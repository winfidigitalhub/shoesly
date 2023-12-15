import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shoesly_app/screens/show_all_reviews.dart';
import '../model/shoe_model.dart';
import '../widgets/cart_bottom_sheet.dart';
import '../widgets/custom_top_snackbar.dart';
import '../widgets/product_detail_screen_widget/custom_bottom_navigation.dart';
import '../widgets/product_detail_screen_widget/product_color_selection.dart';
import '../widgets/product_detail_screen_widget/product_description_widget.dart';
import '../widgets/product_detail_screen_widget/product_reviews_widget.dart';
import '../widgets/product_detail_screen_widget/product_size_selector.dart';
import '../widgets/product_detail_screen_widget/ratings_widget.dart';

class ProductDetailScreen extends StatefulWidget {
  final Shoe shoe;
  final double highestRating;

  const ProductDetailScreen(
      {Key? key, required this.shoe, required this.highestRating})
      : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String? selectedColor;
  String? selectedSize;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: Image.asset(
              'assets/images/bag.png',
              scale: 2,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Display shoe image
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: CachedNetworkImage(
                      imageUrl: widget.shoe.shoeImage,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(
                          color: Colors.grey,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      width: double.infinity,
                      height: 350,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(children: [

                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:
                              widget.shoe.availableColors.map((colorName) {
                            // Color? color = _getColorFromName(colorName);
                            // bool isWhite = color == Colors.white;
                            return Container(
                              width: 15,
                              height: 15,
                              margin: EdgeInsets.only(right: 4),
                              decoration: BoxDecoration(
                                // color: color,
                                shape: BoxShape.circle,
                                // border: isWhite
                                //     ? Border.all(color: Colors.grey, width: 1.0)
                                //     : null,
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      ColorSelectionWidget(
                        availableColors: widget.shoe.availableColors,
                        onColorSelected: (selectedColor) {
                          setState(() {
                            this.selectedColor = selectedColor;
                          });
                        },
                      ),
                    ]),
                  )
                ],
              ),
              const SizedBox(height: 20),

              // Display shoe details
              Text(
                widget.shoe.shoeName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 5),

              RatingWidget(
                rating: widget.highestRating,
                numberOfReviews: widget.shoe.reviews.length,
              ),

              SizedBox(height: 8),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 8),
                    child: Text(
                      'Size',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                    ),
                  ),
                  SizeSelector(
                      availableSizes: widget.shoe.availableSizes,
                    onSizeSelected: (selectedSize) {
                      setState(() {
                        this.selectedSize = selectedSize;
                        print(this.selectedSize);
                      });
                    },
                  ),
                ],
              ),

              ShoeDescriptionWidget(description: widget.shoe.shoeDescription),

              TopThreeReviewsWidget(
                  reviews: widget.shoe.reviews,
                  numberOfReviews: widget.shoe.reviews.length),

              const SizedBox(height: 10),

              Visibility(
                visible: widget.shoe.reviews.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.only(
                          right: 30, left: 30, top: 15, bottom: 15),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllReviewsPage(
                            reviews: widget.shoe.reviews,
                            highestRating: widget.highestRating,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'See All Reviews',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
              // Add more details as needed
            ],
          ),
        ),
      ),

      bottomNavigationBar: Builder(
        builder: (context) => CustomBottomNavigationBar(
          price: widget.shoe.price,
          onAddToCartPressed: () async {
            final selectedQuantity = await showBottomSheet<int>(
              context: context,
              builder: (context) => CartBottomSheet(),
              enableDrag: true,
            );
            if (selectedQuantity != null) {
              CustomTopSnackBar.show(
                context,
                '${widget.shoe.shoeName} has been added to cart',
              );
            }
          },
        ),
      ),

      // bottomNavigationBar: CustomBottomNavigationBar(
      //   price: widget.shoe.price,
      //   onAddToCartPressed: () async {
      //     final selectedQuantity = await showModalBottomSheet<int>(
      //       context: context,
      //       builder: (context) => CartBottomSheet(),
      //     );
      //     if (selectedQuantity != null) {
      //       CustomTopSnackBar.show(
      //         context,
      //         '${widget.shoe.shoeName} has been added to cart. Quantity: $selectedQuantity',
      //       );
      //     }
      //     // _firestore.addToCart(
      //     //     widget.shoe.dateAdded.toString(),
      //     //     widget.shoe.shoeName,
      //     //     widget.shoe.price,
      //     //     selectedColor ?? '',
      //     //     selectedSize ?? '',
      //     //     widget.shoe.shoeImage,
      //     // );
      //     CustomTopSnackBar.show(context, '${widget.shoe.shoeName}has been added to cart');
      //   },
      // ),
    );
  }
}
