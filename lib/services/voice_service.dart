import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart';

class VoiceService {
  final SpeechToText _speech = SpeechToText();

  Future<bool> initSpeech() async {
    return await _speech.initialize();
  }

  void listen(
    Function(String intent, String originalText) onIntentDetected,
  ) async {
    print("🔴 Listening started...");
    _speech.listen(
      onResult: (result) async {
        String text = result.recognizedWords;
        print("🟢 Recognized speech: $text");
        if (text.isNotEmpty) {
          String intent = await getIntentFromApi(text);
          onIntentDetected(intent, text);
        }
      },
      listenFor: const Duration(seconds: 6),
      pauseFor: const Duration(seconds: 3),
      partialResults: false,
      cancelOnError: true,
      localeId: 'en_US',
    );
  }

  void stop() {
    _speech.stop();
  }

  bool get isListening => _speech.isListening;

  Future<String> getIntentFromApi(String userText) async {
    try {
      print("🧠 Calling NLP API with text: $userText");
      final response = await http.post(
        Uri.parse('http://10.91.100.5:5000/predict'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"text": userText}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String intent = data['intent'] ?? 'unknown';
        print("🧠 Intent from API: $intent");
        return intent;
      } else {
        print("❌ API call failed: ${response.statusCode}");
        return 'unknown';
      }
    } catch (e) {
      print('❌ API error: $e');
      return 'unknown';
    }
  }
}
