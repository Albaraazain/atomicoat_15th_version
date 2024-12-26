import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/repositories/i_recipe_repository.dart';
import '../datasources/remote/firebase_recipe_remote_source.dart';
import '../models/recipe_dto.dart';

class RecipeRepositoryImpl implements IRecipeRepository {
  final IRecipeRemoteSource remoteSource;

  RecipeRepositoryImpl({
    required this.remoteSource,
  });

  @override
  Future<Either<Failure, List<Recipe>>> getRecipes() async {
    try {
      final recipes = await remoteSource.getRecipes();
      return Right(recipes.map((dto) => dto.toDomain()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Recipe>> getRecipeById(String id) async {
    try {
      final recipe = await remoteSource.getRecipeById(id);
      return Right(recipe.toDomain());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> createRecipe(Recipe recipe) async {
    try {
      await remoteSource.createRecipe(RecipeDTO.fromDomain(recipe));
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateRecipe(Recipe recipe) async {
    try {
      await remoteSource.updateRecipe(RecipeDTO.fromDomain(recipe));
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteRecipe(String id) async {
    try {
      await remoteSource.deleteRecipe(id);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Stream<List<Recipe>> watchRecipes() {
    return remoteSource.watchRecipes().map(
          (dtos) => dtos.map((dto) => dto.toDomain()).toList(),
        );
  }
}