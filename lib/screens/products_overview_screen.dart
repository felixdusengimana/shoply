import 'package:flutter/material.dart';

import '../widgets/product_grid.dart';

class ProductOverViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shoply"),
      ),
      body: ProductGrid(),
    );
  }
}
