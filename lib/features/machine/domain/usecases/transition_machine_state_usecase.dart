import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/machine.dart';
import '../repositories/i_machine_repository.dart';

/// Use case for transitioning machine state
class TransitionMachineStateUseCase implements UseCase<Machine, TransitionMachineStateParams> {
  final IMachineRepository repository;

  TransitionMachineStateUseCase(this.repository);

  @override
  Future<Either<Failure, Machine>> call(TransitionMachineStateParams params) {
    return repository.transitionState(
      machineId: params.machineId,
      newState: params.newState,
    );
  }
}

/// Parameters for transitioning machine state
class TransitionMachineStateParams extends Equatable {
  final String machineId;
  final MachineState newState;

  const TransitionMachineStateParams({
    required this.machineId,
    required this.newState,
  });

  @override
  List<Object> get props => [machineId, newState];
}