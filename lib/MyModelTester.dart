import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class ModelTester extends StatefulWidget {
  @override
  _ModelTesterState createState() => _ModelTesterState();
}

class _ModelTesterState extends State<ModelTester> {
  late Interpreter _interpreter;
  List<double> _input = [0.0, 98.0, 60.0];
  late List<List<double>> _output;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }
  // getVitals() async{
  // retrieval code
  // }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('mymodel.tflite');
      setState(() {
        _isLoaded = true;
      });
    } catch (e) {
      print('Failed to load model. $e');
    }
  }

  Future<void> _runInference() async {
    if (_isLoaded) {
      try {
        _output = List.generate(1, (_) => List.filled(1, 0.0));
        _interpreter.run(_input, _output);

        double result = _output[0][0];
        String message = result > 0.5 ? 'Normal' : 'Critical';
        print(message);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Result'),
              content: Text(message),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } catch (e) {
        print('Failed to run inference. $e');
      }
    } else {
      print('Interpreter is not initialized');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("hoja sim sim"),
      ),
      body: Center(
        child: _isLoaded
            ? ElevatedButton(
                onPressed: _runInference,
                child: Text('Predict'),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
