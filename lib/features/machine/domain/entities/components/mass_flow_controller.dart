import '../component.dart';
import '../parameter.dart';

class MassFlowController extends Component {
  final double maxFlowRate;
  final double minFlowRate;
  final double accuracy;
  final String gasType;

  const MassFlowController({
    required super.id,
    required super.name,
    required super.state,
    required super.parameters,
    required super.lastMaintenanceDate,
    required super.isOperational,
    required this.maxFlowRate,
    required this.minFlowRate,
    required this.accuracy,
    required this.gasType,
  }) : super(type: ComponentType.massFlowController);

  @override
  bool get isSafe {
    final flowRate = getParameter('flow_rate')?.value ?? 0;
    return flowRate >= minFlowRate && flowRate <= maxFlowRate && isOperational;
  }

  bool get isAtSetpoint {
    final flowRate = getParameter('flow_rate')?.value ?? 0;
    final setpoint = getParameter('setpoint')?.value ?? 0;
    return (flowRate - setpoint).abs() <= accuracy;
  }

  double get flowDeviation {
    final flowRate = getParameter('flow_rate')?.value ?? 0;
    final setpoint = getParameter('setpoint')?.value ?? 0;
    return (setpoint - flowRate).abs();
  }

  bool get isFlowStable => flowDeviation <= accuracy;

  bool get isFlowing => state == ComponentState.active;

  @override
  MassFlowController copyWith({
    String? id,
    String? name,
    ComponentState? state,
    List<Parameter>? parameters,
    DateTime? lastMaintenanceDate,
    bool? isOperational,
    double? maxFlowRate,
    double? minFlowRate,
    double? accuracy,
    String? gasType,
  }) {
    return MassFlowController(
      id: id ?? this.id,
      name: name ?? this.name,
      state: state ?? this.state,
      parameters: parameters ?? this.parameters,
      lastMaintenanceDate: lastMaintenanceDate ?? this.lastMaintenanceDate,
      isOperational: isOperational ?? this.isOperational,
      maxFlowRate: maxFlowRate ?? this.maxFlowRate,
      minFlowRate: minFlowRate ?? this.minFlowRate,
      accuracy: accuracy ?? this.accuracy,
      gasType: gasType ?? this.gasType,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    maxFlowRate,
    minFlowRate,
    accuracy,
    gasType,
  ];
}