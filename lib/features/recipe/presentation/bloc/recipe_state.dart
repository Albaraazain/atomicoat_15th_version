import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/recipe.dart';

part 'recipe_state.freezed.dart';

@freezed
class RecipeState with _$RecipeState {
  const factory RecipeState.initial() = _Initial;
  const factory RecipeState.loading() = _Loading;
  const factory RecipeState.loaded(List<Recipe> recipes) = _Loaded;
  const factory RecipeState.error(String message) = _Error;
  const factory RecipeState.saving() = _Saving;
  const factory RecipeState.saved() = _Saved;
  const factory RecipeState.deleting() = _Deleting;
  const factory RecipeState.deleted() = _Deleted;
}