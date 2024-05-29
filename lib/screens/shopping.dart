import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/products.dart';
import 'package:shop_app/provider/globalProvider.dart';
import 'package:shop_app/repository/repository.dart';
import 'package:shop_app/widgets/ProductView.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  MyRepository repository = new MyRepository();
  late Future<List<ProductModel>?> _productData;

  @override
  void initState() {
    super.initState();
    // Check if products list is empty before fetching data
    if (Provider.of<GlobalProvider>(context, listen: false).products.isEmpty) {
      _productData = _getProductData();
    } else {
      // Use existing data from the provider
      _productData = Future.value(
          Provider.of<GlobalProvider>(context, listen: false).products);
    }
  }

  Future<List<ProductModel>?> _getProductData() async {
    List<ProductModel> data = await repository.fetchProductData();
    Provider.of<GlobalProvider>(context, listen: false).setProducts(data);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Wrap the SingleChildScrollView with Scaffold
      appBar: AppBar( // Add the AppBar
        title: Text('Shop'), // Set the title of the AppBar
      ),
      body: FutureBuilder(
        future: _productData,
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Бараанууд",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(223, 37, 37, 37),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Wrap(
                      spacing: 20,
                      runSpacing: 10,
                      children: List.generate(
                        snapshot.data!.length,
                        (index) => ProductViewShop(snapshot.data![index]),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }
        }),
      ),
    );
  }
}
