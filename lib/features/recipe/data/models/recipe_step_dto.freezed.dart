// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipe_step_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RecipeStepDTO _$RecipeStepDTOFromJson(Map<String, dynamic> json) {
  return _RecipeStepDTO.fromJson(json);
}

/// @nodoc
mixin _$RecipeStepDTO {
  StepType get type => throw _privateConstructorUsedError;
  Map<String, dynamic> get parameters => throw _privateConstructorUsedError;
  List<RecipeStepDTO>? get subSteps => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(StepType type, Map<String, dynamic> parameters,
            List<RecipeStepDTO>? subSteps)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(StepType type, Map<String, dynamic> parameters,
            List<RecipeStepDTO>? subSteps)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(StepType type, Map<String, dynamic> parameters,
            List<RecipeStepDTO>? subSteps)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_RecipeStepDTO value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_RecipeStepDTO value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_RecipeStepDTO value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this RecipeStepDTO to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecipeStepDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecipeStepDTOCopyWith<RecipeStepDTO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecipeStepDTOCopyWith<$Res> {
  factory $RecipeStepDTOCopyWith(
          RecipeStepDTO value, $Res Function(RecipeStepDTO) then) =
      _$RecipeStepDTOCopyWithImpl<$Res, RecipeStepDTO>;
  @useResult
  $Res call(
      {StepType type,
      Map<String, dynamic> parameters,
      List<RecipeStepDTO>? subSteps});
}

/// @nodoc
class _$RecipeStepDTOCopyWithImpl<$Res, $Val extends RecipeStepDTO>
    implements $RecipeStepDTOCopyWith<$Res> {
  _$RecipeStepDTOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecipeStepDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? parameters = null,
    Object? subSteps = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as StepType,
      parameters: null == parameters
          ? _value.parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      subSteps: freezed == subSteps
          ? _value.subSteps
          : subSteps // ignore: cast_nullable_to_non_nullable
              as List<RecipeStepDTO>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecipeStepDTOImplCopyWith<$Res>
    implements $RecipeStepDTOCopyWith<$Res> {
  factory _$$RecipeStepDTOImplCopyWith(
          _$RecipeStepDTOImpl value, $Res Function(_$RecipeStepDTOImpl) then) =
      __$$RecipeStepDTOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {StepType type,
      Map<String, dynamic> parameters,
      List<RecipeStepDTO>? subSteps});
}

/// @nodoc
class __$$RecipeStepDTOImplCopyWithImpl<$Res>
    extends _$RecipeStepDTOCopyWithImpl<$Res, _$RecipeStepDTOImpl>
    implements _$$RecipeStepDTOImplCopyWith<$Res> {
  __$$RecipeStepDTOImplCopyWithImpl(
      _$RecipeStepDTOImpl _value, $Res Function(_$RecipeStepDTOImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecipeStepDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? parameters = null,
    Object? subSteps = freezed,
  }) {
    return _then(_$RecipeStepDTOImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as StepType,
      parameters: null == parameters
          ? _value._parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      subSteps: freezed == subSteps
          ? _value._subSteps
          : subSteps // ignore: cast_nullable_to_non_nullable
              as List<RecipeStepDTO>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecipeStepDTOImpl extends _RecipeStepDTO {
  const _$RecipeStepDTOImpl(
      {required this.type,
      required final Map<String, dynamic> parameters,
      final List<RecipeStepDTO>? subSteps})
      : _parameters = parameters,
        _subSteps = subSteps,
        super._();

  factory _$RecipeStepDTOImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecipeStepDTOImplFromJson(json);

  @override
  final StepType type;
  final Map<String, dynamic> _parameters;
  @override
  Map<String, dynamic> get parameters {
    if (_parameters is EqualUnmodifiableMapView) return _parameters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_parameters);
  }

  final List<RecipeStepDTO>? _subSteps;
  @override
  List<RecipeStepDTO>? get subSteps {
    final value = _subSteps;
    if (value == null) return null;
    if (_subSteps is EqualUnmodifiableListView) return _subSteps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'RecipeStepDTO(type: $type, parameters: $parameters, subSteps: $subSteps)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecipeStepDTOImpl &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other._parameters, _parameters) &&
            const DeepCollectionEquality().equals(other._subSteps, _subSteps));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      type,
      const DeepCollectionEquality().hash(_parameters),
      const DeepCollectionEquality().hash(_subSteps));

  /// Create a copy of RecipeStepDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecipeStepDTOImplCopyWith<_$RecipeStepDTOImpl> get copyWith =>
      __$$RecipeStepDTOImplCopyWithImpl<_$RecipeStepDTOImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(StepType type, Map<String, dynamic> parameters,
            List<RecipeStepDTO>? subSteps)
        $default,
  ) {
    return $default(type, parameters, subSteps);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(StepType type, Map<String, dynamic> parameters,
            List<RecipeStepDTO>? subSteps)?
        $default,
  ) {
    return $default?.call(type, parameters, subSteps);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(StepType type, Map<String, dynamic> parameters,
            List<RecipeStepDTO>? subSteps)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(type, parameters, subSteps);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_RecipeStepDTO value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_RecipeStepDTO value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_RecipeStepDTO value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RecipeStepDTOImplToJson(
      this,
    );
  }
}

abstract class _RecipeStepDTO extends RecipeStepDTO {
  const factory _RecipeStepDTO(
      {required final StepType type,
      required final Map<String, dynamic> parameters,
      final List<RecipeStepDTO>? subSteps}) = _$RecipeStepDTOImpl;
  const _RecipeStepDTO._() : super._();

  factory _RecipeStepDTO.fromJson(Map<String, dynamic> json) =
      _$RecipeStepDTOImpl.fromJson;

  @override
  StepType get type;
  @override
  Map<String, dynamic> get parameters;
  @override
  List<RecipeStepDTO>? get subSteps;

  /// Create a copy of RecipeStepDTO
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecipeStepDTOImplCopyWith<_$RecipeStepDTOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
