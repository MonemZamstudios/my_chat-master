import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  stt.SpeechToText _speech;
  bool _isListening = false;
  String _textSpeech = 'Presiona el botón para iniciar a hablar';

  void onListen() async {
    bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'));

    if (!_isListening) {
      if (available) {
        setState(() {
          _isListening = false;
          _speech.listen(
            onResult: (val) => setState(() {
              _textSpeech = val.recognizedWords;
            }),
          );
        });
      }
    } else {
      setState(() {
        _isListening = false;
        _speech.stop();
      });
    }
  }

  void stopListen() {
    _speech.stop();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    _fondoApp() {
      final gradiente = Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(0.0, 1.0),
                colors: [Colors.black87, Colors.black])),
      );

      return Stack(
        children: <Widget>[gradiente],
      );
    }

    return Scaffold(
        body: Stack(children: <Widget>[
          _fondoApp(),
          Container(
              padding: EdgeInsets.all(30.0),
              child: Text(_textSpeech,
                  style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.w500))),
        ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FloatingActionButton(
                onPressed: onListen,
                child: Icon(Icons.mic),
                backgroundColor: Colors.green,
              ),
              SizedBox(
                width: 40,
              ),
              SizedBox(
                child: _speech.isListening
                    ? Text(
                  "Escuchando...",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )
                    : Text(
                  'Sin escuchar',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: 40,
              ),
              FloatingActionButton(
                child: Icon(Icons.stop),
                heroTag: "btn2",
                backgroundColor: Colors.redAccent,
                onPressed: () => stopListen(),
              ),
            ],
          ),
        ));
  }
}