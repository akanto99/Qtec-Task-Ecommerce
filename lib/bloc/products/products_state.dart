import 'package:equatable/equatable.dart';
import 'package:task_qtec_ecommerce/model/products/products_model.dart';

enum ProductsStatus { initial, success, failure }

class ProductsState extends Equatable {
  const ProductsState({
    this.status = ProductsStatus.initial,
    this.products = const <ProductsModel>[],
    this.message = '',
    this.searchProductsList = const <ProductsModel>[],
    this.searchMessage = ''
  });

  final ProductsStatus status;
  final List<ProductsModel> products;
  final List<ProductsModel> searchProductsList;

  final String message;
  final String searchMessage;


  ProductsState copyWith({
    ProductsStatus? status,
    List<ProductsModel>? productsList,
    String? message,
    String? searchMessage,
    List<ProductsModel>? tempSearchProductsList
  }) {
    return ProductsState(
      status: status ?? this.status,
      products: productsList?? this.products,
      message: message ?? this.message,
      searchMessage: searchMessage ?? this.searchMessage,
      searchProductsList: tempSearchProductsList ?? this.searchProductsList,
    );
  }

  @override
  String toString() {
    return '''ProductsState { status: $status, hasReachedMax: $message, posts: ${products.length} }''';
  }

  @override
  List<Object> get props => [status, products, message, searchProductsList , searchMessage];
}
