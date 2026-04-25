import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:local_business_directory/features/business/domain/entities/business.dart';
import 'package:local_business_directory/features/business/presentation/providers/favorites_provider.dart';
import 'package:local_business_directory/features/business/presentation/providers/business_provider.dart';
import 'package:local_business_directory/features/business/presentation/widgets/enquiry_dialog.dart';
import 'package:local_business_directory/features/business/presentation/widgets/review_dialog.dart';

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
            Hero(
              tag: 'business_image_${business.id}',
              child: business.heroImageUrl != null
                  ? Image.network(business.heroImageUrl!, height: 200, width: double.infinity, fit: BoxFit.cover)
                  : Container(height: 200, width: double.infinity, color: Colors.grey[300], child: const Icon(Icons.business, size: 100)),
            ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Contact Information', style: TextStyle(fontWeight: FontWeight.bold)),
                      if (business.ownerId == null)
                        TextButton.icon(
                          onPressed: () {
                            // Show claim dialog
                          },
                          icon: const Icon(Icons.verified_user),
                          label: const Text('Claim Business'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (business.phoneNumber != null) ListTile(leading: const Icon(Icons.phone), title: Text(business.phoneNumber!)),
                  if (business.email != null) ListTile(leading: const Icon(Icons.email), title: Text(business.email!)),
                  if (business.youtubeVideoUrl != null) ...[
                    const Divider(),
                    const Text('Video', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    YoutubePlayer(
                      controller: YoutubePlayerController(
                        initialVideoId: YoutubePlayer.convertUrlToId(business.youtubeVideoUrl!) ?? '',
                        flags: const YoutubePlayerFlags(autoPlay: false),
                      ),
                      showVideoProgressIndicator: true,
                    ),
                  ],
                  ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(business.address),
                    trailing: IconButton(
                      icon: const Icon(Icons.directions, color: Colors.blue),
                      onPressed: () async {
                        final url = 'https://www.google.com/maps/dir/?api=1&destination=${business.latitude},${business.longitude}';
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url));
                        }
                      },
                    ),
                  ),
                  const Divider(height: 32),
                  const Text('Offerings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 8),
                  ref.watch(businessOfferingsProvider(business.id)).when(
                        data: (offerings) {
                          if (offerings.isEmpty) return const Text('No offerings listed.');
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: offerings.length,
                            itemBuilder: (context, index) {
                              final offering = offerings[index];
                              return Card(
                                color: offering.isFlagship ? Colors.indigo.shade50 : null,
                                child: ListTile(
                                  title: Text(offering.name),
                                  subtitle: Text(offering.description),
                                  trailing: Text('\$${offering.price}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                  leading: offering.isFlagship ? const Icon(Icons.flash_on, color: Colors.indigo) : null,
                                ),
                              );
                            },
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (e, s) => Text('Error loading offerings: $e'),
                      ),
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
                            showDialog(
                              context: context,
                              builder: (_) => ReviewDialog(businessId: business.id),
                            );
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
