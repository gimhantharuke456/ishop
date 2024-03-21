import 'package:flutter_tts/flutter_tts.dart';

class VoiceController {
  FlutterTts flutterTts = FlutterTts();

  Future<void> speek({required String message}) async {
    try {
      await flutterTts.speak(message);
    } catch (e) {
      throw Error.safeToString(e.toString());
    }
  }
}
