import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/usecases/create_recipe_usecase.dart';
import '../../domain/usecases/delete_recipe_usecase.dart';
import '../../domain/usecases/get_recipe_by_id_usecase.dart';
import '../../domain/usecases/get_recipes_usecase.dart';
import '../../domain/usecases/update_recipe_usecase.dart';
import 'recipe_event.dart';
import 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final GetRecipesUseCase getRecipes;
  final CreateRecipeUseCase createRecipe;
  final UpdateRecipeUseCase updateRecipe;
  final DeleteRecipeUseCase deleteRecipe;
  final GetRecipeByIdUseCase getRecipeById;

  RecipeBloc({
    required this.getRecipes,
    required this.createRecipe,
    required this.updateRecipe,
    required this.deleteRecipe,
    required this.getRecipeById,
  }) : super(const RecipeState.initial()) {
    on<RecipeEvent>((event, emit) async {
      AppLogger.debug('Handling RecipeEvent: ${event.runtimeType}');
      if (state == const RecipeState.saving() || state == const RecipeState.loading()) {
        AppLogger.debug('Skipping event while in ${state.runtimeType} state');
        return;
      }
      await event.when(
        loadRecipes: () => _onLoadRecipes(emit),
        createRecipe: (recipe) => _onCreateRecipe(recipe, emit),
        updateRecipe: (recipe) => _onUpdateRecipe(recipe, emit),
        deleteRecipe: (id) => _onDeleteRecipe(id, emit),
        getRecipeById: (id) => _onGetRecipeById(id, emit),
      );
    });
  }

  Future<void> _onLoadRecipes(Emitter<RecipeState> emit) async {
    AppLogger.debug('Loading recipes...');
    emit(const RecipeState.loading());
    final result = await getRecipes(const NoParams());
    if (!emit.isDone) {
      AppLogger.debug('Got recipes result: ${result.toString()}');
      result.fold(
        (failure) {
          AppLogger.error('Failed to load recipes: ${failure.message}');
          emit(RecipeState.error(failure.message));
        },
        (recipes) {
          AppLogger.debug('Successfully loaded ${recipes.length} recipes');
          emit(RecipeState.loaded(recipes));
        },
      );
    } else {
      AppLogger.debug('Emitter is done, skipping state emission');
    }
  }

  Future<void> _onCreateRecipe(recipe, Emitter<RecipeState> emit) async {
    AppLogger.debug('Creating recipe...');
    emit(const RecipeState.saving());
    final result = await createRecipe(recipe);
    if (!emit.isDone) {
      AppLogger.debug('Got create recipe result: ${result.toString()}');
      await result.fold(
        (failure) async {
          AppLogger.error('Failed to create recipe: ${failure.message}');
          emit(RecipeState.error(failure.message));
        },
        (_) async {
          AppLogger.debug('Recipe created successfully');
          emit(const RecipeState.saved());
          AppLogger.debug('Loading recipes after save...');
          final recipesResult = await getRecipes(const NoParams());
          if (!emit.isDone) {
            recipesResult.fold(
              (failure) {
                AppLogger.error('Failed to load recipes after create: ${failure.message}');
                emit(RecipeState.error(failure.message));
              },
              (recipes) {
                AppLogger.debug('Successfully loaded ${recipes.length} recipes after create');
                emit(RecipeState.loaded(recipes));
              },
            );
          }
        },
      );
    }
  }

  Future<void> _onUpdateRecipe(recipe, Emitter<RecipeState> emit) async {
    AppLogger.debug('Updating recipe...');
    emit(const RecipeState.saving());
    final result = await updateRecipe(recipe);
    if (!emit.isDone) {
      AppLogger.debug('Got update recipe result: ${result.toString()}');
      await result.fold(
        (failure) async {
          AppLogger.error('Failed to update recipe: ${failure.message}');
          emit(RecipeState.error(failure.message));
        },
        (_) async {
          AppLogger.debug('Recipe updated successfully');
          emit(const RecipeState.saved());
          AppLogger.debug('Loading recipes after save...');
          final recipesResult = await getRecipes(const NoParams());
          if (!emit.isDone) {
            recipesResult.fold(
              (failure) {
                AppLogger.error('Failed to load recipes after update: ${failure.message}');
                emit(RecipeState.error(failure.message));
              },
              (recipes) {
                AppLogger.debug('Successfully loaded ${recipes.length} recipes after update');
                emit(RecipeState.loaded(recipes));
              },
            );
          }
        },
      );
    }
  }

  Future<void> _onDeleteRecipe(String id, Emitter<RecipeState> emit) async {
    emit(const RecipeState.deleting());
    final result = await deleteRecipe(id);
    result.fold(
      (failure) => emit(RecipeState.error(failure.message)),
      (_) => emit(const RecipeState.deleted()),
    );
  }

  Future<void> _onGetRecipeById(String id, Emitter<RecipeState> emit) async {
    emit(const RecipeState.loading());
    final result = await getRecipeById(id);
    result.fold(
      (failure) => emit(RecipeState.error(failure.message)),
      (recipe) => emit(RecipeState.loaded([recipe])),
    );
  }
}