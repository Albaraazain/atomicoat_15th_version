// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'component_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComponentDTO _$ComponentDTOFromJson(Map<String, dynamic> json) => ComponentDTO(
      id: json['id'] as String,
      name: json['name'] as String,
      componentTypeString: json['type'] as String,
      componentStateString: json['state'] as String,
      parameters: (json['parameters'] as List<dynamic>)
          .map((e) => ParameterDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastMaintenanceDate:
          DateTime.parse(json['last_maintenance_date'] as String),
      isOperational: json['is_operational'] as bool,
      volume: (json['volume'] as num?)?.toDouble() ?? 0.0,
      material: json['material'] as String? ?? '',
      maxPressure: (json['max_pressure'] as num?)?.toDouble() ?? 0.0,
      maxTemperature: (json['max_temperature'] as num?)?.toDouble() ?? 0.0,
      valveLocationString: json['valve_location_string'] as String? ?? '',
      isNormallyOpen: json['is_normally_open'] as bool? ?? false,
      cycleCount: (json['cycle_count'] as num?)?.toInt() ?? 0,
      maxCycles: (json['max_cycles'] as num?)?.toInt() ?? 0,
      baselinePressure: (json['baseline_pressure'] as num?)?.toDouble() ?? 0.0,
      maxInletPressure: (json['max_inlet_pressure'] as num?)?.toDouble() ?? 0.0,
      operatingHours: (json['operating_hours'] as num?)?.toInt() ?? 0,
      maxOperatingHours: (json['max_operating_hours'] as num?)?.toInt() ?? 0,
      heaterLocationString: json['heater_location_string'] as String? ?? '',
      maxPower: (json['max_power'] as num?)?.toDouble() ?? 0.0,
      rampRate: (json['ramp_rate'] as num?)?.toDouble() ?? 0.0,
      steadyStateError: (json['steady_state_error'] as num?)?.toDouble() ?? 0.0,
      heatingElementMaterial: json['heating_element_material'] as String? ?? '',
      powerCycles: (json['power_cycles'] as num?)?.toInt() ?? 0,
      maxPowerCycles: (json['max_power_cycles'] as num?)?.toInt() ?? 0,
      maxFlowRate: (json['max_flow_rate'] as num?)?.toDouble() ?? 0.0,
      minFlowRate: (json['min_flow_rate'] as num?)?.toDouble() ?? 0.0,
      accuracy: (json['accuracy'] as num?)?.toDouble() ?? 0.0,
      gasType: json['gas_type'] as String? ?? '',
      minPurity: (json['min_purity'] as num?)?.toDouble() ?? 0.0,
      currentPurity: (json['current_purity'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$ComponentDTOToJson(ComponentDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.componentTypeString,
      'state': instance.componentStateString,
      'parameters': instance.parameters.map((e) => e.toJson()).toList(),
      'last_maintenance_date': instance.lastMaintenanceDate.toIso8601String(),
      'is_operational': instance.isOperational,
      'volume': instance.volume,
      'material': instance.material,
      'max_pressure': instance.maxPressure,
      'max_temperature': instance.maxTemperature,
      'valve_location_string': instance.valveLocationString,
      'is_normally_open': instance.isNormallyOpen,
      'cycle_count': instance.cycleCount,
      'max_cycles': instance.maxCycles,
      'baseline_pressure': instance.baselinePressure,
      'max_inlet_pressure': instance.maxInletPressure,
      'operating_hours': instance.operatingHours,
      'max_operating_hours': instance.maxOperatingHours,
      'heater_location_string': instance.heaterLocationString,
      'max_power': instance.maxPower,
      'ramp_rate': instance.rampRate,
      'steady_state_error': instance.steadyStateError,
      'heating_element_material': instance.heatingElementMaterial,
      'power_cycles': instance.powerCycles,
      'max_power_cycles': instance.maxPowerCycles,
      'max_flow_rate': instance.maxFlowRate,
      'min_flow_rate': instance.minFlowRate,
      'accuracy': instance.accuracy,
      'gas_type': instance.gasType,
      'min_purity': instance.minPurity,
      'current_purity': instance.currentPurity,
    };
