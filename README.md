Project Setup Instructions:
Clone the Repository:  https://github.com/winfidigitalhub/shoesly.git
Navigate to the Project Directory:  cd your-project
Install Dependencies:  flutter pub get

Firebase Configuration:
Created a new Firebase project on the Firebase Console.
Configured the necessary Firebase services such as Firestore, Firebase Authentication, etc.
Obtained your Firebase configuration files (google-services.json for Android, GoogleService-Info.plist for iOS) and placed them in the appropriate directories in the project.

Run the Application: flutter run


Assumptions Made During Development: 
1) I assumed that developers would require Firebase authentication as either admin or customer to have easier access to the project.
2) The setup assumes that developers have Flutter and Dart installed and have configured their development environment for both Android and iOS.


Challenges Faced and How They Were Overcome:
1) Integrating Firebase services required careful configuration and handling of asynchronous operations.
(SOLUTION): Detailed documentation and thorough testing were conducted to ensure seamless Firebase integration. Stack Overflow and Firebase documentation were valuable resources.

2) Maintaining a consistent and appealing UI/UX design across different screens and devices posed challenges.
(SOLUTION): Regular design reviews, adherence to Flutter best practices, and testing on various devices were undertaken to ensure a consistent user experience.


Additional Features or Improvements:

Admin Page To Upload Shoes:
1) An admin page was added to facilitate administrative tasks and manage content.
(IMPLEMENTATION): Firebase Authentication roles were utilized to differentiate between regular users and admins. Admin-specific functionality was added to the admin page.

Authentication:
1) Firebase Authentication was implemented to secure user data and authenticate users.
(IMPLEMENTATION): Firebase Authentication methods were integrated, and user authentication was handled securely. Email/password and social media authentication options were provided.


