import 'package:equatable/equatable.dart';
import '../../domain/entities/component.dart';

abstract class MachineEvent extends Equatable {
  const MachineEvent();

  @override
  List<Object?> get props => [];
}

class GetMachineStateEvent extends MachineEvent {
  final String machineId;

  const GetMachineStateEvent(this.machineId);

  @override
  List<Object?> get props => [machineId];
}

class UpdateComponentStateEvent extends MachineEvent {
  final String machineId;
  final String componentId;
  final ComponentState newState;

  const UpdateComponentStateEvent({
    required this.machineId,
    required this.componentId,
    required this.newState,
  });

  @override
  List<Object?> get props => [machineId, componentId, newState];
}

class SetParameterValueEvent extends MachineEvent {
  final String machineId;
  final String componentId;
  final String parameterId;
  final double value;

  const SetParameterValueEvent({
    required this.machineId,
    required this.componentId,
    required this.parameterId,
    required this.value,
  });

  @override
  List<Object?> get props => [machineId, componentId, parameterId, value];
}

class StartWatchingMachineEvent extends MachineEvent {
  final String machineId;

  const StartWatchingMachineEvent(this.machineId);

  @override
  List<Object?> get props => [machineId];
}

class StopWatchingMachineEvent extends MachineEvent {
  const StopWatchingMachineEvent();
}

class StartWatchingComponentEvent extends MachineEvent {
  final String machineId;
  final String componentId;

  const StartWatchingComponentEvent({
    required this.machineId,
    required this.componentId,
  });

  @override
  List<Object?> get props => [machineId, componentId];
}

class StopWatchingComponentEvent extends MachineEvent {
  const StopWatchingComponentEvent();
}

class StartWatchingParameterEvent extends MachineEvent {
  final String machineId;
  final String componentId;
  final String parameterId;

  const StartWatchingParameterEvent({
    required this.machineId,
    required this.componentId,
    required this.parameterId,
  });

  @override
  List<Object?> get props => [machineId, componentId, parameterId];
}

class StopWatchingParameterEvent extends MachineEvent {
  const StopWatchingParameterEvent();
}

class GetParameterHistoryEvent extends MachineEvent {
  final String machineId;
  final String componentId;
  final String parameterId;
  final DateTime startTime;
  final DateTime endTime;

  const GetParameterHistoryEvent({
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