import 'package:canadapp/ui/core/date_time_picker_widget.dart';
import 'package:canadapp/ui/viewmodels/sala_pesi_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SalaPesiScreen extends StatefulWidget {
  const SalaPesiScreen({super.key});

  @override
  State<SalaPesiScreen> createState() => _SalaPesiScreenState();
}

class _SalaPesiScreenState extends State<SalaPesiScreen> {
  @override
  Widget build(BuildContext context) {
    final salaPesiViewModel = context.watch<SalaPesiViewModel>();
    final items = salaPesiViewModel.prenotazioni;
    //print("items: ");
    print(items);

    return Stack(
      children: [
        // Lista principale
        ListView.builder(
          padding: EdgeInsets.fromLTRB(15, 5, 15, 50),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(
                  Icons.edit_calendar,
                  size: 32,
                  color: Colors.deepPurple,
                ),
                title: Text(
                  item.userId,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(item.dataOra),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder:
                        (_) => Container(
                          padding: EdgeInsets.all(16),
                          height: 250,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.userId,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                item.dataOra,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Spacer(),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple,
                                  ),
                                  child: Text('Chiudi'),
                                ),
                              ),
                            ],
                          ),
                        ),
                  );
                },
              ),
            );
          },
        ),
        Positioned(
          bottom: 24,
          right: 24,
          child: FloatingActionButton(
            backgroundColor: Colors.deepPurple,
            child: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) {
                  Map<DateTime, List<TimeOfDay>> prenotazioni = {
                    DateTime(2025, 6, 18): [
                      TimeOfDay(hour: 10, minute: 0),
                      TimeOfDay(hour: 10, minute: 30),
                    ],
                    DateTime(2025, 6, 19): List.generate(
                      24,
                      (i) =>
                          TimeOfDay(hour: 8 + (i ~/ 2), minute: (i % 2) * 30),
                    ), // giorno pieno
                  };

                  return AlertDialog(
                    title: Text("Seleziona data e ora"),
                    content: SizedBox(
                      width: double.maxFinite,
                      height: 400, // 👈 aggiunta fondamentale
                      child: SingleChildScrollView(
                        child: DateTimeSlotPicker(
                          prenotazioni: prenotazioni,
                          onSlotSelected: (data, orario) {
                            print(
                              "Selezionato: $data alle ${orario.format(context)}",
                            );
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
