import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:canadapp/ui/viewmodels/sala_pesi_view_model.dart';

void showCalendarBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: CalendarPrenotazione(),
      );
    },
  );
}

class CalendarPrenotazione extends StatefulWidget {
  @override
  _CalendarPrenotazioneState createState() => _CalendarPrenotazioneState();
}

class _CalendarPrenotazioneState extends State<CalendarPrenotazione> {
  DateTime _selectedDay = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay(hour: 9, minute: 0);

  @override
  Widget build(BuildContext context) {
    final salaPesiViewModel = context.read<SalaPesiViewModel>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TableCalendar(
          focusedDay: _selectedDay,
          firstDay: DateTime.now(),
          lastDay: DateTime.now().add(Duration(days: 365)),
          selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
            });
          },
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Ora: ${_selectedTime.format(context)}'),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: () async {
                final pickedTime = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime,
                );
                if (pickedTime != null) {
                  setState(() {
                    _selectedTime = pickedTime;
                  });
                }
              },
              child: Text('Seleziona Ora'),
            ),
          ],
        ),
        SizedBox(height: 24),
        ElevatedButton(
          onPressed: () async {
            final String data = "${_selectedDay.year.toString().padLeft(4, '0')}-${_selectedDay.month.toString().padLeft(2, '0')}-${_selectedDay.day.toString().padLeft(2, '0')}";
            final String ora = "${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}";

            try {
              await salaPesiViewModel.aggiungiPrenotazione(data, ora);
              Navigator.pop(context);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(e.toString())),
              );
            }
          },
          child: Text('Prenota'),
        ),
      ],
    );
  }
}