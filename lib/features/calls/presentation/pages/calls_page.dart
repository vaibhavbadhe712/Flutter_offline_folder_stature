import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../widgets/activity_list_item.dart';
import '../../../widgets/custom_card.dart';
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
import '../../../widgets/custom_shimmer.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../dashboard/presentation/providers/recent_activity_provider.dart';
import '../providers/campaign_helpers_provider.dart';
import '../controllers/calls_screen_controller.dart';
import '../widgets/calling_hours_card.dart';
import '../widgets/schedule_selector.dart';
import '../widgets/target_audience_selector.dart';

class CallsPage extends ConsumerStatefulWidget {
  const CallsPage({super.key});

  @override
  ConsumerState<CallsPage> createState() => _CallsPageState();
}

class _CallsPageState extends ConsumerState<CallsPage> {
  final _ui = CallsUiController();

  bool get _isBulkMode => _ui.isBulkMode;
  set _isBulkMode(bool value) => _ui.isBulkMode = value;
  bool get _hasSelectedTargetAudience => _ui.hasSelectedTargetAudience;
  set _hasSelectedTargetAudience(bool value) => _ui.hasSelectedTargetAudience = value;
  PhoneNumberEntity? get _selectedOutbound => _ui.selectedOutbound;
  set _selectedOutbound(PhoneNumberEntity? value) => _ui.selectedOutbound = value;
  String? get _selectedAssistant => _ui.selectedAssistant;
  set _selectedAssistant(String? value) => _ui.selectedAssistant = value;
  ContactEntity? get _selectedContact => _ui.selectedContact;
  set _selectedContact(ContactEntity? value) => _ui.selectedContact = value;
  TextEditingController get _campaignNameController => _ui.campaignNameController;
  String get _selectedTargetAudienceMode => _ui.selectedTargetAudienceMode;
  set _selectedTargetAudienceMode(String value) => _ui.selectedTargetAudienceMode = value;
  String? get _selectedBulkGroup => _ui.selectedBulkGroup;
  set _selectedBulkGroup(String? value) => _ui.selectedBulkGroup = value;
  String? get _selectedCsvFile => _ui.selectedCsvFile;
  set _selectedCsvFile(String? value) => _ui.selectedCsvFile = value;
  ContactEntity? get _selectedBulkContact => _ui.selectedBulkContact;
  set _selectedBulkContact(ContactEntity? value) => _ui.selectedBulkContact = value;
  String get _selectedScheduleMode => _ui.selectedScheduleMode;
  set _selectedScheduleMode(String value) => _ui.selectedScheduleMode = value;
  DateTime? get _scheduledDateTime => _ui.scheduledDateTime;
  set _scheduledDateTime(DateTime? value) => _ui.scheduledDateTime = value;
  bool get _callingHoursEnabled => _ui.callingHoursEnabled;
  set _callingHoursEnabled(bool value) => _ui.callingHoursEnabled = value;
  bool get _isGroupDropdownExpanded => _ui.isGroupDropdownExpanded;
  set _isGroupDropdownExpanded(bool value) => _ui.isGroupDropdownExpanded = value;
  String get _groupSearchQuery => _ui.groupSearchQuery;
  set _groupSearchQuery(String value) => _ui.groupSearchQuery = value;
  TextEditingController get _groupSearchController => _ui.groupSearchController;

  void _update(VoidCallback action) => _ui.update(action);

