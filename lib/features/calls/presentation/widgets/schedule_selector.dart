import 'package:flutter/material.dart';

import '../../../../core/utils/constants/app_colors.dart';

class ScheduleSelector extends StatelessWidget {
  const ScheduleSelector({
    super.key,
    required this.selectedMode,
    required this.onModeSelected,
  });

  final String selectedMode;
  final ValueChanged<String> onModeSelected;

  @override
  Widget build(BuildContext context) {
    const modes = ['LAUNCH NOW', 'LATER'];
    return Row(
      children: modes.map((mode) {
        final isSelected = selectedMode == mode;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: mode == 'LAUNCH NOW' ? 8 : 0,
              left: mode == 'LATER' ? 8 : 0,
            ),
            child: InkWell(
              onTap: () => onModeSelected(mode),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Text(
                  mode,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : const Color(0xFF64748B),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
