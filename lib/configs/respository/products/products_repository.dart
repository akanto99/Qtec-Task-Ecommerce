import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:http/http.dart'  as http;
import 'package:task_qtec_ecommerce/configs/res/app_url.dart';
import 'package:task_qtec_ecommerce/configs/services/database_services/products_database/products_database.dart';
import 'package:task_qtec_ecommerce/model/products/products_model.dart';
class ProductsRepository {
  ///Fetch data only from API
  // Future<List<ProductsModel>> fetchProducts() async {
  //   try {
  //     final response = await http
  //         .get(Uri.parse(AppUrl.productEndPoint))
  //         .timeout(const Duration(seconds: 30));
  //
  //     if (response.statusCode == 200) {
  //       final List<ProductsModel> products =
  //       productsModelFromJson(response.body);
  //       return products;
  //     } else {
  //       throw Exception('Failed to load products');
  //     }
  //   } on SocketException {
  //     throw Exception('No Internet Connection');
  //   } on TimeoutException {
  //     throw Exception('Request Timed Out');
  //   } catch (e) {
  //     throw Exception('Unexpected Error: $e');
  //   }
  // }



  Future<List<ProductsModel>> fetchProducts() async {
    try {
      final response = await http
          .get(Uri.parse(AppUrl.productEndPoint))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<ProductsModel> fetchedProducts =
        productsModelFromJson(response.body);

        for (var product in fetchedProducts) {
          product.offPrice = getRandomOffPrice();
          product.discountPrice = applyDiscount(product.price ?? 0.0);
        }
        ///Sync to local DB
        await ProductDatabase.instance.syncProducts(fetchedProducts);

        /// Return the list
        return fetchedProducts;
      } else {
        throw Exception('Failed to load products');
      }
    } on SocketException {
      throw Exception('NO_INTERNET');
    } on TimeoutException {
      throw Exception('Request Timed Out');
    } catch (e) {
      throw Exception('Unexpected Error: $e');
    }
  }

  ///Random offprice
  List<ProductsModel> products = [];
  final List<int> offPrices = [10, 15, 20, 25];
  final Random random = Random();
  int getRandomOffPrice() {
    return offPrices[random.nextInt(offPrices.length)];
  }

  ///Discount Dollar
  double applyDiscount(double price) {
    final discount = 5 + random.nextInt(6);
    return price - discount;
  }

}
