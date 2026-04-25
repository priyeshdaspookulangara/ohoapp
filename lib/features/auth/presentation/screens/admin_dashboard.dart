import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_business_directory/features/business/presentation/providers/business_provider.dart';

class AdminDashboard extends ConsumerWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          bottom: const TabBar(
            tabs: [Tab(text: 'Moderation'), Tab(text: 'Claims'), Tab(text: 'Users')],
          ),
        ),
        body: TabBarView(
          children: [
            _ModerationList(),
            const Center(child: Text('No pending claim requests')),
            const Center(child: Text('User management coming soon')),
          ],
        ),
      ),
    );
  }
}

class _ModerationList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allBusinesses = ref.watch(searchBusinessesProvider);
    return allBusinesses.when(
      data: (businesses) {
        return ListView.builder(
          itemCount: businesses.length,
          itemBuilder: (context, index) {
            final business = businesses[index];
            return ListTile(
              title: Text(business.name),
              subtitle: Text('Owner: ${business.ownerId ?? 'Unowned'}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(icon: const Icon(Icons.check, color: Colors.green), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.close, color: Colors.red), onPressed: () {}),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
