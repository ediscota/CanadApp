import 'package:canadapp/data/services/sala_pesi_service.dart';
import 'package:canadapp/domain/models/prenotazione.dart';
import 'package:canadapp/data/services/notifiche_service.dart';

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
    List<String> l = await _salaPesiService.aggiungiPrenotazione(data, ora);
    NotificheService().notificaSessioneSalaPesi(data, ora); //devo metterlo dopo
    return l;
  }

  Future<bool> isOrarioDisponibile(String data, String ora) {
    return _salaPesiService.isOrarioDisponibile(data, ora);
  }

  Future<void> deletePrenotazione(String id) {
    NotificheService().deleteNotificaSalaPesi(id.hashCode);
    return _salaPesiService.deletePrenotazione(id);
  }
}
