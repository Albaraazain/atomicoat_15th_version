import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/di/injection.dart';
import 'core/di/hive_adapters.dart';
import 'core/config/route_config.dart';
import 'core/config/theme_config.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/domain/entities/user.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/registration_pending_page.dart';
import 'features/auth/presentation/pages/registration_rejected_page.dart';
import 'features/machine/presentation/bloc/machine_bloc.dart';
import 'features/machine/presentation/pages/machine_dashboard_page.dart';
import 'features/recipe/presentation/bloc/recipe_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize Hive
  await Hive.initFlutter();
  await registerHiveAdapters();

  // Initialize dependencies
  await initializeDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Auth BLoC
        BlocProvider<AuthBloc>(
          create: (_) {
            final bloc = getIt<AuthBloc>();
            bloc.add(CheckAuthStatus());
            return bloc;
          },
        ),
        // Machine BLoC
        BlocProvider<MachineBloc>(
          create: (_) => getIt<MachineBloc>(),
        ),
        // Recipe BLoC
        BlocProvider<RecipeBloc>(
          create: (_) => getIt<RecipeBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'AtomiCoat',
        theme: ThemeConfig.darkTheme,
        darkTheme: ThemeConfig.darkTheme,
        themeMode: ThemeMode.dark,
        // If you’re removing 'home:', do it here
        // home: const RootPage(),
        onGenerateRoute: RouteConfig.generateRoute,
        navigatorObservers: [
          LoggingNavigatorObserver(), // <--- Attach the observer
        ],
      ),
    );
  }
}

class LoggingNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    debugPrint(
        '[NAVIGATION] didPush => ${route.settings.name} (prev: ${previousRoute?.settings.name})');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    debugPrint(
        '[NAVIGATION] didPop => ${route.settings.name} (new top: ${previousRoute?.settings.name})');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    debugPrint(
        '[NAVIGATION] didReplace => ${oldRoute?.settings.name} -> ${newRoute?.settings.name}');
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    debugPrint(
        '[NAVIGATION] didRemove => ${route.settings.name} (new top: ${previousRoute?.settings.name})');
  }
}

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial || state is AuthLoading) {
          return Scaffold(
            body: Container(
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
            ),
          );
        }

        if (state is Authenticated) {
          if (state.user.approvalStatus == UserApprovalStatus.pending) {
            return const RegistrationPendingPage();
          }
          if (state.user.approvalStatus == UserApprovalStatus.rejected) {
            return RegistrationRejectedPage(
                reason: state.user.rejectionReason!);
          }
          return MachineDashboardPage(
              machineId: state.user.machineSerialNumber);
        }

        return const LoginPage();
      },
    );
  }
}
