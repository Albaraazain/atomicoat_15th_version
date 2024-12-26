import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/recipe.dart';
import '../repositories/i_recipe_repository.dart';

class CreateRecipeUseCase implements UseCase<Unit, Recipe> {
  final IRecipeRepository repository;

  CreateRecipeUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(Recipe recipe) async {
    return await repository.createRecipe(recipe);
  }
}