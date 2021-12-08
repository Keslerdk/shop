import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/provider/order.dart';

class OrderTile extends StatefulWidget {
  final OrderItem orderItem;

  const OrderTile({Key? key, required this.orderItem}) : super(key: key);

  @override
  State<OrderTile> createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        height: _expanded
            ? min(widget.orderItem.products.length * 20 + 10, 180) + 80
            : 72,
        child: Column(
          children: [
            ListTile(
              title: Text("\$${widget.orderItem.amount}"),
              subtitle: Text(DateFormat("dd.MM.yyyy hh:mm")
                  .format(widget.orderItem.dateTime)),
              trailing: IconButton(
                icon: const Icon(
                  Icons.expand_more,
                ),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
              AnimatedContainer(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                height: _expanded? min(widget.orderItem.products.length * 20 + 10, 180)+8 : 0,
                duration: const Duration(milliseconds: 500),
                child: ListView(
                  children: [
                    ...widget.orderItem.products.map((prod) => Row(
                          children: [
                            Text(
                              prod.title,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text("${prod.quantity}x / ${prod.price}")
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ))
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
