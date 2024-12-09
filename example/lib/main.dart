import 'package:analog_time_picker/analog_time_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Time Picker Demo',
      home: const HomeScreen(),
    );
  }
}

/// Home Page
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Picker Demo'),
      ),

      // body
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Selected Time:',
              style: const TextStyle(fontSize: 16),
            ),

            // Selected Time
            Text(
              _selectedTime.format(context),
              style: const TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),

      // Floating Action Button
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Material Floating Action Button
          FloatingActionButton.extended(
            onPressed: () {
              showTimePicker(
                context: context,
                initialTime: _selectedTime,
              ).then((TimeOfDay? time) {
                if (time != null) {
                  setState(() {
                    _selectedTime = time;
                  });
                }
              });
            },
            icon: const Icon(Icons.access_time),
            label: Text('Open Material Picker'),
          ),
          SizedBox(height: 32),

          /// Better Time Picker Floating Action Button
          FloatingActionButton.extended(
            onPressed: () async {
              final time = await showCustomTimePicker(context);
              if (time != null) {
                setState(() {
                  _selectedTime = time;
                });
              }
            },
            icon: const Icon(Icons.access_time),
            label: Text('Open Better Picker'),
          ),
        ],
      ),
    );
  }

  Future<TimeOfDay?> showCustomTimePicker(BuildContext context) {
    return showDialog<TimeOfDay>(
      context: context,
      builder: (context) {
        return CustomTimePickerDialog();
      },
    );
  }
}