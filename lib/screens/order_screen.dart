import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';
import '../providers/order.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/Orders_Screen';

  @override
  Widget build(BuildContext context) {
    // final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, data) {
          if (data.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (data.error != null) {
            return Center(
              child: Text('Your Login Expired'),
            );
          } else {
            return Consumer<Orders>(
              builder: (ctx, ordersData, child) => ListView.builder(
                itemCount: ordersData.orders.length,
                itemBuilder: (ctx, i) {
                  return OrderItemWidget(ordersData.orders[i]);
                },
              ),
            );
          }
        },
      ),
    );
  }
}
