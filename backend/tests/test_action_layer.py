import uuid
import time
import requests
from datetime import datetime, timezone

def test_job_posted_action(db, base_url):
    # 1. Set up a fake job in Firestore
    job_id = f"test_job_{uuid.uuid4().hex[:8]}"
    contractor_phone = "9999999999"

    db.collection("jobs").document(job_id).set({
        "title": "Test Plumbing Job",
        "contractorPhone": contractor_phone,
        "status": "open",
    })

    try:
        # 2. Call the actual endpoint
        response = requests.post(
            f"{base_url}/actions/job-posted",
            json={"jobId": job_id}
        )

        # 3. Check the HTTP response
        assert response.status_code == 200
        body = response.json()
        assert body["success"] is True

        # 4. Verify a notification was actually created in Firestore
        notifications = db.collection("notifications") \
            .where("jobId", "==", job_id) \
            .where("type", "==", "job_posted_confirmation") \
            .stream()
        notif_list = list(notifications)
        assert len(notif_list) == 1
        assert notif_list[0].to_dict()["workerPhone"] == contractor_phone

    finally:
        # 5. Clean up — delete test job and any notifications created
        db.collection("jobs").document(job_id).delete()
        for notif in db.collection("notifications").where("jobId", "==", job_id).stream():
            notif.reference.delete()


def test_payment_received_action(db, base_url):
    job_id = f"test_job_{uuid.uuid4().hex[:8]}"
    application_id = f"test_app_{uuid.uuid4().hex[:8]}"
    real_contractor_phone = "9999999999"
    worker_phone = "8888888888"

    db.collection("jobs").document(job_id).set({
        "title": "Test Wiring Job",
        "contractorPhone": real_contractor_phone,
        "status": "open",
    })

    db.collection("applications").document(application_id).set({
        "jobId": job_id,
        "jobTitle": "Test Wiring Job",
        "workerPhone": worker_phone,
        "status": "completed",
        "paid": False,
    })

    try:
        # Case 1: wrong contractor should be rejected
        wrong_response = requests.post(
            f"{base_url}/actions/payment-received",
            json={"applicationId": application_id, "contractorPhone": "0000000000"}
        )
        assert wrong_response.status_code == 403
        assert wrong_response.json()["success"] is False

        # Case 2: correct contractor should succeed
        correct_response = requests.post(
            f"{base_url}/actions/payment-received",
            json={"applicationId": application_id, "contractorPhone": real_contractor_phone}
        )
        assert correct_response.status_code == 200
        assert correct_response.json()["success"] is True

        # Verify Firestore was actually updated
        updated_app = db.collection("applications").document(application_id).get().to_dict()
        assert updated_app["paid"] is True

        # Verify notification was created for the worker
        notifications = list(
            db.collection("notifications")
            .where("jobId", "==", job_id)
            .where("type", "==", "payment_received")
            .stream()
        )
        assert len(notifications) == 1
        assert notifications[0].to_dict()["workerPhone"] == worker_phone

        # Case 3: calling it again should fail (already paid)
        repeat_response = requests.post(
            f"{base_url}/actions/payment-received",
            json={"applicationId": application_id, "contractorPhone": real_contractor_phone}
        )
        assert repeat_response.status_code == 400

    finally:
        db.collection("jobs").document(job_id).delete()
        db.collection("applications").document(application_id).delete()
        for notif in db.collection("notifications").where("jobId", "==", job_id).stream():
            notif.reference.delete()


def test_remove_job_action(db, base_url):
    job_id = f"test_job_{uuid.uuid4().hex[:8]}"
    application_id = f"test_app_{uuid.uuid4().hex[:8]}"
    report_id = f"test_report_{uuid.uuid4().hex[:8]}"
    worker_phone = "7777777777"

    db.collection("jobs").document(job_id).set({
        "title": "Test Removable Job",
        "contractorPhone": "9999999999",
        "status": "open",
    })

    # An affected, non-completed application — should get notified
    db.collection("applications").document(application_id).set({
        "jobId": job_id,
        "jobTitle": "Test Removable Job",
        "workerPhone": worker_phone,
        "status": "applied",
    })

    db.collection("reports").document(report_id).set({
        "jobId": job_id,
        "jobTitle": "Test Removable Job",
        "reason": "test reason",
        "reviewedByAdmin": False,
    })

    try:
        response = requests.post(
            f"{base_url}/actions/remove-job",
            json={"jobId": job_id, "reportId": report_id}
        )
        assert response.status_code == 200
        body = response.json()
        assert body["success"] is True
        assert body["notified_count"] == 1

        # Job status should now be "removed"
        updated_job = db.collection("jobs").document(job_id).get().to_dict()
        assert updated_job["status"] == "removed"

        # Report should be marked reviewed
        updated_report = db.collection("reports").document(report_id).get().to_dict()
        assert updated_report["reviewedByAdmin"] is True

        # Worker should have been notified
        notifications = list(
            db.collection("notifications")
            .where("jobId", "==", job_id)
            .where("type", "==", "job_removed")
            .stream()
        )
        assert len(notifications) == 1
        assert notifications[0].to_dict()["workerPhone"] == worker_phone

    finally:
        db.collection("jobs").document(job_id).delete()
        db.collection("applications").document(application_id).delete()
        db.collection("reports").document(report_id).delete()
        for notif in db.collection("notifications").where("jobId", "==", job_id).stream():
            notif.reference.delete()


