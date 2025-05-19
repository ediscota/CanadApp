import '../../domain/models/aula_studio.dart';
import '../services/aula_studio_service.dart';

class AulaStudioRepository {
  final AulaStudioService _service;
  AulaStudioRepository(this._service);

  Future<AulaStudio?> getDisponibilita() {
    return _service.getDisponibilita();
  }
  Future<void> setDisponibilita(int nuovaDisponibilita) {
    return _service.setDisponibilita(nuovaDisponibilita);
  }
  Stream<AulaStudio> disponibilitaStream() {
    return _service.disponibilitaStream();
  }
  Future<void> decrementaDisponibilita() {
    return _service.decrementaDisponibilita();
  }
  Future<void> incrementaDisponibilita() {
    return _service.incrementaDisponibilita();
  }
}
