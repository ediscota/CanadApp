import 'package:freezed_annotation/freezed_annotation.dart';
part 'aula_studio.freezed.dart';
part 'aula_studio.g.dart';

//Freezed per rendere immutabile la disponibilità
@freezed
class AulaStudio with _$AulaStudio {
  const factory AulaStudio({
    required int disponibilita,
  }) = _AulaStudio;

  factory AulaStudio.fromJson(Map<String, dynamic> json) =>
      _$AulaStudioFromJson(json); 
}