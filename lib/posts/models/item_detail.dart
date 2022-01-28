import 'package:equatable/equatable.dart';
import 'package:market_app/posts/models/models.dart';

class ItemDetail extends Equatable {
  const ItemDetail(
      {required this.id,
      required this.shortTitle,
      required this.title,
      required this.secureThumbnail,
      required this.price,
      required this.currencyId,
      required this.pictures});

  final String id;
  final String title;
  final String shortTitle;
  final String secureThumbnail;
  final String price;
  final String currencyId;
  final List<dynamic> pictures;

  @override
  List<Object> get props =>
      [id, title, shortTitle, secureThumbnail, price, currencyId, pictures];
}
