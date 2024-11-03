import 'dart:math';
import 'package:compass_app/constans/app_color.dart';
import 'package:compass_app/widgets/compass_view_painter.dart';
import 'package:compass_app/widgets/neumorphism.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';

class CompassScreen extends StatefulWidget {
  const CompassScreen({super.key});

  @override
  State<CompassScreen> createState() => _CompassScreenState();
}

class _CompassScreenState extends State<CompassScreen> {
  double? direction;
  double headingToDegree(double heading) {
    return heading < 0 ? 360 - heading.abs() : heading;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: StreamBuilder<CompassEvent>(
          stream: FlutterCompass.events,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text("Error reading heading");
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            direction = snapshot.data!.heading;
            if (direction == null) {
              return const Text("Device does not have sensors");
            }
            return Stack(
              children: [
                Neumorphism(
                  margin: EdgeInsets.all(size.width * 0.1),
                  padding: const EdgeInsets.all(10),
                  child: Transform.rotate(
                    angle: (direction! * (pi / 180) * -1),
                    child: CustomPaint(
                      size: size,
                      painter: CompassViewPainter(color: AppColor.grey),
                    ),
                  ),
                ),
                CenterDisplayMeter(direction: headingToDegree(direction!)),
                Positioned.fill(
                  top: size.height * 0.28,
                  child: Column(
                    children: [
                      // Container(
                      //   width: 10,
                      //   height: 10,
                      //   decoration: BoxDecoration(
                      //     color: AppColor.red,
                      //     boxShadow: [
                      //       BoxShadow(
                      //         color: Colors.grey.shade500,
                      //         blurRadius: 5,
                      //         offset: const Offset(10, 10),
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      Container(
                        width: 5,
                        height: size.width * .21,
                        decoration: BoxDecoration(
                            color: AppColor.red,
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(10),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade500,
                                blurRadius: 5,
                                offset: const Offset(10, 10),
                              ),
                            ]),
                      )
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }
}

class CenterDisplayMeter extends StatelessWidget {
  const CenterDisplayMeter({super.key, required this.direction});

  final double direction;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Neumorphism(
      margin: EdgeInsets.all(size.width * 0.27),
      distance: 2.5,
      blur: 5,
      child: Neumorphism(
        margin: EdgeInsets.all(size.width * 0.01),
        distance: 0,
        blur: 0,
        innerShadow: true,
        isReverse: true,
        child: Neumorphism(
          margin: EdgeInsets.all(size.width * 0.05),
          distance: 4,
          blur: 5,
          child: TopGradientContainer(
            padding: EdgeInsets.all(size.width * 0.02),
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColor.greenColor,
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment(-5, -5),
                  end: Alignment.bottomRight,
                  colors: [
                    AppColor.greenDarkColor,
                    AppColor.greenColor,
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    removeLeadingZero(
                        "${direction.toInt().toString().padLeft(3, '0')}°"),
                    style: TextStyle(
                      color: AppColor.black,
                      fontSize: size.width * 0.1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    getDirection(direction),
                    style: TextStyle(
                      color: AppColor.black,
                      fontSize: size.width * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String getDirection(double direction) {
    if (direction >= 337.5 || direction < 22.5) {
      return "N";
    } else if (direction >= 22.5 && direction < 67.5) {
      return "NE";
    } else if (direction >= 67.5 && direction < 112.5) {
      return "E";
    } else if (direction >= 112.5 && direction < 157.5) {
      return "SE";
    } else if (direction >= 157.5 && direction < 202.5) {
      return "S";
    } else if (direction >= 202.5 && direction < 247.5) {
      return "SW";
    } else if (direction >= 247.5 && direction < 292.5) {
      return "W";
    } else if (direction >= 292.5 && direction < 337.5) {
      return "NW";
    } else {
      return "N";
    }
  }
}

String removeLeadingZero(String input) {
  if (input.startsWith('0') && input.length > 1) {
    return " ${input.replaceFirst(RegExp(r'^0+'), '')}";
  }
  return " $input";
}
