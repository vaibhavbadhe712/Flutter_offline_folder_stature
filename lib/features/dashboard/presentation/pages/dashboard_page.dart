import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../widgets/activity_list_item.dart';
import '../../../widgets/custom_shimmer.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../providers/dashboard_metrics_provider.dart';
import '../providers/recent_activity_provider.dart';



class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final selectedTimeframe = ref.watch(timeframeProvider);
    final timeframes = ['Today', '7 Days', '30 Days', 'Custom'];

    final userName = authState.maybeWhen(
      authenticated: (user) => user.name,
      orElse: () => 'Rao',
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FC),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, color: Color(0xFF334155), size: 26),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final authState = ref.read(authProvider);
          final userId = authState.maybeWhen(
            authenticated: (user) => user.id,
            orElse: () => null,
          );
          await Future.wait([
            ref.read(dashboardMetricsProvider.notifier).fetchMetrics(userId: userId),
            ref.read(recentActivityProvider.notifier).fetchRecentActivity(userId: userId),
          ]);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Greeting & Wallet Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getGreeting(),
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        userName,
                        style: const TextStyle(
                          color: Color(0xFF0F172A),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // Wallet chip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.account_balance_wallet_outlined, color: Color(0xFF4F46E5), size: 20),
                        const SizedBox(width: 6),
                        const Text(
                          '₹4,230.5',
                          style: TextStyle(
                            color: Color(0xFF1E293B),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFF4F46E5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add, color: Colors.white, size: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Timeframe Segmented Selector
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: timeframes.map((timeframe) {
                    final isSelected = selectedTimeframe == timeframe;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          ref.read(timeframeProvider.notifier).state = timeframe;
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Center(
                            child: Text(
                              timeframe,
                              style: TextStyle(
                                color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFF64748B),
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // Stat Cards Horizontal List
              SizedBox(
                height: 152,
                child: ref.watch(dashboardMetricsProvider).when(
                  initial: () => _buildStatCardsLoadingShimmer(),
                  loading: () => _buildStatCardsLoadingShimmer(),
                  error: (message) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: $message',
                          style: const TextStyle(color: AppColors.errorRed, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        TextButton(
                          onPressed: () => ref.read(dashboardMetricsProvider.notifier).fetchMetrics(),
                          child: const Text('Retry', style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                  loaded: (metrics) {
                    final formattedSpend = _formatSpend(metrics.totalSpendLocal, metrics.currency);

                    return ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _buildStatCard(
                          icon: Icons.phone_outlined,
                          iconColor: AppColors.statCardCallsIcon,
                          iconBgColor: AppColors.statCardCallsBg,
                          title: 'Total Calls',
                          value: '${metrics.totalCalls}',
                        ),
                        _buildStatCard(
                          icon: Icons.smart_toy_outlined,
                          iconColor: AppColors.statCardAgentsIcon,
                          iconBgColor: AppColors.statCardAgentsBg,
                          title: 'Active Agents',
                          value: '${metrics.activeAssistants}',
                        ),
                        _buildStatCard(
                          icon: Icons.access_time_outlined,
                          iconColor: AppColors.statCardMinutesIcon,
                          iconBgColor: AppColors.statCardMinutesBg,
                          title: 'Total Minutes',
                          value: '${metrics.totalMinutes.toInt()}',
                        ),
                        _buildStatCard(
                          icon: _getCurrencyIcon(metrics.currency),
                          iconColor: AppColors.statCardSpendIcon,
                          iconBgColor: AppColors.statCardSpendBg,
                          title: 'Total Spend',
                          value: formattedSpend,
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Recent Activity Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Activity',
                    style: TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'View all',
                      style: TextStyle(
                        color: Color(0xFF4F46E5),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // List of Activities
              ref.watch(recentActivityProvider).when(
                initial: () => Column(
                  children: List.generate(3, (index) => const ActivityListItemShimmer()),
                ),
                loading: () => Column(
                  children: List.generate(3, (index) => const ActivityListItemShimmer()),
                ),
                error: (message) => Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Column(
                      children: [
                        Text(
                          'Error: $message',
                          style: const TextStyle(color: Color(0xFFDC2626), fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => ref.read(recentActivityProvider.notifier).fetchRecentActivity(),
                          child: const Text('Retry', style: TextStyle(fontSize: 12, color: Color(0xFF4F46E5))),
                        ),
                      ],
                    ),
                  ),
                ),
                loaded: (activities) {
                  if (activities.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 32.0),
                        child: Text(
                          'No recent activity found',
                          style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      final activity = activities[index];
                      final initials = _getInitials(activity.contactInfo);
                      final avatarColor = _getAvatarColorsForName(activity.contactInfo);
                      final dateTimeFormatted = _formatActivityDateTime(activity.dateTime);
                      final typeString = activity.assistantName.toUpperCase();
                      final subtitle = '$dateTimeFormatted · $typeString';
                      final amount = _formatSpend(activity.costLocal, activity.currency);
                      
                      final status = activity.status;
                      final Color statusTextColor;
                      final Color statusBgColor;
                      
                      if (status.toLowerCase() == 'completed' || status.toLowerCase() == 'success' || status.toLowerCase() == 'positive') {
                        statusTextColor = AppColors.statusPositiveText;
                        statusBgColor = AppColors.mintGreen;
                      } else if (status.toLowerCase() == 'failed' || status.toLowerCase() == 'cancelled' || status.toLowerCase() == 'negative') {
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
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCurrencyIcon(String currency) {
    switch (currency.toUpperCase()) {
      case 'INR':
        return Icons.currency_rupee_outlined;
      case 'EUR':
        return Icons.euro_outlined;
      case 'GBP':
        return Icons.currency_pound_outlined;
      case 'USD':
      default:
        return Icons.attach_money_outlined;
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

  Widget _buildStatCard({
    IconData? icon,
    String? title,
    String? value,
    Color iconColor = AppColors.statCardIconDefault,
    Color iconBgColor = AppColors.statCardIconBgDefault,
    String subtext = '',
    bool isLoading = false,
  }) {
    return Container(
      width: 172,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.statCardBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: isLoading
          ? const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomShimmer.rectangular(
                      width: 70,
                      height: 14,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    CustomShimmer.rectangular(
                      width: 36,
                      height: 36,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ],
                ),
                Spacer(),
                CustomShimmer.rectangular(
                  width: 90,
                  height: 28,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.statCardTitle,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: iconBgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Icon(icon, color: iconColor, size: 20),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  value ?? '',
                  style: const TextStyle(
                    color: AppColors.statCardValue,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtext.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtext,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.statCardTitle,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
    );
  }

  Widget _buildStatCardsLoadingShimmer() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      itemBuilder: (context, index) => _buildStatCard(isLoading: true),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good afternoon';
    } else if (hour >= 17 && hour < 22) {
      return 'Good evening';
    } else {
      return 'Good night';
    }
  }

  String _getInitials(String contactInfo) {
    final cleanName = contactInfo.replaceAll(RegExp(r'\s*\+?\d+\s*'), '').replaceAll(RegExp(r'[^\w\s]'), '').trim();
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
      
      final isToday = dt.year == now.year && dt.month == now.month && dt.day == now.day;
      if (isToday) {
        return timeStr;
      } else {
        final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        return '${months[dt.month - 1]} ${dt.day}, $timeStr';
      }
    } catch (_) {
      return '';
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
