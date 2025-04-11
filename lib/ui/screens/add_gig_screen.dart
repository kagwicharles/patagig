import 'package:flutter/material.dart';

class AddGigScreen extends StatefulWidget {
  const AddGigScreen({Key? key}) : super(key: key);

  @override
  _AddGigScreenState createState() => _AddGigScreenState();
}

class _AddGigScreenState extends State<AddGigScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form field controllers
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _companyController = TextEditingController();
  final _locationController = TextEditingController();
  final _salaryController = TextEditingController();

  String? _selectedCategory;
  String _tagsInput = "";
  bool _isFeatured = false;

  // Categories list
  final List<String> _categories = [
    'Design',
    'Development',
    'Marketing',
    'Writing',
    'Customer Service',
    'Sales',
    'Admin',
    'Finance',
    'Healthcare',
    'Other'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _companyController.dispose();
    _locationController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  void _submitGig() {
    if (_formKey.currentState!.validate()) {
      // Process form data - in a real app, this would save the data
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gig posted successfully!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post a Gig'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create a New Gig',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Title field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Gig Title',
                  hintText: 'e.g. UI/UX Designer Needed',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.work),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a gig title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Subtitle field
              TextFormField(
                controller: _subtitleController,
                decoration: const InputDecoration(
                  labelText: 'Subtitle',
                  hintText: 'Brief description of the gig',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a subtitle';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Company field
              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(
                  labelText: 'Company Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.business),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a company name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Location field
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  hintText: 'City, State or Remote',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Salary field
              TextFormField(
                controller: _salaryController,
                decoration: const InputDecoration(
                  labelText: 'Salary/Rate',
                  hintText: 'e.g. \$25/hr or \$2000/month',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter salary information';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Category dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                hint: const Text('Select a category'),
                value: _selectedCategory,
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Tags input (simple implementation)
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Tags',
                  hintText: 'Enter tags, separated by commas',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.label),
                ),
                onChanged: (value) {
                  _tagsInput = value;
                },
              ),

              const SizedBox(height: 44),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitGig,
                  child: const Text(
                    'POST GIG',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
