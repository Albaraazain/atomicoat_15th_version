import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/recipe_bloc.dart';
import '../bloc/recipe_event.dart';
import '../bloc/recipe_state.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_page.dart';

class RecipeListPage extends StatelessWidget {
  const RecipeListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Recipes'),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
      ),
      body: BlocBuilder<RecipeBloc, RecipeState>(
        builder: (context, state) {
          return state.map(
            initial: (_) {
              context.read<RecipeBloc>().add(const RecipeEvent.loadRecipes());
              return const Center(child: CircularProgressIndicator());
            },
            loading: (_) => const Center(child: CircularProgressIndicator()),
            loaded: (state) => state.recipes.isEmpty
                ? const Center(
                    child: Text(
                      'No recipes found',
                      style: TextStyle(color: Color(0xFFE0E0E0)),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = state.recipes[index];
                      return RecipeCard(
                        recipe: recipe,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailPage(
                              recipeId: recipe.id,
                            ),
                          ),
                        ),
                        onDelete: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: const Color(0xFF1E1E1E),
                              title: const Text(
                                'Delete Recipe',
                                style: TextStyle(color: Color(0xFFE0E0E0)),
                              ),
                              content: Text(
                                'Are you sure you want to delete ${recipe.name}?',
                                style: const TextStyle(color: Color(0xFFB0B0B0)),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.read<RecipeBloc>().add(
                                          RecipeEvent.deleteRecipe(recipe.id),
                                        );
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
            error: (state) => Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            ),
            saving: (_) => const Center(child: CircularProgressIndicator()),
            saved: (_) => const SizedBox(),
            deleting: (_) => const Center(child: CircularProgressIndicator()),
            deleted: (_) => const SizedBox(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF64FFDA),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RecipeDetailPage(),
          ),
        ),
        child: const Icon(Icons.add, color: Color(0xFF121212)),
      ),
    );
  }
}