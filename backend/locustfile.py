from locust import HttpUser, task, between

class LabourConnectUser(HttpUser):
    wait_time = between(1, 3)  # simulates real users pausing between actions

    @task(3)
    def check_wage(self):
        self.client.post("/check_wage", json={
            "skill": "Mason",
            "location": "Mangalore",
            "offered_wage": 500
        })

    @task(1)
    def chat(self):
        self.client.post("/chat", json={
            "message": "Are there mason jobs near me?",
            "language": "English",
            "worker_phone": ""
        })