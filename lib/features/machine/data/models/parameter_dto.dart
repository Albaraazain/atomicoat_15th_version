import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/parameter.dart';

part 'parameter_dto.g.dart';

@JsonSerializable()
class ParameterDTO {
  final String id;
  final String name;
  @JsonKey(name: 'type', defaultValue: 'flow')
  final String parameterTypeString;
  @JsonKey(name: 'value', defaultValue: 0.0)
  final double value;
  @JsonKey(name: 'minValue', defaultValue: 0.0)
  final double minValue;
  @JsonKey(name: 'maxValue', defaultValue: 100.0)
  final double maxValue;
  @JsonKey(name: 'unit', defaultValue: '')
  final String unit;
  @JsonKey(name: 'lastUpdated')
  final DateTime lastUpdated;

  const ParameterDTO({
    required this.id,
    required this.name,
    required this.parameterTypeString,
    this.value = 0.0,
    this.minValue = 0.0,
    this.maxValue = 100.0,
    this.unit = '',
    required this.lastUpdated,
  });

  // From JSON
  factory ParameterDTO.fromJson(Map<String, dynamic> json) {
    // Handle the case where type might be null
    if (json['type'] == null) {
      json['type'] = 'flow'; // Set default value
    }
    return _$ParameterDTOFromJson(json);
  }

  // To JSON
  Map<String, dynamic> toJson() => _$ParameterDTOToJson(this);

  // To Domain
  Parameter toDomain() {
    return Parameter(
      id: id,
      name: name,
      type: _parseType(parameterTypeString),
      value: value,
      minValue: minValue,
      maxValue: maxValue,
      unit: unit,
      lastUpdated: lastUpdated,
    );
  }

  // From Domain
  factory ParameterDTO.fromDomain(Parameter parameter) {
    return ParameterDTO(
      id: parameter.id,
      name: parameter.name,
      parameterTypeString: _typeToString(parameter.type),
      value: parameter.value,
      minValue: parameter.minValue,
      maxValue: parameter.maxValue,
      unit: parameter.unit,
      lastUpdated: parameter.lastUpdated,
    );
  }

  // Helper methods
  static ParameterType _parseType(String type) {
    switch (type.toLowerCase()) {
      case 'temperature':
        return ParameterType.temperature;
      case 'pressure':
        return ParameterType.pressure;
      case 'flow':
        return ParameterType.flow;
      case 'power':
        return ParameterType.power;
      case 'voltage':
        return ParameterType.voltage;
      case 'current':
        return ParameterType.current;
      case 'signalquality':
        return ParameterType.signalQuality;
      case 'purity':
        return ParameterType.purity;
      case 'humidity':
        return ParameterType.humidity;
      case 'concentration':
        return ParameterType.concentration;
      default:
        throw ArgumentError('Invalid parameter type: $type');
    }
  }

  static String _typeToString(ParameterType type) {
    switch (type) {
      case ParameterType.temperature:
        return 'temperature';
      case ParameterType.pressure:
        return 'pressure';
      case ParameterType.flow:
        return 'flow';
      case ParameterType.power:
        return 'power';
      case ParameterType.voltage:
        return 'voltage';
      case ParameterType.current:
        return 'current';
      case ParameterType.signalQuality:
        return 'signalquality';
      case ParameterType.purity:
        return 'purity';
      case ParameterType.humidity:
        return 'humidity';
      case ParameterType.concentration:
        return 'concentration';
    }
  }
}