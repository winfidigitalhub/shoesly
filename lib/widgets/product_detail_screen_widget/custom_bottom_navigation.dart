import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final double price;
  final VoidCallback onAddToCartPressed;

  const CustomBottomNavigationBar({
    Key? key,
    required this.price,
    required this.onAddToCartPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 200,
            child: ListTile(
              title: const Text(
                'Price',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              subtitle: Text(
                '\$$price',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          ElevatedButton(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.only(right: 30, left: 30, top: 15, bottom: 15),
              foregroundColor: Colors.white,
              backgroundColor: Colors.black,
            ),
            onPressed: onAddToCartPressed,
            child: const Text(
              'ADD TO CART',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
