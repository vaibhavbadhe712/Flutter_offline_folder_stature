import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../providers/dialer_calls_provider.dart';

class RecentCallsList extends StatelessWidget {
  const RecentCallsList({
    super.key,
    required this.state,
    required this.onRefresh,
  });

  final AsyncValue<List<DialerCall>> state;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent calls',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.darkSlate,
              ),
            ),
            IconButton(
              tooltip: 'Refresh recent calls',
              icon: const Icon(Icons.refresh, size: 20),
              onPressed: onRefresh,
            ),
          ],
        ),
        Expanded(
          child: state.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: Text(
                'Could not load recent calls.\n$error',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.noticeRedText),
              ),
            ),
            data: (calls) {
              if (calls.isEmpty) {
                return const Center(
                  child: Text(
                    'No recent calls',
                    style: TextStyle(color: AppColors.greyText),
                  ),
                );
              }
              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: calls.length,
                separatorBuilder: (_, _) => const Divider(
                  height: 1,
                  color: AppColors.fieldBorderColor,
                ),
                itemBuilder: (context, index) {
                  final call = calls[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 2),
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primaryLight,
                      child: Icon(
                        call.status.toLowerCase().contains('fail')
                            ? Icons.phone_missed_outlined
                            : Icons.phone_outlined,
                        color: AppColors.primary,
                      ),
                    ),
                    title: Text(
                      call.toNumber,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkText,
                      ),
                    ),
                    subtitle: Text(
                      '${call.status}  •  ${_formatCallDuration(call.durationSeconds)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.slateGray,
                      ),
                    ),
                    trailing: Text(
                      _formatCallTime(call.startedAt),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.slateGray,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatCallTime(String value) {
    final time = DateTime.tryParse(value)?.toLocal();
    if (time == null) return '';
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute ${time.hour >= 12 ? 'PM' : 'AM'}';
  }

  String _formatCallDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '${minutes}m ${remainingSeconds}s';
  }
}
