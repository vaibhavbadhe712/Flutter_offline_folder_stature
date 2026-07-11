import 'package:flutter/material.dart';
import '../../core/utils/constants/app_colors.dart';

class PhoneListing {
  final String number;
  final String region;
  final String prefix;
  final double pricePerMonth;

  const PhoneListing({
    required this.number,
    required this.region,
    required this.prefix,
    required this.pricePerMonth,
  });
}

class RegionPickerSheet extends StatelessWidget {
  final List<String> regions;
  final String selected;

  const RegionPickerSheet({super.key, required this.regions, required this.selected});
  static const Color _sheetBg = Color(0xFF1E2430);
  static const Color _sheetDivider = Color(0xFF323A48);
  static const Color _radioOn = Color(0xFFF59E0B);

  static Future<String?> show(
    BuildContext context, {
    required List<String> regions,
    required String selected,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.transparent,
      builder: (_) => RegionPickerSheet(regions: regions, selected: selected),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _sheetBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < regions.length; i++) ...[
                InkWell(
                  onTap: () => Navigator.of(context).pop(regions[i]),
                  borderRadius: BorderRadius.vertical(
                    top: i == 0 ? const Radius.circular(16) : Radius.zero,
                    bottom: i == regions.length - 1 ? const Radius.circular(16) : Radius.zero,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          regions[i],
                          style: const TextStyle(fontSize: 17, color: AppColors.white),
                        ),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: regions[i] == selected ? _radioOn : Colors.white54,
                              width: 2,
                            ),
                          ),
                          child: regions[i] == selected
                              ? Center(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _radioOn,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
                if (i != regions.length - 1)
                  const Divider(height: 1, color: _sheetDivider),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class NumberListingCard extends StatelessWidget {
  final PhoneListing listing;
  final VoidCallback onBuy;

  const NumberListingCard({super.key, required this.listing, required this.onBuy});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.phone, color: AppColors.primaryBlue, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  listing.region,
                  style: const TextStyle(fontSize: 13, color: AppColors.greyText, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            listing.number,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.darkText),
          ),
          const SizedBox(height: 4),
          Text(
            'Prefix ${listing.prefix} \u00b7 Local presence number',
            style: const TextStyle(fontSize: 13, color: AppColors.iconGrey),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '\u20b9${listing.pricePerMonth.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.darkText),
                    ),
                    const TextSpan(
                      text: '/mo',
                      style: TextStyle(fontSize: 14, color: AppColors.iconGrey),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: onBuy,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('Buy Number', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}