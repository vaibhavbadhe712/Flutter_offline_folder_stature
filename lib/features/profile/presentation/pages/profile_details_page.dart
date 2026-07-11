import 'package:flutter/material.dart';
import 'package:enterprise_app/features/widgets/profile_widgets.dart';
import '../../../../core/utils/constants/app_colors.dart';

class ProfileDetailsPage extends StatefulWidget {
  final ProfileUser user;
  final Future<void> Function(ProfileUser updatedUser) onSave;
  final Future<void> Function(String newNumber) onSendOtp;

  const ProfileDetailsPage({
    super.key,
    required this.user,
    required this.onSave,
    required this.onSendOtp,
  });

  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.fullName);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    setState(() => _saving = true);
    final updated = widget.user.copyWith(fullName: _nameController.text.trim());
    await widget.onSave(updated);
    if (mounted) setState(() => _saving = false);
  }

  void _openChangeNumberSheet() {
    ChangeNumberSheet.show(context, onSendOtp: widget.onSendOtp);
  }

  @override
  Widget build(BuildContext context) {
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
          'Profile Details',
          style: TextStyle(color: AppColors.darkText, fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabeledField(
                      label: 'FULL NAME',
                      icon: Icons.person_outline,
                      controller: _nameController,
                      hint: 'Full name',
                    ),
                    const SizedBox(height: 16),
                    LabeledField(
                      label: 'EMAIL',
                      icon: Icons.mail_outline,
                      controller: _emailController,
                      readOnly: true,
                    ),
                    const SizedBox(height: 16),
                    LabeledField(
                      label: 'VERIFIED PHONE NUMBER',
                      icon: Icons.phone_iphone,
                      controller: _phoneController,
                      readOnly: true,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        if (widget.user.isPhoneVerified)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.mintGreen,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle, size: 14, color: AppColors.emeraldGreen),
                                SizedBox(width: 4),
                                Text(
                                  'Verified',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.emeraldGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: _openChangeNumberSheet,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.greyText,
                            side: const BorderSide(color: AppColors.lightGreyColor),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          ),
                          child: const Text('Change', style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton(label: 'Save Changes', loading: _saving, onPressed: _handleSave),
            ],
          ),
        ),
      ),
    );
  }
}