import 'package:equatable/equatable.dart';
import 'parameter.dart';

enum ComponentType {
  chamber,
  valve,
  pump,
  heater,
  nitrogenGenerator,
  massFlowController,
  vacuumPump,
}

enum ComponentState {
  off,
  idle,
  active,
  error,
  maintenance,
}

abstract class Component extends Equatable {
  final String id;
  final String name;
  final ComponentType type;
  final ComponentState state;
  final List<Parameter> parameters;
  final DateTime lastMaintenanceDate;
  final bool isOperational;

  const Component({
    required this.id,
    required this.name,
    required this.type,
    required this.state,
    required this.parameters,
    required this.lastMaintenanceDate,
    required this.isOperational,
  });

  Parameter? getParameter(String id) {
    try {
      return parameters.firstWhere((param) => param.id == id);
    } catch (e) {
      return null;
    }
  }

  bool get isSafe;

  bool get needsMaintenance {
    final timeSinceLastMaintenance = DateTime.now().difference(lastMaintenanceDate).inDays;
    return timeSinceLastMaintenance > 30;
  }

  @override
  List<Object?> get props => [
    id,
    name,
    type,
    state,
    parameters,
    lastMaintenanceDate,
    isOperational,
  ];
}