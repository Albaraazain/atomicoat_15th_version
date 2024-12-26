// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecipeStepImpl _$$RecipeStepImplFromJson(Map<String, dynamic> json) =>
    _$RecipeStepImpl(
      type: $enumDecode(_$StepTypeEnumMap, json['type']),
      parameters: json['parameters'] as Map<String, dynamic>,
      subSteps: (json['sub_steps'] as List<dynamic>?)
          ?.map((e) => RecipeStep.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$RecipeStepImplToJson(_$RecipeStepImpl instance) =>
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
