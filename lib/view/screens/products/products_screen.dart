import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_qtec_ecommerce/bloc/products/products_bloc.dart';
import 'package:task_qtec_ecommerce/bloc/products/products_event.dart';
import 'package:task_qtec_ecommerce/bloc/products/products_state.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductsBloc>().add(ProductsFetch());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("E-commerce")),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          switch (state.status) {
            case ProductsStatus.initial:
              return const Center(child: CircularProgressIndicator());
            case ProductsStatus.failure:
              return Center(
                child: Text(state.message ?? "Something went wrong"),
              );
            case ProductsStatus.success:
              if (state.products.isEmpty) {
                return const Center(child: Text("No products found"));
              }
              return Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                        hintText: 'Search by category',
                        border: OutlineInputBorder()
                    ),
                    onChanged: (value){
                      context.read<ProductsBloc>().add(SearchItem(value));
                    },
                  ),
                  Expanded(
                    child: state.searchMessage.isNotEmpty ?
                    Center(child: Text(state.searchMessage.toString())) :
                    ListView.builder(
                      itemCount: state.searchProductsList.isEmpty ?  state.products.length : state.searchProductsList.length ,
                      itemBuilder: (BuildContext context, int index) {
                        if(state.searchProductsList.isNotEmpty){
                          return Card(
                            child: ListTile(
                              title: Text(state.searchProductsList[index].title.toString()),
                              subtitle: Text(state.searchProductsList[index].category.toString()),
                            ),
                          );
                        }else {
                          return Card(
                            child: ListTile(
                              title: Text(state.products[index].title.toString()),
                              subtitle: Text(state.products[index].category.toString()),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              );
          }
        },
      ),
    );
  }
}
