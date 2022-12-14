import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders_provider.dart';

class OrderItem extends StatefulWidget {
  final Order order;
  OrderItem(this.order);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      // height: _expanded ? 300 : 95,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("\$${widget.order.amount.toStringAsFixed(2)}"),
              subtitle: Text(
                  DateFormat('dd MM yyyy hh:mm').format(widget.order.dateTime)),
              trailing: IconButton(
                icon: _expanded
                    ? const Icon(Icons.expand_less)
                    : const Icon(Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            if (_expanded)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                height: min(widget.order.products.length * 20.0 + 100, 180),
                child: ListView(
                  children: widget.order.products
                      .map((product) => Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    product.title,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${product.quantity}x \$${product.price}",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const Divider(),
                            ],
                          ))
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
