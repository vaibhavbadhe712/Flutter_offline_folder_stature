import 'package:flutter/material.dart';
import '../../core/utils/constants/app_colors.dart';

class ProfileUser {
  final String fullName;
  final String email;
  final String phone;
  final bool isPhoneVerified;

  const ProfileUser({
    required this.fullName,
    required this.email,
    required this.phone,
    this.isPhoneVerified = true,
  });

  ProfileUser copyWith({
    String? fullName,
    String? email,
    String? phone,
    bool? isPhoneVerified,
  }) {
    return ProfileUser(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
    );
  }
}

class LabeledField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final String? hint;
  final bool readOnly;
  final TextInputType keyboardType;

  const LabeledField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    this.hint,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryBlue,
                letterSpacing: 0.4,
              ),
            ),
          ),
        TextField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: keyboardType,
          style: TextStyle(
            fontSize: 14,
            color: readOnly ? AppColors.greyText : AppColors.darkText,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 18, color: AppColors.iconGrey),
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.iconGrey, fontSize: 14),
            filled: readOnly,
            fillColor: AppColors.scaffoldBg,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
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
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: loading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white),
              )
            : Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class ChangeNumberSheet extends StatefulWidget {
  final Future<void> Function(String newNumber) onSendOtp;

  const ChangeNumberSheet({super.key, required this.onSendOtp});

  static Future<void> show(
    BuildContext context, {
    required Future<void> Function(String newNumber) onSendOtp,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ChangeNumberSheet(onSendOtp: onSendOtp),
    );
  }

  @override
  State<ChangeNumberSheet> createState() => _ChangeNumberSheetState();
}

class _ChangeNumberSheetState extends State<ChangeNumberSheet> {
  final _numberController = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  Future<void> _handleSendOtp() async {
    final number = _numberController.text.trim();
    if (number.isEmpty) return;
    setState(() => _sending = true);
    await widget.onSendOtp(number);
    if (mounted) {
      setState(() => _sending = false);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.lightGreyColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Verify New Number',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.darkText),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20, color: AppColors.iconGrey),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            "Enter your new phone number and we'll send an OTP to verify it.",
            style: TextStyle(fontSize: 13, color: AppColors.primaryBlue, height: 1.4),
          ),
          const SizedBox(height: 16),
          LabeledField(
            label: '',
            icon: Icons.phone_iphone,
            controller: _numberController,
            hint: '+91 new number',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          PrimaryButton(label: 'Send OTP', loading: _sending, onPressed: _handleSendOtp),
        ],
      ),
    );
  }
}