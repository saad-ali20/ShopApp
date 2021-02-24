import 'package:flutter/material.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';
import 'product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool isFavo;
  ProductsGrid(this.isFavo);
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final loadedProducts =
        isFavo ? productData.favoriteItems : productData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: loadedProducts.length,
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: loadedProducts[index],
        child: ProductItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
    );
  }
}
