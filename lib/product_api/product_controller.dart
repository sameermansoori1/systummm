import 'package:eshop/product_api/product_model.dart';
import 'package:eshop/product_api/product_repo.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ProductController {
  final ProductRepository productRepository = ProductRepository();
  Rxn<ProductModel> productData = Rxn<ProductModel>();

  RxBool isLoading = false.obs;

  Future<void> getProducts() async {
    isLoading.value = true;
    final response = await productRepository.addedProducts();
    productData.value = response;
    isLoading.value = false;
  }
}
