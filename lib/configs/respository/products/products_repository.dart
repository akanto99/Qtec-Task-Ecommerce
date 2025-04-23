import 'dart:async';
import 'dart:io';

import 'package:http/http.dart'  as http;
import 'package:task_qtec_ecommerce/configs/res/app_url.dart';
import 'package:task_qtec_ecommerce/model/products/products_model.dart';
class ProductsRepository {
  Future<List<ProductsModel>> fetchProducts() async {
    try {
      final response = await http
          .get(Uri.parse(AppUrl.productEndPoint))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<ProductsModel> products =
        productsModelFromJson(response.body);
        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } on SocketException {
      throw Exception('No Internet Connection');
    } on TimeoutException {
      throw Exception('Request Timed Out');
    } catch (e) {
      throw Exception('Unexpected Error: $e');
    }
  }
}
