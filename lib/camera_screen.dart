import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:video/compass_manager.dart';
import 'compass_widget.dart';
import 'package:audioplayers/audioplayers.dart';

class CameraScreen extends StatefulWidget {
  CameraScreen({super.key, this.cameras, this.chosenAngle});
  final List<CameraDescription>? cameras;
  final String? chosenAngle;
  int? angle;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  double zoom = 0.0;
  double lowerValue = 0.0;
  int ang = 0;
  bool isChosen = false;
  late AudioPlayer audioPlayer;

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
    audioPlayer = AudioPlayer();
    // audioPlayer.setSourceAsset("");
    initCamera(widget.cameras![0]);
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.chosenAngle != "") {
      widget.angle = int.parse(widget.chosenAngle!);
    } else {
      widget.angle = null;
    }
    ang = Provider.of<CompassManager>(context, listen: true).getAng;

    if (widget.angle != null && ang == widget.angle) {
      isChosen = true;
      audioPlayer.play(AssetSource("long-beep.mp3"));
      Future.delayed(const Duration(seconds: 2)).then((value) {
        audioPlayer.stop();
      });
    } else {
      isChosen = false;
    }
    for (int i = 10; i > 0; i--) {
      if (widget.angle != null &&
          (ang + i == widget.angle || ang - i == widget.angle)) {
        if (i <= 10 && i > 5) {
          audioPlayer.play(AssetSource("beep.mp3"));
          audioPlayer.setPlaybackRate(1.0);
        } else if (i <= 5 && i > 2) {
          audioPlayer.play(AssetSource("beep.mp3"));
          audioPlayer.setPlaybackRate(2.0);
        } else {
          audioPlayer.play(AssetSource("beep.mp3"));
          audioPlayer.setPlaybackRate(3.0);
        }
      }
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
          title: Text(""),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios))),
      body: OrientationBuilder(builder: (context, orientation) {
        return Stack(children: [
          (_cameraController.value.isInitialized)
              ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: CameraPreview(_cameraController))
              : Container(
                  color: Colors.white,
                  child: const Center(child: CircularProgressIndicator())),
          Padding(
              padding: const EdgeInsets.only(top: 10, left: 40),
              child: Text(
                "$ang",
                style: TextStyle(
                    color: isChosen ? Colors.green : Colors.red,
                    fontSize: 80,
                    fontFamily: 'digi'),
              )),
          Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.75, left: 40),
              child: const Align(
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
