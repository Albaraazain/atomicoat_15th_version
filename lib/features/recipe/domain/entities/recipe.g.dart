// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecipeImpl _$$RecipeImplFromJson(Map<String, dynamic> json) => _$RecipeImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      substrate: json['substrate'] as String,
      steps: (json['steps'] as List<dynamic>)
          .map((e) => RecipeStep.fromJson(e as Map<String, dynamic>))
          .toList(),
      chamberTemperatureSetPoint:
          (json['chamber_temperature_set_point'] as num).toDouble(),
      pressureSetPoint: (json['pressure_set_point'] as num).toDouble(),
    );

Map<String, dynamic> _$$RecipeImplToJson(_$RecipeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'substrate': instance.substrate,
      'steps': instance.steps.map((e) => e.toJson()).toList(),
      'chamber_temperature_set_point': instance.chamberTemperatureSetPoint,
      'pressure_set_point': instance.pressureSetPoint,
    };
