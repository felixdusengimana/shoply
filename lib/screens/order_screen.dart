import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/orders';

  const OrderScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<OrderProviders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: FutureBuilder(
          future: Provider.of<OrderProviders>(context, listen: false)
              .fetchAndSetOrders(),
          builder: (context, dataSnapshot) => dataSnapshot.connectionState ==
                  ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : dataSnapshot.error != null
                  ? const Center(
                      child: Text('An error occured'),
                    )
                  : Consumer<OrderProviders>(
                      builder: (context, orderData, child) => ListView.builder(
                        itemCount: orderData.orders.length,
                        itemBuilder: (context, index) =>
                            OrderItem(orderData.orders[index]),
                      ),
                    )),
      drawer: const AppDrawer(),
    );
  }
}
