import 'package:flutter/material.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../calls/domain/entities/contact_entity.dart';
import '../../../calls/presentation/state/contacts_state.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/custom_shimmer.dart';

class DialerContactsView extends StatelessWidget {
  const DialerContactsView({
    super.key,
    required this.contactsState,
    required this.isCalling,
    required this.onCall,
    required this.onRetry,
  });

  final ContactsState contactsState;
  final bool isCalling;
  final ValueChanged<String> onCall;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return contactsState.when(
      initial: _buildContactsShimmer,
      loading: _buildContactsShimmer,
      error: (message) => CustomCard(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Error loading contacts: $message',
                style: const TextStyle(
                  color: AppColors.noticeRedText,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      loaded: (contacts) => _buildContactsList(contacts),
    );
  }

  Widget _buildContactsList(List<ContactEntity> contacts) {
    if (contacts.isEmpty) {
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
          for (var i = 0; i < contacts.length; i++) ...[
            _ContactRow(
              contact: contacts[i],
              index: i,
              isCalling: isCalling,
              onCall: onCall,
            ),
            if (i != contacts.length - 1)
              const Divider(height: 1, color: AppColors.whiteColor),
          ],
        ],
      ),
    );
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
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.contact,
    required this.index,
    required this.isCalling,
    required this.onCall,
  });

  final ContactEntity contact;
  final int index;
  final bool isCalling;
  final ValueChanged<String> onCall;

  @override
  Widget build(BuildContext context) {
    final initials =
        ((contact.firstName.isNotEmpty ? contact.firstName[0] : '') +
                (contact.lastName.isNotEmpty ? contact.lastName[0] : ''))
            .toUpperCase();
    final fullName = '${contact.firstName} ${contact.lastName}'.trim();
    final nameToShow = fullName.isEmpty ? 'Unknown Contact' : fullName;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: _getAvatarBgColor(index),
            child: Text(
              initials.isEmpty ? '?' : initials,
              style: TextStyle(
                color: _getAvatarTextColor(index),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nameToShow,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
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
              onTap: isCalling ? null : () => onCall(contact.phoneNumber),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.phone_outlined,
                  size: 18,
                  color: AppColors.greenColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getAvatarBgColor(int index) {
    const colors = [
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
    const colors = [
      AppColors.avatarIndigoText,
      AppColors.avatarSkyText,
      AppColors.avatarVioletText,
      AppColors.noticeYellowText,
      AppColors.noticeRedText,
      AppColors.emeraldGreen,
    ];
    return colors[index % colors.length];
  }
}
