import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/shoe_model.dart';
import '../../services/firestore_service.dart';
import '../../widgets/homescreen_widgets/shoe_card.dart';
import 'homescreen.dart';

class CategoryPage extends StatefulWidget {
  final String category;
  final String? selectedBrand;
  final double? minPrice;
  final double? maxPrice;
  final String? selectedGender;
  final List<String>? selectedColors;
  final String? selectedSorting;

  const CategoryPage({super.key,
    required this.category,
    this.selectedBrand,
    this.minPrice,
    this.maxPrice,
    this.selectedGender,
    this.selectedColors,
    this.selectedSorting,
  });

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with TickerProviderStateMixin {
  late AnimationController _slideAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _slideAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 5.0).animate(
      CurvedAnimation(
        parent: _fadeAnimationController,
        curve: Curves.fastOutSlowIn,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _slideAnimationController,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _slideAnimationController.forward();
    _fadeAnimationController.forward();
  }

  @override
  void dispose() {
    _slideAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: widget.category == "All"
          ? FirestoreService().getShoeCollections()
          : FirestoreService().getShoeCollectionsByBrand(widget.category),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 50.0,
                width: 50.0,
                child: CircularProgressIndicator(
                  color: Colors.grey,
                  strokeWidth: 5,
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Align(
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.deepPurple[500],
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('We are restocking!, please check back later', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),),
                  )
              )
          );
        }

        List<Map<String, dynamic>> shoeCollections = snapshot.data!;

        // Apply filters if they exist and update UI accordingly
        if (widget.selectedBrand != null) {
          shoeCollections = shoeCollections
              .where((shoe) => shoe['shoeBrand'] == widget.selectedBrand)
              .toList();
        }

        if (widget.minPrice != null) {
          shoeCollections = shoeCollections
              .where((shoe) => shoe['price'] >= widget.minPrice!)
              .toList();
        }

        if (widget.maxPrice != null) {
          shoeCollections = shoeCollections
              .where((shoe) => shoe['price'] <= widget.maxPrice!)
              .toList();
        }

        if (widget.selectedGender != null) {
          shoeCollections = shoeCollections
              .where((shoe) => shoe['gender'] == widget.selectedGender)
              .toList();
        }

        if (widget.selectedColors != null &&
            widget.selectedColors!.isNotEmpty) {
          shoeCollections = shoeCollections
              .where((shoe) =>
                  shoe['availableColors']?.any(
                      (color) => widget.selectedColors!.contains(color)) ??
                  false)
              .toList();
        }

        // Sorting logic based on selectedSorting option and render accordingly
        if (widget.selectedBrand != null && widget.selectedSorting != null) {
          switch (widget.selectedSorting) {
            case 'Highest Reviews':
              shoeCollections.sort((a, b) => (b['ratings']?.length ?? 0)
                  .compareTo(a['ratings']?.length ?? 0));
              break;
            case 'Most Recent':
              shoeCollections.sort((a, b) => (b['dateAdded'] as Timestamp)
                  .millisecondsSinceEpoch
                  .compareTo(
                      (a['dateAdded'] as Timestamp).millisecondsSinceEpoch));
              break;
            case 'Lowest Price':
              shoeCollections.sort(
                  (a, b) => (a['price'] as num).compareTo(b['price'] as num));
              break;
          }
        }
        return Scaffold(
          appBar: widget.selectedBrand != null
              ? AppBar(
                  automaticallyImplyLeading: false,
                  leading: FadeTransition(
                    opacity: _fadeAnimation,
                    child: InkWell(
                      splashFactory: NoSplash.splashFactory,
                      highlightColor: Colors.transparent,
                      child: const Icon(Icons.arrow_back),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                      },
                    ),
                  ),
                  title: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Search Results for',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              '${widget.selectedBrand!} shoes',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : PreferredSize(
              preferredSize: Size.fromHeight(10),
              child: Container()
          ),
          body: Padding(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 0),
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: ListView(
                    children: [
                      GridView.builder(
                        padding: EdgeInsets.only(bottom: 200),
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 5.0,
                          mainAxisSpacing: 120.0,
                        ),
                        itemCount: shoeCollections.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> shoeData = shoeCollections[index];
                          Shoe shoe = Shoe.fromMap(shoeData);
                          double highestRating = shoe.ratings.isNotEmpty ? shoe.ratings.reduce((a, b) => a > b ? a : b) : 0.0;

                          return ShoeCard(shoe: shoe, highestRating: highestRating);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
