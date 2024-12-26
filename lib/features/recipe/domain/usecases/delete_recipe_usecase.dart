import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/i_recipe_repository.dart';

class DeleteRecipeUseCase implements UseCase<Unit, String> {
  final IRecipeRepository repository;

  DeleteRecipeUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    return await repository.deleteRecipe(id);
  }
}