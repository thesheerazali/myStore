import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mystore/app/modules/home/view/categories/view/category_card.dart';
import '../controller/categories_controller.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoriesController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Categories',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Search Bar
                  TextField(
                    onChanged: controller.searchCategories,
                    decoration: InputDecoration(
                        hintText: 'Search Categories',
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.black),
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
                            '${controller.filteredCategories.length} results found',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        )),
                  ),
                  const SizedBox(height: 16),
                  // Categories Grid
                  Obx(() {
                    if (controller.isLoading.value &&
                        controller.categories.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1,
                        ),
                        itemCount: controller.filteredCategories.length,
                        itemBuilder: (context, index) {
                          final category = controller.filteredCategories[index];
                          return InkWell(
                            onTap: () =>
                                controller.navigateToCategory(category),
                            child: CategoryCard(category: category),
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
            // Loading overlay
            Obx(() {
              if (controller.isLoading.value &&
                  controller.categories.isNotEmpty) {
                return Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}
