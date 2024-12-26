import '../component.dart';
import '../parameter.dart';

class Chamber extends Component {
  final double volume; // in cubic centimeters
  final String material;
  final double maxPressure; // in Torr
  final double maxTemperature; // in Celsius

  const Chamber({
    required super.id,
    required super.name,
    required super.state,
    required super.parameters,
    required super.lastMaintenanceDate,
    required super.isOperational,
    required this.volume,
    required this.material,
    required this.maxPressure,
    required this.maxTemperature,
  }) : super(type: ComponentType.chamber);

  @override
  List<Object?> get props => [
    ...super.props,
    volume,
    material,
    maxPressure,
    maxTemperature,
  ];

  Chamber copyWith({
    String? id,
    String? name,
    ComponentState? state,
    List<Parameter>? parameters,
    DateTime? lastMaintenanceDate,
    bool? isOperational,
    double? volume,
    String? material,
    double? maxPressure,
    double? maxTemperature,
  }) {
    return Chamber(
      id: id ?? this.id,
      name: name ?? this.name,
      state: state ?? this.state,
      parameters: parameters ?? this.parameters,
      lastMaintenanceDate: lastMaintenanceDate ?? this.lastMaintenanceDate,
      isOperational: isOperational ?? this.isOperational,
      volume: volume ?? this.volume,
      material: material ?? this.material,
      maxPressure: maxPressure ?? this.maxPressure,
      maxTemperature: maxTemperature ?? this.maxTemperature,
    );
  }

  // Chamber-specific methods
  bool get isPressurizationSafe {
    final pressure = getParameter('pressure')?.value ?? 0;
    return pressure <= maxPressure;
  }

  bool get isTemperatureSafe {
    final temperature = getParameter('temperature')?.value ?? 0;
    return temperature <= maxTemperature;
  }

  @override
  bool get isSafe => isPressurizationSafe && isTemperatureSafe;
}