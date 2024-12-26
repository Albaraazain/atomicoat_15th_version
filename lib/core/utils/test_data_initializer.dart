import 'package:cloud_firestore/cloud_firestore.dart';

/// Utility class for initializing test data in Firestore
class TestDataInitializer {
  /// Initializes test data in Firestore
  static Future<void> initializeTestData(
    FirebaseFirestore firestore,
    String machineId,
  ) async {
    final now = DateTime.now();
    final batch = firestore.batch();

    // Create machine document
    final machineRef = firestore.collection('machines').doc(machineId);
    batch.set(machineRef, {
      'id': machineId,
      'serialNumber': 'ALD-2024-001',
      'name': 'AtomiCoat R&D System',
      'state': 'standby',
      'lastMaintenanceDate': now.toIso8601String(),
      'isOperational': true,
    });

    // Create chamber document
    final chamberRef = machineRef.collection('components').doc('chamber001');
    batch.set(chamberRef, {
      'id': 'chamber001',
      'name': 'Main Process Chamber',
      'type': 'chamber',
      'state': 'idle',
      'volume': 5000.0,
      'material': 'Stainless Steel 316L',
      'maxPressure': 760.0,
      'maxTemperature': 300.0,
      'lastMaintenanceDate': now.toIso8601String(),
      'isOperational': true,
    });

    // Create chamber parameters
    final chamberTempRef = chamberRef.collection('parameters').doc('chamber_temp');
    batch.set(chamberTempRef, {
      'id': 'chamber_temp',
      'name': 'Chamber Temperature',
      'type': 'temperature',
      'value': 25.0,
      'unit': '°C',
      'minValue': 0.0,
      'maxValue': 300.0,
      'lastUpdated': now.toIso8601String(),
    });

    final chamberPressureRef = chamberRef.collection('parameters').doc('chamber_pressure');
    batch.set(chamberPressureRef, {
      'id': 'chamber_pressure',
      'name': 'Chamber Pressure',
      'type': 'pressure',
      'value': 1.0E-6,
      'unit': 'Torr',
      'minValue': 1.0E-6,
      'maxValue': 760.0,
      'lastUpdated': now.toIso8601String(),
    });

    // Create vacuum pump document
    final pumpRef = machineRef.collection('components').doc('pump001');
    batch.set(pumpRef, {
      'id': 'pump001',
      'name': 'Turbomolecular Pump',
      'type': 'vacuumPump',
      'state': 'active',
      'baselinePressure': 1.0E-8,
      'maxInletPressure': 1.0E-2,
      'operatingHours': 0,
      'maxOperatingHours': 8760,
      'targetPressure': 1.0E-6,
      'pressureTolerance': 1.0E-7,
      'lastMaintenanceDate': now.toIso8601String(),
      'isOperational': true,
    });

    // Create pump parameters
    final pumpInletRef = pumpRef.collection('parameters').doc('inlet_pressure');
    batch.set(pumpInletRef, {
      'id': 'inlet_pressure',
      'name': 'Inlet Pressure',
      'type': 'pressure',
      'value': 1.0E-6,
      'unit': 'Torr',
      'minValue': 1.0E-8,
      'maxValue': 1.0E-2,
      'lastUpdated': now.toIso8601String(),
    });

    final pumpSpeedRef = pumpRef.collection('parameters').doc('pump_speed');
    batch.set(pumpSpeedRef, {
      'id': 'pump_speed',
      'name': 'Pump Speed',
      'type': 'flow',
      'value': 33000,
      'unit': 'RPM',
      'minValue': 0,
      'maxValue': 35000,
      'lastUpdated': now.toIso8601String(),
    });

    // Create heater document
    final heaterRef = machineRef.collection('components').doc('heater001');
    batch.set(heaterRef, {
      'id': 'heater001',
      'name': 'Precursor-1 Heater',
      'type': 'heater',
      'state': 'active',
      'location': 'precursor1',
      'maxTemperature': 200.0,
      'maxPower': 100.0,
      'rampRate': 10.0,
      'steadyStateError': 0.5,
      'heatingElementMaterial': 'Nichrome',
      'powerCycles': 0,
      'maxPowerCycles': 10000,
      'lastMaintenanceDate': now.toIso8601String(),
      'isOperational': true,
    });

    // Create heater parameters
    final heaterTempRef = heaterRef.collection('parameters').doc('temperature');
    batch.set(heaterTempRef, {
      'id': 'temperature',
      'name': 'Temperature',
      'type': 'temperature',
      'value': 150.0,
      'unit': '°C',
      'minValue': 0.0,
      'maxValue': 200.0,
      'lastUpdated': now.toIso8601String(),
    });

    final heaterPowerRef = heaterRef.collection('parameters').doc('power');
    batch.set(heaterPowerRef, {
      'id': 'power',
      'name': 'Power Output',
      'type': 'power',
      'value': 45.0,
      'unit': 'W',
      'minValue': 0.0,
      'maxValue': 100.0,
      'lastUpdated': now.toIso8601String(),
    });

    // Create valve document
    final valveRef = machineRef.collection('components').doc('valve001');
    batch.set(valveRef, {
      'id': 'valve001',
      'name': 'Precursor-1 Valve',
      'type': 'valve',
      'state': 'idle',
      'location': 'precursor1',
      'isNormallyOpen': false,
      'cycleCount': 0,
      'maxCycles': 1000000,
      'lastMaintenanceDate': now.toIso8601String(),
      'isOperational': true,
    });

    // Create valve parameters
    final valvePositionRef = valveRef.collection('parameters').doc('position');
    batch.set(valvePositionRef, {
      'id': 'position',
      'name': 'Valve Position',
      'type': 'flow',
      'value': 0.0,
      'unit': '',
      'minValue': 0.0,
      'maxValue': 1.0,
      'lastUpdated': now.toIso8601String(),
    });

    // Create nitrogen generator document
    final n2genRef = machineRef.collection('components').doc('n2gen001');
    batch.set(n2genRef, {
      'id': 'n2gen001',
      'name': 'Nitrogen Generator',
      'type': 'nitrogenGenerator',
      'state': 'active',
      'maxFlowRate': 10.0,
      'minPurity': 99.995,
      'currentPurity': 99.999,
      'lastMaintenanceDate': now.toIso8601String(),
      'isOperational': true,
    });

    // Create nitrogen generator parameters
    final n2genFlowRef = n2genRef.collection('parameters').doc('flow_rate');
    batch.set(n2genFlowRef, {
      'id': 'flow_rate',
      'name': 'Flow Rate',
      'type': 'flow',
      'value': 5.0,
      'unit': 'SLPM',
      'minValue': 0.0,
      'maxValue': 10.0,
      'lastUpdated': now.toIso8601String(),
    });

    final n2genPurityRef = n2genRef.collection('parameters').doc('purity');
    batch.set(n2genPurityRef, {
      'id': 'purity',
      'name': 'N2 Purity',
      'type': 'purity',
      'value': 99.999,
      'unit': '%',
      'minValue': 99.9,
      'maxValue': 100.0,
      'lastUpdated': now.toIso8601String(),
    });

    // Create MFC document
    final mfcRef = machineRef.collection('components').doc('mfc001');
    batch.set(mfcRef, {
      'id': 'mfc001',
      'name': 'Purge Gas MFC',
      'type': 'massFlowController',
      'state': 'active',
      'maxFlowRate': 200.0,
      'minFlowRate': 0.0,
      'accuracy': 1.0,
      'gasType': 'N2',
      'lastMaintenanceDate': now.toIso8601String(),
      'isOperational': true,
    });

    // Create MFC parameters
    final mfcFlowRef = mfcRef.collection('parameters').doc('flow_rate');
    batch.set(mfcFlowRef, {
      'id': 'flow_rate',
      'name': 'Flow Rate',
      'type': 'flow',
      'value': 100.0,
      'unit': 'sccm',
      'minValue': 0.0,
      'maxValue': 200.0,
      'lastUpdated': now.toIso8601String(),
    });

    // Commit all the changes
    await batch.commit();
  }
}