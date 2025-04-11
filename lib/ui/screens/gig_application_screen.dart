import 'package:flutter/material.dart';

class GigApplicationScreen extends StatefulWidget {
  final String gigTitle;

  const GigApplicationScreen({Key? key, required this.gigTitle})
      : super(key: key);

  @override
  _GigApplicationScreenState createState() => _GigApplicationScreenState();
}

class _GigApplicationScreenState extends State<GigApplicationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form field controllers
  final _messageController = TextEditingController();
  final _availabilityController = TextEditingController();
  String? _selectedExperience;

  final List<String> _experienceLevels = [
    'Beginner',
    'Intermediate',
    'Expert',
    'Professional'
  ];

  void _submitInterest() {
    if (_formKey.currentState!.validate()) {
      // Process form data
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Interest submitted successfully!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _availabilityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply Gig'),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gig title
                Text(
                  'Gig: ${widget.gigTitle}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Experience level dropdown
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Experience Level',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.stars),
                  ),
                  hint: const Text('Select your experience level'),
                  value: _selectedExperience,
                  items: _experienceLevels.map((String level) {
                    return DropdownMenuItem<String>(
                      value: level,
                      child: Text(level),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedExperience = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your experience level';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _availabilityController,
                  decoration: const InputDecoration(
                    labelText: 'Your Availability',
                    hintText: 'e.g. Weekdays after 5pm, Weekends',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your availability';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    labelText: 'Why you\'re interested',
                    hintText: 'Briefly describe why you\'re a good fit',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a message';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 44),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitInterest,
                    child: const Text(
                      'APPLY NOW',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Example usage:
// Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) => GigApplicationScreen(gigTitle: 'Freelance UI Designer'),
//   ),
// );
