import 'package:flutter/material.dart';

Container ButtonDarker(BuildContext context, String title, Function onTap,
    {bool shouldExpand = true,
    double width = 0.6,
    double height = 0.06,
    EdgeInsets margin = const EdgeInsets.fromLTRB(0, 10, 0, 30)}) {
  return Container(
    width: shouldExpand
        ? MediaQuery.of(context).size.width - 40
        : MediaQuery.of(context).size.width * width,
    height: shouldExpand ? 50 : MediaQuery.of(context).size.height * height,
    margin: margin,
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>(0),
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Color.fromARGB(255, 164, 30, 30);
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
  );
}
