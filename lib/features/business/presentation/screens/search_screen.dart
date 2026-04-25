import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_business_directory/features/business/presentation/providers/business_provider.dart';
import 'package:local_business_directory/features/business/presentation/screens/business_profile_screen.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResults = ref.watch(searchBusinessesProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Search businesses...',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            ref.read(searchQueryProvider.notifier).state = value;
          },
        ),
      ),
      body: searchResults.when(
        data: (businesses) {
          if (businesses.isEmpty) {
            return const Center(child: Text('No businesses found.'));
          }
          return ListView.builder(
            itemCount: businesses.length,
            itemBuilder: (context, index) {
              final business = businesses[index];
              return ListTile(
                leading: Hero(
                  tag: 'business_image_${business.id}',
                  child: business.heroImageUrl != null
                      ? Image.network(business.heroImageUrl!, width: 50, height: 50, fit: BoxFit.cover)
                      : const Icon(Icons.business),
                ),
                title: Text(business.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(business.category),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        Text(' ${business.averageRating.toStringAsFixed(1)} (${business.reviewCount})'),
                      ],
                    ),
                  ],
                ),
                trailing: business.isFeatured ? const Icon(Icons.star, color: Colors.amber) : null,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => BusinessProfileScreen(business: business)),
                  );
                },
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
