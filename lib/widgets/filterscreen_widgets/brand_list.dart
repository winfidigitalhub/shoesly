import 'package:flutter/material.dart';
import '../../model/shoe_model.dart';
import '../../services/firestore_service.dart';

class BrandList extends StatefulWidget {
  final Function(String?) onBrandSelected;
  final int? selectedFilterCount;

  BrandList({required this.onBrandSelected, this.selectedFilterCount});

  @override
  _BrandListState createState() => _BrandListState();
}

class _BrandListState extends State<BrandList> {
  String? selectedBrand;

  final List<Map<String, dynamic>> brandsData = [
    {'name': 'Nike', 'image': 'assets/images/nikeLogo.png'},
    {'name': 'Puma', 'image': 'assets/images/pumaLogo.png'},
    {'name': 'Adidas', 'image': 'assets/images/adidasLogo.png'},
    {'name': 'Reebok', 'image': 'assets/images/reebokLogo.png'},
    {'name': 'Jordan', 'image': 'assets/images/nikeLogo.png'},
    {'name': 'New Balance', 'image': 'assets/images/nikeLogo.png'},
  ];

  Map<String, int> brandItemCountMap = {
    'Nike': 0,
    'Puma': 0,
    'Adidas': 0,
    'Reebok': 0,
    'Jordan': 0,
    'New Balance': 0,
  };


  @override
  void initState() {
    super.initState();
    updateBrandItemCountMap();
  }



  void updateBrandItemCountMap() async {
    final List<Map<String, dynamic>> allShoes = await FirestoreService().getShoeCollections();
    setState(() {
      brandItemCountMap = Map.fromIterable(
        brandsData,
        key: (brand) => brand['name'],
        value: (brand) {
          final brandName = brand['name'];
          if (brandName != null) {
            return allShoes.where((shoe) => shoe['shoeBrand'] == brand['name']).length;
          } else {
            return 0; // or handle the case when brandName is null
          }
        },
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade50,
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: brandsData.length,
              itemBuilder: (context, index) {
                final brand = brandsData[index];
                final brandName = brand['name'];
                final itemCount = brandItemCountMap[brandName] ?? 0;
                return Padding(
                  padding: const EdgeInsets.only(right: 20, left: 10),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedBrand == brandName) {
                          selectedBrand = null;
                        } else {
                          selectedBrand = brandName;
                        }
                        widget.onBrandSelected(selectedBrand);
                      });
                    },
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Image.asset(
                              brand['image'],
                              height: 50,
                              width: 50,
                            ),
                            if (selectedBrand == brandName && widget.selectedFilterCount != 0)
                              const Icon(
                                Icons.check_circle,
                                color: Colors.black,
                                size: 20,
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          selectedBrand == brandName
                              ? brandName.toUpperCase()
                              : brandName,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: selectedBrand == brandName ? FontWeight.w700 : FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$itemCount Items',
                          style: TextStyle(fontSize: 12, color: Colors.grey, letterSpacing: 0),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}
