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
        emit(state.copyWith(tempSearchProductsList: tempProductsList, searchMessage: 'No data found'));
      } else {
        emit(state.copyWith(tempSearchProductsList: tempProductsList, searchMessage: ''));
      }
    }
  }
}
