import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart' show CartProvider;

class CartItem extends StatelessWidget {
  final String title;
  final int quantity;
  final double price;
  final String id;
  final String productId;

  CartItem({
    required this.title,
    required this.quantity,
    required this.price,
    required this.id,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      onDismissed: (direction) {
        Provider.of<CartProvider>(context, listen: false).removeItem(productId);
      },
      confirmDismiss: ((direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text("Are you sure?"),
                  content: const Text(
                      "Do you want to remove the item from the cart?"),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("No")),
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text("Yes")),
                  ],
                ));
        // return Future.value(true);
      }),
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: FittedBox(
                  child: Text('\$$price'),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${price * quantity}'),
            trailing: Text('${quantity}x'),
          ),
        ),
      ),
    );
  }
}
