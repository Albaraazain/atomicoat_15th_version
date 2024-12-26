import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/machine.dart' as domain;
import '../../domain/entities/component.dart';
import '../bloc/machine_bloc.dart';
import '../bloc/machine_event.dart';
import '../bloc/machine_state.dart';
import '../widgets/machine/machine_status_card.dart';
import '../widgets/machine/machine_overview.dart';
import '../widgets/components/component_card.dart';
import '../../../../shared/widgets/app_drawer.dart';
import 'component_details_page.dart';

class MachineDashboardPage extends StatelessWidget {
  final String machineId;

  const MachineDashboardPage({
    Key? key,
    required this.machineId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MachineBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Machine Dashboard'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                context.read<MachineBloc>().add(GetMachineStateEvent(machineId));
              },
            ),
          ],
        ),
        drawer: const AppDrawer(),
        body: BlocBuilder<MachineBloc, MachineState>(
          builder: (context, state) {
            if (state is MachineInitial) {
              context.read<MachineBloc>()
                ..add(GetMachineStateEvent(machineId))
                ..add(StartWatchingMachineEvent(machineId));
              return const Center(child: CircularProgressIndicator());
            }

            if (state is MachineLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is MachineError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<MachineBloc>()
                            .add(GetMachineStateEvent(machineId));
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is MachineLoaded || state is WatchingMachine) {
              final machine = state is MachineLoaded
                  ? state.machine
                  : (state as WatchingMachine).machine;
              return _buildDashboard(context, machine);
            }

            return const Center(child: Text('Unknown state'));
          },
        ),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, domain.Machine machine) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<MachineBloc>().add(GetMachineStateEvent(machineId));
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MachineStatusCard(machine: machine),
                  const SizedBox(height: 16),
                  MachineOverview(machine: machine),
                  const SizedBox(height: 16),
                  const Text(
                    'Components',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final component = machine.components[index];
                  return ComponentCard(
                    component: component,
                    onTap: () => _navigateToComponentDetails(
                      context,
                      machine,
                      component,
                    ),
                  );
                },
                childCount: machine.components.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToComponentDetails(
    BuildContext context,
    domain.Machine machine,
    Component component,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (_) => getIt<MachineBloc>(),
          child: ComponentDetailsPage(
            machineId: machine.id,
            component: component,
          ),
        ),
      ),
    );
  }
}