import 'package:flutter/material.dart';
import '../models/bread_item.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimens.dart';

/// 商品カードウィジェット
class ProductCard extends StatelessWidget {
  final BreadItem item;
  final VoidCallback? onTap;

  const ProductCard({
    Key? key,
    required this.item,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimens.cardBorderRadius),
          border: Border.all(
            color: AppColors.cardBorder,
            width: 1.0,
          ),
          color: AppColors.surface,
        ),
        padding: const EdgeInsets.all(AppDimens.cardPadding),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.borderRadiusMedium),
            border: Border.all(
              color: AppColors.cardBorder,
              width: 1.0,
            ),
            color: AppColors.cardBackground,
          ),
          margin: const EdgeInsets.all(AppDimens.marginSmall),
          child: Container(
            width: AppDimens.cardWidth,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.paddingSmall,
              vertical: AppDimens.paddingSmall,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 商品画像
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimens.borderRadiusMedium),
                  child: _buildProductImage(),
                ),
                const SizedBox(height: AppDimens.paddingSmall),
                // 商品名
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    item.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppDimens.fontSizeXLarge,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      height: 1.2,
                    ),
                  ),
                ),
                // 在庫数表示
                Text(
                  '残り：${item.count}個',
                  style: TextStyle(
                    fontSize: AppDimens.fontSizeXLarge,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Image.asset(
      item.inStock? item.imagePath : 'assets/images/sold-out.png',
      width: AppDimens.cardImageSize,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        debugPrint('画像の読み込みに失敗しました: ${item.imagePath}');
        return Icon(
          Icons.bakery_dining,
          size: AppDimens.iconSizeLarge,
          color: AppColors.primary,
        );
      },
    );
  }
}
