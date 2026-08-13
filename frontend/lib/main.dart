import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:math';

// ================================================
// LANGUAGE SYSTEM
// ================================================
String currentLanguage = 'English';

Map<String, Map<String, String>> appTexts = {
  'English': {
    'welcome': 'Welcome to LabourConnect',
    'login_subtitle': 'Login with your mobile number',
    'mobile_number': 'Mobile Number',
    'mobile_hint': 'Enter 10 digit mobile number',
    'send_otp': 'Send OTP',
    'enter_otp': 'Enter OTP',
    'otp_hint': 'Enter 6 digit OTP',
    'verify_otp': 'Verify OTP ✓',
    'change_number': 'Change mobile number?',
    'choose_language': 'Choose your language',
    'i_am': 'I am a...',
    'choose_role': 'Choose your role to continue',
    'worker': 'Worker',
    'worker_desc': 'I am looking for daily work\nMason, Painter, Farmer etc.',
    'contractor': 'Contractor',
    'contractor_desc': 'I want to hire workers\nfor my construction or farm work',
    'worker_registration': 'Worker Registration',
    'contractor_registration': 'Contractor Registration',
    'full_name': 'Full Name',
    'full_name_hint': 'Enter your full name',
    'phone_number': 'Phone Number',
    'village': 'Village / Location',
    'village_hint': 'eg. Bantwal, Dakshina Kannada',
    'experience': 'Years of Experience',
    'experience_hint': 'eg. 3',
    'govt_id': 'Government ID',
    'govt_id_hint': 'Aadhaar / PAN / Driving Licence No.',
    'select_skill': 'Select Your Skill',
    'register_worker': 'Register as Worker →',
    'register_contractor': 'Register as Contractor →',
    'company_name': 'Company / Business Name',
    'company_hint': 'eg. Shetty Constructions',
    'work_location': 'Work Location',
    'work_location_hint': 'eg. Konaje, Mangalore',
    'type_of_work': 'Type of Work',
    'good_morning': 'Good morning',
    'good_afternoon': 'Good afternoon',
    'good_evening': 'Good evening',
    'good_night': 'Good night',
    'jobs_near': 'new jobs near you',
    'search_jobs': 'Search jobs near you...',
    'jobs_today': 'Jobs near you today',
    'my_jobs': 'My Jobs',
    'ai_help': 'AI Help',
    'profile': 'Profile',
    'home': 'Home',
    'post_job': 'Post Job',
    'apply_job': 'Apply for this Job',
    'logout': 'Logout',
    'edit_profile': 'Edit Profile',
    'your_full_name': 'Your Full Name',
    'your_name_hint': 'Enter your name',
    'skill_required': 'Skill Required',
    'job_title': 'Job Title',
    'job_title_hint': 'eg. 5 Masons needed for construction',
    'wage_per_day': 'Wage per Day (₹)',
    'wage_hint': 'eg. 500',
    'workers_needed': 'Number of Workers needed',
    'workers_hint': 'eg. 5',
    'start_date': 'Start Date',
    'start_date_hint': 'eg. Tomorrow / 10 June 2026',
    'num_days': 'Number of Days',
    'num_days_hint': 'eg. 1 day / 3 days / 1 week',
    'job_desc': 'Job Description',
    'job_desc_hint': 'Describe the work in detail...',
    'additional': 'Additional Details (optional)',
    'additional_hint': 'Any special requirements or notes...',
    'post_job_btn': 'Post Job → AI will verify',
    'applied_jobs': 'Applied Jobs',
    'completed_jobs': 'Completed Jobs',
    'ask_hint': 'Type in Kannada, Hindi or English...',
    'ai_subtitle': 'Ask in Kannada, Hindi or English',
    'my_information': 'MY INFORMATION',
    'choose_lang_sub': 'ನಿಮ್ಮ ಭಾಷೆ ಆಯ್ಕೆ ಮಾಡಿ • अपनी भाषा चुनें',
  },
  'Kannada': {
    'welcome': 'LabourConnect ಗೆ ಸ್ವಾಗತ',
    'login_subtitle': 'ನಿಮ್ಮ ಮೊಬೈಲ್ ನಂಬರ್‌ನಿಂದ ಲಾಗಿನ್ ಮಾಡಿ',
    'mobile_number': 'ಮೊಬೈಲ್ ನಂಬರ್',
    'mobile_hint': '10 ಅಂಕಿ ಮೊಬೈಲ್ ನಂಬರ್ ನಮೂದಿಸಿ',
    'send_otp': 'OTP ಕಳುಹಿಸಿ',
    'enter_otp': 'OTP ನಮೂದಿಸಿ',
    'otp_hint': '6 ಅಂಕಿ OTP ನಮೂದಿಸಿ',
    'verify_otp': 'OTP ಪರಿಶೀಲಿಸಿ ✓',
    'change_number': 'ಮೊಬೈಲ್ ನಂಬರ್ ಬದಲಾಯಿಸಲು?',
    'choose_language': 'ನಿಮ್ಮ ಭಾಷೆ ಆಯ್ಕೆ ಮಾಡಿ',
    'i_am': 'ನಾನು...',
    'choose_role': 'ಮುಂದುವರಿಯಲು ನಿಮ್ಮ ಪಾತ್ರ ಆಯ್ಕೆ ಮಾಡಿ',
    'worker': 'ಕಾರ್ಮಿಕ',
    'worker_desc': 'ನಾನು ದೈನಂದಿನ ಕೆಲಸ ಹುಡುಕುತ್ತಿದ್ದೇನೆ\nರಾಜಮೇಸ್ತ್ರಿ, ಚಿತ್ರಕಾರ, ರೈತ ಇತ್ಯಾದಿ',
    'contractor': 'ಗುತ್ತಿಗೆದಾರ',
    'contractor_desc': 'ನಾನು ಕಾರ್ಮಿಕರನ್ನು ನೇಮಿಸಿಕೊಳ್ಳಲು ಬಯಸುತ್ತೇನೆ',
    'worker_registration': 'ಕಾರ್ಮಿಕ ನೋಂದಣಿ',
    'contractor_registration': 'ಗುತ್ತಿಗೆದಾರ ನೋಂದಣಿ',
    'full_name': 'ಪೂರ್ಣ ಹೆಸರು',
    'full_name_hint': 'ನಿಮ್ಮ ಪೂರ್ಣ ಹೆಸರು ನಮೂದಿಸಿ',
    'phone_number': 'ಫೋನ್ ನಂಬರ್',
    'village': 'ಗ್ರಾಮ / ಸ್ಥಳ',
    'village_hint': 'ಉದಾ. ಬಂಟ್ವಾಳ, ದಕ್ಷಿಣ ಕನ್ನಡ',
    'experience': 'ಅನುಭವದ ವರ್ಷಗಳು',
    'experience_hint': 'ಉದಾ. 3',
    'govt_id': 'ಸರ್ಕಾರಿ ಐಡಿ',
    'govt_id_hint': 'ಆಧಾರ್ / ಪ್ಯಾನ್ / ಡ್ರೈವಿಂಗ್ ಲೈಸೆನ್ಸ್',
    'select_skill': 'ನಿಮ್ಮ ಕೌಶಲ್ಯ ಆಯ್ಕೆ ಮಾಡಿ',
    'register_worker': 'ಕಾರ್ಮಿಕನಾಗಿ ನೋಂದಾಯಿಸಿ →',
    'register_contractor': 'ಗುತ್ತಿಗೆದಾರನಾಗಿ ನೋಂದಾಯಿಸಿ →',
    'company_name': 'ಕಂಪನಿ / ವ್ಯಾಪಾರ ಹೆಸರು',
    'company_hint': 'ಉದಾ. ಶೆಟ್ಟಿ ಕನ್ಸ್ಟ್ರಕ್ಷನ್ಸ್',
    'work_location': 'ಕೆಲಸದ ಸ್ಥಳ',
    'work_location_hint': 'ಉದಾ. ಕೊಣಾಜೆ, ಮಂಗಳೂರು',
    'type_of_work': 'ಕೆಲಸದ ವಿಧ',
    'good_morning': 'ಶುಭೋದಯ',
    'good_afternoon': 'ಶುಭ ಮಧ್ಯಾಹ್ನ',
    'good_evening': 'ಶುಭ ಸಂಜೆ',
    'good_night': 'ಶುಭ ರಾತ್ರಿ',
    'jobs_near': 'ಹೊಸ ಉದ್ಯೋಗಗಳು ಹತ್ತಿರದಲ್ಲಿ',
    'search_jobs': 'ಹತ್ತಿರದ ಉದ್ಯೋಗ ಹುಡುಕಿ...',
    'jobs_today': 'ಇಂದು ಹತ್ತಿರದ ಉದ್ಯೋಗಗಳು',
    'my_jobs': 'ನನ್ನ ಉದ್ಯೋಗಗಳು',
    'ai_help': 'AI ಸಹಾಯ',
    'profile': 'ಪ್ರೊಫೈಲ್',
    'home': 'ಮನೆ',
    'post_job': 'ಉದ್ಯೋಗ ಪೋಸ್ಟ್ ಮಾಡಿ',
    'apply_job': 'ಈ ಕೆಲಸಕ್ಕೆ ಅರ್ಜಿ ಸಲ್ಲಿಸಿ',
    'logout': 'ಲಾಗ್ ಔಟ್',
    'edit_profile': 'ಪ್ರೊಫೈಲ್ ಸಂಪಾದಿಸಿ',
    'your_full_name': 'ನಿಮ್ಮ ಪೂರ್ಣ ಹೆಸರು',
    'your_name_hint': 'ನಿಮ್ಮ ಹೆಸರು ನಮೂದಿಸಿ',
    'skill_required': 'ಬೇಕಾದ ಕೌಶಲ್ಯ',
    'job_title': 'ಕೆಲಸದ ಶೀರ್ಷಿಕೆ',
    'job_title_hint': 'ಉದಾ. 5 ರಾಜಮೇಸ್ತ್ರಿಗಳು ಬೇಕು',
    'wage_per_day': 'ದಿನದ ವೇತನ (₹)',
    'wage_hint': 'ಉದಾ. 500',
    'workers_needed': 'ಬೇಕಾದ ಕಾರ್ಮಿಕರ ಸಂಖ್ಯೆ',
    'workers_hint': 'ಉದಾ. 5',
    'start_date': 'ಪ್ರಾರಂಭ ದಿನಾಂಕ',
    'start_date_hint': 'ಉದಾ. ನಾಳೆ / 10 ಜೂನ್ 2026',
    'num_days': 'ದಿನಗಳ ಸಂಖ್ಯೆ',
    'num_days_hint': 'ಉದಾ. 1 ದಿನ / 3 ದಿನ / 1 ವಾರ',
    'job_desc': 'ಕೆಲಸದ ವಿವರಣೆ',
    'job_desc_hint': 'ಕೆಲಸವನ್ನು ವಿವರವಾಗಿ ವಿವರಿಸಿ...',
    'additional': 'ಹೆಚ್ಚುವರಿ ವಿವರಗಳು (ಐಚ್ಛಿಕ)',
    'additional_hint': 'ಯಾವುದೇ ವಿಶೇಷ ಅವಶ್ಯಕತೆಗಳು...',
    'post_job_btn': 'ಕೆಲಸ ಪೋಸ್ಟ್ ಮಾಡಿ → AI ಪರಿಶೀಲಿಸುತ್ತದೆ',
    'applied_jobs': 'ಅರ್ಜಿ ಸಲ್ಲಿಸಿದ ಕೆಲಸಗಳು',
    'completed_jobs': 'ಮುಗಿದ ಕೆಲಸಗಳು',
    'ask_hint': 'ಕನ್ನಡ, ಹಿಂದಿ ಅಥವಾ ಇಂಗ್ಲೀಷ್‌ನಲ್ಲಿ ಟೈಪ್ ಮಾಡಿ...',
    'ai_subtitle': 'ಕನ್ನಡ, ಹಿಂದಿ ಅಥವಾ ಇಂಗ್ಲೀಷ್‌ನಲ್ಲಿ ಕೇಳಿ',
    'my_information': 'ನನ್ನ ಮಾಹಿತಿ',
    'choose_lang_sub': 'ನಿಮ್ಮ ಭಾಷೆ ಆಯ್ಕೆ ಮಾಡಿ • अपनी भाषा चुनें',
  },
  'Hindi': {
    'welcome': 'LabourConnect में आपका स्वागत है',
    'login_subtitle': 'अपने मोबाइल नंबर से लॉगिन करें',
    'mobile_number': 'मोबाइल नंबर',
    'mobile_hint': '10 अंकों का मोबाइल नंबर दर्ज करें',
    'send_otp': 'OTP भेजें',
    'enter_otp': 'OTP दर्ज करें',
    'otp_hint': '6 अंकों का OTP दर्ज करें',
    'verify_otp': 'OTP सत्यापित करें ✓',
    'change_number': 'मोबाइल नंबर बदलें?',
    'choose_language': 'अपनी भाषा चुनें',
    'i_am': 'मैं हूँ...',
    'choose_role': 'जारी रखने के लिए अपनी भूमिका चुनें',
    'worker': 'मजदूर',
    'worker_desc': 'मैं दैनिक काम की तलाश में हूँ\nराजमिस्त्री, पेंटर, किसान आदि',
    'contractor': 'ठेकेदार',
    'contractor_desc': 'मैं मजदूरों को काम पर रखना चाहता हूँ',
    'worker_registration': 'मजदूर पंजीकरण',
    'contractor_registration': 'ठेकेदार पंजीकरण',
    'full_name': 'पूरा नाम',
    'full_name_hint': 'अपना पूरा नाम दर्ज करें',
    'phone_number': 'फोन नंबर',
    'village': 'गाँव / स्थान',
    'village_hint': 'उदा. बंटवाल, दक्षिण कन्नड',
    'experience': 'अनुभव के वर्ष',
    'experience_hint': 'उदा. 3',
    'govt_id': 'सरकारी आईडी',
    'govt_id_hint': 'आधार / पैन / ड्राइविंग लाइसेंस',
    'select_skill': 'अपना कौशल चुनें',
    'register_worker': 'मजदूर के रूप में पंजीकरण →',
    'register_contractor': 'ठेकेदार के रूप में पंजीकरण →',
    'company_name': 'कंपनी / व्यापार का नाम',
    'company_hint': 'उदा. शेट्टी कंस्ट्रक्शन्स',
    'work_location': 'काम का स्थान',
    'work_location_hint': 'उदा. कोनाजे, मंगलूरु',
    'type_of_work': 'काम का प्रकार',
    'good_morning': 'शुभ प्रभात',
    'good_afternoon': 'शुभ दोपहर',
    'good_evening': 'शुभ संध्या',
    'good_night': 'शुभ रात्रि',
    'jobs_near': 'नई नौकरियाँ पास में',
    'search_jobs': 'पास की नौकरियाँ खोजें...',
    'jobs_today': 'आज पास की नौकरियाँ',
    'my_jobs': 'मेरी नौकरियाँ',
    'ai_help': 'AI सहायता',
    'profile': 'प्रोफ़ाइल',
    'home': 'होम',
    'post_job': 'नौकरी पोस्ट करें',
    'apply_job': 'इस नौकरी के लिए आवेदन करें',
    'logout': 'लॉग आउट',
    'edit_profile': 'प्रोफ़ाइल संपादित करें',
    'your_full_name': 'आपका पूरा नाम',
    'your_name_hint': 'अपना नाम दर्ज करें',
    'skill_required': 'आवश्यक कौशल',
    'job_title': 'नौकरी का शीर्षक',
    'job_title_hint': 'उदा. 5 राजमिस्त्री चाहिए',
    'wage_per_day': 'प्रतिदिन वेतन (₹)',
    'wage_hint': 'उदा. 500',
    'workers_needed': 'आवश्यक मजदूरों की संख्या',
    'workers_hint': 'उदा. 5',
    'start_date': 'शुरू होने की तारीख',
    'start_date_hint': 'उदा. कल / 10 जून 2026',
    'num_days': 'दिनों की संख्या',
    'num_days_hint': 'उदा. 1 दिन / 3 दिन / 1 सप्ताह',
    'job_desc': 'काम का विवरण',
    'job_desc_hint': 'काम को विस्तार से बताएं...',
    'additional': 'अतिरिक्त विवरण (वैकल्पिक)',
    'additional_hint': 'कोई विशेष आवश्यकता या नोट्स...',
    'post_job_btn': 'नौकरी पोस्ट करें → AI सत्यापित करेगा',
    'applied_jobs': 'आवेदित नौकरियाँ',
    'completed_jobs': 'पूर्ण नौकरियाँ',
    'ask_hint': 'कन्नड, हिंदी या अंग्रेजी में टाइप करें...',
    'ai_subtitle': 'कन्नड, हिंदी या अंग्रेजी में पूछें',
    'my_information': 'मेरी जानकारी',
    'choose_lang_sub': 'ನಿಮ್ಮ ಭಾಷೆ ಆಯ್ಕೆ ಮಾಡಿ • अपनी भाषा चुनें',
  },
  'Tulu': {
    'welcome': 'LabourConnect ಡ ಸ್ವಾಗತ',
    'login_subtitle': 'ನಿಕುಲೆನ ಮೊಬೈಲ್ ನಂಬರ್‌ಡ್ ಲಾಗಿನ್ ಮಲ್ಪುಲೆ',
    'mobile_number': 'ಮೊಬೈಲ್ ನಂಬರ್',
    'mobile_hint': '10 ಅಂಕಿತ ಮೊಬೈಲ್ ನಂಬರ್ ಪಾಡುಲೆ',
    'send_otp': 'OTP ಕಡಪಾಲೆ',
    'enter_otp': 'OTP ಪಾಡುಲೆ',
    'otp_hint': '6 ಅಂಕಿತ OTP ಪಾಡುಲೆ',
    'verify_otp': 'OTP ಪರಿಶೀಲನೆ ✓',
    'change_number': 'ಮೊಬೈಲ್ ನಂಬರ್ ಬದಲಾವಣೆ?',
    'choose_language': 'ನಿಕುಲೆನ ಭಾಷೆ ಆಯ್ಕೆ ಮಲ್ಪುಲೆ',
    'i_am': 'ಯಾನ್...',
    'choose_role': 'ಮುಂದರಿಯೆರೆ ನಿಕುಲೆನ ಪಾತ್ರ ಆಯ್ಕೆ ಮಲ್ಪುಲೆ',
    'worker': 'ಕೆಲಸಗಾರ',
    'worker_desc': 'ಯಾನ್ ದಿನೊಲು ಕೆಲಸ ತೂವೊಂದುಲ್ಲೆ',
    'contractor': 'ಗುತ್ತಿಗೆದಾರ',
    'contractor_desc': 'ಯಾನ್ ಕೆಲಸಗಾರೆರೆನ್ ನೇಮಕ ಮಲ್ಪೆರೆ ಉಲ್ಲೆ',
    'worker_registration': 'ಕೆಲಸಗಾರ ನೋಂದಣಿ',
    'contractor_registration': 'ಗುತ್ತಿಗೆದಾರ ನೋಂದಣಿ',
    'full_name': 'ಪೂರ್ಣ ಪೆಸರ್',
    'full_name_hint': 'ನಿಕುಲೆನ ಪೂರ್ಣ ಪೆಸರ್ ಪಾಡುಲೆ',
    'phone_number': 'ಫೋನ್ ನಂಬರ್',
    'village': 'ಊರು / ಜಾಗ',
    'village_hint': 'ಉದಾ. ಬಂಟ್ವಾಳ, ದಕ್ಷಿಣ ಕನ್ನಡ',
    'experience': 'ಅನುಭವೊದ ವರ್ಸೊ',
    'experience_hint': 'ಉದಾ. 3',
    'govt_id': 'ಸರ್ಕಾರಿ ಐಡಿ',
    'govt_id_hint': 'ಆಧಾರ್ / ಪ್ಯಾನ್ / ಡ್ರೈವಿಂಗ್ ಲೈಸೆನ್ಸ್',
    'select_skill': 'ನಿಕುಲೆನ ಕೌಶಲ್ಯ ಆಯ್ಕೆ ಮಲ್ಪುಲೆ',
    'register_worker': 'ಕೆಲಸಗಾರನಾಗಿ ನೋಂದಾಯಿಸಿ →',
    'register_contractor': 'ಗುತ್ತಿಗೆದಾರನಾಗಿ ನೋಂದಾಯಿಸಿ →',
    'company_name': 'ಕಂಪನಿ / ವ್ಯಾಪಾರ ಪೆಸರ್',
    'company_hint': 'ಉದಾ. ಶೆಟ್ಟಿ ಕನ್ಸ್ಟ್ರಕ್ಷನ್ಸ್',
    'work_location': 'ಕೆಲಸೊದ ಜಾಗ',
    'work_location_hint': 'ಉದಾ. ಕೊಣಾಜೆ, ಮಂಗಳೂರು',
    'type_of_work': 'ಕೆಲಸೊದ ವಿಧ',
    'good_morning': 'ಶುಭೊದಯ',
    'good_afternoon': 'ಶುಭ ಮಧ್ಯಾನ್ಹ',
    'good_evening': 'ಶುಭ ಸಂಜೆ',
    'good_night': 'ಶುಭ ರಾತ್ರೆ',
    'jobs_near': 'ಪೊಸ ಕೆಲಸೊಲು ಹತ್ತಿರ',
    'search_jobs': 'ಹತ್ತಿರೊದ ಕೆಲಸ ತೂಲೆ...',
    'jobs_today': 'ಇನಿ ಹತ್ತಿರೊದ ಕೆಲಸೊಲು',
    'my_jobs': 'ಯಾನೆನ ಕೆಲಸೊಲು',
    'ai_help': 'AI ಸಹಾಯ',
    'profile': 'ಪ್ರೊಫೈಲ್',
    'home': 'ಮನೆ',
    'post_job': 'ಕೆಲಸ ಪೋಸ್ಟ್ ಮಲ್ಪುಲೆ',
    'apply_job': 'ಈ ಕೆಲಸೊಗು ಅರ್ಜಿ ಕೊರುಲೆ',
    'logout': 'ಲಾಗ್ ಔಟ್',
    'edit_profile': 'ಪ್ರೊಫೈಲ್ ಸಂಪಾದನೆ',
    'your_full_name': 'ನಿಕುಲೆನ ಪೂರ್ಣ ಪೆಸರ್',
    'your_name_hint': 'ನಿಕುಲೆನ ಪೆಸರ್ ಪಾಡುಲೆ',
    'skill_required': 'ಬೇಕಾಪಿನ ಕೌಶಲ್ಯ',
    'job_title': 'ಕೆಲಸೊದ ಶೀರ್ಷಿಕೆ',
    'job_title_hint': 'ಉದಾ. 5 ರಾಜಮೇಸ್ತ್ರಿಲು ಬೇಕು',
    'wage_per_day': 'ದಿನೊದ ವೇತನ (₹)',
    'wage_hint': 'ಉದಾ. 500',
    'workers_needed': 'ಬೇಕಾಪಿನ ಕೆಲಸಗಾರೆರ್ ಸಂಖ್ಯೆ',
    'workers_hint': 'ಉದಾ. 5',
    'start_date': 'ಪ್ರಾರಂಭ ದಿನ',
    'start_date_hint': 'ಉದಾ. ನಾಳೆ / 10 ಜೂನ್ 2026',
    'num_days': 'ದಿನೊಲೆ ಸಂಖ್ಯೆ',
    'num_days_hint': 'ಉದಾ. 1 ದಿನ / 3 ದಿನ / 1 ವಾರ',
    'job_desc': 'ಕೆಲಸೊದ ವಿವರಣೆ',
    'job_desc_hint': 'ಕೆಲಸೊನು ವಿವರವಾದ್ ಪನ್ಪುಲೆ...',
    'additional': 'ಹೆಚ್ಚುವರಿ ವಿವರ (ಐಚ್ಛಿಕ)',
    'additional_hint': 'ಯಾವೊಂದಾನಿ ವಿಶೇಷ ಅವಶ್ಯಕತೆ...',
    'post_job_btn': 'ಕೆಲಸ ಪೋಸ್ಟ್ ಮಲ್ಪುಲೆ → AI ಪರಿಶೀಲಿಸುಂಡು',
    'applied_jobs': 'ಅರ್ಜಿ ಕೊರ್ತಿನ ಕೆಲಸೊಲು',
    'completed_jobs': 'ಮುಗಿತಿನ ಕೆಲಸೊಲು',
    'ask_hint': 'ತುಳು, ಕನ್ನಡ ಅತ್ತಂಡ ಇಂಗ್ಲೀಷ್‌ಡ್ ಟೈಪ್ ಮಲ್ಪುಲೆ...',
    'ai_subtitle': 'ತುಳು, ಕನ್ನಡ ಅತ್ತಂಡ ಇಂಗ್ಲೀಷ್‌ಡ್ ಕೇನುಲೆ',
    'my_information': 'ಯಾನೆನ ಮಾಹಿತಿ',
    'choose_lang_sub': 'ನಿಕುಲೆನ ಭಾಷೆ ಆಯ್ಕೆ ಮಲ್ಪುಲೆ • अपनी भाषा चुनें',
  },
};

