import 'package:equatable/equatable.dart';
import 'component.dart';
import 'components/valve.dart';
import 'components/heater.dart';
import 'components/vacuum_pump.dart';
import 'components/mass_flow_controller.dart';
import 'components/nitrogen_generator.dart';

enum MachineState {
  initializing,    // System is starting up and checking components
  standby,         // System is ready but not running a process
  purging,         // System is purging lines/chamber
  processPump,     // Pumping down to base pressure
  processIdle,     // Ready for ALD cycle
  precursor1Pulse, // First precursor injection
  precursor2Pulse, // Second precursor injection
  precursor1Purge, // First precursor purge
  precursor2Purge, // Second precursor purge
  processComplete, // Process finished successfully
  error,           // System error
  maintenance,     // System in maintenance mode
  shutdown,        // System shutting down
}

class Machine extends Equatable {
  final String id;
  final String serialNumber;
  final String name;
  final MachineState state;
  final List<Component> components;
  final DateTime lastMaintenanceDate;
  final bool isOperational;

  const Machine({
    required this.id,
    required this.serialNumber,
    required this.name,
    required this.state,
    required this.components,
    required this.lastMaintenanceDate,
    required this.isOperational,
  });

  // Component getters
  VacuumPump? get vacuumPump =>
    components.whereType<VacuumPump>().firstOrNull;

  List<Valve> get valves =>
    components.whereType<Valve>().toList();

  List<Heater> get heaters =>
    components.whereType<Heater>().toList();

  List<MassFlowController> get mfcs =>
    components.whereType<MassFlowController>().toList();

  NitrogenGenerator? get nitrogenGenerator =>
    components.whereType<NitrogenGenerator>().firstOrNull;

  // State validation methods
  bool get isReadyForProcess {
    if (state != MachineState.standby) return false;

    // Check vacuum pump
    final pump = vacuumPump;
    if (pump == null || !pump.isOperational || !pump.isSafe) return false;

    // Check nitrogen generator
    final n2gen = nitrogenGenerator;
    if (n2gen == null || !n2gen.isOperational || !n2gen.isSafe) return false;

    // Check heaters
    for (final heater in heaters) {
      if (!heater.isOperational || !heater.isSafe) return false;

      // Verify heaters are at correct temperatures
      final temp = heater.getParameter('temperature')?.value;
      final setpoint = heater.getParameter('setpoint')?.value;
      if (temp == null || setpoint == null || !heater.isTemperatureStable) {
        return false;
      }
    }

    // Check MFCs
    for (final mfc in mfcs) {
      if (!mfc.isOperational || !mfc.isSafe) return false;
    }

    // Check valves
    for (final valve in valves) {
      if (!valve.isOperational || !valve.isSafe) return false;
    }

    return true;
  }

  bool get canStartPurge {
    if (state != MachineState.standby && state != MachineState.processComplete) {
      return false;
    }

    final n2gen = nitrogenGenerator;
    if (n2gen == null || !n2gen.isOperational || !n2gen.isPuritySufficient) {
      return false;
    }

    // Check purge line MFCs
    final purgeMfcs = mfcs.where((mfc) => mfc.gasType == 'N2');
    for (final mfc in purgeMfcs) {
      if (!mfc.isOperational || !mfc.isSafe) return false;
    }

    return true;
  }

  bool get canStartPump {
    if (state != MachineState.purging) return false;

    final pump = vacuumPump;
    if (pump == null || !pump.isOperational || !pump.isSafe) return false;

    // All valves should be closed
    for (final valve in valves) {
      if (valve.isOpen) return false;
    }

    return true;
  }

  bool get canStartPrecursor1 {
    if (state != MachineState.processIdle && state != MachineState.precursor2Purge) {
      return false;
    }

    // Check precursor 1 specific components
    final precursor1Valve = valves
      .where((v) => v.location == ValveLocation.precursor1)
      .firstOrNull;
    if (precursor1Valve == null || !precursor1Valve.isOperational || !precursor1Valve.isSafe) {
      return false;
    }

    final precursor1Heater = heaters
      .where((h) => h.location == HeaterLocation.precursor1)
      .firstOrNull;
    if (precursor1Heater == null || !precursor1Heater.isOperational ||
        !precursor1Heater.isSafe || !precursor1Heater.isTemperatureStable) {
      return false;
    }

    return true;
  }

