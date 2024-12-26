import '../component.dart';
import '../parameter.dart';

enum ValveLocation {
  precursor1,
  precursor2,
  purge,
  vacuum,
}

class Valve extends Component {
  final ValveLocation location;
  final bool isNormallyOpen;
  final int cycleCount;
  final int maxCycles;

  const Valve({
    required super.id,
    required super.name,
    required super.state,
    required super.parameters,
    required super.lastMaintenanceDate,
    required super.isOperational,
    required this.location,
    required this.isNormallyOpen,
    required this.cycleCount,
    required this.maxCycles,
  }) : super(type: ComponentType.valve);

  @override
  bool get isSafe {
    return cycleCount <= maxCycles &&
           isOperational &&
           (isNormallyOpen ? isOpen : isClosed);
  }

  bool get isOpen {
    final position = getParameter('position')?.value ?? 0;
    return position >= 0.9;
  }

  bool get isClosed {
    final position = getParameter('position')?.value ?? 0;
    return position <= 0.1;
  }

  bool get isTransitioning {
    final position = getParameter('position')?.value ?? 0;
    return position > 0.1 && position < 0.9;
  }

  bool get isActuating => state == ComponentState.active;

  int get remainingCycles => maxCycles - cycleCount;

  Valve incrementCycleCount() {
    return copyWith(cycleCount: cycleCount + 1);
  }

  @override
  bool get needsMaintenance {
    final timeSinceLastMaintenance = DateTime.now().difference(lastMaintenanceDate).inDays;
    return cycleCount >= (maxCycles * 0.9) || // 90% of max cycles
           timeSinceLastMaintenance > 180; // 6 months maintenance interval
  }

  @override
  Valve copyWith({
    String? id,
    String? name,
    ComponentState? state,
    List<Parameter>? parameters,
    DateTime? lastMaintenanceDate,
    bool? isOperational,
    ValveLocation? location,
    bool? isNormallyOpen,
    int? cycleCount,
    int? maxCycles,
  }) {
    return Valve(
      id: id ?? this.id,
      name: name ?? this.name,
      state: state ?? this.state,
      parameters: parameters ?? this.parameters,
      lastMaintenanceDate: lastMaintenanceDate ?? this.lastMaintenanceDate,
      isOperational: isOperational ?? this.isOperational,
      location: location ?? this.location,
      isNormallyOpen: isNormallyOpen ?? this.isNormallyOpen,
      cycleCount: cycleCount ?? this.cycleCount,
      maxCycles: maxCycles ?? this.maxCycles,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    location,
    isNormallyOpen,
    cycleCount,
    maxCycles,
  ];
}