import 'package:flutter/material.dart';
import '../../../domain/entities/machine.dart' as domain;

class MachineStatusCard extends StatelessWidget {
  final domain.Machine machine;

  const MachineStatusCard({
    Key? key,
    required this.machine,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusRow(context),
            const Divider(height: 24),
            _buildStatusDetails(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(BuildContext context) {
    final color = _getStatusColor();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                machine.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'S/N: ${machine.serialNumber}',
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getStatusIcon(),
                size: 16,
                color: color,
              ),
              const SizedBox(width: 8),
              Text(
                _getStatusText(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusDetails(BuildContext context) {
    return Column(
      children: [
        _buildDetailRow(
          context,
          'Operational Status',
          machine.isOperational ? 'Online' : 'Offline',
          machine.isOperational ? Colors.green : Colors.red,
        ),
        const SizedBox(height: 8),
        _buildDetailRow(
          context,
          'Last Maintenance',
          _formatDate(machine.lastMaintenanceDate),
          machine.needsMaintenance ? Colors.orange : Colors.green,
        ),
        if (machine.hasErrors) ...[
          const SizedBox(height: 8),
          _buildDetailRow(
            context,
            'Errors',
            'Components reporting errors',
            Colors.red,
          ),
        ],
      ],
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    Color valueColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: valueColor, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Color _getStatusColor() {
    switch (machine.state) {
      case domain.MachineState.standby:
        return Colors.blue;
      case domain.MachineState.processPump:
      case domain.MachineState.processIdle:
      case domain.MachineState.precursor1Pulse:
      case domain.MachineState.precursor2Pulse:
      case domain.MachineState.precursor1Purge:
      case domain.MachineState.precursor2Purge:
        return Colors.green;
      case domain.MachineState.error:
        return Colors.red;
      case domain.MachineState.maintenance:
        return Colors.orange;
      case domain.MachineState.initializing:
      case domain.MachineState.purging:
      case domain.MachineState.processComplete:
      case domain.MachineState.shutdown:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon() {
    switch (machine.state) {
      case domain.MachineState.standby:
        return Icons.pause_circle_outline;
      case domain.MachineState.processPump:
      case domain.MachineState.processIdle:
      case domain.MachineState.precursor1Pulse:
      case domain.MachineState.precursor2Pulse:
      case domain.MachineState.precursor1Purge:
      case domain.MachineState.precursor2Purge:
        return Icons.play_circle_outline;
      case domain.MachineState.error:
        return Icons.error_outline;
      case domain.MachineState.maintenance:
        return Icons.build_circle_outlined;
      case domain.MachineState.initializing:
        return Icons.refresh;
      case domain.MachineState.purging:
        return Icons.cleaning_services;
      case domain.MachineState.processComplete:
        return Icons.check_circle_outline;
      case domain.MachineState.shutdown:
        return Icons.power_settings_new;
    }
  }

  String _getStatusText() {
    switch (machine.state) {
      case domain.MachineState.standby:
        return 'STANDBY';
      case domain.MachineState.processPump:
        return 'PUMPING';
      case domain.MachineState.processIdle:
        return 'PROCESS IDLE';
      case domain.MachineState.precursor1Pulse:
        return 'PRECURSOR 1';
      case domain.MachineState.precursor2Pulse:
        return 'PRECURSOR 2';
      case domain.MachineState.precursor1Purge:
        return 'PURGING 1';
      case domain.MachineState.precursor2Purge:
        return 'PURGING 2';
      case domain.MachineState.error:
        return 'ERROR';
      case domain.MachineState.maintenance:
        return 'MAINTENANCE';
      case domain.MachineState.initializing:
        return 'INITIALIZING';
      case domain.MachineState.purging:
        return 'PURGING';
      case domain.MachineState.processComplete:
        return 'COMPLETE';
      case domain.MachineState.shutdown:
        return 'SHUTDOWN';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}