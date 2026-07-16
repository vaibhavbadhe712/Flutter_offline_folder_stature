import 'package:flutter/material.dart';

/// A pure Flutter pulsing shimmer widget that doesn't require any third-party dependencies.
class CustomShimmer extends StatefulWidget {
  final double width;
  final double height;
  final BoxShape shape;
  final BorderRadius? borderRadius;

  const CustomShimmer({
    super.key,
    required this.width,
    required this.height,
    this.shape = BoxShape.rectangle,
    this.borderRadius,
  });

  /// Factory constructor to create a circular shimmer placeholder (e.g. for avatars)
  factory CustomShimmer.circular({required double radius}) {
    return CustomShimmer(
      width: radius * 2,
      height: radius * 2,
      shape: BoxShape.circle,
    );
  }

  @override
  State<CustomShimmer> createState() => _CustomShimmerState();
}

class _CustomShimmerState extends State<CustomShimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.35, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              shape: widget.shape,
              borderRadius: widget.shape == BoxShape.circle ? null : (widget.borderRadius ?? BorderRadius.circular(8)),
            ),
          ),
        );
      },
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          // Circular Avatar Shimmer
          CustomShimmer.circular(radius: 20),
          const SizedBox(width: 12),
          // Name and Subtitle Shimmer
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomShimmer(width: 120, height: 14),
                const SizedBox(height: 6),
                const CustomShimmer(width: 160, height: 11),
              ],
            ),
          ),
          // Amount and Status Shimmer
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const CustomShimmer(width: 50, height: 14),
              const SizedBox(height: 8),
              CustomShimmer(
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
