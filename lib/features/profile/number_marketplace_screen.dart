import 'package:enterprise_app/features/widgets/number_marketplace_shared.dart';
import 'package:flutter/material.dart';
import '../../core/utils/constants/app_colors.dart';

class NumberMarketplaceScreen extends StatefulWidget {
  final List<PhoneListing> listings;
  final void Function(PhoneListing listing) onBuy;

  const NumberMarketplaceScreen({
    super.key,
    this.listings = _demoListings,
    required this.onBuy,
  });

  static const _demoListings = <PhoneListing>[
    PhoneListing(number: '+91 22 6900 4410', region: 'Mumbai', prefix: '22', pricePerMonth: 199),
    PhoneListing(number: '+91 80 6112 8834', region: 'Bengaluru', prefix: '80', pricePerMonth: 179),
    PhoneListing(number: '+91 11 4020 7765', region: 'Delhi NCR', prefix: '11', pricePerMonth: 189),
    PhoneListing(number: '+91 20 3355 9981', region: 'Pune', prefix: '20', pricePerMonth: 159),
    PhoneListing(number: '+91 44 6600 2210', region: 'Chennai', prefix: '44', pricePerMonth: 169),
    PhoneListing(number: '+91 1800 120 4455', region: 'Toll-Free', prefix: '1800', pricePerMonth: 299),
  ];

  @override
  State<NumberMarketplaceScreen> createState() => _NumberMarketplaceScreenState();
}

class _NumberMarketplaceScreenState extends State<NumberMarketplaceScreen> {
  static const _regions = [
    'All Regions',
    'Mumbai',
    'Bengaluru',
    'Delhi NCR',
    'Pune',
    'Chennai',
    'Toll-Free',
  ];

  String _selectedRegion = 'All Regions';
  final _prefixController = TextEditingController();
  String _prefixQuery = '';

  @override
  void dispose() {
    _prefixController.dispose();
    super.dispose();
  }

  Future<void> _openRegionPicker() async {
    final picked = await RegionPickerSheet.show(
      context,
      regions: _regions,
      selected: _selectedRegion,
    );
    if (picked != null) setState(() => _selectedRegion = picked);
  }

  List<PhoneListing> get _filteredListings {
    return widget.listings.where((l) {
      final regionMatch = _selectedRegion == 'All Regions' || l.region == _selectedRegion;
      final prefixMatch = _prefixQuery.isEmpty || l.prefix.startsWith(_prefixQuery);
      return regionMatch && prefixMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final results = _filteredListings;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: AppColors.darkText, size: 28),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Number Marketplace',
          style: TextStyle(color: AppColors.darkText, fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
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
                  const Text(
                    'REGION',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.greyText, letterSpacing: 0.6),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _openRegionPicker,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.4)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_selectedRegion, style: const TextStyle(fontSize: 16, color: AppColors.darkText)),
                          const Icon(Icons.keyboard_arrow_down, color: AppColors.iconGrey),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'PREFIX',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.greyText, letterSpacing: 0.6),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _prefixController,
                    keyboardType: TextInputType.number,
                    onChanged: (v) => setState(() => _prefixQuery = v.trim()),
                    style: const TextStyle(fontSize: 16, color: AppColors.darkText),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.filter_alt_outlined, color: AppColors.iconGrey, size: 20),
                      hintText: 'e.g. 22',
                      hintStyle: const TextStyle(color: AppColors.iconGrey, fontSize: 15),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.lightGreyColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.lightGreyColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primaryBlue),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (results.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text(
                    'No numbers match this filter.',
                    style: const TextStyle(color: AppColors.iconGrey, fontSize: 14),
                  ),
                ),
              )
            else
              for (final listing in results)
                NumberListingCard(
                  listing: listing,
                  onBuy: () => widget.onBuy(listing),
                ),
          ],
        ),
      ),
    );
  }
}