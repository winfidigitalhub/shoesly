import 'package:flutter/material.dart';
import 'package:shoesly_app/model/shoe_model.dart';
import 'package:shoesly_app/widgets/product_detail_screen_widget/star_widget_builder.dart';
import 'package:shoesly_app/widgets/timestamp_converter.dart';

class TopThreeReviewsWidget extends StatefulWidget {
  final List<RatingReview> reviews;
  final int numberOfReviews;

  const TopThreeReviewsWidget({Key? key, required this.reviews, required this.numberOfReviews}) : super(key: key);

  @override
  State<TopThreeReviewsWidget> createState() => _TopThreeReviewsWidgetState();
}

class _TopThreeReviewsWidgetState extends State<TopThreeReviewsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Review',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 5,),
              Text('(${widget.numberOfReviews.toString()})', style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500
              ),),
            ],
          ),
          const SizedBox(height: 2),
          widget.reviews.isNotEmpty ? Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
            children: widget.reviews
                  .take(3)
                  .map((review) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ReviewItem(review: review,),
                  ))
                  .toList(),
          ),
              )
              : Text(
            'No reviews available.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
class ReviewItem extends StatefulWidget {
  final RatingReview review;

  const ReviewItem({Key? key, required this.review}) : super(key: key);

  @override
  State<ReviewItem> createState() => _ReviewItemState();
}

class _ReviewItemState extends State<ReviewItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 2,
            leading: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: Image.asset('assets/images/nike2.jpeg').image
                  ),
                  borderRadius: BorderRadius.circular(50)
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.review.customerName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            trailing: Text(
              TimestampConverter.customFormatTimestamp(widget.review.dateAdded),
              style: TextStyle(
                fontSize: 12,
                overflow: TextOverflow.visible,
                color: Colors.grey.shade500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 60), // Adjust the left padding to align with ListTile title
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StarRatingWidget(rating: widget.review.rating),
                const SizedBox(height: 10,),
                Text(
                  widget.review.reviews,
                  style: TextStyle(
                    fontSize: 16,
                    overflow: TextOverflow.visible,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

