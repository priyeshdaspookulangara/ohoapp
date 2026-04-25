import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_business_directory/features/business/domain/entities/business.dart';
import 'package:local_business_directory/features/business/presentation/providers/business_provider.dart';
import 'package:local_business_directory/features/business/presentation/screens/map_picker_screen.dart';

class EditBusinessScreen extends ConsumerStatefulWidget {
  final Business? business;
  const EditBusinessScreen({super.key, this.business});

  @override
  ConsumerState<EditBusinessScreen> createState() => _EditBusinessScreenState();
}

class _EditBusinessScreenState extends ConsumerState<EditBusinessScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _descriptionController;
  late TextEditingController _addressController;
  LatLng? _selectedLocation;
  File? _heroImage;
  final List<File> _galleryImages = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.business?.name);
    _categoryController = TextEditingController(text: widget.business?.category);
    _descriptionController = TextEditingController(text: widget.business?.description);
    _addressController = TextEditingController(text: widget.business?.address);
    if (widget.business != null) {
      _selectedLocation = LatLng(widget.business!.latitude, widget.business!.longitude);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.business == null ? 'Create Business' : 'Edit Business')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Business Name'),
                validator: (value) => value!.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) => value!.isEmpty ? 'Enter category' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) => value!.isEmpty ? 'Enter address' : null,
              ),
              const SizedBox(height: 16),
              const Text('Hero Image', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final picker = ImagePicker();
                  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) setState(() => _heroImage = File(pickedFile.path));
                },
                child: Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: _heroImage != null
                      ? Image.file(_heroImage!, fit: BoxFit.cover)
                      : (widget.business?.heroImageUrl != null
                          ? Image.network(widget.business!.heroImageUrl!, fit: BoxFit.cover)
                          : const Icon(Icons.add_a_photo, size: 50)),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(_selectedLocation == null
                    ? 'No location selected'
                    : 'Location: ${_selectedLocation!.latitude.toStringAsFixed(4)}, ${_selectedLocation!.longitude.toStringAsFixed(4)}'),
                trailing: const Icon(Icons.map),
                onTap: () async {
                  final result = await Navigator.of(context).push<LatLng>(
                    MaterialPageRoute(builder: (_) => MapPickerScreen(
                      initialPosition: _selectedLocation ?? const LatLng(-1.286389, 36.817223),
                    )),
                  );
                  if (result != null) setState(() => _selectedLocation = result);
                },
              ),
              const SizedBox(height: 16),
              const Text('Working Hours', style: TextStyle(fontWeight: FontWeight.bold)),
              ...['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'].map((day) {
                return Row(
                  children: [
                    Expanded(child: Text(day)),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        decoration: const InputDecoration(hintText: 'e.g. 09:00 - 17:00'),
                        onChanged: (val) {
                          // Update working hours map
                        },
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate() && _selectedLocation != null) {
                          setState(() => _isLoading = true);
                          final business = Business(
                            id: widget.business?.id ?? '',
                            name: _nameController.text,
                            category: _categoryController.text,
                            description: _descriptionController.text,
                            address: _addressController.text,
                            latitude: _selectedLocation!.latitude,
                            longitude: _selectedLocation!.longitude,
                            heroImageUrl: widget.business?.heroImageUrl,
                            galleryUrls: widget.business?.galleryUrls ?? [],
                          );

                          final result = widget.business == null
                              ? await ref.read(businessRepositoryProvider).createBusiness(business)
                              : await ref.read(businessRepositoryProvider).updateBusiness(business);

                          result.fold(
                            (l) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.message))),
                            (r) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Success')));
                              Navigator.of(context).pop();
                            },
                          );
                        } else if (_selectedLocation == null) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a location on the map')));
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
