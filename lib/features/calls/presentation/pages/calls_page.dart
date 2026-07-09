import 'package:flutter/material.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../widgets/activity_list_item.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/dashed_border_container.dart';
import '../../../widgets/segmented_toggle.dart';

class _CampaignEntry {
  const _CampaignEntry({
    required this.initials,
    required this.avatarBg,
    required this.avatarText,
    required this.name,
    required this.subtitle,
    required this.amount,
    required this.isPositive,
  });

  final String initials;
  final Color avatarBg;
  final Color avatarText;
  final String name;
  final String subtitle;
  final String amount;
  final bool isPositive;
}

const _campaignHistory = [
  _CampaignEntry(
    initials: 'RD',
    avatarBg: Color(0xFFE0E7FF),
    avatarText: Color(0xFF4F46E5),
    name: 'Rohan Deshmukh',
    subtitle: '10:42 AM · AI Call',
    amount: '₹4.20',
    isPositive: true,
  ),
  _CampaignEntry(
    initials: 'VN',
    avatarBg: Color(0xFFFEE2E2),
    avatarText: Color(0xFFDC2626),
    name: 'Vikram Nair',
    subtitle: '09:58 AM · AI Call',
    amount: '₹2.10',
    isPositive: false,
  ),
  _CampaignEntry(
    initials: 'PS',
    avatarBg: Color(0xFFE0F2FE),
    avatarText: Color(0xFF0284C7),
    name: 'Priya Sharma',
    subtitle: '09:30 AM · AI Call',
    amount: '₹6.75',
    isPositive: true,
  ),
  _CampaignEntry(
    initials: 'SP',
    avatarBg: Color(0xFFEDE9FE),
    avatarText: Color(0xFF6D28D9),
    name: 'Sneha Patil',
    subtitle: '08:47 AM · AI Call',
    amount: '₹3.60',
    isPositive: true,
  ),
];

class CallsPage extends StatefulWidget {
  const CallsPage({super.key});

  @override
  State<CallsPage> createState() => _CallsPageState();
}

class _CallsPageState extends State<CallsPage> {
  bool _isBulkMode = false;
  String _selectedAgent = 'Support Bot V1';
  final _phoneController = TextEditingController();

  static const _agents = ['Support Bot V1', 'Sales Bot V2', 'Survey Bot'];

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AI Calling & Campaigns',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.black),
              ),
              const SizedBox(height: 16),
              CustomCard(child: _buildCallForm()),
              const SizedBox(height: 24),
              const Text(
                'Live Progress Monitor',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black),
              ),
              const SizedBox(height: 12),
              CustomCard(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.show_chart, size: 36, color: AppColors.black),
                      const SizedBox(height: 12),
                      const Text(
                        'No active calls — start one above',
                        style: TextStyle(color: AppColors.black, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Campaign History',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black),
              ),
              const SizedBox(height: 12),
              Column(
                children: [
                  for (final entry in _campaignHistory)
                    ActivityListItem(
                      initials: entry.initials,
                      avatarBgColor: entry.avatarBg,
                      avatarTextColor: entry.avatarText,
                      name: entry.name,
                      subtitle: entry.subtitle,
                      amount: entry.amount,
                      status: entry.isPositive ? 'Positive' : 'Negative',
                      statusTextColor: AppColors.black,
                      statusBgColor: entry.isPositive ? AppColors.greenColor : AppColors.redColor,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCallForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SegmentedToggle(
          labels: const ['Single Call', 'Bulk Calls'],
          selectedIndex: _isBulkMode ? 1 : 0,
          onChanged: (index) => setState(() => _isBulkMode = index == 1),
        ),
        const SizedBox(height: 16),
        if (_isBulkMode) ..._buildBulkFields() else ..._buildSingleFields(),
        const SizedBox(height: 4),
        const Text(
          'AI AGENT',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.black, letterSpacing: 0.4),
        ),
        const SizedBox(height: 8),
        _buildAgentDropdown(),
        const SizedBox(height: 20),
        _buildStartButton(),
      ],
    );
  }

  List<Widget> _buildSingleFields() {
    return [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.phone_android_outlined, size: 20, color: AppColors.black),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontSize: 15, color: AppColors.black, fontWeight: FontWeight.w500),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                  hintText: '+91 98765 43210',
                  hintStyle: TextStyle(color: AppColors.black, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showSnack('Opening contacts…'),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.white),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 20, color: AppColors.black),
                SizedBox(width: 8),
                Text(
                  'Browse Contacts',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.black),
                ),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(height: 16),
    ];
  }

  List<Widget> _buildBulkFields() {
    return [
      Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showSnack('Upload CSV / Excel not yet wired up.'),
          child: DashedBorderContainer(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28),
              child: const Column(
                children: [
                  Icon(Icons.upload_file_outlined, size: 28, color: AppColors.primary),
                  SizedBox(height: 10),
                  Text(
                    'Tap to upload CSV / Excel',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.black),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'max 5,000 contacts',
                    style: TextStyle(fontSize: 12, color: AppColors.black),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      const SizedBox(height: 16),
    ];
  }

  Widget _buildAgentDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.white),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedAgent,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.black),
          style: const TextStyle(fontSize: 15, color: AppColors.black, fontWeight: FontWeight.w500),
          items: _agents
              .map((agent) => DropdownMenuItem(value: agent, child: Text(agent)))
              .toList(),
          onChanged: (value) {
            if (value != null) setState(() => _selectedAgent = value);
          },
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    final label = _isBulkMode ? 'Start Bulk Campaign' : 'Start Call';
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: () {
          if (_isBulkMode) {
            _showSnack('Bulk campaign started.');
          } else {
            _showSnack('Calling ${_phoneController.text.isEmpty ? '+91 98765 43210' : _phoneController.text}…');
          }
        },
        icon: const Icon(Icons.phone_in_talk_outlined, size: 20),
        label: Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

}
