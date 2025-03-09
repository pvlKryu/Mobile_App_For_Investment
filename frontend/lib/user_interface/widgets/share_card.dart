import 'package:flutter/material.dart';
import '../../domain/models/share.dart';
import 'selected_share.dart';

class ShareCard extends StatelessWidget {
  final Share share;

  const ShareCard({super.key, required this.share});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const FlutterLogo(),
      title: Text(
        share.shortname,
        style: const TextStyle(
          fontSize: 22,
        ),
      ),
      trailing: (share.price != '')
          ? Text(
              '${double.parse((share.price)!.toStringAsFixed(2)) ?? 'Нет данных'} ${share.currency}',
              style: const TextStyle(fontSize: 21),
            )
          : const Text(
              ' Нет данных',
              style: TextStyle(fontSize: 21),
            ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SelectSharePage(
                    share: share,
                  )),
        );
      },
    );
  }
}
