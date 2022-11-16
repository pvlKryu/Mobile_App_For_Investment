// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:flutter/material.dart';
import '../../domain/models/transaction_data.dart';
import '../custom_theme.dart';

sellShare(BuildContext context, widget) {
  final TextEditingController _controller = TextEditingController();

  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      titlePadding: const EdgeInsets.all(10),
      title: Card(
        color: AppColors.fontWhite,
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: AppColors.fontBlack, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ListTile(
            title: Text(
              '${widget.share.shortname} -  ${widget.share.price} ${widget.share.currency}',
              style: const TextStyle(color: AppColors.fontBlack),
            ),
          ),
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.fromLTRB(5, 2, 2, 5),
        child: TextField(
          controller: _controller,
          style: const TextStyle(color: AppColors.alertInfoTextFolder),
          decoration: InputDecoration(
            fillColor: AppColors.fontWhite,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                  color: AppColors.alertInfoTextFolder, width: 1),
            ),
            labelText: 'Введите количество лотов',
          ),
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                int? amount = int.tryParse(_controller.text);
                TransactionData transaction =
                    TransactionData(widget.share.figi, amount);
                Navigator.pop(context, transaction);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(AppColors.fontWhite),
              ),
              child: const Text(
                'Продать',
                style: (TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.normal,
                  color: AppColors.fontBlack,
                )),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
