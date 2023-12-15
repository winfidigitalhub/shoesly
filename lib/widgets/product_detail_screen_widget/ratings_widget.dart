import 'package:flutter/material.dart';
import 'package:shoesly_app/widgets/product_detail_screen_widget/star_widget_builder.dart';

class RatingWidget extends StatelessWidget {
  final double rating;
  final int numberOfReviews;

  const RatingWidget({
    Key? key,
    required this.rating,
    required this.numberOfReviews,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StarRatingWidget(rating: rating),
        SizedBox(width: 4),
        Text(
          rating.toString(),
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(width: 4),
        Text(
          '(${numberOfReviews} Reviews)',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }


}
