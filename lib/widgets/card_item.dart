import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/card.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final int quantity;
  final double price;
  final String title;
  CartItem(this.id, this.productId, this.quantity, this.price, this.title);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (dir) {
        Provider.of<Cart>(
          context,
          listen: false,
        ).removeItem(productId);
      },
      confirmDismiss: (dir) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure'),
            content: Text('you will remove the item from the card'),
            actions: [
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              ),
            ],
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(child: Text('\$$price')),
            ),
            title: Text(title),
            subtitle: Text('\$${(price * quantity)}'),
            trailing: Text('$quantity'),
          ),
        ),
      ),
    );
  }
}
