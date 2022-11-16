import 'package:flutter/material.dart';
import '../../domain/models/share.dart';
import 'selected_share.dart';

class FavoriteShareCard extends StatefulWidget {
  final Share share;

  const FavoriteShareCard({super.key, required this.share});

  @override
  State<FavoriteShareCard> createState() => _FavoriteShareCardState();
}

class _FavoriteShareCardState extends State<FavoriteShareCard> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const FlutterLogo(),
      title: Text(
        widget.share.shortname,
        style: const TextStyle(
          fontSize: 22,
        ),
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            '${widget.share.price!.toStringAsFixed(2)} ${widget.share.currency}',
            style: const TextStyle(fontSize: 21),
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SelectSharePage(
                    share: widget.share,
                  )),
        );
      },
    );
  }
}
