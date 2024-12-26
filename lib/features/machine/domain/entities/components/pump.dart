import '../component.dart';
import '../parameter.dart';

class Pump extends Component {
  final PumpType pumpType;
  final double maxFlowRate; // in sccm (standard cubic centimeters per minute)
  final double baselinePressure; // in Torr
  final double maxInletPressure; // in Torr
  final double maxOutletPressure; // in Torr
  final int operatingHours;
  final int maxOperatingHours;

  const Pump({
    required super.id,
    required super.name,
    required super.state,
    required super.parameters,
    required super.lastMaintenanceDate,
    required super.isOperational,
    required this.pumpType,
    required this.maxFlowRate,
    required this.baselinePressure,
    required this.maxInletPressure,
    required this.maxOutletPressure,
    required this.operatingHours,
    required this.maxOperatingHours,
  }) : super(type: ComponentType.pump);

  @override
  List<Object?> get props => [
    ...super.props,
    pumpType,
    maxFlowRate,
    baselinePressure,
    maxInletPressure,
    maxOutletPressure,
    operatingHours,
    maxOperatingHours,
  ];

  Pump copyWith({
    String? id,
    String? name,
    ComponentState? state,
    List<Parameter>? parameters,
    DateTime? lastMaintenanceDate,
    bool? isOperational,
    PumpType? pumpType,
    double? maxFlowRate,
    double? baselinePressure,
    double? maxInletPressure,
    double? maxOutletPressure,
    int? operatingHours,
    int? maxOperatingHours,
  }) {
    return Pump(
      id: id ?? this.id,
      name: name ?? this.name,
      state: state ?? this.state,
      parameters: parameters ?? this.parameters,
      lastMaintenanceDate: lastMaintenanceDate ?? this.lastMaintenanceDate,
      isOperational: isOperational ?? this.isOperational,
      pumpType: pumpType ?? this.pumpType,
      maxFlowRate: maxFlowRate ?? this.maxFlowRate,
      baselinePressure: baselinePressure ?? this.baselinePressure,
      maxInletPressure: maxInletPressure ?? this.maxInletPressure,
      maxOutletPressure: maxOutletPressure ?? this.maxOutletPressure,
      operatingHours: operatingHours ?? this.operatingHours,
      maxOperatingHours: maxOperatingHours ?? this.maxOperatingHours,
    );
  }

  // Pump-specific methods
  bool get needsHourBasedMaintenance =>
    operatingHours >= maxOperatingHours * 0.9;

  bool get isPressureSafe {
    final inletPressure = getParameter('inlet_pressure')?.value ?? 0;
    final outletPressure = getParameter('outlet_pressure')?.value ?? 0;
    return inletPressure <= maxInletPressure &&
           outletPressure <= maxOutletPressure;
  }

  bool get isFlowRateSafe {
    final flowRate = getParameter('flow_rate')?.value ?? 0;
    return flowRate <= maxFlowRate;
  }

  bool get isPerformingWell {
    final currentBaseline = getParameter('baseline_pressure')?.value ?? double.infinity;
    return currentBaseline <= baselinePressure * 1.2; // 20% tolerance
  }

  @override
  bool get isSafe =>
    isPressureSafe &&
    isFlowRateSafe &&
    !needsHourBasedMaintenance &&
    isPerformingWell;

  bool get isRunning => state == ComponentState.active;

  double get efficiency {
    final currentBaseline = getParameter('baseline_pressure')?.value;
    if (currentBaseline == null) return 1.0;

    // Calculate efficiency based on baseline pressure degradation
    // 1.0 = perfect performance, 0.0 = complete failure
    final degradation = (currentBaseline - baselinePressure) / baselinePressure;
    return (1.0 - degradation).clamp(0.0, 1.0);
  }
}

enum PumpType {
  rotaryVane,    // Common backing pump
  turbomolecular,// High vacuum
  scroll,        // Oil-free backing pump
  diaphragm,     // Low flow, oil-free
  ionPump,       // Ultra-high vacuum
  cryoPump,      // High vacuum, gas capture
  rootsBlower,   // High throughput
  diffusion,     // High vacuum, simple operation
  dragPump,      // Compact turbo variant
  sublimation    // Titanium sublimation pump
}