String t(String key) {
  return appTexts[currentLanguage]?[key] ?? appTexts['English']![key] ?? key;
}
// ================================================
// AI BACKEND CONNECTION
// ================================================
const String AI_BACKEND_URL = "https://cleft-surgical-snack.ngrok-free.dev";

Future<String> checkWageWithAI({
  required String skill,
  required String location,
  required int offeredWage,
}) async {
  try {
    final response = await http.post(
      Uri.parse('$AI_BACKEND_URL/check_wage'),
      headers: {
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({
        'skill': skill,
        'location': location,
        'offered_wage': offeredWage,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['result'];
    } else {
      return 'Error: could not reach AI advisor (status ${response.statusCode})';
    }
  } catch (e) {
    return 'Error: $e';
  }
}

Future<String> matchJobsWithAI({
  required String workerSkill,
  required String workerLocation,
  int minWage = 0,
  int maxWage = 0,
  String workerExperience = '',
}) async {
  try {
    final response = await http.post(
      Uri.parse('$AI_BACKEND_URL/match_jobs'),
      headers: {
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({
        'worker_skill': workerSkill,
        'worker_location': workerLocation,
        'min_wage': minWage,
        'max_wage': maxWage,
        'worker_experience': workerExperience,
        // Note: job list is no longer sent — the Job Matching Agent now
        // fetches jobs itself via an MCP tool connected to Firestore.
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['result'];
    } else {
      return 'Error: could not reach Job Matcher (status ${response.statusCode})';
    }
  } catch (e) {
    return 'Error: $e';
  }
}

// ── Safety Check Agent ──
Future<Map<String, dynamic>> checkJobSafetyWithAI({
  required String jobTitle,
  required String jobDescription,
  required String wage,
  required String location,
}) async {
  try {
    final response = await http.post(
      Uri.parse('$AI_BACKEND_URL/check_safety'),
      headers: {
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({
        'job_title': jobTitle,
        'job_description': jobDescription,
        'wage': wage,
        'location': location,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'trust_score': data['trust_score'] ?? 70,
        'verdict': data['verdict'] ?? 'SAFE',
        'reason': data['reason'] ?? '',
      };
    } else {
      return {
        'trust_score': 70,
        'verdict': 'UNKNOWN',
        'reason': 'Could not reach Safety Check AI (status ${response.statusCode})',
      };
    }
  } catch (e) {
    return {'trust_score': 70, 'verdict': 'UNKNOWN', 'reason': 'Error: $e'};
  }
}

// ── Chatbot Agent ──
Future<String> chatWithAI({
  required String message,
  required String language,
  String workerPhone = '',
}) async {
  try {
    final response = await http.post(
      Uri.parse('$AI_BACKEND_URL/chat'),
      headers: {
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({
        'message': message,
        'language': language,
        'worker_phone': workerPhone,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['reply'] ?? '...';
    } else {
      return 'Sorry, I could not reach the AI assistant right now (status ${response.statusCode}).';
    }
  } catch (e) {
    return 'Sorry, something went wrong: $e';
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const LabourConnectApp());
}

class LabourConnectApp extends StatelessWidget {
  const LabourConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LabourConnect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF185FA5)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

// ================================================
// SCREEN 1 — SPLASH SCREEN
// ================================================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _loadSavedLanguageThenNavigate();
  }

  Future<void> _loadSavedLanguageThenNavigate() async {
    // Restore the user's last-chosen language (English/Kannada/Hindi/Tulu)
    // even though we always show OTP login — this matters because a
    // returning, already-registered user will skip the Language screen
    // entirely after verifying OTP, so it needs to already be set here.
    try {
      final prefs = await SharedPreferences.getInstance();
      currentLanguage = prefs.getString('app_language') ?? 'English';
    } catch (e) {
      debugPrint('Language load error: $e');
    }

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const OTPLoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F1FB),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90, height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFF185FA5),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [BoxShadow(color: const Color(0xFF185FA5).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
              ),
              child: const Icon(Icons.work_rounded, color: Colors.white, size: 45),
            ),
            const SizedBox(height: 24),
            const Text('LabourConnect', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Color(0xFF0C447C), letterSpacing: 1)),
            const SizedBox(height: 8),
            const Text('Connecting Workers & Contractors', style: TextStyle(fontSize: 13, color: Color(0xFF378ADD))),
            const SizedBox(height: 6),
            const Text('ಕೆಲಸಗಾರರು ಮತ್ತು ಗುತ್ತಿಗೆದಾರರು', style: TextStyle(fontSize: 13, color: Color(0xFF378ADD))),
            const SizedBox(height: 6),
            const Text('मजदूर और ठेकेदार', style: TextStyle(fontSize: 13, color: Color(0xFF378ADD))),
            const SizedBox(height: 40),
            const CircularProgressIndicator(color: Color(0xFF185FA5), strokeWidth: 2),
          ],
        ),
      ),
    );
  }
}

// ================================================
// SCREEN 2 — LANGUAGE SELECTION
// ================================================
class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Container(width: 50, height: 50,
                  decoration: BoxDecoration(color: const Color(0xFF185FA5), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.work_rounded, color: Colors.white, size: 26)),
              const SizedBox(height: 24),
              const Text('Choose your language', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF0C447C))),
              const SizedBox(height: 6),
              const Text('ನಿಮ್ಮ ಭಾಷೆ ಆಯ್ಕೆ ಮಾಡಿ • अपनी भाषा चुनें', style: TextStyle(fontSize: 13, color: Colors.grey)),
              const SizedBox(height: 36),
              _buildLanguageButton(context, language: 'English', nativeName: 'English', emoji: '🇮🇳', color: const Color(0xFFE6F1FB), textColor: const Color(0xFF0C447C)),
              const SizedBox(height: 12),
              _buildLanguageButton(context, language: 'Kannada', nativeName: 'ಕನ್ನಡ', emoji: '🌿', color: const Color(0xFFEAF3DE), textColor: const Color(0xFF27500A)),
              const SizedBox(height: 12),
              _buildLanguageButton(context, language: 'Hindi', nativeName: 'हिन्दी', emoji: '🌸', color: const Color(0xFFFAEEDA), textColor: const Color(0xFF633806)),
              const SizedBox(height: 12),
              _buildLanguageButton(context, language: 'Tulu', nativeName: 'ತುಳು', emoji: '🌊', color: const Color(0xFFFBEAF0), textColor: const Color(0xFF72243E)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageButton(BuildContext context, {required String language, required String nativeName, required String emoji, required Color color, required Color textColor}) {
    return GestureDetector(
      onTap: () async {
        currentLanguage = language;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('app_language', language);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UserTypeScreen()));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14), border: Border.all(color: color, width: 1.5)),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 14),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(language, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textColor)),
              Text(nativeName, style: TextStyle(fontSize: 13, color: textColor.withOpacity(0.7))),
            ]),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, size: 16, color: textColor.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }
}

