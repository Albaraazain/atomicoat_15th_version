import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../entities/parameter.dart';
import '../repositories/i_machine_repository.dart';

class SetParameterValue implements UseCase<Parameter, SetParameterValueParams> {
  final IMachineRepository repository;

  SetParameterValue(this.repository);

  @override
  Future<Either<Failure, Parameter>> call(SetParameterValueParams params) async {
    return await repository.setParameterValue(
      params.machineId,
      params.componentId,
      params.parameterId,
      params.value,
    );
  }
}

class SetParameterValueParams extends Equatable {
  final String machineId;
  final String componentId;
  final String parameterId;
  final double value;

  const SetParameterValueParams({
    required this.machineId,
    required this.componentId,
    required this.parameterId,
    required this.value,
  });

  @override
  List<Object?> get props => [machineId, componentId, parameterId, value];
}