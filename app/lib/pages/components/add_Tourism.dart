import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddTourismPlacePage extends StatefulWidget {
  const AddTourismPlacePage({super.key});

  @override
  State<AddTourismPlacePage> createState() => _AddTourismPlacePageState();
}

class _AddTourismPlacePageState extends State<AddTourismPlacePage> {
  final _formKey = GlobalKey<FormState>();

  // TextEditingControllers
  final TextEditingController placeNameController = TextEditingController();
  final TextEditingController townController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController timeNeededController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Dropdown selections
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
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField("Tourism Place Name", placeNameController),
              _buildTextField("Town", townController),
              _buildTextField("City", cityController),
              _buildTextField("District", districtController),
              _buildTextField("Time Needed to Visit", timeNeededController),
              _buildTextField(
                "Description of the Place",
                descriptionController,
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: "Zone",
                value: selectedZone,
                items: zones,
                onChanged: (value) => setState(() => selectedZone = value),
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: "Tourism Type",
                value: selectedTourismType,
                items: tourismTypes,
                onChanged:
                    (value) => setState(() => selectedTourismType = value),
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: "Best Season",
                value: selectedBestSeason,
                items: bestSeasons,
                onChanged:
                    (value) => setState(() => selectedBestSeason = value),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _submitTourismPlace();
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

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select $label';
        }
        return null;
      },
    );
  }

  Future<void> _submitTourismPlace() async {
    if (selectedZone == null ||
        selectedTourismType == null ||
        selectedBestSeason == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select all dropdown fields.')),
      );
      return;
    }

    try {
      final tourismData = {
        "name": placeNameController.text.trim(),
        "town": townController.text.trim(),
        "city": cityController.text.trim(),
        "district": districtController.text.trim(),
        "time_needed_to_visit": timeNeededController.text.trim(),
        "description": descriptionController.text.trim(),
        "zone": selectedZone,
        "tourism_type": selectedTourismType,
        "best_season": selectedBestSeason,
        "verified": false, // for admin to verify
        "created_at": FieldValue.serverTimestamp(),
      };

      // Send to verification collection
      await FirebaseFirestore.instance
          .collection('touristplacesverify')
          .add(tourismData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tourism place submitted for verification!'),
        ),
      );

      // Reset form and state
      _formKey.currentState!.reset();
      _clearControllers();
      setState(() {
        selectedZone = null;
        selectedTourismType = null;
        selectedBestSeason = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  void _clearControllers() {
    placeNameController.clear();
    townController.clear();
    cityController.clear();
    districtController.clear();
    timeNeededController.clear();
    descriptionController.clear();
  }

  @override
  void dispose() {
    placeNameController.dispose();
    townController.dispose();
    cityController.dispose();
    districtController.dispose();
    timeNeededController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
