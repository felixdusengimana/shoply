import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/order_screen.dart';
import '../providers/cart_provider.dart' show CartProvider;
import '../providers/orders_provider.dart';

import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Cart'),
        ),
        body: Column(
          children: <Widget>[
            Card(
              margin: const EdgeInsets.all(15),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 20),
                    ),
                    Chip(
                      label: Text(
                        "\$${cart.totalAmount.toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    if (cart.items.values.toList().isNotEmpty)
                      TextButton(
                        onPressed: () {
                          Provider.of<OrderProviders>(context, listen: false)
                              .addOrder(
                                  cart.items.values.toList(), cart.totalAmount);
                          cart.clearCart();
                          Navigator.of(context)
                              .pushNamed(OrderScreen.routeName);
                        },
                        child: const Text('ORDER NOW'),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (ctx, index) => CartItem(
                    id: cart.items.values.toList()[index].id,
                    title: cart.items.values.toList()[index].title,
                    quantity: cart.items.values.toList()[index].quantity,
                    price: cart.items.values.toList()[index].price,
                    productId: cart.items.keys.toList()[index]),
                itemCount: cart.items.length,
              ),
            ),
          ],
        ));
  }
}