  @override
  void dispose() {
    _ui.dispose();
    super.dispose();
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String? get _currentUserId => ref.read(authProvider).maybeWhen(
        authenticated: (user) => user.id,
        orElse: () => null,
      );

  void _selectTargetAudience(String mode) {
    _update(() {
      _hasSelectedTargetAudience = true;
      _selectedTargetAudienceMode = mode;
      if (mode != 'BY GROUP') {
        _selectedBulkGroup = null;
        _isGroupDropdownExpanded = false;
        _groupSearchQuery = '';
        _groupSearchController.clear();
      }
      if (mode != 'BY FILE') _selectedCsvFile = null;
      if (mode != 'SINGLE CONTACT') _selectedBulkContact = null;
    });

    final userId = _currentUserId;
    if (userId == null || userId.isEmpty) return;

    switch (mode) {
      case 'ALL CONTACTS':
      case 'SINGLE CONTACT':
        ref.read(contactsProvider.notifier).fetchContacts(userId: userId);
        break;
      case 'BY GROUP':
        unawaited(ref.refresh(campaignGroupsProvider(userId).future));
        break;
      case 'BY FILE':
        unawaited(ref.refresh(campaignFilesProvider(userId).future));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final outboundState = ref.watch(outboundPhoneNumbersProvider);
    final assistantsState = ref.watch(assistantsProvider);
    final shouldWatchContacts = !_isBulkMode ||
      (_hasSelectedTargetAudience &&
        (_selectedTargetAudienceMode == 'ALL CONTACTS' ||
          _selectedTargetAudienceMode == 'SINGLE CONTACT'));
    final contactsState = shouldWatchContacts
      ? ref.watch(contactsProvider)
      : const ContactsState.initial();
    final startCallState = ref.watch(startCallProvider);
    final bulkCampaignState = ref.watch(bulkCampaignProvider);
    final recentActivityState = ref.watch(recentActivityProvider);

    ref.listen<StartCallState>(startCallProvider, (previous, next) {
      next.maybeWhen(
        success: (message) {
          ToastServices.success('Success', message);
          final authState = ref.read(authProvider);
          final userId = authState.maybeWhen(
            authenticated: (user) => user.id,
            orElse: () => null,
          );
          ref
              .read(recentActivityProvider.notifier)
              .fetchRecentActivity(userId: userId);
        },
        error: (message) {
          ToastServices.error('Error', 'Failed to start call: $message');
        },
        orElse: () {},
      );
    });

    ref.listen<AsyncValue<String>>(bulkCampaignProvider, (previous, next) {
      next.whenOrNull(
        data: (message) {
          if (message.isNotEmpty) {
            ToastServices.success('Success', message);
            ref.read(recentActivityProvider.notifier).fetchRecentActivity(
                  userId: _currentUserId,
                );
          }
        },
        error: (error, _) => ToastServices.error('Error', 'Failed to launch campaign: $error'),
      );
    });

    return AnimatedBuilder(
      animation: _ui,
      builder: (context, _) => Scaffold(
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
              CustomCard(
                child: _buildCallForm(
                  outboundState,
                  assistantsState,
                  contactsState,
                  startCallState,
                  bulkCampaignState,
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
              recentActivityState.when(
                initial: () => Column(
                  children: List.generate(
                    3,
                    (index) => const ActivityListItemShimmer(),
                  ),
                ),
                loading: () => Column(
                  children: List.generate(
                    3,
                    (index) => const ActivityListItemShimmer(),
                  ),
                ),
                error: (message) => Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Column(
                      children: [
                        Text(
                          'Error: $message',
                          style: const TextStyle(
                            color: AppColors.noticeRedText,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            final authState = ref.read(authProvider);
                            final userId = authState.maybeWhen(
                              authenticated: (user) => user.id,
                              orElse: () => null,
                            );
                            ref
                                .read(recentActivityProvider.notifier)
                                .fetchRecentActivity(userId: userId);
                          },
                          child: const Text(
                            'Retry',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.statCardCallsIcon,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                loaded: (activities) {
                  if (activities.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.0),
                        child: Text(
                          'No Campaign History Found',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      for (final activity in activities)
                        Builder(
                          builder: (context) {
                            final initials = _getInitials(activity.contactInfo);
                            final avatarColor = _getAvatarColorsForName(
                              activity.contactInfo,
                            );
                            final dateTimeFormatted = _formatActivityDateTime(
                              activity.dateTime,
                            );
                            final typeString = activity.assistantName
                                .toUpperCase();
                            final subtitle = '$dateTimeFormatted · $typeString';
                            final amount = _formatSpend(
                              activity.costLocal,
                              activity.currency,
                            );

                            final status = activity.status;
                            final Color statusTextColor;
                            final Color statusBgColor;

                            if (status.toLowerCase() == 'completed' ||
                                status.toLowerCase() == 'success' ||
                                status.toLowerCase() == 'positive') {
                              statusTextColor = AppColors.statusPositiveText;
                              statusBgColor = AppColors.mintGreen;
                            } else if (status.toLowerCase() == 'failed' ||
                                status.toLowerCase() == 'cancelled' ||
                                status.toLowerCase() == 'negative') {
                              statusTextColor = AppColors.statusNegativeText;
                              statusBgColor = AppColors.noticeRedBg;
                            } else {
                              statusTextColor = AppColors.statCardAgentsIcon;
                              statusBgColor = AppColors.statCardAgentsBg;
                            }

                            return ActivityListItem(
                              initials: initials,
                              avatarBgColor: avatarColor.bg,
                              avatarTextColor: avatarColor.text,
                              name: activity.contactInfo,
                              subtitle: subtitle,
                              amount: amount,
                              status: status,
                              statusTextColor: statusTextColor,
                              statusBgColor: statusBgColor,
                            );
                          },
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
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
    AsyncValue<String> bulkCampaignState,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SegmentedToggle(
          labels: const ['Single Call', 'Bulk Calls'],
          selectedIndex: _isBulkMode ? 1 : 0,
          onChanged: (index) => _update(() => _isBulkMode = index == 1),
          selectedColor: AppColors.primary,
        ),
        const SizedBox(height: 24),
        if (_isBulkMode) ...[
          _buildBulkCampaignUI(
            outboundState,
            assistantsState,
            contactsState,
            startCallState,
            bulkCampaignState,
          ),
        ] else ...[
          ..._buildSingleFields(outboundState, assistantsState, contactsState),
          const SizedBox(height: 24),
          _buildStartButton(startCallState, assistantsState, contactsState),
        ],
      ],
    );
  }

  List<Widget> _buildSingleFields(
    OutboundPhoneNumbersState state,
    AssistantsState assistantsState,
    ContactsState contactsState,
  ) {
    return [
      // const Text(
      //   'SINGLE TEST CALL',
      //   style: TextStyle(
      //     fontSize: 16,
      //     fontWeight: FontWeight.bold,
      //     color: Color(0xFF0F172A),
      //     letterSpacing: 0.5,
      //   ),
      // ),
      // const SizedBox(height: 4),
      // const Text(
      //   'TEST AN AI ASSISTANT ON A REAL CALL.',
      //   style: TextStyle(
      //     fontSize: 10,
      //     fontWeight: FontWeight.w600,
      //     color: Color(0xFF64748B),
      //     letterSpacing: 0.5,
      //   ),
      // ),
      // const SizedBox(height: 20),

      // 1. Phone Number Field
      _buildFieldLabel(Icons.phone_in_talk_outlined, 'Phone Number'),
      const SizedBox(height: 8),
      state.when(
        initial: () => _buildDropdownFieldShimmer(),
        loading: () => _buildDropdownFieldShimmer(),
        error: (message) => Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.noticeRedBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.priorityHigh),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Error loading numbers: $message',
                style: const TextStyle(color: AppColors.statusNegativeText, fontSize: 13),
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
                    color: AppColors.noticeRedText,
                  ),
                ),
              ),
            ],
          ),
        ),
        loaded: (phoneNumbers) {
          if (phoneNumbers.isEmpty) {
            return _buildEmptyField('No outbound phone numbers configured');
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
              if (val != null) _update(() => _selectedOutbound = val);
            },
          );
        },
      ),
      const SizedBox(height: 16),

      // 2. Assistant Field
      _buildFieldLabel(Icons.radio_button_unchecked_outlined, 'Assistant'),
      const SizedBox(height: 8),
      assistantsState.when(
        initial: () => _buildDropdownFieldShimmer(),
        loading: () => _buildDropdownFieldShimmer(),
        error: (message) => Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.noticeRedBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.noticeRedText.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Error loading assistants: $message',
                style: const TextStyle(
                  color: AppColors.noticeRedText,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: () =>
                    ref.read(assistantsProvider.notifier).fetchAssistants(),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                ),
                child: const Text(
                  'Retry',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.noticeRedText,
                  ),
                ),
              ),
            ],
          ),
        ),
        loaded: (assistants) {
          if (assistants.isEmpty) {
            return _buildEmptyField('No assistants configured');
          }

          // Safe dynamic fallback to avoid build error
          if (_selectedAssistant == null ||
              !assistants.any((item) => item.name == _selectedAssistant)) {
            _selectedAssistant = assistants.first.name;
          } else {
            // Re-match reference
            _selectedAssistant = assistants
                .firstWhere((item) => item.name == _selectedAssistant)
                .name;
          }

          return _buildDropdownField<String>(
            value: _selectedAssistant!,
            items: _buildAssistantItems(assistants),
            onChanged: (val) {
              if (val != null) _update(() => _selectedAssistant = val);
            },
          );
        },
      ),
      const SizedBox(height: 16),

      // 3. Contact Field
      _buildFieldLabel(Icons.people_outline, 'Contact'),
      const SizedBox(height: 8),
      contactsState.when(
        initial: () => _buildDropdownFieldShimmer(),
        loading: () => _buildDropdownFieldShimmer(),
        error: (message) => Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.noticeRedBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.noticeRedText.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Error loading contacts: $message',
                style: const TextStyle(
                  color: AppColors.noticeRedText,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: () =>
                    ref.read(contactsProvider.notifier).fetchContacts(),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                ),
                child: const Text(
                  'Retry',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.noticeRedText,
                  ),
                ),
              ),
            ],
          ),
        ),
        loaded: (contacts) {
          if (contacts.isEmpty) {
            return _buildEmptyField('No contacts configured');
          }

          // Safe dynamic fallback to avoid build error
          if (_selectedContact == null ||
              !contacts.any((item) => item.id == _selectedContact!.id)) {
            _selectedContact = contacts.first;
          } else {
            // Re-match reference
            _selectedContact = contacts.firstWhere(
              (item) => item.id == _selectedContact!.id,
            );
          }

          return _buildDropdownField<ContactEntity>(
            value: _selectedContact!,
            items: _buildContactItems(contacts),
            onChanged: (val) {
              if (val != null) _update(() => _selectedContact = val);
            },
          );
        },
      ),
    ];
  }

  Widget _buildStartButton(
    StartCallState startCallState,
    AssistantsState assistantsState,
    ContactsState contactsState,
  ) {
    final isLoading = startCallState.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );
    final label = isLoading ? 'Starting Call...' : 'Start AI Test Call';
    final icon = Icons.play_arrow_outlined;
    const bgColor = AppColors.primary;

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
        onPressed: isLoading
            ? null
            : () {
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
                String? assistantId;
                assistantsState.maybeWhen(
                  loaded: (assistants) {
                    final match = assistants.firstWhere(
                      (a) => a.name == _selectedAssistant,
                    );
                    assistantId = match.id;
                  },
                  orElse: () {},
                );

                if (assistantId == null) {
                  _showSnack(
                    'Selected assistant database record was not loaded.',
                  );
                  return;
                }

                final authState = ref.read(authProvider);
                final userId = authState.maybeWhen(
                  authenticated: (user) => user.id,
                  orElse: () => null,
                );

                ref
                    .read(startCallProvider.notifier)
                    .startTestCall(
                      assistantId: assistantId!,
                      toNumber: _selectedContact!.phoneNumber,
                      phoneNumberId: _selectedOutbound!.id,
                      contactId: _selectedContact!.id,
                      userId: userId,
                    );
              },
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Icon(icon, size: 20),
        label: Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildBulkCampaignUI(
    OutboundPhoneNumbersState outboundState,
    AssistantsState assistantsState,
    ContactsState contactsState,
    StartCallState startCallState,
    AsyncValue<String> bulkCampaignState,
  ) {
    final authState = ref.watch(authProvider);
    final userId = authState.maybeWhen(
      authenticated: (user) => user.id,
      orElse: () => 'd6e723df-7a48-4710-aa9a-57f32763eb19',
    );
    final groupsAsync = _selectedTargetAudienceMode == 'BY GROUP'
      ? ref.watch(campaignGroupsProvider(userId))
      : const AsyncValue.data(<String>[]);
    final filesAsync = _selectedTargetAudienceMode == 'BY FILE'
      ? ref.watch(campaignFilesProvider(userId))
      : const AsyncValue.data(<String>[]);
    // Calculate Selected Count based on target audience mode
    String selectedCountText = '0 SELECTED';
    contactsState.maybeWhen(
      loaded: (contacts) {
        if (_selectedTargetAudienceMode == 'ALL CONTACTS') {
          selectedCountText = 'ALL CONTACTS';
        } else if (_selectedTargetAudienceMode == 'BY GROUP') {
          if (_selectedBulkGroup != null) {
            final count = contacts
                .where((c) => c.group == _selectedBulkGroup)
                .length;
            selectedCountText = '$count SELECTED';
          } else {
            selectedCountText = '0 SELECTED';
          }
        } else if (_selectedTargetAudienceMode == 'BY FILE') {
          selectedCountText = _selectedCsvFile != null
              ? '100 SELECTED'
              : '0 SELECTED';
        } else if (_selectedTargetAudienceMode == 'SINGLE CONTACT') {
          selectedCountText = _selectedBulkContact != null
              ? '1 SELECTED'
              : '0 SELECTED';
        }
      },
      orElse: () {},
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title & Description
        // const Text(
        //   'NEW BULK CAMPAIGN',
        //   style: TextStyle(
        //     fontSize: 20,
        //     fontWeight: FontWeight.w900,
        //     color: Color(0xFF0F172A),
        //     letterSpacing: 0.5,
        //   ),
        // ),
        // const SizedBox(height: 6),
        // const Text(
        //   'CREATE AN AI BULK CAMPAIGN. CALLS FIRE IN BATCHES; THE NEXT BATCH STARTS ONLY AFTER THE CURRENT BATCH ENDS.',
        //   style: TextStyle(
        //     fontSize: 9,
        //     fontWeight: FontWeight.bold,
        //     color: Color(0xFF64748B),
        //     letterSpacing: 0.5,
        //     height: 1.4,
        //   ),
        // ),
        // const SizedBox(height: 24),

        // Campaign Name Label & Input
        _buildBulkFieldLabel(
          Icons.description_outlined,
          'Campaign Name',
          required: true,
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _campaignNameController,
            style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A)),
            decoration: const InputDecoration(
              hintText: 'e.g. Lead Re-Engagement',
              hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              border: InputBorder.none,
            ),
            onChanged: (val) => _update(() {}),
          ),
        ),
        const SizedBox(height: 20),

        // Assistant dropdown
        _buildBulkFieldLabel(Icons.smart_toy_outlined, 'Assistant'),
        const SizedBox(height: 8),
        assistantsState.when(
          initial: () => _buildDropdownFieldShimmer(),
          loading: () => _buildDropdownFieldShimmer(),
          error: (msg) => _buildErrorBox(msg),
          loaded: (assistants) {
            if (assistants.isEmpty) {
              return _buildEmptyField('No assistants configured');
            }
            if (_selectedAssistant == null ||
                !assistants.any((item) => item.name == _selectedAssistant)) {
              _selectedAssistant = assistants.first.name;
            }
            return _buildDropdownField<String>(
              value: _selectedAssistant!,
              items: _buildAssistantItems(assistants),
              onChanged: (val) {
                if (val != null) _update(() => _selectedAssistant = val);
              },
            );
          },
        ),
        const SizedBox(height: 20),

        // Phone Number dropdown
        _buildBulkFieldLabel(Icons.phone_outlined, 'Phone Number'),
        const SizedBox(height: 8),
        outboundState.when(
          initial: () => _buildDropdownFieldShimmer(),
          loading: () => _buildDropdownFieldShimmer(),
          error: (msg) => _buildErrorBox(msg),
          loaded: (phoneNumbers) {
            if (phoneNumbers.isEmpty) {
              return _buildEmptyField('No outbound phone numbers');
            }
            if (_selectedOutbound == null ||
                !phoneNumbers.any((item) => item.id == _selectedOutbound!.id)) {
              _selectedOutbound = phoneNumbers.first;
            }
            return _buildDropdownField<PhoneNumberEntity>(
              value: _selectedOutbound!,
              items: _buildOutboundItems(phoneNumbers),
              onChanged: (val) {
                if (val != null) _update(() => _selectedOutbound = val);
              },
            );
          },
        ),
        const SizedBox(height: 20),

        // Target Audience Tabs
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildBulkFieldLabel(Icons.people_outline, 'Target Audience'),
            // Selected badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                selectedCountText,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TargetAudienceSelector(
          selectedMode: _selectedTargetAudienceMode,
          onModeSelected: _selectTargetAudience,
        ),
        const SizedBox(height: 12),

        // Dependent inputs based on Target Audience mode
        if (_selectedTargetAudienceMode == 'BY GROUP') ...[
          _buildBulkFieldLabel(Icons.filter_list_outlined, 'Group'),
          const SizedBox(height: 8),
          groupsAsync.when(
            loading: () => _buildDropdownFieldShimmer(),
            error: (err, stack) => _buildErrorBox('Error: $err'),
            data: (groups) {
              if (groups.isEmpty) {
                return _buildEmptyField('No groups available');
              }
              return _buildSearchableGroupDropdown(groups);
            },
          ),
          const SizedBox(height: 20),
        ] else if (_selectedTargetAudienceMode == 'BY FILE') ...[
          _buildBulkFieldLabel(Icons.insert_drive_file_outlined, 'CSV File'),
          const SizedBox(height: 8),
          filesAsync.when(
            loading: () => _buildDropdownFieldShimmer(),
            error: (err, stack) => _buildErrorBox('Error: $err'),
            data: (files) {
              if (files.isEmpty) return _buildEmptyField('No uploaded files available');
              final selectedFile = _selectedCsvFile != null && files.contains(_selectedCsvFile)
                  ? _selectedCsvFile!
                  : files.first;
              if (_selectedCsvFile == null || !files.contains(_selectedCsvFile)) {
                _selectedCsvFile = selectedFile;
              }
              return _buildDropdownField<String>(
                value: selectedFile,
                items: files
                    .map((file) => DropdownMenuItem(value: file, child: Text(file)))
                    .toList(),
                onChanged: (val) => _update(() => _selectedCsvFile = val),
              );
            },
          ),
          const SizedBox(height: 20),
        ] else if (_selectedTargetAudienceMode == 'SINGLE CONTACT') ...[
          _buildBulkFieldLabel(Icons.person_outline, 'Contact'),
          const SizedBox(height: 8),
          contactsState.maybeWhen(
            loaded: (contacts) {
              if (contacts.isEmpty) {
                return _buildEmptyField('No contacts configured');
              }
              return _buildDropdownField<String>(
                value: _selectedBulkContact?.id ?? 'Select contact',
                items: [
                  const DropdownMenuItem(
                    value: 'Select contact',
                    child: Text('Select contact'),
                  ),
                  ...contacts.map(
                    (c) => DropdownMenuItem(
                      value: c.id,
                      child: Text(
                        '${c.firstName} ${c.lastName} (${c.phoneNumber})',
                      ),
                    ),
                  ),
                ],
                onChanged: (val) {
                  if (val != null && val != 'Select contact') {
                    final match = contacts.firstWhere((c) => c.id == val);
                    _update(() => _selectedBulkContact = match);
                  } else {
                    _update(() => _selectedBulkContact = null);
                  }
                },
              );
            },
            orElse: () => _buildDropdownFieldShimmer(),
          ),
          const SizedBox(height: 20),
        ],

        // Schedule Mode
        _buildBulkFieldLabel(Icons.calendar_month_outlined, 'Schedule'),
        const SizedBox(height: 8),
        ScheduleSelector(
          selectedMode: _selectedScheduleMode,
          onModeSelected: (mode) => _update(() => _selectedScheduleMode = mode),
        ),
        const SizedBox(height: 12),

        // Dependent datetime input if Schedule mode is LATER
        if (_selectedScheduleMode == 'LATER') ...[
          InkWell(
            onTap: () => _selectScheduleDateTime(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE2E8F0)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _scheduledDateTime != null
                        ? _formatDateTime(_scheduledDateTime!)
                        : 'Select date and time',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 18,
                    color: Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],

        // Calling hours switch
        CallingHoursCard(
          enabled: _callingHoursEnabled,
          onChanged: (enabled) => _update(() => _callingHoursEnabled = enabled),
        ),
        const SizedBox(height: 24),

        // Bottom launch campaign action button
        _buildBulkLaunchButton(assistantsState, bulkCampaignState),
      ],
    );
  }

  Widget _buildBulkFieldLabel(
    IconData icon,
    String label, {
    bool required = false,
  }) {
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
        if (required) ...[
          const SizedBox(width: 4),
          const Text(
            '*',
            style: TextStyle(color: AppColors.errorRed, fontSize: 13),
          ),
        ],
      ],
    );
  }

  Widget _buildErrorBox(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFCA5A5)),
      ),
      child: Text(
        message,
        style: const TextStyle(color: Color(0xFF991B1B), fontSize: 13),
      ),
    );
  }

  Widget _buildBulkLaunchButton(
    AssistantsState assistantsState,
    AsyncValue<String> bulkCampaignState,
  ) {
    final isNameEmpty = _campaignNameController.text.trim().isEmpty;
    final isLaterMode = _selectedScheduleMode == 'LATER';
    final isLoading = bulkCampaignState.isLoading;
    final buttonLabel = isLaterMode
        ? 'Schedule Campaign'
        : 'Launch Campaign Now';
    final buttonIcon = isLaterMode
        ? Icons.calendar_today_outlined
        : Icons.play_arrow_outlined;
    final buttonBg = isNameEmpty || isLoading
        ? const Color(0xFF94A3B8)
        : AppColors.primary;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonBg,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: isLoading ? null : () {
          if (isNameEmpty) {
            _showSnack('Please enter a campaign name.');
            return;
          }
          if (isLaterMode && _scheduledDateTime == null) {
            _showSnack('Please select a schedule date and time.');
            return;
          }

          final assistantId = assistantsState.maybeWhen(
            loaded: (assistants) => assistants
                .where((assistant) => assistant.name == _selectedAssistant)
                .map((assistant) => assistant.id)
                .firstOrNull,
            orElse: () => null,
          );
          if (assistantId == null) {
            _showSnack('Please select an assistant.');
            return;
          }
          if (_selectedTargetAudienceMode == 'BY GROUP' && _selectedBulkGroup == null) {
            _showSnack('Please select a group.');
            return;
          }
          if (_selectedTargetAudienceMode == 'BY FILE' && _selectedCsvFile == null) {
            _showSnack('Please select a file.');
            return;
          }
          if (_selectedTargetAudienceMode == 'SINGLE CONTACT' && _selectedBulkContact == null) {
            _showSnack('Please select a contact.');
            return;
          }

          final targetType = switch (_selectedTargetAudienceMode) {
            'BY GROUP' => 'group',
            'BY FILE' => 'file',
            'SINGLE CONTACT' => 'single',
            _ => 'all',
          };
          final targetValue = switch (_selectedTargetAudienceMode) {
            'BY GROUP' => _selectedBulkGroup,
            'BY FILE' => _selectedCsvFile,
            'SINGLE CONTACT' => _selectedBulkContact?.id,
            _ => null,
          };
          final userId = _currentUserId;
          if (userId == null) {
            _showSnack('Please sign in before launching a campaign.');
            return;
          }

          ref.read(bulkCampaignProvider.notifier).launch(
                userId: userId,
                name: _campaignNameController.text.trim(),
                assistantId: assistantId,
                phoneNumberId: null,
                defaultLine: 'indian',
                targetType: targetType,
                targetValue: targetValue,
                batchSize: 5,
                runAt: isLaterMode ? _scheduledDateTime : null,
                callWindowEnabled: _callingHoursEnabled,
              );
        },
        icon: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : Icon(buttonIcon, size: 20),
        label: Text(
          isLoading ? 'Launching...' : buttonLabel,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future<void> _selectScheduleDateTime(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _scheduledDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0F172A),
              onPrimary: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      if (!context.mounted) return;
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          _scheduledDateTime ?? DateTime.now(),
        ),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF0F172A),
                onPrimary: Colors.white,
                onSurface: Color(0xFF0F172A),
              ),
            ),
            child: child!,
          );
        },
      );
      if (pickedTime != null) {
        _update(() {
          _scheduledDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  String _formatDateTime(DateTime dt) {
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final year = dt.year;
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$day-$month-$year $hour:$minute';
  }

  Widget _buildSearchableGroupDropdown(List<String> groups) {
    final filteredGroups = groups
        .where((g) => g.toLowerCase().contains(_groupSearchQuery.toLowerCase()))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            _update(() {
              _isGroupDropdownExpanded = !_isGroupDropdownExpanded;
              if (!_isGroupDropdownExpanded) {
                _groupSearchQuery = '';
                _groupSearchController.clear();
              }
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE2E8F0)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedBulkGroup ?? 'Select group',
                  style: TextStyle(
                    fontSize: 14,
                    color: _selectedBulkGroup != null ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
                  ),
                ),
                Icon(
                  _isGroupDropdownExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: const Color(0xFF64748B),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (_isGroupDropdownExpanded) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _groupSearchController,
                    onChanged: (val) {
                      _update(() => _groupSearchQuery = val);
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search...',
                      hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                      prefixIcon: Icon(Icons.search, size: 16, color: Color(0xFF64748B)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                if (filteredGroups.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'No groups found',
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                    ),
                  )
                else
                  Container(
                    constraints: const BoxConstraints(maxHeight: 180),
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: filteredGroups.length,
                      itemBuilder: (context, index) {
                        final group = filteredGroups[index];
                        final isSelected = _selectedBulkGroup == group;
                        return InkWell(
                          onTap: () {
                            _update(() {
                              _selectedBulkGroup = group;
                              _isGroupDropdownExpanded = false;
                              _groupSearchQuery = '';
                              _groupSearchController.clear();
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFF1F5F9) : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  group,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: const Color(0xFF0F172A),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(Icons.check, size: 16, color: Color(0xFF0F172A)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
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
          dropdownColor: Colors.white,
          focusColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
          style: const TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 14,
          ),
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

  List<DropdownMenuItem<ContactEntity>> _buildContactItems(
    List<ContactEntity> contacts,
  ) {
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

  List<DropdownMenuItem<String>> _buildAssistantItems(
    List<AssistantEntity> assistants,
  ) {
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

  Widget _buildEmptyField(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 18, color: Color(0xFF94A3B8)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownFieldShimmer() {
    return Container(
      width: double.infinity,
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.fieldBorderColor),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomShimmer.rectangular(
                width: 80,
                height: 14,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              SizedBox(height: 4),
              CustomShimmer.rectangular(
                width: 120,
                height: 12,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            ],
          ),
          Icon(Icons.keyboard_arrow_down, color: AppColors.fieldBorderColor),
        ],
      ),
    );
  }

  String _getInitials(String contactInfo) {
    final cleanName = contactInfo
        .replaceAll(RegExp(r'\s*\+?\d+\s*'), '')
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .trim();
    if (cleanName.isEmpty) return '??';
    final parts = cleanName.split(RegExp(r'\s+'));
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
  }

  _AvatarColor _getAvatarColorsForName(String name) {
    if (name.isEmpty) return _avatarColors[0];
    final index = name.hashCode.abs() % _avatarColors.length;
    return _avatarColors[index];
  }

  String _formatActivityDateTime(String dateTimeStr) {
    try {
      final dt = DateTime.parse(dateTimeStr).toLocal();
      final now = DateTime.now();
      final hour = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      final minute = dt.minute.toString().padLeft(2, '0');
      final timeStr = '${hour.toString().padLeft(2, '0')}:$minute $period';

      final isToday =
          dt.year == now.year && dt.month == now.month && dt.day == now.day;
      if (isToday) {
        return timeStr;
      } else {
        final months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];
        return '${months[dt.month - 1]} ${dt.day}, $timeStr';
      }
    } catch (_) {
      return '';
    }
  }

  String _formatSpend(double amount, String currency) {
    switch (currency.toUpperCase()) {
      case 'INR':
        return '₹${amount.toStringAsFixed(2)}';
      case 'EUR':
        return '€${amount.toStringAsFixed(2)}';
      case 'GBP':
        return '£${amount.toStringAsFixed(2)}';
      case 'USD':
      default:
        return '\$${amount.toStringAsFixed(2)}';
    }
  }
}

class _AvatarColor {
  final Color bg;
  final Color text;
  const _AvatarColor(this.bg, this.text);
}

const List<_AvatarColor> _avatarColors = [
  _AvatarColor(AppColors.avatarIndigoBg, AppColors.avatarIndigoText),
  _AvatarColor(AppColors.avatarSkyBg, AppColors.avatarSkyText),
  _AvatarColor(AppColors.avatarVioletBg, AppColors.avatarVioletText),
  _AvatarColor(AppColors.noticeRedBg, AppColors.noticeRedText),
];
