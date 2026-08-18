import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/segmented_toggle.dart';
import '../../../widgets/custom_shimmer.dart';
import '../../../calls/domain/entities/contact_entity.dart';
import '../../../calls/presentation/providers/contacts_provider.dart';
import '../../../calls/presentation/state/contacts_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

const _keypadKeys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '*', '0', '#'];

class DialerPage extends ConsumerStatefulWidget {
  const DialerPage({super.key});

  @override
  ConsumerState<DialerPage> createState() => _DialerPageState();
}

class _DialerPageState extends ConsumerState<DialerPage> {
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
    final contactsState = ref.watch(contactsProvider);
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
                onChanged: (index) {
                  setState(() => _isContactsMode = index == 1);
                  if (index == 1) {
                    final authState = ref.read(authProvider);
                    final userId = authState.maybeWhen(
                      authenticated: (user) => user.id,
                      orElse: () => null,
                    );
                    ref.read(contactsProvider.notifier).fetchContacts(userId: userId);
                  }
                },
              ),
              const SizedBox(height: 20),
              if (_isContactsMode) ..._buildContactsView(contactsState) else ..._buildDialerPadView(),
              // const SizedBox(height: 16),
              // _buildSimulateIncomingButton(),
              // const SizedBox(height: 16),
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

  List<Widget> _buildContactsView(ContactsState contactsState) {
    return [
      contactsState.when(
        initial: () => _buildContactsShimmer(),
        loading: () => _buildContactsShimmer(),
        error: (message) => CustomCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Error loading contacts: $message',
                  style: const TextStyle(color: AppColors.noticeRedText, fontSize: 14),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => ref.read(contactsProvider.notifier).fetchContacts(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        loaded: (contactsList) {
          if (contactsList.isEmpty) {
            return const CustomCard(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    'No contacts found',
                    style: TextStyle(color: AppColors.black, fontSize: 14),
                  ),
                ),
              ),
            );
          }

          return CustomCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var i = 0; i < contactsList.length; i++) ...[
                  _buildContactRow(contactsList[i], i),
                  if (i != contactsList.length - 1) const Divider(height: 1, color: AppColors.whiteColor),
                ],
              ],
            ),
          );
        },
      ),
    ];
  }

  Widget _buildContactRow(ContactEntity contact, int index) {
    final String initials = ((contact.firstName.isNotEmpty ? contact.firstName[0] : '') +
                            (contact.lastName.isNotEmpty ? contact.lastName[0] : '')).toUpperCase();
    final String fullName = '${contact.firstName} ${contact.lastName}'.trim();
    final String nameToShow = fullName.isEmpty ? 'Unknown Contact' : fullName;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: _getAvatarBgColor(index),
            child: Text(
              initials.isEmpty ? '?' : initials,
              style: TextStyle(color: _getAvatarTextColor(index), fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nameToShow,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.black),
                ),
                const SizedBox(height: 2),
                Text(
                  contact.phoneNumber,
                  style: const TextStyle(fontSize: 12, color: AppColors.black),
                ),
              ],
            ),
          ),
          Material(
            color: AppColors.mintGreen,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => _callNumber(contact.phoneNumber),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.phone_outlined, size: 18, color: AppColors.greenColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getAvatarBgColor(int index) {
    final colors = [
      AppColors.avatarIndigoBg,
      AppColors.avatarSkyBg,
      AppColors.avatarVioletBg,
      AppColors.noticeYellowBg,
      AppColors.noticeRedBg,
      AppColors.mintGreen,
    ];
    return colors[index % colors.length];
  }

  Color _getAvatarTextColor(int index) {
    final colors = [
      AppColors.avatarIndigoText,
      AppColors.avatarSkyText,
      AppColors.avatarVioletText,
      AppColors.noticeYellowText,
      AppColors.noticeRedText,
      AppColors.emeraldGreen,
    ];
    return colors[index % colors.length];
  }

  Widget _buildContactsShimmer() {
    return CustomCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < 4; i++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  const CustomShimmer.circular(size: 40),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomShimmer.rectangular(width: 120, height: 14),
                        SizedBox(height: 6),
                        CustomShimmer.rectangular(width: 160, height: 11),
                      ],
                    ),
                  ),
                  CustomShimmer.rectangular(
                    width: 38,
                    height: 38,
                    borderRadius: BorderRadius.circular(19),
                  ),
                ],
              ),
            ),
            if (i != 3) const Divider(height: 1, color: AppColors.whiteColor),
          ],
        ],
      ),
    );
  }

  // Widget _buildSimulateIncomingButton() {
  //   return Material(
  //     color: Colors.transparent,
  //     child: InkWell(
  //       borderRadius: BorderRadius.circular(14),
  //       onTap: () => _showSnack('Simulating incoming call…'),
  //       child: DashedBorderContainer(
  //         borderRadius: 14,
  //         child: Container(
  //           width: double.infinity,
  //           padding: const EdgeInsets.symmetric(vertical: 14),
  //           child: const Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Icon(Icons.phone_callback_outlined, size: 18, color: AppColors.primary),
  //               SizedBox(width: 8),
  //               Text(
  //                 'Simulate Incoming Call (demo)',
  //                 style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