def test_report_submitted_action(db, base_url):
    report_id = f"test_report_{uuid.uuid4().hex[:8]}"
    ADMIN_PHONE = "1234567890"

    db.collection("reports").document(report_id).set({
        "jobTitle": "Test Reported Job",
        "reason": "test fraud reason",
        "alertSent": False,
    })

    try:
        # First call should send the alert
        response = requests.post(
            f"{base_url}/actions/report-submitted",
            json={"reportId": report_id}
        )
        assert response.status_code == 200
        assert response.json()["success"] is True

        updated_report = db.collection("reports").document(report_id).get().to_dict()
        assert updated_report["alertSent"] is True

        notifications = list(
            db.collection("notifications")
            .where("reportId", "==", report_id)
            .where("type", "==", "fraud_alert")
            .stream()
        )
        assert len(notifications) == 1
        assert notifications[0].to_dict()["workerPhone"] == ADMIN_PHONE

        # Second call should NOT send a duplicate alert
        repeat_response = requests.post(
            f"{base_url}/actions/report-submitted",
            json={"reportId": report_id}
        )
        assert repeat_response.status_code == 200
        assert repeat_response.json()["message"] == "Alert already sent for this report"

        notifications_after = list(
            db.collection("notifications")
            .where("reportId", "==", report_id)
            .where("type", "==", "fraud_alert")
            .stream()
        )
        assert len(notifications_after) == 1  # still just 1, not 2

    finally:
        db.collection("reports").document(report_id).delete()
        for notif in db.collection("notifications").where("reportId", "==", report_id).stream():
            notif.reference.delete()            

def test_register_complete_action(db, base_url):
    worker_phone = f"70000{uuid.uuid4().hex[:5]}"
    contractor_phone = f"71111{uuid.uuid4().hex[:5]}"

    try:
        # Worker registration
        worker_response = requests.post(
            f"{base_url}/actions/register-complete",
            json={"phone": worker_phone, "name": "Test Worker", "role": "worker"}
        )
        assert worker_response.status_code == 200
        assert worker_response.json()["success"] is True

        worker_notifs = list(
            db.collection("notifications")
            .where("workerPhone", "==", worker_phone)
            .where("type", "==", "welcome")
            .stream()
        )
        assert len(worker_notifs) == 1
        assert "Browse jobs" in worker_notifs[0].to_dict()["message"]

        # Contractor registration
        contractor_response = requests.post(
            f"{base_url}/actions/register-complete",
            json={"phone": contractor_phone, "name": "Test Contractor", "role": "contractor"}
        )
        assert contractor_response.status_code == 200

        contractor_notifs = list(
            db.collection("notifications")
            .where("workerPhone", "==", contractor_phone)
            .where("type", "==", "welcome")
            .stream()
        )
        assert len(contractor_notifs) == 1
        assert "Post your first job" in contractor_notifs[0].to_dict()["message"]

        # Invalid role should be rejected
        bad_response = requests.post(
            f"{base_url}/actions/register-complete",
            json={"phone": "7222222222", "name": "Bad Role", "role": "admin"}
        )
        assert bad_response.status_code == 400

    finally:
        for notif in db.collection("notifications").where("workerPhone", "==", worker_phone).stream():
            notif.reference.delete()
        for notif in db.collection("notifications").where("workerPhone", "==", contractor_phone).stream():
            notif.reference.delete()


