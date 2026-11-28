import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';

import '../models/transaction_model.dart';

class TransactionItemCard extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TransactionItemCard({
    super.key,
    required this.transaction,
    this.onTap,
    this.onDelete,
  });

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final bool isIncome = transaction.categoryType == 'income';
    final createdAt = DateTime.tryParse(transaction.createdAt ?? '');
    final date = createdAt == null
        ? null
        : DateFormat('dd/MM/yyyy').format(createdAt.toLocal());

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isIncome
                ? Colors.green.withValues(alpha: 0.1)
                : Colors.red.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isIncome ? Icons.arrow_downward : Icons.arrow_upward,
            color: isIncome ? Colors.green : Colors.red,
          ),
        ),
        title: Text(
          transaction.categoryName ?? 'Transaksi',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (transaction.description != null &&
                transaction.description!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                transaction.description!,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (date != null) ...[
              const SizedBox(height: 2),
              Text(
                date,
                style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
              ),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${isIncome ? "+ " : "- "}${_formatCurrency(transaction.amount)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: isIncome ? Colors.green : Colors.red,
              ),
            ),
            if (onDelete != null)
              IconButton(
                tooltip: 'Hapus transaksi',
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
