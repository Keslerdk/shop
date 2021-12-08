import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/helper/custom_router.dart';
import 'package:shop/provider/auth.dart';
import 'package:shop/screens/order_screen.dart';
import 'package:shop/screens/user_products_screen.dart';

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
              color: Theme
                  .of(context)
                  .colorScheme
                  .primary,
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
                      onTap: () {
                        // Navigator.of(context)
                        //     .pushReplacementNamed(OrderScreen.routeName)
                        Navigator.of(context).pushReplacement(
                            CustomRouter((ctx) => OrderScreen(), null));
                      },
                    ),
                    ListTile(
                      title: const Text("Manage Products"),
                      leading: const Icon(Icons.edit),
                      onTap: () =>
                          Navigator.of(context)
                              .pushReplacementNamed(
                              UserProductsScreen.routeName),
                    ),
                    ListTile(
                      title: const Text("logout"),
                      leading: const Icon(Icons.logout),
                      onTap: () {
                        Navigator.of(context).pop();
                        Provider.of<Auth>(context, listen: false).logout();
                        Navigator.pushReplacementNamed(context, "/");
                      },
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
