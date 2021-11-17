import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop/screens/order_screen.dart';
import 'package:shop/screens/products_overview_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            Container(
              height: 56,
              child: const Center(
                  child: Text(
                "Hello Friend!",
                style: TextStyle(color: Colors.white, fontSize: 16),
              )),
              color: Theme.of(context).colorScheme.primary,
            ),
            Expanded(
                child: ListView(
              children: [
                ListTile(
                  title: const Text("Shop"),
                  leading: const Icon(Icons.shop),
                  onTap: () => Navigator.pushReplacementNamed(context, "/"),
                ),
                ListTile(
                  title: const Text("Orders"),
                  leading: const Icon(Icons.card_giftcard),
                  onTap: () => Navigator.of(context)
                      .pushReplacementNamed(OrderScreen.routeName),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}