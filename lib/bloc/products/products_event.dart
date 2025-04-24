import 'package:equatable/equatable.dart';
import 'package:task_qtec_ecommerce/model/products/products_model.dart';

abstract class ProductsEvent extends Equatable{
  @override
  List<Object>get props=>[];
}
class ProductsFetch extends ProductsEvent{}

class SearchItem extends ProductsEvent {
  final String stSearch ;
  SearchItem(this.stSearch);

}


class FetchPostWithLazyLoading extends ProductsEvent {}


enum SortType { priceHighToLow, priceLowToHigh, bestRating }

class SortProducts extends ProductsEvent {
  final SortType sortType;

  SortProducts(this.sortType);
}



class ProductsFetchedFromLocal extends ProductsEvent {
  final List<ProductsModel> products;

  ProductsFetchedFromLocal(this.products);
}
