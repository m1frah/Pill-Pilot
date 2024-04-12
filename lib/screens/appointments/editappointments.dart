import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:pillapp/database/sql_helper.dart';

class EditAppointmentPage extends StatefulWidget {
  final Map<String, dynamic> appointment;

  EditAppointmentPage({Key? key, required this.appointment}) : super(key: key);

  @override
  _EditAppointmentPageState createState() => _EditAppointmentPageState();
}

class _EditAppointmentPageState extends State<EditAppointmentPage> {
  late TextEditingController _titleController;
  late TextEditingController _locationController;
  late TextEditingController _dateTimeController;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.appointment['title']);
    _locationController = TextEditingController(text: widget.appointment['location']);
    _dateTimeController = TextEditingController(text: widget.appointment['dateTime']);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _dateTimeController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    await SQLHelper.updateApp(
      widget.appointment['id'],
      _titleController.text,
      _locationController.text,
      _dateTimeController.text,
    );

    Navigator.pop(context);
  }

  Future<void> _deleteAppointment() async {
    try {
      await SQLHelper.deleteApp(widget.appointment['id']);
      Navigator.pop(context);
    } catch (err) {
      debugPrint("Error deleting appointment: $err");
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 365)), // One year ago
      lastDate: DateTime.now().add(Duration(days: 365)), // One year from now
    );

    if (pickedDateTime != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      );

      if (pickedTime != null) {
        final DateTime selectedDateTime = DateTime(
          pickedDateTime.year,
          pickedDateTime.month,
          pickedDateTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          _dateTimeController.text = DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Appointment Title'),
            ),
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(labelText: 'Location'),
            ),
            TextFormField(
              controller: _dateTimeController,
              readOnly: true, // Make the field read-only
              onTap: () => _selectDateTime(context), // Open date-time picker on tap
              decoration: InputDecoration(labelText: 'Date and Time'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _deleteAppointment,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  ),
                  icon: Icon(Icons.delete, color: Colors.white),
                  label: Text(
                    'Delete',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: _saveChanges,
                  child: Text('Save Changes'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
