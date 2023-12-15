import 'package:flutter/material.dart';

class GenderButton extends StatefulWidget {
  final String gender;
  final String? selectedGender;
  final Function(String) onPressed;

  GenderButton({
    required this.gender,
    required this.selectedGender,
    required this.onPressed,
  });

  @override
  _GenderButtonState createState() => _GenderButtonState();
}

class _GenderButtonState extends State<GenderButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only( left: 0, right: 20),
      child: OutlinedButton(
        onPressed: () {
          widget.onPressed(widget.gender);
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: widget.selectedGender == widget.gender
              ? Colors.white
              : Colors.black,
          backgroundColor:
          widget.selectedGender == widget.gender ? Colors.black : null,
        ),
        child: Text(widget.gender),
      ),
    );
  }
}
