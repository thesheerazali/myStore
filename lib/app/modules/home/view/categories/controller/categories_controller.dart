import 'package:get/get.dart';
import 'package:mystore/app/routes/api_routes.dart';
import '../../../../../data/network/api_service.dart';
import '../../../../../routes/app_routes.dart';
import '../model/category_model.dart';
import '../../products/model/detailed_product_model.dart';
import '../view/category_details_view.dart';

class CategoriesController extends GetxController {
  final ApiService _apiService = ApiService();
  final RxList<Category> categories = <Category>[].obs;
  final RxList<Category> filteredCategories = <Category>[].obs;
  final RxBool isLoading = true.obs;
  final RxList<DetailedProduct> categoryProducts = <DetailedProduct>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final response = await _apiService.get(ApiRoutes().fetchCategory);

      if (response.data != null) {
        categories.value = (response.data as List<dynamic>)
            .map((item) => Category.fromJson(item))
            .toList();
        filteredCategories.value = categories;
      }
    } catch (e) {
      print('Error fetching categories: $e');
      categories.value = [];
      filteredCategories.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  void searchCategories(String query) {
    if (query.isEmpty) {
      filteredCategories.value = categories;
    } else {
      filteredCategories.value = categories
          .where((category) =>
              category.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  Future<void> navigateToCategory(Category category) async {
    try {
      isLoading.value = true;
      final response = await _apiService.get(category.url);
    

      if (response.data != null) {
        final List<dynamic> productsData = response.data['products'] ?? [];

        print(productsData.first);
        final filteredProducts = productsData
            .map((item) => DetailedProduct.fromJson(item))
            .where((product) =>
                product.category.toLowerCase() == category.name.toLowerCase())
            .toList();

        categoryProducts.value = filteredProducts;

        Get.to(() => CategoryDetailsView(
              category: category,
              products: categoryProducts,
            ));
      }
    } catch (e) {
      print('Error fetching category products: $e');
      Get.snackbar(
        'Error',
        'Failed to load products for ${category.name}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
