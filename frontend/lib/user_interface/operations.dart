import 'package:firstflutterproj/domain/models/operation.dart';
import 'package:flutter/material.dart';
import '../domain/models/operation.dart';
import 'widgets/no_data.dart';
import 'widgets/operation_card.dart';

class Operations extends StatelessWidget {
  final List<Operation> operations;
  const Operations({Key? key, required this.operations}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (operations.isEmpty) {
      return noData(context, "Операции", "У Вас совершенных операций");
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Операции",
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                itemCount: operations.length,
                itemBuilder: (BuildContext context, int index) {
                  return OperationCard(operation: operations[index]);
                }),
          ),
        ],
      ),
    );
  }
}
