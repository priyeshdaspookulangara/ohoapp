import 'package:flutter/material.dart';
import 'package:local_business_directory/features/business/domain/entities/business.dart';

class BusinessProfileScreen extends StatelessWidget {
  final Business business;
  const BusinessProfileScreen({super.key, required this.business});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(business.name)),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
