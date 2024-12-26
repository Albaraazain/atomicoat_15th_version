import 'dart:math' as math;
import '../component.dart';
import '../parameter.dart';

class VacuumPump extends Component {
  final double baselinePressure;
  final double maxInletPressure;
  final int operatingHours;
  final int maxOperatingHours;
  final double targetPressure;
  final double pressureTolerance;

  const VacuumPump({
    required super.id,
    required super.name,
    required super.state,
    required super.parameters,
    required super.lastMaintenanceDate,
    required super.isOperational,
    required this.baselinePressure,
    required this.maxInletPressure,
    required this.operatingHours,
    required this.maxOperatingHours,
    required this.targetPressure,
    required this.pressureTolerance,
  }) : super(type: ComponentType.vacuumPump);

  @override
  bool get isSafe {
    final inletPressure = getParameter('inlet_pressure')?.value ?? 0;
    return inletPressure <= maxInletPressure &&
           isOperational &&
           !needsHourBasedMaintenance &&
           isPerformingWell;
  }

  bool get isAtTargetPressure {
    final chamberPressure = getParameter('chamber_pressure')?.value ?? 0;
    return (chamberPressure - targetPressure).abs() <= pressureTolerance;
  }

  bool get isPerformingWell {
    final baselinePressureValue = getParameter('baseline_pressure')?.value ?? 0;
    return baselinePressureValue <= baselinePressure * 1.5;
  }

  bool get needsHourBasedMaintenance => operatingHours >= maxOperatingHours * 0.9;

  double get efficiency {
    final baselinePressureValue = getParameter('baseline_pressure')?.value ?? 0;
    if (baselinePressureValue <= baselinePressure) return 1.0;

    // Calculate efficiency as a ratio of expected vs actual baseline pressure
    // A 50% increase in baseline pressure means 50% efficiency
    final degradation = (baselinePressureValue - baselinePressure) / baselinePressure;
    final result = (1.0 - degradation).clamp(0.0, 1.0);
    return double.parse(result.toStringAsFixed(1));
  }

  bool get isPumping => state == ComponentState.active;

  Duration estimateTimeToTarget({
    required double currentPressure,
    required double pumpingSpeed,
    required double chamberVolume,
  }) {
    if (currentPressure <= targetPressure) return Duration.zero;

    // Using simplified vacuum pump-down equation
    final pumpDownTime = chamberVolume / pumpingSpeed *
        math.log(currentPressure / targetPressure) * 2.303;

    return Duration(seconds: pumpDownTime.ceil());
  }

  @override
  VacuumPump copyWith({
    String? id,
    String? name,
    ComponentState? state,
    List<Parameter>? parameters,
    DateTime? lastMaintenanceDate,
    bool? isOperational,
    double? baselinePressure,
    double? maxInletPressure,
    int? operatingHours,
    int? maxOperatingHours,
    double? targetPressure,
    double? pressureTolerance,
  }) {
    return VacuumPump(
      id: id ?? this.id,
      name: name ?? this.name,
      state: state ?? this.state,
      parameters: parameters ?? this.parameters,
      lastMaintenanceDate: lastMaintenanceDate ?? this.lastMaintenanceDate,
      isOperational: isOperational ?? this.isOperational,
      baselinePressure: baselinePressure ?? this.baselinePressure,
      maxInletPressure: maxInletPressure ?? this.maxInletPressure,
      operatingHours: operatingHours ?? this.operatingHours,
      maxOperatingHours: maxOperatingHours ?? this.maxOperatingHours,
      targetPressure: targetPressure ?? this.targetPressure,
      pressureTolerance: pressureTolerance ?? this.pressureTolerance,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    baselinePressure,
    maxInletPressure,
    operatingHours,
    maxOperatingHours,
    targetPressure,
    pressureTolerance,
  ];
}