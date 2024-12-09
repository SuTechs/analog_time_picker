import 'dart:math';

import 'package:flutter/material.dart';

class CustomTimePickerDialog extends StatefulWidget {
  const CustomTimePickerDialog({super.key});

  @override
  State<CustomTimePickerDialog> createState() => _CustomTimePickerDialogState();
}

class _CustomTimePickerDialogState extends State<CustomTimePickerDialog> {
  late int selectedHour;
  late int selectedMinute;
  bool isHourSelectionActive = true;
  bool isAm = true;

  @override
  void initState() {
    super.initState();
    final now = TimeOfDay.now();
    selectedHour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    selectedMinute = (now.minute ~/ 5) * 5;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Select Time",
        style: Theme.of(context).textTheme.labelLarge,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TimeDisplay(
            selectedHour: selectedHour,
            selectedMinute: selectedMinute,
            isHourSelectionActive: isHourSelectionActive,
            isAm: isAm,
            onHourTap: () {
              setState(() {
                isHourSelectionActive = true;
              });
            },
            onMinuteTap: () {
              setState(() {
                isHourSelectionActive = false;
              });
            },
            onAmTap: () {
              setState(() {
                isAm = true;
              });
            },
            onPmTap: () {
              setState(() {
                isAm = false;
              });
            },
          ),
          SizedBox(height: 20),

          // Dial with custom painter
          AspectRatio(
            aspectRatio: 1,
            child: GestureDetector(
              onPanUpdate: (details) {
                handlePanUpdate(details);
              },
              child: CustomPaint(
                painter: ClockPainter(
                    selectedHour, selectedMinute, isHourSelectionActive),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(
              context,
              TimeOfDay(
                hour: selectedHour % 12,
                minute: selectedMinute,
              ),
            );
          },
          child: Text("OK"),
        ),
      ],
    );
  }

  void handlePanUpdate(DragUpdateDetails details) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final offset = box.globalToLocal(details.globalPosition);
    final center = Offset(box.size.width / 2, box.size.height / 2);
    final angle = atan2(offset.dy - center.dy, offset.dx - center.dx);
    final adjustedAngle = (angle + pi / 2) % (2 * pi);

    setState(() {
      if (isHourSelectionActive) {
        selectedHour = (adjustedAngle / (2 * pi / 12)).round() % 12;
        if (selectedHour == 0) selectedHour = 12; // Adjust for hour display
      } else {
        selectedMinute = (adjustedAngle / (2 * pi / 60)).round() % 60;
        selectedMinute =
            (selectedMinute ~/ 5) * 5; // Snap to nearest five minutes
      }
    });
  }
}

class TimeDisplay extends StatelessWidget {
  final int selectedHour;
  final int selectedMinute;
  final bool isHourSelectionActive;
  final bool isAm;
  final VoidCallback onHourTap;
  final VoidCallback onMinuteTap;
  final VoidCallback onAmTap;
  final VoidCallback onPmTap;

  const TimeDisplay({
    super.key,
    required this.selectedHour,
    required this.selectedMinute,
    required this.isHourSelectionActive,
    required this.isAm,
    required this.onHourTap,
    required this.onMinuteTap,
    required this.onAmTap,
    required this.onPmTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onHourTap,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isHourSelectionActive ? Colors.purple : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              selectedHour.toString().padLeft(2, '0'),
              style: TextStyle(
                fontSize: 32,
                color: isHourSelectionActive ? Colors.white : null,
              ),
            ),
          ),
        ),
        Text(
          ":",
          style: TextStyle(fontSize: 32),
        ),
        GestureDetector(
          onTap: onMinuteTap,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: !isHourSelectionActive ? Colors.purple : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              selectedMinute.toString().padLeft(2, '0'),
              style: TextStyle(
                fontSize: 32,
                color: !isHourSelectionActive ? Colors.white : null,
              ),
            ),
          ),
        ),
        Spacer(),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: onAmTap,
              child: Text(
                "AM",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isAm ? FontWeight.bold : FontWeight.normal,
                  color: isAm ? Colors.purple : null,
                ),
              ),
            ),
            GestureDetector(
              onTap: onPmTap,
              child: Text(
                "PM",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: !isAm ? FontWeight.bold : FontWeight.normal,
                  color: !isAm ? Colors.purple : null,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ClockPainter extends CustomPainter {
  final int hour;
  final int minute;
  final bool isHourActive;

  ClockPainter(this.hour, this.minute, this.isHourActive);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw clock face
    Paint paintCircle = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
        size.center(Offset.zero), size.width / 2 - 10, paintCircle);

    // Draw hour markers
    for (int i = 1; i <= 12; i++) {
      double angle = (i * pi / 6); // Each hour is π/6 radians apart
      double xOuter =
          size.width / 2 + cos(angle - pi / 2) * (size.width / 2 - 30);
      double yOuter =
          size.height / 2 + sin(angle - pi / 2) * (size.height / 2 - 30);

      // Draw hour text
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: '$i',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
          canvas,
          Offset(
              xOuter - textPainter.width / 2, yOuter - textPainter.height / 2));
    }

    // Draw minute markers
    for (int i = 0; i < 60; i += 5) {
      double angle = (i * pi / 30); // Each minute is π/30 radians apart
      double xOuter =
          size.width / 2 + cos(angle - pi / 2) * (size.width / 2 - 50);
      double yOuter =
          size.height / 2 + sin(angle - pi / 2) * (size.height / 2 - 50);

      // Draw minute text
      TextPainter minuteTextPainter = TextPainter(
        text: TextSpan(
          text: '$i',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        textDirection: TextDirection.ltr,
      );
      minuteTextPainter.layout();
      minuteTextPainter.paint(
          canvas,
          Offset(xOuter - minuteTextPainter.width / 2,
              yOuter - minuteTextPainter.height / 2));
    }

    // Draw hour hand
    double hourAngle = ((hour % 12) + (minute / 60)) * pi / 6;
    drawHand(
        canvas,
        size.center(Offset.zero),
        hourAngle,
        size.width * .25,
        Paint()
          ..color = Colors.blue
          ..strokeWidth = 8
          ..style = PaintingStyle.stroke);

    // Draw minute hand
    double minuteAngle = minute * pi / 30;
    drawHand(
        canvas,
        size.center(Offset.zero),
        minuteAngle,
        size.width * .35,
        Paint()
          ..color = Colors.red
          ..strokeWidth = 4
          ..style = PaintingStyle.stroke);

    // Draw center point
    canvas.drawCircle(size.center(Offset.zero), size.width * .05,
        Paint()..color = Colors.black);
  }

  void drawHand(
      Canvas canvas, Offset center, double angle, double length, Paint paint) {
    final xEnd = center.dx + cos(angle - pi / 2) * length;
    final yEnd = center.dy + sin(angle - pi / 2) * length;
    canvas.drawLine(center, Offset(xEnd, yEnd), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
