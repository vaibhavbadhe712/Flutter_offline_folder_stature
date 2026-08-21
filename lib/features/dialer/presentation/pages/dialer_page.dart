import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../widgets/segmented_toggle.dart';
import '../../../calls/presentation/providers/contacts_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/dial_outbound_call_provider.dart';
import '../providers/dialer_calls_provider.dart';
import '../widgets/dialer_contacts_view.dart';
import '../widgets/dialer_keypad.dart';
import '../widgets/recent_calls_list.dart';
import '../../../../core/utils/toast_services/toast_services.dart';

class DialerPage extends ConsumerStatefulWidget {
  const DialerPage({super.key});

  @override
  ConsumerState<DialerPage> createState() => _DialerPageState();
}

class _DialerPageState extends ConsumerState<DialerPage> {
  bool _isContactsMode = false;
  bool _isDialPadOpen = false;
  String _dialedNumber = '';
  String? _selectedKey;

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _startOutboundCall(String number) async {
    final normalizedNumber = _normalizePhoneNumber(number);
    if (normalizedNumber == null) {
      ToastServices.error('Error', 'Enter a valid phone number to call.');
      return;
    }

    final userId = ref
        .read(authProvider)
        .maybeWhen(authenticated: (user) => user.id, orElse: () => null);
    if (userId == null || userId.isEmpty) {
      ToastServices.error('Error', 'Please sign in before placing a call.');
      return;
    }

    final error = await ref
        .read(dialOutboundCallProvider.notifier)
        .dial(userId: userId, toNumber: normalizedNumber);
    if (!mounted) return;

    if (error == null) {
      ToastServices.success('Success', 'Call initiated successfully.');
      setState(() {
        _dialedNumber = '';
      });
      ref.read(dialerCallsProvider.notifier).fetchCalls(userId: userId);
    } else {
      ToastServices.error('Error', error);
    }
  }

  String? _normalizePhoneNumber(String value) {
    final compact = value.trim().replaceAll(RegExp(r'[\s()-]'), '');
    if (RegExp(r'^\+\d{8,15}$').hasMatch(compact)) return compact;
    if (RegExp(r'^\d{10}$').hasMatch(compact)) return '+91$compact';
    return null;
  }

  void _refreshCalls() {
    final userId = ref.read(authProvider).maybeWhen(
          authenticated: (user) => user.id,
          orElse: () => null,
        );
    if (userId != null && userId.isNotEmpty) {
      ref.read(dialerCallsProvider.notifier).fetchCalls(userId: userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final contactsState = ref.watch(contactsProvider);
    final dialerCallsState = ref.watch(dialerCallsProvider);
    final isCalling = ref.watch(dialOutboundCallProvider);
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Text(
              //   'Dialer',
              //   style: TextStyle(
              //     fontSize: 22,
              //     fontWeight: FontWeight.bold,
              //     color: AppColors.black,
              //   ),
              // ),
              const SizedBox(height: 16),
              SegmentedToggle(
                labels: const ['Dialer Pad', 'Contacts'],
                selectedIndex: _isContactsMode ? 1 : 0,
                selectedColor: AppColors.primary,
                onChanged: (index) {
                  setState(() {
                    _isContactsMode = index == 1;
                    if (index == 1) _isDialPadOpen = false;
                  });
                  if (index == 1) {
                    final authState = ref.read(authProvider);
                    final userId = authState.maybeWhen(
                      authenticated: (user) => user.id,
                      orElse: () => null,
                    );
                    ref
                        .read(contactsProvider.notifier)
                        .fetchContacts(userId: userId);
                  }
                },
              ),
              const SizedBox(height: 12),
              if (_isContactsMode)
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: DialerContactsView(
                      contactsState: contactsState,
                      isCalling: isCalling,
                      onCall: _startOutboundCall,
                      onRetry: () => ref
                          .read(contactsProvider.notifier)
                          .fetchContacts(),
                    ),
                  ),
                )
              else
                Expanded(
                  child: _buildCallHistoryWithDialPad(
                    state: dialerCallsState,
                    isCalling: isCalling,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCallHistoryWithDialPad({
    required AsyncValue<List<DialerCall>> state,
    required bool isCalling,
  }) {
    return LayoutBuilder(
      builder: (context, _) {
        return Stack(
          children: [
            Positioned.fill(
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (_isDialPadOpen && notification is ScrollStartNotification) {
                    setState(() => _isDialPadOpen = false);
                  }
                  return false;
                },
                child: RecentCallsList(
                  state: state,
                  onRefresh: _refreshCalls,
                ),
              ),
            ),
            if (_isDialPadOpen)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  decoration: const BoxDecoration(
                    color: AppColors.whiteColor,
                    border: Border(
                      top: BorderSide(color: AppColors.fieldBorderColor),
                    ),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.lightGreyColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      DialerKeypad(
                        dialedNumber: _dialedNumber,
                        selectedKey: _selectedKey,
                        isCalling: isCalling,
                        onKeyPressed: (key) => setState(() {
                          _dialedNumber += key;
                          _selectedKey = key;
                        }),
                        onBackspace: () => setState(
                          () => _dialedNumber = _dialedNumber.substring(
                            0,
                            _dialedNumber.length - 1,
                          ),
                        ),
                        onCall: () => _startOutboundCall(_dialedNumber),
                      ),
                    ],
                  ),
                ),
              )
            else
              Positioned(
                right: 4,
                bottom: 16,
                child: FloatingActionButton(
                  heroTag: 'openDialPad',
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  onPressed: () => setState(() => _isDialPadOpen = true),
                  child: const Icon(Icons.dialpad),
                ),
              ),
          ],
        );
      },
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
