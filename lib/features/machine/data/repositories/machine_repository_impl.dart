import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/machine.dart';
import '../../domain/entities/component.dart';
import '../../domain/entities/parameter.dart';
import '../../domain/repositories/i_machine_repository.dart';
import '../datasources/local/machine_local_source.dart';
import '../datasources/remote/machine_remote_source.dart';

class MachineRepositoryImpl implements IMachineRepository {
  final MachineRemoteSource remoteSource;
  final MachineLocalSource localSource;

  MachineRepositoryImpl({
    required this.remoteSource,
    required this.localSource,
  });

  @override
  Future<Either<Failure, Machine>> getMachineState(String machineId) async {
    try {
      final machineDTO = await remoteSource.fetchMachineState(machineId);
      await localSource.cacheComponentStates(machineDTO);
      return Right(machineDTO.toDomain());
    } catch (e) {
      try {
        final cachedMachine = await localSource.getCachedMachineState(machineId);
        return Right(cachedMachine.toDomain());
      } catch (e) {
        return Left(ServerFailure(message: 'Failed to get machine state: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, Component>> updateComponentState(
    String machineId,
    String componentId,
    ComponentState newState,
  ) async {
    try {
      final componentDTO = await remoteSource.updateComponentState(
        machineId,
        componentId,
        newState,
      );
      return Right(componentDTO.toDomain());
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to update component state: $e'));
    }
  }

  @override
  Future<Either<Failure, Parameter>> setParameterValue(
    String machineId,
    String componentId,
    String parameterId,
    double value,
  ) async {
    try {
      final parameterDTO = await remoteSource.setParameterValue(
        machineId,
        componentId,
        parameterId,
        value,
      );
      return Right(parameterDTO.toDomain());
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to set parameter value: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Parameter>>> getParameterHistory(
    String machineId,
    String componentId,
    String parameterId,
    DateTime startTime,
    DateTime endTime,
  ) async {
    try {
      final parameterDTOs = await remoteSource.getParameterReadings(
        machineId,
        componentId,
        parameterId,
        startTime,
        endTime,
      );
      return Right(parameterDTOs.map((dto) => dto.toDomain()).toList());
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get parameter history: $e'));
    }
  }

  @override
  Stream<Either<Failure, Machine>> watchMachineState(String machineId) async* {
    try {
      await for (final machineDTO in remoteSource.watchMachineState(machineId)) {
        yield Right(machineDTO.toDomain());
      }
    } catch (e) {
      yield Left(ServerFailure(message: 'Failed to watch machine state: $e'));
    }
  }

  @override
  Stream<Either<Failure, Component>> watchComponent(
    String machineId,
    String componentId,
  ) async* {
    try {
      await for (final componentDTO
          in remoteSource.watchComponent(machineId, componentId)) {
        yield Right(componentDTO.toDomain());
      }
    } catch (e) {
      yield Left(ServerFailure(message: 'Failed to watch component: $e'));
    }
  }

  @override
  Stream<Either<Failure, Parameter>> watchParameter(
    String machineId,
    String componentId,
    String parameterId,
  ) async* {
    try {
      await for (final parameterDTO in remoteSource.watchParameter(
        machineId,
        componentId,
        parameterId,
      )) {
        yield Right(parameterDTO.toDomain());
      }
    } catch (e) {
      yield Left(ServerFailure(message: 'Failed to watch parameter: $e'));
    }
  }

  @override
  Future<Either<Failure, Machine>> transitionState({
    required String machineId,
    required MachineState newState,
  }) async {
    try {
      final machineDTO = await remoteSource.transitionMachineState(
        machineId,
        newState,
      );
      await localSource.cacheComponentStates(machineDTO);
      return Right(machineDTO.toDomain());
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to transition machine state: $e'));
    }
  }
}