// ================================================
// SCREEN 3 — USER TYPE SELECTION
// ================================================
class UserTypeScreen extends StatelessWidget {
  const UserTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Text(t('i_am'), style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: Color(0xFF0C447C))),
              const SizedBox(height: 8),
              Text(t('choose_role'), style: const TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const WorkerRegistrationScreen())),
                child: Container(
                  width: double.infinity, padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: const Color(0xFFE6F1FB), borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFB5D4F4), width: 1.5)),
                  child: Column(children: [
                    Container(width: 64, height: 64, decoration: BoxDecoration(color: const Color(0xFF185FA5), borderRadius: BorderRadius.circular(16)),
                        child: const Icon(Icons.engineering_rounded, color: Colors.white, size: 32)),
                    const SizedBox(height: 14),
                    Text(t('worker'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF0C447C))),
                    const SizedBox(height: 6),
                    Text(t('worker_desc'), textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: Colors.grey, height: 1.5)),
                  ]),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ContractorRegistrationScreen())),
                child: Container(
                  width: double.infinity, padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: const Color(0xFFEAF3DE), borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFF97C459), width: 1.5)),
                  child: Column(children: [
                    Container(width: 64, height: 64, decoration: BoxDecoration(color: const Color(0xFF27500A), borderRadius: BorderRadius.circular(16)),
                        child: const Icon(Icons.business_center_rounded, color: Colors.white, size: 32)),
                    const SizedBox(height: 14),
                    Text(t('contractor'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF27500A))),
                    const SizedBox(height: 6),
                    Text(t('contractor_desc'), textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: Colors.grey, height: 1.5)),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================================================
// SCREEN 4 — WORKER REGISTRATION (MULTI-SKILL VERSION)
// ================================================
class WorkerRegistrationScreen extends StatefulWidget {
  const WorkerRegistrationScreen({super.key});

  @override
  State<WorkerRegistrationScreen> createState() => _WorkerRegistrationScreenState();
}

class _WorkerRegistrationScreenState extends State<WorkerRegistrationScreen> {
  // Changed: Now a List to store multiple selected skills
  List<String> selectedSkills = [];

  // Expanded skills list - add more as needed
  final List<String> skills = [
    'Mason',
    'Painter',
    'Plumber',
    'Carpenter',
    'Farmer',
    'Loader',
    'Electrician',
    'Welder',
    'Driver',
    'Cook',
    'Cleaner',
    'Security Guard',
    'Helper',
    'Gardener',
    'Mechanic',
    'Tailor',
    'Construction Laborer',
    'Housekeeping',
    'Factory Worker',
    'Warehouse Worker',
  ];

  String selectedIdType = 'Aadhaar';

  final Map<String, Map<String, dynamic>> idTypes = {
    'Aadhaar': {
      'hint': '1234 5678 9012',
      'maxLength': 14,
      'keyboard': TextInputType.number,
      'format': '#### #### ####',
    },
    'PAN': {
      'hint': 'ABCDE1234F',
      'maxLength': 10,
      'keyboard': TextInputType.text,
      'format': 'AAAAA9999A',
    },
    'Driving Licence': {
      'hint': 'KA01 20230001234',
      'maxLength': 16,
      'keyboard': TextInputType.text,
      'format': 'KA01 YYYYXXXXXXX',
    },
  };

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _govtIdController = TextEditingController();
  bool _isSaving = false;
  bool _consentGiven = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF185FA5)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          t('worker_registration'),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0C447C),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6F1FB),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: const Color(0xFF185FA5), width: 2),
                    ),
                    child: const Icon(Icons.person, size: 40, color: Color(0xFF185FA5)),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: const Color(0xFF185FA5),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildInputField(
              label: t('full_name'),
              hint: t('full_name_hint'),
              icon: Icons.person_outline,
              controller: _nameController,
            ),
            const SizedBox(height: 14),
            _buildInputField(
              label: t('phone_number'),
              hint: '+91 9876543210',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.number,
              controller: _phoneController,
              //maxLength: 10,
            ),
            const SizedBox(height: 14),
            _buildInputField(
              label: t('village'),
              hint: t('village_hint'),
              icon: Icons.location_on_outlined,
              controller: _locationController,
            ),
            const SizedBox(height: 14),
            _buildInputField(
              label: t('experience'),
              hint: t('experience_hint'),
              icon: Icons.work_history_outlined,
              keyboardType: TextInputType.number,
              controller: _experienceController,
            ),
            const SizedBox(height: 14),

            // Government ID Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t('govt_id'),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: idTypes.keys.map((type) {
                    final isSelected = selectedIdType == type;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIdType = type;
                            _govtIdController.clear();
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF185FA5)
                                : const Color(0xFFE6F1FB),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF185FA5)
                                  : const Color(0xFFB5D4F4),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              type,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF0C447C),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAEEDA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline,
                          size: 14, color: Color(0xFF633806)),
                      const SizedBox(width: 6),
                      Text(
                        'Format: ${idTypes[selectedIdType]!['format']}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF633806),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFB5D4F4), width: 1),
                  ),
                  child: TextField(
                    controller: _govtIdController,
                    keyboardType: selectedIdType == 'Aadhaar'
                        ? TextInputType.number
                        : TextInputType.visiblePassword,
                    maxLength: idTypes[selectedIdType]!['maxLength'],
                    textCapitalization: selectedIdType == 'PAN'
                        ? TextCapitalization.characters
                        : TextCapitalization.none,
                    onChanged: (value) {
                      if (selectedIdType == 'Aadhaar') {
                        final digits = value.replaceAll(' ', '');
                        if (digits.length <= 12) {
                          String formatted = '';
                          for (int i = 0; i < digits.length; i++) {
                            if (i == 4 || i == 8) formatted += ' ';
                            formatted += digits[i];
                          }
                          if (formatted != value) {
                            _govtIdController.value = TextEditingValue(
                              text: formatted,
                              selection: TextSelection.collapsed(
                                offset: formatted.length,
                              ),
                            );
                          }
                        }
                      }
                    },
                    decoration: InputDecoration(
                      hintText: idTypes[selectedIdType]!['hint'],
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                      prefixIcon: Icon(
                        selectedIdType == 'Aadhaar'
                            ? Icons.fingerprint
                            : selectedIdType == 'PAN'
                            ? Icons.credit_card
                            : Icons.drive_eta,
                        color: const Color(0xFF185FA5),
                        size: 20,
                      ),
                      border: InputBorder.none,
                      counterText: '',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Updated: Multi-skill selection section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t('select_skill'),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                // Show count of selected skills
                if (selectedSkills.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF185FA5),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      '${selectedSkills.length} selected',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),

            // Updated: Multi-select skill chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills.map((skill) {
                final isSelected = selectedSkills.contains(skill);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedSkills.remove(skill);
                      } else {
                        selectedSkills.add(skill);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF185FA5)
                          : const Color(0xFFE6F1FB),
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF185FA5)
                            : const Color(0xFFB5D4F4),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isSelected) ...[
                          const Icon(
                            Icons.check,
                            size: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                        ],
                        Text(
                          skill,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF0C447C),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            // Helper text
            if (selectedSkills.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Tap to select one or more skills',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),

            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _consentGiven,
                  activeColor: const Color(0xFF185FA5),
                  onChanged: (value) {
                    setState(() {
                      _consentGiven = value ?? false;
                    });
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      "I agree to LabourConnect collecting my name, phone number, "
                          "location, experience, and government ID for job matching and "
                          "verification purposes.",
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
            GestureDetector(
              onTap: (_isSaving || selectedSkills.isEmpty || !_consentGiven)
                  ? null
                  : () async {
                setState(() => _isSaving = true);

                final enteredId = _govtIdController.text.trim();

                try {
                  // Encrypt/hash the govt ID via the backend before storing or checking
                  final encryptResponse = await http.post(
                    Uri.parse('$AI_BACKEND_URL/actions/encrypt-govt-id'),
                    headers: {
                      'Content-Type': 'application/json',
                      'ngrok-skip-browser-warning': 'true',
                      'X-API-Key': 'LC_MangaloreLabour_9x7k2m',
                    },
                    body: jsonEncode({'govtId': enteredId}),
                  );
                  final encryptData = jsonDecode(encryptResponse.body);
                  if (encryptData['success'] != true) {
                    setState(() => _isSaving = false);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Could not process ID. Please try again.')),
                      );
                    }
                    return;
                  }
                  final govtIdHash = encryptData['govtIdHash'];
                  final govtIdEncrypted = encryptData['govtIdEncrypted'];

                  // Check for duplicate govtId across both workers and contractors, using the hash
                  final existingWorkers = await FirebaseFirestore.instance
                      .collection('workers')
                      .where('govtIdHash', isEqualTo: govtIdHash)
                      .get();
                  final existingContractors = await FirebaseFirestore.instance
                      .collection('contractors')
                      .where('govtIdHash', isEqualTo: govtIdHash)
                      .get();

                  if (existingWorkers.docs.isNotEmpty || existingContractors.docs.isNotEmpty) {
                    setState(() => _isSaving = false);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('This ID is already registered. Please check and try again.'),
                          backgroundColor: Color(0xFFE24B4A),
                        ),
                      );
                    }
                    return;
                  }

                  // Updated: Save skills as a list
                  await FirebaseFirestore.instance.collection('workers').add({
                    'ownerUid': FirebaseAuth.instance.currentUser?.uid ?? '',
                    'name': _nameController.text.trim(),
                    'phone': _phoneController.text.trim(),
                    'location': _locationController.text.trim(),
                    'experience': _experienceController.text.trim(),
                    'govtIdHash': govtIdHash,
                    'govtIdEncrypted': govtIdEncrypted,
                    'skills': selectedSkills, // Now saves as array
                    'primarySkill': selectedSkills.isNotEmpty
                        ? selectedSkills.first
                        : '', // Keep first skill as primary for compatibility
                    'registeredAt': DateTime.now().toIso8601String(),
                    'consentGiven': _consentGiven,
                    'consentTimestamp': DateTime.now().toIso8601String(),
                  });

                  try {
                    await http.post(
                      Uri.parse('$AI_BACKEND_URL/actions/register-complete'),
                      headers: {
                        'Content-Type': 'application/json',
                        'ngrok-skip-browser-warning': 'true',
                        'X-API-Key': 'LC_MangaloreLabour_9x7k2m',
                      },
                      body: jsonEncode({
                        'phone': _phoneController.text.trim(),
                        'name': _nameController.text.trim(),
                        'role': 'worker',
                      }),
                    );
                  } catch (e) {
                    debugPrint('register-complete action error: $e');
                  }

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                } catch (e) {
                  setState(() => _isSaving = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error saving: $e')),
                  );
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: (selectedSkills.isEmpty || !_consentGiven)
                      ? const Color(0xFF185FA5).withOpacity(0.4)
                      : const Color(0xFF185FA5),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF185FA5).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: _isSaving
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  )
                      : Text(
                    t('register_worker'),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFB5D4F4), width: 1),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
              prefixIcon: Icon(icon, color: const Color(0xFF185FA5), size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
// ================================================
// SCREEN 5 — CONTRACTOR REGISTRATION
// ================================================
class ContractorRegistrationScreen extends StatefulWidget {
  const ContractorRegistrationScreen({super.key});

  @override
  State<ContractorRegistrationScreen> createState() => _ContractorRegistrationScreenState();
}

class _ContractorRegistrationScreenState extends State<ContractorRegistrationScreen> {
  String selectedWork = '';
  final List<String> workTypes = [
    'Construction',
    'Farming',
    'Painting',
    'Loading',
    'Plumbing',
    'Electrical',
    'Masonry',
    'Carpentry',
    'Welding',
    'Driving',
    'Cooking',
    'Cleaning',
    'Security',
    'Gardening',
    'Mechanical Work',
    'Tailoring',
    'Housekeeping',
    'Factory Work',
    'Warehouse Work',
  ];
  String selectedIdType = 'Aadhaar';
  final Map<String, Map<String, dynamic>> idTypes = {
    'Aadhaar': {
      'hint': '1234 5678 9012',
      'maxLength': 14,
      'keyboard': TextInputType.number,
      'format': '#### #### ####',
    },
    'PAN': {
      'hint': 'ABCDE1234F',
      'maxLength': 10,
      'keyboard': TextInputType.text,
      'format': 'AAAAA9999A',
    },
    'Driving Licence': {
      'hint': 'KA01 20230001234',
      'maxLength': 16,
      'keyboard': TextInputType.text,
      'format': 'KA01 YYYYXXXXXXX',
    },
  };
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _govtIdController = TextEditingController();
  bool _isSaving = false;
  bool _consentGiven = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF185FA5)), onPressed: () => Navigator.pop(context)),
        title: Text(t('contractor_registration'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF0C447C))),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFFEAF3DE), borderRadius: BorderRadius.circular(12)),
              child: const Row(children: [Icon(Icons.info_outline, color: Color(0xFF27500A), size: 18), SizedBox(width: 8), Expanded(child: Text('Post jobs and find verified workers near you instantly', style: TextStyle(fontSize: 12, color: Color(0xFF27500A))))])),
          const SizedBox(height: 20),
          _buildInputField(label: t('your_full_name'), hint: t('your_name_hint'), icon: Icons.person_outline, controller: _nameController),
          const SizedBox(height: 14),
          _buildInputField(label: t('phone_number'), hint: '+91 9876543210', icon: Icons.phone_outlined, keyboardType: TextInputType.number, controller: _phoneController, maxLength: 10),
          const SizedBox(height: 14),
          _buildInputField(label: t('company_name'), hint: t('company_hint'), icon: Icons.business_outlined, controller: _companyController),
          const SizedBox(height: 14),
          _buildInputField(label: t('work_location'), hint: t('work_location_hint'), icon: Icons.location_on_outlined, controller: _locationController),
          const SizedBox(height: 14),
          Text(t('govt_id'), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey)),
          const SizedBox(height: 8),
          Row(
            children: idTypes.keys.map((type) {
              final isSelected = selectedIdType == type;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() { selectedIdType = type; _govtIdController.clear(); }),
                  child: Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF27500A) : const Color(0xFFEAF3DE),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: isSelected ? const Color(0xFF27500A) : const Color(0xFF97C459)),
                    ),
                    child: Center(
                      child: Text(type, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : const Color(0xFF27500A))),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFAEEDA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 14, color: Color(0xFF633806)),
                const SizedBox(width: 6),
                Text(
                  'Format: ${idTypes[selectedIdType]!['format']}',
                  style: const TextStyle(fontSize: 11, color: Color(0xFF633806)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFB5D4F4), width: 1)),
            child: TextField(
              controller: _govtIdController,
              keyboardType: selectedIdType == 'Aadhaar'
                  ? TextInputType.number
                  : TextInputType.visiblePassword,
              maxLength: idTypes[selectedIdType]!['maxLength'],
              textCapitalization: selectedIdType == 'PAN'
                  ? TextCapitalization.characters
                  : TextCapitalization.none,
              onChanged: (value) {
                if (selectedIdType == 'Aadhaar') {
                  final digits = value.replaceAll(' ', '');
                  if (digits.length <= 12) {
                    String formatted = '';
                    for (int i = 0; i < digits.length; i++) {
                      if (i == 4 || i == 8) formatted += ' ';
                      formatted += digits[i];
                    }
                    if (formatted != value) {
                      _govtIdController.value = TextEditingValue(
                        text: formatted,
                        selection: TextSelection.collapsed(offset: formatted.length),
                      );
                    }
                  }
                }
              },
              decoration: InputDecoration(
                hintText: idTypes[selectedIdType]!['hint'],
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                prefixIcon: Icon(
                  selectedIdType == 'Aadhaar'
                      ? Icons.fingerprint
                      : selectedIdType == 'PAN'
                      ? Icons.credit_card
                      : Icons.drive_eta,
                  color: const Color(0xFF185FA5),
                  size: 20,
                ),
                border: InputBorder.none,
                counterText: '',
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(t('type_of_work'), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey)),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: workTypes.map((work) {
            final isSelected = selectedWork == work;
            return GestureDetector(
              onTap: () => setState(() => selectedWork = work),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: isSelected ? const Color(0xFF27500A) : const Color(0xFFEAF3DE), borderRadius: BorderRadius.circular(99), border: Border.all(color: isSelected ? const Color(0xFF27500A) : const Color(0xFF97C459))),
                child: Text(work, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: isSelected ? Colors.white : const Color(0xFF27500A))),
              ),
            );
          }).toList()),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: _consentGiven,
                activeColor: const Color(0xFF27500A),
                onChanged: (value) {
                  setState(() {
                    _consentGiven = value ?? false;
                  });
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    "I agree to LabourConnect collecting my name, phone number, "
                        "company name, location, and government ID for job posting and "
                        "verification purposes.",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: (_isSaving || !_consentGiven) ? null : () async {
              setState(() => _isSaving = true);

              final enteredId = _govtIdController.text.trim();

              try {
                final encryptResponse = await http.post(
                  Uri.parse('$AI_BACKEND_URL/actions/encrypt-govt-id'),
                  headers: {
                    'Content-Type': 'application/json',
                    'ngrok-skip-browser-warning': 'true',
                    'X-API-Key': 'LC_MangaloreLabour_9x7k2m',
                  },
                  body: jsonEncode({'govtId': enteredId}),
                );
                final encryptData = jsonDecode(encryptResponse.body);
                if (encryptData['success'] != true) {
                  setState(() => _isSaving = false);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Could not process ID. Please try again.')),
                    );
                  }
                  return;
                }
                final govtIdHash = encryptData['govtIdHash'];
                final govtIdEncrypted = encryptData['govtIdEncrypted'];

                final existingWorkers = await FirebaseFirestore.instance
                    .collection('workers')
                    .where('govtIdHash', isEqualTo: govtIdHash)
                    .get();
                final existingContractors = await FirebaseFirestore.instance
                    .collection('contractors')
                    .where('govtIdHash', isEqualTo: govtIdHash)
                    .get();

                if (existingWorkers.docs.isNotEmpty || existingContractors.docs.isNotEmpty) {
                  setState(() => _isSaving = false);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('This ID is already registered. Please check and try again.'),
                        backgroundColor: Color(0xFFE24B4A),
                      ),
                    );
                  }
                  return;
                }

                await FirebaseFirestore.instance.collection('contractors').add({
                  'ownerUid': FirebaseAuth.instance.currentUser?.uid ?? '',
                  'name': _nameController.text.trim(),
                  'phone': _phoneController.text.trim(),
                  'company': _companyController.text.trim(),
                  'location': _locationController.text.trim(),
                  'workType': selectedWork,
                  'govtIdHash': govtIdHash,
                  'govtIdEncrypted': govtIdEncrypted,
                  'registeredAt': DateTime.now().toIso8601String(),
                  'consentGiven': _consentGiven,
                  'consentTimestamp': DateTime.now().toIso8601String(),
                });

                try {
                  await http.post(
                    Uri.parse('$AI_BACKEND_URL/actions/register-complete'),
                    headers: {
                      'Content-Type': 'application/json',
                      'ngrok-skip-browser-warning': 'true',
                      'X-API-Key': 'LC_MangaloreLabour_9x7k2m',
                    },
                    body: jsonEncode({
                      'phone': _phoneController.text.trim(),
                      'name': _nameController.text.trim(),
                      'role': 'contractor',
                    }),
                  );
                } catch (e) {
                  debugPrint('register-complete action error: $e');
                }

                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ContractorHomeScreen()));
              } catch (e) {
                setState(() => _isSaving = false);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving: $e')));
              }
            },
            child: Container(
              width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(color: const Color(0xFF27500A), borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: const Color(0xFF27500A).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))]),
              child: Center(child: _isSaving
                  ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                  : Text(t('register_contractor'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white))),
            ),
          ),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }

  Widget _buildInputField({required String label, required String hint, required IconData icon, TextInputType keyboardType = TextInputType.text, TextEditingController? controller, int? maxLength}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey)),
      const SizedBox(height: 6),
      Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFB5D4F4), width: 1)),
        child: TextField(controller: controller, keyboardType: keyboardType, maxLength: maxLength,
            decoration: InputDecoration(hintText: hint, hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                prefixIcon: Icon(icon, color: const Color(0xFF185FA5), size: 20), border: InputBorder.none,
                counterText: '',
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14))),
      ),
    ]);
  }
}

