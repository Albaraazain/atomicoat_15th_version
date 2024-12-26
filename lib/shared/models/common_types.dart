// Common type definitions used across the app
typedef JSON = Map<String, dynamic>;
typedef StringCallback = void Function(String);
typedef BoolCallback = void Function(bool);
typedef VoidCallback = void Function();

// Common enums
enum LoadingStatus { initial, loading, success, error }

enum ConnectionStatus { connected, disconnected }

// Common constants
const Duration kDefaultAnimationDuration = Duration(milliseconds: 300);
const Duration kDefaultTimeout = Duration(seconds: 30);