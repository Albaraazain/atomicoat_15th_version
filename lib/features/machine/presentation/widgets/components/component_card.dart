import 'package:flutter/material.dart';
import '../../../domain/entities/component.dart';
import '../../../domain/entities/components/chamber.dart';

class ComponentCard extends StatelessWidget {
  final Component component;
  final VoidCallback? onTap;

  const ComponentCard({
    Key? key,
    required this.component,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          component.name,
                          style: Theme.of(context).textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getComponentTypeText(),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  _buildStatusIndicator(context),
                ],
              ),
              const Spacer(),
              _buildComponentSpecificInfo(context),
              const SizedBox(height: 8),
              _buildParameterSummary(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(BuildContext context) {
    final color = _getStatusColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStatusIcon(),
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            _getStatusText(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildComponentSpecificInfo(BuildContext context) {
    if (component is Chamber) {
      final chamber = component as Chamber;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Volume: ${chamber.volume} cm³',
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              chamber.material,
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildParameterSummary(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.sensors,
          size: 16,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          '${component.parameters.length} Parameters',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        if (component.state == ComponentState.error) ...[
          const Spacer(),
          const Icon(
            Icons.warning_amber_rounded,
            size: 16,
            color: Colors.red,
          ),
        ],
      ],
    );
  }

  Color _getStatusColor() {
    switch (component.state) {
      case ComponentState.idle:
        return Colors.blue;
      case ComponentState.active:
        return Colors.green;
      case ComponentState.error:
        return Colors.red;
      case ComponentState.maintenance:
        return Colors.orange;
      case ComponentState.off:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon() {
    switch (component.state) {
      case ComponentState.idle:
        return Icons.pause_circle_outline;
      case ComponentState.active:
        return Icons.play_circle_outline;
      case ComponentState.error:
        return Icons.error_outline;
      case ComponentState.maintenance:
        return Icons.build_circle_outlined;
      case ComponentState.off:
        return Icons.power_settings_new;
    }
  }

  String _getStatusText() {
    switch (component.state) {
      case ComponentState.idle:
        return 'IDLE';
      case ComponentState.active:
        return 'ACTIVE';
      case ComponentState.error:
        return 'ERROR';
      case ComponentState.maintenance:
        return 'MAINTENANCE';
      case ComponentState.off:
        return 'OFF';
    }
  }

  String _getComponentTypeText() {
    switch (component.type) {
      case ComponentType.chamber:
        return 'Reaction Chamber';
      case ComponentType.valve:
        return 'Control Valve';
      case ComponentType.pump:
        return 'Vacuum Pump';
      case ComponentType.heater:
        return 'Heater System';
      case ComponentType.nitrogenGenerator:
        return 'Nitrogen Generator';
      case ComponentType.massFlowController:
        return 'Mass Flow Controller';
      case ComponentType.vacuumPump:
        return 'Vacuum Pump';
    }
  }
}
