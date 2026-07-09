import 'package:flutter/material.dart';

import '../../core/utils/constants/app_colors.dart';

/// Single activity/campaign row card (avatar + name/subtitle + amount/status
/// badge) shared between the Dashboard's Recent Activity list and the Calls
/// page's Campaign History list so both stay visually identical.
class ActivityListItem extends StatelessWidget {
  const ActivityListItem({
    super.key,
    required this.initials,
    required this.avatarBgColor,
    required this.avatarTextColor,
    required this.name,
    required this.subtitle,
    required this.amount,
    required this.status,
    required this.statusTextColor,
    required this.statusBgColor,
  });

  final String initials;
  final Color avatarBgColor;
  final Color avatarTextColor;
  final String name;
  final String subtitle;
  final String amount;
  final String status;
  final Color statusTextColor;
  final Color statusBgColor;

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
          CircleAvatar(
            radius: 20,
            backgroundColor: avatarBgColor,
            child: Text(
              initials,
              style: TextStyle(
                color: avatarTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusTextColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
