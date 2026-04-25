import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_business_directory/features/business/presentation/providers/business_provider.dart';

class ClaimBusinessDialog extends StatefulWidget {
  final String businessId;
  const ClaimBusinessDialog({super.key, required this.businessId});

  @override
  State<ClaimBusinessDialog> createState() => _ClaimBusinessDialogState();
}

class _ClaimBusinessDialogState extends State<ClaimBusinessDialog> {
  final _reasonController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Claim Business'),
      content: TextField(
        controller: _reasonController,
        decoration: const InputDecoration(labelText: 'Why are you claiming this business?'),
        maxLines: 3,
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        Consumer(builder: (context, ref, _) {
          return ElevatedButton(
            onPressed: _isLoading ? null : () async {
              setState(() => _isLoading = true);
              final result = await ref.read(businessRepositoryProvider).claimBusiness(
                widget.businessId,
                _reasonController.text,
              );
              result.fold(
                (l) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.message))),
                (r) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Claim request sent!')));
                  Navigator.pop(context);
                },
              );
            },
            child: _isLoading ? const CircularProgressIndicator() : const Text('Submit Claim'),
          );
        }),
      ],
    );
  }
}
