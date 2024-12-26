import 'package:hive/hive.dart';
import '../../features/auth/data/models/user_dto.dart';

/// Registers all Hive type adapters
Future<void> registerHiveAdapters() async {
  // Register adapters for main types
  Hive.registerAdapter(UserDTOAdapter());
}