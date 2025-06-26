import 'package:canadapp/data/services/sala_pesi_service.dart';
import 'package:canadapp/domain/models/prenotazione.dart';

class SalaPesiRepository {
  final SalaPesiService _salaPesiService;

  SalaPesiRepository(this._salaPesiService);

  Future<List<Prenotazione>> fetchPrenotazioni() {
    //print("Metodo");
    final prenotazioni = _salaPesiService.fetchPrenotazioni();
    return prenotazioni;
  }
  
  Future<void> aggiungiPrenotazione(String data, String ora) {
    return _salaPesiService.aggiungiPrenotazione(data, ora);
  }
}
