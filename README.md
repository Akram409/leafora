# AI-Powered Plant Care Flutter App

A cross-platform Flutter application that leverages AI to assist users in identifying plant diseases and genus, provides expert consultations, and serves as an educational hub for plant enthusiasts.

## App Screenshots

Here is a quick look at the app's screenshots:
![screenshot](assets/images/screen1.png)
![screenshot](assets/images/screen2.png)
![screenshot](assets/images/screen3.png)    

[//]: # (## App Video)

[//]: # ()
[//]: # (Here is a video of the app in action:)

[//]: # (<iframe width="560" height="315" src="[https://www.youtube.com/embed/VIDEO_ID]&#40;https://www.youtube.com/shorts/ummhfdx7DaE&#41;" frameborder="0" allowfullscreen></iframe>)


## App Download

[Google Drive](https://drive.google.com/file/d/1oppRBfPMRDgnuLEAA7B78kt1GhCpyS4P/view?usp=sharing) - Visit the link to download the app.


## App Features

### Core Features
- **User Authentication**: Secure authentication using Firebase Authentication.
- **AI Diagnosis**: Utilize Gemini AI models to:
    - Detect plant diseases.
    - Identify plant genus.
- **Google Translator Integration**: Translate AI diagnosis results into any language.
- **Expert Chat**: Real-time chat with plant experts, featuring:
    - Online/offline status tracking.
    - Image and emoji sharing.
    - Push notifications for new messages.
- **Educational Hub**:
    - Articles on plant care and gardening.
    - Comprehensive plant database with detailed information.
    - Common diseases and their detailed descriptions.
    - Explore disease types and their characteristics.
- **Bookmarking**: Save favorite articles and plant details for quick access.
- **User Account Management**: Manage personal information, upgrade subscriptions, billing, and payment methods.
- **My Plant History**: Save and view past diagnoses as a history.


### Premium Features (Upgrade Required)
- Unlimited AI checks for plant disease and genus detection.
- Access to expert consultations 24/7.

### Notifications
- Real-time notifications for chat messages and updates.

### Payment Integration
- Payment options include:
  - **Bkash** (currently active).
  - Uddoktapay.
  - SSLCommerz.
  - Shurjopay.

### Storage and Multimedia
- Images are stored securely using Cloudinary.

## How to Run the App
To run the app, you'll need to set up Flutter and Dart on your machine.

Steps:
- Download Android Studio from the official website: https://developer.android.com/studio
- Download JDK from the official website: https://www.oracle.com/java/technologies/javase-jdk11-downloads.html
- Download the Flutter SDK from the official website: https://docs.flutter.dev/release/archive
- Download sdk version 3.22.1
- Unzip the downloaded Flutter SDK into a directory of your choice
- Open Android Studio and install Flutter & dart plugin
- Set up Flutter SDK in your system environment variables
- Specify the Flutter SDK path in your Android Studio settings

You can check reference videos on YouTube for detailed instructions:
https://youtu.be/mMeQhLGD-og?si=rXZQVFBjGOu12aM8


After completing these steps, follow these steps to run the app:
- Open Android Studio
- Select project from version control (VCS) and paste the project URL: https://github.com/Akram409/leafora.git
- Project will be imported into Android Studio
- Finally, run the app on an emulator or a physical device

**Set Up the `.env` File**
- Create a `.env` file in the root directory of the project.
- Add the credentials.

## Packages Used

- **[firebase_core](https://pub.dev/packages/firebase_core)**: Core Firebase functionalities.
- **[firebase_auth](https://pub.dev/packages/firebase_auth)**: Firebase Authentication.
- **[cloud_firestore](https://pub.dev/packages/cloud_firestore)**: Firestore database.
- **[firebase_messaging](https://pub.dev/packages/firebase_messaging)**: Push notifications.
- **[flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)**: Local notifications support.
- **[get](https://pub.dev/packages/get)**: High-performance state management and navigation.
- **[google_fonts](https://pub.dev/packages/google_fonts)**: Easy integration of Google Fonts.
- **[fluttertoast](https://pub.dev/packages/fluttertoast)**: Toast messages.
- **[image_picker](https://pub.dev/packages/image_picker)**: Image selection.
- **[permission_handler](https://pub.dev/packages/permission_handler)**: Handle runtime permissions.
- **[flutter_markdown](https://pub.dev/packages/flutter_markdown)**: Markdown rendering.
- **[flutter_bloc](https://pub.dev/packages/flutter_bloc)**: Bloc for state management.
- **[google_generative_ai](https://pub.dev/packages/google_generative_ai)**: Google Gemini AI integration.
- **[bkash](https://pub.dev/packages/bkash)**: Bkash payment gateway.
- **[emoji_picker_flutter](https://pub.dev/packages/emoji_picker_flutter)**: Emoji picker.
- **[badges](https://pub.dev/packages/badges)**: Badges for notifications.
- **[cached_network_image](https://pub.dev/packages/cached_network_image)**: Efficient image caching.
- **[intl](https://pub.dev/packages/intl)**: Internationalization and localization.
- **[getwidget](https://pub.dev/packages/getwidget)**: Pre-designed UI components.
- **[flutter_spinkit](https://pub.dev/packages/flutter_spinkit)**: Loading animations.
- **[path_provider](https://pub.dev/packages/path_provider)**: Access to device storage paths.
- **[shared_preferences](https://pub.dev/packages/shared_preferences)**: Persistent storage.

## Image Resources
- **[Cloudinary](https://cloudinary.com/)**: Image storage.
- **[FlatIcons](https://www.flaticon.com/)**: Icons for UI design.

## Additional Notes
- Google Translator integration enables multilingual support for AI responses.
- Current active payment gateway: **Bkash**.