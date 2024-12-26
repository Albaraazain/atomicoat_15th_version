// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_step_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecipeStepDTOImpl _$$RecipeStepDTOImplFromJson(Map<String, dynamic> json) =>
    _$RecipeStepDTOImpl(
      type: $enumDecode(_$StepTypeEnumMap, json['type']),
      parameters: json['parameters'] as Map<String, dynamic>,
      subSteps: (json['sub_steps'] as List<dynamic>?)
          ?.map((e) => RecipeStepDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$RecipeStepDTOImplToJson(_$RecipeStepDTOImpl instance) =>
    <String, dynamic>{
      'type': _$StepTypeEnumMap[instance.type]!,
      'parameters': instance.parameters,
      'sub_steps': instance.subSteps?.map((e) => e.toJson()).toList(),
    };

const _$StepTypeEnumMap = {
  StepType.loop: 'loop',
  StepType.valve: 'valve',
  StepType.purge: 'purge',
  StepType.setParameter: 'setParameter',
};
