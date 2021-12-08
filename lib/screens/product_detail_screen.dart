import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  static const routeName = '/product_detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct = Provider.of<ProductsProvider>(context, listen: false)
        .findById(productId);
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          foregroundColor: Colors.black,
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title,),
              background: Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            )),
        SliverList(
            delegate: SliverChildListDelegate([
          const SizedBox(
            height: 10,
          ),
          Text(
            " \$${loadedProduct.price}",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, fontSize: 20),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            loadedProduct.description,
            softWrap: true,
            textAlign: TextAlign.center,
          ),
              SizedBox(height: 800,)
        ]))
      ],
    ));
  }
}
