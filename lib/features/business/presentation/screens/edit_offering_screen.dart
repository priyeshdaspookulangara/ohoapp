import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_business_directory/features/business/domain/entities/offering.dart';
import 'package:local_business_directory/features/business/presentation/providers/business_provider.dart';

class EditOfferingScreen extends ConsumerStatefulWidget {
  final String businessId;
  final Offering? offering;
  const EditOfferingScreen({super.key, required this.businessId, this.offering});

  @override
  ConsumerState<EditOfferingScreen> createState() => _EditOfferingScreenState();
}

class _EditOfferingScreenState extends ConsumerState<EditOfferingScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  bool _isFlagship = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.offering?.name);
    _descriptionController = TextEditingController(text: widget.offering?.description);
    _priceController = TextEditingController(text: widget.offering?.price.toString());
    _isFlagship = widget.offering?.isFlagship ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.offering == null ? 'Add Offering' : 'Edit Offering')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 2,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              SwitchListTile(
                title: const Text('Flagship Offering'),
                value: _isFlagship,
                onChanged: (v) => setState(() => _isFlagship = v),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() => _isLoading = true);
                    final offering = Offering(
                      id: widget.offering?.id ?? '',
                      businessId: widget.businessId,
                      name: _nameController.text,
                      description: _descriptionController.text,
                      price: double.parse(_priceController.text),
                      isFlagship: _isFlagship,
                    );

                    final result = widget.offering == null
                      ? await ref.read(businessRepositoryProvider).addOffering(offering)
                      : await ref.read(businessRepositoryProvider).updateOffering(offering);

                    result.fold(
                      (l) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.message))),
                      (r) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Success')));
                        Navigator.pop(context);
                      },
                    );
                  }
                },
                child: _isLoading ? const CircularProgressIndicator() : const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
