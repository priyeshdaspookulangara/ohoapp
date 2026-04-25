import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_business_directory/features/business/domain/entities/interaction.dart';
import 'package:local_business_directory/features/business/presentation/providers/business_provider.dart';

class BusinessInteractionsScreen extends ConsumerWidget {
  final String businessId;
  const BusinessInteractionsScreen({super.key, required this.businessId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Enquiries & Reviews'),
          bottom: const TabBar(
            tabs: [Tab(text: 'Enquiries'), Tab(text: 'Reviews')],
          ),
        ),
        body: TabBarView(
          children: [
            _EnquiriesList(businessId: businessId),
            _ReviewsList(businessId: businessId),
          ],
        ),
      ),
    );
  }
}

class _EnquiriesList extends ConsumerWidget {
  final String businessId;
  const _EnquiriesList({required this.businessId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enquiries = ref.watch(FutureProvider((ref) => ref.read(businessRepositoryProvider).getBusinessEnquiries(businessId)));

    return enquiries.when(
      data: (result) => result.fold(
        (l) => Center(child: Text(l.message)),
        (list) => ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) => _EnquiryTile(enquiry: list[index]),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text(e.toString())),
    );
  }
}

class _EnquiryTile extends ConsumerWidget {
  final Enquiry enquiry;
  const _EnquiryTile({required this.enquiry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final replyController = TextEditingController(text: enquiry.reply);
    return ExpansionTile(
      title: Text(enquiry.subject),
      subtitle: Text('From: ${enquiry.userName}'),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(enquiry.message),
              const Divider(),
              TextField(
                controller: replyController,
                decoration: const InputDecoration(labelText: 'Your Reply'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await ref.read(businessRepositoryProvider).replyToEnquiry(enquiry.id, replyController.text);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reply sent')));
                },
                child: const Text('Send Reply'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReviewsList extends ConsumerWidget {
  final String businessId;
  const _ReviewsList({required this.businessId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviews = ref.watch(FutureProvider((ref) => ref.read(businessRepositoryProvider).getBusinessReviews(businessId)));

    return reviews.when(
      data: (result) => result.fold(
        (l) => Center(child: Text(l.message)),
        (list) => ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) => _ReviewTile(review: list[index]),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text(e.toString())),
    );
  }
}

class _ReviewTile extends ConsumerWidget {
  final Review review;
  const _ReviewTile({required this.review});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final replyController = TextEditingController(text: review.reply);
    return ExpansionTile(
      title: Row(
        children: [
          ...List.generate(5, (i) => Icon(i < review.rating ? Icons.star : Icons.star_border, size: 16, color: Colors.amber)),
          const SizedBox(width: 8),
          Text(review.userName),
        ],
      ),
      subtitle: Text(review.comment),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: replyController,
                decoration: const InputDecoration(labelText: 'Your Reply'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await ref.read(businessRepositoryProvider).replyToReview(review.id, replyController.text);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reply sent')));
                },
                child: const Text('Send Reply'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
