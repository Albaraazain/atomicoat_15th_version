import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/recipe.dart';

part 'recipe_event.freezed.dart';

@freezed
class RecipeEvent with _$RecipeEvent {
  const factory RecipeEvent.loadRecipes() = _LoadRecipes;
  const factory RecipeEvent.createRecipe(Recipe recipe) = _CreateRecipe;
  const factory RecipeEvent.updateRecipe(Recipe recipe) = _UpdateRecipe;
  const factory RecipeEvent.deleteRecipe(String id) = _DeleteRecipe;
  const factory RecipeEvent.getRecipeById(String id) = _GetRecipeById;
}