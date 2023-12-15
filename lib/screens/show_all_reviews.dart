import 'package:flutter/material.dart';
import '../model/shoe_model.dart';


class AllReviewsPage extends StatefulWidget {
  final List<RatingReview> reviews;
  final double highestRating;

  const AllReviewsPage({
    required this.reviews,
    required this.highestRating,
  });

  @override
  _AllReviewsPageState createState() => _AllReviewsPageState();
}

class _AllReviewsPageState extends State<AllReviewsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Reviews'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '1 Star'),
            Tab(text: '2 Stars'),
            Tab(text: '3 Stars'),
            Tab(text: '4 Stars'),
            Tab(text: '5 Stars'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: List.generate(5, (index) {
          double stars = index + 1.0;
          List<RatingReview> reviewsForStars = widget.reviews
              .where((review) => review.rating <= stars)
              .toList();

          return ListView.builder(
            itemCount: widget.reviews.length,
            itemBuilder: (context, index) {
              final RatingReview review = widget.reviews[index];
              // Check if the review's rating is less than or equal to the current tab's star rating
              if (review.rating <= _tabController.index + 1) {
                return ListTile(
                  title: Text('Rating: ${review.rating}'),
                  subtitle: Text(review.reviews),
                );
              } else {
                // If the review's rating is greater than the current tab's star rating, return an empty container
                return Container();
              }
            },
          );

        }),
      ),
    );
  }
}
