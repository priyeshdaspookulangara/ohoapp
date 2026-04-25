import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_business_directory/features/business/presentation/providers/business_provider.dart';

class AdminDashboard extends ConsumerWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Admins see all businesses (mocking for now or using search with no query)
    final allBusinesses = ref.watch(searchBusinessesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: allBusinesses.when(
        data: (businesses) {
          return ListView.builder(
            itemCount: businesses.length,
            itemBuilder: (context, index) {
              final business = businesses[index];
              return ListTile(
                title: Text(business.name),
                subtitle: Text('Owner: ${business.ownerId ?? 'Unknown'}'),
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
      ),
    );
  }
}
