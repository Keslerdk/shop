import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/order.dart';

class OrderTile extends StatelessWidget {
  final OrderItem orderItem;

  const OrderTile({Key? key, required this.orderItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text("\$${orderItem.amount}"),
        subtitle:
            Text(DateFormat("dd.MM.yyyy hh:mm").format(orderItem.dateTime)),
        trailing: IconButton(
          icon: const Icon(
            Icons.expand_more,
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}
