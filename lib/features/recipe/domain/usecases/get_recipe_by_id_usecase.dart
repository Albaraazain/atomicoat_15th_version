import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/recipe.dart';
import '../repositories/i_recipe_repository.dart';

class GetRecipeByIdUseCase implements UseCase<Recipe, String> {
  final IRecipeRepository repository;

  GetRecipeByIdUseCase(this.repository);

  @override
  Future<Either<Failure, Recipe>> call(String id) async {
    return await repository.getRecipeById(id);
  }
}