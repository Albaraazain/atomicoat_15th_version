import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class UserManagementPage extends StatelessWidget {
  const UserManagementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AuthError) {
            return Center(child: Text(state.message));
          }

          if (state is! Authenticated || state.user.role != UserRole.admin) {
            return const Center(
              child: Text('You do not have permission to access this page'),
            );
          }

          return const PendingRegistrationsView();
        },
      ),
    );
  }
}

class PendingRegistrationsView extends StatefulWidget {
  const PendingRegistrationsView({Key? key}) : super(key: key);

  @override
  State<PendingRegistrationsView> createState() => _PendingRegistrationsViewState();
}

class _PendingRegistrationsViewState extends State<PendingRegistrationsView> {
  @override
  void initState() {
    super.initState();
    // Load pending registrations when the view is initialized
    context.read<AuthBloc>().add(LoadPendingRegistrations());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is PendingRegistrationsLoaded) {
          if (state.pendingUsers.isEmpty) {
            return const Center(
              child: Text('No pending registrations'),
            );
          }

          return ListView.builder(
            itemCount: state.pendingUsers.length,
            itemBuilder: (context, index) {
              final user = state.pendingUsers[index];
              return RegistrationRequestCard(user: user);
            },
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class RegistrationRequestCard extends StatelessWidget {
  final User user;

  const RegistrationRequestCard({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text('Email: ${user.email}'),
            Text('Machine Serial: ${user.machineSerialNumber}'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _showApprovalDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Approve'),
                ),
                ElevatedButton(
                  onPressed: () => _showRejectionDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Reject'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showApprovalDialog(BuildContext context) {
    UserRole selectedRole = UserRole.researcher;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approve Registration'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select role for the user:'),
            const SizedBox(height: 16),
            StatefulBuilder(
              builder: (context, setState) => DropdownButton<UserRole>(
                value: selectedRole,
                items: UserRole.values
                    .map((role) => DropdownMenuItem(
                          value: role,
                          child: Text(role.toString().split('.').last),
                        ))
                    .toList(),
                onChanged: (role) {
                  if (role != null) {
                    setState(() => selectedRole = role);
                  }
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AuthBloc>().add(
                    ApproveRegistration(
                      userId: user.id.toString(),
                      assignedRole: selectedRole,
                    ),
                  );
              Navigator.pop(context);
            },
            child: const Text('Approve'),
          ),
        ],
      ),
    );
  }

  void _showRejectionDialog(BuildContext context) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Registration'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please provide a reason for rejection:'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                hintText: 'Enter rejection reason',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please provide a reason for rejection'),
                  ),
                );
                return;
              }

              context.read<AuthBloc>().add(
                    RejectRegistration(
                      userId: user.id.toString(),
                      reason: reasonController.text.trim(),
                    ),
                  );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }
}