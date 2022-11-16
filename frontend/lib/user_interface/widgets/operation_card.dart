import 'package:firstflutterproj/domain/models/operation.dart';
import 'package:flutter/material.dart';
import '../../domain/models/operation.dart';
import '../custom_theme.dart';

class OperationCard extends StatelessWidget {
  final Operation operation;

  const OperationCard({super.key, required this.operation});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const FlutterLogo(),
      title: Text(
        operation.shortname,
        style: const TextStyle(
          fontSize: 22,
        ),
      ),
      subtitle: Text('${operation.type.toString()} - ${operation.amount} шт.',
          style: const TextStyle(fontSize: 18)),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "${(operation.price * operation.amount).toStringAsFixed(2)} ₽",
            style: const TextStyle(fontSize: 21),
          ),
          Text(
            operation.date,
            style: const TextStyle(
                fontSize: 18,
                color: AppColors.alertInfoTextFolder,
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
