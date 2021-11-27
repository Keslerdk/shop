import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/auth.dart';
import 'package:shop/provider/cart.dart';
import 'package:shop/provider/order.dart';
import 'package:shop/provider/products_provider.dart';
import 'package:shop/screens/auth_screen.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/screens/edit_product_screen.dart';
import 'package:shop/screens/order_screen.dart';
import 'package:shop/screens/product_detail_screen.dart';
import 'package:shop/screens/products_overview_screen.dart';
import 'package:shop/screens/user_products_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider.value(value: Auth()),
      ChangeNotifierProvider.value(value: ProductsProvider()),
      ChangeNotifierProvider.value(value: Cart()), 
      ChangeNotifierProvider.value(value: Orders())
    ], child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
              .copyWith(secondary: Colors.deepOrange),
          fontFamily: 'Lato'),
      home: const AuthScreen(),
      routes: {
        ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
        CartScreen.routeName: (ctx) => const CartScreen(),
        OrderScreen.routeName: (ctx) =>  const OrderScreen(),
        UserProductsScreen.routeName: (ctx) => const UserProductsScreen(),
        EditProductScreen.routeName: (ctx) => const EditProductScreen()
      },
    ),);
  }
}
