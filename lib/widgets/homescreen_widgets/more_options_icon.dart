import 'package:flutter/material.dart';

class MoreOptions extends StatelessWidget {
  final void Function(String) onSelected;

  const MoreOptions({
    Key? key,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'more',
      splashRadius: 50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      surfaceTintColor: Colors.white,
      onSelected: onSelected,
      itemBuilder: (context) => [
        const PopupMenuItem<String>(
          value: 'signOut',
          child: Text(
            'Log Out',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
        child: Icon(Icons.more_vert),
      ),
    );
  }
}