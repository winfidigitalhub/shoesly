import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FirestoreService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future<QuerySnapshot> getUsers() async {
    return userCollection.get();
  }

  Stream<DocumentSnapshot> getCurrentUserUserDetails() {
    return userCollection.doc(_auth.currentUser?.uid).snapshots();
  }

  Future<List<Map<String, dynamic>>> getShoeCollections() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('shoes').get();
      List<Map<String, dynamic>> shoeCollections = [];

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        shoeCollections.add(doc.data() as Map<String, dynamic>);
      }

      return shoeCollections;
    } catch (e) {
      print('Error fetching shoe collections: $e');
      return [];
    }
  }

  Future<String?> addShoe(Map<String, dynamic> shoeData) async {
    try {
      DocumentReference shoeRef = await _firestore.collection('shoes').add(shoeData);
      return shoeRef.id;
    } catch (e) {
      print('Error adding shoe to Firestore: $e');
      return null;
    }
  }


  Future<void> addToCart(
      String shoeId, String shoeName, double price, String selectedColor,
      String selectedSize, String shoeImage) async {
    try {
      // Get the current user
      User? user = _auth.currentUser;

      // Check if the user is authenticated
      if (user != null) {
        String userId = user.uid;

        // Create a new document in the "cart" collection
        await _firestore.collection('users').doc(userId).collection('cart').doc(shoeId).set({
          'shoeId': shoeId,
          'shoeName': shoeName,
          'ImageUrl': shoeImage,
          'price': price,
          'selectedColor': selectedColor,
          'selectedSize': selectedSize,
          'timestamp': FieldValue.serverTimestamp(),
        });
      } else {
        // Show an error snackbar or handle the case when the user is not authenticated
      }
    } catch (e) {
      // Handle errors
      print('Error adding to cart: $e');
      // Show an error snackbar or handle the error as needed
    }
  }


  Future<List<Map<String, dynamic>>> getShoeCollectionsByBrand(String brand) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('shoes').where('shoeBrand', isEqualTo: brand).get();
      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error fetching shoe collections: $e');
      return [];
    }
  }
}

