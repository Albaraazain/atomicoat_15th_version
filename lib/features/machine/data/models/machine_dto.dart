import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/machine.dart';
import 'component_dto.dart';

part 'machine_dto.g.dart';

@JsonSerializable()
class MachineDTO {
  final String id;
  @JsonKey(name: 'serialNumber')
  final String serialNumber;
  final String name;
  @JsonKey(name: 'state', defaultValue: 'standby')
  final String machineStateString;
  @JsonKey(defaultValue: [])
  final List<ComponentDTO> components;
  @JsonKey(name: 'lastMaintenanceDate')
  final DateTime lastMaintenanceDate;
  @JsonKey(name: 'isOperational', defaultValue: true)
  final bool isOperational;

  const MachineDTO({
    required this.id,
    required this.serialNumber,
    required this.name,
    required this.machineStateString,
    this.components = const [],
    required this.lastMaintenanceDate,
    required this.isOperational,
  });

  // From JSON
  factory MachineDTO.fromJson(Map<String, dynamic> json) =>
      _$MachineDTOFromJson(json);

  // To JSON
  Map<String, dynamic> toJson() => _$MachineDTOToJson(this);

  // To Domain
  Machine toDomain() {
    return Machine(
      id: id,
      serialNumber: serialNumber,
      name: name,
      state: _parseState(machineStateString),
      components: components.map((c) => c.toDomain()).toList(),
      lastMaintenanceDate: lastMaintenanceDate,
      isOperational: isOperational,
    );
  }

  // From Domain
  factory MachineDTO.fromDomain(Machine machine) {
    return MachineDTO(
      id: machine.id,
      serialNumber: machine.serialNumber,
      name: machine.name,
      machineStateString: _stateToString(machine.state),
      components: machine.components
          .map((component) => ComponentDTO.fromDomain(component))
          .toList(),
      lastMaintenanceDate: machine.lastMaintenanceDate,
      isOperational: machine.isOperational,
    );
  }

  // Helper methods
  static MachineState _parseState(String state) {
    switch (state.toLowerCase()) {
      case 'initializing':
        return MachineState.initializing;
      case 'standby':
        return MachineState.standby;
      case 'purging':
        return MachineState.purging;
      case 'processpump':
        return MachineState.processPump;
      case 'processidle':
        return MachineState.processIdle;
      case 'precursor1pulse':
        return MachineState.precursor1Pulse;
      case 'precursor2pulse':
        return MachineState.precursor2Pulse;
      case 'precursor1purge':
        return MachineState.precursor1Purge;
      case 'precursor2purge':
        return MachineState.precursor2Purge;
      case 'processcomplete':
        return MachineState.processComplete;
      case 'error':
        return MachineState.error;
      case 'maintenance':
        return MachineState.maintenance;
      case 'shutdown':
        return MachineState.shutdown;
      default:
        return MachineState.error;
    }
  }

  static String _stateToString(MachineState state) {
    switch (state) {
      case MachineState.initializing:
        return 'initializing';
      case MachineState.standby:
        return 'standby';
      case MachineState.purging:
        return 'purging';
      case MachineState.processPump:
        return 'processpump';
      case MachineState.processIdle:
        return 'processidle';
      case MachineState.precursor1Pulse:
        return 'precursor1pulse';
      case MachineState.precursor2Pulse:
        return 'precursor2pulse';
      case MachineState.precursor1Purge:
        return 'precursor1purge';
      case MachineState.precursor2Purge:
        return 'precursor2purge';
      case MachineState.processComplete:
        return 'processcomplete';
      case MachineState.error:
        return 'error';
      case MachineState.maintenance:
        return 'maintenance';
      case MachineState.shutdown:
        return 'shutdown';
    }
  }
}