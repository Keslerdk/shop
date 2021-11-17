import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/cart.dart';

class CartTile extends StatelessWidget {
  final double price;
  final int quantity;
  final String title;
  final String id;
  final String productId;

  const CartTile({Key? key,
    required this.price,
    required this.quantity,
    required this.title,
    required this.id, required this.productId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Dismissible(
        key: ValueKey(id),
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: FittedBox(
                  child: Text(
                    "\$$price",
                  )),
            ),
            foregroundColor: Colors.white,
            backgroundColor: Theme
                .of(context)
                .colorScheme
                .primary,
          ),
          title: Text(title),
          subtitle: Text("Total: \$${price * quantity}"),
          trailing: Text("${quantity}x"),
        ),
        background: Container(
          color: Theme
              .of(context)
              .errorColor,
          child: const Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.delete,
                  size: 40,
                  color: Colors.white,
                ),
              )),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          Provider.of<Cart>(context, listen: false).removeItem(productId);
        },
      ),
    );
  }
}