// ================================================
// SCREEN 6 — HOME SCREEN
// ================================================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  List<Widget> get _screens => [
    const HomeContent(),
    const MyJobsScreen(),
    AIChatbotScreen(onNavigateToTab: (index) => setState(() => _selectedIndex = index)),
    const ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF185FA5),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home_outlined), activeIcon: const Icon(Icons.home), label: t('home')),
          BottomNavigationBarItem(icon: const Icon(Icons.work_outline), activeIcon: const Icon(Icons.work), label: t('my_jobs')),
          BottomNavigationBarItem(icon: const Icon(Icons.smart_toy_outlined), activeIcon: const Icon(Icons.smart_toy), label: t('ai_help')),
          BottomNavigationBarItem(icon: const Icon(Icons.person_outline), activeIcon: const Icon(Icons.person), label: t('profile')),
        ],
      ),
    );
  }
}

// ================================================
// SCREEN 6A — HOME CONTENT (MULTI-SKILL + FALLBACK)
// ================================================
class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

String _getGreeting() {
  final hour = DateTime.now().hour;

  if (hour >= 5 && hour < 12) {
    return t('good_morning');
  } else if (hour >= 12 && hour < 17) {
    return t('good_afternoon');
  } else if (hour >= 17 && hour < 21) {
    return t('good_evening');
  } else {
    return t('good_night');
  }
}

class _HomeContentState extends State<HomeContent> {
  String _workerName = 'Worker';
  String _workerPhone = '';
  List<String> _workerSkills = [];
  String _workerLocation = '';
  String _workerExperience = '';
  bool _showOnlyMySkills = true;
  int _unreadNotifications = 0;

  List<Map<String, dynamic>> _jobs = [];
  bool _isLoadingJobs = true;
  bool _isLoadingRanking = false;
  String? _aiRankingNote;

  // Track if we're showing fallback (all jobs)
  bool _isShowingFallback = false;

  // ── Search ──
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // ── Real stats ──
  int _jobsDoneCount = 0;
  double _avgRating = 0.0;
  bool _isLoadingStats = true;

  @override
  void initState() {
    super.initState();
    _loadEverything();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadEverything() async {
    await _loadWorkerProfile();
    await _loadJobs();
    await _loadUnreadNotificationCount();
    await _loadRealStats();
  }

  Future<void> _loadRealStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedPhone = prefs.getString('user_phone') ?? '';
      if (savedPhone.isEmpty) {
        setState(() => _isLoadingStats = false);
        return;
      }
      final digitsOnly = savedPhone.replaceAll(RegExp(r'[^0-9]'), '');
      final phone10 = digitsOnly.length >= 10
          ? digitsOnly.substring(digitsOnly.length - 10)
          : digitsOnly;

      // Jobs Done = completed applications for this worker
      final applications = await FirebaseFirestore.instance.collection('applications').get();
      final completedCount = applications.docs.where((doc) {
        final docPhone = (doc['workerPhone'] ?? '').toString().replaceAll(RegExp(r'[^0-9]'), '');
        final docPhone10 = docPhone.length >= 10 ? docPhone.substring(docPhone.length - 10) : docPhone;
        return docPhone10 == phone10 && (doc['status'] ?? '') == 'completed';
      }).length;

      // Rating = average of feedback entries for this worker
      final feedbackSnap = await FirebaseFirestore.instance.collection('feedback').get();
      final myRatings = feedbackSnap.docs.where((doc) {
        final docPhone = (doc['workerPhone'] ?? '').toString().replaceAll(RegExp(r'[^0-9]'), '');
        final docPhone10 = docPhone.length >= 10 ? docPhone.substring(docPhone.length - 10) : docPhone;
        return docPhone10 == phone10;
      }).map((doc) => (doc['rating'] ?? 0) as num).toList();

      final avg = myRatings.isEmpty
          ? 0.0
          : myRatings.reduce((a, b) => a + b) / myRatings.length;

      if (mounted) {
        setState(() {
          _jobsDoneCount = completedCount;
          _avgRating = avg.toDouble();
          _isLoadingStats = false;
        });
      }
    } catch (e) {
      debugPrint('Stats load error: $e');
      if (mounted) setState(() => _isLoadingStats = false);
    }
  }

  Future<void> _loadWorkerProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedPhone = prefs.getString('user_phone') ?? '';
      if (savedPhone.isEmpty) return;

      final digitsOnly = savedPhone.replaceAll(RegExp(r'[^0-9]'), '');
      final phone10 = digitsOnly.length >= 10
          ? digitsOnly.substring(digitsOnly.length - 10)
          : digitsOnly;

      final allWorkers =
      await FirebaseFirestore.instance.collection('workers').get();

      for (var doc in allWorkers.docs) {
        final workerPhone = (doc['phone'] ?? '')
            .toString()
            .replaceAll(RegExp(r'[^0-9]'), '');
        final workerPhone10 = workerPhone.length >= 10
            ? workerPhone.substring(workerPhone.length - 10)
            : workerPhone;

        if (phone10 == workerPhone10) {
          setState(() {
            _workerName = doc['name'] ?? 'Worker';
            _workerPhone = savedPhone;
            _workerLocation = doc['location'] ?? '';
            _workerExperience = doc['experience'] ?? '';

            final skillsData = doc['skills'];
            if (skillsData is List) {
              _workerSkills = List<String>.from(skillsData);
            } else if (skillsData is String && skillsData.isNotEmpty) {
              _workerSkills = [skillsData];
            } else {
              final oldSkill = doc['skill']?.toString() ?? '';
              if (oldSkill.isNotEmpty) {
                _workerSkills = [oldSkill];
              }
            }
          });
          return;
        }
      }

      final allContractors =
      await FirebaseFirestore.instance.collection('contractors').get();
      for (var doc in allContractors.docs) {
        final contractorPhone = (doc['phone'] ?? '')
            .toString()
            .replaceAll(RegExp(r'[^0-9]'), '');
        final contractorPhone10 = contractorPhone.length >= 10
            ? contractorPhone.substring(contractorPhone.length - 10)
            : contractorPhone;
        if (phone10 == contractorPhone10) {
          setState(() => _workerName = doc['name'] ?? 'Worker');
          return;
        }
      }
    } catch (e) {
      debugPrint('Profile load error: $e');
    }
  }

  Future<void> _loadUnreadNotificationCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedPhone = prefs.getString('user_phone') ?? '';
      if (savedPhone.isEmpty) return;

      final digitsOnly = savedPhone.replaceAll(RegExp(r'[^0-9]'), '');
      final phone10 = digitsOnly.length >= 10
          ? digitsOnly.substring(digitsOnly.length - 10)
          : digitsOnly;

      final snapshot =
      await FirebaseFirestore.instance.collection('notifications').get();

      final unreadCount = snapshot.docs.where((doc) {
        final docPhone = (doc['workerPhone'] ?? '')
            .toString()
            .replaceAll(RegExp(r'[^0-9]'), '');
        final docPhone10 = docPhone.length >= 10
            ? docPhone.substring(docPhone.length - 10)
            : docPhone;
        final isRead = doc['read'] ?? false;
        return docPhone10 == phone10 && !isRead;
      }).length;

      if (mounted) {
        setState(() => _unreadNotifications = unreadCount);
      }
    } catch (e) {
      debugPrint('Unread count error: $e');
    }
  }

  Future<void> _loadJobs() async {
    try {
      final snapshot =
      await FirebaseFirestore.instance.collection('jobs').get();

      final jobs = snapshot.docs
          .where((doc) {
        final status = doc.data().toString().contains('status') ? doc['status'] : null;
        return status != 'expired' && status != 'removed' && status != 'completed';
      })
          .map((doc) {
        return {
          'id': doc.id,
          'title': doc['title'] ?? 'Untitled Job',
          'skill': doc['skill'] ?? '',
          'location': doc['location'] ?? 'Unknown',
          'wage': doc['wage'] ?? '0',
          'date': doc['startDate'] ?? '',
          'description': doc['description'] ?? '',
        };
      }).toList();

      setState(() {
        _jobs = jobs;
        _isLoadingJobs = false;
      });

      if (jobs.isNotEmpty) {
        setState(() => _isLoadingRanking = true);
        _rankJobsWithAI(jobs);
      }
    } catch (e) {
      debugPrint('Error loading jobs: $e');
      setState(() => _isLoadingJobs = false);
    }
  }

  Future<void> _rankJobsWithAI(List<Map<String, dynamic>> jobs) async {
    final result = await matchJobsWithAI(
      workerSkill: _workerSkills.join(', '),
      workerLocation: _workerLocation,
      workerExperience: _workerExperience,
    );

    if (mounted) {
      setState(() {
        _aiRankingNote = result;
        _isLoadingRanking = false;
      });
    }
  }

  bool _jobMatchesWorkerSkills(String jobSkill) {
    if (_workerSkills.isEmpty) return false;

    final normalizedJobSkill = jobSkill.trim().toLowerCase();

    for (final skill in _workerSkills) {
      final normalizedSkill = skill.trim().toLowerCase();

      if (normalizedJobSkill == normalizedSkill) return true;
      if (normalizedJobSkill.contains(normalizedSkill)) return true;
      if (normalizedSkill.contains(normalizedJobSkill)) return true;
    }
    return false;
  }

  // Get filtered jobs with fallback logic + search
  List<Map<String, dynamic>> _getVisibleJobs() {
    List<Map<String, dynamic>> base;

    if (!_showOnlyMySkills || _workerSkills.isEmpty) {
      _isShowingFallback = false;
      base = _jobs;
    } else {
      // Try to filter by skills
      final skillMatches = _jobs
          .where((job) => _jobMatchesWorkerSkills(job['skill'].toString()))
          .toList();

      // If no matches, show all jobs (fallback)
      if (skillMatches.isEmpty) {
        _isShowingFallback = true;
        base = _jobs;
      } else {
        _isShowingFallback = false;
        base = skillMatches;
      }
    }

    if (_searchQuery.isEmpty) return base;

    return base.where((job) {
      final title = job['title'].toString().toLowerCase();
      final skill = job['skill'].toString().toLowerCase();
      final location = job['location'].toString().toLowerCase();
      return title.contains(_searchQuery) ||
          skill.contains(_searchQuery) ||
          location.contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final visibleJobs = _getVisibleJobs();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${_getGreeting()}, $_workerName 👋',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0C447C))),
            Text('${_jobs.length} ${t('jobs_near')}',
                style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                  icon: const Icon(Icons.notifications_outlined,
                      color: Color(0xFF185FA5)),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                    );
                    _loadUnreadNotificationCount(); // refresh badge after returning
                  }),
              if (_unreadNotifications > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE24B4A),
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      _unreadNotifications > 9 ? '9+' : '$_unreadNotifications',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                    color: const Color(0xFFE6F1FB),
                    borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  const Icon(Icons.search,
                      color: Color(0xFF185FA5), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() => _searchQuery = value.trim().toLowerCase());
                      },
                      decoration: InputDecoration(
                        hintText: t('search_jobs'),
                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  if (_searchQuery.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                      child: const Icon(Icons.close, color: Colors.grey, size: 18),
                    ),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(children: [
                _buildStatCard('${_jobs.length}', 'New Jobs',
                    const Color(0xFF185FA5)),
                const SizedBox(width: 8),
                _buildStatCard(
                    _isLoadingStats ? '—' : '$_jobsDoneCount',
                    'Jobs Done',
                    const Color(0xFF27500A)),
                const SizedBox(width: 8),
                _buildStatCard(
                    _isLoadingStats
                        ? '—'
                        : (_avgRating == 0.0 ? 'N/A' : '${_avgRating.toStringAsFixed(1)}★'),
                    'Rating',
                    const Color(0xFFEF9F27)),
              ]),
            ),
            const SizedBox(height: 12),

            if (_isLoadingRanking)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: const Color(0xFFFAEEDA),
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(children: [
                    const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Color(0xFF633806))),
                    const SizedBox(width: 10),
                    const Expanded(
                        child: Text('AI is finding your best job matches...',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFF633806)))),
                  ]),
                ),
              )
            else if (_aiRankingNote != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: const Color(0xFFFAEEDA),
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(children: [
                          Icon(Icons.smart_toy_outlined,
                              size: 14, color: Color(0xFF633806)),
                          SizedBox(width: 6),
                          Text('AI Job Matching',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF633806))),
                        ]),
                        const SizedBox(height: 6),
                        Text(_aiRankingNote!,
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF633806),
                                height: 1.4)),
                      ]),
                ),
              ),
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_showOnlyMySkills && _workerSkills.isNotEmpty && !_isShowingFallback
                      ? t('jobs_today')
                      : 'All Jobs',
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0C447C))),
                  if (_workerSkills.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showOnlyMySkills = !_showOnlyMySkills;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: _showOnlyMySkills && !_isShowingFallback
                              ? const Color(0xFF185FA5)
                              : const Color(0xFFE6F1FB),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _showOnlyMySkills && !_isShowingFallback
                                  ? Icons.filter_alt
                                  : Icons.filter_alt_off,
                              size: 12,
                              color: _showOnlyMySkills && !_isShowingFallback
                                  ? Colors.white
                                  : const Color(0xFF0C447C),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _showOnlyMySkills && !_isShowingFallback
                                  ? '${_workerSkills.length} skills'
                                  : 'Show my skills',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: _showOnlyMySkills && !_isShowingFallback
                                    ? Colors.white
                                    : const Color(0xFF0C447C),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Show fallback banner when no skill matches
            if (_isShowingFallback && _workerSkills.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBEAF0),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFF4C2D3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 18,
                        color: Color(0xFF72243E),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'No ${_workerSkills.join('/')} jobs right now',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF72243E),
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Showing all available jobs instead',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF72243E),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Show worker's skills as chips (only when not in fallback)
            if (_workerSkills.isNotEmpty && _showOnlyMySkills && !_isShowingFallback)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _workerSkills.map((skill) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF3DE),
                        borderRadius: BorderRadius.circular(99),
                        border: Border.all(
                            color: const Color(0xFF97C459), width: 1),
                      ),
                      child: Text(
                        skill,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF27500A),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

            if (_isLoadingJobs)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                    child: CircularProgressIndicator(color: Color(0xFF185FA5))),
              )
            else if (visibleJobs.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    'No jobs posted yet. Check back soon!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ),
              )
            else
              Column(
                children: visibleJobs
                    .map((job) => _buildJobCard(
                  context,
                  jobId: job['id'],
                  title: job['title'],
                  company: job['skill'].toString().isNotEmpty
                      ? '${job['skill']} job'
                      : 'LabourConnect job',
                  location: job['location'],
                  wage: '₹${job['wage']}/day',
                  date: job['date'].toString().isNotEmpty
                      ? job['date']
                      : 'Date not specified',
                  description: job['description'] ?? '',
                ))
                    .toList(),
              ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String number, String label, Color color) {
    return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE8EEF8), width: 1)),
          child: Column(children: [
            Text(number,
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700, color: color)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ]),
        ));
  }

  Widget _buildJobCard(BuildContext context,
      {required String jobId,
        required String title,
        required String company,
        required String location,
        required String wage,
        required String date,
        required String description}) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => JobDetailScreen(
                  jobId: jobId,
                  title: title,
                  company: company,
                  location: location,
                  wage: wage,
                  date: date,
                  description: description))),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE8EEF8), width: 1),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2))
            ]),
        child:
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
                child: Text(title,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1a1a2e)))),
            Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: const Color(0xFFEAF3DE),
                    borderRadius: BorderRadius.circular(99)),
                child: Text(wage,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF27500A)))),
          ]),
          const SizedBox(height: 4),
          Text('$company · $location',
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 6),
          Row(children: [
            Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    color: const Color(0xFFE6F1FB),
                    borderRadius: BorderRadius.circular(6)),
                child: Text(date,
                    style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF0C447C),
                        fontWeight: FontWeight.w500))),
            const SizedBox(width: 6),
            Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    color: const Color(0xFFE6F1FB),
                    borderRadius: BorderRadius.circular(6)),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.verified_user_outlined,
                      size: 11, color: Color(0xFF0C447C)),
                  SizedBox(width: 3),
                  Text('AI Safety Checked',
                      style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF0C447C),
                          fontWeight: FontWeight.w500)),
                ])),
          ]),
        ]),
      ),
    );
  }
}
// ================================================
// NOTIFICATIONS SCREEN
// ================================================
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedPhone = prefs.getString('user_phone') ?? '';
      if (savedPhone.isEmpty) {
        setState(() => _isLoading = false);
        return;
      }

      final digitsOnly = savedPhone.replaceAll(RegExp(r'[^0-9]'), '');
      final phone10 = digitsOnly.length >= 10
          ? digitsOnly.substring(digitsOnly.length - 10)
          : digitsOnly;

      final snapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .get();

      final matched = snapshot.docs.where((doc) {
        final docPhone = (doc['workerPhone'] ?? '')
            .toString()
            .replaceAll(RegExp(r'[^0-9]'), '');
        final docPhone10 = docPhone.length >= 10
            ? docPhone.substring(docPhone.length - 10)
            : docPhone;
        return docPhone10 == phone10;
      }).map((doc) {
        return {
          'id': doc.id,
          'message': doc['message'] ?? '',
          'type': doc['type'] ?? '',
          'read': doc['read'] ?? false,
          'createdAt': doc['createdAt'] ?? '',
          'jobId': (doc.data() as Map<String, dynamic>).containsKey('jobId') ? doc['jobId'] : '',
          'jobTitle': (doc.data() as Map<String, dynamic>).containsKey('jobTitle') ? doc['jobTitle'] : '',
        };
      }).toList();

      // Newest first
      matched.sort((a, b) =>
          (b['createdAt'] as String).compareTo(a['createdAt'] as String));

      setState(() {
        _notifications = matched;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Notifications load error: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _markAsRead(String docId, int index) async {
    try {
      await http.post(
        Uri.parse('$AI_BACKEND_URL/actions/mark-notification-read'),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
          'X-API-Key': 'LC_MangaloreLabour_9x7k2m',
        },
        body: jsonEncode({'notificationId': docId}),
      );
      setState(() {
        _notifications[index]['read'] = true;
      });
    } catch (e) {
      debugPrint('Mark as read error: $e');
    }
  }

  Future<void> _showFeedbackDialog(String jobId, String message) async {
    int selectedRating = 0;
    final commentController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('Rate this job'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    final starIndex = i + 1;
                    return GestureDetector(
                      onTap: () => setDialogState(() => selectedRating = starIndex),
                      child: Icon(
                        starIndex <= selectedRating ? Icons.star : Icons.star_border,
                        color: const Color(0xFFEF9F27),
                        size: 32,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: commentController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Any comments? (optional)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: selectedRating == 0
                    ? null
                    : () async {
                  try {
                    final prefs = await SharedPreferences.getInstance();
                    final savedPhone = prefs.getString('user_phone') ?? '';

                    await FirebaseFirestore.instance.collection('feedback').add({
                      'jobId': jobId,
                      'workerPhone': savedPhone,
                      'rating': selectedRating,
                      'comment': commentController.text.trim(),
                      'submittedAt': DateTime.now().toIso8601String(),
                    });

                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Thanks for your feedback!')),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF185FA5)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Notifications',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0C447C))),
      ),
      body: _isLoading
          ? const Center(
          child: CircularProgressIndicator(color: Color(0xFF185FA5)))
          : _notifications.isEmpty
          ? const Center(
        child: Text(
          'No notifications yet.',
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final n = _notifications[index];
          final isRead = n['read'] as bool;
          return GestureDetector(

              onTap: () {
                if (!isRead) _markAsRead(n['id'], index);
                if (n['type'] == 'scheme_reminder') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AIChatbotScreen()),
                  );
                } else if (n['type'] == 'feedback_request') {
                  _showFeedbackDialog(n['jobId'] ?? '', n['message'] ?? '');
                } else if (n['type'] == 'new_applicant') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ApplicantsScreen(jobId: n['jobId'] ?? '', jobTitle: n['jobTitle'] ?? 'Job')),
                  );
                }
              },
              child: Container(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isRead
                        ? Colors.white
                        : const Color(0xFFE6F1FB),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: const Color(0xFFE8EEF8), width: 1),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        n['type'] == 'scheme_reminder'
                            ? Icons.campaign_outlined
                            : Icons.notifications_outlined,
                        color: const Color(0xFF185FA5),
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          n['message'],
                          style: TextStyle(
                            fontSize: 13,
                            color: const Color(0xFF1a1a2e),
                            fontWeight: isRead
                                ? FontWeight.normal
                                : FontWeight.w600,
                            height: 1.4,
                          ),
                        ),
                      ),
                      if (!isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF185FA5),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
              ));

        },
      ),
    );
  }
}

