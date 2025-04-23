import 'package:equatable/equatable.dart';

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
