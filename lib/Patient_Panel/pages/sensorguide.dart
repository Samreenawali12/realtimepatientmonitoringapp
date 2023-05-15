
import 'package:flutter/material.dart';
class sensorguide extends StatefulWidget {
  const sensorguide({Key? key}) : super(key: key);

  @override
  State<sensorguide> createState() => _sensorguideState();
}

class _sensorguideState extends State<sensorguide> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Sensor Guide"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: size.width / 1,
              height: size.height/0.7 ,
              decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                      "assets/Images/RTHMS guide-01.png",
                                    ),
                                    fit: BoxFit.fitWidth,
                                    alignment: Alignment.center),
                              ),
            )
          ],
        ),
      ),
    );
  }

  
}
