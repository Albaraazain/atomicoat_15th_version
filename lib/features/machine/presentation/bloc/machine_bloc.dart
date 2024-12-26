import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/parameter.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_machine_state_usecase.dart';
import '../../domain/usecases/update_component_state_usecase.dart';
import '../../domain/usecases/set_parameter_value_usecase.dart';
import '../../domain/usecases/get_parameter_history_usecase.dart';
import '../../domain/repositories/i_machine_repository.dart';
import '../../domain/entities/machine.dart' as domain;
import 'machine_event.dart';
import 'machine_state.dart';

class MachineBloc extends Bloc<MachineEvent, MachineState> {
  final GetMachineState getMachineState;
  final UpdateComponentState updateComponentState;
  final SetParameterValue setParameterValue;
  final GetParameterHistory getParameterHistory;
  final IMachineRepository repository;

  StreamSubscription? _machineSubscription;
  StreamSubscription? _componentSubscription;
  StreamSubscription? _parameterSubscription;

  MachineBloc({
    required this.getMachineState,
    required this.updateComponentState,
    required this.setParameterValue,
    required this.getParameterHistory,
    required this.repository,
  }) : super(MachineInitial()) {
    on<GetMachineStateEvent>(_onGetMachineState);
    on<UpdateComponentStateEvent>(_onUpdateComponentState);
    on<SetParameterValueEvent>(_onSetParameterValue);
    on<StartWatchingMachineEvent>(_onStartWatchingMachine);
    on<StopWatchingMachineEvent>(_onStopWatchingMachine);
    on<StartWatchingComponentEvent>(_onStartWatchingComponent);
    on<StopWatchingComponentEvent>(_onStopWatchingComponent);
    on<StartWatchingParameterEvent>(_onStartWatchingParameter);
    on<StopWatchingParameterEvent>(_onStopWatchingParameter);
    on<GetParameterHistoryEvent>(_onGetParameterHistory);
  }

  Future<void> _onGetMachineState(
    GetMachineStateEvent event,
    Emitter<MachineState> emit,
  ) async {
    emit(MachineLoading());
    final result = await getMachineState(GetMachineStateParams(
      machineId: event.machineId,
    ));
    result.fold(
      (failure) => emit(MachineError(failure.message)),
      (machine) => emit(MachineLoaded(machine)),
    );
  }

  Future<void> _onUpdateComponentState(
    UpdateComponentStateEvent event,
    Emitter<MachineState> emit,
  ) async {
    final result = await updateComponentState(UpdateComponentStateParams(
      machineId: event.machineId,
      componentId: event.componentId,
      newState: event.newState,
    ));
    result.fold(
      (failure) => emit(ComponentError(failure.message)),
      (component) => emit(ComponentUpdated(component)),
    );
  }

  Future<void> _onSetParameterValue(
    SetParameterValueEvent event,
    Emitter<MachineState> emit,
  ) async {
    final result = await setParameterValue(SetParameterValueParams(
      machineId: event.machineId,
      componentId: event.componentId,
      parameterId: event.parameterId,
      value: event.value,
    ));
    result.fold(
      (failure) => emit(ParameterError(failure.message)),
      (parameter) => emit(ParameterUpdated(parameter)),
    );
  }

  Future<void> _onGetParameterHistory(
    GetParameterHistoryEvent event,
    Emitter<MachineState> emit,
  ) async {
    emit(ParameterHistoryLoading());
    final result = await getParameterHistory(GetParameterHistoryParams(
      machineId: event.machineId,
      componentId: event.componentId,
      parameterId: event.parameterId,
      startTime: event.startTime,
      endTime: event.endTime,
    ));
    result.fold(
      (failure) => emit(ParameterHistoryError(failure.message)),
      (parameters) => emit(ParameterHistoryLoaded(parameters)),
    );
  }

  Future<void> _onStartWatchingMachine(
    StartWatchingMachineEvent event,
    Emitter<MachineState> emit,
  ) async {
    await _machineSubscription?.cancel();
    await emit.forEach<Either<Failure, domain.Machine>>(
      repository.watchMachineState(event.machineId),
      onData: (result) => result.fold(
        (failure) => MachineError(failure.message),
        (machine) => WatchingMachine(machine),
      ),
    );
  }

  Future<void> _onStopWatchingMachine(
    StopWatchingMachineEvent event,
    Emitter<MachineState> emit,
  ) async {
    await _machineSubscription?.cancel();
    _machineSubscription = null;
  }

  Future<void> _onStartWatchingComponent(
    StartWatchingComponentEvent event,
    Emitter<MachineState> emit,
  ) async {
    await _componentSubscription?.cancel();
    _componentSubscription = repository
        .watchComponent(event.machineId, event.componentId)
        .listen((result) {
          result.fold(
            (failure) => emit(ComponentError(failure.message)),
            (component) => emit(WatchingComponent(component)),
          );
        });
  }

  Future<void> _onStopWatchingComponent(
    StopWatchingComponentEvent event,
    Emitter<MachineState> emit,
  ) async {
    await _componentSubscription?.cancel();
    _componentSubscription = null;
  }

  Future<void> _onStartWatchingParameter(
    StartWatchingParameterEvent event,
    Emitter<MachineState> emit,
  ) async {
    await _parameterSubscription?.cancel();
    await emit.forEach<Either<Failure, Parameter>>(
      repository.watchParameter(
        event.machineId,
        event.componentId,
        event.parameterId,
      ),
      onData: (result) => result.fold(
        (failure) => ParameterError(failure.message ?? 'Unknown error'),
        (parameter) => WatchingParameter(parameter),
      ),
    );
  }

  Future<void> _onStopWatchingParameter(
    StopWatchingParameterEvent event,
    Emitter<MachineState> emit,
  ) async {
    await _parameterSubscription?.cancel();
    _parameterSubscription = null;
  }

  @override
  Future<void> close() {
    _machineSubscription?.cancel();
    _componentSubscription?.cancel();
    _parameterSubscription?.cancel();
    return super.close();
  }
}