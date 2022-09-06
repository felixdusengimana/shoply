import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/splash_screen.dart';
import '../screens/cart_screen.dart';
import './screens/order_screen.dart';
import '../screens/edit_product_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/product_details_screen.dart';
import './screens/user_products_screen.dart';
import './screens/auth_screen.dart';

import '../providers/auth_provider.dart';
import './providers/products_provider.dart';
import '../providers/orders_provider.dart';
import './providers/cart_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      builder: (context, _) => MultiProvider(
        providers: [
          ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
            create: (_) => ProductsProvider(
                Provider.of<AuthProvider>(context, listen: false).token,
                Provider.of<AuthProvider>(context, listen: false).userId, []),
            update: (context, auth, previousProducts) => ProductsProvider(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.items,
            ),
          ),
          ChangeNotifierProvider(
            create: (_) => CartProvider(),
          ),
          ChangeNotifierProxyProvider<AuthProvider, OrderProviders>(
            create: (_) => OrderProviders(
                Provider.of<AuthProvider>(context, listen: false).token,
                Provider.of<AuthProvider>(context, listen: false).userId, []),
            update: (context, auth, previousOrders) => OrderProviders(
              auth.token,
              auth.userId,
              previousOrders == null ? [] : previousOrders.orders,
            ),
          ),
        ],
        child: Consumer<AuthProvider>(
          builder: (_, auth, child) => MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: auth.isAuth
                ? ProductOverViewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: ((context, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? const SplashScreen()
                            : const AuthScreen())),
            routes: {
              ProductOverViewScreen.routeName: (context) =>
                  ProductOverViewScreen(),
              ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrderScreen.routeName: (ctx) => const OrderScreen(),
              UserProductScreen.routeName: (ctx) => const UserProductScreen(),
              AddEditProductScreen.routeName: (ctx) =>
                  const AddEditProductScreen(),
            },
          ),
        ),
      ),
    );
  }
}
