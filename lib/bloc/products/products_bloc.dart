import 'package:bloc/bloc.dart';
import 'package:task_qtec_ecommerce/bloc/products/products_event.dart';
import 'package:task_qtec_ecommerce/bloc/products/products_state.dart';
import 'package:task_qtec_ecommerce/configs/respository/products/products_repository.dart';
import 'package:task_qtec_ecommerce/model/products/products_model.dart';


class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsRepository postRepository = ProductsRepository();
  List<ProductsModel> tempProductsList = [];

  ProductsBloc() : super(const ProductsState()) {
    on<ProductsFetch>(fetchProductstApi);
    on<SearchItem>(_searchItem);
    on<SortProducts>(_onSortProducts);

///Fetch api then Stored in DB then return from DB
    on<ProductsFetchedFromLocal>(_onProductsFetchedFromLocal);
  }

  Future<void> fetchProductstApi(ProductsFetch event, Emitter<ProductsState> emit) async {
    await postRepository.fetchProducts().then((value) {
      emit(state.copyWith(status: ProductsStatus.success, productsList: value, message: 'success'));
    }).onError((error, stackTrace) {
      emit(state.copyWith(status: ProductsStatus.failure, message: error.toString()));
    });
  }

  void _searchItem(SearchItem event, Emitter<ProductsState> emit) {
    if (event.stSearch.isEmpty) {
      emit(state.copyWith(tempSearchProductsList: [], searchMessage: ''));
    } else {
      tempProductsList = state.products.where((element) => element.category.toString().toLowerCase().toString().contains(event.stSearch.toString().toLowerCase())).toList();
      // tempPostList = state.posts.where((map)=>map.userId.toString() == event.stSearch).toList();
      if (tempProductsList.isEmpty) {
        emit(state.copyWith(tempSearchProductsList: tempProductsList, searchMessage: 'No items found'));
      } else {
        emit(state.copyWith(tempSearchProductsList: tempProductsList, searchMessage: ''));
      }
    }
  }


  void _onSortProducts(SortProducts event, Emitter<ProductsState> emit) {
    final currentList = state.searchProductsList.isNotEmpty
        ? state.searchProductsList
        : state.products;

    final sortedList = List<ProductsModel>.from(currentList);

    switch (event.sortType) {
      case SortType.priceHighToLow:
        sortedList.sort((a, b) => b.price!.compareTo(a.price!));
        break;
      case SortType.priceLowToHigh:
        sortedList.sort((a, b) => a.price!.compareTo(b.price!));
        break;
      case SortType.bestRating:
        sortedList.sort((a, b) => b.rating!.rate!.compareTo(a.rating!.rate!));
        break;
    }

    emit(state.copyWith(tempSearchProductsList: sortedList));
  }


  void _onProductsFetchedFromLocal(ProductsFetchedFromLocal event, Emitter<ProductsState> emit) {
    emit(state.copyWith(status: ProductsStatus.success, productsList: event.products, message: 'Loaded from local DB'));
  }
}
