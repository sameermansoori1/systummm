import 'dart:convert';

import 'package:eshop/product_api/product_controller.dart';
import 'package:eshop/product_api/product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final productProvider =
    StateNotifierProvider<ProductNotifier, List<Products>>((ref) {
  return ProductNotifier();
});

class ProductNotifier extends StateNotifier<List<Products>> {
  ProductNotifier() : super([]) {
    getItems();
  }

  ProductController productController = ProductController();

  Future<void> getItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedData = prefs.getString('product_data');

    if (savedData != null) {
      List<dynamic> decodedData = json.decode(savedData);
      state = decodedData.map((product) => Products.fromJson(product)).toList();
    }

    await productController.getProducts();
    state = productController.productData.value!.products!;

    prefs.setString('product_data',
        json.encode(state.map((product) => product.toJson()).toList()));
  }
}