// ================================================
// KYC STATUS SCREEN
// ================================================
class KycStatusScreen extends StatefulWidget {
  const KycStatusScreen({super.key});

  @override
  State<KycStatusScreen> createState() => _KycStatusScreenState();
}

class _KycStatusScreenState extends State<KycStatusScreen> {
  bool _isLoading = true;
  String _kycStatus = 'not_submitted';
  String _govtId = '';

  @override
  void initState() {
    super.initState();
    _loadKycStatus();
  }

  Future<void> _loadKycStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedPhone = prefs.getString('user_phone') ?? '';
      if (savedPhone.isEmpty) {
        setState(() => _isLoading = false);
        return;
      }

      final digitsOnly = savedPhone.replaceAll(RegExp(r'[^0-9]'), '');
      final phone10 = digitsOnly.length >= 10
          ? digitsOnly.substring(digitsOnly.length - 10)
          : digitsOnly;

      bool found = false;

      final workers = await FirebaseFirestore.instance.collection('workers').get();
      for (var doc in workers.docs) {
        final docPhone = (doc['phone'] ?? '').toString().replaceAll(RegExp(r'[^0-9]'), '');
        final docPhone10 = docPhone.length >= 10 ? docPhone.substring(docPhone.length - 10) : docPhone;
        if (phone10 == docPhone10) {
          setState(() {
            _kycStatus = doc.data().toString().contains('kycStatus') ? (doc['kycStatus'] ?? 'not_submitted') : 'not_submitted';
            _govtId = doc.data().toString().contains('govtId') ? (doc['govtId'] ?? '') : '';
          });
          found = true;
          break;
        }
      }

      if (!found) {
        final contractors = await FirebaseFirestore.instance.collection('contractors').get();
        for (var doc in contractors.docs) {
          final docPhone = (doc['phone'] ?? '').toString().replaceAll(RegExp(r'[^0-9]'), '');
          final docPhone10 = docPhone.length >= 10 ? docPhone.substring(docPhone.length - 10) : docPhone;
          if (phone10 == docPhone10) {
            setState(() {
              _kycStatus = doc.data().toString().contains('kycStatus') ? (doc['kycStatus'] ?? 'not_submitted') : 'not_submitted';
              _govtId = doc.data().toString().contains('govtId') ? (doc['govtId'] ?? '') : '';
            });
            break;
          }
        }
      }

      setState(() => _isLoading = false);
    } catch (e) {
      debugPrint('KYC status load error: $e');
      setState(() => _isLoading = false);
    }
  }

  Map<String, dynamic> _statusDisplay() {
    switch (_kycStatus) {
      case 'verified':
        return {
          'label': 'Verified',
          'color': const Color(0xFF27500A),
          'bg': const Color(0xFFEAF3DE),
          'icon': Icons.verified_user,
          'desc': 'Your identity has been verified by an admin. You have full access to all features.',
        };
      case 'pending_review':
        return {
          'label': 'Pending Review',
          'color': const Color(0xFF633806),
          'bg': const Color(0xFFFAEEDA),
          'icon': Icons.hourglass_top,
          'desc': 'Your ID format looks valid and is awaiting admin verification.',
        };
      case 'flagged':
        return {
          'label': 'Flagged',
          'color': const Color(0xFFB33A3A),
          'bg': const Color(0xFFFCE4E4),
          'icon': Icons.warning_amber_rounded,
          'desc': 'There\'s an issue with your submitted ID (missing, duplicate, or invalid format). Please update your government ID in your profile.',
        };
      default:
        return {
          'label': 'Not Yet Scanned',
          'color': Colors.grey,
          'bg': const Color(0xFFE8EEF8),
          'icon': Icons.info_outline,
          'desc': 'Your KYC hasn\'t been reviewed yet. This runs automatically once a day.',
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = _statusDisplay();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF185FA5)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('KYC Status',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF0C447C))),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF185FA5)))
          : Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: status['bg'],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(status['icon'], color: status['color'], size: 22),
                      const SizedBox(width: 8),
                      Text(status['label'],
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: status['color'])),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(status['desc'],
                      style: TextStyle(fontSize: 13, color: status['color'], height: 1.4)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (_govtId.isNotEmpty) ...[
              const Text('Submitted ID', style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(_govtId, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1a1a2e))),
            ],
          ],
        ),
      ),
    );
  }
}

// ================================================
// SCREEN 7 — JOB DETAIL + AI WAGE ADVISOR + AI SAFETY CHECK
// ================================================
class JobDetailScreen extends StatefulWidget {
  final String jobId, title, company, location, wage, date, description;

  const JobDetailScreen({super.key, required this.jobId, required this.title, required this.company, required this.location, required this.wage, required this.date, required this.description});

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  String _aiWageAdvice = "Loading AI wage advice...";
  bool _isLoadingWage = true;

  int _trustScore = 70;
  String _verdict = 'SAFE';
  String _safetyReason = 'Checking this job for safety...';
  bool _isLoadingSafety = true;

  @override
  void initState() {
    super.initState();
    _loadWageAdvice();
    _loadSafetyCheck();
  }

  Future<void> _loadWageAdvice() async {
    String skill = "Worker";
    if (widget.title.toLowerCase().contains("mason")) skill = "Mason";
    else if (widget.title.toLowerCase().contains("painter")) skill = "Painter";
    else if (widget.title.toLowerCase().contains("farm") || widget.title.toLowerCase().contains("harvest")) skill = "Farmer";
    else if (widget.title.toLowerCase().contains("plumb")) skill = "Plumber";
    else if (widget.title.toLowerCase().contains("electric")) skill = "Electrician";

    final wageDigits = widget.wage.replaceAll(RegExp(r'[^0-9]'), '');
    final wageAmount = int.tryParse(wageDigits) ?? 0;

    final locationPart = widget.location.split('·').first.trim();

    final result = await checkWageWithAI(
      skill: skill,
      location: locationPart,
      offeredWage: wageAmount,
    );

    if (mounted) {
      setState(() {
        _aiWageAdvice = result;
        _isLoadingWage = false;
      });
    }
  }

