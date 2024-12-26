import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe_step.freezed.dart';
part 'recipe_step.g.dart';

enum StepType {
  loop,
  valve,
  purge,
  setParameter,
}

enum ValveType {
  valveA,
  valveB,
}

@freezed
class RecipeStep with _$RecipeStep {
  const factory RecipeStep({
    required StepType type,
    required Map<String, dynamic> parameters,
    List<RecipeStep>? subSteps,
  }) = _RecipeStep;

  factory RecipeStep.fromJson(Map<String, dynamic> json) => _$RecipeStepFromJson(json);
}