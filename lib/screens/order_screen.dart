import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/order.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/order_tile.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = "/order_screen";

  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {

  late Future _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false)
        .fetchAndSetOrders();
  }


  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Order'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(future: _ordersFuture,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasError) {
              return const Center(child: Text("Something gone wrong."),);
            } else {
              return Consumer<Orders>(
                builder: (BuildContext context, orderData, Widget? child) =>
                    ListView.builder(
                      itemBuilder: (context, index) =>
                          OrderTile(
                            orderItem: orderData.orders[index],
                          ),
                      itemCount: orderData.orders.length,
                    ),
              );
            }
          }
        },),
    );
  }
}
