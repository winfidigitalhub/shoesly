import 'package:flutter/material.dart';
import '../../screens/filter_screen/filter_screen.dart';

class FilterButton extends StatelessWidget {
  final void Function(
      String? selectedBrand,
      double? minPrice,
      double? maxPrice,
      String? selectedGender,
      List<String>? selectedColors,
      ) onApplyFilter;

  const FilterButton({
    Key? key,
    required this.onApplyFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: FloatingActionButton.extended(
        backgroundColor: Colors.black,
        elevation: 0,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilterScreen(
                onApplyFilter: onApplyFilter,
              ),
            ),
          );
        },
        label: Row(
          children: [
            Image.asset(
              'assets/images/button1.png',
              scale: 2,
            ),
            const SizedBox(width: 15),
            const Text(
              'FILTER',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }
}
