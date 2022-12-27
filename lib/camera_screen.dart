import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'compass_widget.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key, this.cameras});
  final List<CameraDescription>? cameras;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  // bool _isRearCameraSelected = true;
  double zoom = 1.0;
  double value = 1.0;

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
          const Padding(
              padding: EdgeInsets.only(top: 50, right: 10),
              child:
                  Align(alignment: Alignment.topRight, child: CompassWidget())),
          Padding(
              padding: EdgeInsets.only(top: 50, right: 10),
              child: Align(
                  alignment: Alignment.center,
                  child: Container(
                      height: 50,
                      width: 50,
                      child: Image.asset(
                        'assets/cross2.png',
                      )))),
          Align(
            alignment: Alignment.bottomCenter,
            child: orientation == Orientation.portrait
                ? buildButtonsPortrait()
                : buildButtonsLandscape(),
          )
        ]);
      }),
    );
  }

  Widget buildButtonsPortrait() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const Spacer(),
            Expanded(
                child: MaterialButton(
              onPressed: () {
                if (value <= 10.0 && value >= 1.0) {
                  value = value + 1;
                  _cameraController.setZoomLevel(value);
                }
                setState(() => zoom = value / 5);
              },
              color: Colors.red,
              textColor: Colors.white,
              child: Icon(
                Icons.add,
                size: 24,
              ),
              padding: const EdgeInsets.all(16),
              shape: const CircleBorder(),
            )),
            Expanded(
                child: MaterialButton(
              onPressed: () {
                if (value <= 11.0 && value >= 2.0) {
                  value = value - 1;
                  _cameraController.setZoomLevel(value);
                }
                setState(() => zoom = value / 5);
              },
              color: Colors.red,
              textColor: Colors.white,
              child: Icon(
                Icons.remove,
                size: 24,
              ),
              padding: EdgeInsets.all(16),
              shape: CircleBorder(),
            )),
            const Spacer(),
          ])),
    );
  }

  Widget buildButtonsLandscape() {
    return Align(
        alignment: Alignment.bottomRight,
        child: Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.5),
            child: Column(
              children: [
                // const Spacer(),
                MaterialButton(
                  onPressed: () {
                    if (value <= 10.0 && value >= 1.0) {
                      value = value + 1;
                      _cameraController.setZoomLevel(value);
                    }
                    setState(() => zoom = value / 5);
                  },
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Icon(
                    Icons.add,
                    size: 24,
                  ),
                  padding: const EdgeInsets.all(16),
                  shape: const CircleBorder(),
                ),
                const SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  onPressed: () {
                    if (value <= 11.0 && value >= 2.0) {
                      value = value - 1;
                      _cameraController.setZoomLevel(value);
                    }
                    setState(() => zoom = value / 5);
                  },
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Icon(
                    Icons.remove,
                    size: 24,
                  ),
                  padding: EdgeInsets.all(16),
                  shape: CircleBorder(),
                ),
              ],
            )));
  }
}
