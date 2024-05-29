import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/login_page.dart';
import 'package:shop_app/models/products.dart';
import 'package:shop_app/provider/globalProvider.dart';

class ProductDetail extends StatelessWidget {
  final ProductModel product;

  const ProductDetail(this.product, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController commentController = TextEditingController();

    return Consumer<GlobalProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Product Detail'),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: Image.network(
                        product.image!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    product.title!,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    product.description!,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Price: \$${product.price}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Rating: ${product.count}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _handleAddToCart(context, provider);
                    },
                    child: Text('Add to Cart'),
                  ),
                ),
                SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Comments:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...product.comments.map((comment) => ListTile(
                      title: Text(comment.user),
                      subtitle: Text(comment.comment),
                    )),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      labelText: 'Add a comment',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _handleAddComment(context, provider, commentController);
                    },
                    child: Text('Submit Comment'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleAddToCart(BuildContext context, GlobalProvider provider) {
    final currentUser = provider.currentUser;
    if (currentUser == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
      );
    } else {
      provider.addCartItem(product, currentUser.email);
      Navigator.pop(context); // Navigate back to the previous screen
    }
  }

  void _handleAddComment(BuildContext context, GlobalProvider provider, TextEditingController commentController) {
    final currentUser = provider.currentUser;
    if (currentUser == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
      );
    } else {
      final comment = CommentModel(user: currentUser.email, comment: commentController.text);
      provider.addComment(product, comment);
      commentController.clear();
    }
  }
}
