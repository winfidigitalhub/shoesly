import 'package:flutter/material.dart';

class CartBottomSheet extends StatefulWidget {
  const CartBottomSheet({Key? key}) : super(key: key);

  @override
  _CartBottomSheetState createState() => _CartBottomSheetState();
}

class _CartBottomSheetState extends State<CartBottomSheet> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Added to cart', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                Image.asset('assets/images/add.png', scale: 1.5,)
              ],
            ),
          ),

          SizedBox(height: 20,),

          const Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Text(
              'Quantity',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$quantity',
                  style: const TextStyle(fontSize: 16),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (quantity > 1) {
                            quantity--;
                          }
                        });
                      },
                    ),

                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          quantity++;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Image.asset('assets/images/line.png'),
        ],
      ),
    );
  }
}