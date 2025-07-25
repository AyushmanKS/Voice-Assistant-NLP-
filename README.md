# 🛒 Voice-Controlled Shopping App – WizardCart Edition

A Harry Potter–themed, voice-controlled shopping app that allows users to browse, search, and manage their shopping experience completely hands-free using natural voice commands. Built with Flutter and a Python NLP backend, this app enhances accessibility and brings a magical twist to e-commerce.

---

✨ **Overview**

WizardCart is an enhancement to traditional AI chatbots. Unlike basic conversational agents, this prototype brings an immersive and accessible shopping experience powered by:

*   **Natural Language Processing (NLP):** A custom Python/Flask server interprets natural speech to understand user intent.
*   **Voice Command Navigation:** The entire shopping flow is controllable by voice.
*   **Magical UI:** An immersive interface inspired by the Wizarding World.

This project was developed as part of Triwizardathon, a Harry Potter–themed national-level hackathon aimed at showcasing creative tech solutions.

---

📱 **Features**

🔊 **Voice Assistant Capabilities**

*   **Add to Cart:** Example – “Add the Invisibility Cloak to my cart”
*   **Search Products:** Example – “Search for a flying broomstick”
*   **Clear Search:** Example – “Clear search” or “Go home”
*   **View Cart / Checkout:** Example – “Checkout” or “Open cart”
*   **Remove Items from Cart:** Example – “Remove Spell Book” or “Clear cart”
*   **Return to Home:** Example – “Go back” / “Go home”

🧙 **Magical UI Theme**

*   Dark wizardry-themed UI with rich visual styles.
*   Typography using the "Cinzel" font to match magical aesthetics.
*   Product tiles and voice feedback styled with enchanting effects.

---

🧩 **Architecture**

The project uses a client-server architecture to separate the UI from the heavy lifting of language processing.

**Frontend (Flutter App)**
*   **Framework:** Flutter (Dart)
*   **State Management:** Provider
*   **Voice Recognition:** `speech_to_text` package captures raw speech from the user.
*   **Responsibilities:** Renders the UI, captures voice, sends the text to the backend, and acts on the received intent.

**Backend (Python NLP Server)**
*   **Framework:** Flask
*   **NLP:** A custom model trained on `intents.json` using Scikit-learn.
*   **Responsibilities:** Receives text from the Flutter app, processes it using the trained model (`model.pkl` and `vectorizer.pkl`), and returns a JSON object with the determined intent (e.g., `{"intent": "add_to_cart"}`).

---

📂 **Folder Structure**

The repository is structured into two main parts: the Flutter frontend and the Python backend.

wizardcart-voice-app/
├── lib/
│ ├── main.dart
│ ├── screens/
│ │ ├── home_screen.dart
│ │ ├── cart_screen.dart
│ │ └── info_screen.dart
│ ├── models/
│ │ └── product.dart
│ ├── providers/
│ │ └── cart_provider.dart
│ └── services/
│ └── voice_service.dart
├── assets/
│ └── images/
│ └── ...etc
└── nlp_backend/
├── app.py # Flask server
├── intents.json # Training data for intents
├── model.pkl # Saved trained model
├── train_model.py # Script to train the model
└── vectorizer.pkl # Saved text vectorizer

---

🛠 **Setup Instructions**

To run this project, you need to set up both the Python backend and the Flutter frontend. This guide assumes you have Python and Flutter installed.

### Part 1: Setting Up the Backend Server

First, get the server that understands voice commands running.

1.  **Open a Terminal** (Command Prompt, PowerShell, or Terminal).

2.  **Navigate to the Backend Folder:**
    ```bash
    cd path/to/your/project/nlp_backend
    ```

3.  **Create a Python Virtual Environment** (Highly Recommended):
    ```bash
    # Create the virtual environment
    python -m venv venv

    # Activate it:
    # On Windows:
    venv\Scripts\activate
    # On macOS/Linux:
    source venv/bin/activate
    ```
    *(You should see `(venv)` at the beginning of your terminal prompt.)*

