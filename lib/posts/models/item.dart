import 'package:equatable/equatable.dart';

class Item extends Equatable {
  const Item(
      {required this.id,
      required this.shortTitle,
      required this.title,
      required this.thumbnail,
      required this.price,
      required this.currencyId});

  final String id;
  final String title;
  final String shortTitle;
  final String thumbnail;
  final String price;
  final String currencyId;

  @override
  List<Object> get props =>
      [id, title, shortTitle, thumbnail, price, currencyId];
}
