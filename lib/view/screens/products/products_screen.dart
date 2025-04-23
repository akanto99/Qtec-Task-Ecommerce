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
  bool isSearchActive = false;

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
                  isSearchActive
                      ? Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              autofocus: true,
                              decoration: const InputDecoration(
                                hintText: 'Search by category',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                context.read<ProductsBloc>().add(
                                  SearchItem(value),
                                );
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.filter_list),
                            onPressed: () {
                              _showSortBottomSheet(context);
                            },
                          ),
                        ],
                      )
                      : GestureDetector(
                        onTap: () {
                          setState(() {
                            isSearchActive = true;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            enabled: false,
                            decoration: const InputDecoration(
                              hintText: 'Search by category',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                  Expanded(
                    child:
                        state.searchMessage.isNotEmpty
                            ? Center(
                              child: Text(state.searchMessage.toString()),
                            )
                            : ListView.builder(
                              itemCount:
                                  state.searchProductsList.isNotEmpty
                                      ? state.searchProductsList.length
                                      : state.products.length,
                              itemBuilder: (BuildContext context, int index) {
                                final product =
                                    state.searchProductsList.isNotEmpty
                                        ? state.searchProductsList[index]
                                        : state.products[index];
                                return Card(
                                  child: ListTile(
                                    title: Text(product.title ?? 'No Title'),
                                    subtitle: Text(
                                      product.category ?? 'No Category',
                                    ),
                                    trailing: Text(
                                      product.price?.toString() ?? 'No Price',
                                    ),
                                  ),
                                );
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

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.arrow_downward),
              title: const Text("Price High to Low"),
              onTap: () {
                Navigator.pop(context);
                context.read<ProductsBloc>().add(
                  SortProducts(SortType.priceHighToLow),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.arrow_upward),
              title: const Text("Price Low to High"),
              onTap: () {
                Navigator.pop(context);
                context.read<ProductsBloc>().add(
                  SortProducts(SortType.priceLowToHigh),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text("Best Rating"),
              onTap: () {
                Navigator.pop(context);
                context.read<ProductsBloc>().add(
                  SortProducts(SortType.bestRating),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
