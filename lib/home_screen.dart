import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video/camera_screen.dart';

import 'button.dart';
import 'compass_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.cameras});
  final List<CameraDescription>? cameras;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  final TextEditingController _numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            top: false,
            bottom: false,
            left: false,
            right: false,
            child: buildBody())
        // CameraScreen(cameras: widget.cameras)),
        );
  }

  Widget buildBody() {
    // print(_numberController.text);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.3,
                left: MediaQuery.of(context).size.width * 0.3),
            child: TextField(
              controller: _numberController,
              decoration: const InputDecoration(labelText: "Enter azimuth"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            )),
        Padding(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.4,
                left: MediaQuery.of(context).size.width * 0.4,
                top: 10),
            child: ButtonDarker(context, "START", () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                      create: (_) => CompassManager(),
                      child: CameraScreen(
                          cameras: widget.cameras,
                          chosenAngle: _numberController.text)),
                ),
              );
            })),
      ],
    );
  }
}
