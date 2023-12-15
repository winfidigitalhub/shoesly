import 'package:flutter/material.dart';

class SortingButton extends StatefulWidget {
  final String? selectedSorting;
  final List<String> sortingOptions;
  final Function(String?) onPressed;

  SortingButton({
    required this.selectedSorting,
    required this.sortingOptions,
    required this.onPressed,
  });

  @override
  _SortingButtonState createState() => _SortingButtonState();
}

class _SortingButtonState extends State<SortingButton> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only( left: 10, right: 10),
        child: Row(
          children: widget.sortingOptions.map((sorting) {
            bool isSelected = widget.selectedSorting == sorting;

            return Padding(
              padding: const EdgeInsets.only( left: 5, right: 5),
              child: OutlinedButton(
                onPressed: () {
                  widget.onPressed(isSelected ? null : sorting);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: widget.selectedSorting == sorting
                      ? Colors.white
                      : Colors.black,
                  backgroundColor:
                  widget.selectedSorting == sorting ? Colors.black : null,
                ),
                child: Text(sorting),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
