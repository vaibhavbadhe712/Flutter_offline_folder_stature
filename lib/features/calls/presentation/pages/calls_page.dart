import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../widgets/activity_list_item.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/dashed_border_container.dart';
import '../../../widgets/segmented_toggle.dart';
import '../providers/outbound_phone_numbers_provider.dart';
import '../state/outbound_phone_numbers_state.dart';
import '../../domain/entities/phone_number_entity.dart';
import '../providers/assistants_provider.dart';
import '../state/assistants_state.dart';
import '../../domain/entities/assistant_entity.dart';
import '../providers/contacts_provider.dart';
import '../state/contacts_state.dart';
import '../../domain/entities/contact_entity.dart';
import '../providers/start_call_provider.dart';
import '../state/start_call_state.dart';
import '../../../../core/utils/toast_services/toast_services.dart';

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
    avatarBg: AppColors.avatarIndigoBg,
    avatarText: AppColors.avatarIndigoText,
    name: 'Rohan Deshmukh',
    subtitle: '10:42 AM · AI Call',
    amount: '₹4.20',
    isPositive: true,
  ),
  _CampaignEntry(
    initials: 'VN',
    avatarBg: AppColors.noticeRedBg,
    avatarText: AppColors.noticeRedText,
    name: 'Vikram Nair',
    subtitle: '09:58 AM · AI Call',
    amount: '₹2.10',
    isPositive: false,
  ),
  _CampaignEntry(
    initials: 'PS',
    avatarBg: AppColors.avatarSkyBg,
    avatarText: AppColors.avatarSkyText,
    name: 'Priya Sharma',
    subtitle: '09:30 AM · AI Call',
    amount: '₹6.75',
    isPositive: true,
  ),
  _CampaignEntry(
    initials: 'SP',
    avatarBg: AppColors.avatarVioletBg,
    avatarText: AppColors.avatarVioletText,
    name: 'Sneha Patil',
    subtitle: '08:47 AM · AI Call',
    amount: '₹3.60',
    isPositive: true,
  ),
];

class CallsPage extends ConsumerStatefulWidget {
  const CallsPage({super.key});

  @override
  ConsumerState<CallsPage> createState() => _CallsPageState();
}

class _CallsPageState extends ConsumerState<CallsPage> {
  bool _isBulkMode = false;

  PhoneNumberEntity? _selectedOutbound;

  String? _selectedAssistant;
  ContactEntity? _selectedContact;

  String _selectedAgent = 'Support Bot V1';
  final _phoneController = TextEditingController();

  static const _agents = ['Support Bot V1', 'Sales Bot V2', 'Survey Bot'];

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final outboundState = ref.watch(outboundPhoneNumbersProvider);
    final assistantsState = ref.watch(assistantsProvider);
    final contactsState = ref.watch(contactsProvider);
    final startCallState = ref.watch(startCallProvider);

