import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../screens/homescreen/admin_add_shoes.dart';

class AdminIcon extends StatefulWidget {
  final Stream<DocumentSnapshot> myStream;

  const AdminIcon({
    Key? key,
    required this.myStream,
  }) : super(key: key);

  @override
  State<AdminIcon> createState() => _AdminIconState();
}

class _AdminIconState extends State<AdminIcon> with TickerProviderStateMixin {
  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;


  @override
  void initState() {
    super.initState();
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
    _fadeAnimationController.forward();
  }


  @override
  void dispose() {
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: widget.myStream,
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Container();
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        return Visibility(
          visible: snapshot.data?['privilege'] == 'admin',
          child: InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AdminScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Icon(Icons.add),
              ),
            ),
          ),
        );
      },
    );
  }
}
