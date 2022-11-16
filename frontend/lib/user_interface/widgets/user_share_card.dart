import 'package:flutter/material.dart';
import '../../domain/models/share.dart';
import '../custom_theme.dart';
import 'selected_share.dart';

class UserShareCard extends StatelessWidget {
  final Share share;

  const UserShareCard({super.key, required this.share});

  @override
  Widget build(BuildContext context) {
    final profit = (share.profit! * 100.0);

    return ListTile(
      leading: const FlutterLogo(),
      title: Text(
        share.shortname,
        style: const TextStyle(
          fontSize: 22,
        ),
      ),
      subtitle:
          Text('${share.amount} шт.', style: const TextStyle(fontSize: 18)),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${share.price ?? 'Нет данных'} ${share.currency}',
            style: const TextStyle(fontSize: 21),
          ),
          Text('${(share.profit! * 100.0).toStringAsFixed(2)} %',
              style: TextStyle(
                fontSize: 19,
                color: (profit < 0
                    ? AppColors.redBalanceAmount
                    : AppColors.greenBalanceAmount),
              )),
        ],
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
