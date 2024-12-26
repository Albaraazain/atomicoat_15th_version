import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/auth/data/datasources/local/auth_local_source.dart';
import '../../features/auth/data/datasources/remote/auth_remote_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/i_auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/sign_in_usecase.dart';
import '../../features/auth/domain/usecases/sign_out_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/machine/data/datasources/local/machine_local_source.dart';
import '../../features/machine/data/datasources/remote/machine_remote_source.dart';
import '../../features/machine/data/repositories/machine_repository_impl.dart';
import '../../features/machine/domain/repositories/i_machine_repository.dart';
import '../../features/machine/domain/usecases/get_machine_state_usecase.dart';
import '../../features/machine/domain/usecases/update_component_state_usecase.dart';
import '../../features/machine/domain/usecases/set_parameter_value_usecase.dart';
import '../../features/machine/domain/usecases/get_parameter_history_usecase.dart';
import '../../features/machine/presentation/bloc/machine_bloc.dart';
import '../../features/auth/domain/repositories/i_user_repository.dart';
import '../../features/auth/domain/usecases/register_user_usecase.dart';
import '../../features/auth/data/datasources/remote/user_remote_source.dart';
import '../../features/auth/data/repositories/user_repository_impl.dart';
import '../../features/auth/data/datasources/remote/firebase_user_remote_source.dart';
import '../../features/recipe/data/datasources/remote/firebase_recipe_remote_source.dart';
import '../../features/recipe/data/repositories/recipe_repository_impl.dart';
import '../../features/recipe/domain/repositories/i_recipe_repository.dart';
import '../../features/recipe/domain/usecases/create_recipe_usecase.dart';
import '../../features/recipe/domain/usecases/delete_recipe_usecase.dart';
import '../../features/recipe/domain/usecases/get_recipe_by_id_usecase.dart';
import '../../features/recipe/domain/usecases/get_recipes_usecase.dart';
import '../../features/recipe/domain/usecases/update_recipe_usecase.dart';
import '../../features/recipe/presentation/bloc/recipe_bloc.dart';

final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => FirebaseFirestore.instance);

  // Auth Data sources
  getIt.registerLazySingleton<IAuthLocalSource>(
    () => AuthLocalSource(sharedPreferences: getIt()),
  );

  getIt.registerLazySingleton<IAuthRemoteSource>(
    () => FirebaseAuthRemoteSource(
      firebaseAuth: getIt(),
      firestore: getIt(),
    ),
  );

  getIt.registerLazySingleton<IUserRemoteSource>(
    () => FirebaseUserRemoteSource(
      firebaseAuth: getIt(),
      firestore: getIt(),
    ),
  );

  // Auth Repository
  getIt.registerLazySingleton<IAuthRepository>(
    () => AuthRepositoryImpl(
      remoteSource: getIt(),
      localSource: getIt(),
    ),
  );

  getIt.registerLazySingleton<IUserRepository>(
    () => UserRepositoryImpl(
      remoteSource: getIt(),
    ),
  );

  // Auth Use cases
  getIt.registerLazySingleton(() => SignInUseCase(getIt()));
  getIt.registerLazySingleton(() => SignOutUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCurrentUserUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterUserUseCase(getIt()));

  // Auth BLoC
  getIt.registerFactory(
    () => AuthBloc(
      signInUseCase: getIt(),
      signOutUseCase: getIt(),
      getCurrentUserUseCase: getIt(),
      registerUserUseCase: getIt(),
      userRepository: getIt(),
    ),
  );

  // Machine Data sources
  getIt.registerLazySingleton<MachineLocalSource>(
    () => MachineLocalSourceImpl(sharedPreferences: getIt()),
  );

  getIt.registerLazySingleton<MachineRemoteSource>(
    () => MachineRemoteSourceImpl(
      firestore: getIt(),
    ),
  );

  // Machine Repository
  getIt.registerLazySingleton<IMachineRepository>(
    () => MachineRepositoryImpl(
      remoteSource: getIt(),
      localSource: getIt(),
    ),
  );

  // Machine Use cases
  getIt.registerLazySingleton(() => GetMachineState(getIt()));
  getIt.registerLazySingleton(() => UpdateComponentState(getIt()));
  getIt.registerLazySingleton(() => SetParameterValue(getIt()));
  getIt.registerLazySingleton(() => GetParameterHistory(getIt()));

  // Machine BLoC
  getIt.registerFactory(
    () => MachineBloc(
      getMachineState: getIt(),
      updateComponentState: getIt(),
      setParameterValue: getIt(),
      getParameterHistory: getIt(),
      repository: getIt(),
    ),
  );

  // Recipe Data sources
  getIt.registerLazySingleton<IRecipeRemoteSource>(
    () => FirebaseRecipeRemoteSource(getIt()),
  );

  // Recipe Repository
  getIt.registerLazySingleton<IRecipeRepository>(
    () => RecipeRepositoryImpl(
      remoteSource: getIt(),
    ),
  );

  // Recipe Use cases
  getIt.registerLazySingleton(() => GetRecipesUseCase(getIt()));
  getIt.registerLazySingleton(() => GetRecipeByIdUseCase(getIt()));
  getIt.registerLazySingleton(() => CreateRecipeUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateRecipeUseCase(getIt()));
  getIt.registerLazySingleton(() => DeleteRecipeUseCase(getIt()));

  // Recipe BLoC
  getIt.registerFactory(
    () => RecipeBloc(
      getRecipes: getIt(),
      getRecipeById: getIt(),
      createRecipe: getIt(),
      updateRecipe: getIt(),
      deleteRecipe: getIt(),
    ),
  );
}