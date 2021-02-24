import 'package:flutter/material.dart';
import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../providers/card.dart';
import '../screens/card_screens.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import 'package:provider/provider.dart';

enum FilterOption {
  Favorite,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showFavoriteONly = false;
  var _isinit = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isinit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndEstProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isinit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('MyPeoduct'),
          actions: [
            PopupMenuButton(
              onSelected: (FilterOption value) {
                setState(() {
                  if (value == FilterOption.Favorite) {
                    _showFavoriteONly = true;
                  } else {
                    _showFavoriteONly = false;
                  }
                });
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text('favorite'),
                  value: FilterOption.Favorite,
                ),
                PopupMenuItem(
                  child: Text('all Product'),
                  value: FilterOption.All,
                )
              ],
            ),
            Consumer<Cart>(
              builder: (_, card, ch) => Badge(
                child: ch,
                value: card.itemCount.toString(),
              ),
              //this child did not rebuilt
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CardScreen.routName);
                },
              ),
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ProductsGrid(_showFavoriteONly));
  }
}
