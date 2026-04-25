import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_business_directory/features/business/domain/entities/business.dart';
import 'package:local_business_directory/features/business/presentation/providers/favorites_provider.dart';
import 'package:local_business_directory/features/business/presentation/widgets/enquiry_dialog.dart';

class BusinessProfileScreen extends ConsumerWidget {
  final Business business;
  const BusinessProfileScreen({super.key, required this.business});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoritesProvider).any((e) => e.id == business.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(business.name),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : null),
            onPressed: () {
              ref.read(favoritesProvider.notifier).toggleFavorite(business);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (business.heroImageUrl != null)
              Image.network(business.heroImageUrl!, height: 200, width: double.infinity, fit: BoxFit.cover)
            else
              Container(height: 200, color: Colors.grey[300], child: const Icon(Icons.business, size: 100)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(business.name, style: Theme.of(context).textTheme.headlineMedium),
                  Text(business.category, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.indigo)),
                  const SizedBox(height: 8),
                  Text(business.description),
                  const Divider(height: 32),
                  const Text('Contact Information', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  if (business.phoneNumber != null) ListTile(leading: const Icon(Icons.phone), title: Text(business.phoneNumber!)),
                  if (business.email != null) ListTile(leading: const Icon(Icons.email), title: Text(business.email!)),
                  ListTile(leading: const Icon(Icons.location_on), title: Text(business.address)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => EnquiryDialog(businessId: business.id),
                            );
                          },
                          icon: const Icon(Icons.message),
                          label: const Text('Inquire'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Show review dialog
                          },
                          icon: const Icon(Icons.rate_review),
                          label: const Text('Review'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
