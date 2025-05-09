import 'package:get/get.dart';

import '../modules/splash/view/splash_screen.dart';
import '../modules/home/screens/home_screen.dart';
import '../modules/home/view/products/screens/products_screen.dart';
import '../modules/home/view/categories/screen/categories_screen.dart';
import '../modules/home/view/favorites/view/favorites_screen.dart';
import '../modules/home/view/profile/view/profile_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: AppRoutes.products,
      page: () => const ProductsScreen(),
    ),
    GetPage(
      name: AppRoutes.categories,
      page: () => const CategoriesScreen(),
    ),
    GetPage(
      name: AppRoutes.favorites,
      page: () => const FavoritesScreen(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
    ),
  ];
}
