import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_qtec_ecommerce/bloc/products/products_bloc.dart';
import 'package:task_qtec_ecommerce/bloc/products/products_event.dart';
import 'package:task_qtec_ecommerce/bloc/products/products_state.dart';
import 'package:task_qtec_ecommerce/configs/services/pagination_services.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  bool isSearchActive = false;
  int _currentPage = 1;
  final int _itemsPerPage = 10;

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
              return Center(child: Text(state.message ?? "Something went wrong"));
            case ProductsStatus.success:
              final isSearching = isSearchActive && state.searchProductsList.isNotEmpty;
              final allItems = isSearching ? state.searchProductsList : state.products;

              // Pagination calculation
              final totalItems = allItems.length;
              final totalPages = (totalItems / _itemsPerPage).ceil();
              final startIndex = (_currentPage - 1) * _itemsPerPage;
              final endIndex = (_currentPage * _itemsPerPage).clamp(0, totalItems);
              final paginatedItems = isSearching ? allItems : allItems.sublist(startIndex, endIndex);

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
                            context.read<ProductsBloc>().add(SearchItem(value));
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.filter_list),
                        onPressed: () => _showSortBottomSheet(context),
                      ),
                    ],
                  )
                      : GestureDetector(
                    onTap: () {
                      setState(() {
                        isSearchActive = true;
                        _currentPage = 1; // Reset page when search starts
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
                  if (state.searchMessage.isNotEmpty)
                    Expanded(child: Center(child: Text(state.searchMessage))),
                  if (state.searchMessage.isEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: paginatedItems.length + 1, // +1 for footer
                        itemBuilder: (context, index) {
                          if (index < paginatedItems.length) {
                            final product = paginatedItems[index];
                            return Card(
                              child: ListTile(
                                title: Text(product.title ?? 'No Title'),
                                subtitle: Text(product.category ?? 'No Category'),
                                trailing: Text(product.price?.toString() ?? 'No Price'),
                              ),
                            );
                          } else {
                            return !isSearching
                                ? PaginationWidget(
                              currentPage: _currentPage,
                              totalPages: totalPages,
                              onPageChanged: (page) {
                                setState(() {
                                  _currentPage = page;
                                });
                              },
                            )
                                : const SizedBox(); // No pagination if searching
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
                context.read<ProductsBloc>().add(SortProducts(SortType.priceHighToLow));
              },
            ),
            ListTile(
              leading: const Icon(Icons.arrow_upward),
              title: const Text("Price Low to High"),
              onTap: () {
                Navigator.pop(context);
                context.read<ProductsBloc>().add(SortProducts(SortType.priceLowToHigh));
              },
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text("Best Rating"),
              onTap: () {
                Navigator.pop(context);
                context.read<ProductsBloc>().add(SortProducts(SortType.bestRating));
              },
            ),
          ],
        );
      },
    );
  }
}
