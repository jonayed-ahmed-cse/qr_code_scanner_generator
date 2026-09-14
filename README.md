- 👉Click on thumbnail for the QR Link apk

[![Click on thumbnail for the QR Link apk](https://github.com/jonayed-ahmed-cse/qr_code_scanner_generator/blob/db9712f073f4698f3a39af93e53d8e0d3bf885e4/QR%20Link%20banner.png)](https://drive.google.com/drive/folders/1JGIB5R1_3EnsMIxiH5KnL3b0dYR6AQTq?usp=sharing)

<!-- <p align="center">
  <img src="https://github.com/jonayed-ahmed-cse/qr_code_scanner_generator/blob/db9712f073f4698f3a39af93e53d8e0d3bf885e4/QR%20Link%20banner.png" alt="QR Link Banner" width="100%">
</p> -->

# QR Link

A Flutter-based **QR Code Scanner and Generator** application built with **Dart**. QR Link allows users to generate, scan, save, share, and manage QR codes with a clean **Material 3** interface and persistent scan history.

## Features

* Generate QR codes from text or URLs
* Scan QR codes using the device camera
* Copy scanned results to clipboard
* Share QR code results
* Open scanned URLs directly
* Save generated QR codes to the device gallery
* Maintain local scan history
* View scan date and time
* Delete individual history items or clear all history
* Light and dark theme support
* Reusable Flutter UI components

## App Flow

```text
                    QR Link
                       │
          ┌────────────┴────────────┐
          │                         │
     Generate QR               Scan QR
          │                         │
    Enter Text / URL          Open Camera
          │                         │
    Generate QR Code          Scan QR Code
          │                         │
     ┌────┴────┐             ┌──────┴──────┐
     │         │             │             │
   Save      Share         Copy          Share
     │         │             │             │
     └────┬────┘             └──────┬──────┘
          │                         │
          └──────────┬──────────────┘
                     │
                Scan History
                     │
              View / Delete
```

## Tech Stack

* **Flutter & Dart** — Mobile application development
* **qr_flutter** — QR code generation
* **mobile_scanner** — QR code scanning
* **SharedPreferences** — Local storage and history persistence
* **share_plus** — Sharing QR codes and scanned results
* **url_launcher** — Opening URLs and web searches
* **gal** — Saving generated QR images to the device gallery
* **intl** — Date and time formatting
* **Flutter SVG** — SVG asset rendering
* **Material 3** — UI and theming
* **Git & GitHub** — Version control

## What I Learned

Through this project, I gained practical experience in:

* Building a complete Flutter mobile application
* Implementing QR code generation and camera-based scanning
* Integrating and working with third-party Flutter packages
* Managing local data persistence using SharedPreferences
* Handling asynchronous operations and device permissions
* Implementing image saving, sharing, and clipboard functionality
* Working with URL launching and web search
* Creating reusable Flutter widgets and UI components
* Supporting light and dark themes with Material 3
* Structuring, debugging, and maintaining a multi-screen Flutter application
* Using Git and GitHub for version control

## Project Structure

```text
lib/
├── main.dart
├── generate_qr_code.dart
├── scan_qr_code.dart
├── history_screen.dart
├── history_service.dart
└── scan_history_model.dart

assets/
└── icon/

android/
ios/
web/
test/
```

## Getting Started

### Clone

```bash
git clone https://github.com/jonayed-ahmed-cse/qr_code_scanner_generator.git
```

### Install Dependencies

```bash
cd qr_code_scanner_generator
flutter pub get
```

### Run

```bash
flutter run
```

## Future Improvements

* Add support for Wi-Fi, email, phone, and contact QR codes
* Add customizable QR code styles
* Add search and filtering for scan history
* Improve automated testing
* Add additional export and sharing options

## Author

**MD. JONAYED AHMED**

Computer Science Graduate | Flutter & Mobile Application Developer

[GitHub](https://github.com/jonayed-ahmed-cse) | [LinkedIn](https://linkedin.com/in/jonayedahmed) | [Portfolio](https://jonayedahmed.netlify.app)
