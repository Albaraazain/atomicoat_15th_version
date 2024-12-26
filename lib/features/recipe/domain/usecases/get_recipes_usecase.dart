import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/recipe.dart';
import '../repositories/i_recipe_repository.dart';

class GetRecipesUseCase implements UseCase<List<Recipe>, NoParams> {
  final IRecipeRepository repository;

  GetRecipesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Recipe>>> call(NoParams params) async {
    return await repository.getRecipes();
  }
}