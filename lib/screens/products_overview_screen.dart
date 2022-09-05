import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/products_provider.dart';
import '../widgets/product_grid.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductOverViewScreen extends StatefulWidget {
  @override
  State<ProductOverViewScreen> createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductOverViewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      // setState(() {
      //   _isLoading = true;
      // });
      Provider.of<ProductsProvider>(context).fetchAndSetProducts().then((_) {
        // setState(() {
        //   _isLoading = false;
        // });
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final ProductsContainer = Provider.of<ProductsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shoply"),
        actions: <Widget>[
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              const PopupMenuItem(
                  value: FilterOptions.Favorites,
                  child: Text("Only Favorites")),
              const PopupMenuItem(
                  value: FilterOptions.All, child: Text("Show All")),
            ],
            onSelected: (FilterOptions selectedValue) {
              if (selectedValue == FilterOptions.Favorites) {
                // ProductsContainer.showFavoriteOnly();
                setState(() {
                  _showOnlyFavorites = true;
                });
              } else {
                setState(() {
                  _showOnlyFavorites = false;
                });
                // ProductsContainer.showAll();
              }
            },
          ),
          Consumer<CartProvider>(
              builder: (_, cartData, ch) => Badge(
                    value: cartData.itemCount.toString(),
                    child: ch as Widget,
                  ),
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/cart');
                  },
                  icon: const Icon(
                    Icons.shopping_cart,
                  ))),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showOnlyFavorites),
      drawer: const AppDrawer(),
    );
  }
}
