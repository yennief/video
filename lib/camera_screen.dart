import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:video/compass_manager.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'compass_widget.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key, this.cameras, this.chosenAngle});
  final List<CameraDescription>? cameras;
  final int? chosenAngle;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  double zoom = 0.0;
  double lowerValue = 0.0;
  int ang = 0;
  bool isChosen = false;

  Future initCamera(CameraDescription cameraDescription) async {
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);

    try {
      await _cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  @override
  void initState() {
    super.initState();
    initCamera(widget.cameras![0]);
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ang = Provider.of<CompassManager>(context, listen: true).getAng;
    if (ang == widget.chosenAngle) {
      isChosen = true;
      FlutterBeep.beep();
      //play the loudest sound
    } else {
      isChosen = false;
    }
    if (ang + 10 == widget.chosenAngle || ang - 10 == widget.chosenAngle) {
      //play one sound
      FlutterBeep.playSysSound(iOSSoundIDs.AudioToneError);
    }
    if (ang + 5 == widget.chosenAngle || ang - 5 == widget.chosenAngle) {
      //play louder sound
      FlutterBeep.beep(false);
    }

    return Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        return Stack(children: [
          (_cameraController.value.isInitialized)
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: CameraPreview(_cameraController))
              : Container(
                  color: Colors.white,
                  child: const Center(child: CircularProgressIndicator())),
          Padding(
              padding: EdgeInsets.only(top: 10, left: 40),
              child: Text(
                "$ang",
                style: TextStyle(
                  color: isChosen ? Colors.green : Colors.red,
                  fontSize: 80,
                ),
              )),
          Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.75, left: 40),
              child: Align(
                  alignment: Alignment.bottomLeft, child: CompassWidget())),
          Padding(
              padding: EdgeInsets.only(top: 50, right: 10),
              child: Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/krzyż.png',
                  ))),
          Align(
            alignment: Alignment.bottomCenter,
            child: buildButtonsLandscape(),
          )
        ]);
      }),
    );
  }

  // Widget buildButtonsPortrait() {
  //   return Align(
  //     alignment: Alignment.bottomCenter,
  //     child: Padding(
  //         padding: const EdgeInsets.only(bottom: 50),
  //         child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
  //           const Spacer(),
  //           SfSlider.vertical(
  //             min: 0.0,
  //             max: 10.0,
  //             value: lowerValue,
  //             // interval: 1,
  //             // showTicks: true,
  //             // showLabels: true,
  //             //  showTooltip: true,
  //             minorTicksPerInterval: 1,
  //             onChanged: (dynamic value) {
  //               if (value <= 8.0 && value >= 1.0) {
  //                 _cameraController.setZoomLevel(value);
  //               }
  //               setState(() {
  //                 zoom = value / 10;
  //                 lowerValue = value;
  //               });
  //             },
  //           ),
  //           // const Spacer(),
  //         ])),
  //   );
  // }

  Widget buildButtonsLandscape() {
    return Align(
        alignment: Alignment.bottomRight,
        child: Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
            child: Column(
              children: [
                // const Spacer(),
                Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.85),
                    child: SfSlider.vertical(
                      activeColor: Colors.orange,
                      min: 0.0,
                      max: 10.0,
                      value: lowerValue,
                      minorTicksPerInterval: 1,
                      onChanged: (dynamic value) {
                        if (value <= 8.0 && value >= 1.0) {
                          _cameraController.setZoomLevel(value);
                        }
                        setState(() {
                          zoom = value / 10;
                          lowerValue = value;
                        });
                      },
                    )),
              ],
            )));
  }
}
