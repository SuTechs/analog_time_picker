import 'dart:math';

import 'package:flutter/material.dart';

import 'clock_painter.dart';
import 'time_display.dart';

class AnalogTimePickerDialog extends StatefulWidget {
  final TimeOfDay? initialTime;
  final TimeOfDay? minTime;
  final TimeOfDay? maxTime;

  const AnalogTimePickerDialog({
    super.key,
    this.initialTime,
    this.minTime,
    this.maxTime,
  });

  @override
  State<AnalogTimePickerDialog> createState() => _AnalogTimePickerDialogState();

  static Future<TimeOfDay?> show(
    BuildContext context, {
    TimeOfDay? initialTime,
    TimeOfDay? minTime,
    TimeOfDay? maxTime,
  }) {
    return showDialog<TimeOfDay>(
      context: context,
      builder: (context) {
        return AnalogTimePickerDialog(
          initialTime: initialTime,
          minTime: minTime,
          maxTime: maxTime,
        );
      },
    );
  }
}

class _AnalogTimePickerDialogState extends State<AnalogTimePickerDialog> {
  late int selectedHour;
  late int selectedMinute;
  bool isHourSelectionActive = true;
  bool isAm = true;

  @override
  void initState() {
    super.initState();

    // Initialize selected time based on provided initial time or current time
    final time = widget.initialTime ?? TimeOfDay.now();

    final minTime = widget.minTime;
    final maxTime = widget.maxTime;

    if (minTime != null && time.isBefore(minTime)) {
      _updateSelectedTime(minTime);
    } else if (maxTime != null && time.isAfter(maxTime)) {
      _updateSelectedTime(maxTime);
    } else {
      _updateSelectedTime(time);
    }
  }

  void _updateSelectedTime(TimeOfDay time) {
    selectedHour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    selectedMinute = time.minute ~/ 5 * 5;
    isAm = time.hour < 12; // Determine AM/PM
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16),
      title: Text(
        "Select Time",
        style: Theme.of(context).textTheme.labelLarge,
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Time display
            TimeDisplay(
              selectedHour: selectedHour,
              selectedMinute: selectedMinute,
              isHourSelectionActive: isHourSelectionActive,
              isAm: isAm,
              onHourTap: () => setState(() => isHourSelectionActive = true),
              onMinuteTap: () => setState(() => isHourSelectionActive = false),
              onAmTap: () => setState(() => isAm = true),
              onPmTap: () => setState(() => isAm = false),
            ),
            SizedBox(height: 16),

            /// Dial with custom painter
            AspectRatio(
              aspectRatio: 1,
              child: GestureDetector(
                onPanUpdate: (details) {
                  handlePanUpdate(details);
                },
                child: CustomPaint(
                  painter: ClockPainter(
                    selectedHour,
                    selectedMinute,
                    isHourSelectionActive,
                    widget.minTime,
                    widget.maxTime,
                    isAm,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        /// Cancel button
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: Text("Cancel"),
        ),

        /// OK button
        TextButton(
          onPressed: () {
            final hour = isAm ? selectedHour % 12 : (selectedHour % 12) + 12;

            final minTime = widget.minTime;
            final maxTime = widget.maxTime;

            final selectedTime = TimeOfDay(
              hour: hour,
              minute: selectedMinute,
            );

            if (minTime != null && selectedTime.isBefore(minTime)) {
              Navigator.pop(context);
            } else if (maxTime != null && selectedTime.isAfter(maxTime)) {
              Navigator.pop(context);
            } else {
              Navigator.pop(context, selectedTime);
            }
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

    /// Update selected hour or minute based on the active selection
    setState(() {
      if (isHourSelectionActive) {
        selectedHour = (adjustedAngle / (2 * pi / 12)).round() % 12;
        if (selectedHour == 0) selectedHour = 12;
      } else {
        selectedMinute = (adjustedAngle / (2 * pi / 60)).round() % 60;
        selectedMinute = (selectedMinute ~/ 5) * 5;
      }

      /// Check if the new time falls within the allowed range and adjust accordingly
      final newSelectedTime = TimeOfDay(
          hour: selectedHour % 12 + (isAm ? 0 : 12), minute: selectedMinute);

      final minTime = widget.minTime;
      final maxTime = widget.maxTime;

      if (minTime != null && newSelectedTime.isBefore(minTime)) {
        _updateSelectedTime(minTime);
        return;
      } else if (maxTime != null && newSelectedTime.isAfter(maxTime)) {
        _updateSelectedTime(maxTime);
        return;
      }

      selectedHour =
          newSelectedTime.hour % 12 == 0 ? 12 : newSelectedTime.hour % 12;
      selectedMinute = newSelectedTime.minute;
    });
  }
}
