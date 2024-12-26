import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/recipe.dart';

abstract class IRecipeRepository {
  Future<Either<Failure, List<Recipe>>> getRecipes();
  Future<Either<Failure, Recipe>> getRecipeById(String id);
  Future<Either<Failure, Unit>> createRecipe(Recipe recipe);
  Future<Either<Failure, Unit>> updateRecipe(Recipe recipe);
  Future<Either<Failure, Unit>> deleteRecipe(String id);
  Stream<List<Recipe>> watchRecipes();
}