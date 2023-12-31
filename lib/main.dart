// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';
import 'package:highlight_text/highlight_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Voice',
      theme: ThemeData(
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home: SpceechScreen(),
    );
  }
}

class SpceechScreen extends StatefulWidget {
  const SpceechScreen({super.key});

  @override
  State<SpceechScreen> createState() => _SpceechScreenState();
}

class _SpceechScreenState extends State<SpceechScreen> {
  final Map<String, HighlightedWord> _hightlights = {
    'flutter': HighlightedWord(
      onTap: () => print('flutter'),
      textStyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
    ),
    'voice': HighlightedWord(
        onTap: () => print('voice'),
        textStyle: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
    'subscribe': HighlightedWord(
        onTap: () => print('subscribe'),
        textStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
    'like': HighlightedWord(
        onTap: () => print('like'),
        textStyle:
            TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
    'comment': HighlightedWord(
        onTap: () => print('comment'),
        textStyle: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
  };
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = "Press the button and start speaking";
  double _confidence = 1.0;
  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: Duration(milliseconds: 2000),
        repeatPauseDuration: Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: () {
            _listen();
          },
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          child: TextHighlight(
            text: _text,
            words: _hightlights,
            textStyle: TextStyle(
                fontSize: 32, color: Colors.black, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }

  Future<void> _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus:$val'),
        onError: (val) => print('onError:$val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech!.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      } else {
        setState(() => _isListening = false);
        _speech!.stop();
      }
    }
  }
}
