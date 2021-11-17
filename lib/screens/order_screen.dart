import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/order.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/order_tile.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = "/order_screen";
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context).orders;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Order'),
      ),
      drawer: const AppDrawer(),
      body:
      ListView.builder(
        itemBuilder: (context, index) => OrderTile(
          orderItem: orders[index],
        ),
        itemCount: orders.length,
      ),
    );
  }
}
