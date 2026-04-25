import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_business_directory/features/business/domain/repositories/monetization_repository.dart';

final monetizationRepositoryProvider = Provider<MonetizationRepository>((ref) => MonetizationRepositoryImpl());

class PromoteBusinessScreen extends ConsumerWidget {
  final String businessId;
  const PromoteBusinessScreen({super.key, required this.businessId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Promote Business')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Featured Plans', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                title: const Text('Premium Visibility'),
                subtitle: const Text('Appear at the top of search results.'),
                trailing: ElevatedButton(onPressed: () {}, child: const Text('\$25/mo')),
              ),
            ),
            const Divider(height: 48),
            const Text('Discount Coupons', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Request a special discount code for your next feature purchase.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Show coupon request dialog
              },
              child: const Text('Request Coupon'),
            ),
          ],
        ),
      ),
    );
  }
}
