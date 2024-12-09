import 'dart:math';

import 'package:flutter/material.dart';

/// Custom painter to draw the clock face and hands
class ClockPainter extends CustomPainter {
  final int hour;
  final int minute;
  final bool isHourActive;
  final bool isAm;
  final TimeOfDay? minTime;
  final TimeOfDay? maxTime;

  ClockPainter(
    this.hour,
    this.minute,
    this.isHourActive,
    this.minTime,
    this.maxTime,
    this.isAm,
  );

  @override
  void paint(Canvas canvas, Size size) {
    /// Draw clock face
    Paint paintCircle = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
        size.center(Offset.zero), size.width / 2 - 10, paintCircle);

    /// Draw hour markers
    for (int i = 1; i <= 12; i++) {
      double angle = (i * pi / 6); // Each hour is π/6 radians apart
      double xOuter =
          size.width / 2 + cos(angle - pi / 2) * (size.width / 2 - 60);
      double yOuter =
          size.height / 2 + sin(angle - pi / 2) * (size.height / 2 - 60);

      // Draw hour text
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: '$i',
          style: TextStyle(
            fontSize: 16,
            color: isTimeAllowed(i, 0) ? Colors.black : Colors.grey,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
          canvas,
          Offset(
              xOuter - textPainter.width / 2, yOuter - textPainter.height / 2));
    }

    /// Draw minute markers
    for (int i = 0; i < 60; i += 5) {
      double angle = (i * pi / 30); // Each minute is π/30 radians apart
      double xOuter =
          size.width / 2 + cos(angle - pi / 2) * (size.width / 2 - 30);
      double yOuter =
          size.height / 2 + sin(angle - pi / 2) * (size.height / 2 - 30);

      // Draw minute text
      TextPainter minuteTextPainter = TextPainter(
        text: TextSpan(
          text: '$i',
          style: TextStyle(
            fontSize: 12,
            color: isTimeAllowed(hour, i) ? Colors.black54 : Colors.grey,
          ),
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
        ..style = PaintingStyle.stroke,
    );

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
        ..style = PaintingStyle.stroke,
    );

    /// Draw center point
    canvas.drawCircle(size.center(Offset.zero), size.width * .05,
        Paint()..color = Colors.black);
  }

  /// Check if the selected time is within the allowed range
  bool isTimeAllowed(int hour, int minute) {
    final selectedTime =
        TimeOfDay(hour: isAm ? hour % 12 : (hour % 12) + 12, minute: minute);
    final minTime = this.minTime;
    final maxTime = this.maxTime;

    if (minTime != null && selectedTime.isBefore(minTime)) {
      return false;
    } else if (maxTime != null && selectedTime.isAfter(maxTime)) {
      return false;
    }

    return true;
  }

  /// Draw clock hands
  void drawHand(
    Canvas canvas,
    Offset center,
    double angle,
    double length,
    Paint paint,
  ) {
    final xEnd = center.dx + cos(angle - pi / 2) * length;
    final yEnd = center.dy + sin(angle - pi / 2) * length;
    canvas.drawLine(center, Offset(xEnd, yEnd), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
