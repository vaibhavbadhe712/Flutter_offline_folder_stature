import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../widgets/activity_list_item.dart';

final timeframeProvider = StateProvider<String>((ref) => '7 Days');

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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
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
                    const Text(
                      'Good afternoon',
                      style: TextStyle(
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
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildStatCard(
                    icon: Icons.phone_in_talk_outlined,
                    iconColor: const Color(0xFF4F46E5),
                    iconBgColor: const Color(0xFFEEF2FF),
                    title: 'Voice Calls Made',
                    value: '1,284',
                    subtext: '8,940 min total',
                  ),
                  _buildStatCard(
                    icon: Icons.credit_card_outlined,
                    iconColor: const Color(0xFF10B981),
                    iconBgColor: const Color(0xFFECFDF5),
                    title: 'Amount Spent',
                    value: '₹18,430',
                    subtext: 'All campaigns',
                  ),
                  _buildStatCard(
                    icon: Icons.smart_toy_outlined,
                    iconColor: const Color(0xFFF59E0B),
                    iconBgColor: const Color(0xFFFEF3C7),
                    title: 'AI Calls',
                    value: '946',
                    subtext: '73.6% connection',
                  ),
                ],
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
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ActivityListItem(
                  initials: 'RD',
                  avatarBgColor: const Color(0xFFE0E7FF),
                  avatarTextColor: const Color(0xFF4F46E5),
                  name: 'Rohan Deshmukh',
                  subtitle: '10:42 AM · AI Call',
                  amount: '₹4.20',
                  status: 'Positive',
                  statusTextColor: const Color(0xFF059669),
                  statusBgColor: const Color(0xFFD1FAE5),
                ),
                ActivityListItem(
                  initials: 'AK',
                  avatarBgColor: const Color(0xFFF3E8FF),
                  avatarTextColor: const Color(0xFF9333EA),
                  name: 'Ayesha Khan',
                  subtitle: '10:15 AM · Manual',
                  amount: '₹12.80',
                  status: 'Neutral',
                  statusTextColor: const Color(0xFFD97706),
                  statusBgColor: const Color(0xFFFEF3C7),
                ),
                ActivityListItem(
                  initials: 'VN',
                  avatarBgColor: const Color(0xFFFEE2E2),
                  avatarTextColor: const Color(0xFFDC2626),
                  name: 'Vikram Nair',
                  subtitle: '09:58 AM · AI Call',
                  amount: '₹2.10',
                  status: 'Negative',
                  statusTextColor: const Color(0xFFB91C1C),
                  statusBgColor: const Color(0xFFFEE2E2),
                ),
                ActivityListItem(
                  initials: 'PS',
                  avatarBgColor: const Color(0xFFE0F2FE),
                  avatarTextColor: const Color(0xFF0284C7),
                  name: 'Priya Sharma',
                  subtitle: '09:30 AM · AI Call',
                  amount: '₹6.75',
                  status: 'Positive',
                  statusTextColor: const Color(0xFF059669),
                  statusBgColor: const Color(0xFFD1FAE5),
                ),
                ActivityListItem(
                  initials: 'KM',
                  avatarBgColor: const Color(0xFFE0F8E8),
                  avatarTextColor: const Color(0xFF16A34A),
                  name: 'Karan Mehta',
                  subtitle: '09:02 AM · Manual',
                  amount: '₹18.40',
                  status: 'Neutral',
                  statusTextColor: const Color(0xFFD97706),
                  statusBgColor: const Color(0xFFFEF3C7),
                ),
                ActivityListItem(
                  initials: 'SP',
                  avatarBgColor: const Color(0xFFEDE9FE),
                  avatarTextColor: const Color(0xFF6D28D9),
                  name: 'Sneha Patil',
                  subtitle: '08:47 AM · AI Call',
                  amount: '₹3.60',
                  status: 'Positive',
                  statusTextColor: const Color(0xFF059669),
                  statusBgColor: const Color(0xFFD1FAE5),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String value,
    required String subtext,
  }) {
    return Container(
      width: 156,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtext,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

}
