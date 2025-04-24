import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:task_qtec_ecommerce/bloc/products/products_bloc.dart';
import 'package:task_qtec_ecommerce/bloc/products/products_event.dart';
import 'package:task_qtec_ecommerce/bloc/products/products_state.dart';
import 'package:task_qtec_ecommerce/configs/services/database_services/products_database/products_database.dart';
import 'package:task_qtec_ecommerce/configs/services/pagination_services.dart';



import 'dart:developer' as developer;



class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  bool isSearchActive = false;
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  bool isConnected = true;  // Track internet connectivity


  ///InterNet Connectivity
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  ConnectivityResult _currentConnection = ConnectivityResult.none;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
          final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
          _updateConnectionStatus(result);
        });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Future<void> initConnectivity() async {
  //   late List<ConnectivityResult> results;
  //   try {
  //     results = await _connectivity.checkConnectivity();
  //     final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
  //     _updateConnectionStatus(result);
  //
  //     if (result != ConnectivityResult.none) {
  //       context.read<ProductsBloc>().add(ProductsFetch());
  //     } else {
  //       final storedProducts = await ProductDatabase.instance.getAllProducts();
  //       context.read<ProductsBloc>().add(ProductsFetchedFromLocal(storedProducts));
  //     }
  //   } on PlatformException catch (e) {
  //     developer.log("Couldn't check connectivity status", error: e);
  //   }
  // }
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> results;
    try {
      results = await _connectivity.checkConnectivity();
      final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      _updateConnectionStatus(result);

      if (result != ConnectivityResult.none) {
        // Fetch data from the network if online
        context.read<ProductsBloc>().add(ProductsFetch());
        print("A");
      } else {
        // If offline, check if local DB has products
        final storedProducts = await ProductDatabase.instance.getAllProducts();
        if (storedProducts.isEmpty) {
          // If the DB is empty, show appropriate message or fallback
          context.read<ProductsBloc>().add(ProductsFetch());
          print("B");
        } else {
          // If DB has data, fetch and display
          context.read<ProductsBloc>().add(ProductsFetchedFromLocal(storedProducts));
          print("C");
        }
      }
    } on PlatformException catch (e) {
      developer.log("Couldn't check connectivity status", error: e);
    }
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      _currentConnection = result;
      isConnected = result != ConnectivityResult.none;
    });
    print('Current connection: $_currentConnection');
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
              return Center(child: Text(state.message?? "Something went wrong"));

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

                  Text(state.message ?? "Something went wrong"),
                  ///Check Data is Saved in db or not
                  ElevatedButton(
                    onPressed: () async {
                      final stored = await ProductDatabase.instance.getAllProducts();
                      print("Local DB has ${stored.length} products.");
                    },
                    child: Text("Check Local DB"),
                  ),

                  // Display total matching search results
                  if (isSearchActive)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${state.searchProductsList.length} items',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),

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
                                onTap: () {
                                  if (!isConnected) {
                                    // Show a snackbar if no internet connection
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('No internet connection')),
                                    );
                                  } else {
                                    print("internet available");
                                  }
                                },
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
