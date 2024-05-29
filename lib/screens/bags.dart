import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/products.dart';
import 'package:shop_app/provider/globalProvider.dart';

class Basket extends StatelessWidget {
  const Basket({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalProvider>(
      builder: (context, provider, child) {
        provider.fetchCart(provider.currentUser!.email); // Fetch cart data

        double total = provider.cartItems.fold(
          0, (sum, item) => sum + (item.price! * item.count)
        );

        return Scaffold(
          appBar: AppBar(
            title: Text('Basket'),
          ),
          body: _buildCartBody(provider),
          bottomNavigationBar: _buildBottomNavigationBar(context, total, provider),
        );
      },
    );
  }

  Widget _buildCartBody(GlobalProvider provider) {
    final cartItemsWithQuantity = provider.cartItems.where((item) => item.count > 0).toList();

    return cartItemsWithQuantity.isEmpty
        ? Center(
            child: Text(
              "Basket Is Empty.",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          )
        : ListView.builder(
            itemCount: cartItemsWithQuantity.length,
            itemBuilder: (context, index) {
              return _buildCartItem(provider, index);
            },
          );
  }

  Widget _buildCartItem(GlobalProvider provider, int index) {
    ProductModel item = provider.cartItems[index];

    return Dismissible(
      key: ValueKey<ProductModel>(item),
      background: Container(color: Colors.red),
      onDismissed: (direction) {
        provider.removeCartItem(item, provider.currentUser!.email); // Remove item locally
      },
      child: ListTile(
        contentPadding: const EdgeInsets.all(8.0),
        leading: Image.network(
          item.image!,
          width: 50,
          height: 50,
        ),
        title: Text(item.title!),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        provider.decrementCount(item);
                        provider.removeFromCartFirestore(item, provider.currentUser!.email); // Update item in Firestore
                      },
                    ),
                    Text('${item.count}'),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        provider.incrementCount(item);
                        provider.addToCartFirestore(item, provider.currentUser!.email); // Update item in Firestore
                      },
                    ),
                  ],
                ),
                Text(
                  '\$${item.price} x ${item.count}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context, double total, GlobalProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total: \$${total.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await provider.postCart(); // Post cart and clear cart if successful
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Total price: \$${total.toStringAsFixed(2)}'), // Show snackbar with total price
                ),
              );
            },
            child: Text('Buy'),
          ),
        ],
      ),
    );
  }
}
