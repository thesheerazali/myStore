import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/products_controller.dart';
import '../view/product_card.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  String _formatCategoryName(String category) {
    return category
        .split('-')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductsController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() => Text(
                    controller.currentCategory.isEmpty
                        ? 'Products'
                        : _formatCategoryName(controller.currentCategory.value),
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
              const SizedBox(height: 16),
              // Search Bar
              TextField(
                onChanged: controller.searchProducts,
                decoration: InputDecoration(
                    hintText: 'Search products',
                    prefixIcon: const Icon(Icons.search, color: Colors.black),
                    border: InputBorder.none,
                    filled: true,
                    fillColor:
                        Colors.transparent, // Make background transparent
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    enabled: true,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black)),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black))),
              ),
              const SizedBox(height: 4),
              // Search Results Count
              Align(
                alignment: Alignment.centerLeft,
                child: Obx(() => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        '${controller.filteredProducts.length} results found',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    )),
              ),
              const SizedBox(height: 16),
              // Products List
              Obx(() {
                if (controller.isLoading.value) {
                  return const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (controller.filteredProducts.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        'No products found',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  );
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: controller.filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = controller.filteredProducts[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: ProductCard(
                          product: product,
                          onFavoritePressed: () =>
                              controller.toggleFavorite(product),
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
