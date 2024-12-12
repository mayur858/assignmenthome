import 'package:assignmenthome/postgres_database.dart'; // Import the PostgreSQL helper
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _paxController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  //menu
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _instructionController = TextEditingController();

  String? _selectedMealType;
  String? _selectedFunctionName;
  String? _selectedTime;

  List<String> _mealTypes = [];
  List<String> _functionNames = [];
  List<String> _times = ['Morning', 'Evening'];

  final postgresHelper = PosgresHelper(); // Instance of PostgresHelper

  @override
  void initState() {
    super.initState();
    _fetchMealTypes(); 
    _fetchFunctionNamesFromPostgres(); 
  }

  Future<void> _fetchMealTypes() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('meal_types').get();

      List<String> mealTypes = [];
      for (var doc in querySnapshot.docs) {
        if (doc.exists && doc.data() != null) {
          final data = doc.data() as Map<String, dynamic>;
          if (data.containsKey('Type') && data['Type'] is List) {
            mealTypes.addAll(List<String>.from(data['Type']));
          }
        }
      }

      setState(() {
        _mealTypes = mealTypes.toSet().toList(); 
      });

      debugPrint("Meal Types Fetched: $_mealTypes");
    } catch (error) {
      debugPrint("Error fetching meal types: $error");
    }
  }

  Future<void> _fetchFunctionNamesFromPostgres() async {
    final functionNames = await postgresHelper.fetchFunctionsNames();
    setState(() {
      _functionNames = functionNames;
    });
    debugPrint("Function Names Fetched: $_functionNames");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFFF9A825),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Customer Name Field
              _buildTextField(
                controller: _customerNameController,
                labelText: 'Customer name',
              ),
              const SizedBox(height: 16),

              // Phone Number Field
              _buildTextField(
                controller: _phoneNumberController,
                labelText: 'Phone number',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // PAX Field
              _buildTextField(
                controller: _paxController,
                labelText: 'PAX',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Address Field
              _buildTextField(
                controller: _addressController,
                labelText: 'Address',
              ),
              const SizedBox(height: 16),

              // Meal Type Dropdown
              _buildDropdownField(
                labelText: 'Select Meal Type',
                items: _mealTypes,
                onChanged: (value) => setState(() => _selectedMealType = value),
              ),
              const SizedBox(height: 16),

              _buildDropdownField(
                labelText: 'Select Function Name',
                items: _functionNames.isNotEmpty
                    ? _functionNames
                    : ['Loading...'], 
                onChanged: (value) =>
                    setState(() => _selectedFunctionName = value),
              ),
              const SizedBox(height: 16),

              // Time Dropdown
              _buildDropdownField(
                labelText: 'Select Time',
                items: const ['Morning', 'Evening'],
                onChanged: (value) => setState(() => _selectedTime = value),
              ),
              const SizedBox(height: 32),

              // Menu Section
              _buildMenuSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: Color(0xFF1565C0)),
        ),
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField({
    required String labelText,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: Color(0xFF1565C0)),
        ),
      ),
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Please select $labelText';
        }
        return null;
      },
    );
  }

  Widget _buildMenuSection() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF00004D),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () {
                  _showAddMenuItemBottomSheet();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddMenuItemBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _instructionController,
              decoration: InputDecoration(
                labelText: 'Instructions',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _phoneNumberController.dispose();
    _paxController.dispose();
    _addressController.dispose();
    _nameController.dispose();
    _instructionController.dispose();
    super.dispose();
  }
}
