import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:video/camera_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          top: false,
          bottom: false,
          left: false,
          right: false,
          child: CameraScreen(cameras: widget.cameras)),
    );
  }
}
