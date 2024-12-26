import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/i_user_repository.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/register_user_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/value_objects/email.dart';
import '../../domain/value_objects/user_id.dart';
import '../../../../core/usecase/usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../../../core/utils/app_logger.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase _signInUseCase;
  final SignOutUseCase _signOutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final RegisterUserUseCase _registerUserUseCase;
  final IUserRepository _userRepository;

  AuthBloc({
    required SignInUseCase signInUseCase,
    required SignOutUseCase signOutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required RegisterUserUseCase registerUserUseCase,
    required IUserRepository userRepository,
  })  : _signInUseCase = signInUseCase,
        _signOutUseCase = signOutUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _registerUserUseCase = registerUserUseCase,
        _userRepository = userRepository,
        super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<SignInRequested>(_onSignInRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<UserUpdated>(_onUserUpdated);
    on<ApproveRegistration>(_onApproveRegistration);
    on<RejectRegistration>(_onRejectRegistration);
    on<LoadPendingRegistrations>(_onLoadPendingRegistrations);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    AppLogger.info('Starting auth status check');
    emit(AuthLoading());

    AppLogger.info('Getting current user');
    final result = await _getCurrentUserUseCase(const NoParams());

    result.fold(
      (failure) {
        AppLogger.error('Failed to get current user', failure.toString(), StackTrace.current);
        emit(Unauthenticated());
      },
      (user) {
        AppLogger.info('Got current user with approval status: ${user.approvalStatus}');
        switch (user.approvalStatus) {
          case UserApprovalStatus.approved:
            AppLogger.info('User is approved, emitting Authenticated state');
            emit(Authenticated(user));
            break;
          case UserApprovalStatus.pending:
            AppLogger.info('User registration is pending approval');
            emit(PendingApproval(user));
            break;
          case UserApprovalStatus.rejected:
            AppLogger.info('User registration was rejected');
            emit(RegistrationRejected(user, user.rejectionReason ?? 'No reason provided'));
            break;
        }
      },
    );
  }

  void _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    AppLogger.info('Starting sign in request in bloc');
    emit(AuthLoading());

    final email = Email.create(event.email);
    if (email == null) {
      emit(const AuthError('Invalid email format'));
      return;
    }
    AppLogger.info('Email format validated');

    AppLogger.info('Calling sign in use case');
    final result = await _signInUseCase(
      SignInParams(
        email: email,
        password: event.password,
      ),
    );

    await result.fold(
      (failure) async {
        AppLogger.error('Sign in failed', failure, StackTrace.current);
        emit(AuthError(failure.message));
      },
      (token) async {
        AppLogger.info('Successfully got token from remote source');
        AppLogger.info('Getting current user');

        final userResult = await _getCurrentUserUseCase(const NoParams());

        await userResult.fold(
          (failure) async {
            AppLogger.error('Failed to get current user', failure, StackTrace.current);
            emit(AuthError(failure.message));
          },
          (user) async {
            AppLogger.info('Successfully got current user: ${user.email}');
            switch (user.approvalStatus) {
              case UserApprovalStatus.approved:
                emit(Authenticated(user));
                break;
              case UserApprovalStatus.pending:
                emit(PendingApproval(user));
                break;
              case UserApprovalStatus.rejected:
                emit(RegistrationRejected(user, user.rejectionReason ?? 'No reason provided'));
                break;
            }
          },
        );
      },
    );
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _signOutUseCase(const NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(Unauthenticated()),
    );
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final email = Email.create(event.email);
    if (email == null) {
      emit(const AuthError('Invalid email format'));
      return;
    }

    final result = await _registerUserUseCase(RegisterUserParams(
      name: event.name,
      email: email,
      password: event.password,
      machineSerialNumber: event.machineSerialNumber,
    ));

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(PendingApproval(user)),
    );
  }

  Future<void> _onUserUpdated(
    UserUpdated event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _getCurrentUserUseCase(const NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) {
        switch (user.approvalStatus) {
          case UserApprovalStatus.approved:
            emit(Authenticated(user));
            break;
          case UserApprovalStatus.pending:
            emit(PendingApproval(user));
            break;
          case UserApprovalStatus.rejected:
            emit(RegistrationRejected(user, user.rejectionReason ?? 'No reason provided'));
            break;
        }
      },
    );
  }

  Future<void> _onApproveRegistration(
    ApproveRegistration event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final userId = UserId.create(event.userId);
    if (userId == null) {
      emit(const AuthError('Invalid user ID'));
      return;
    }

    final result = await _userRepository.approveRegistration(
      userId: userId,
      role: event.assignedRole,
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onRejectRegistration(
    RejectRegistration event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final userId = UserId.create(event.userId);
    if (userId == null) {
      emit(const AuthError('Invalid user ID'));
      return;
    }

    final result = await _userRepository.rejectRegistration(
      userId: userId,
      reason: event.reason,
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(RegistrationRejected(user, event.reason)),
    );
  }

  Future<void> _onLoadPendingRegistrations(
    LoadPendingRegistrations event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _userRepository.getPendingRegistrations();

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (users) => emit(PendingRegistrationsLoaded(users)),
    );
  }

  UserRole _mapStringToUserRole(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'engineer':
        return UserRole.engineer;
      case 'researcher':
        return UserRole.researcher;
      default:
        throw ArgumentError('Invalid user role: $role');
    }
  }

  bool _isValidEmail(String email) {
    // Implement your email validation logic here
    return true;
  }
}