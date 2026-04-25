import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_business_directory/features/auth/presentation/providers/auth_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsFuture = ref.watch(FutureProvider((ref) => ref.read(authRepositoryProvider).getNotifications()));

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: notificationsFuture.when(
        data: (result) => result.fold(
          (l) => Center(child: Text(l.message)),
          (list) {
            if (list.isEmpty) return const Center(child: Text('No notifications'));
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final notification = list[index];
                return ListTile(
                  leading: const Icon(Icons.notifications_active, color: Colors.indigo),
                  title: Text(notification.title),
                  subtitle: Text(notification.message),
                  trailing: Text('${notification.createdAt.hour}:${notification.createdAt.minute}'),
                );
              },
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text(e.toString())),
      ),
    );
  }
}
