import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_business_directory/features/business/presentation/providers/business_provider.dart';

class EnquiryDialog extends ConsumerStatefulWidget {
  final String businessId;
  const EnquiryDialog({super.key, required this.businessId});

  @override
  ConsumerState<EnquiryDialog> createState() => _EnquiryDialogState();
}

class _EnquiryDialogState extends ConsumerState<EnquiryDialog> {
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Send Enquiry'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: _subjectController, decoration: const InputDecoration(labelText: 'Subject')),
          TextField(controller: _messageController, decoration: const InputDecoration(labelText: 'Message'), maxLines: 3),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: _isLoading ? null : () async {
            setState(() => _isLoading = true);
            final result = await ref.read(businessRepositoryProvider).sendEnquiry(
              widget.businessId,
              _subjectController.text,
              _messageController.text,
            );
            result.fold(
              (l) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.message))),
              (r) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enquiry sent!')));
                Navigator.pop(context);
              },
            );
          },
          child: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Send'),
        ),
      ],
    );
  }
}