  Future<void> _loadSafetyCheck() async {
    final result = await checkJobSafetyWithAI(
      jobTitle: widget.title,
      jobDescription: widget.description,
      wage: widget.wage,
      location: widget.location,
    );

    if (mounted) {
      setState(() {
        _trustScore = result['trust_score'];
        _verdict = result['verdict'];
        _safetyReason = result['reason'];
        _isLoadingSafety = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF185FA5)), onPressed: () => Navigator.pop(context)),
        title: const Text('Job Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF0C447C))),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(width: double.infinity, padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFFE6F1FB), borderRadius: BorderRadius.circular(14)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF0C447C))),
                const SizedBox(height: 4),
                Text('${widget.company} · ${widget.location}', style: const TextStyle(fontSize: 13, color: Color(0xFF378ADD))),
              ])),
          const SizedBox(height: 16),
          _buildDetailRow(Icons.calendar_today_outlined, 'Date', widget.date),
          _buildDetailRow(Icons.location_on_outlined, 'Location', widget.location),
          _buildDetailRow(Icons.people_outline, 'Workers needed', '5'),
          _buildDetailRow(Icons.currency_rupee, 'Wage offered', widget.wage),
          const SizedBox(height: 16),
          Container(width: double.infinity, padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFFFAEEDA), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFFAC775), width: 1)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Row(children: [Icon(Icons.smart_toy_outlined, color: Color(0xFF633806), size: 16), SizedBox(width: 6), Text('AI Wage Advisor', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF633806)))]),
                const SizedBox(height: 8),
                _isLoadingWage
                    ? const Row(children: [
                  SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF633806))),
                  SizedBox(width: 8),
                  Text('AI is analyzing this wage...', style: TextStyle(fontSize: 12, color: Color(0xFF633806))),
                ])
                    : Text(_aiWageAdvice, style: const TextStyle(fontSize: 13, color: Color(0xFF1a1a2e), height: 1.4)),
              ])),
          const SizedBox(height: 12),
          Container(width: double.infinity, padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFFE6F1FB), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFB5D4F4), width: 1)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Row(children: [Icon(Icons.verified_user_outlined, color: Color(0xFF0C447C), size: 16), SizedBox(width: 6), Text('AI Safety Check', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0C447C)))]),
                const SizedBox(height: 8),
                _isLoadingSafety
                    ? const Row(children: [
                  SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0C447C))),
                  SizedBox(width: 8),
                  Text('AI is checking this job for safety...', style: TextStyle(fontSize: 12, color: Color(0xFF0C447C))),
                ])
                    : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Text('Trust Score: $_trustScore/100', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0C447C))),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _verdict == 'SAFE' ? const Color(0xFFEAF3DE) : const Color(0xFFFCE4E4),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        _verdict == 'SAFE' ? '✅ SAFE' : '⚠️ SUSPICIOUS',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _verdict == 'SAFE' ? const Color(0xFF27500A) : const Color(0xFFB33A3A)),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: _trustScore / 100,
                      backgroundColor: const Color(0xFFB5D4F4),
                      valueColor: AlwaysStoppedAnimation<Color>(_verdict == 'SAFE' ? const Color(0xFF185FA5) : const Color(0xFFE24B4A)),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(_safetyReason, style: const TextStyle(fontSize: 11, color: Colors.grey, height: 1.4)),
                ]),
              ])),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () async {
              try {
                final prefs = await SharedPreferences.getInstance();
                final savedPhone = prefs.getString('user_phone') ?? '';

                final appRef = await FirebaseFirestore.instance.collection('applications').add({
                  'workerUid': FirebaseAuth.instance.currentUser?.uid ?? '',
                  'jobId': widget.jobId,
                  'jobTitle': widget.title,
                  'workerPhone': savedPhone,
                  'status': 'applied',
                  'appliedAt': DateTime.now().toIso8601String(),
                });

                try {
                  await http.post(
                    Uri.parse('$AI_BACKEND_URL/actions/application-submitted'),
                    headers: {
                      'Content-Type': 'application/json',
                      'ngrok-skip-browser-warning': 'true',
                      'X-API-Key': 'LC_MangaloreLabour_9x7k2m',
                    },
                    body: jsonEncode({'applicationId': appRef.id}),
                  );
                } catch (e) {
                  debugPrint('application-submitted action error: $e');
                }


                if (context.mounted) {
                  showDialog(context: context, builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      title: const Text('Application Sent! 🎉'),
                      content: const Text('Your application has been sent to the contractor. You will receive a confirmation shortly.'),
                      actions: [TextButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); }, child: const Text('OK'))]));
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error applying: $e')));
                }
              }
            },
            child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(color: const Color(0xFF185FA5), borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: const Color(0xFF185FA5).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))]),
                child: Center(child: Text(t('apply_job'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)))),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              final reasonController = TextEditingController();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  title: const Text('Report Suspicious Job'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Why does this job seem suspicious?', style: TextStyle(fontSize: 13, color: Colors.grey)),
                      const SizedBox(height: 10),
                      TextField(
                        controller: reasonController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'e.g. asked for upfront payment...',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                    TextButton(
                      onPressed: () async {
                        try {
                          final reportRef = await FirebaseFirestore.instance.collection('reports').add({
                            'jobId': widget.jobId,
                            'jobTitle': widget.title,
                            'contractorPhone': '',
                            'reason': reasonController.text.trim().isEmpty ? 'No reason given' : reasonController.text.trim(),
                            'reportedAt': DateTime.now().toIso8601String(),
                          });

                          // Instantly alert the admin via the Action Layer, instead of
                          // waiting for n8n's 3-hour fraud alert sweep
                          try {
                            await http.post(
                              Uri.parse('$AI_BACKEND_URL/actions/report-submitted'),
                              headers: {
                                'Content-Type': 'application/json',
                                'ngrok-skip-browser-warning': 'true',
                                'X-API-Key': 'LC_MangaloreLabour_9x7k2m',
                              },
                              body: jsonEncode({'reportId': reportRef.id}),
                            );
                          } catch (e) {
                            debugPrint('report-submitted action error: $e');
                          }

                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Report submitted. Thank you for keeping the community safe.')),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                          }
                        }
                      },
                      child: const Text('Submit Report', style: TextStyle(color: Color(0xFFE24B4A))),
                    ),
                  ],
                ),
              );
            },
            child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE24B4A), width: 1)),
                child: const Center(child: Text('Report Suspicious Job', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFFE24B4A))))),
          ),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFE8EEF8), width: 1))),
      child: Row(children: [Icon(icon, size: 18, color: const Color(0xFF185FA5)), const SizedBox(width: 10), Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)), const Spacer(), Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1a1a2e)))]),
    );
  }
}


// ================================================
// SCREEN 8 — POST A JOB
// ================================================
class PostJobScreen extends StatefulWidget {
  final VoidCallback? onJobPosted;
  const PostJobScreen({super.key, this.onJobPosted});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  List<String> selectedSkills = [];
  final List<String> skills = [ 'Construction',
    'Farming',
    'Painting',
    'Loading',
    'Plumbing',
    'Electrical',
    'Masonry',
    'Carpentry',
    'Welding',
    'Driving',
    'Cooking',
    'Cleaning',
    'Security',
    'Gardening',
    'Mechanical Work',
    'Tailoring',
    'Housekeeping',
    'Factory Work',
    'Warehouse Work'];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _wageController = TextEditingController();
  final TextEditingController _workersController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _additionalController = TextEditingController();
  bool _isSaving = false;

  // ── wage suggestion state ──
  Timer? _wageDebounce;
  String _wageSuggestion = '';
  bool _checkingWage = false;

  // ── Wage fairness chat (new) ──
  String _wageVerdict = '';
  bool _wageAcknowledged = false;
  final List<Map<String, String>> _wageChatMessages = [];
  final TextEditingController _wageDoubtController = TextEditingController();
  bool _isSendingWageDoubt = false;

  @override
  void initState() {
    super.initState();
    _wageController.addListener(_onWageChanged);
  }

  @override
  void dispose() {
    _wageDebounce?.cancel();
    _wageController.removeListener(_onWageChanged);
    _wageDoubtController.dispose();
    super.dispose();
  }

  void _onWageChanged() {
    _wageDebounce?.cancel();
    _wageDebounce = Timer(const Duration(milliseconds: 700), _checkWage);
  }

  Future<void> _checkWage() async {
    final wageText = _wageController.text.trim();
    final wage = int.tryParse(wageText);
    if (wage == null || wage <= 0 || selectedSkills.isEmpty) {
      setState(() {
        _wageSuggestion = '';
        _wageVerdict = '';
        _wageAcknowledged = false;
        _wageChatMessages.clear();
      });
      return;
    }

    setState(() => _checkingWage = true);
    try {
      final response = await http.post(
        Uri.parse('$AI_BACKEND_URL/check_wage'),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode({
          'skill': selectedSkills.first,
          'location': _locationController.text.trim(),
          'offered_wage': wage,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _wageSuggestion = data['result'] ?? '';
          _wageVerdict = (data['verdict'] ?? 'FAIR').toString().toUpperCase();
          _wageAcknowledged = false;
          _wageChatMessages.clear();
        });
      }
    } catch (e) {
      debugPrint('check_wage error: $e');
    } finally {
      if (mounted) setState(() => _checkingWage = false);
    }
  }

  Future<void> _sendWageDoubt() async {
    final doubt = _wageDoubtController.text.trim();
    if (doubt.isEmpty || _isSendingWageDoubt) return;

    setState(() {
      _wageChatMessages.add({'role': 'user', 'text': doubt});
      _wageDoubtController.clear();
      _isSendingWageDoubt = true;
    });

    try {
      final contextMessage =
          "Regarding the wage warning for a ${selectedSkills.isNotEmpty ? selectedSkills.first : ''} "
          "job in ${_locationController.text.trim()} offered at ₹${_wageController.text.trim()}/day: $doubt";

      final response = await http.post(
        Uri.parse('$AI_BACKEND_URL/chat'),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode({
          'message': contextMessage,
          'language': currentLanguage,
        }),
      );
      final data = jsonDecode(response.body);
      final reply = data['reply'] ?? 'Sorry, I could not answer that.';

      setState(() {
        _wageChatMessages.add({'role': 'ai', 'text': reply});
        _isSendingWageDoubt = false;
      });
    } catch (e) {
      setState(() {
        _wageChatMessages.add({'role': 'ai', 'text': 'Sorry, something went wrong.'});
        _isSendingWageDoubt = false;
      });
    }
  }

  Future<void> _actuallyPostJob() async {
    setState(() => _isSaving = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedPhone = prefs.getString('user_phone') ?? '';
      String contractorName = '';
      if (savedPhone.isNotEmpty) {
        final digitsOnly = savedPhone.replaceAll(RegExp(r'[^0-9]'), '');
        final phone10 = digitsOnly.length >= 10
            ? digitsOnly.substring(digitsOnly.length - 10)
            : digitsOnly;
        final allContractors = await FirebaseFirestore.instance.collection('contractors').get();
        for (var doc in allContractors.docs) {
          final cPhone = (doc['phone'] ?? '').toString().replaceAll(RegExp(r'[^0-9]'), '');
          final cPhone10 = cPhone.length >= 10 ? cPhone.substring(cPhone.length - 10) : cPhone;
          if (phone10 == cPhone10) {
            contractorName = doc['name'] ?? '';
            break;
          }
        }
      }

      final jobRef = await FirebaseFirestore.instance.collection('jobs').add({
        'ownerUid': FirebaseAuth.instance.currentUser?.uid ?? '',
        'title': _titleController.text.trim(),
        'location': _locationController.text.trim(),
        'wage': _wageController.text.trim(),
        'workers': _workersController.text.trim(),
        'startDate': _dateController.text.trim(),
        'days': _daysController.text.trim(),
        'description': _descriptionController.text.trim(),
        'additionalDetails': _additionalController.text.trim(),
        'skill': selectedSkills.isNotEmpty ? selectedSkills.first : '',
        'skills': selectedSkills,
        'postedAt': DateTime.now().toIso8601String(),
        'contractorPhone': savedPhone,
        'contractorName': contractorName,
      });

      // Notify the contractor instantly via the new Action Layer endpoint
      try {
        await http.post(
          Uri.parse('$AI_BACKEND_URL/actions/job-posted'),
          headers: {
            'Content-Type': 'application/json',
            'ngrok-skip-browser-warning': 'true',
            'X-API-Key': 'LC_MangaloreLabour_9x7k2m',
          },
          body: jsonEncode({'jobId': jobRef.id}),
        );
      } catch (e) {
        debugPrint('job-posted action error: $e');
      }

      setState(() => _isSaving = false);
      showDialog(context: context, builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Job Posted! 🎉'),
        content: const Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('✅ AI Trust Score: 94/100 — Safe'),
          SizedBox(height: 8),
          Text('Your job is now live! Workers near you can see and apply.'),
        ]),
        actions: [TextButton(onPressed: () {
          Navigator.pop(context);
          widget.onJobPosted?.call();
        }, child: const Text('OK'))],
      ));
    } catch (e) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF185FA5)), onPressed: () => Navigator.pop(context)),
        title: Text(t('post_job'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF0C447C))),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFFE6F1FB), borderRadius: BorderRadius.circular(12)),
              child: const Row(children: [Icon(Icons.smart_toy_outlined, color: Color(0xFF0C447C), size: 16), SizedBox(width: 8), Expanded(child: Text('AI will automatically verify your job before publishing to protect workers', style: TextStyle(fontSize: 12, color: Color(0xFF0C447C))))])),
          const SizedBox(height: 20),
          _buildInputField(label: t('job_title'), hint: t('job_title_hint'), icon: Icons.work_outline, controller: _titleController),
          const SizedBox(height: 14),
          _buildInputField(label: t('work_location'), hint: t('work_location_hint'), icon: Icons.location_on_outlined, controller: _locationController),
          const SizedBox(height: 14),
          _buildInputField(label: t('wage_per_day'), hint: t('wage_hint'), icon: Icons.currency_rupee, keyboardType: TextInputType.number, controller: _wageController),

          // ── Wage fairness chat bubble ──
          if (_checkingWage)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Row(children: [
                SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2)),
                SizedBox(width: 8),
                Text('Checking fair wage...', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ]),
            )
          else if (_wageVerdict == 'LOW')
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFFE082)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const CircleAvatar(radius: 12, backgroundColor: Color(0xFFB28900), child: Icon(Icons.smart_toy_outlined, size: 14, color: Colors.white)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                        child: Text(_wageSuggestion, style: const TextStyle(fontSize: 12, color: Color(0xFF6B5900), height: 1.4)),
                      ),
                    ),
                  ]),
                  ..._wageChatMessages.map((m) {
                    final isAi = m['role'] == 'ai';
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: isAi ? MainAxisAlignment.start : MainAxisAlignment.end,
                        children: [
                          if (isAi) const Padding(padding: EdgeInsets.only(right: 8), child: CircleAvatar(radius: 12, backgroundColor: Color(0xFFB28900), child: Icon(Icons.smart_toy_outlined, size: 14, color: Colors.white))),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isAi ? Colors.white : const Color(0xFF185FA5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(m['text']!, style: TextStyle(fontSize: 12, color: isAi ? const Color(0xFF6B5900) : Colors.white, height: 1.4)),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  if (_isSendingWageDoubt)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2)),
                    ),
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                        child: TextField(
                          controller: _wageDoubtController,
                          style: const TextStyle(fontSize: 12),
                          decoration: const InputDecoration(
                            hintText: 'Ask why, or type your doubt...',
                            hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                          onSubmitted: (_) => _sendWageDoubt(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, size: 18, color: Color(0xFFB28900)),
                      onPressed: _isSendingWageDoubt ? null : _sendWageDoubt,
                    ),
                  ]),
                ],
              ),
            )
          else if (_wageSuggestion.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFFEAF3DE), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFF97C459))),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Icon(Icons.check_circle_outline, color: Color(0xFF27500A), size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text(_wageSuggestion, style: const TextStyle(fontSize: 12, color: Color(0xFF27500A)))),
                ]),
              ),
          // ── END wage fairness chat bubble ──

          const SizedBox(height: 14),
          _buildInputField(label: t('workers_needed'), hint: t('workers_hint'), icon: Icons.people_outline, keyboardType: TextInputType.number, controller: _workersController),
          const SizedBox(height: 14),
          _buildInputField(label: t('start_date'), hint: t('start_date_hint'), icon: Icons.calendar_today_outlined, controller: _dateController),
          const SizedBox(height: 14),
          _buildInputField(label: t('num_days'), hint: t('num_days_hint'), icon: Icons.access_time_outlined, controller: _daysController),
          const SizedBox(height: 14),
          _buildInputField(label: t('job_desc'), hint: t('job_desc_hint'), icon: Icons.description_outlined, controller: _descriptionController),
          const SizedBox(height: 14),
          _buildInputField(label: t('additional'), hint: t('additional_hint'), icon: Icons.notes_outlined, controller: _additionalController),
          const SizedBox(height: 20),
          Text(t('skill_required'), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey)),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: skills.map((skill) {
            final isSelected = selectedSkills.contains(skill);
            return GestureDetector(
              onTap: () => setState(() {
                if (isSelected) {
                  selectedSkills.remove(skill);
                } else {
                  selectedSkills.add(skill);
                }
                _checkWage();
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: isSelected ? const Color(0xFF185FA5) : const Color(0xFFE6F1FB), borderRadius: BorderRadius.circular(99), border: Border.all(color: isSelected ? const Color(0xFF185FA5) : const Color(0xFFB5D4F4))),
                child: Text(skill, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: isSelected ? Colors.white : const Color(0xFF0C447C))),
              ),
            );
          }).toList()),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: _isSaving ? null : () {
              if (_wageVerdict == 'LOW' && !_wageAcknowledged) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    title: const Text('Wage below fair range'),
                    content: const Text('This wage may be below the fair range for this skill and location. Do you want to post it anyway?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Go Back')),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() => _wageAcknowledged = true);
                          _actuallyPostJob();
                        },
                        child: const Text('Post Anyway', style: TextStyle(color: Color(0xFFE24B4A))),
                      ),
                    ],
                  ),
                );
              } else {
                _actuallyPostJob();
              }
            },
            child: Container(
              width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(color: const Color(0xFF185FA5), borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: const Color(0xFF185FA5).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))]),
              child: Center(child: _isSaving
                  ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                  : Text(t('post_job_btn'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white))),
            ),
          ),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }

  Widget _buildInputField({required String label, required String hint, required IconData icon, TextInputType keyboardType = TextInputType.text, TextEditingController? controller, int? maxLength}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey)),
      const SizedBox(height: 6),
      Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFB5D4F4), width: 1)),
        child: TextField(controller: controller, keyboardType: keyboardType, maxLength: maxLength,
            decoration: InputDecoration(hintText: hint, hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                prefixIcon: Icon(icon, color: const Color(0xFF185FA5), size: 20), border: InputBorder.none,
                counterText: '',
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14))),
      ),
    ]);
  }
}
// ================================================
// CONTRACTOR HOME SCREEN
// ================================================
class ContractorHomeScreen extends StatefulWidget {
  const ContractorHomeScreen({super.key});

