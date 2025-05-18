// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'aula_studio.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AulaStudio _$AulaStudioFromJson(Map<String, dynamic> json) {
  return _AulaStudio.fromJson(json);
}

/// @nodoc
mixin _$AulaStudio {
  int get disponibilita => throw _privateConstructorUsedError;

  /// Serializes this AulaStudio to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AulaStudio
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AulaStudioCopyWith<AulaStudio> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AulaStudioCopyWith<$Res> {
  factory $AulaStudioCopyWith(
    AulaStudio value,
    $Res Function(AulaStudio) then,
  ) = _$AulaStudioCopyWithImpl<$Res, AulaStudio>;
  @useResult
  $Res call({int disponibilita});
}

/// @nodoc
class _$AulaStudioCopyWithImpl<$Res, $Val extends AulaStudio>
    implements $AulaStudioCopyWith<$Res> {
  _$AulaStudioCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AulaStudio
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? disponibilita = null}) {
    return _then(
      _value.copyWith(
            disponibilita:
                null == disponibilita
                    ? _value.disponibilita
                    : disponibilita // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AulaStudioImplCopyWith<$Res>
    implements $AulaStudioCopyWith<$Res> {
  factory _$$AulaStudioImplCopyWith(
    _$AulaStudioImpl value,
    $Res Function(_$AulaStudioImpl) then,
  ) = __$$AulaStudioImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int disponibilita});
}

/// @nodoc
class __$$AulaStudioImplCopyWithImpl<$Res>
    extends _$AulaStudioCopyWithImpl<$Res, _$AulaStudioImpl>
    implements _$$AulaStudioImplCopyWith<$Res> {
  __$$AulaStudioImplCopyWithImpl(
    _$AulaStudioImpl _value,
    $Res Function(_$AulaStudioImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AulaStudio
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? disponibilita = null}) {
    return _then(
      _$AulaStudioImpl(
        disponibilita:
            null == disponibilita
                ? _value.disponibilita
                : disponibilita // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AulaStudioImpl implements _AulaStudio {
  const _$AulaStudioImpl({required this.disponibilita});

  factory _$AulaStudioImpl.fromJson(Map<String, dynamic> json) =>
      _$$AulaStudioImplFromJson(json);

  @override
  final int disponibilita;

  @override
  String toString() {
    return 'AulaStudio(disponibilita: $disponibilita)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AulaStudioImpl &&
            (identical(other.disponibilita, disponibilita) ||
                other.disponibilita == disponibilita));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, disponibilita);

  /// Create a copy of AulaStudio
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AulaStudioImplCopyWith<_$AulaStudioImpl> get copyWith =>
      __$$AulaStudioImplCopyWithImpl<_$AulaStudioImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AulaStudioImplToJson(this);
  }
}

abstract class _AulaStudio implements AulaStudio {
  const factory _AulaStudio({required final int disponibilita}) =
      _$AulaStudioImpl;

  factory _AulaStudio.fromJson(Map<String, dynamic> json) =
      _$AulaStudioImpl.fromJson;

  @override
  int get disponibilita;

  /// Create a copy of AulaStudio
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AulaStudioImplCopyWith<_$AulaStudioImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
