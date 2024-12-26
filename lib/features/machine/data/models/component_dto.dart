import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/component.dart';
import '../../domain/entities/components/chamber.dart';
import '../../domain/entities/components/valve.dart';
import '../../domain/entities/components/vacuum_pump.dart';
import '../../domain/entities/components/heater.dart';
import '../../domain/entities/components/mass_flow_controller.dart';
import '../../domain/entities/components/nitrogen_generator.dart';
import 'parameter_dto.dart';

part 'component_dto.g.dart';

@JsonSerializable()
class ComponentDTO {
  final String id;
  final String name;
  @JsonKey(name: 'type')
  final String componentTypeString;
  @JsonKey(name: 'state')
  final String componentStateString;
  final List<ParameterDTO> parameters;
  @JsonKey(name: 'lastMaintenanceDate')
  final DateTime lastMaintenanceDate;
  final bool isOperational;

  // Chamber-specific fields
  final double? volume;
  final String? material;
  final double? maxPressure;
  final double? maxTemperature;

  // Valve-specific fields
  final String? valveLocationString;
  final bool? isNormallyOpen;
  final int? cycleCount;
  final int? maxCycles;

  // VacuumPump-specific fields
  final double? baselinePressure;
  final double? maxInletPressure;
  final int? operatingHours;
  final int? maxOperatingHours;

  // Heater-specific fields
  final String? heaterLocationString;
  final double? maxPower;
  final double? rampRate;
  final double? steadyStateError;
  final String? heatingElementMaterial;
  final int? powerCycles;
  final int? maxPowerCycles;

  // MassFlowController-specific fields
  final double? maxFlowRate;
  final double? minFlowRate;
  final double? accuracy;
  final String? gasType;

  // NitrogenGenerator-specific fields
  final double? minPurity;
  final double? currentPurity;

  const ComponentDTO({
    required this.id,
    required this.name,
    required this.componentTypeString,
    required this.componentStateString,
    required this.parameters,
    required this.lastMaintenanceDate,
    required this.isOperational,
    // Chamber fields
    this.volume,
    this.material,
    this.maxPressure,
    this.maxTemperature,
    // Valve fields
    this.valveLocationString,
    this.isNormallyOpen,
    this.cycleCount,
    this.maxCycles,
    // VacuumPump fields
    this.baselinePressure,
    this.maxInletPressure,
    this.operatingHours,
    this.maxOperatingHours,
    // Heater fields
    this.heaterLocationString,
    this.maxPower,
    this.rampRate,
    this.steadyStateError,
    this.heatingElementMaterial,
    this.powerCycles,
    this.maxPowerCycles,
    // MassFlowController fields
    this.maxFlowRate,
    this.minFlowRate,
    this.accuracy,
    this.gasType,
    // NitrogenGenerator fields
    this.minPurity,
    this.currentPurity,
  });

  // From JSON
  factory ComponentDTO.fromJson(Map<String, dynamic> json) =>
      _$ComponentDTOFromJson(json);

  // To JSON
  Map<String, dynamic> toJson() => _$ComponentDTOToJson(this);

  // To Domain
  Component toDomain() {
    final type = _parseType(componentTypeString);
    final state = _parseState(componentStateString);
    final params = parameters.map((p) => p.toDomain()).toList();

    switch (type) {
      case ComponentType.chamber:
        return Chamber(
          id: id,
          name: name,
          state: state,
          parameters: params,
          lastMaintenanceDate: lastMaintenanceDate,
          isOperational: isOperational,
          volume: volume ?? 0.0,
          material: material ?? 'unknown',
          maxPressure: maxPressure ?? 0.0,
          maxTemperature: maxTemperature ?? 0.0,
        );

      case ComponentType.valve:
        return Valve(
          id: id,
          name: name,
          state: state,
          parameters: params,
          lastMaintenanceDate: lastMaintenanceDate,
          isOperational: isOperational,
          location: _parseValveLocation(valveLocationString ?? 'precursor1'),
          isNormallyOpen: isNormallyOpen ?? false,
          cycleCount: cycleCount ?? 0,
          maxCycles: maxCycles ?? 100000,
        );

      case ComponentType.vacuumPump:
        return VacuumPump(
          id: id,
          name: name,
          state: state,
          parameters: params,
          lastMaintenanceDate: lastMaintenanceDate,
          isOperational: isOperational,
          baselinePressure: baselinePressure ?? 0.0,
          maxInletPressure: maxInletPressure ?? 0.0,
          operatingHours: operatingHours ?? 0,
          maxOperatingHours: maxOperatingHours ?? 10000,
          targetPressure: 1e-3,
          pressureTolerance: 1e-4,
        );

      case ComponentType.heater:
        return Heater(
          id: id,
          name: name,
          state: state,
          parameters: params,
          lastMaintenanceDate: lastMaintenanceDate,
          isOperational: isOperational,
          location: _parseHeaterLocation(heaterLocationString ?? 'precursor1'),
          maxTemperature: maxTemperature ?? 0.0,
          maxPower: maxPower ?? 0.0,
          rampRate: rampRate ?? 0.0,
          steadyStateError: steadyStateError ?? 0.0,
          heatingElementMaterial: heatingElementMaterial ?? 'unknown',
          powerCycles: powerCycles ?? 0,
          maxPowerCycles: maxPowerCycles ?? 100000,
        );

      case ComponentType.massFlowController:
        return MassFlowController(
          id: id,
          name: name,
          state: state,
          parameters: params,
          lastMaintenanceDate: lastMaintenanceDate,
          isOperational: isOperational,
          maxFlowRate: maxFlowRate ?? 0.0,
          minFlowRate: minFlowRate ?? 0.0,
          accuracy: accuracy ?? 1.0,
          gasType: gasType ?? 'N2',
        );

      case ComponentType.nitrogenGenerator:
        return NitrogenGenerator(
          id: id,
          name: name,
          state: state,
          parameters: params,
          lastMaintenanceDate: lastMaintenanceDate,
          isOperational: isOperational,
          maxFlowRate: maxFlowRate ?? 0.0,
          minPurity: minPurity ?? 99.999,
          currentPurity: currentPurity ?? 99.999,
        );

      case ComponentType.pump:
        throw UnimplementedError('Pump type is deprecated, use VacuumPump instead');
    }
  }

  // From Domain
  factory ComponentDTO.fromDomain(Component component) {
    final baseDTO = ComponentDTO(
      id: component.id,
      name: component.name,
      componentTypeString: _typeToString(component.type),
      componentStateString: _stateToString(component.state),
      parameters: component.parameters
          .map((param) => ParameterDTO.fromDomain(param))
          .toList(),
      lastMaintenanceDate: component.lastMaintenanceDate,
      isOperational: component.isOperational,
    );

    switch (component.type) {
      case ComponentType.chamber:
        final chamber = component as Chamber;
        return baseDTO.copyWith(
          volume: chamber.volume,
          material: chamber.material,
          maxPressure: chamber.maxPressure,
          maxTemperature: chamber.maxTemperature,
        );

      case ComponentType.valve:
        final valve = component as Valve;
        return baseDTO.copyWith(
          valveLocationString: _valveLocationToString(valve.location),
          isNormallyOpen: valve.isNormallyOpen,
          cycleCount: valve.cycleCount,
          maxCycles: valve.maxCycles,
        );

      case ComponentType.vacuumPump:
        final pump = component as VacuumPump;
        return baseDTO.copyWith(
          baselinePressure: pump.baselinePressure,
          maxInletPressure: pump.maxInletPressure,
          operatingHours: pump.operatingHours,
          maxOperatingHours: pump.maxOperatingHours,
        );

      case ComponentType.heater:
        final heater = component as Heater;
        return baseDTO.copyWith(
          heaterLocationString: _heaterLocationToString(heater.location),
          maxTemperature: heater.maxTemperature,
          maxPower: heater.maxPower,
          rampRate: heater.rampRate,
          steadyStateError: heater.steadyStateError,
          heatingElementMaterial: heater.heatingElementMaterial,
          powerCycles: heater.powerCycles,
          maxPowerCycles: heater.maxPowerCycles,
        );

      case ComponentType.massFlowController:
        final mfc = component as MassFlowController;
        return baseDTO.copyWith(
          maxFlowRate: mfc.maxFlowRate,
          minFlowRate: mfc.minFlowRate,
          accuracy: mfc.accuracy,
          gasType: mfc.gasType,
        );

      case ComponentType.nitrogenGenerator:
        final n2gen = component as NitrogenGenerator;
        return baseDTO.copyWith(
          maxFlowRate: n2gen.maxFlowRate,
          minPurity: n2gen.minPurity,
          currentPurity: n2gen.currentPurity,
        );

      case ComponentType.pump:
        throw UnimplementedError('Pump type is deprecated, use VacuumPump instead');
    }
  }

  ComponentDTO copyWith({
    String? id,
    String? name,
    String? componentTypeString,
    String? componentStateString,
    List<ParameterDTO>? parameters,
    DateTime? lastMaintenanceDate,
    bool? isOperational,
    double? volume,
    String? material,
    double? maxPressure,
    double? maxTemperature,
    String? valveLocationString,
    bool? isNormallyOpen,
    int? cycleCount,
    int? maxCycles,
    double? baselinePressure,
    double? maxInletPressure,
    int? operatingHours,
    int? maxOperatingHours,
    String? heaterLocationString,
    double? maxPower,
    double? rampRate,
    double? steadyStateError,
    String? heatingElementMaterial,
    int? powerCycles,
    int? maxPowerCycles,
    double? maxFlowRate,
    double? minFlowRate,
    double? accuracy,
    String? gasType,
    double? minPurity,
    double? currentPurity,
  }) {
    return ComponentDTO(
      id: id ?? this.id,
      name: name ?? this.name,
      componentTypeString: componentTypeString ?? this.componentTypeString,
      componentStateString: componentStateString ?? this.componentStateString,
      parameters: parameters ?? this.parameters,
      lastMaintenanceDate: lastMaintenanceDate ?? this.lastMaintenanceDate,
      isOperational: isOperational ?? this.isOperational,
      volume: volume ?? this.volume,
      material: material ?? this.material,
      maxPressure: maxPressure ?? this.maxPressure,
      maxTemperature: maxTemperature ?? this.maxTemperature,
      valveLocationString: valveLocationString ?? this.valveLocationString,
      isNormallyOpen: isNormallyOpen ?? this.isNormallyOpen,
      cycleCount: cycleCount ?? this.cycleCount,
      maxCycles: maxCycles ?? this.maxCycles,
      baselinePressure: baselinePressure ?? this.baselinePressure,
      maxInletPressure: maxInletPressure ?? this.maxInletPressure,
      operatingHours: operatingHours ?? this.operatingHours,
      maxOperatingHours: maxOperatingHours ?? this.maxOperatingHours,
      heaterLocationString: heaterLocationString ?? this.heaterLocationString,
      maxPower: maxPower ?? this.maxPower,
      rampRate: rampRate ?? this.rampRate,
      steadyStateError: steadyStateError ?? this.steadyStateError,
      heatingElementMaterial: heatingElementMaterial ?? this.heatingElementMaterial,
      powerCycles: powerCycles ?? this.powerCycles,
      maxPowerCycles: maxPowerCycles ?? this.maxPowerCycles,
      maxFlowRate: maxFlowRate ?? this.maxFlowRate,
      minFlowRate: minFlowRate ?? this.minFlowRate,
      accuracy: accuracy ?? this.accuracy,
      gasType: gasType ?? this.gasType,
      minPurity: minPurity ?? this.minPurity,
      currentPurity: currentPurity ?? this.currentPurity,
    );
  }

  // Helper methods
  static ComponentType _parseType(String type) {
    switch (type.toLowerCase()) {
      case 'chamber':
        return ComponentType.chamber;
      case 'valve':
        return ComponentType.valve;
      case 'vacuumpump':
        return ComponentType.vacuumPump;
      case 'heater':
        return ComponentType.heater;
      case 'massflowcontroller':
        return ComponentType.massFlowController;
      case 'nitrogengenerator':
        return ComponentType.nitrogenGenerator;
      case 'pump':
        return ComponentType.pump;
      default:
        throw ArgumentError('Invalid component type: $type');
    }
  }

  static String _typeToString(ComponentType type) {
    switch (type) {
      case ComponentType.chamber:
        return 'chamber';
      case ComponentType.valve:
        return 'valve';
      case ComponentType.vacuumPump:
        return 'vacuumpump';
      case ComponentType.heater:
        return 'heater';
      case ComponentType.massFlowController:
        return 'massflowcontroller';
      case ComponentType.nitrogenGenerator:
        return 'nitrogengenerator';
      case ComponentType.pump:
        return 'pump';
    }
  }

  static ComponentState _parseState(String state) {
    switch (state.toLowerCase()) {
      case 'off':
        return ComponentState.off;
      case 'idle':
        return ComponentState.idle;
      case 'active':
        return ComponentState.active;
      case 'error':
        return ComponentState.error;
      case 'maintenance':
        return ComponentState.maintenance;
      default:
        return ComponentState.error;
    }
  }

  static String _stateToString(ComponentState state) {
    switch (state) {
      case ComponentState.off:
        return 'off';
      case ComponentState.idle:
        return 'idle';
      case ComponentState.active:
        return 'active';
      case ComponentState.error:
        return 'error';
      case ComponentState.maintenance:
        return 'maintenance';
    }
  }

  static ValveLocation _parseValveLocation(String location) {
    switch (location.toLowerCase()) {
      case 'precursor1':
        return ValveLocation.precursor1;
      case 'precursor2':
        return ValveLocation.precursor2;
      case 'purge':
        return ValveLocation.purge;
      case 'vacuum':
        return ValveLocation.vacuum;
      default:
        return ValveLocation.purge;
    }
  }

  static String _valveLocationToString(ValveLocation location) {
    switch (location) {
      case ValveLocation.precursor1:
        return 'precursor1';
      case ValveLocation.precursor2:
        return 'precursor2';
      case ValveLocation.purge:
        return 'purge';
      case ValveLocation.vacuum:
        return 'vacuum';
    }
  }

  static HeaterLocation _parseHeaterLocation(String location) {
    switch (location.toLowerCase()) {
      case 'precursor1':
        return HeaterLocation.precursor1;
      case 'precursor2':
        return HeaterLocation.precursor2;
      case 'backline':
        return HeaterLocation.backline;
      case 'frontline':
        return HeaterLocation.frontline;
      default:
        return HeaterLocation.backline;
    }
  }

  static String _heaterLocationToString(HeaterLocation location) {
    switch (location) {
      case HeaterLocation.precursor1:
        return 'precursor1';
      case HeaterLocation.precursor2:
        return 'precursor2';
      case HeaterLocation.backline:
        return 'backline';
      case HeaterLocation.frontline:
        return 'frontline';
    }
  }
}