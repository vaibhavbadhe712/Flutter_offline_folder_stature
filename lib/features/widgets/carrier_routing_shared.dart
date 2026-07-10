import 'package:flutter/material.dart';
import '../../core/utils/constants/app_colors.dart';

class Carrier {
  final String name;
  final double pricePerMin;
  final bool enabled;

  const Carrier({
    required this.name,
    required this.pricePerMin,
    this.enabled = true,
  });

  Carrier copyWith({String? name, double? pricePerMin, bool? enabled}) {
    return Carrier(
      name: name ?? this.name,
      pricePerMin: pricePerMin ?? this.pricePerMin,
      enabled: enabled ?? this.enabled,
    );
  }
}

class CarrierRow extends StatelessWidget {
  final int priority;
  final Carrier carrier;
  final ValueChanged<bool> onToggle;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;

  const CarrierRow({
    super.key,
    required this.priority,
    required this.carrier,
    required this.onToggle,
    this.onMoveUp,
    this.onMoveDown,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Text(
              '$priority',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primaryBlue),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  carrier.name,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primaryBlue),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.mintGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '\u20b9${carrier.pricePerMin.toStringAsFixed(2)}/min',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.emeraldGreen),
                  ),
                ),
              ],
            ),
          ),

          Switch(
            value: carrier.enabled,
            onChanged: onToggle,
            activeThumbColor: AppColors.white,
            activeTrackColor: AppColors.primaryBlue,
            inactiveThumbColor: AppColors.white,
            inactiveTrackColor: AppColors.lightGreyColor,
            trackOutlineColor: WidgetStateProperty.all(AppColors.transparent),
          ),
          const SizedBox(width: 6),

          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: onMoveUp,
                child: Icon(
                  Icons.keyboard_arrow_up,
                  size: 20,
                  color: onMoveUp == null ? AppColors.lightGreyColor : AppColors.iconGrey,
                ),
              ),
              GestureDetector(
                onTap: onMoveDown,
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                  color: onMoveDown == null ? AppColors.lightGreyColor : AppColors.iconGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}