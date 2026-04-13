import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/schedule_provider.dart';

class TaskInputScreen extends StatefulWidget {
  const TaskInputScreen({super.key});
  @override
  State<TaskInputScreen> createState() => _TaskInputScreenState();
}

class _TaskInputScreenState extends State<TaskInputScreen> {
  final _formKey = GlobalKey<FormState>();

  String _title = '';
  String _category = 'Class';
  DateTime _date = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 1);
  double _urgency = 3, _importance = 3, _effort = 1.0;
  String _energy = 'Medium';

  final List<String> _cats = ['Class', 'Org Work', 'Study', 'Rest', 'Other'];
  final List<String> _energies = ['Low', 'Medium', 'High'];

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: const Color(0xFF1C1C21),
              hourMinuteColor: const Color(0xFF2E2E36),
              hourMinuteTextColor: const Color(0xFFF1F0F5),
              dialBackgroundColor: const Color(0xFF2E2E36),
              dialHandColor: const Color(0xFFF472B6),
              dialTextColor: const Color(0xFFF1F0F5),
              entryModeIconColor: const Color(0xFFF472B6),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => isStart ? _startTime = picked : _endTime = picked);
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Provider.of<ScheduleProvider>(context, listen: false).AddTask(
        title: _title, category: _category, date: _date,
        startTime: _startTime, endTime: _endTime,
        urgency: _urgency.toInt(), importance: _importance.toInt(),
        estimatedEffortHours: _effort, energyLevel: _energy,
      );
      Navigator.pop(context);
    }
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: GoogleFonts.dmSans(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF666672),
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C21),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF2E2E36)),
            ),
            child: const Icon(Icons.arrow_back_ios_new, size: 14, color: Color(0xFFAAAAAA)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // Task Title
              _sectionLabel('TASK TITLE'),
              TextFormField(
                style: GoogleFonts.dmSans(fontSize: 14, color: const Color(0xFFF1F0F5)),
                decoration: const InputDecoration(hintText: 'e.g. Math Lecture'),
                onSaved: (value) => _title = value!,
                validator: (value) => value == null || value.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 20),

              // Category
              _sectionLabel('CATEGORY'),
              DropdownButtonFormField<String>(
                value: _category,
                dropdownColor: const Color(0xFF1C1C21),
                style: GoogleFonts.dmSans(fontSize: 14, color: const Color(0xFFF1F0F5)),
                decoration: const InputDecoration(),
                icon: const Icon(Icons.expand_more, color: Color(0xFF666672), size: 18),
                items: _cats.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) => setState(() => _category = val!),
              ),
              const SizedBox(height: 20),

              // Time Row
              _sectionLabel('TIME'),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _pickTime(true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C1C21),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF2E2E36)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Start', style: GoogleFonts.dmSans(fontSize: 10, color: const Color(0xFF666672))),
                            const SizedBox(height: 2),
                            Text(
                              _startTime.format(context),
                              style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w500, color: const Color(0xFFF472B6)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _pickTime(false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C1C21),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF2E2E36)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('End', style: GoogleFonts.dmSans(fontSize: 10, color: const Color(0xFF666672))),
                            const SizedBox(height: 2),
                            Text(
                              _endTime.format(context),
                              style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w500, color: const Color(0xFFF1F0F5)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Urgency Slider
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _sectionLabel('URGENCY'),
                  Text(
                    _urgency.round().toString(),
                    style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFFF472B6)),
                  ),
                ],
              ),
              Slider(
                value: _urgency, min: 1, max: 5, divisions: 4,
                label: _urgency.round().toString(),
                onChanged: (val) => setState(() => _urgency = val),
              ),
              const SizedBox(height: 8),

              // Importance Slider
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _sectionLabel('IMPORTANCE'),
                  Text(
                    _importance.round().toString(),
                    style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFFF472B6)),
                  ),
                ],
              ),
              Slider(
                value: _importance, min: 1, max: 5, divisions: 4,
                label: _importance.round().toString(),
                onChanged: (val) => setState(() => _importance = val),
              ),
              const SizedBox(height: 20),

              // Energy Level
              _sectionLabel('ENERGY LEVEL'),
              Row(
                children: _energies.map((e) {
                  final selected = _energy == e;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _energy = e),
                      child: Container(
                        margin: EdgeInsets.only(right: e != _energies.last ? 8 : 0),
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        decoration: BoxDecoration(
                          color: selected ? const Color(0xFFF472B6).withOpacity(0.12) : const Color(0xFF1C1C21),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selected ? const Color(0xFFF472B6) : const Color(0xFF2E2E36),
                            width: selected ? 1.5 : 1,
                          ),
                        ),
                        child: Text(
                          e,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                            color: selected ? const Color(0xFFF472B6) : const Color(0xFF666672),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Submit
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Text(
                    'Add Task to Timeline',
                    style: GoogleFonts.dmSans(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}