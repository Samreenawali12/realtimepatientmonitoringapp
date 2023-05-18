import 'package:dbtest/Patient_Panel/pages/vitals.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class ModelTester extends StatefulWidget {
  const ModelTester({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ModelTesterState createState() => _ModelTesterState();
}

class _ModelTesterState extends State<ModelTester> {
  late Interpreter _interpreter;
  final List<double> _input = [
    double.parse(temprature.value),
    double.parse(oxygen.value),
    double.parse(BPM.value)
  ];
  late List<List<double>> _output;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    getUpdatedVitals();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('mymodel.tflite');
      setState(() {
        _isLoaded = true;
      });
    } catch (e) {
      // ignore: avoid_print
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
        // ignore: avoid_print
        print(message);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Result'),
              content: Text(message),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } catch (e) {
        // ignore: avoid_print
        print('Failed to run inference. $e');
      }
    } else {
      // ignore: avoid_print
      print('Interpreter is not initialized');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("hoja sim sim"),
      ),
      body: Center(
        child: _isLoaded
            ? ElevatedButton(
                onPressed: _runInference,
                child: const Text('Predict'),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