    ref.listen<StartCallState>(startCallProvider, (previous, next) {
      next.maybeWhen(
        success: (message) {
          ToastServices.success('Success', message);
        },
        error: (message) {
          ToastServices.error('Error', 'Failed to start call: $message');
        },
        orElse: () {},
      );
    });

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
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 16),
              CustomCard(child: _buildCallForm(outboundState, assistantsState, contactsState, startCallState)),
              const SizedBox(height: 24),
              const Text(
                'Live Progress Monitor',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
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
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
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
                      statusTextColor: entry.isPositive
                          ? AppColors.statusPositiveText
                          : AppColors.statusNegativeText,
                      statusBgColor: entry.isPositive
                          ? AppColors.mintGreen
                          : AppColors.noticeRedBg,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCallForm(
    OutboundPhoneNumbersState outboundState,
    AssistantsState assistantsState,
    ContactsState contactsState,
    StartCallState startCallState,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SegmentedToggle(
          labels: const ['Single Call', 'Bulk Calls'],
          selectedIndex: _isBulkMode ? 1 : 0,
          onChanged: (index) => setState(() => _isBulkMode = index == 1),
        ),
        const SizedBox(height: 24),
        if (_isBulkMode) ...[
          ..._buildBulkFields(),
          const SizedBox(height: 4),
          const Text(
            'AI AGENT',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 8),
          _buildAgentDropdown(),
        ] else ...[
          ..._buildSingleFields(outboundState, assistantsState, contactsState),
        ],
        const SizedBox(height: 24),
        _buildStartButton(startCallState, assistantsState, contactsState),
      ],
    );
  }

  List<Widget> _buildSingleFields(
    OutboundPhoneNumbersState state,
    AssistantsState assistantsState,
    ContactsState contactsState,
  ) {
    return [
      const Text(
        'SINGLE TEST CALL',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0F172A),
          letterSpacing: 0.5,
        ),
      ),
      const SizedBox(height: 4),
      const Text(
        'TEST AN AI ASSISTANT ON A REAL CALL.',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Color(0xFF64748B),
          letterSpacing: 0.5,
        ),
      ),
      const SizedBox(height: 20),

      // 1. Phone Number Field
      _buildFieldLabel(Icons.phone_in_talk_outlined, 'Phone Number'),
      const SizedBox(height: 8),
      state.when(
        initial: () => const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: CircularProgressIndicator(),
          ),
        ),
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (message) => Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF2F2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFCA5A5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Error loading numbers: $message',
                style: const TextStyle(color: Color(0xFF991B1B), fontSize: 13),
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: () => ref
                    .read(outboundPhoneNumbersProvider.notifier)
                    .fetchOutboundNumbers(),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                ),
                child: const Text(
                  'Retry',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFDC2626),
                  ),
                ),
              ),
            ],
          ),
        ),
        loaded: (phoneNumbers) {
          if (phoneNumbers.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'No outbound phone numbers configured',
                style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
              ),
            );
          }

          // Safe dynamic fallback to avoid build error
          if (_selectedOutbound == null ||
              !phoneNumbers.any((item) => item.id == _selectedOutbound!.id)) {
            _selectedOutbound = phoneNumbers.first;
          } else {
            // Re-match the reference with the loaded array item
            _selectedOutbound = phoneNumbers.firstWhere(
              (item) => item.id == _selectedOutbound!.id,
            );
          }

          return _buildDropdownField<PhoneNumberEntity>(
            value: _selectedOutbound!,
            items: _buildOutboundItems(phoneNumbers),
            onChanged: (val) {
              if (val != null) setState(() => _selectedOutbound = val);
            },
          );
        },
      ),
      const SizedBox(height: 16),

      // 2. Assistant Field
      _buildFieldLabel(Icons.radio_button_unchecked_outlined, 'Assistant'),
      const SizedBox(height: 8),
      assistantsState.when(
        initial: () => const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: CircularProgressIndicator(),
          ),
        ),
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (message) => Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.noticeRedBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.noticeRedText.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Error loading assistants: $message',
                style: const TextStyle(color: AppColors.noticeRedText, fontSize: 13),
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: () => ref.read(assistantsProvider.notifier).fetchAssistants(),
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                child: const Text('Retry', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.noticeRedText)),
              ),
            ],
          ),
        ),
        loaded: (assistants) {
          if (assistants.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'No assistants configured',
                style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
              ),
            );
          }

          // Safe dynamic fallback to avoid build error
          if (_selectedAssistant == null || !assistants.any((item) => item.name == _selectedAssistant)) {
            _selectedAssistant = assistants.first.name;
          } else {
            // Re-match reference
            _selectedAssistant = assistants.firstWhere((item) => item.name == _selectedAssistant).name;
          }

          return _buildDropdownField<String>(
            value: _selectedAssistant!,
            items: _buildAssistantItems(assistants),
            onChanged: (val) {
              if (val != null) setState(() => _selectedAssistant = val);
            },
          );
        },
      ),
      const SizedBox(height: 16),

      // 3. Contact Field
      _buildFieldLabel(Icons.people_outline, 'Contact'),
      const SizedBox(height: 8),
      contactsState.when(
        initial: () => const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: CircularProgressIndicator(),
          ),
        ),
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (message) => Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.noticeRedBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.noticeRedText.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Error loading contacts: $message',
                style: const TextStyle(color: AppColors.noticeRedText, fontSize: 13),
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: () => ref.read(contactsProvider.notifier).fetchContacts(),
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                child: const Text('Retry', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.noticeRedText)),
              ),
            ],
          ),
        ),
        loaded: (contacts) {
          if (contacts.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'No contacts configured',
                style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
              ),
            );
          }

          // Safe dynamic fallback to avoid build error
          if (_selectedContact == null || !contacts.any((item) => item.id == _selectedContact!.id)) {
            _selectedContact = contacts.first;
          } else {
            // Re-match reference
            _selectedContact = contacts.firstWhere((item) => item.id == _selectedContact!.id);
          }

          return _buildDropdownField<ContactEntity>(
            value: _selectedContact!,
            items: _buildContactItems(contacts),
            onChanged: (val) {
              if (val != null) setState(() => _selectedContact = val);
            },
          );
        },
      ),
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
                  Icon(
                    Icons.upload_file_outlined,
                    size: 28,
                    color: AppColors.primary,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Tap to upload CSV / Excel',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
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
        border: Border.all(color: AppColors.fieldBorderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedAgent,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.black),
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.black,
            fontWeight: FontWeight.w500,
          ),
          items: _agents
              .map(
                (agent) => DropdownMenuItem(value: agent, child: Text(agent)),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) setState(() => _selectedAgent = value);
          },
        ),
      ),
    );
  }

  Widget _buildStartButton(
    StartCallState startCallState,
    AssistantsState assistantsState,
    ContactsState contactsState,
  ) {
    final isLoading = startCallState.maybeWhen(loading: () => true, orElse: () => false);
    final label = _isBulkMode ? 'Start Bulk Campaign' : (isLoading ? 'Starting Call...' : 'Start AI Test Call');
    final icon = _isBulkMode ? Icons.phone_in_talk_outlined : Icons.play_arrow_outlined;
    final bgColor = _isBulkMode ? AppColors.primary : const Color(0xFF0F172A);

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: isLoading ? null : () {
          if (_isBulkMode) {
            _showSnack('Bulk campaign started.');
          } else {
            if (_selectedOutbound == null) {
              _showSnack('Please select an outbound phone number line.');
              return;
            }
            if (_selectedAssistant == null) {
              _showSnack('Please select an assistant.');
              return;
            }
            if (_selectedContact == null) {
              _showSnack('Please select a contact.');
              return;
            }

            // Obtain the assistant's real ID by checking the loaded assistants list
            int? assistantId;
            assistantsState.maybeWhen(
              loaded: (assistants) {
                final match = assistants.firstWhere((a) => a.name == _selectedAssistant);
                assistantId = match.id;
              },
              orElse: () {},
            );

            if (assistantId == null) {
              _showSnack('Selected assistant database record was not loaded.');
              return;
            }

            ref.read(startCallProvider.notifier).startTestCall(
              assistantId: assistantId!,
              toNumber: _selectedContact!.phoneNumber,
              phoneNumberId: _selectedOutbound!.id,
              contactId: _selectedContact!.id,
            );
          }
        },
        icon: isLoading 
            ? const SizedBox(
                width: 20, 
                height: 20, 
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : Icon(icon, size: 20),
        label: Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF64748B)),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField<T>({
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B)),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }

  List<DropdownMenuItem<PhoneNumberEntity>> _buildOutboundItems(
    List<PhoneNumberEntity> phoneNumbers,
  ) {
    return phoneNumbers.map((item) {
      return DropdownMenuItem(
        value: item,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              item.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              item.phoneNumber,
              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
          ],
        ),
      );
    }).toList();
  }

  List<DropdownMenuItem<ContactEntity>> _buildContactItems(List<ContactEntity> contacts) {
    return contacts.map((item) {
      return DropdownMenuItem(
        value: item,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              item.firstName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              item.phoneNumber,
              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
          ],
        ),
      );
    }).toList();
  }

  List<DropdownMenuItem<String>> _buildAssistantItems(List<AssistantEntity> assistants) {
    return assistants.map((item) {
      return DropdownMenuItem(
        value: item.name,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            item.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
        ),
      );
    }).toList();
  }
}
