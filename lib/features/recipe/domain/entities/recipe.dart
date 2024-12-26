import 'package:freezed_annotation/freezed_annotation.dart';
import 'recipe_step.dart';

part 'recipe.freezed.dart';
part 'recipe.g.dart';

@freezed
class Recipe with _$Recipe {
  const factory Recipe({
    required String id,
    required String name,
    required String substrate,
    required List<RecipeStep> steps,
    required double chamberTemperatureSetPoint,
    required double pressureSetPoint,
  }) = _Recipe;

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);
}