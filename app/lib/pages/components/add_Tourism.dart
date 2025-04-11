import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add Tourism Place',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          labelStyle: TextStyle(color: Colors.white),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const AddTourismPlacePage(),
    );
  }
}

class AddTourismPlacePage extends StatefulWidget {
  const AddTourismPlacePage({super.key});

  @override
  State<AddTourismPlacePage> createState() => _AddTourismPlacePageState();
}

class _AddTourismPlacePageState extends State<AddTourismPlacePage> {
  final _formKey = GlobalKey<FormState>();

  String? selectedZone;
  String? selectedTourismType;
  String? selectedBestSeason;

  final List<String> zones = ['Northern', 'Southern', 'Western', 'Eastern'];
  final List<String> tourismTypes = [
    'Nature',
    'Historical',
    'Beach',
    'Wildlife',
    'Other',
  ];
  final List<String> bestSeasons = ['Summer', 'Winter', 'Monsoon', 'Spring'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Tourism Place"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField("Tourism Place Name"),
              _buildTextField("Town"),
              _buildTextField("City"),
              _buildTextField("District"),
              _buildTextField("Time Needed to Visit"),
              _buildTextField("Description of the Place", maxLines: 4),
              const SizedBox(height: 16),
              _buildDropdown(
                label: "Zone",
                value: selectedZone,
                items: zones,
                onChanged: (value) {
                  setState(() {
                    selectedZone = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: "Tourism Type",
                value: selectedTourismType,
                items: tourismTypes,
                onChanged: (value) {
                  setState(() {
                    selectedTourismType = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: "Best Season",
                value: selectedBestSeason,
                items: bestSeasons,
                onChanged: (value) {
                  setState(() {
                    selectedBestSeason = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Handle submit
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Form Submitted')),
                    );
                  }
                },
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        maxLines: maxLines,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: Colors.black87,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        border: const OutlineInputBorder(),
      ),
      items:
          items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
      onChanged: onChanged,
    );
  }
}
