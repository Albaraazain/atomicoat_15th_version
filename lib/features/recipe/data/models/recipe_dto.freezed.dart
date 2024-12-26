// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipe_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RecipeDTO _$RecipeDTOFromJson(Map<String, dynamic> json) {
  return _RecipeDTO.fromJson(json);
}

/// @nodoc
mixin _$RecipeDTO {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get substrate => throw _privateConstructorUsedError;
  List<RecipeStepDTO> get steps => throw _privateConstructorUsedError;
  double get chamberTemperatureSetPoint => throw _privateConstructorUsedError;
  double get pressureSetPoint => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String name,
            String substrate,
            List<RecipeStepDTO> steps,
            double chamberTemperatureSetPoint,
            double pressureSetPoint)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String name,
            String substrate,
            List<RecipeStepDTO> steps,
            double chamberTemperatureSetPoint,
            double pressureSetPoint)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String name,
            String substrate,
            List<RecipeStepDTO> steps,
            double chamberTemperatureSetPoint,
            double pressureSetPoint)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_RecipeDTO value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_RecipeDTO value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_RecipeDTO value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this RecipeDTO to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecipeDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecipeDTOCopyWith<RecipeDTO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecipeDTOCopyWith<$Res> {
  factory $RecipeDTOCopyWith(RecipeDTO value, $Res Function(RecipeDTO) then) =
      _$RecipeDTOCopyWithImpl<$Res, RecipeDTO>;
  @useResult
  $Res call(
      {String id,
      String name,
      String substrate,
      List<RecipeStepDTO> steps,
      double chamberTemperatureSetPoint,
      double pressureSetPoint});
}

/// @nodoc
class _$RecipeDTOCopyWithImpl<$Res, $Val extends RecipeDTO>
    implements $RecipeDTOCopyWith<$Res> {
  _$RecipeDTOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecipeDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? substrate = null,
    Object? steps = null,
    Object? chamberTemperatureSetPoint = null,
    Object? pressureSetPoint = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      substrate: null == substrate
          ? _value.substrate
          : substrate // ignore: cast_nullable_to_non_nullable
              as String,
      steps: null == steps
          ? _value.steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<RecipeStepDTO>,
      chamberTemperatureSetPoint: null == chamberTemperatureSetPoint
          ? _value.chamberTemperatureSetPoint
          : chamberTemperatureSetPoint // ignore: cast_nullable_to_non_nullable
              as double,
      pressureSetPoint: null == pressureSetPoint
          ? _value.pressureSetPoint
          : pressureSetPoint // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecipeDTOImplCopyWith<$Res>
    implements $RecipeDTOCopyWith<$Res> {
  factory _$$RecipeDTOImplCopyWith(
          _$RecipeDTOImpl value, $Res Function(_$RecipeDTOImpl) then) =
      __$$RecipeDTOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String substrate,
      List<RecipeStepDTO> steps,
      double chamberTemperatureSetPoint,
      double pressureSetPoint});
}

/// @nodoc
class __$$RecipeDTOImplCopyWithImpl<$Res>
    extends _$RecipeDTOCopyWithImpl<$Res, _$RecipeDTOImpl>
    implements _$$RecipeDTOImplCopyWith<$Res> {
  __$$RecipeDTOImplCopyWithImpl(
      _$RecipeDTOImpl _value, $Res Function(_$RecipeDTOImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecipeDTO
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? substrate = null,
    Object? steps = null,
    Object? chamberTemperatureSetPoint = null,
    Object? pressureSetPoint = null,
  }) {
    return _then(_$RecipeDTOImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      substrate: null == substrate
          ? _value.substrate
          : substrate // ignore: cast_nullable_to_non_nullable
              as String,
      steps: null == steps
          ? _value._steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<RecipeStepDTO>,
      chamberTemperatureSetPoint: null == chamberTemperatureSetPoint
          ? _value.chamberTemperatureSetPoint
          : chamberTemperatureSetPoint // ignore: cast_nullable_to_non_nullable
              as double,
      pressureSetPoint: null == pressureSetPoint
          ? _value.pressureSetPoint
          : pressureSetPoint // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecipeDTOImpl extends _RecipeDTO {
  const _$RecipeDTOImpl(
      {required this.id,
      required this.name,
      required this.substrate,
      required final List<RecipeStepDTO> steps,
      required this.chamberTemperatureSetPoint,
      required this.pressureSetPoint})
      : _steps = steps,
        super._();

  factory _$RecipeDTOImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecipeDTOImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String substrate;
  final List<RecipeStepDTO> _steps;
  @override
  List<RecipeStepDTO> get steps {
    if (_steps is EqualUnmodifiableListView) return _steps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_steps);
  }

  @override
  final double chamberTemperatureSetPoint;
  @override
  final double pressureSetPoint;

  @override
  String toString() {
    return 'RecipeDTO(id: $id, name: $name, substrate: $substrate, steps: $steps, chamberTemperatureSetPoint: $chamberTemperatureSetPoint, pressureSetPoint: $pressureSetPoint)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecipeDTOImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.substrate, substrate) ||
                other.substrate == substrate) &&
            const DeepCollectionEquality().equals(other._steps, _steps) &&
            (identical(other.chamberTemperatureSetPoint,
                    chamberTemperatureSetPoint) ||
                other.chamberTemperatureSetPoint ==
                    chamberTemperatureSetPoint) &&
            (identical(other.pressureSetPoint, pressureSetPoint) ||
                other.pressureSetPoint == pressureSetPoint));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      substrate,
      const DeepCollectionEquality().hash(_steps),
      chamberTemperatureSetPoint,
      pressureSetPoint);

  /// Create a copy of RecipeDTO
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecipeDTOImplCopyWith<_$RecipeDTOImpl> get copyWith =>
      __$$RecipeDTOImplCopyWithImpl<_$RecipeDTOImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String name,
            String substrate,
            List<RecipeStepDTO> steps,
            double chamberTemperatureSetPoint,
            double pressureSetPoint)
        $default,
  ) {
    return $default(id, name, substrate, steps, chamberTemperatureSetPoint,
        pressureSetPoint);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String name,
            String substrate,
            List<RecipeStepDTO> steps,
            double chamberTemperatureSetPoint,
            double pressureSetPoint)?
        $default,
  ) {
    return $default?.call(id, name, substrate, steps,
        chamberTemperatureSetPoint, pressureSetPoint);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String name,
            String substrate,
            List<RecipeStepDTO> steps,
            double chamberTemperatureSetPoint,
            double pressureSetPoint)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(id, name, substrate, steps, chamberTemperatureSetPoint,
          pressureSetPoint);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_RecipeDTO value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_RecipeDTO value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_RecipeDTO value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RecipeDTOImplToJson(
      this,
    );
  }
}

abstract class _RecipeDTO extends RecipeDTO {
  const factory _RecipeDTO(
      {required final String id,
      required final String name,
      required final String substrate,
      required final List<RecipeStepDTO> steps,
      required final double chamberTemperatureSetPoint,
      required final double pressureSetPoint}) = _$RecipeDTOImpl;
  const _RecipeDTO._() : super._();

  factory _RecipeDTO.fromJson(Map<String, dynamic> json) =
      _$RecipeDTOImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get substrate;
  @override
  List<RecipeStepDTO> get steps;
  @override
  double get chamberTemperatureSetPoint;
  @override
  double get pressureSetPoint;

  /// Create a copy of RecipeDTO
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecipeDTOImplCopyWith<_$RecipeDTOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
