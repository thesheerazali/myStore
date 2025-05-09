import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mystore/app/res/svgs.dart';
import '../controller/home_controller.dart';
import '../view/products/screens/products_screen.dart';
import '../view/categories/screen/categories_screen.dart';
import '../view/favorites/view/favorites_screen.dart';
import '../view/profile/view/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    final screens = [
      const ProductsScreen(),
      const CategoriesScreen(),
      const FavoritesScreen(),
      const ProfileScreen(),
    ];

    return Obx(
      () => Scaffold(
        body: screens[controller.currentIndex.value],
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          height: 90.h,
          child: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changePage,
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconSize: 24.sp,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            selectedLabelStyle: GoogleFonts.poppins(
              fontSize: 11.sp,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
            unselectedLabelStyle: GoogleFonts.poppins(
              fontSize: 11.sp,
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedIconTheme: IconThemeData(size: 24.sp),
            unselectedIconTheme: IconThemeData(size: 24.sp),
            landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
            items: [
              _buildNavigationBarItem(Svgs.product, 'Products', 0, controller),
              _buildNavigationBarItem(
                  Svgs.category, 'Categories', 1, controller),
              _buildNavigationBarItem(Svgs.fav, 'Favorites', 2, controller),
              _buildNavigationBarItem(Svgs.profile, 'Profile', 3, controller),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavigationBarItem(
      String svgIcon, String label, int index, HomeController controller) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: EdgeInsets.only(bottom: 6.h),
        child: SvgPicture.string(
          svgIcon,
          width: 24.w,
          height: 24.h,
        ),
      ),
      label: label,
    );
  }
}
