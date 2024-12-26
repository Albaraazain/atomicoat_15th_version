import 'dart:async';
import '../utils/app_logger.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/machine/presentation/bloc/machine_bloc.dart';
import '../../features/machine/presentation/bloc/machine_state.dart';
import '../../features/machine/presentation/bloc/machine_event.dart';

class StateSyncService {
  final AuthBloc _authBloc;
  final MachineBloc _machineBloc;

  StateSyncService({
    required AuthBloc authBloc,
    required MachineBloc machineBloc,
  })  : _authBloc = authBloc,
        _machineBloc = machineBloc {
    _authBloc.stream.listen(_handleAuthStateChange);
  }

  Future<void> _handleAuthStateChange(AuthState state) async {
    if (state is Authenticated) {
      await _handleSignIn();
    } else {
      await _handleSignOut();
    }
  }

  Future<void> _handleSignOut() async {
    // Wait for any ongoing machine operations to complete
    if (_machineBloc.state is! MachineInitial) {
      await _waitForMachineStateCompletion();
    }

    // Clear machine data
    _machineBloc.add(const StopWatchingMachineEvent());
  }

  Future<void> _handleSignIn() async {
    // Wait for any ongoing machine operations to complete
    if (_machineBloc.state is! MachineInitial) {
      await _waitForMachineStateCompletion();
    }

    // Load initial machine data
    if (_machineBloc.state is MachineInitial) {
      final authState = _authBloc.state as Authenticated;
      _machineBloc.add(GetMachineStateEvent(authState.user.machineSerialNumber));
    }
  }

  Future<void> _waitForMachineStateCompletion() async {
    final completer = Completer<void>();
    late StreamSubscription<MachineState> subscription;

    subscription = _machineBloc.stream.listen(
      (state) {
        if (state is! MachineLoading) {
          subscription.cancel();
          if (!completer.isCompleted) {
            completer.complete();
          }
        }
      },
      onError: (error) {
        subscription.cancel();
        if (!completer.isCompleted) {
          completer.completeError(error);
        }
      },
    );

    try {
      await completer.future.timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          subscription.cancel();
          AppLogger.warning('Timeout waiting for machine state completion');
        },
      );
    } catch (e) {
      subscription.cancel();
      rethrow;
    }
  }
}