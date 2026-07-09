import 'package:flutter/material.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/dashed_border_container.dart';
import '../../../widgets/segmented_toggle.dart';

const _phoneNumberColor = Color(0xFFC17B6B);

class _ContactEntry {
  const _ContactEntry({
    required this.initials,
    required this.avatarBg,
    required this.avatarText,
    required this.name,
    required this.phone,
  });

  final String initials;
  final Color avatarBg;
  final Color avatarText;
  final String name;
  final String phone;
}

const _contacts = [
  _ContactEntry(
    initials: 'RD',
    avatarBg: Color(0xFFE0E7FF),
    avatarText: Color(0xFF4F46E5),
    name: 'Rohan Deshmukh',
    phone: '+91 98200 11223',
  ),
  _ContactEntry(
    initials: 'AK',
    avatarBg: Color(0xFFF3E8FF),
    avatarText: Color(0xFF9333EA),
    name: 'Ayesha Khan',
    phone: '+91 90040 55621',
  ),
  _ContactEntry(
    initials: 'VN',
    avatarBg: Color(0xFFFEE2E2),
    avatarText: Color(0xFFDC2626),
    name: 'Vikram Nair',
    phone: '+91 99870 34210',
  ),
  _ContactEntry(
    initials: 'PS',
    avatarBg: Color(0xFFE0F2FE),
    avatarText: Color(0xFF0284C7),
    name: 'Priya Sharma',
    phone: '+91 87654 90012',
  ),
  _ContactEntry(
    initials: 'KM',
    avatarBg: Color(0xFFE0F8E8),
    avatarText: Color(0xFF16A34A),
    name: 'Karan Mehta',
    phone: '+91 96540 11002',
  ),
  _ContactEntry(
    initials: 'SP',
    avatarBg: Color(0xFFEDE9FE),
    avatarText: Color(0xFF6D28D9),
    name: 'Sneha Patil',
    phone: '+91 88990 22114',
  ),
];

const _keypadKeys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '*', '0', '#'];

class DialerPage extends StatefulWidget {
  const DialerPage({super.key});

  @override
  State<DialerPage> createState() => _DialerPageState();
}

class _DialerPageState extends State<DialerPage> {
  bool _isContactsMode = false;
  String _dialedNumber = '';

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _callNumber(String number) {
    _showSnack(number.isEmpty ? 'Enter a number to call.' : 'Calling $number…');
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
              const Text(
                'Dialer',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.black),
              ),
              const SizedBox(height: 16),
              SegmentedToggle(
                labels: const ['Dialer Pad', 'Contacts'],
                selectedIndex: _isContactsMode ? 1 : 0,
                onChanged: (index) => setState(() => _isContactsMode = index == 1),
              ),
              const SizedBox(height: 20),
              if (_isContactsMode) ..._buildContactsView() else ..._buildDialerPadView(),
              const SizedBox(height: 16),
              _buildSimulateIncomingButton(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDialerPadView() {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _dialedNumber.isEmpty ? 'Enter number' : _dialedNumber,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                  color: _dialedNumber.isEmpty ? AppColors.black : AppColors.darkText,
                ),
              ),
            ),
            if (_dialedNumber.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.backspace_outlined, color: AppColors.black),
                onPressed: () => setState(
                  () => _dialedNumber = _dialedNumber.substring(0, _dialedNumber.length - 1),
                ),
              ),
          ],
        ),
      ),
      const SizedBox(height: 8),
      GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        childAspectRatio: 1.5,
        children: _keypadKeys.map(_buildKeypadKey).toList(),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          onPressed: () => _callNumber(_dialedNumber),
          icon: const Icon(Icons.phone_in_talk_outlined, size: 20),
          label: const Text('Call', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ),
      ),
    ];
  }

  Widget _buildKeypadKey(String key) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => setState(() => _dialedNumber += key),
        child: Center(
          child: Text(
            key,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: AppColors.black),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContactsView() {
    return [
      CustomCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            for (var i = 0; i < _contacts.length; i++) ...[
              _buildContactRow(_contacts[i]),
              if (i != _contacts.length - 1) const Divider(height: 1, color: AppColors.whiteColor),
            ],
          ],
        ),
      ),
    ];
  }

  Widget _buildContactRow(_ContactEntry contact) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: contact.avatarBg,
            child: Text(
              contact.initials,
              style: TextStyle(color: contact.avatarText, fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.name,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.black),
                ),
                const SizedBox(height: 2),
                Text(
                  contact.phone,
                  style: const TextStyle(fontSize: 12, color: AppColors.black),
                ),
              ],
            ),
          ),
          Material(
            color: const Color(0xFFDCFCE7),
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => _callNumber(contact.phone),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.phone_outlined, size: 18, color: Color(0xFF16A34A)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimulateIncomingButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _showSnack('Simulating incoming call…'),
        child: DashedBorderContainer(
          borderRadius: 14,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.phone_callback_outlined, size: 18, color: AppColors.primary),
                SizedBox(width: 8),
                Text(
                  'Simulate Incoming Call (demo)',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
