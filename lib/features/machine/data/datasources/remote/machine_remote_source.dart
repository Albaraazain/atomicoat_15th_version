import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/utils/app_logger.dart';
import '../../models/machine_dto.dart';
import '../../models/component_dto.dart';
import '../../models/parameter_dto.dart';
import '../../../domain/entities/component.dart';
import '../../../domain/entities/machine.dart';

abstract class MachineRemoteSource {
  Future<MachineDTO> fetchMachineState(String machineId);
  Future<ComponentDTO> updateComponentState(
    String machineId,
    String componentId,
    ComponentState newState,
  );
  Future<ParameterDTO> setParameterValue(
    String machineId,
    String componentId,
    String parameterId,
    double value,
  );
  Future<List<ParameterDTO>> getParameterReadings(
    String machineId,
    String componentId,
    String parameterId,
    DateTime startTime,
    DateTime endTime,
  );
  Stream<MachineDTO> watchMachineState(String machineId);
  Stream<ComponentDTO> watchComponent(String machineId, String componentId);
  Stream<ParameterDTO> watchParameter(
    String machineId,
    String componentId,
    String parameterId,
  );
  Future<MachineDTO> transitionMachineState(String machineId, MachineState newState);
}

class MachineRemoteSourceImpl implements MachineRemoteSource {
  final FirebaseFirestore firestore;

  MachineRemoteSourceImpl({
    required this.firestore,
  });

  @override
  Future<MachineDTO> fetchMachineState(String machineId) async {
    try {
      final machineDoc = await firestore.collection('machines').doc(machineId).get();

      if (!machineDoc.exists) {
        throw NotFoundException('Machine not found');
      }

      final machineData = Map<String, dynamic>.from(machineDoc.data()!);
      machineData['id'] = machineDoc.id;

      // Convert timestamps to ISO strings
      if (machineData['lastMaintenanceDate'] is Timestamp) {
        machineData['lastMaintenanceDate'] =
            (machineData['lastMaintenanceDate'] as Timestamp).toDate().toIso8601String();
      }

      // Map field names to match DTO
      machineData['last_maintenance_date'] = machineData['lastMaintenanceDate'];
      machineData['is_operational'] = machineData['isOperational'];
      machineData['serial_number'] = machineData['serialNumber'];

      // Get components from subcollection
      final componentsSnapshot = await firestore
          .collection('machines')
          .doc(machineId)
          .collection('components')
          .get();

      AppLogger.debug('Processing ${componentsSnapshot.docs.length} components');

      final components = await Future.wait(
        componentsSnapshot.docs.map((componentDoc) async {
          final componentData = Map<String, dynamic>.from(componentDoc.data());
          componentData['id'] = componentDoc.id;

          // Convert component timestamps and map required fields
          if (componentData['lastMaintenanceDate'] is Timestamp) {
            componentData['last_maintenance_date'] =
                (componentData['lastMaintenanceDate'] as Timestamp).toDate().toIso8601String();
          } else if (componentData['lastMaintenanceDate'] is String) {
            componentData['last_maintenance_date'] = componentData['lastMaintenanceDate'];
          }

          // Map required fields first
          componentData['id'] = componentData['id'] as String;
          componentData['name'] = componentData['name'] as String;
          componentData['type'] = componentData['type'] as String;
          componentData['state'] = componentData['state'] as String;
          componentData['is_operational'] = componentData['isOperational'] as bool;

          // Map optional fields based on component type
          final componentType = componentData['type'] as String;
          switch (componentType) {
            case 'valve':
              componentData['valve_location_string'] = componentData['location'] ?? '';
              componentData['is_normally_open'] = componentData['isNormallyOpen'] ?? false;
              componentData['cycle_count'] = componentData['cycleCount'] ?? 0;
              componentData['max_cycles'] = componentData['maxCycles'] ?? 0;
              break;
            case 'heater':
              componentData['heater_location_string'] = componentData['location'] ?? '';
              componentData['max_power'] = componentData['maxPower'] ?? 0.0;
              componentData['ramp_rate'] = componentData['rampRate'] ?? 0.0;
              componentData['steady_state_error'] = componentData['steadyStateError'] ?? 0.0;
              componentData['heating_element_material'] = componentData['heatingElementMaterial'] ?? '';
              componentData['power_cycles'] = componentData['powerCycles'] ?? 0;
              componentData['max_power_cycles'] = componentData['maxPowerCycles'] ?? 0;
              componentData['max_temperature'] = componentData['maxTemperature'] ?? 0.0;
              break;
            case 'vacuumPump':
              componentData['baseline_pressure'] = componentData['baselinePressure'] ?? 0.0;
              componentData['max_inlet_pressure'] = componentData['maxInletPressure'] ?? 0.0;
              componentData['operating_hours'] = componentData['operatingHours'] ?? 0;
              componentData['max_operating_hours'] = componentData['maxOperatingHours'] ?? 0;
              break;
            case 'nitrogenGenerator':
              componentData['max_flow_rate'] = componentData['maxFlowRate'] ?? 0.0;
              componentData['min_purity'] = componentData['minPurity'] ?? 0.0;
              componentData['current_purity'] = componentData['currentPurity'] ?? 0.0;
              break;
            case 'massFlowController':
              componentData['max_flow_rate'] = componentData['maxFlowRate'] ?? 0.0;
              componentData['min_flow_rate'] = componentData['minFlowRate'] ?? 0.0;
              componentData['gas_type'] = componentData['gasType'] ?? '';
              break;
            case 'chamber':
              componentData['max_pressure'] = componentData['maxPressure'] ?? 0.0;
              componentData['max_temperature'] = componentData['maxTemperature'] ?? 0.0;
              break;
          }

          // Get parameters from subcollection
          final parametersSnapshot = await componentDoc.reference
              .collection('parameters')
              .get();

          AppLogger.debug('Processing ${parametersSnapshot.docs.length} parameters for component ${componentDoc.id}');

          final parameters = parametersSnapshot.docs.map((parameterDoc) {
            final parameterData = Map<String, dynamic>.from(parameterDoc.data());
            parameterData['id'] = parameterDoc.id;

            if (parameterData['lastUpdated'] is Timestamp) {
              parameterData['lastUpdated'] =
                  (parameterData['lastUpdated'] as Timestamp).toDate().toIso8601String();
            }

            try {
              return ParameterDTO.fromJson(parameterData);
            } catch (e) {
              AppLogger.error('Error creating ParameterDTO: $e\nParameter data: $parameterData');
              rethrow;
            }
          }).toList();

          componentData['parameters'] = parameters.map((p) => p.toJson()).toList();
          try {
            return ComponentDTO.fromJson(componentData);
          } catch (e) {
            AppLogger.error('Error creating ComponentDTO: $e\nComponent data: $componentData');
            rethrow;
          }
        }),
      );

      // Add components to machine data
      machineData['components'] = components.map((c) => c.toJson()).toList();

      try {
        return MachineDTO.fromJson(machineData);
      } catch (e) {
        AppLogger.error('Error creating MachineDTO: $e\nMachine data: $machineData');
        rethrow;
      }
    } catch (e) {
      AppLogger.error('Error fetching machine state: $e');
      rethrow;
    }
  }

