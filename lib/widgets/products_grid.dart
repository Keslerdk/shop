import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/products_provider.dart';
import 'package:shop/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool isFav;

  const ProductsGrid({Key? key, required this.isFav}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsDate = Provider.of<ProductsProvider>(context);
    final products = (isFav)? productsDate.favouriteItems : productsDate.items;
    return GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemCount: products.length,
        itemBuilder: (context, index) => ChangeNotifierProvider.value(
              value: products[index],
              child: const ProductItem(),
            ));
  }
}