def test_application_decision_action(db, base_url):
    job_id = f"test_job_{uuid.uuid4().hex[:8]}"
    accepted_app_id = f"test_app_{uuid.uuid4().hex[:8]}"
    rejected_app_id = f"test_app_{uuid.uuid4().hex[:8]}"
    real_contractor_phone = "9999999999"
    worker_phone = "6666666666"

    db.collection("jobs").document(job_id).set({
        "title": "Test Decision Job",
        "contractorPhone": real_contractor_phone,
        "status": "open",
    })

    db.collection("applications").document(accepted_app_id).set({
        "jobId": job_id,
        "jobTitle": "Test Decision Job",
        "workerPhone": worker_phone,
        "status": "applied",
    })

    db.collection("applications").document(rejected_app_id).set({
        "jobId": job_id,
        "jobTitle": "Test Decision Job",
        "workerPhone": worker_phone,
        "status": "applied",
    })

    try:
        wrong_response = requests.post(
            f"{base_url}/actions/application-decision",
            json={"applicationId": accepted_app_id, "decision": "accepted", "contractorPhone": "0000000000"}
        )
        assert wrong_response.status_code == 403

        accept_response = requests.post(
            f"{base_url}/actions/application-decision",
            json={"applicationId": accepted_app_id, "decision": "accepted", "contractorPhone": real_contractor_phone}
        )
        assert accept_response.status_code == 200
        updated_accept = db.collection("applications").document(accepted_app_id).get().to_dict()
        assert updated_accept["status"] == "accepted"

        reject_response = requests.post(
            f"{base_url}/actions/application-decision",
            json={"applicationId": rejected_app_id, "decision": "rejected", "contractorPhone": real_contractor_phone}
        )
        assert reject_response.status_code == 200
        updated_reject = db.collection("applications").document(rejected_app_id).get().to_dict()
        assert updated_reject["status"] == "rejected"

        notifs = list(
            db.collection("notifications")
            .where("jobId", "==", job_id)
            .where("type", "==", "application_decision")
            .stream()
        )
        assert len(notifs) == 2
        messages = [n.to_dict()["message"] for n in notifs]
        assert any("accepted" in m for m in messages)
        assert any("not selected" in m for m in messages)

    finally:
        db.collection("jobs").document(job_id).delete()
        db.collection("applications").document(accepted_app_id).delete()
        db.collection("applications").document(rejected_app_id).delete()
        for notif in db.collection("notifications").where("jobId", "==", job_id).stream():
            notif.reference.delete()



def test_kyc_decision_action(db, base_url):
    verified_worker_id = f"test_worker_{uuid.uuid4().hex[:8]}"
    flagged_worker_id = f"test_worker_{uuid.uuid4().hex[:8]}"
    phone_verified = "5555555555"
    phone_flagged = "4444444444"

    db.collection("workers").document(verified_worker_id).set({
        "name": "Test Verify Worker",
        "phone": phone_verified,
        "kycStatus": "pending_review",
    })

    db.collection("workers").document(flagged_worker_id).set({
        "name": "Test Flag Worker",
        "phone": phone_flagged,
        "kycStatus": "pending_review",
    })

    try:
        verify_response = requests.post(
            f"{base_url}/actions/kyc-decision",
            json={"collection": "workers", "docId": verified_worker_id, "decision": "verified"}
        )
        assert verify_response.status_code == 200
        updated_verified = db.collection("workers").document(verified_worker_id).get().to_dict()
        assert updated_verified["kycStatus"] == "verified"

        flag_response = requests.post(
            f"{base_url}/actions/kyc-decision",
            json={"collection": "workers", "docId": flagged_worker_id, "decision": "flagged"}
        )
        assert flag_response.status_code == 200
        updated_flagged = db.collection("workers").document(flagged_worker_id).get().to_dict()
        assert updated_flagged["kycStatus"] == "flagged"

        # Invalid collection should be rejected
        bad_response = requests.post(
            f"{base_url}/actions/kyc-decision",
            json={"collection": "admins", "docId": verified_worker_id, "decision": "verified"}
        )
        assert bad_response.status_code == 400

        # Verify both got their respective notifications
        notifs_verified = list(
            db.collection("notifications")
            .where("workerPhone", "==", phone_verified)
            .where("type", "==", "kyc_update")
            .stream()
        )
        assert len(notifs_verified) == 1
        assert "verified" in notifs_verified[0].to_dict()["message"]

        notifs_flagged = list(
            db.collection("notifications")
            .where("workerPhone", "==", phone_flagged)
            .where("type", "==", "kyc_update")
            .stream()
        )
        assert len(notifs_flagged) == 1
        assert "flagged" in notifs_flagged[0].to_dict()["message"]

    finally:
        db.collection("workers").document(verified_worker_id).delete()
        db.collection("workers").document(flagged_worker_id).delete()
        for notif in db.collection("notifications").where("workerPhone", "==", phone_verified).stream():
            notif.reference.delete()
        for notif in db.collection("notifications").where("workerPhone", "==", phone_flagged).stream():
            notif.reference.delete()


def test_register_device_token_action(db, base_url):
    worker_id = f"test_worker_{uuid.uuid4().hex[:8]}"
    phone = "3333333333"
    fake_token = "fake_fcm_token_12345"

    db.collection("workers").document(worker_id).set({
        "name": "Test Token Worker",
        "phone": phone,
    })

    try:
        # Success case — matching phone found
        response = requests.post(
            f"{base_url}/actions/register-device-token",
            json={"phone": phone, "fcmToken": fake_token}
        )
        assert response.status_code == 200
        assert response.json()["success"] is True

        updated_worker = db.collection("workers").document(worker_id).get().to_dict()
        assert updated_worker["fcmToken"] == fake_token

        # No matching phone should 404
        not_found_response = requests.post(
            f"{base_url}/actions/register-device-token",
            json={"phone": "0000000000", "fcmToken": fake_token}
        )
        assert not_found_response.status_code == 404

        # Missing fields should 400
        bad_response = requests.post(
            f"{base_url}/actions/register-device-token",
            json={"phone": phone}
        )
        assert bad_response.status_code == 400

    finally:
        db.collection("workers").document(worker_id).delete()            
