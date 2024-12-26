import 'package:dartz/dartz.dart';
import '../entities/machine.dart';
import '../entities/component.dart';
import '../entities/parameter.dart';
import '../../../../core/error/failures.dart';

abstract class IMachineRepository {
  /// Get machine state and details
  Future<Either<Failure, Machine>> getMachineState(String machineId);

  /// Update component state
  Future<Either<Failure, Component>> updateComponentState(
    String machineId,
    String componentId,
    ComponentState newState,
  );

  /// Set parameter value
  Future<Either<Failure, Parameter>> setParameterValue(
    String machineId,
    String componentId,
    String parameterId,
    double value,
  );

  /// Get parameter history
  Future<Either<Failure, List<Parameter>>> getParameterHistory(
    String machineId,
    String componentId,
    String parameterId,
    DateTime startTime,
    DateTime endTime,
  );

  /// Stream of machine state updates
  Stream<Either<Failure, Machine>> watchMachineState(String machineId);

  /// Stream of component updates
  Stream<Either<Failure, Component>> watchComponent(
    String machineId,
    String componentId,
  );

  /// Stream of parameter updates
  Stream<Either<Failure, Parameter>> watchParameter(
    String machineId,
    String componentId,
    String parameterId,
  );

  /// Transition machine state
  Future<Either<Failure, Machine>> transitionState({
    required String machineId,
    required MachineState newState,
  });
}