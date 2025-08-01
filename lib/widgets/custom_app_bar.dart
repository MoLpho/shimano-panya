import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimens.dart';

/// カスタムアプリバーウィジェット
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String lastUpdated;
  final VoidCallback onRefresh;

  const CustomAppBar({
    Key? key,
    required this.lastUpdated,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: AppDimens.appBarHeight,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppDimens.paddingMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                color: AppColors.primary,
                size: AppDimens.appBarIconSize,
              ),
              const SizedBox(width: AppDimens.paddingMedium),
              Text(
                'いまのパン',
                style: TextStyle(
                  fontSize: AppDimens.appBarTitleSize,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.paddingMedium),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.paddingLarge,
              vertical: AppDimens.paddingSmall,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.update,
                  size: AppDimens.iconSizeSmall,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppDimens.paddingSmall),
                Text(
                  '更新: $lastUpdated',
                  style: const TextStyle(
                    fontSize: AppDimens.fontSizeSmall,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(
            right: AppDimens.paddingLarge,
            top: AppDimens.paddingMedium,
          ),
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(AppDimens.paddingSmall),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.refresh,
                color: Colors.white,
                size: AppDimens.iconSizeSmall,
              ),
            ),
            onPressed: onRefresh,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 40);
}
