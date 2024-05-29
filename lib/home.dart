
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/globalProvider.dart';
import 'package:shop_app/screens/bags.dart';
import 'package:shop_app/screens/favorites.dart';
import 'package:shop_app/screens/profile.dart';
import 'package:shop_app/screens/shopping.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // ignore: non_constant_identifier_names
  List<Widget> Pages = [const ShopPage(), const Basket(), const Favorites(), const Profile()];

  @override
  Widget build(BuildContext context) {
    return  Consumer<GlobalProvider>(
    builder: (context, provider, child) {
    return Scaffold(
      body: Pages[provider.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: provider.currentIndex,
        onTap: provider.changeCurrentIdx,
        items: 
           [
            BottomNavigationBarItem(icon: Icon(Icons.shop), label:'shop'.tr()),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'basket'.tr()),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'favorites'.tr()),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'profile'.tr())
          ]),
    );});
} 
}