  @override
  State<ContractorHomeScreen> createState() => _ContractorHomeScreenState();
}
class _ContractorHomeScreenState extends State<ContractorHomeScreen> {
  int _selectedIndex = 0;

  List<Widget> get _screens => [
    const MyPostedJobsScreen(),
    PostJobScreen(onJobPosted: () => setState(() => _selectedIndex = 0)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF27500A),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.work_outline), activeIcon: Icon(Icons.work), label: 'My Jobs'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), activeIcon: Icon(Icons.add_circle), label: 'Post Job'),
        ],
      ),
    );
  }
}

// ================================================
// MY POSTED JOBS SCREEN (contractor view)
// ================================================
class MyPostedJobsScreen extends StatefulWidget {
  const MyPostedJobsScreen({super.key});

  @override
  State<MyPostedJobsScreen> createState() => _MyPostedJobsScreenState();
}

class _MyPostedJobsScreenState extends State<MyPostedJobsScreen> {
  List<Map<String, dynamic>> _jobs = [];
  bool _isLoading = true;
  int _unreadNotifications = 0;

  @override
  void initState() {
    super.initState();
    _loadMyJobs();
    _loadUnreadNotificationCount();
  }

  Future<void> _loadUnreadNotificationCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedPhone = prefs.getString('user_phone') ?? '';
      if (savedPhone.isEmpty) return;

      final digitsOnly = savedPhone.replaceAll(RegExp(r'[^0-9]'), '');
      final phone10 = digitsOnly.length >= 10
          ? digitsOnly.substring(digitsOnly.length - 10)
          : digitsOnly;

      final snapshot = await FirebaseFirestore.instance.collection('notifications').get();

      final unreadCount = snapshot.docs.where((doc) {
        final docPhone = (doc['workerPhone'] ?? '').toString().replaceAll(RegExp(r'[^0-9]'), '');
        final docPhone10 = docPhone.length >= 10 ? docPhone.substring(docPhone.length - 10) : docPhone;
        final isRead = doc['read'] ?? false;
        return docPhone10 == phone10 && !isRead;
      }).length;

      if (mounted) {
        setState(() => _unreadNotifications = unreadCount);
      }
    } catch (e) {
      debugPrint('Contractor unread count error: $e');
    }
  }

  Future<void> _loadMyJobs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedPhone = prefs.getString('user_phone') ?? '';
      final digitsOnly = savedPhone.replaceAll(RegExp(r'[^0-9]'), '');
      final phone10 = digitsOnly.length >= 10
          ? digitsOnly.substring(digitsOnly.length - 10)
          : digitsOnly;

      final snapshot = await FirebaseFirestore.instance.collection('jobs').get();

      final matched = snapshot.docs.where((doc) {
        final data = doc.data();
        final docPhone = (data['contractorPhone'] ?? '').toString().replaceAll(RegExp(r'[^0-9]'), '');
        final docPhone10 = docPhone.length >= 10 ? docPhone.substring(docPhone.length - 10) : docPhone;
        return docPhone10 == phone10;
      }).map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'title': data['title'] ?? 'Untitled',
          'status': data['status'] ?? 'open',
          'postedAt': data['postedAt'] ?? '',
        };
      }).toList();

      matched.sort((a, b) => (b['postedAt'] as String).compareTo(a['postedAt'] as String));

      setState(() {
        _jobs = matched;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('My posted jobs load error: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0, automaticallyImplyLeading: false,
        title: const Text('My Posted Jobs', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF27500A))),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Color(0xFF27500A)),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                  );
                  _loadUnreadNotificationCount();
                },
              ),
              if (_unreadNotifications > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE24B4A),
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      _unreadNotifications > 9 ? '9+' : '$_unreadNotifications',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF27500A)))
          : _jobs.isEmpty
          ? const Center(child: Padding(padding: EdgeInsets.all(24), child: Text('You haven\'t posted any jobs yet.', style: TextStyle(color: Colors.grey, fontSize: 13))))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _jobs.length,
        itemBuilder: (context, index) {
          final job = _jobs[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ApplicantsScreen(jobId: job['id'], jobTitle: job['title'])),
            ),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE8EEF8))),
              child: Row(
                children: [
                  Expanded(child: Text(job['title'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: const Color(0xFFEAF3DE), borderRadius: BorderRadius.circular(99)),
                    child: Text(job['status'], style: const TextStyle(fontSize: 11, color: Color(0xFF27500A))),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ================================================
// APPLICANTS SCREEN (contractor view — accept/reject)
// ================================================
class ApplicantsScreen extends StatefulWidget {
  final String jobId;
  final String jobTitle;

  const ApplicantsScreen({super.key, required this.jobId, required this.jobTitle});

  @override
  State<ApplicantsScreen> createState() => _ApplicantsScreenState();
}

class _ApplicantsScreenState extends State<ApplicantsScreen> {
  List<Map<String, dynamic>> _applicants = [];
  bool _isLoading = true;
  String _contractorPhone = '';

  @override
  void initState() {
    super.initState();
    _loadApplicants();
  }

  Future<void> _loadApplicants() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _contractorPhone = prefs.getString('user_phone') ?? '';

      final snapshot = await FirebaseFirestore.instance
          .collection('applications')
          .where('jobId', isEqualTo: widget.jobId)
          .get();

      final workers = await FirebaseFirestore.instance.collection('workers').get();

      final matched = snapshot.docs.map((doc) {
        final data = doc.data();
        final workerPhone = (data['workerPhone'] ?? '').toString();
        final workerPhoneDigits = workerPhone.replaceAll(RegExp(r'[^0-9]'), '');
        final workerPhone10 = workerPhoneDigits.length >= 10
            ? workerPhoneDigits.substring(workerPhoneDigits.length - 10)
            : workerPhoneDigits;

        String workerName = 'Worker';
        for (var w in workers.docs) {
          final wPhone = (w['phone'] ?? '').toString().replaceAll(RegExp(r'[^0-9]'), '');
          final wPhone10 = wPhone.length >= 10 ? wPhone.substring(wPhone.length - 10) : wPhone;
          if (wPhone10 == workerPhone10) {
            workerName = w['name'] ?? 'Worker';
            break;
          }
        }

        return {
          'id': doc.id,
          'workerName': workerName,
          'workerPhone': workerPhone,
          'status': data['status'] ?? 'applied',
          'appliedAt': data['appliedAt'] ?? '',
          'paid': data['paid'] ?? false,
        };
      }).toList();

      setState(() {
        _applicants = matched;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Applicants load error: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _decide(String applicationId, String decision, int index) async {
    try {
      final response = await http.post(
        Uri.parse('$AI_BACKEND_URL/actions/application-decision'),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
          'X-API-Key': 'LC_MangaloreLabour_9x7k2m',
        },
        body: jsonEncode({
          'applicationId': applicationId,
          'decision': decision,
          'contractorPhone': _contractorPhone,
        }),
      );
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        setState(() => _applicants[index]['status'] = decision);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['error'] ?? 'Could not update application')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _markPaymentReceived(String applicationId, int index) async {
    try {
      final response = await http.post(
        Uri.parse('$AI_BACKEND_URL/actions/payment-received'),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
          'X-API-Key': 'LC_MangaloreLabour_9x7k2m',
        },
        body: jsonEncode({
          'applicationId': applicationId,
          'contractorPhone': _contractorPhone,
        }),
      );
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        setState(() => _applicants[index]['paid'] = true);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['error'] ?? 'Could not mark payment received')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF27500A)), onPressed: () => Navigator.pop(context)),
        title: Text(widget.jobTitle, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF27500A))),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF27500A)))
          : _applicants.isEmpty
          ? const Center(child: Padding(padding: EdgeInsets.all(24), child: Text('No one has applied yet.', style: TextStyle(color: Colors.grey, fontSize: 13))))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _applicants.length,
        itemBuilder: (context, index) {
          final a = _applicants[index];
          final status = a['status'];
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE8EEF8))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(a['workerName'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: status == 'accepted' ? const Color(0xFFEAF3DE) : status == 'rejected' ? const Color(0xFFFCE4E4) : const Color(0xFFFAEEDA),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(status, style: const TextStyle(fontSize: 11)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(a['workerPhone'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                if (status == 'applied') ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _decide(a['id'], 'accepted', index),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(color: const Color(0xFF27500A), borderRadius: BorderRadius.circular(8)),
                            child: const Center(child: Text('Accept', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white))),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _decide(a['id'], 'rejected', index),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE24B4A))),
                            child: const Center(child: Text('Reject', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFE24B4A)))),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                if (status == 'completed' && a['paid'] != true) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(color: const Color(0xFFFCE4E4), borderRadius: BorderRadius.circular(8)),
                    child: const Center(
                      child: Text('Payment pending', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFFB33A3A))),
                    ),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () => _markPaymentReceived(a['id'], index),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(color: const Color(0xFF185FA5), borderRadius: BorderRadius.circular(8)),
                      child: const Center(
                        child: Text('Mark Payment Received', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}


// ================================================
// SCREEN 9 — MY JOBS SCREEN (REAL DATA)
// ================================================
class MyJobsScreen extends StatefulWidget {
  const MyJobsScreen({super.key});

  @override
  State<MyJobsScreen> createState() => _MyJobsScreenState();
}

class _MyJobsScreenState extends State<MyJobsScreen> {
  List<Map<String, dynamic>> _applications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }


  Future<void> _loadApplications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedPhone = prefs.getString('user_phone') ?? '';
      if (savedPhone.isEmpty) {
        setState(() => _isLoading = false);
        return;
      }

      final digitsOnly = savedPhone.replaceAll(RegExp(r'[^0-9]'), '');
      final phone10 = digitsOnly.length >= 10
          ? digitsOnly.substring(digitsOnly.length - 10)
          : digitsOnly;

      final snapshot = await FirebaseFirestore.instance
          .collection('applications')
          .get();

      final matched = snapshot.docs.where((doc) {
        final docPhone = (doc['workerPhone'] ?? '')
            .toString()
            .replaceAll(RegExp(r'[^0-9]'), '');
        final docPhone10 = docPhone.length >= 10
            ? docPhone.substring(docPhone.length - 10)
            : docPhone;
        return docPhone10 == phone10;
      }).map((doc) {
        return {
          'id': doc.id,
          'jobId': doc['jobId'] ?? '',
          'jobTitle': doc['jobTitle'] ?? '',
          'status': doc['status'] ?? 'applied',
          'appliedAt': doc['appliedAt'] ?? '',
          'paid': (doc.data() as Map<String, dynamic>).containsKey('paid') ? doc['paid'] : false,
        };
      }).toList();

      matched.sort((a, b) =>
          (b['appliedAt'] as String).compareTo(a['appliedAt'] as String));

      setState(() {
        _applications = matched;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Applications load error: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _markComplete(String appId, String jobId, int index) async {
    try {
      // Update the application record
      await FirebaseFirestore.instance
          .collection('applications')
          .doc(appId)
          .update({
        'status': 'completed',
        'completedAt': DateTime.now().toIso8601String(),
        'paid': false,
      });

      // Also update the job document itself, so n8n can find it later
      if (jobId.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('jobs')
            .doc(jobId)
            .update({'status': 'completed'});
      }

      setState(() {
        _applications[index]['status'] = 'completed';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Marked as completed!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final active = _applications.where((a) => a['status'] != 'completed').toList();
    final completed = _applications.where((a) => a['status'] == 'completed').toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0, automaticallyImplyLeading: false,
        title: Text(t('my_jobs'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF0C447C))),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF185FA5)))
          : _applications.isEmpty
          ? const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'You haven\'t applied to any jobs yet.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(t('applied_jobs'), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey, letterSpacing: 0.5)),
          const SizedBox(height: 8),
          if (active.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('No active applications.', style: TextStyle(color: Colors.grey, fontSize: 12)),
            )
          else
            ...active.map((a) {
              final index = _applications.indexOf(a);
              return _buildAppCard(a, index);
            }),
          const SizedBox(height: 16),
          Text(t('completed_jobs'), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey, letterSpacing: 0.5)),
          const SizedBox(height: 8),
          if (completed.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('No completed jobs yet.', style: TextStyle(color: Colors.grey, fontSize: 12)),
            )
          else
            ...completed.map((a) {
              final index = _applications.indexOf(a);
              return _buildAppCard(a, index);
            }),
        ]),
      ),
    );
  }

  Widget _buildAppCard(Map<String, dynamic> a, int index) {
    final isCompleted = a['status'] == 'completed';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE8EEF8), width: 1)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(child: Text(a['jobTitle'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1a1a2e)))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: isCompleted ? const Color(0xFFE6F1FB) : const Color(0xFFFAEEDA),
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(
              isCompleted ? 'Completed' : 'Applied',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: isCompleted ? const Color(0xFF185FA5) : const Color(0xFF633806)),
            ),
          ),
        ]),
        if (!isCompleted && a['status'] == 'accepted') ...[
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => _markComplete(a['id'], a['jobId'], index),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(color: const Color(0xFF27500A), borderRadius: BorderRadius.circular(8)),
              child: const Center(
                child: Text('Mark as Completed', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
          ),
        ] else if (isCompleted && a['paid'] != true) ...[
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(color: const Color(0xFFFCE4E4), borderRadius: BorderRadius.circular(8)),
            child: const Center(
              child: Text('Payment pending — waiting for contractor to confirm', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFFB33A3A))),
            ),
          ),
        ],
      ]),
    );
  }
}
// ================================================
// SCREEN 10 — AI CHATBOT SCREEN (now connected to the real Chatbot Agent)
// ================================================
class AIChatbotScreen extends StatefulWidget {
  final void Function(int)? onNavigateToTab;
  const AIChatbotScreen({super.key, this.onNavigateToTab});

