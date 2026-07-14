import 'package:go_router/go_router.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/utils/toast_services/toast_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/utils/constants/app_colors.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    final String name = authState.maybeWhen(
      authenticated: (user) => user.name,
      orElse: () => '',
    );
    final String email = authState.maybeWhen(
      authenticated: (user) => user.email,
      orElse: () => '',
    );
    final String firstLetter = name.isNotEmpty ? name[0].toUpperCase() : 'U';

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 24,
        title: const Text(
          'More',
          style: TextStyle(
            color: AppColors.darkText,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.noticeYellowBg, // Custom Yellow background
                  child: Text(
                    firstLetter,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.noticeYellowText, // Custom Gold text
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.greyText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // First White Card (Options)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.scaffoldBg, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blackColor.withValues(alpha: 0.02),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildOptionItem(
                    icon: Icons.person_outline_rounded,
                    title: 'Profile Details',
                    subtitle: 'Name, email, verified phone',
                    onTap: () {
                      context.push(AppRoutes.profileDetails);
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildOptionItem(
                    icon: Icons.tune_rounded,
                    title: 'AI Agent Settings',
                    subtitle: 'Model, knowledge base, intents',
                    onTap: () {
                      context.push(AppRoutes.aiAgentSettings);
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildOptionItem(
                    icon: Icons.call_outlined,
                    title: 'Number Marketplace',
                    subtitle: 'Browse & buy virtual numbers',
                    onTap: () {
                      context.push(AppRoutes.numberMarketplace);
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildOptionItem(
                    icon: Icons.settings_outlined,
                    title: 'Carrier Routing',
                    subtitle: 'Telecom provider priority',
                    onTap: () {
                      context.push(AppRoutes.carrierRouting);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Second White Card (Logout)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.scaffoldBg, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blackColor.withValues(alpha: 0.02),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          'Log out?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkText,
                          ),
                        ),
                        content: const Text(
                          'Are you sure you want to log out from your account?',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.greyText,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              ref.read(authProvider.notifier).logout();
                              ToastServices.success('Success', 'Logged out successfully');
                            },
                            child: const Text(
                              'Log out',
                              style: TextStyle(
                                color: AppColors.errorRed,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.noticeRedBg, // Custom Red background
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.logout_rounded,
                        color: AppColors.errorRed, // Custom Red icon
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Log out',
                      style: TextStyle(
                        color: AppColors.errorRed, // Custom Red text
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Row(
        children: [
          // Icon Container
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.skyBlueColor, // Custom Sky Blue background
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryBlue, // Custom Blue icon
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          // Texts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.darkText,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.greyText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.lightGrey, 
            size: 22,
          ),
        ],
      ),
    );
  }
}
