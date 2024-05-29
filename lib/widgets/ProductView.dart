import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/login_page.dart';
import 'package:shop_app/models/products.dart';
import 'package:shop_app/provider/globalProvider.dart';
import 'package:shop_app/screens/product_detail.dart';

class ProductViewShop extends StatelessWidget {
  final ProductModel data;

  const ProductViewShop(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _onTap(context),
      child: Card(
        elevation: 4.0,
        margin: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 150.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(data.image!),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.title!,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            '\$${data.price!}',
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Consumer<GlobalProvider>(
                      builder: (context, provider, _) => IconButton(
                        icon: Icon(
                          data.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: data. isFavorite ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          _handleFavorite(context, provider);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetail(data),
      ),
    );
  }

  void _handleFavorite(BuildContext context, GlobalProvider provider) {
    final currentUser = provider.currentUser;
    if (currentUser == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
      );
    } else {
      provider.setFavorite(data);
    }
  }
}
