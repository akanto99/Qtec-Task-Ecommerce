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
                  child: Text(state.message ?? "Something went wrong"));
            case ProductsStatus.success:
              if (state.products.isEmpty) {
                return const Center(child: Text("No products found"));
              }
              return ListView.builder(
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final item = state.products[index];
                  return ListTile(
                    title: Text(item.title ?? 'No Title'),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
