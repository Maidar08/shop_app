import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/products.dart';
import 'package:shop_app/provider/globalProvider.dart';
import 'package:shop_app/screens/product_detail.dart';

class Favorites extends StatelessWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GlobalProvider>(context, listen: false);

    // Fetch favorite items when the widget is initialized
    provider.fetchFavoriteItems(provider.currentUser!.email);

    return Consumer<GlobalProvider>(
      builder: (context, provider, child) {
        List<ProductModel> favoriteItems = provider.favoriteItems;

        return Scaffold(
          appBar: AppBar(
            title: Text('Favorites'),
          ),
          body: favoriteItems.isEmpty
              ? Center(
                  child: Text(
                    "No favorite items.",
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                )
              : ListView.builder(
                  itemCount: favoriteItems.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Image.network(
                        favoriteItems[index].image!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(favoriteItems[index].title!),
                      subtitle: Text(
                        '\$${favoriteItems[index].price}',
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          provider.removeFavorite(favoriteItems[index]);
                        },
                      ),
                      onTap: () {
                        // Navigate to product detail page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetail(favoriteItems[index]),
                          ),
                        );
                      },
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Navigate back to the shopping page
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back),
          ),
        );
      },
    );
  }
}
