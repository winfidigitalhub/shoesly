import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shoesly_app/widgets/page_transition_builder.dart';
import '../../../model/shoe_model.dart';
import '../../screens/product_detail_screen.dart';

class ShoeCard extends StatelessWidget {
  final Shoe shoe;
  final double highestRating;

  const ShoeCard({
    Key? key,
    required this.shoe,
    required this.highestRating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      surfaceTintColor: Colors.white,
      shadowColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
              PageTransition.createPageRoute(ProductDetailScreen(shoe: shoe, highestRating: highestRating)),
          );
        },
        child: Wrap(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10.0),
                bottom: Radius.circular(10.0),
              ),
              child: CachedNetworkImage(
                imageUrl: shoe.shoeImage,
                placeholder: (context, url) => const Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 30.0,
                    width: 30.0,
                    child: CircularProgressIndicator(
                      color: Colors.grey,
                      strokeWidth: 3,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                width: double.infinity,
                height: 200,
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shoe.shoeName,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(
                        '$highestRating',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        '(${shoe.reviews.length} Reviews)',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    '\$${shoe.price.toString()}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
