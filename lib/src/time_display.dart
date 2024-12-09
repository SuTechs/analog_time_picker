import 'package:flutter/material.dart';

/// Display the selected time and allow the user to switch
/// between hours and minutes and AM/PM
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
