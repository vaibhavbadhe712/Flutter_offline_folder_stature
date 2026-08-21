import 'package:flutter/material.dart';

import '../../../../core/utils/constants/app_colors.dart';

class CallingHoursCard extends StatelessWidget {
  const CallingHoursCard({
    super.key,
    required this.enabled,
    required this.onChanged,
  });

  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.more_time_outlined, color: Color(0xFF0F172A), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Calling hours',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                ],
              ),
              Switch(
                value: enabled,
                onChanged: onChanged,
                activeThumbColor: AppColors.primary,
                activeTrackColor: AppColors.primaryLight,
                inactiveThumbColor: AppColors.white,
                inactiveTrackColor: AppColors.primaryLight,
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Only place calls between these times (IST). Outside the window the campaign sleeps and auto-resumes — so it won\'t call at night.',
            style: TextStyle(fontSize: 11, color: Color(0xFF64748B), height: 1.4),
          ),
        ],
      ),
    );
  }
}
