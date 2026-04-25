import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_business_directory/features/business/domain/entities/business.dart';
import 'package:local_business_directory/features/business/presentation/providers/business_provider.dart';
import 'package:local_business_directory/features/business/presentation/screens/business_interactions_screen.dart';
import 'package:local_business_directory/features/business/presentation/screens/edit_business_screen.dart';
import 'package:local_business_directory/features/business/presentation/screens/edit_offering_screen.dart';
import 'package:local_business_directory/features/business/presentation/screens/promote_business_screen.dart';

class BusinessOwnerDashboard extends ConsumerWidget {
  const BusinessOwnerDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ownedBusinesses = ref.watch(ownedBusinessesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Businesses')),
      body: ownedBusinesses.when(
        data: (businesses) {
          if (businesses.isEmpty) {
            return const Center(child: Text('You don\'t have any business listings.'));
          }
          return ListView.builder(
            itemCount: businesses.length,
            itemBuilder: (context, index) {
              final business = businesses[index];
              return ListTile(
                title: Text(business.name),
                subtitle: Text(business.category),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.message),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => BusinessInteractionsScreen(businessId: business.id)),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.shopping_bag),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => EditOfferingScreen(businessId: business.id)),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.campaign),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => PromoteBusinessScreen(businessId: business.id)),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => EditBusinessScreen(business: business)),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const EditBusinessScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
