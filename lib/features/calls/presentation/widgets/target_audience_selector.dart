import 'package:flutter/material.dart';

import '../../../../core/utils/constants/app_colors.dart';

class TargetAudienceSelector extends StatelessWidget {
  const TargetAudienceSelector({
    super.key,
    required this.selectedMode,
    required this.onModeSelected,
  });

  final String selectedMode;
  final ValueChanged<String> onModeSelected;

  @override
  Widget build(BuildContext context) {
    const modes = ['ALL CONTACTS', 'BY GROUP', 'BY FILE', 'SINGLE CONTACT'];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: modes.map((mode) {
          final isSelected = selectedMode == mode;
          return Expanded(
            child: InkWell(
              onTap: () => onModeSelected(mode),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  mode,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : const Color(0xFF64748B),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
