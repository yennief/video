import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_compass/flutter_compass.dart';

class CompassWidget extends StatelessWidget {
  const CompassWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildCompass(context);
  }

  Widget _buildCompass(BuildContext context) {
    double width = 70;
    double height = 70;
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error reading heading: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        double? direction = snapshot.data!.heading;
        if (direction == null)
          return Center(
            child: Text("Device does not have sensors !"),
          );

        int ang = (direction.round());
        return Stack(
          children: [
            Column(
              children: [
                Container(
                  width: width,
                  height: height,
                  padding: EdgeInsets.all(5.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFEBEBEB),
                  ),
                  child: Transform.rotate(
                    angle: ((direction ?? 0) * (math.pi / 180) * -1),
                    child: Image.asset('assets/compass.png'),
                  ),
                ),
                Text(
                  "$ang",
                  style: TextStyle(
                    color: Color(0xFFEBEBEB),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            Positioned(
              // center of the screen - half the width of the rectangle
              left: (width / 2) - ((width / 80) / 2),
              // height - width is the non compass vertical space, half of that
              top: (height - width) / 2,
              child: SizedBox(
                width: width / 80,
                height: width / 10,
                child: Container(
                  //color: HSLColor.fromAHSL(0.85, 0, 0, 0.05).toColor(),
                  color: Color(0xBBEBEBEB),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
