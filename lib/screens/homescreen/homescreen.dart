import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoesly_app/screens/filter_screen/filter_screen.dart';
import 'package:shoesly_app/services/auth_service.dart';
import 'package:shoesly_app/services/firestore_service.dart';
import 'package:shoesly_app/widgets/homescreen_widgets/more_options_icon.dart';
import '../../widgets/homescreen_widgets/admin_addProduct_Icon.dart';
import '../../widgets/homescreen_widgets/homepage_filter_button.dart';
import 'categories.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _tabAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<Offset> _tabSlideAnimation;
  late Animation<double> _fadeAnimation;
  final _auth = AuthService();
  final firestore = FirestoreService();
  late Stream<DocumentSnapshot> myStream;

  late TabController _tabController;
  List<String> categories = [
    'All',
    'Nike',
    'Jordan',
    'Adidas',
    'Reebok',
    'Puma',
    'New Balance'
  ];

  @override
  void initState() {
    super.initState();

    _tabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 5.0).animate(
      CurvedAnimation(
        parent: _fadeAnimationController,
        curve: Curves.fastOutSlowIn,
      ),
    );

    _tabSlideAnimation = Tween<Offset>(
      begin: const Offset(5.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _tabAnimationController,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _tabAnimationController.forward();
    _fadeAnimationController.forward();
    _tabController = TabController(length: categories.length, vsync: this);
    myStream = firestore.getCurrentUserUserDetails();
  }


  @override
  void dispose() {
    _tabController.dispose();
    _tabAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            toolbarHeight: 100,
            leading: Padding(
              padding: EdgeInsets.only(right: 20, left: 20, top: 20),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: const Text(
                  'Discover',
                  style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            actions: [
              InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  setState(() {
                    // Your logic here
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Image.asset('assets/images/cart.png'),
                  ),
                ),
              ),

              // Show Icon if user is admin, else hide Icon
              AdminIcon(myStream: myStream),

              // Show more options Icon
              MoreOptions(
                onSelected: (value) {
                  setState(() {
                    switch (value) {
                      case 'signOut':
                        setState(() {
                          _auth.signOut(context);
                        });
                        break;
                    }
                  });
                },
              ),
            ],
            leadingWidth: MediaQuery.of(context).size.width / 2,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(10),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: SlideTransition(
                    position: _tabSlideAnimation,
                    child: TabBar(
                      splashFactory: NoSplash.splashFactory,
                      dividerColor: Colors.white,
                      indicator: BoxDecoration(),
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      controller: _tabController,
                      isScrollable: true,
                      tabs: categories.map((category) => Tab(
                        child: InkResponse(
                          onTap: () {
                            _tabController.animateTo(categories.indexOf(category));
                          },
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Text(category),
                        ),
                      )).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: categories.map((category) => CategoryPage(category: category)).toList(),
          ),
          floatingActionButton: FilterButton(
            onApplyFilter: (
                String? selectedBrand,
                double? minPrice,
                double? maxPrice,
                String? selectedGender,
                List<String>? selectedColors,
                ) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FilterScreen(
                    onApplyFilter: (selectedBrand, minPrice, maxPrice, selectedGender, selectedColors,) {
                    },
                  ),
                ),
              );
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );

  }
}
