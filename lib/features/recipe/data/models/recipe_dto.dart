import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/recipe.dart';
import 'recipe_step_dto.dart';

part 'recipe_dto.freezed.dart';
part 'recipe_dto.g.dart';

@freezed
class RecipeDTO with _$RecipeDTO {
  const RecipeDTO._();

  const factory RecipeDTO({
    required String id,
    required String name,
    required String substrate,
    required List<RecipeStepDTO> steps,
    required double chamberTemperatureSetPoint,
    required double pressureSetPoint,
  }) = _RecipeDTO;

  factory RecipeDTO.fromJson(Map<String, dynamic> json) => _$RecipeDTOFromJson(json);

  factory RecipeDTO.fromDomain(Recipe recipe) {
    return RecipeDTO(
      id: recipe.id,
      name: recipe.name,
      substrate: recipe.substrate,
      steps: recipe.steps.map((step) => RecipeStepDTO.fromDomain(step)).toList(),
      chamberTemperatureSetPoint: recipe.chamberTemperatureSetPoint,
      pressureSetPoint: recipe.pressureSetPoint,
    );
  }

  Recipe toDomain() {
    return Recipe(
      id: id,
      name: name,
      substrate: substrate,
      steps: steps.map((step) => step.toDomain()).toList(),
      chamberTemperatureSetPoint: chamberTemperatureSetPoint,
      pressureSetPoint: pressureSetPoint,
    );
  }
}