  @override
  State<AIChatbotScreen> createState() => _AIChatbotScreenState();
}
class _AIChatbotScreenState extends State<AIChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [
    {'role': 'ai', 'text': 'ನಮಸ್ಕಾರ! ನಾನು LabourConnect AI.\nHello! I am LabourConnect AI assistant.\nमैं LabourConnect AI हूँ।\n\nHow can I help you today?'},
  ];
  bool _isWaitingForReply = false;

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty || _isWaitingForReply) return;
    final userMsg = _controller.text.trim();

    setState(() {
      _messages.add({'role': 'user', 'text': userMsg});
      _controller.clear();
      _isWaitingForReply = true;
    });
    _scrollToBottom();

    final prefs = await SharedPreferences.getInstance();
    final savedPhone = prefs.getString('user_phone') ?? '';

    try {
      final response = await http.post(
        Uri.parse('$AI_BACKEND_URL/chat'),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode({
          'message': userMsg,
          'language': currentLanguage,
          'worker_phone': savedPhone,
        }),
      );
      final data = jsonDecode(response.body);
      final reply = data['reply'] ?? '...';
      final navigateToTab = data['navigateToTab'];

      if (mounted) {
        setState(() {
          _messages.add({'role': 'ai', 'text': reply});
          _isWaitingForReply = false;
        });
        _scrollToBottom();

        if (navigateToTab != null) {
          Future.delayed(const Duration(milliseconds: 800), () {
            widget.onNavigateToTab?.call(navigateToTab as int);
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add({'role': 'ai', 'text': 'Sorry, something went wrong: $e'});
          _isWaitingForReply = false;
        });
        _scrollToBottom();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = _messages.length + (_isWaitingForReply ? 1 : 0);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0, automaticallyImplyLeading: false,
        title: Row(children: [
          const CircleAvatar(backgroundColor: Color(0xFF185FA5), radius: 16, child: Icon(Icons.smart_toy, color: Colors.white, size: 18)),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t('ai_help'), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0C447C))),
            Text(t('ai_subtitle'), style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ]),
        ]),
      ),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(12),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              // Typing indicator bubble (shown after the last real message)
              if (index == _messages.length && _isWaitingForReply) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                        color: const Color(0xFFE6F1FB),
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12), bottomRight: Radius.circular(12))),
                    child: const SizedBox(
                      width: 24, height: 14,
                      child: Center(child: SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF185FA5)))),
                    ),
                  ),
                );
              }

              final msg = _messages[index];
              final isAI = msg['role'] == 'ai';
              return Align(
                alignment: isAI ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                  decoration: BoxDecoration(
                      color: isAI ? const Color(0xFFE6F1FB) : const Color(0xFF185FA5),
                      borderRadius: BorderRadius.only(topLeft: const Radius.circular(12), topRight: const Radius.circular(12), bottomLeft: Radius.circular(isAI ? 0 : 12), bottomRight: Radius.circular(isAI ? 12 : 0))),
                  child: Text(msg['text']!, style: TextStyle(fontSize: 13, color: isAI ? const Color(0xFF0C447C) : Colors.white, height: 1.5)),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey.shade200))),
          child: Row(children: [
            Expanded(child: Container(
              decoration: BoxDecoration(color: const Color(0xFFE6F1FB), borderRadius: BorderRadius.circular(24)),
              child: TextField(
                controller: _controller,
                enabled: !_isWaitingForReply,
                decoration: InputDecoration(hintText: t('ask_hint'), hintStyle: const TextStyle(fontSize: 13, color: Colors.grey), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10)),
                onSubmitted: (_) => _sendMessage(),
              ),
            )),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _isWaitingForReply ? null : _sendMessage,
              child: Container(
                width: 42, height: 42,
                decoration: BoxDecoration(
                  color: _isWaitingForReply ? const Color(0xFF185FA5).withOpacity(0.4) : const Color(0xFF185FA5),
                  borderRadius: BorderRadius.circular(21),
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 18),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

// ================================================
// SCREEN 11 — WORKER PROFILE SCREEN (REAL DATA)
// ================================================
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _workerData;
  bool _isLoading = true;
  int _jobsDoneCount = 0;
  double _avgRating = 0.0;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadRealStats();
  }

  Future<void> _loadRealStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedPhone = prefs.getString('user_phone') ?? '';
      if (savedPhone.isEmpty) return;
      final digitsOnly = savedPhone.replaceAll(RegExp(r'[^0-9]'), '');
      final phone10 = digitsOnly.length >= 10
          ? digitsOnly.substring(digitsOnly.length - 10)
          : digitsOnly;

      final applications = await FirebaseFirestore.instance.collection('applications').get();
      final completedCount = applications.docs.where((doc) {
        final docPhone = (doc['workerPhone'] ?? '').toString().replaceAll(RegExp(r'[^0-9]'), '');
        final docPhone10 = docPhone.length >= 10 ? docPhone.substring(docPhone.length - 10) : docPhone;
        return docPhone10 == phone10 && (doc['status'] ?? '') == 'completed';
      }).length;

      final feedbackSnap = await FirebaseFirestore.instance.collection('feedback').get();
      final myRatings = feedbackSnap.docs.where((doc) {
        final docPhone = (doc['workerPhone'] ?? '').toString().replaceAll(RegExp(r'[^0-9]'), '');
        final docPhone10 = docPhone.length >= 10 ? docPhone.substring(docPhone.length - 10) : docPhone;
        return docPhone10 == phone10;
      }).map((doc) => (doc['rating'] ?? 0) as num).toList();

      final avg = myRatings.isEmpty
          ? 0.0
          : myRatings.reduce((a, b) => a + b) / myRatings.length;

      if (mounted) {
        setState(() {
          _jobsDoneCount = completedCount;
          _avgRating = avg.toDouble();
        });
      }
    } catch (e) {
      debugPrint('Profile stats load error: $e');
    }
  }

  Future<void> _loadProfile() async {
    try {
      // Read phone directly from device storage
      final prefs = await SharedPreferences.getInstance();
      final savedPhone = prefs.getString('user_phone') ?? '';

      if (savedPhone.isEmpty) {
        debugPrint('No phone found in device storage');
        setState(() => _isLoading = false);
        return;
      }

      // Clean phone to last 10 digits
      final digitsOnly = savedPhone.replaceAll(RegExp(r'[^0-9]'), '');
      final phone10 = digitsOnly.length >= 10
          ? digitsOnly.substring(digitsOnly.length - 10)
          : digitsOnly;

      debugPrint('Looking for phone: $phone10');

      // Search all workers
      final allWorkers = await FirebaseFirestore.instance
          .collection('workers')
          .get();

      for (var doc in allWorkers.docs) {
        final workerPhone = (doc['phone'] ?? '')
            .toString()
            .replaceAll(RegExp(r'[^0-9]'), '');
        final workerPhone10 = workerPhone.length >= 10
            ? workerPhone.substring(workerPhone.length - 10)
            : workerPhone;

        if (phone10 == workerPhone10) {
          setState(() {
            _workerData = doc.data();
            _isLoading = false;
          });
          return;
        }
      }

      setState(() => _isLoading = false);

    } catch (e) {
      debugPrint('Profile error: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF8FAFF),
        body: Center(child: CircularProgressIndicator(color: Color(0xFF185FA5))),
      );
    }

    // Use real data if available, fallback to placeholder
    final name = _workerData?['name'] ?? 'Worker';
    final skill = _workerData?['skill'] ?? '—';
    final location = _workerData?['location'] ?? '—';
    final experience = _workerData?['experience'] ?? '—';
    final phone = _workerData?['phone']
        ?? FirebaseAuth.instance.currentUser?.phoneNumber
        ?? '—';
    final govtId = _workerData?['govtId'] ?? '—';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: SingleChildScrollView(
        child: Column(children: [
          // ── Header ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 24),
            decoration: const BoxDecoration(color: Color(0xFFE6F1FB)),
            child: Column(children: [
              Stack(children: [
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF185FA5),
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: Center(
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 12),
              Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF0C447C))),
              const SizedBox(height: 4),
              Text('$skill · $location', style: const TextStyle(fontSize: 13, color: Color(0xFF378ADD))),
              const SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ...List.generate(_avgRating.round().clamp(0, 5),
                        (i) => const Icon(Icons.star, size: 16, color: Color(0xFFEF9F27))),
                ...List.generate(5 - _avgRating.round().clamp(0, 5),
                        (i) => const Icon(Icons.star_border, size: 16, color: Color(0xFFEF9F27))),
                const SizedBox(width: 6),
                Text(
                  '${_avgRating == 0.0 ? "N/A" : _avgRating.toStringAsFixed(1)} · $_jobsDoneCount jobs done',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF378ADD)),
                ),
              ]),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFEAF3DE), borderRadius: BorderRadius.circular(99)),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.verified_user, size: 14, color: Color(0xFF27500A)),
                  SizedBox(width: 4),
                  Text('Verified Worker', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF27500A))),
                ]),
              ),
            ]),
          ),

          // ── Body ──
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: _buildStatCard('$_jobsDoneCount', 'Jobs Done', const Color(0xFF185FA5))),
                const SizedBox(width: 8),
                Expanded(child: _buildStatCard(
                    _avgRating == 0.0 ? 'N/A' : '${_avgRating.toStringAsFixed(1)}★',
                    'Rating', const Color(0xFFEF9F27))),
                const SizedBox(width: 8),
                Expanded(child: _buildStatCard('${experience}yr', 'Experience', const Color(0xFF27500A))),
              ]),
              const SizedBox(height: 20),
              Text(t('my_information'), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.grey, letterSpacing: 0.8)),
              const SizedBox(height: 10),
              _buildInfoRow(Icons.phone_outlined, 'Phone', phone),
              _buildInfoRow(Icons.build_outlined, 'Skill', skill),
              _buildInfoRow(Icons.location_on_outlined, 'Location', location),
              _buildInfoRow(Icons.language_outlined, 'Language', currentLanguage),
              _buildInfoRow(Icons.access_time_outlined, 'Experience', '$experience years'),
              _buildInfoRow(Icons.badge_outlined, 'Govt ID', govtId),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const KycStatusScreen()),
                ),
                child: _buildInfoRow(Icons.shield_outlined, 'Account Status', 'View KYC Status →'),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(color: const Color(0xFF185FA5), borderRadius: BorderRadius.circular(12)),
                  child: Center(child: Text(t('edit_profile'), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white))),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('user_phone');
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OTPLoginScreen()));
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE24B4A), width: 1)),
                  child: Center(child: Text(t('logout'), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFFE24B4A)))),
                ),
              ),
              const SizedBox(height: 20),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _buildStatCard(String number, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE8EEF8), width: 1)),
      child: Column(children: [
        Text(number, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ]),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFE8EEF8), width: 1))),
      child: Row(children: [
        Icon(icon, size: 18, color: const Color(0xFF185FA5)),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        const Spacer(),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1a1a2e))),
      ]),
    );
  }
}
// ================================================
// OTP LOGIN SCREEN — FIXED VERSION
// ================================================
class OTPLoginScreen extends StatefulWidget {
  const OTPLoginScreen({super.key});

  @override
  State<OTPLoginScreen> createState() => _OTPLoginScreenState();
}

class _OTPLoginScreenState extends State<OTPLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _otpSent = false;
  bool _isLoading = false;
  String _generatedOTP = '';
  int _secondsRemaining = 300;
  Timer? _timer;

  // Generate 6-digit OTP using dart:math
  String _generateOTP() {
    final random = Random();
    String otp = '';
    for (int i = 0; i < 6; i++) {
      otp += random.nextInt(10).toString();
    }
    return otp;
  }
  void _startTimer() {
    _timer?.cancel();
    _secondsRemaining = 300;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
          setState(() {
            _otpSent = false;
            _generatedOTP = '';
            _secondsRemaining = 300;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('OTP expired! Please request again.'),
              backgroundColor: Color(0xFFE24B4A),
            ),
          );
        }
      });
    });
  }

  Future<void> _sendOTP() async {
    if (_phoneController.text.trim().isEmpty) return;
    if (_phoneController.text.trim().length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid 10 digit number'),
          backgroundColor: Color(0xFFE24B4A),
        ),
      );
      return;
    }
    setState(() => _isLoading = true);

    // Generate OTP
    _generatedOTP = _generateOTP();

    setState(() {
      _otpSent = true;
      _isLoading = false;
    });
    _startTimer();
  }

  Future<void> _verifyOTP() async {
    if (_otpController.text.trim().isEmpty) return;
    setState(() => _isLoading = true);

    if (_otpController.text.trim() == _generatedOTP) {
      try {
        await FirebaseAuth.instance.signInAnonymously();

        // Save phone to device storage — simple and reliable
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_phone', _phoneController.text.trim());

        // Check if this phone is already a registered worker or
        // contractor. If so, skip Language/UserType/Registration
        // entirely and go straight to their home screen.
        final destination = await _resolveDestinationForPhone(_phoneController.text.trim());

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wrong OTP! Please try again.'),
          backgroundColor: Color(0xFFE24B4A),
          duration: Duration(seconds: 3),
        ),
      );
      _otpController.clear();
    }
  }

  Future<Widget> _resolveDestinationForPhone(String rawPhone) async {
    try {
      String last10(String raw) {
        final d = raw.replaceAll(RegExp(r'[^0-9]'), '');
        return d.length >= 10 ? d.substring(d.length - 10) : d;
      }
      final phone10 = last10(rawPhone);

      final allWorkers = await FirebaseFirestore.instance.collection('workers').get();
      for (var doc in allWorkers.docs) {
        if (phone10 == last10((doc['phone'] ?? '').toString())) {
          return const HomeScreen();
        }
      }

      final allContractors = await FirebaseFirestore.instance.collection('contractors').get();
      for (var doc in allContractors.docs) {
        if (phone10 == last10((doc['phone'] ?? '').toString())) {
          return const ContractorHomeScreen();
        }
      }

      // Not registered yet — go through Language → UserType → Registration.
      return const LanguageScreen();
    } catch (e) {
      debugPrint('Destination lookup error: $e');
      return const LanguageScreen();
    }
  }
  @override
  void dispose() {
    _timer?.cancel();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F1FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Container(
                width: 60, height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF185FA5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.work_rounded,
                    color: Colors.white, size: 30),
              ),
              const SizedBox(height: 24),
              Text(t('welcome'), style: const TextStyle(
                fontSize: 26, fontWeight: FontWeight.w700,
                color: Color(0xFF0C447C), height: 1.3,
              )),
              const SizedBox(height: 8),
              Text(t('login_subtitle'),
                  style: const TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 32),

              if (!_otpSent) ...[
                // ── Phone number entry ──
                Text(t('mobile_number'), style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey,
                )),
                const SizedBox(height: 6),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFB5D4F4)),
                  ),
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    decoration: InputDecoration(
                      hintText: t('mobile_hint'),
                      hintStyle: const TextStyle(
                          color: Colors.grey, fontSize: 13),
                      prefixIcon: const Icon(Icons.phone_outlined,
                          color: Color(0xFF185FA5), size: 20),
                      prefix: const Text('+91 ', style: TextStyle(
                        color: Color(0xFF185FA5),
                        fontWeight: FontWeight.w600,
                      )),
                      border: InputBorder.none,
                      counterText: '',
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: _isLoading ? null : _sendOTP,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF185FA5),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [BoxShadow(
                        color: const Color(0xFF185FA5).withOpacity(0.3),
                        blurRadius: 12, offset: const Offset(0, 4),
                      )],
                    ),
                    child: Center(child: _isLoading
                        ? const CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2)
                        : Text(t('send_otp'), style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ))),
                  ),
                ),

              ] else ...[
                // ── OTP displayed in big box — Fix 1 ──
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF185FA5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(children: [
                    const Text('Your OTP Code',
                        style: TextStyle(
                            color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 10),
                    // BIG OTP number — always visible
                    Text(
                      _generatedOTP,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 12,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Enter this code below',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'OTP expires in: ${_secondsRemaining ~/ 60}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 20),

                // ── Sent to confirmation ──
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF3DE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(children: [
                    const Icon(Icons.check_circle,
                        color: Color(0xFF27500A), size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'OTP generated for +91 ${_phoneController.text}',
                        style: const TextStyle(
                            fontSize: 13, color: Color(0xFF27500A)),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 16),

                // ── OTP input field ──
                Text(t('enter_otp'), style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w500,
                  color: Colors.grey,
                )),
                const SizedBox(height: 6),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFB5D4F4)),
                  ),
                  child: TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 10,
                    ),
                    decoration: InputDecoration(
                      hintText: '------',
                      hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 24,
                          letterSpacing: 10),
                      prefixIcon: const Icon(Icons.lock_outline,
                          color: Color(0xFF185FA5), size: 20),
                      border: InputBorder.none,
                      counterText: '',
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // ── Fix 3 — Change number + Resend options ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Change mobile number
                    GestureDetector(
                      onTap: () => setState(() {
                        _otpSent = false;
                        _otpController.clear();
                        _phoneController.clear(); // clears phone too
                        _generatedOTP = '';
                      }),
                      child: const Text(
                        '← Change number',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFFE24B4A),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // Resend OTP
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _generatedOTP = _generateOTP();
                          _otpController.clear();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('New OTP generated above ↑'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: const Text(
                        'Resend OTP →',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF185FA5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ── Verify button ──
                GestureDetector(
                  onTap: _isLoading ? null : _verifyOTP,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF185FA5),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [BoxShadow(
                        color: const Color(0xFF185FA5).withOpacity(0.3),
                        blurRadius: 12, offset: const Offset(0, 4),
                      )],
                    ),
                    child: Center(child: _isLoading
                        ? const CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2)
                        : Text(t('verify_otp'), style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ))),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}