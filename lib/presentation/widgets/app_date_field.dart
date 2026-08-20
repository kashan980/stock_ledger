import 'package:flutter/material.dart';

class AppDateField extends StatelessWidget {
  final DateTime date;
  final String label;
  final VoidCallback onTap;
  final String? errorText;

  const AppDateField({
    super.key,
    required this.date,
    required this.label,
    required this.onTap,
    this.errorText,
  });

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day/$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          errorText: errorText,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _formatDate(date),
            ),
            const Icon(
              Icons.calendar_today,
            ),
          ],
        ),
      ),
    );
  }
}