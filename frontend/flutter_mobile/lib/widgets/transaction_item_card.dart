import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionItemCard extends StatelessWidget {
  final String categoryName;
  final String categoryType; // 'income' atau 'expense'
  final double amount;
  final String? description;
  final String? date;
  final VoidCallback onTap;

  const TransactionItemCard({
    Key? key,
    required this.categoryName,
    required this.categoryType,
    required this.amount,
    this.description,
    this.date,
    required this.onTap,
  }) : super(key: key);

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final bool isIncome = categoryType == 'income';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isIncome ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isIncome ? Icons.arrow_downward : Icons.arrow_upward,
            color: isIncome ? Colors.green : Colors.red,
          ),
        ),
        title: Text(
          categoryName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (description != null && description!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                description!,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (date != null) ...[
              const SizedBox(height: 2),
              Text(
                date!,
                style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
              ),
            ],
          ],
        ),
        trailing: Text(
          '${isIncome ? "+ " : "- "}${_formatCurrency(amount)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: isIncome ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }
}