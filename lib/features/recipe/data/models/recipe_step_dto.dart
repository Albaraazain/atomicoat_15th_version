import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/recipe_step.dart';

part 'recipe_step_dto.freezed.dart';
part 'recipe_step_dto.g.dart';

@freezed
class RecipeStepDTO with _$RecipeStepDTO {
  const RecipeStepDTO._();

  const factory RecipeStepDTO({
    required StepType type,
    required Map<String, dynamic> parameters,
    List<RecipeStepDTO>? subSteps,
  }) = _RecipeStepDTO;

  factory RecipeStepDTO.fromJson(Map<String, dynamic> json) => _$RecipeStepDTOFromJson(json);

  factory RecipeStepDTO.fromDomain(RecipeStep step) {
    return RecipeStepDTO(
      type: step.type,
      parameters: Map<String, dynamic>.from(step.parameters),
      subSteps: step.subSteps?.map((s) => RecipeStepDTO.fromDomain(s)).toList(),
    );
  }

  RecipeStep toDomain() {
    return RecipeStep(
      type: type,
      parameters: Map<String, dynamic>.from(parameters),
      subSteps: subSteps?.map((s) => s.toDomain()).toList(),
    );
  }
}