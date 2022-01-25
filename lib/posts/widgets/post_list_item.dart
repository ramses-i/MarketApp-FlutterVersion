import 'package:flutter/material.dart';
import 'package:market_app/posts/posts.dart';

class PostListItem extends StatelessWidget {
  const PostListItem({Key? key, required this.post}) : super(key: key);

  //final Post post;
  final Item post;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
        child: Card(
      child: ListTile(
        minVerticalPadding: 20,
        leading: Image.network(
          post.thumbnail,
          width: 100,
          height: 400,
          fit: BoxFit.fill,
        ),
        title: Text(post.shortTitle),
        isThreeLine: true,
        subtitle: Text('${post.price} ${post.currencyId}'),
        dense: true,
      ),
    ));
  }
}
