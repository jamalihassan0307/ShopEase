import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/ItemModel.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';
import '../controller/auth_controller.dart';

class ShopItemListing extends StatelessWidget {
  final List<ShopItemModel> items;

  const ShopItemListing({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final authController = Get.find<AuthController>();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildItemCard(item, controller, authController, index);
      },
    );
  }

  Widget _buildItemCard(ShopItemModel item, HomeController controller, AuthController authController, int index) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => Get.toNamed('/item-detail', arguments: item),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.deepPurple.shade50,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Image.network(
                        item.image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GetBuilder<HomeController>(
                        builder: (_) => IconButton(
                          icon: Icon(
                            item.isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: item.isFavorite ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            if (!authController.isAuthenticated) {
                              Get.snackbar(
                                'Login Required',
                                'Please login to add items to favorites',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.deepPurple,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 2),
                                mainButton: TextButton(
                                  onPressed: () => Get.toNamed('/login'),
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                              return;
                            }
                            controller.setToFav(item.id);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GetBuilder<HomeController>(
                      builder: (_) => ElevatedButton(
                        onPressed: () {
                          if (!authController.isAuthenticated) {
                            Get.snackbar(
                              'Login Required',
                              'Please login to add items to cart',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.deepPurple,
                              colorText: Colors.white,
                              duration: const Duration(seconds: 2),
                              mainButton: TextButton(
                                onPressed: () => Get.toNamed('/login'),
                                child: const Text(
                                  'Login',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                            return;
                          }
                          controller.addToCart(item.id);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 36),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          controller.isAlreadyInCart(item.id) ? 'In Cart' : 'Add to Cart',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate()
      .fadeIn(delay: (50 * index).ms)
      .slideY(begin: 0.2, end: 0);
  }
} 