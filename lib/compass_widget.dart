import 'dart:io';

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
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        double? direction = snapshot.data!.heading;
        if (direction == null)
          return Center(
            child: Text("Device does not have sensors !"),
          );
        if (Platform.isIOS) {
          ang = ((direction.round()) + 90) % 360;
        } else if (Platform.isAndroid) {
          direction.round() < 0
              ? ang = (direction.round()) + 360
              : ang = (direction.round());
        }
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
                  padding: const EdgeInsets.all(5.0),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFEBEBEB),
                  ),
                  child: Transform.rotate(
                    angle: Platform.isIOS
                        ? ((((direction.round()) + 90) % 360 ?? 0) *
                            (math.pi / 180) *
                            -1)
                        : (((direction < 0 ? direction + 360 : direction) ??
                                0) *
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
