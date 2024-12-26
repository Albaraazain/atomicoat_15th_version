// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parameter_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParameterDTO _$ParameterDTOFromJson(Map<String, dynamic> json) => ParameterDTO(
      id: json['id'] as String,
      name: json['name'] as String,
      parameterTypeString: json['type'] as String? ?? 'flow',
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      minValue: (json['minValue'] as num?)?.toDouble() ?? 0.0,
      maxValue: (json['maxValue'] as num?)?.toDouble() ?? 100.0,
      unit: json['unit'] as String? ?? '',
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$ParameterDTOToJson(ParameterDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.parameterTypeString,
      'value': instance.value,
      'minValue': instance.minValue,
      'maxValue': instance.maxValue,
      'unit': instance.unit,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };
