import '../component.dart';
import '../parameter.dart';

enum HeaterLocation {
  precursor1,
  precursor2,
  backline,
  frontline,
}

class Heater extends Component {
  final HeaterLocation location;
  final double maxTemperature;
  final double maxPower;
  final double rampRate;
  final double steadyStateError;
  final String heatingElementMaterial;
  final int powerCycles;
  final int maxPowerCycles;

  const Heater({
    required super.id,
    required super.name,
    required super.state,
    required super.parameters,
    required super.lastMaintenanceDate,
    required super.isOperational,
    required this.location,
    required this.maxTemperature,
    required this.maxPower,
    required this.rampRate,
    required this.steadyStateError,
    required this.heatingElementMaterial,
    required this.powerCycles,
    required this.maxPowerCycles,
  }) : super(type: ComponentType.heater);

  @override
  bool get isSafe {
    final temperature = getParameter('temperature')?.value ?? 0;
    final power = getParameter('power')?.value ?? 0;
    return temperature <= maxTemperature &&
           power <= maxPower &&
           powerCycles <= maxPowerCycles &&
           isOperational;
  }

  bool get isAtSetpoint {
    final temperature = getParameter('temperature')?.value ?? 0;
    final setpoint = getParameter('setpoint')?.value ?? 0;
    return (temperature - setpoint).abs() <= steadyStateError;
  }

  double get temperatureDeviation {
    final temperature = getParameter('temperature')?.value ?? 0;
    final setpoint = getParameter('setpoint')?.value ?? 0;
    return (setpoint - temperature).abs();
  }

  bool get isTemperatureStable => temperatureDeviation <= steadyStateError;

  bool get isHeating => state == ComponentState.active;

  @override
  bool get needsMaintenance {
    final powerEfficiency = getPowerEfficiency();
    final timeSinceLastMaintenance = DateTime.now().difference(lastMaintenanceDate).inDays;
    return powerCycles >= (maxPowerCycles * 0.9) || // 90% of max cycles
           powerEfficiency < 0.8 || // 80% power efficiency threshold
           timeSinceLastMaintenance > 180; // 6 months maintenance interval
  }

  double getPowerEfficiency() {
    final temperature = getParameter('temperature')?.value ?? 0;
    final power = getParameter('power')?.value ?? 0;
    final setpoint = getParameter('setpoint')?.value ?? 0;

    if (setpoint <= 0 || power <= 0) return 1.0;

    // Calculate power efficiency based on power needed to maintain temperature
    final expectedPower = (setpoint / maxTemperature) * maxPower;
    final actualPower = power;

    return (expectedPower / actualPower).clamp(0.0, 1.0);
  }

  @override
  Heater copyWith({
    String? id,
    String? name,
    ComponentState? state,
    List<Parameter>? parameters,
    DateTime? lastMaintenanceDate,
    bool? isOperational,
    HeaterLocation? location,
    double? maxTemperature,
    double? maxPower,
    double? rampRate,
    double? steadyStateError,
    String? heatingElementMaterial,
    int? powerCycles,
    int? maxPowerCycles,
  }) {
    return Heater(
      id: id ?? this.id,
      name: name ?? this.name,
      state: state ?? this.state,
      parameters: parameters ?? this.parameters,
      lastMaintenanceDate: lastMaintenanceDate ?? this.lastMaintenanceDate,
      isOperational: isOperational ?? this.isOperational,
      location: location ?? this.location,
      maxTemperature: maxTemperature ?? this.maxTemperature,
      maxPower: maxPower ?? this.maxPower,
      rampRate: rampRate ?? this.rampRate,
      steadyStateError: steadyStateError ?? this.steadyStateError,
      heatingElementMaterial: heatingElementMaterial ?? this.heatingElementMaterial,
      powerCycles: powerCycles ?? this.powerCycles,
      maxPowerCycles: maxPowerCycles ?? this.maxPowerCycles,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    location,
    maxTemperature,
    maxPower,
    rampRate,
    steadyStateError,
    heatingElementMaterial,
    powerCycles,
    maxPowerCycles,
  ];
}