import 'package:eshop/product_api/product_model.dart';
import 'package:http/http.dart' as http;

class ProductRepository {
  Future<ProductModel?> addedProducts() async {
    var request =
        http.Request('GET', Uri.parse('https://dummyjson.com/products'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return dataFromJsonBuy(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
