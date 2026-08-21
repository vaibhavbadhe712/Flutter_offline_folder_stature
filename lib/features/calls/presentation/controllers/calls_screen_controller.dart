import 'package:flutter/material.dart';

import '../../domain/entities/contact_entity.dart';
import '../../domain/entities/phone_number_entity.dart';

class CallsUiController extends ChangeNotifier {
  bool isBulkMode = false;
  bool hasSelectedTargetAudience = false;
  PhoneNumberEntity? selectedOutbound;
  String? selectedAssistant;
  ContactEntity? selectedContact;
  final campaignNameController = TextEditingController();
  String selectedTargetAudienceMode = 'ALL CONTACTS';
  String? selectedBulkGroup;
  String? selectedCsvFile;
  ContactEntity? selectedBulkContact;
  String selectedScheduleMode = 'LAUNCH NOW';
  DateTime? scheduledDateTime;
  bool callingHoursEnabled = false;
  bool isGroupDropdownExpanded = false;
  String groupSearchQuery = '';
  final groupSearchController = TextEditingController();

  void update(VoidCallback action) {
    action();
    notifyListeners();
  }

  @override
  void dispose() {
    campaignNameController.dispose();
    groupSearchController.dispose();
    super.dispose();
  }
}
