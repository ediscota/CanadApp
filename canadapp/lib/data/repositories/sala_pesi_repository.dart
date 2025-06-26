import 'package:canadapp/data/services/sala_pesi_service.dart';
import 'package:canadapp/domain/models/prenotazione.dart';

class SalaPesiRepository {
  final SalaPesiService _salaPesiService;
  //List<String> errors = [];

  SalaPesiRepository(this._salaPesiService);

  Future<List<Prenotazione>> fetchPrenotazioni() {
    //print("Metodo");
    final prenotazioni = _salaPesiService.fetchPrenotazioni();
    return prenotazioni;
  }
  
  Future<List<String>> aggiungiPrenotazione(String data, String ora) async {
    return _salaPesiService.aggiungiPrenotazione(data, ora);
  }

  Future<bool> isOrarioDisponibile(String data, String ora) {
    return _salaPesiService.isOrarioDisponibile(data, ora);
  }
}
