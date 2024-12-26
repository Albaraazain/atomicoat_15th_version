import '../component.dart';
import '../parameter.dart';

class NitrogenGenerator extends Component {
  final double maxFlowRate;
  final double minPurity;
  final double currentPurity;

  const NitrogenGenerator({
    required super.id,
    required super.name,
    required super.state,
    required super.parameters,
    required super.lastMaintenanceDate,
    required super.isOperational,
    required this.maxFlowRate,
    required this.minPurity,
    required this.currentPurity,
  }) : super(type: ComponentType.nitrogenGenerator);

  @override
  bool get isSafe {
    return isFlowRateSafe && isPuritySufficient && isOperational;
  }

  bool get isFlowRateSafe {
    final flowRate = getParameter('flow_rate')?.value ?? 0;
    return flowRate >= 0 && flowRate <= maxFlowRate;
  }

  bool get isPuritySufficient {
    return currentPurity >= minPurity;
  }

  double get purityMargin {
    return double.parse((currentPurity - minPurity).toStringAsFixed(1));
  }

  bool get isGenerating => state == ComponentState.active;

  bool get needsPurityBasedMaintenance => purityMargin < 0.01;

  bool get needsTimeBasedMaintenance {
    final timeSinceLastMaintenance = DateTime.now().difference(lastMaintenanceDate).inDays;
    return timeSinceLastMaintenance >= 90; // 3 months maintenance interval
  }

  @override
  bool get needsMaintenance => needsTimeBasedMaintenance || needsPurityBasedMaintenance;

  @override
  NitrogenGenerator copyWith({
    String? id,
    String? name,
    ComponentState? state,
    List<Parameter>? parameters,
    DateTime? lastMaintenanceDate,
    bool? isOperational,
    double? maxFlowRate,
    double? minPurity,
    double? currentPurity,
  }) {
    return NitrogenGenerator(
      id: id ?? this.id,
      name: name ?? this.name,
      state: state ?? this.state,
      parameters: parameters ?? this.parameters,
      lastMaintenanceDate: lastMaintenanceDate ?? this.lastMaintenanceDate,
      isOperational: isOperational ?? this.isOperational,
      maxFlowRate: maxFlowRate ?? this.maxFlowRate,
      minPurity: minPurity ?? this.minPurity,
      currentPurity: currentPurity ?? this.currentPurity,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    maxFlowRate,
    minPurity,
    currentPurity,
  ];
}