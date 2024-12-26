import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../entities/parameter.dart';
import '../repositories/i_machine_repository.dart';

class GetParameterHistory implements UseCase<List<Parameter>, GetParameterHistoryParams> {
  final IMachineRepository repository;

  GetParameterHistory(this.repository);

  @override
  Future<Either<Failure, List<Parameter>>> call(GetParameterHistoryParams params) async {
    return await repository.getParameterHistory(
      params.machineId,
      params.componentId,
      params.parameterId,
      params.startTime,
      params.endTime,
    );
  }
}

class GetParameterHistoryParams extends Equatable {
  final String machineId;
  final String componentId;
  final String parameterId;
  final DateTime startTime;
  final DateTime endTime;

  const GetParameterHistoryParams({
    required this.machineId,
    required this.componentId,
    required this.parameterId,
    required this.startTime,
    required this.endTime,
  });

  @override
  List<Object?> get props => [
    machineId,
    componentId,
    parameterId,
    startTime,
    endTime,
  ];
}