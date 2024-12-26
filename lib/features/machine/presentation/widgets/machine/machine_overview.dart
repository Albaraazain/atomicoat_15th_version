import 'package:flutter/material.dart';
import '../../../domain/entities/machine.dart' as domain;
import '../../../domain/entities/component.dart';
import '../../pages/component_details_page.dart';
import 'system_overview.dart';

class MachineOverview extends StatelessWidget {
  final domain.Machine machine;

  const MachineOverview({
    Key? key,
    required this.machine,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overview',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            // System diagram with interactive components
            SystemOverview(
              onComponentTap: () {
                // Handle component navigation
                // This will be handled by the component hotspots themselves
              },
            ),
            const SizedBox(height: 24),
            // Statistics
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard(
                  context,
                  'Total Components',
                  machine.components.length.toString(),
                  Icons.precision_manufacturing,
                ),
                _buildStatCard(
                  context,
                  'Active Components',
                  _countActiveComponents().toString(),
                  Icons.play_circle,
                ),
                _buildStatCard(
                  context,
                  'Error Components',
                  _countErrorComponents().toString(),
                  Icons.error,
                  isError: true,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildMaintenanceWarning(context),
          ],
        ),
      ),
    );
  }

  void _navigateToComponentDetails(BuildContext context, Component component) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComponentDetailsPage(
          machineId: machine.id,
          component: component,
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    bool isError = false,
  }) {
    final color = isError && int.parse(value) > 0 ? Colors.red : Colors.blue;

    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 32,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildMaintenanceWarning(BuildContext context) {
    if (!machine.needsMaintenance) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Maintenance Required',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  int _countActiveComponents() {
    return machine.components
        .where((c) => c.state == ComponentState.active)
        .length;
  }

  int _countErrorComponents() {
    return machine.components
        .where((c) => c.state == ComponentState.error)
        .length;
  }
}