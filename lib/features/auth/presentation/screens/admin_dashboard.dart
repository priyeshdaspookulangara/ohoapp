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
            tabs: [Tab(text: 'Moderation'), Tab(text: 'Claims'), Tab(text: 'Media'), Tab(text: 'Users')],
          ),
        ),
        body: TabBarView(
          children: [
            _ModerationList(),
            _ClaimRequestsList(),
            _MediaManager(),
            _UserManagementList(),
          ],
        ),
      ),
    );
  }
}

class _ClaimRequestsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 2,
      itemBuilder: (context, index) => ListTile(
        title: Text('Claim Request #$index'),
        subtitle: const Text('Reason: I am the legal owner of this shop.'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.check, color: Colors.green), onPressed: () {}),
            IconButton(icon: const Icon(Icons.close, color: Colors.red), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

class _UserManagementList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text('User $index'),
        subtitle: Text('role: ${index % 2 == 0 ? 'customer' : 'business_owner'}'),
        trailing: IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () {}),
      ),
    );
  }
}

class _MediaManager extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allBusinesses = ref.watch(searchBusinessesProvider);
    return allBusinesses.when(
      data: (businesses) {
        final allImages = businesses.expand((b) => [if (b.heroImageUrl != null) b.heroImageUrl!, ...b.galleryUrls]).toList();
        if (allImages.isEmpty) return const Center(child: Text('No media to moderate'));
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemCount: allImages.length,
          itemBuilder: (context, index) => Stack(
            children: [
              Image.network(allImages[index], fit: BoxFit.cover, width: double.infinity, height: double.infinity),
              Positioned(
                right: 0,
                child: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () {}),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
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
