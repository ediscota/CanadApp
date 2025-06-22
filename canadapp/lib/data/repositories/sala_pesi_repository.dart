import 'package:canadapp/data/services/sala_pesi_service.dart';
import 'package:canadapp/domain/models/prenotazione.dart';

class SalaPesiRepository {
  final SalaPesiService _salaPesiService;

  SalaPesiRepository(this._salaPesiService);

  Future<List<Prenotazione>> fetchPrenotazioni() {
    //print("Metodo");
    final prenotazioni = _salaPesiService.fetchPrenotazioni();
    print(prenotazioni);
    return prenotazioni;
  }
}