  bool get canStartPrecursor2 {
    if (state != MachineState.precursor1Purge) return false;

    // Check precursor 2 specific components
    final precursor2Valve = valves
      .where((v) => v.location == ValveLocation.precursor2)
      .firstOrNull;
    if (precursor2Valve == null || !precursor2Valve.isOperational || !precursor2Valve.isSafe) {
      return false;
    }

    final precursor2Heater = heaters
      .where((h) => h.location == HeaterLocation.precursor2)
      .firstOrNull;
    if (precursor2Heater == null || !precursor2Heater.isOperational ||
        !precursor2Heater.isSafe || !precursor2Heater.isTemperatureStable) {
      return false;
    }

    return true;
  }

  bool get canComplete {
    return state == MachineState.precursor2Purge;
  }

  bool get needsMaintenance =>
    DateTime.now().difference(lastMaintenanceDate).inDays > 30 ||
    components.any((component) => component.needsMaintenance);

  bool get hasErrors =>
    components.any((component) => component.state == ComponentState.error);

  // State transition validation
  bool canTransitionTo(MachineState newState) {
    switch (newState) {
      case MachineState.standby:
        return state == MachineState.initializing && isReadyForProcess;

      case MachineState.purging:
        return canStartPurge;

      case MachineState.processPump:
        return canStartPump;

      case MachineState.processIdle:
        return state == MachineState.processPump &&
               vacuumPump?.isAtTargetPressure == true;

      case MachineState.precursor1Pulse:
        return canStartPrecursor1;

      case MachineState.precursor1Purge:
        return state == MachineState.precursor1Pulse;

      case MachineState.precursor2Pulse:
        return canStartPrecursor2;

      case MachineState.precursor2Purge:
        return state == MachineState.precursor2Pulse;

      case MachineState.processComplete:
        return canComplete;

      case MachineState.error:
        return true; // Can transition to error from any state

      case MachineState.maintenance:
        return state == MachineState.standby && needsMaintenance;

      case MachineState.shutdown:
        return state == MachineState.standby || state == MachineState.error;

      case MachineState.initializing:
        return state == MachineState.shutdown; // Only when restarting

      default:
        return false;
    }
  }

  @override
  List<Object?> get props => [
    id,
    serialNumber,
    name,
    state,
    components,
    lastMaintenanceDate,
    isOperational,
  ];

  Machine copyWith({
    String? id,
    String? serialNumber,
    String? name,
    MachineState? state,
    List<Component>? components,
    DateTime? lastMaintenanceDate,
    bool? isOperational,
  }) {
    return Machine(
      id: id ?? this.id,
      serialNumber: serialNumber ?? this.serialNumber,
      name: name ?? this.name,
      state: state ?? this.state,
      components: components ?? this.components,
      lastMaintenanceDate: lastMaintenanceDate ?? this.lastMaintenanceDate,
      isOperational: isOperational ?? this.isOperational,
    );
  }

  // Helper method to get a specific component by ID
  T? getComponent<T extends Component>(String id) {
    try {
      return components.firstWhere((c) => c.id == id) as T;
    } catch (e) {
      return null;
    }
  }

  // Helper method to check if all components are in a safe state
  bool get areAllComponentsSafe =>
      components.every((component) => component.isSafe);

  // Helper method to check if all components are operational
  bool get areAllComponentsOperational =>
      components.every((component) => component.isOperational);

  // Helper method to get all components in error state
  List<Component> get componentsInError =>
      components.where((component) => component.state == ComponentState.error).toList();

  // Helper method to check if machine can be started
  bool get canStart =>
      isOperational && areAllComponentsSafe && areAllComponentsOperational && !hasErrors;

  @override
  String toString() =>
      'Machine(id: $id, name: $name, state: $state, isOperational: $isOperational)';
}