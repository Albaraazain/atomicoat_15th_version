  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import '../../features/auth/domain/entities/user.dart';
  import '../../features/auth/presentation/bloc/auth_bloc.dart';
  import '../../features/auth/presentation/bloc/auth_state.dart';
  import '../../features/auth/presentation/pages/login_page.dart';
  import '../../features/auth/presentation/pages/register_page.dart';
  import '../../features/auth/presentation/pages/registration_pending_page.dart';
  import '../../features/auth/presentation/pages/registration_rejected_page.dart';
  import '../../features/machine/presentation/pages/machine_dashboard_page.dart';
  import '../../features/recipe/presentation/pages/recipe_list_page.dart';
  import '../../features/recipe/presentation/pages/recipe_detail_page.dart';

  class RouteConfig {
    static Route<dynamic> generateRoute(RouteSettings settings) {
      // Extract arguments if any
      final args = settings.arguments;

      // Handle auth and other routes
      switch (settings.name) {
        case '/':
          return MaterialPageRoute(
            builder: (context) {
              return Scaffold(
                body: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthInitial || state is AuthLoading) {
                      return Container(
                        color: Colors.white,
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text(
                                'AtomiCoat',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (state is Authenticated) {
                      if (state.user.approvalStatus == UserApprovalStatus.pending) {
                        return const RegistrationPendingPage();
                      }
                      if (state.user.approvalStatus == UserApprovalStatus.rejected) {
                        return RegistrationRejectedPage(reason: state.user.rejectionReason!);
                      }
                      return MachineDashboardPage(machineId: state.user.machineSerialNumber);
                    }

                    return const LoginPage();
                  },
                ),
              );
            },
          );
        case '/login':
          return MaterialPageRoute(builder: (_) => const LoginPage());
        case '/register':
          return MaterialPageRoute(builder: (_) => const RegisterPage());
        case '/recipes':
          return MaterialPageRoute(builder: (_) => const RecipeListPage());
        case '/recipes/create':
          return MaterialPageRoute(builder: (_) => const RecipeDetailPage());
        case '/recipes/edit':
          if (args is String) {
            return MaterialPageRoute(
              builder: (_) => RecipeDetailPage(recipeId: args),
            );
          }
          return _errorRoute('Recipe ID is required for editing');
        default:
          return _errorRoute('No route defined for ${settings.name}');
      }
    }

    static Route<dynamic> _errorRoute(String message) {
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.of(_).pop(),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }