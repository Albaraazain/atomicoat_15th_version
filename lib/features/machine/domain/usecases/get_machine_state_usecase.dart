import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../entities/machine.dart';
import '../repositories/i_machine_repository.dart';

class GetMachineState implements UseCase<Machine, GetMachineStateParams> {
  final IMachineRepository repository;

  GetMachineState(this.repository);

  @override
  Future<Either<Failure, Machine>> call(GetMachineStateParams params) async {
    return await repository.getMachineState(params.machineId);
  }
}

class GetMachineStateParams extends Equatable {
  final String machineId;

  const GetMachineStateParams({required this.machineId});

  @override
  List<Object?> get props => [machineId];
}