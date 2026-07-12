import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../state/auth_state.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/utils/toast_services/toast_services.dart';
import '../../../../core/utils/constants/app_colors.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _phoneFormKey = GlobalKey<FormState>();
  final _emailFormKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  int _selectedTab = 0; // 0 = Phone OTP, 1 = Email
  bool _registerBusiness = false;
  bool _obscurePassword = true;
  String _currentLanguage = 'English';
  bool _isMockLoading = false;

  void _switchTab(int tab) {
    if (_selectedTab == tab) return;
    setState(() {
      _selectedTab = tab;
      _fullNameController.clear();
      _phoneController.clear();
      _emailController.clear();
      _passwordController.clear();
      _phoneFormKey.currentState?.reset();
      _emailFormKey.currentState?.reset();
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _getCleanedPhoneNumber(String val) {
    final cleaned = val.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length > 10) {
      // If it contains country code like 91, strip it or take last 10 digits
      return '+91 ${cleaned.substring(cleaned.length - 10)}';
    }
    return '+91 $cleaned';
  }

  void _submitPhoneSignup() async {
    if (_phoneFormKey.currentState?.validate() ?? false) {
      final phone = _phoneController.text.trim();
      final fullPhoneNumber = _getCleanedPhoneNumber(phone);
      
      // Call the existing OTP flow
      final success = await ref.read(authProvider.notifier).sendOtp(fullPhoneNumber);
      if (success && mounted) {
        context.push('${AppRoutes.verifyOtp}?phone=${Uri.encodeComponent(fullPhoneNumber)}');
      }
    }
  }

  void _submitEmailSignup() async {
    if (_emailFormKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      final name = _fullNameController.text.trim();
      final phone = _phoneController.text.trim();

      final success = await ref.read(authProvider.notifier).signUp(
        email: email,
        password: password,
        name: name,
        phone: phone,
      );

      if (success && mounted) {
        ToastServices.success('Success', 'Account created successfully! Please log in.');
        context.go(AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      next.maybeWhen(
        error: (message) {
          ToastServices.error('Error', message);
        },
        orElse: () {},
      );
    });

    final authState = ref.watch(authProvider);
    final isAuthLoading = authState.maybeWhen(loading: () => true, orElse: () => false);
    final isLoading = isAuthLoading || _isMockLoading;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: _buildLanguageDropdown(),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              
              // Bot Icon & Name
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.indigo,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.indigo.withValues(alpha: 0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: const Icon(
                        Icons.smart_toy_rounded,
                        color: AppColors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'BAAP AI',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppColors.darkSlate,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Titles
              const Text(
                'Create your account',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkSlate,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Start automating calls in minutes',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.greyText,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Toggle tabs
              _buildTabBar(),
              
              const SizedBox(height: 24),
              
              _selectedTab == 0 ? _buildPhoneForm(isLoading) : _buildEmailForm(isLoading),
              
              const SizedBox(height: 20),
              
              _buildBusinessCheckbox(),
              
              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : (_selectedTab == 0 ? _submitPhoneSignup : _submitEmailSignup),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.indigo,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded, size: 20),
                          ],
                        ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Log In Option Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(fontSize: 14, color: AppColors.greyText),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.push(AppRoutes.login);
                      }
                    },
                    child: const Text(
                      'Log in',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.indigo,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.cultured,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _switchTab(0),
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: _selectedTab == 0 ? AppColors.white : AppColors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: _selectedTab == 0
                      ? [
                          BoxShadow(
                            color: AppColors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                child: Text(
                  'Phone OTP',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _selectedTab == 0 ? AppColors.indigo : AppColors.greyText,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _switchTab(1),
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: _selectedTab == 1 ? AppColors.white : AppColors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: _selectedTab == 1
                      ? [
                          BoxShadow(
                            color: AppColors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                child: Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _selectedTab == 1 ? AppColors.indigo : AppColors.greyText,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneForm(bool isLoading) {
    return Form(
      key: _phoneFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full Name Input
          TextFormField(
            controller: _fullNameController,
            keyboardType: TextInputType.name,
            enabled: !isLoading,
            style: const TextStyle(color: AppColors.darkSlate, fontSize: 15),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.iconGrey),
              hintText: 'Full name',
              hintStyle: const TextStyle(color: AppColors.iconGrey),
              filled: true,
              fillColor: AppColors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.lightGrey, width: 1.5),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.lightGrey, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.indigo, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.errorRed, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.errorRed, width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your full name';
              }
              if (value.trim().length < 2) {
                return 'Name must be at least 2 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          // Phone Input
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            enabled: !isLoading,
            style: const TextStyle(color: AppColors.darkSlate, fontSize: 15),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.phone_android_rounded, color: AppColors.iconGrey),
              hintText: '+91 98765 43210',
              hintStyle: const TextStyle(color: AppColors.iconGrey),
              filled: true,
              fillColor: AppColors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.lightGrey, width: 1.5),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.lightGrey, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.indigo, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.errorRed, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.errorRed, width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your phone number';
              }
              final clean = value.replaceAll(RegExp(r'\D'), '');
              if (clean.length != 10) {
                return 'Phone number must be exactly 10 digits';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          const Text(
            'A 6-digit OTP will be sent via SMS for verification.',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.greyText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailForm(bool isLoading) {
    return Form(
      key: _emailFormKey,
      child: Column(
        children: [
          // Full Name Input
          TextFormField(
            controller: _fullNameController,
            keyboardType: TextInputType.name,
            enabled: !isLoading,
            style: const TextStyle(color: AppColors.darkSlate, fontSize: 15),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.iconGrey),
              hintText: 'Full name',
              hintStyle: const TextStyle(color: AppColors.iconGrey),
              filled: true,
              fillColor: AppColors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.lightGrey, width: 1.5),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.lightGrey, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.indigo, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.errorRed, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.errorRed, width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your full name';
              }
              if (value.trim().length < 2) {
                return 'Name must be at least 2 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          // Email Input
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            enabled: !isLoading,
            style: const TextStyle(color: AppColors.darkSlate, fontSize: 15),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.mail_outline_rounded, color: AppColors.iconGrey),
              hintText: 'you@company.com',
              hintStyle: const TextStyle(color: AppColors.iconGrey),
              filled: true,
              fillColor: AppColors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.lightGrey, width: 1.5),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.lightGrey, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.indigo, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.errorRed, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.errorRed, width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your email address';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          // Phone Input
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            enabled: !isLoading,
            style: const TextStyle(color: AppColors.darkSlate, fontSize: 15),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.phone_android_rounded, color: AppColors.iconGrey),
              hintText: 'Phone number',
              hintStyle: const TextStyle(color: AppColors.iconGrey),
              filled: true,
              fillColor: AppColors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.lightGrey, width: 1.5),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.lightGrey, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.indigo, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.errorRed, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.errorRed, width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your phone number';
              }
              final clean = value.replaceAll(RegExp(r'\D'), '');
              if (clean.length != 10) {
                return 'Phone number must be exactly 10 digits';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          // Password Input
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            enabled: !isLoading,
            style: const TextStyle(color: AppColors.darkSlate, fontSize: 15),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.iconGrey),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: AppColors.iconGrey,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
              hintText: 'Password',
              hintStyle: const TextStyle(color: AppColors.iconGrey),
              filled: true,
              fillColor: AppColors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.lightGrey, width: 1.5),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.lightGrey, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.indigo, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.errorRed, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.errorRed, width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters long';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessCheckbox() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _registerBusiness = !_registerBusiness;
        });
      },
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.scaffoldBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _registerBusiness ? AppColors.indigo : AppColors.lightGreyColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(6),
                color: _registerBusiness ? AppColors.indigo : AppColors.transparent,
              ),
              child: _registerBusiness
                  ? const Icon(
                      Icons.check,
                      size: 14,
                      color: AppColors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            const Text(
              'Register your Business',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.darkSlate,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.lightGrey),
        borderRadius: BorderRadius.circular(20),
      ),
      child: PopupMenuButton<String>(
        onSelected: (String value) {
          setState(() {
            _currentLanguage = value;
          });
          ToastServices.info('Language Changed', 'Language switched to $value');
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(value: 'English', child: Text('English')),
          const PopupMenuItem<String>(value: 'Marathi', child: Text('Marathi')),
          const PopupMenuItem<String>(value: 'Hindi', child: Text('Hindi')),
        ],
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _currentLanguage,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.greyText,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.greyText,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
