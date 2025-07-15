🛒 Voice-Controlled Shopping App – WizardCart Edition

A Harry Potter–themed, voice-controlled shopping app that allows users to browse, search, and manage their shopping experience completely hands-free using natural voice commands. Built with Flutter, this app enhances accessibility and brings a magical twist to e-commerce.


---

✨ Overview

WizardCart is an enhancement to traditional AI chatbots like Walmart’s Sparky AI. Unlike basic conversational agents, this prototype brings an immersive and accessible shopping experience powered by:

Natural language processing (NLP)

Voice command navigation

Magical UI inspired by the Wizarding World


This project was developed as part of Triwizardathon, a Harry Potter–themed national-level hackathon aimed at showcasing creative tech solutions.


---

📱 Features

🔊 Voice Assistant Capabilities

Add to Cart: Example – “Add iPhone to cart”

Search Products: Example – “Search MacBook”

Clear Search: Example – “Clear search”

View Cart / Checkout: Example – “Checkout” or “Open cart”

Remove Items from Cart: Example – “Clear MacBook” or “Clear cart”

Return to Home: Example – “Go back” / “Go home”


🧙 Magical UI Theme

Dark wizardry-themed UI with rich visual styles

Typography using "Cinzel" font to match magical aesthetics

Product tiles and voice feedback styled with enchanting effects


🧠 User-Created Commands (Custom Commands)

Create your own voice commands and bind them to app actions

Delete custom commands at any time (default ones are protected)



---

🧩 Architecture

Frontend: Flutter (Dart)

State Management: Provider

Voice Recognition: speech_to_text package

Custom Command Management: Local in-memory storage (can be extended to use local DB like Hive or SharedPreferences)



---

🧪 Screens

Screen	Purpose	Key Features

Home	Main shopping area	Grid of products, voice search, add to cart
Cart	Review and checkout	Voice-enabled cart management
Info	Voice command help	List of available commands, custom command creator



---

📂 Folder Structure

lib/
├── main.dart
├── screens/
│   ├── home_screen.dart
│   ├── cart_screen.dart
│   └── info_screen.dart
├── models/
│   └── product.dart
├── providers/
│   └── cart_provider.dart
├── services/
│   └── voice_service.dart
assets/
└── images/
├── iphone.jpeg
├── samsung.jpg
└── ...etc


---

🛠 Setup Instructions

1. Clone the repository:

git clone https://github.com/yourusername/wizardcart-voice-app.git
cd wizardcart-voice-app


2. Install dependencies:

flutter pub get


3. Ensure microphone permissions:

Add the following in AndroidManifest.xml:

<uses-permission android:name="android.permission.RECORD_AUDIO"/>


4. Run the app:

flutter run




---

🚀 Future Enhancements

Improve NLP model with context-aware command recognition

Voice signature/recognition for secure personalized experience

Conversational AI assistant with TTS (Text-to-Speech) responses

Store user-created commands persistently

Backend integration for live product inventory and authentication



---

🎯 Problem Statement

Most shopping apps and AI chatbots are limited to basic input fields or static responses. There’s a growing need for:

Hands-free operation (e.g., for multitasking or accessibility)

Natural voice interaction beyond simple keyword matching

Enhanced in-app navigation through voice



---

💡 Solution

We’ve built a voice-controlled shopping assistant embedded directly within the app that supports full product browsing, cart management, and navigation – all through speech. It mimics conversational AI behaviors, while remaining lightweight and fast for mobile use.


---

👨‍💻 Tech Stack

Tech	Purpose

Flutter	UI and cross-platform logic
Dart	Main programming language
Provider	State management
speech_to_text	Voice recognition
Material UI	Core widget styling



---

🏁 Conclusion

WizardCart is a magical leap toward intuitive, accessible, and immersive shopping experiences. With seamless voice control and a fantasy-inspired UI, it’s designed to blend innovation with enchantment — making every purchase feel like casting a spell.


---

📷 Screenshots