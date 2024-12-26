import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../core/error/exceptions.dart';
import '../../models/recipe_dto.dart';

abstract class IRecipeRemoteSource {
  Future<List<RecipeDTO>> getRecipes();
  Future<RecipeDTO> getRecipeById(String id);
  Future<void> createRecipe(RecipeDTO recipe);
  Future<void> updateRecipe(RecipeDTO recipe);
  Future<void> deleteRecipe(String id);
  Stream<List<RecipeDTO>> watchRecipes();
}

class FirebaseRecipeRemoteSource implements IRecipeRemoteSource {
  final FirebaseFirestore _firestore;
  final String _collection = 'recipes';

  FirebaseRecipeRemoteSource(this._firestore);

  @override
  Future<List<RecipeDTO>> getRecipes() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();
      return snapshot.docs
          .map((doc) => RecipeDTO.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw ServerException('Failed to fetch recipes: ${e.toString()}');
    }
  }

  @override
  Future<RecipeDTO> getRecipeById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (!doc.exists) throw NotFoundException();
      return RecipeDTO.fromJson({...doc.data()!, 'id': doc.id});
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw ServerException('Failed to fetch recipe with ID $id: ${e.toString()}');
    }
  }

  @override
  Future<void> createRecipe(RecipeDTO recipe) async {
    try {
      await _firestore.collection(_collection).doc(recipe.id).set(recipe.toJson()..remove('id'));
    } catch (e) {
      throw ServerException('Failed to create recipe: ${e.toString()}');
    }
  }

  @override
  Future<void> updateRecipe(RecipeDTO recipe) async {
    try {
      await _firestore.collection(_collection).doc(recipe.id).update(recipe.toJson()..remove('id'));
    } catch (e) {
      throw ServerException('Failed to update recipe: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteRecipe(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw ServerException('Failed to delete recipe: ${e.toString()}');
    }
  }

  @override
  Stream<List<RecipeDTO>> watchRecipes() {
    return _firestore.collection(_collection).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => RecipeDTO.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }
}