import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/sync_engine.dart';
import '../../../../core/di/injection.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enterprise Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: authState.maybeWhen(
                  authenticated: (user) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, ${user.name}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Email: ${user.email}'),
                      Text('Role: ${user.role}'),
                    ],
                  ),
                  orElse: () => const Text('Loading Session...'),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Offline sync utilities:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Simulate Offline Mutation Request'),
              onPressed: () async {
                // Enqueue a mock request to the Sync Queue
                await getIt<SyncEngine>().enqueueMutation(
                  endpoint: '/trips/create',
                  method: 'POST',
                  payload: {
                    'trip_id': 'TRP-10922',
                    'timestamp': DateTime.now().toIso8601String(),
                    'destination': 'Headquarters Office',
                  },
                );
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mock mutation added to local Sync Queue.')),
                );
              },
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.sync),
              label: const Text('Process Sync Queue Now'),
              onPressed: () async {
                await getIt<SyncEngine>().processQueue();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Offline sync execution triggered.')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