  @override
  Future<ComponentDTO> updateComponentState(
    String machineId,
    String componentId,
    ComponentState newState,
  ) async {
    try {
      final componentRef = firestore
          .collection('machines')
          .doc(machineId)
          .collection('components')
          .doc(componentId);

      await componentRef.update({
        'state': newState.toString().split('.').last,
      });

      final doc = await componentRef.get();
      return ComponentDTO.fromJson(doc.data()!);
    } catch (e) {
      throw ServerException('Failed to update component state: $e');
    }
  }

  @override
  Future<ParameterDTO> setParameterValue(
    String machineId,
    String componentId,
    String parameterId,
    double value,
  ) async {
    try {
      final parameterRef = firestore
          .collection('machines')
          .doc(machineId)
          .collection('components')
          .doc(componentId)
          .collection('parameters')
          .doc(parameterId);

      final timestamp = DateTime.now();
      final parameterData = {
        'value': value,
        'timestamp': Timestamp.fromDate(timestamp),
      };

      await parameterRef.update(parameterData);

      // Also store in history
      await parameterRef
          .collection('history')
          .add(parameterData);

      final doc = await parameterRef.get();
      return ParameterDTO.fromJson(doc.data()!);
    } catch (e) {
      throw ServerException('Failed to set parameter value: $e');
    }
  }

  @override
  Future<List<ParameterDTO>> getParameterReadings(
    String machineId,
    String componentId,
    String parameterId,
    DateTime startTime,
    DateTime endTime,
  ) async {
    try {
      final querySnapshot = await firestore
          .collection('machines')
          .doc(machineId)
          .collection('components')
          .doc(componentId)
          .collection('parameters')
          .doc(parameterId)
          .collection('history')
          .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startTime))
          .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endTime))
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => ParameterDTO.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw ServerException('Failed to get parameter readings: $e');
    }
  }

  @override
  Stream<MachineDTO> watchMachineState(String machineId) {
    return firestore
        .collection('machines')
        .doc(machineId)
        .snapshots()
        .map((doc) => MachineDTO.fromJson(doc.data()!));
  }

  @override
  Stream<ComponentDTO> watchComponent(String machineId, String componentId) {
    return firestore
        .collection('machines')
        .doc(machineId)
        .collection('components')
        .doc(componentId)
        .snapshots()
        .map((doc) => ComponentDTO.fromJson(doc.data()!));
  }

  @override
  Stream<ParameterDTO> watchParameter(
    String machineId,
    String componentId,
    String parameterId,
  ) {
    return firestore
        .collection('machines')
        .doc(machineId)
        .collection('components')
        .doc(componentId)
        .collection('parameters')
        .doc(parameterId)
        .snapshots()
        .map((doc) => ParameterDTO.fromJson(doc.data()!));
  }

  @override
  Future<MachineDTO> transitionMachineState(String machineId, MachineState newState) async {
    try {
      final machineRef = firestore.collection('machines').doc(machineId);

      await machineRef.update({
        'state': newState.toString().split('.').last,
      });

      final doc = await machineRef.get();
      return MachineDTO.fromJson(doc.data()!);
    } catch (e) {
      throw ServerException('Failed to transition machine state: $e');
    }
  }
}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}