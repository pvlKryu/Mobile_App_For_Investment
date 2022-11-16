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
      trailing: Text(
        '${share.price ?? 'Нет данных'} ${share.currency}',
        style: const TextStyle(fontSize: 21),
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
