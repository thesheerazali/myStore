import 'package:get/get.dart';
import '../../../../../data/network/api_service.dart';
import '../model/product_model.dart';
import '../../favorites/controller/favorites_controller.dart';

class ProductsController extends GetxController {
  final ApiService _apiService = ApiService();
  final RxList<Product> products = <Product>[].obs;
  final RxList<Product> filteredProducts = <Product>[].obs;
  final RxBool isLoading = true.obs;
  final RxString searchQuery = ''.obs;
  final RxString currentCategory = ''.obs;
  late final FavoritesController _favoritesController;

  @override
  void onInit() {
    super.onInit();
    _favoritesController = Get.put(FavoritesController());
    // Check if category was passed in arguments
    final args = Get.arguments;
    if (args != null && args['category'] != null) {
      currentCategory.value = args['category'];
      fetchProductsByCategory(args['category']);
    } else {
      fetchProducts();
    }
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final response = await _apiService.get('/products');
      print("resss: $response");
      if (response.data != null && response.data['products'] != null) {
        final List<dynamic> productsJson = response.data['products'];
        products.value = productsJson.map((json) {
          // Handle null values and provide defaults
          final product = Product(
            id: json['id'] ?? 0,
            title: json['title'] ?? '',
            price: (json['price'] as num?)?.toDouble() ?? 0.0,
            description: json['description'] ?? '',
            category: json['category'] ?? '',
            image: json['thumbnail'] ?? '', // Using thumbnail instead of image
            rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
          );
          // Set initial favorite state
          product.isFavorite = _favoritesController.favoriteProducts
              .any((p) => p.id == product.id);
          return product;
        }).toList();
        filteredProducts.value = products;
      }
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchProductsByCategory(String category) async {
    try {
      isLoading.value = true;
      final response = await _apiService.get('/products/category/$category');
      print('Category response: $response');
      if (response.data != null && response.data['products'] != null) {
        final List<dynamic> productsJson = response.data['products'];
        products.value = productsJson.map((json) {
          final product = Product.fromJson(json);
          // Set initial favorite state
          product.isFavorite = _favoritesController.favoriteProducts
              .any((p) => p.id == product.id);
          return product;
        }).toList();
        filteredProducts.value = products;
      }
    } catch (e) {
      print('Error fetching products by category: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void searchProducts(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredProducts.value = products;
    } else {
      filteredProducts.value = products
          .where((product) =>
              product.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void toggleFavorite(Product product) {
    final index = products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      products[index].isFavorite = !products[index].isFavorite;
      if (products[index].isFavorite) {
        _favoritesController.addToFavorites(products[index]);
      } else {
        _favoritesController.removeFromFavorites(products[index]);
      }
      products.refresh();
      filteredProducts.refresh();
    }
  }
}
