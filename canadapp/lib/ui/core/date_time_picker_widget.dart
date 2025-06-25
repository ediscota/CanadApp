import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class DateTimeSlotPicker extends StatefulWidget {
  final Map<DateTime, List<TimeOfDay>> prenotazioni;
  final void Function(DateTime date, TimeOfDay time) onSlotSelected;

  const DateTimeSlotPicker({
    super.key,
    required this.prenotazioni,
    required this.onSlotSelected,
  });

  @override
  _DateTimeSlotPickerState createState() => _DateTimeSlotPickerState();
}

class _DateTimeSlotPickerState extends State<DateTimeSlotPicker> {
  DateTime? selectedDate;

  final TimeOfDay startHour = TimeOfDay(hour: 8, minute: 0);
  final TimeOfDay endHour = TimeOfDay(hour: 20, minute: 0);

  List<TimeOfDay> _generateTimeSlots() {
    final List<TimeOfDay> slots = [];
    TimeOfDay current = startHour;
    while (_isBefore(current, endHour)) {
      slots.add(current);
      current = _addMinutes(current, 30);
    }
    return slots;
  }

  bool _isBefore(TimeOfDay a, TimeOfDay b) {
    return a.hour < b.hour || (a.hour == b.hour && a.minute < b.minute);
  }

  TimeOfDay _addMinutes(TimeOfDay time, int minutes) {
    final totalMinutes = time.hour * 60 + time.minute + minutes;
    return TimeOfDay(hour: totalMinutes ~/ 60, minute: totalMinutes % 60);
  }

  bool _isDayFullyBooked(DateTime day) {
    final prenotati = widget.prenotazioni[_normalizeDate(day)] ?? [];
    return prenotati.length >= _generateTimeSlots().length;
  }

  DateTime _normalizeDate(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  @override
  Widget build(BuildContext context) {
    final slots = _generateTimeSlots();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TableCalendar(
          firstDay: DateTime.now(),
          lastDay: DateTime.now().add(Duration(days: 30)),
          focusedDay: selectedDate ?? DateTime.now(),
          selectedDayPredicate: (day) => isSameDay(day, selectedDate),
          onDaySelected: (selected, _) {
            if (!_isDayFullyBooked(selected)) {
              setState(() => selectedDate = selected);
            }
          },
          enabledDayPredicate: (day) => !_isDayFullyBooked(day),
          calendarStyle: CalendarStyle(
            isTodayHighlighted: true,
            selectedDecoration: BoxDecoration(
              color: Colors.deepPurple,
              shape: BoxShape.circle,
            ),
          ),
        ),
        if (selectedDate != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  slots.map((slot) {
                    final prenotati =
                        widget.prenotazioni[_normalizeDate(selectedDate!)] ??
                        [];
                    final isBooked = prenotati.contains(slot);
                    return ElevatedButton(
                      onPressed:
                          isBooked
                              ? null
                              : () =>
                                  widget.onSlotSelected(selectedDate!, slot),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isBooked ? Colors.grey[300] : Colors.deepPurple,
                      ),
                      child: Text(
                        '${slot.hour.toString().padLeft(2, '0')}:${slot.minute.toString().padLeft(2, '0')}',
                      ),
                    );
                  }).toList(),
            ),
          ),
      ],
    );
  }
}
