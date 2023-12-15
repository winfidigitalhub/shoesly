import 'package:flutter/material.dart';
import 'package:shoesly_app/widgets/filterscreen_widgets/custom_thumb_shape.dart';
import '../../widgets/filterscreen_widgets/brand_list.dart';
import '../../utils/range_slider_utils.dart';
import '../../widgets/filterscreen_widgets/color_selection_button.dart';
import '../../widgets/filterscreen_widgets/gender_widgets.dart';
import '../../widgets/page_transition_builder.dart';
import '../../widgets/filterscreen_widgets/sorting_buttons.dart';
import '../homescreen/categories.dart';

class FilterScreen extends StatefulWidget {
  final Function(String?, double?, double?, String?, List<String>?)
      onApplyFilter;

  FilterScreen({required this.onApplyFilter});

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen>
    with TickerProviderStateMixin {
  String? selectedBrand;
  double? minPrice;
  double? maxPrice;
  String? selectedGender;
  List<String> selectedColors = [];
  String? selectedSorting;
  String? selectedColor;
  int selectedFilterCount = 0;

  late AnimationController _slideAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  List<String> sortingOptions = [
    'Most Recent',
    'Lowest Price',
    'Highest Reviews'
  ];
  List<String> colorOptions = ['Black', 'White', 'Red', 'Blue'];
  final priceLabels = ['\$0', '\$300', '\$700', '\$1100', '\$1500', '\$1900'];

  Widget buildLabel({
    required String label,
    required Color color,
  }) => Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
            .copyWith(color: color),);

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

  void showBrandSnackbar() {
    const snackBar = SnackBar(
      content: Text('Please select a brand'),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void updateSelectedFilterCount() {
    int count = 0;
    if (selectedBrand != null) count++;
    if (minPrice != null || maxPrice != null) count++;
    if (selectedGender != null) count++;
    if (selectedColors.isNotEmpty) count++;
    if (selectedSorting != null) count++;
    selectedFilterCount = count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey.shade50,
        surfaceTintColor: Colors.grey.shade50,
        leading: FadeTransition(
          opacity: _fadeAnimation,
          child: InkWell(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
            child: const Icon(Icons.arrow_back),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: const Text(
          'Filter',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
                  child: Text('Brands',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: SizedBox(
                    height: 130,
                    child: BrandList(
                      selectedFilterCount: selectedFilterCount,
                      onBrandSelected: (brand) {
                        setState(() {
                          print(brand);
                          selectedBrand = brand;
                          updateSelectedFilterCount();
                        });
                      },
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: Text('Price Range',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),

                Row(
                  children: [
                    Expanded(
                      child: SliderTheme(
                        data: SliderThemeData(
                          activeTickMarkColor: Colors.transparent,
                          inactiveTickMarkColor: Colors.transparent,
                          thumbColor: Colors.black,
                          activeTrackColor: Colors.black,
                          inactiveTrackColor: Colors.grey.shade300,
                          trackHeight: 2,
                          thumbShape: CustomThumbShape(),
                        ),
                        child: Column(
                          children: [
                            RangeSlider(
                              values: RangeValues(
                                  minPrice ?? 300, maxPrice ?? 1500),
                              onChanged: (values) {
                                setState(() {
                                  minPrice = values.start;
                                  maxPrice = values.end;
                                  updateSelectedFilterCount();
                                });
                              },
                              labels: RangeLabels("\$${minPrice ?? 300}",
                                  "\$${maxPrice ?? 1500}"),
                              divisions: 20,
                              min: 0,
                              max: 2000,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: Utils.modelBuilder(
                                  priceLabels,
                                  (index, label) {
                                    final selectedColor = Colors.black;
                                    final unselectedColor =
                                        Colors.grey.shade500;
                                    final isSelected = (minPrice ?? 0) >=
                                            index * 200 &&
                                        (maxPrice ?? 0) <= (index + 1) * 200;
                                    final color = isSelected
                                        ? selectedColor
                                        : unselectedColor;

                                    return buildLabel(
                                        label: label, color: color);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                const Padding(
                  padding:
                      EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
                  child: Text('Sort By',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
                SortingButton(
                  selectedSorting: selectedSorting,
                  sortingOptions: sortingOptions,
                  onPressed: (value) {
                    setState(() {
                      selectedSorting = value;
                      updateSelectedFilterCount();
                    });
                  },
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: Text('Gender',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  child: Row(
                    children: [
                      GenderButton(
                        gender: 'Man',
                        selectedGender: selectedGender,
                        onPressed: (gender) {
                          setState(() {
                            selectedGender = gender;
                            updateSelectedFilterCount();
                          });
                        },
                      ),
                      GenderButton(
                        gender: 'Woman',
                        selectedGender: selectedGender,
                        onPressed: (gender) {
                          setState(() {
                            selectedGender = gender;
                            updateSelectedFilterCount();
                          });
                        },
                      ),
                      GenderButton(
                        gender: 'Unisex',
                        selectedGender: selectedGender,
                        onPressed: (gender) {
                          setState(() {
                            selectedGender = gender;
                            updateSelectedFilterCount();
                          });
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: Text('Color',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
                ColorSelectionButton(
                  colorOptions: colorOptions,
                  selectedColor: selectedColor,
                  onChanged: (colors) {
                    setState(() {
                      if (colors != null) {
                        selectedColor = colors;
                        selectedColors = [colors];
                      } else {
                        selectedColor = null;
                        selectedColors = [];
                      }
                      updateSelectedFilterCount();
                    });
                  },
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          height: 120,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        selectedColor = null;
                        selectedBrand = null;
                        minPrice = null;
                        maxPrice = null;
                        selectedGender = null;
                        selectedColors = [];
                        selectedSorting = null;
                        selectedFilterCount = 0;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: const BorderSide(
                        width: 2,
                        color: Colors.grey,
                      ),
                      padding: const EdgeInsets.only(right: 40, left: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'RESET',
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 5),
                        Text('(${selectedFilterCount.toString()})'),
                      ],
                    ),
                  ),
                ],
              ),


              ElevatedButton(
                style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.only(right: 50, left: 50),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black),
                onPressed: () {
                  widget.onApplyFilter(selectedBrand, minPrice, maxPrice,
                      selectedGender, selectedColors);
                  if (selectedBrand != null) {
                    Navigator.of(context).push(
                        PageTransition.createPageRoute(CategoryPage(
                          category: 'All',
                          selectedBrand: selectedBrand,
                          minPrice: minPrice,
                          maxPrice: maxPrice,
                          selectedGender: selectedGender,
                          selectedColors: selectedColors,
                          selectedSorting: selectedSorting,
                        )));
                  } else {
                    showBrandSnackbar();
                  }
                },
                child: const Text(
                  'APPLY',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
