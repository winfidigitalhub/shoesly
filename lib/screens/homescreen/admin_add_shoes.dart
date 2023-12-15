import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/firestore_service.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirestoreService _firestoreService = FirestoreService();
  final ImagePicker _imagePicker = ImagePicker();

  final TextEditingController shoeNameController = TextEditingController();
  final TextEditingController shoeBrandController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController priceBeforeController = TextEditingController();
  final TextEditingController shoeDescriptionController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  String selectedSize = '7';
  String selectedColor = 'Black';
  String selectedCategory = 'Running';

  List<String> availableSizes = ['7', '8', '9', '10'];
  List<String> availableColors = ['Black', 'White', 'Red', 'Blue'];
  List<String> categories = ['Running', 'Casual', 'Formal', 'Sports'];

  File? _imageFile;
  bool _isLoading = false;

  Future<String?> _uploadShoeImage(File imageFile, String imageName) async {
    try {
      String storagePath = 'shoe_images/$imageName';
      TaskSnapshot snapshot = await _storage.ref(storagePath).putFile(imageFile).catchError((err) {
        print(err.toString());
      });
      String downloadURL = await snapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  void _addShoe() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (_validateInputs()) {
      setState(() {
        _isLoading = true;
      });

      String? imageURL = await _uploadShoeImage(_imageFile!, shoeNameController.text);
      if (imageURL != null) {
        Map<String, dynamic> shoeData = {
          'shoeName': shoeNameController.text,
          'imageName': shoeNameController.text,
          'shoeBrand': shoeBrandController.text,
          'price': double.parse(priceController.text),
          'priceBefore': double.parse(priceBeforeController.text),
          'shoeDescription': shoeDescriptionController.text,
          'gender': genderController.text,
          'availableSizes': [selectedSize],
          'availableColors': [selectedColor],
          'categories': [selectedCategory],
          'shoeImage': imageURL,
          'ratings': [],
          'reviews': [],
          'dateAdded': DateTime.now(),
        };

        String? shoeId = await _firestoreService.addShoe(shoeData);

        setState(() {
          _isLoading = false;
        });

        if (shoeId != null) {
          // Clear input fields on success
          _clearInputs();

          // Show success snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Shoe added successfully!'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          // Show error snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to add shoe. Please try again.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    }
  }

  bool _validateInputs() {
    if (shoeNameController.text.isEmpty ||
        shoeBrandController.text.isEmpty ||
        priceController.text.isEmpty ||
        priceBeforeController.text.isEmpty ||
        shoeDescriptionController.text.isEmpty ||
        genderController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All fields are required!'),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
    return true;
  }

  void _clearInputs() {
    shoeNameController.clear();
    shoeBrandController.clear();
    priceController.clear();
    priceBeforeController.clear();
    shoeDescriptionController.clear();
    genderController.clear();
    selectedSize = '7';
    selectedColor = 'Black';
    selectedCategory = 'Running';
  }

  Future<void> _pickImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Shoe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Shoe Name:'),
              TextField(controller: shoeNameController),
              const SizedBox(height: 16),
              const Text('Shoe Brand:'),
              TextField(controller: shoeBrandController),
              const SizedBox(height: 16),
              const Text('Price:'),
              TextField(controller: priceController, keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              const Text('Price Before:'),
              TextField(controller: priceBeforeController, keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              const Text('Shoe Description:'),
              TextField(controller: shoeDescriptionController),
              const SizedBox(height: 16),
              const Text('Gender:'),
              TextField(controller: genderController),
              const SizedBox(height: 20),
              const Text('Available Sizes:'),
              DropdownButton<String>(
                value: selectedSize,
                onChanged: (value) {
                  setState(() {
                    selectedSize = value!;
                  });
                },
                items: availableSizes.map((size) {
                  return DropdownMenuItem<String>(
                    value: size,
                    child: Text(size),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text('Available Colors:'),
              DropdownButton<String>(
                value: selectedColor,
                onChanged: (value) {
                  setState(() {
                    selectedColor = value!;
                  });
                },
                items: availableColors.map((color) {
                  return DropdownMenuItem<String>(
                    value: color,
                    child: Text(color),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text('Categories:'),
              DropdownButton<String>(
                value: selectedCategory,
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
                items: categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black
                  ),
                  onPressed: _isLoading ? null : _pickImage,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt_outlined, color: Colors.white,),
                      SizedBox(width: 20,),
                      Text('Pick Shoe Image', style: TextStyle(color: Colors.white),),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_imageFile != null)
                Image.file(
                  _imageFile!,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black
                  ),
                  onPressed: _isLoading ? null : _addShoe,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 20,),
                      Text('Add Shoe to Products'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
