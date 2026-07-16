import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/utils/constants/app_colors.dart';

class CustomShimmer extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadiusGeometry borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const CustomShimmer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.baseColor,
    this.highlightColor,
  });

  // Factory constructor for circular shimmer shapes
  const CustomShimmer.circular({
    super.key,
    required double size,
    this.baseColor,
    this.highlightColor,
  })  : width = size,
        height = size,
        borderRadius = const BorderRadius.all(Radius.circular(9999));

  // Factory constructor for rectangular/rounded shimmer shapes
  const CustomShimmer.rectangular({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? const Color(0xFFE2E8F0),
      highlightColor: highlightColor ?? const Color(0xFFF1F5F9),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}

/// Shimmer skeleton loader that matches the visual layout of ActivityListItem
class ActivityListItemShimmer extends StatelessWidget {
  const ActivityListItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          // Circular Avatar Shimmer
          const CustomShimmer.circular(size: 40),
          const SizedBox(width: 12),
          // Name and Subtitle Shimmer
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomShimmer.rectangular(width: 120, height: 14),
                SizedBox(height: 6),
                CustomShimmer.rectangular(width: 160, height: 11),
              ],
            ),
          ),
          // Amount and Status Shimmer
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const CustomShimmer.rectangular(width: 50, height: 14),
              const SizedBox(height: 8),
              CustomShimmer.rectangular(
                width: 60,
                height: 16,
                borderRadius: BorderRadius.circular(20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
