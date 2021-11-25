import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/cart.dart';
import 'package:shop/provider/order.dart';
import 'package:shop/widgets/cart_tile.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cartScreen";

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartContainer = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
      ),
      body: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      "\$${cartContainer.totalAmount}",
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  const _OrderButton()
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartContainer.itemCount,
              itemBuilder: (context, index) => CartTile(
                id: cartContainer.items.values.toList()[index].id,
                title: cartContainer.items.values.toList()[index].title,
                quantity: cartContainer.items.values.toList()[index].quantity,
                price: cartContainer.items.values.toList()[index].price,
                productId: cartContainer.items.keys.toList()[index],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderButton extends StatefulWidget {
  const _OrderButton({Key? key}) : super(key: key);

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<_OrderButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cartContainer = Provider.of<Cart>(context);

    return TextButton(
        onPressed: (cartContainer.totalAmount <= 0 || _isLoading)
            ? null
            : () async {
                setState(() {
                  _isLoading = true;
                });
                await Provider.of<Orders>(context, listen: false).addOrder(
                    cartContainer.items.values.toList(),
                    cartContainer.totalAmount);
                setState(() {
                  _isLoading = false;
                });
                cartContainer.clear();
              },
        child: (_isLoading)
            ? const CircularProgressIndicator()
            : const Text("ORDER NOW"));
  }
}
