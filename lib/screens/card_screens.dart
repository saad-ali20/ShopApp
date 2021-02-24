import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order.dart';
import '../widgets/card_item.dart';
import '../providers/card.dart';

class CardScreen extends StatelessWidget {
  static const routName = '/card_Screen';
  @override
  Widget build(BuildContext context) {
    final card = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('your Card'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Expanded(
                    child: Chip(
                      label: Text(
                        '\$${card.totalAmount}',
                        style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .headline6
                                .color),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  OdrerButton(card: card),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: card.item.length,
              itemBuilder: (ctx, i) {
                return CartItem(
                  // we use this complex syntax becouse our item is a Map
                  // have a key and value
                  card.item.values.toList()[i].id,
                  card.item.keys.toList()[i],
                  card.item.values.toList()[i].quantity,
                  card.item.values.toList()[i].price,
                  card.item.values.toList()[i].title,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OdrerButton extends StatefulWidget {
  const OdrerButton({
    Key key,
    @required this.card,
  }) : super(key: key);

  final Cart card;

  @override
  _OdrerButtonState createState() => _OdrerButtonState();
}

class _OdrerButtonState extends State<OdrerButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              'Place Order',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            ),
      onPressed: (widget.card.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.card.item.values.toList(),
                widget.card.totalAmount,
              );
              setState(() {
                _isLoading = false;
              });
              widget.card.clear();
            },
    );
  }
}
