import 'package:canadapp/data/services/sala_pesi_service.dart';
import 'package:canadapp/domain/models/prenotazione.dart';

class SalaPesiRepository {
  final SalaPesiService _salaPesiService;

  SalaPesiRepository(this._salaPesiService);

  Future<List<Prenotazione>> fetchPrenotazioniUtente() {
    //print("Metodo");
    final prenotazioni = _salaPesiService.fetchPrenotazioniUtente();
    print(prenotazioni);
    return prenotazioni;
  }
}
