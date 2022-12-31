import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_compass/flutter_compass.dart';
import 'package:provider/provider.dart';

import 'compass_manager.dart';

class CompassWidget extends StatelessWidget {
  const CompassWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildCompass(context);
  }

  Widget _buildCompass(BuildContext context) {
    double width = 70;
    double height = 70;
    int ang = 0;
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
        ang = ((direction.round()) + 90) % 360;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Provider.of<CompassManager>(context, listen: false).setAng(ang);
        });
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
                    angle: ((((direction.round()) + 90) % 360 ?? 0) *
                        (math.pi / 180) *
                        -1),
                    child: Image.asset('assets/compass.png'),
                  ),
                ),
              ],
            ),
            Positioned(
              left: (width / 2) - ((width / 80) / 2),
              top: (height - width) / 2,
              child: SizedBox(
                width: width / 80,
                height: width / 10,
              ),
            ),
          ],
        );
      },
    );
  }
}
