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

    return ListView.builder(
      padding: EdgeInsets.all(12),
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
              Icons.perm_contact_calendar,
              size: 32,
              color: Colors.deepPurple,
            ),
            title: Text(
              item.userId,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(item.dataOra.toString()),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder:
                    (context) => Container(
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
                            item.dataOra.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Chiudi'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
              );
            },
          ),
        );
      },
    );
  }
}
