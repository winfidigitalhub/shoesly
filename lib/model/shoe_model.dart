import 'package:cloud_firestore/cloud_firestore.dart';

class Shoe {
  String shoeName;
  String shoeBrand;
  double price;
  double priceBefore;
  List<RatingReview> reviews;
  List<double> ratings;
  List<String> availableSizes;
  String shoeDescription;
  String shoeImage;
  String gender;
  List<String> availableColors;
  List<String> categories;
  DateTime dateAdded;

  Shoe({
    required this.shoeName,
    required this.shoeBrand,
    required this.price,
    required this.priceBefore,
    required this.reviews,
    required this.ratings,
    required this.availableSizes,
    required this.shoeDescription,
    required this.shoeImage,
    required this.gender,
    required this.availableColors,
    required this.categories,
    required this.dateAdded,
  });

  // Named constructor to create an instance from a Map
  Shoe.fromMap(Map<String, dynamic> map)
      : shoeName = map['shoeName'],
        shoeBrand = map['shoeBrand'],
        price = map['price'].toDouble(),
        priceBefore = map['priceBefore'].toDouble(),
        reviews = List<RatingReview>.from((map['reviews'] as List<dynamic>)
            .map((review) => RatingReview.fromMap(review))),
        ratings = List<double>.from(
            map['ratings'].map((rating) => rating.toDouble())),
        availableSizes = List<String>.from(map['availableSizes']),
        shoeDescription = map['shoeDescription'],
        shoeImage = map['shoeImage'],
        gender = map['gender'],
        availableColors = List<String>.from(map['availableColors']),
        categories = List<String>.from(map['categories']),
        dateAdded = (map['dateAdded'] as Timestamp).toDate();
}

class RatingReview {
  String userId;
  double rating;
  String reviews;
  String customerName;
  String profilePicture;
  Timestamp? dateAdded;

  RatingReview({
    required this.userId,
    required this.rating,
    required this.reviews,
    required this.customerName,
    required this.profilePicture,
    required this.dateAdded,
  });

  // Our Named constructor to create an instance from a Map
  RatingReview.fromMap(Map<String, dynamic> map)
      : userId = map['userId'],
        rating = map['rating'].toDouble(),
        reviews = map['reviews'],
        customerName = map['customerName'],
        profilePicture = map['customerName'],
        dateAdded = map['dateAdded'];
}
