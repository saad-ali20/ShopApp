import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shope/providers/products.dart';
import 'package:shope/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  String id;
  String title;
  String imageeUrl;
  UserProductItem(this.id, this.imageeUrl, this.title);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageeUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Are You Sure'),
                    duration: Duration(seconds: 5),
                    action: SnackBarAction(
                      label: 'yes',
                      onPressed: () {
                        Provider.of<Products>(context, listen: false)
                            .deleteProduct(id);
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
