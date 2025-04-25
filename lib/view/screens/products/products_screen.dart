import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_qtec_ecommerce/bloc/products/products_bloc.dart';
import 'package:task_qtec_ecommerce/bloc/products/products_event.dart';
import 'package:task_qtec_ecommerce/bloc/products/products_state.dart';
import 'package:task_qtec_ecommerce/configs/res/color.dart';
import 'package:task_qtec_ecommerce/configs/res/text_styles.dart';
import 'package:task_qtec_ecommerce/configs/responsive/responsive_ui.dart';
import 'package:task_qtec_ecommerce/configs/services/database_services/products_database/products_database.dart';
import 'package:task_qtec_ecommerce/configs/services/pagination_services.dart';
import 'package:task_qtec_ecommerce/configs/utils/utils.dart';
import 'package:task_qtec_ecommerce/configs/widgets/loading/loading_wisgets.dart';
import 'package:task_qtec_ecommerce/configs/widgets/nointernet/nointernet_widgets.dart';

import 'dart:developer' as developer;

import 'package:task_qtec_ecommerce/configs/widgets/searchbox/searchbox_widgets.dart';

import '../../../configs/widgets/productcard/productcard_widgets.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  bool isSearchActive = false;
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  bool isConnected = true;

  ///InterNet Connectivity
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  ConnectivityResult _currentConnection = ConnectivityResult.none;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      final result =
          results.isNotEmpty ? results.first : ConnectivityResult.none;
      _updateConnectionStatus(result);
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: ResPonsiveUi(mobile: body(), desktop: body(), tablet: body()),
      ),
    );
  }

  Widget body() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        width: screenWidth * 0.9,
        child: BlocBuilder<ProductsBloc, ProductsState>(
          builder: (context, state) {
            switch (state.status) {
              case ProductsStatus.initial:
                return LoadingScreen();
              case ProductsStatus.failure:
                final isNoInternet =
                    (state.message?.contains('NO_INTERNET') ?? false);
                return isNoInternet
                    ? NointernetWidgets()
                    : Center(
                      child: Text(state.message ?? "Something went wrong"),
                    );

              case ProductsStatus.success:
                final isSearching =
                    isSearchActive && state.searchProductsList.isNotEmpty;
                final allItems =
                    isSearching ? state.searchProductsList : state.products;

                // Pagination calculation
                final totalItems = allItems.length;
                final totalPages = (totalItems / _itemsPerPage).ceil();
                final startIndex = (_currentPage - 1) * _itemsPerPage;
                final endIndex = (_currentPage * _itemsPerPage).clamp(
                  0,
                  totalItems,
                );
                final paginatedItems =
                    isSearching
                        ? allItems
                        : allItems.sublist(startIndex, endIndex);

                return Column(
                  children: [
                    SizedBox(height: screenHeight * 0.02),

                    isSearchActive
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SearchBoxWidget(
                              width: screenWidth * 0.75,
                              autofocus: true,
                              onChanged: (value) {
                                context.read<ProductsBloc>().add(
                                  SearchItem(value),
                                );
                              },
                            ),

                            GestureDetector(
                              onTap: () => _showSortBottomSheet(context),
                              child: Container(
                                height: screenHeight * 0.05,
                                width: screenWidth * 0.12,
                                // color: Colors.black,
                                child: SvgPicture.asset(
                                  'assets/images/icons/sort.svg',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        )
                        : GestureDetector(
                          onTap: () {
                            setState(() {
                              isSearchActive = true;
                              _currentPage = 1;
                            });
                          },
                          child: SearchBoxWidget(
                            width: screenWidth * 0.9,
                            enabled: false,
                          ),
                        ),

                    SizedBox(height: screenHeight * 0.02),

                    /// Display total matching search results
                    if (isSearchActive)
                      Text(
                        '${state.searchProductsList.length} items',
                        style: AppTextStyles.inter12WithColor(
                          color: AppColors.blackColor,
                        ),
                      ),
                    if (isSearchActive) SizedBox(height: screenHeight * 0.02),

                    if (state.searchMessage.isNotEmpty)
                      Expanded(child: Center(child: Text(state.searchMessage))),
                    if (state.searchMessage.isEmpty)
                      Expanded(
                        child: ListView(
                          children: [
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 0.75,
                                  ),
                              itemCount: paginatedItems.length,
                              itemBuilder: (context, index) {
                                final product = paginatedItems[index];
                                return GestureDetector(
                                  onTap: () {
                                    if (!isConnected) {
                                      Utils.flushBarErrorMessage(
                                        "No Internet Connection",
                                        context,
                                      );
                                    } else {
                                      print("internet available");
                                    }
                                  },
                                  child: ProductCardWidgets(
                                    imageUrl: product.image ?? '',
                                    categoryText: product.category ?? '',
                                    price: '\$${product.price ?? '00.00'}',
                                    discountPrice:
                                        '\$${(product.discountPrice ?? 0).toStringAsFixed(2)}',
                                    offPricePercent:
                                        '${product.offPrice ?? '0'}% OFF',
                                    rating: '${product.rating?.rate ?? '0'}',
                                    ratingCount:
                                        '(${product.rating?.count ?? '0'})',
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            if (!isSearching)
                              PaginationWidget(
                                currentPage: _currentPage,
                                totalPages: totalPages,
                                onPageChanged: (page) {
                                  setState(() {
                                    _currentPage = page;
                                  });
                                },
                              ),
                            SizedBox(height: screenHeight * 0.02),
                          ],
                        ),
                      ),
                  ],
                );
            }
          },
        ),
      ),
    );
  }

  ///ShowModal Bottom Sheet
  void _showSortBottomSheet(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          width: screenWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            // borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: screenHeight * 0.02),
              Container(
                width: screenWidth * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Sort By",
                      style: AppTextStyles.inter16WithColor(
                        color: AppColors.blackColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: screenHeight * 0.03,
                        width: screenWidth * 0.05,
                        color: Colors.transparent,
                        child: SvgPicture.asset(
                          'assets/images/icons/x.svg',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  context.read<ProductsBloc>().add(
                    SortProducts(SortType.priceHighToLow),
                  );
                },
                child: Container(
                  height: screenHeight * 0.06,
                  width: screenWidth * 0.9,
                  child: Text(
                    "Price - High to Low",
                    style: AppTextStyles.inter14WithColor(
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  context.read<ProductsBloc>().add(
                    SortProducts(SortType.priceLowToHigh),
                  );
                },
                child: Container(
                  height: screenHeight * 0.06,
                  width: screenWidth * 0.9,
                  child: Text(
                    "Price - Low to High",
                    style: AppTextStyles.inter14WithColor(
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  context.read<ProductsBloc>().add(
                    SortProducts(SortType.bestRating),
                  );
                },
                child: Container(
                  height: screenHeight * 0.06,
                  width: screenWidth * 0.9,
                  child: Text(
                    "Ratting",
                    style: AppTextStyles.inter14WithColor(
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ///Network Connectivity Check and Condition Wise Data Fetching
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> results;
    try {
      results = await _connectivity.checkConnectivity();
      final result =
          results.isNotEmpty ? results.first : ConnectivityResult.none;
      _updateConnectionStatus(result);

      if (result != ConnectivityResult.none) {
        ///Data is Online
        context.read<ProductsBloc>().add(ProductsFetch());
        print("A");
      } else {
        /// offline, check if local DB has products
        final storedProducts = await ProductDatabase.instance.getAllProducts();
        if (storedProducts.isEmpty) {
          /// If the DB is empty,
          context.read<ProductsBloc>().add(ProductsFetch());
          print("B");
        } else {
          /// If DB has data, fetch and display
          context.read<ProductsBloc>().add(
            ProductsFetchedFromLocal(storedProducts),
          );
          print("C");
        }
      }
    } on PlatformException catch (e) {
      developer.log("Couldn't check connectivity status", error: e);
    }
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    bool wasOffline = !isConnected;
    isConnected = result != ConnectivityResult.none;

    if (mounted) {
      setState(() {
        _currentConnection = result;
      });
    }
    if (wasOffline && isConnected) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProductsScreen()),
      );
      debugPrint("Auto-refetching Products due to reconnection.");
    }
  }
}
