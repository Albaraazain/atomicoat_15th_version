import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../entities/component.dart';
import '../repositories/i_machine_repository.dart';

class UpdateComponentState implements UseCase<Component, UpdateComponentStateParams> {
  final IMachineRepository repository;

  UpdateComponentState(this.repository);

  @override
  Future<Either<Failure, Component>> call(UpdateComponentStateParams params) async {
    return await repository.updateComponentState(
      params.machineId,
      params.componentId,
      params.newState,
    );
  }
}

class UpdateComponentStateParams extends Equatable {
  final String machineId;
  final String componentId;
  final ComponentState newState;

  const UpdateComponentStateParams({
    required this.machineId,
    required this.componentId,
    required this.newState,
  });

  @override
  List<Object?> get props => [machineId, componentId, newState];
}