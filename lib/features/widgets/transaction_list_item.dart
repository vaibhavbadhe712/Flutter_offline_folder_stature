import 'package:flutter/material.dart';

import '../../core/utils/constants/app_colors.dart';

/// Single wallet transaction row (title/subtitle + signed amount), used by
/// the Wallet page's Consumption Logs list.
class TransactionListItem extends StatelessWidget {
  const TransactionListItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    this.isCredit = false,
  });

  final String title;
  final String subtitle;
  final String amount;
  final bool isCredit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: AppColors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            amount,
            style: TextStyle(
              color: isCredit ? AppColors.emeraldGreen : AppColors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
