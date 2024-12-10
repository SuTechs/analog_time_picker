# Analog Time Picker Plugin
[Live Preview on FlutterSuro](https://fluttersuro.com/shot/2d191a8e67ce6ebafb6a7fec4fd115cd)

A customizable analog time picker for Flutter that allows users to select time easily with an intuitive interface. This plugin supports AM/PM selections, restricts time ranges, and provides an elegant clock UI.

## Example Preview
<img src="https://raw.githubusercontent.com/SuTechs/analog_time_picker/refs/heads/main/demo.png" alt="Analog Time Picker Preview" width="280">

## Features

- **Customizable Initial Time**: Set the initial time when the picker is opened.
- **Time Range Restrictions**: Prevent users from selecting times outside a specified range (e.g., past times).
- **AM/PM Support**: Easily switch between AM and PM formats.
- **Intuitive UI**: A visually appealing analog clock interface for time selection.
- **User Interaction**: Users can drag the hands of the clock or tap on hour/minute markers to select time.

## Installation

To use the Analog Time Picker in your Flutter project, add it to your `pubspec.yaml`:

```yaml
dependencies:
  better_analog_time_picker: ^0.0.2
```

## Usage
To display the Analog Time Picker, use the following code snippet:
```dart
final currentTime = TimeOfDay.now();
final minTime = TimeOfDay(hour: currentTime.hour, minute: currentTime.minute + 10); // Example minimum time

final time = await AnalogTimePickerDialog.show(
  context,
  initialTime: currentTime,
  minTime: minTime,
  // maxTime: TimeOfDay(hour: currentTime.hour + 2, minute: currentTime.minute + 10), // Optional max time
);
```

## Parameters:
- `initialTime`: The initial time displayed when the picker opens.
- `minTime`: The minimum allowed time (e.g., to prevent past time selection).
- `maxTime`: The maximum allowed time (optional).

## Example Usage
```dart
ElevatedButton(
  onPressed: () async {
    final selectedTime = await AnalogTimePickerDialog.show(
      context,
      initialTime: currentTime,
      minTime: minTime,
      // maxTime: TimeOfDay(hour: currentTime.hour + 2, minute: currentTime.minute + 10),
    );

    if (selectedTime != null) {
      // Handle selected time
      print("Selected Time: ${selectedTime.format(context)}");
    }
  },
  child: const Text("Pick a Time"),
)
```
## Pub Link
The package is on [Pub.dev](https://pub.dev/packages/better_analog_time_picker).

## Customization
You can customize the appearance of the clock by modifying the ClockPainter class in the plugin. Adjust colors, sizes, and styles to fit your app's design.

## Contributing
Contributions are welcome! If you have suggestions or improvements, please create a pull request or open an issue.

## License
This project is licensed under the MIT License. See the LICENSE file for details.
