import 'package:flutter/material.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/transaction_list_item.dart';

class _TransactionEntry {
  const _TransactionEntry({
    required this.title,
    required this.subtitle,
    required this.amount,
    this.isCredit = false,
  });

  final String title;
  final String subtitle;
  final String amount;
  final bool isCredit;
}

const _transactions = [
  _TransactionEntry(
    title: 'Bulk Campaign — 120 mins',
    subtitle: '07 Jul · TXN-88213',
    amount: '-₹486.50',
  ),
  _TransactionEntry(
    title: 'Single AI Call — Rohan Deshmukh',
    subtitle: '06 Jul · TXN-88190',
    amount: '-₹4.20',
  ),
  _TransactionEntry(
    title: 'Manual Voice — Ayesha Khan',
    subtitle: '06 Jul · TXN-88177',
    amount: '-₹12.80',
  ),
  _TransactionEntry(
    title: 'Wallet Recharge',
    subtitle: '05 Jul · TXN-88160',
    amount: '+₹2000.00',
    isCredit: true,
  ),
  _TransactionEntry(
    title: 'Bulk Campaign — 340 mins',
    subtitle: '05 Jul · TXN-88142',
    amount: '-₹1372.15',
  ),
  _TransactionEntry(
    title: 'Number Rental — +91 22 6900 4410',
    subtitle: '04 Jul · TXN-88101',
    amount: '-₹199.00',
  ),
  _TransactionEntry(
    title: 'Single AI Call — Karan Mehta',
    subtitle: '03 Jul · TXN-88090',
    amount: '-₹6.05',
  ),
];

const _quickAmounts = [500, 2000, 5000];

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final _amountController = TextEditingController(text: '2000');
  final _searchController = TextEditingController();
  String _searchQuery = '';

  static const _balance = '₹4,230.5';

  @override
  void dispose() {
    _amountController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  List<_TransactionEntry> get _filteredTransactions {
    if (_searchQuery.isEmpty) return _transactions;
    final query = _searchQuery.toLowerCase();
    return _transactions
        .where(
          (t) =>
              t.title.toLowerCase().contains(query) ||
              t.subtitle.toLowerCase().contains(query),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Wallet & Logs',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.black),
              ),
              const SizedBox(height: 16),
              _buildBalanceCard(),
              const SizedBox(height: 20),
              CustomCard(child: _buildQuickRecharge()),
              const SizedBox(height: 24),
              const Text(
                'Consumption Logs',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black),
              ),
              const SizedBox(height: 12),
              _buildSearchField(),
              const SizedBox(height: 12),
              _buildTransactionList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6D28D9), Color(0xFF4F46E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Balance',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          const Text(
            _balance,
            style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Auto low-balance alerts below ₹500',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 12),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () => _showSnack('Opening recharge options…'),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Recharge Wallet', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickRecharge() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Recharge',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            for (var i = 0; i < _quickAmounts.length; i++) ...[
              if (i != 0) const SizedBox(width: 10),
              Expanded(child: _buildAmountChip(_quickAmounts[i])),
            ],
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.account_balance_wallet_outlined, size: 18, color: AppColors.grey),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => setState(() {}),
                        style: const TextStyle(fontSize: 15, color: AppColors.black, fontWeight: FontWeight.w500),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => _showSnack('Paying ₹${_amountController.text}…'),
              icon: const Icon(Icons.credit_card, size: 18),
              label: const Text('Pay', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAmountChip(int amount) {
    final isSelected = _amountController.text == amount.toString();
    return GestureDetector(
      onTap: () => setState(() => _amountController.text = amount.toString()),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0)),
        ),
        child: Center(
          child: Text(
            '₹$amount',
            style: TextStyle(
              color: isSelected ? AppColors.primary : AppColors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 20, color: AppColors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              style: const TextStyle(fontSize: 14, color: AppColors.black),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
                hintText: 'Search transactions',
                hintStyle: TextStyle(color: AppColors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    final transactions = _filteredTransactions;
    if (transactions.isEmpty) {
      return CustomCard(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: const Center(
          child: Text('No transactions found.', style: TextStyle(color: AppColors.grey, fontSize: 13)),
        ),
      );
    }
    return CustomCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < transactions.length; i++) ...[
            TransactionListItem(
              title: transactions[i].title,
              subtitle: transactions[i].subtitle,
              amount: transactions[i].amount,
              isCredit: transactions[i].isCredit,
            ),
            if (i != transactions.length - 1) const Divider(height: 1, color: Color(0xFFF1F5F9)),
          ],
        ],
      ),
    );
  }
}
