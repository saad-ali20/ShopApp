import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shope/providers/auth.dart';
import 'package:shope/providers/products.dart';
import '../screens/user_products_screen.dart';
import '../screens/order_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<Products>(context, listen: false);
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('hello'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('ٍShope'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('ٍOrders'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('ٍ’Manage Products'),
            onTap: () {
              // pro.fetchAndEstProducts(true).then((_) {

              // });
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('ٍLogOut'),
            onTap: () {
              Provider.of<Auth>(context, listen: false).logout();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
