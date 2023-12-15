import 'package:flutter/material.dart';

class ColorSelectionButton extends StatefulWidget {
  final List<String> colorOptions;
  final String? selectedColor;
  final Function(String?) onChanged;

  ColorSelectionButton({
    required this.colorOptions,
    required this.selectedColor,
    required this.onChanged,
  });

  @override
  _ColorSelectionButtonState createState() => _ColorSelectionButtonState();
}

Color _getColor(String color) {
  switch (color.toLowerCase()) {
    case 'black':
      return Colors.black;
    case 'white':
      return Colors.white;
    case 'red':
      return Colors.red;
    case 'blue':
      return Colors.blue;
    default:
      return Colors.transparent;
  }
}

class _ColorSelectionButtonState extends State<ColorSelectionButton> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          children: widget.colorOptions.map((color) {
            bool isSelected = widget.selectedColor == color;

            return Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: OutlinedButton(
                onPressed: () {
                  widget.onChanged(isSelected ? null : color);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  side: BorderSide(
                    width: isSelected ? 2 : 1,
                    color: widget.selectedColor == color
                        ? Colors.black
                        : Colors.grey,
                  ),
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: _getColor(color),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(color),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
