import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  late final List<CameraDescription>? cameras;
  await availableCameras().then((value) => cameras = value);
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ],
  );
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, this.cameras});
  final List<CameraDescription>? cameras;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(cameras: cameras),
    );
  }
}
