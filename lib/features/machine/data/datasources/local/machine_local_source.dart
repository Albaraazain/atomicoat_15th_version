import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/machine_dto.dart';

abstract class MachineLocalSource {
  Future<void> cacheComponentStates(MachineDTO machine);
  Future<MachineDTO> getCachedMachineState(String machineId);
  Future<void> clearCache();
}

class MachineLocalSourceImpl implements MachineLocalSource {
  final SharedPreferences sharedPreferences;
  static const CACHED_MACHINE_KEY = 'CACHED_MACHINE_STATE_';

  MachineLocalSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheComponentStates(MachineDTO machine) async {
    await sharedPreferences.setString(
      CACHED_MACHINE_KEY + machine.id,
      json.encode(machine.toJson()),
    );
  }

  @override
  Future<MachineDTO> getCachedMachineState(String machineId) async {
    final jsonString = sharedPreferences.getString(CACHED_MACHINE_KEY + machineId);
    if (jsonString != null) {
      return MachineDTO.fromJson(json.decode(jsonString));
    } else {
      throw CacheException('No cached machine state found');
    }
  }

  @override
  Future<void> clearCache() async {
    final keys = sharedPreferences.getKeys();
    for (final key in keys) {
      if (key.startsWith(CACHED_MACHINE_KEY)) {
        await sharedPreferences.remove(key);
      }
    }
  }
}

class CacheException implements Exception {
  final String message;
  CacheException(this.message);
}