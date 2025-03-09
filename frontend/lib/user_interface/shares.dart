import 'package:flutter/material.dart';
import '../domain/models/share.dart';
import 'widgets/share_card.dart';

class Shares extends StatefulWidget {
  final List<Share> shares;
  const Shares({Key? key, required this.shares}) : super(key: key);

  @override
  State<Shares> createState() => _SharesState();
}

class _SharesState extends State<Shares> {
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    bool sorting = false;
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {},
                child: const Text('Сортировка'),
              ),
              const Spacer(),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  sorting = true;
                  widget.shares
                      .sort((a, b) => a.price!.compareTo(b.price!));
                  sorting = false;
                },
                child: const Text('По цене'),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  sorting = true;
                  widget.shares
                      .sort((a, b) => a.shortname.compareTo(b.shortname));
                  sorting = false;
                },
                child: const Text('По названию'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: widget.shares.length,
              itemBuilder: (BuildContext context, int index) {
                return ShareCard(share: widget.shares[index]);
              }),
        ),
      ],
    );
  }
}