4.  **Install Python Dependencies:**
    ```bash
    pip install Flask scikit-learn
    ```

5.  **Run the Server:**
    ```bash
    python app.py
    ```
    The server is now running and waiting for connections. **Leave this terminal window open.**

### Part 2: Setting Up the Frontend App

Now, set up and run the Flutter app on your phone.

1.  **Open a *New* Terminal Window.** (Don't close the server terminal!)

2.  **Navigate to the Project's Root Folder:**
    ```bash
    cd path/to/your/project/
    ```

3.  **Install Flutter Dependencies:**
    ```bash
    flutter pub get
    ```

4.  **Configure the Network Connection (Crucial Step!):** The app needs your computer's local IP address to talk to the server.
    *   **Create a Hotspot:** On your mobile phone, turn on the **Wi-Fi Hotspot**.
    *   **Connect Your Laptop:** On your laptop, connect to your phone's newly created hotspot network.
    *   **Find Your Laptop's IP:** On your laptop (in the new terminal), run `ipconfig` (Windows) or `ifconfig` / `ip a` (macOS/Linux). Find the "IPv4 Address" for the Wi-Fi adapter. It will likely start with `192.168.x.x` or `10.x.x.x`.

5.  **Update the IP Address in the App Code:**
    *   Open the Flutter project in your code editor (e.g., VS Code).
    *   Navigate to the file: `lib/services/voice_service.dart`.
    *   Find the `getIntentFromApi` function and replace the placeholder IP with the one you just found:
    ```dart
    // In lib/services/voice_service.dart
    final response = await http.post(
      // 👇 Replace THIS with your computer's IP address!
      Uri.parse('http://YOUR_LAPTOP_IP_ADDRESS:5000/predict'), 
      headers: {"Content-Type": "application/json"},
      body: json.encode({"text": userText}),
    );
    ```

6.  **Run the Flutter App:**
    *   Connect your phone to your computer via USB (with developer mode enabled).
    *   In your terminal, run:
    ```bash
    flutter run
    ```
You're all set! With the server running and the app configured, everything will now work together.

---

🚀 **Future Enhancements**

*   **Deploy Backend:** Deploy the Python server to a cloud service (like PythonAnywhere or Heroku) to eliminate the need for a local server and hotspot.
*   **Improve NLP Model:** Enhance the model with context-aware command recognition.
*   **Conversational AI:** Implement a full conversational AI assistant with TTS (Text-to-Speech) responses.
*   **Persistent Storage:** Store user-created commands persistently using Hive or SharedPreferences.
*   **Live Inventory:** Integrate with a real backend for live product inventory and user authentication.

---

🎯 **Problem Statement & Solution**

Most shopping apps rely on manual input. There’s a growing need for hands-free operation (for multitasking or accessibility) and more natural voice interaction. We’ve built a voice-controlled shopping assistant embedded directly within the app that supports full product browsing, cart management, and navigation – all through speech.

---

👨‍💻 **Tech Stack**

| Tech           | Purpose                                  |
| :------------- | :--------------------------------------- |
| **Flutter**    | Frontend UI and cross-platform logic     |
| **Dart**       | Main frontend programming language       |
| **Provider**   | State management in Flutter            |
| **speech_to_text**| Voice recognition (Speech-to-Text)       |
| **Python**     | Backend language for NLP                 |
| **Flask**      | Micro-framework for the backend server   |
| **Scikit-learn**| Machine learning for intent classification|
| **Material UI**| Core widget styling                      |

---

🏁 **Conclusion**

WizardCart is a magical leap toward intuitive, accessible, and immersive shopping experiences. With seamless voice control and a fantasy-inspired UI, it’s designed to blend innovation with enchantment — making every purchase feel like casting a spell.
