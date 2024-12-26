import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/component.dart';
import '../../domain/entities/parameter.dart';
import '../bloc/machine_bloc.dart';
import '../bloc/machine_event.dart';
import '../widgets/parameters/parameter_value_display.dart';
import '../widgets/parameters/parameter_chart.dart';
import '../widgets/parameters/parameter_controls.dart';

class ComponentDetailsPage extends StatefulWidget {
  final String machineId;
  final Component component;

  const ComponentDetailsPage({
    Key? key,
    required this.machineId,
    required this.component,
  }) : super(key: key);

  @override
  State<ComponentDetailsPage> createState() => _ComponentDetailsPageState();
}

class _ComponentDetailsPageState extends State<ComponentDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Parameter? _selectedParameter;
  late MachineBloc _machineBloc;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _machineBloc = context.read<MachineBloc>();
    if (widget.component.parameters.isNotEmpty) {
      _selectedParameter = widget.component.parameters.first;
      _startWatchingParameter();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _machineBloc.add(const StopWatchingParameterEvent());
    super.dispose();
  }

  void _startWatchingParameter() {
    if (_selectedParameter != null) {
      _machineBloc.add(StartWatchingParameterEvent(
            machineId: widget.machineId,
            componentId: widget.component.id,
            parameterId: _selectedParameter!.id,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.component.name),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildHistoryTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildComponentInfo(),
                  const SizedBox(height: 24),
                  _buildParameterSection(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildComponentInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Component Information',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Type', _getComponentTypeText()),
            _buildInfoRow('Status', _getStatusText()),
            _buildInfoRow(
              'Operational',
              widget.component.isOperational ? 'Yes' : 'No',
            ),
            _buildInfoRow(
              'Last Maintenance',
              _formatDate(widget.component.lastMaintenanceDate),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParameterSection() {
    if (widget.component.parameters.isEmpty) {
      return const Center(
        child: Text('No parameters available'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Parameters',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        _buildParameterSelector(),
        if (_selectedParameter != null) ...[
          const SizedBox(height: 16),
          ParameterValueDisplay(parameter: _selectedParameter!),
          const SizedBox(height: 16),
          ParameterControls(
            machineId: widget.machineId,
            componentId: widget.component.id,
            parameter: _selectedParameter!,
          ),
        ],
      ],
    );
  }

  Widget _buildParameterSelector() {
    return DropdownButtonFormField<String>(
      value: _selectedParameter?.id,
      decoration: const InputDecoration(
        labelText: 'Select Parameter',
        border: OutlineInputBorder(),
      ),
      items: widget.component.parameters
          .map((param) => DropdownMenuItem(
                value: param.id,
                child: Text(param.name),
              ))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedParameter = widget.component.parameters
                .firstWhere((param) => param.id == value);
          });
          _machineBloc.add(const StopWatchingParameterEvent());
          _startWatchingParameter();
        }
      },
    );
  }

  Widget _buildHistoryTab() {
    if (_selectedParameter == null) {
      return const Center(
        child: Text('Select a parameter to view history'),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          padding: const EdgeInsets.all(16.0),
          child: ParameterChart(
            machineId: widget.machineId,
            componentId: widget.component.id,
            parameter: _selectedParameter!,
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  String _getComponentTypeText() {
    switch (widget.component.type) {
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

  String _getStatusText() {
    switch (widget.component.state) {
      case ComponentState.idle:
        return 'Idle';
      case ComponentState.active:
        return 'Active';
      case ComponentState.error:
        return 'Error';
      case ComponentState.maintenance:
        return 'Maintenance';
      case ComponentState.off:
        return 'Off';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}