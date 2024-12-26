import 'package:equatable/equatable.dart';

enum ParameterType {
  pressure,
  temperature,
  flow,
  power,
  current,
  voltage,
  signalQuality,
  purity,
  humidity,
  concentration,
}

class Parameter extends Equatable {
  final String id;
  final String name;
  final ParameterType type;
  final double value;
  final double minValue;
  final double maxValue;
  final String unit;
  final DateTime lastUpdated;

  const Parameter({
    required this.id,
    required this.name,
    required this.type,
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.unit,
    required this.lastUpdated,
  });

  bool get isInRange => value >= minValue && value <= maxValue;

  @override
  List<Object?> get props => [
    id,
    name,
    type,
    value,
    minValue,
    maxValue,
    unit,
    lastUpdated,
  ];

  Parameter copyWith({
    String? id,
    String? name,
    ParameterType? type,
    double? value,
    double? minValue,
    double? maxValue,
    String? unit,
    DateTime? lastUpdated,
  }) {
    return Parameter(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      value: value ?? this.value,
      minValue: minValue ?? this.minValue,
      maxValue: maxValue ?? this.maxValue,
      unit: unit ?? this.unit,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}