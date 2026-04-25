import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_business_directory/features/business/presentation/providers/business_provider.dart';

class ReviewDialog extends ConsumerStatefulWidget {
  final String businessId;
  const ReviewDialog({super.key, required this.businessId});

  @override
  ConsumerState<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends ConsumerState<ReviewDialog> {
  double _rating = 5.0;
  final _commentController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rate and Review'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < _rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
                onPressed: () => setState(() => _rating = index + 1.0),
              );
            }),
          ),
          TextField(
            controller: _commentController,
            decoration: const InputDecoration(labelText: 'Write a comment...'),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: _isLoading ? null : () async {
            setState(() => _isLoading = true);
            final result = await ref.read(businessRepositoryProvider).postReview(
              widget.businessId,
              _rating,
              _commentController.text,
            );
            result.fold(
              (l) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.message))),
              (r) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Review posted!')));
                Navigator.pop(context);
              },
            );
          },
          child: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Post'),
        ),
      ],
    );
  }
}
