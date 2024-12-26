// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'machine_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MachineDTO _$MachineDTOFromJson(Map<String, dynamic> json) => MachineDTO(
      id: json['id'] as String,
      serialNumber: json['serialNumber'] as String,
      name: json['name'] as String,
      machineStateString: json['state'] as String? ?? 'standby',
      components: (json['components'] as List<dynamic>?)
              ?.map((e) => ComponentDTO.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      lastMaintenanceDate:
          DateTime.parse(json['lastMaintenanceDate'] as String),
      isOperational: json['isOperational'] as bool? ?? true,
    );

Map<String, dynamic> _$MachineDTOToJson(MachineDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'serialNumber': instance.serialNumber,
      'name': instance.name,
      'state': instance.machineStateString,
      'components': instance.components.map((e) => e.toJson()).toList(),
      'lastMaintenanceDate': instance.lastMaintenanceDate.toIso8601String(),
      'isOperational': instance.isOperational,
    };
