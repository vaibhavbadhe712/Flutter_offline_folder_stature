import 'package:flutter/material.dart';

import '../../../../core/utils/constants/app_colors.dart';

const _keypadKeys = [
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '*',
  '0',
  '#',
];

class DialerKeypad extends StatelessWidget {
  const DialerKeypad({
    super.key,
    required this.dialedNumber,
    required this.selectedKey,
    required this.isCalling,
    required this.onKeyPressed,
    required this.onBackspace,
    required this.onCall,
  });

  final String dialedNumber;
  final String? selectedKey;
  final bool isCalling;
  final ValueChanged<String> onKeyPressed;
  final VoidCallback onBackspace;
  final VoidCallback onCall;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  dialedNumber.isEmpty ? 'Enter number' : dialedNumber,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                    color: dialedNumber.isEmpty
                        ? AppColors.black
                        : AppColors.darkText,
                  ),
                ),
              ),
              if (dialedNumber.isNotEmpty)
                IconButton(
                  icon: const Icon(
                    Icons.backspace_outlined,
                    color: AppColors.black,
                  ),
                  onPressed: onBackspace,
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          childAspectRatio: 1.7,
          children: _keypadKeys
              .map(
                (key) => _DialerKeypadKey(
                  label: key,
                  isSelected: selectedKey == key,
                  onPressed: () => onKeyPressed(key),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: isCalling ? null : onCall,
            icon: isCalling
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.phone_in_talk_outlined, size: 20),
            label: Text(
              isCalling ? 'Dialing...' : 'Call',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}

class _DialerKeypadKey extends StatelessWidget {
  const _DialerKeypadKey({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
