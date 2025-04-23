import 'package:flutter/material.dart';
import 'package:task_qtec_ecommerce/configs/utils/routes/routes_name.dart';
import 'package:task_qtec_ecommerce/view/screens/products/products_screen.dart';
import 'package:task_qtec_ecommerce/view/splash_screen/splash_view.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(builder: (BuildContext context) => const SplashScreen());
      case RoutesName.productsScreen:
        return MaterialPageRoute(builder: (BuildContext context) => const ProductsScreen());


      default:
        return _errorRoute();






    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return const Scaffold(
        body: Center(
          child: Text('No route defined'),
        ),
      );
    });
  }
}
