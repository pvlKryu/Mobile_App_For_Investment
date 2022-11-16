import 'package:flutter/material.dart';
import '../domain/models/share.dart';
import '../domain/repository/portfolio_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/favorite_share_card.dart';
import 'widgets/no_data.dart';
class FavoritesPage extends StatelessWidget {
  final List<Share> favorites;
  const FavoritesPage(
      {super.key,
      required this.favorites});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => PortfolioBloc(context.read()),
        child: Favorites(
             favorites: favorites));
  }
}




class Favorites extends StatefulWidget {
  final List<Share> favorites;
  const Favorites({Key? key, required this.favorites}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    if (widget.favorites.isEmpty) {
      return noData(context, "Избранное", "У Вас нет избранных акций");
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Избранное",
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Сортировка",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    )),
                Padding(
                  padding: EdgeInsets.only(left: 80),
                  child: Text("По цене",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Text("По названию",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: widget.favorites.length,
                itemBuilder: (BuildContext context, int index) {
                  return FavoriteShareCard(share: widget.favorites[index]);
                }),
          ),
        ],
      ),
    );
  }
}
