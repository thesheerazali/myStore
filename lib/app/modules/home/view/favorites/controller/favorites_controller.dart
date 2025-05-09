import 'package:get/get.dart';
import '../../products/model/product_model.dart';

class FavoritesController extends GetxController {
  final RxList<Product> favoriteProducts = <Product>[].obs;
  final RxList<Product> filteredFavorites = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
   
    filteredFavorites.value = favoriteProducts;
  }

  void searchFavorites(String query) {
    if (query.isEmpty) {
      filteredFavorites.value = favoriteProducts;
    } else {
      filteredFavorites.value = favoriteProducts
          .where((product) =>
              product.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void toggleFavorite(Product product) {
    if (favoriteProducts.any((p) => p.id == product.id)) {
      removeFromFavorites(product);
    } else {
      addToFavorites(product);
    }
  }

  void addToFavorites(Product product) {
    // Check if product already exists in favorites
    if (!favoriteProducts.any((p) => p.id == product.id)) {

      final newProduct = Product(
        id: product.id,
        title: product.title,
        price: product.price,
        description: product.description,
        category: product.category,
        image: product.image,
        rating: product.rating,
        brand: product.brand,
      );
      newProduct.isFavorite = true;

      favoriteProducts.add(newProduct);

      favoriteProducts.refresh();
      filteredFavorites.refresh();
    }
  }

  void removeFromFavorites(Product product) {
    // Remove all instances of the product with the same ID
    favoriteProducts.removeWhere((p) => p.id == product.id);
    filteredFavorites.removeWhere((p) => p.id == product.id);
    favoriteProducts.refresh();
    filteredFavorites.refresh();
  }

  bool isFavorite(Product product) {
    return favoriteProducts.any((p) => p.id == product.id);
  }
}
