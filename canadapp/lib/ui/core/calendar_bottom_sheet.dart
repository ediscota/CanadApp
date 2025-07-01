import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:table_calendar/table_calendar.dart';
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
  DateTime? _selectedDay = null;
  TimeOfDay? _selectedTime = null;

  bool isValidDate(DateTime day) {
    final salaPesiViewModel = context.read<SalaPesiViewModel>();
    final prenotazioni = salaPesiViewModel.prenotazioni;
    int cont = 0;
    for (var prenotazione in prenotazioni) {
      if (prenotazione.data == day.toString().substring(0, 10)) {
        cont++;
      }
    }
    return cont < 3; // modificare da 1 a 8
  }

  bool isValidTime(hour) {
    if (_selectedDay == null) {
      return false; // Non è stata selezionata una data
    }
    final salaPesiViewModel = context.read<SalaPesiViewModel>();
    final prenotazioni = salaPesiViewModel.prenotazioni;
    final selectedTime = TimeOfDay(hour: hour, minute: 0);
    for (var prenotazione in prenotazioni) {
      if (prenotazione.data == _selectedDay!.toString().substring(0, 10) &&
          prenotazione.ora == selectedTime.format(context)) {
        return false; // L'orario è già occupato
      }
    }
    print('Vero');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final salaPesiViewModel = context.read<SalaPesiViewModel>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CalendarDatePicker(
          initialDate: null,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 365)),
          selectableDayPredicate: (day) {
            return isValidDate(day);
          },
          onDateChanged: (selectedDay) {
            setState(() {
              _selectedDay = selectedDay;
            });
          },
        ),
        if (_selectedDay != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_selectedTime != null)
                Text('Ora: ${_selectedTime!.format(context)}'),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () async {
                  final pickedTime = await showDialog<int>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Seleziona Ora'),
                        content: SizedBox(
                          width: double.maxFinite,
                          child: ListView.builder(
                            itemCount: 13, // Orari da 9 a 21
                            itemBuilder: (context, index) {
                              final hour = index + 9;
                              return ListTile(
                                title: Text('$hour:00'),
                                enabled: isValidTime(hour),
                                onTap: () {
                                  Navigator.pop(
                                    context,
                                    hour,
                                  ); // ✅ Torna l'ora selezionata
                                },
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                  if (pickedTime != null) {
                    print('Hai scelto: $pickedTime:00');
                    setState(() {
                      _selectedTime = TimeOfDay(hour: pickedTime, minute: 0);
                    });
                  }
                },
                child: Text('Seleziona Ora'),
              ),
            ],
          ),
        SizedBox(height: 24),
        ElevatedButton(
          onPressed:
              _selectedDay != null && _selectedTime != null
                  ? () async {
                    final String data =
                        "${_selectedDay!.year.toString().padLeft(4, '0')}-${_selectedDay!.month.toString().padLeft(2, '0')}-${_selectedDay!.day.toString().padLeft(2, '0')}";
                    final String ora =
                        "${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}";

                    try {
                      await salaPesiViewModel.aggiungiPrenotazione(data, ora);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Prenotazione aggiunta!')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  }
                  : null,
          child: Text('Prenota'),
        ),
      ],
    );
  }
}
