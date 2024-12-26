import 'package:equatable/equatable.dart';
import '../../domain/entities/machine.dart';
import '../../domain/entities/component.dart';
import '../../domain/entities/parameter.dart';

abstract class MachineState extends Equatable {
  const MachineState();

  @override
  List<Object?> get props => [];
}

class MachineInitial extends MachineState {}

class MachineLoading extends MachineState {}

class MachineLoaded extends MachineState {
  final Machine machine;

  const MachineLoaded(this.machine);

  @override
  List<Object?> get props => [machine];
}

class ComponentUpdated extends MachineState {
  final Component component;

  const ComponentUpdated(this.component);

  @override
  List<Object?> get props => [component];
}

class ParameterUpdated extends MachineState {
  final Parameter parameter;

  const ParameterUpdated(this.parameter);

  @override
  List<Object?> get props => [parameter];
}

class MachineError extends MachineState {
  final String message;

  const MachineError(this.message);

  @override
  List<Object?> get props => [message];
}

class ComponentError extends MachineState {
  final String message;

  const ComponentError(this.message);

  @override
  List<Object?> get props => [message];
}

class ParameterError extends MachineState {
  final String message;

  const ParameterError(this.message);

  @override
  List<Object?> get props => [message];
}

class WatchingMachine extends MachineState {
  final Machine machine;

  const WatchingMachine(this.machine);

  @override
  List<Object?> get props => [machine];
}

class WatchingComponent extends MachineState {
  final Component component;

  const WatchingComponent(this.component);

  @override
  List<Object?> get props => [component];
}

class WatchingParameter extends MachineState {
  final Parameter parameter;

  const WatchingParameter(this.parameter);

  @override
  List<Object?> get props => [parameter];
}

// Parameter History States
class ParameterHistoryLoading extends MachineState {}

class ParameterHistoryLoaded extends MachineState {
  final List<Parameter> parameters;

  const ParameterHistoryLoaded(this.parameters);

  @override
  List<Object?> get props => [parameters];
}

class ParameterHistoryError extends MachineState {
  final String message;

  const ParameterHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}