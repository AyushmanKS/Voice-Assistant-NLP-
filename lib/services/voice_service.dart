import 'package:speech_to_text/speech_to_text.dart';

class VoiceService {
  final SpeechToText _speech = SpeechToText();

  Future<bool> initSpeech() async {
    return await _speech.initialize();
  }

  void listen(Function(String result) onResult) {
    _speech.listen(onResult: (result) {
      onResult(result.recognizedWords);
    });
  }

  void stop() {
    _speech.stop();
  }

  bool get isListening => _speech.isListening;
}