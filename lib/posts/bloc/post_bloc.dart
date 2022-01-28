import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:market_app/posts/posts.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';

part 'post_event.dart';

part 'post_state.dart';

const _postLimit = 20;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc({required this.httpClient}) : super(const PostState()) {
    on<PostFetched>(
      _onPostFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final http.Client httpClient;

  Future<void> _onPostFetched(
    PostFetched event,
    Emitter<PostState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == PostStatus.initial) {
        //final posts = await _fetchPosts();
        final posts = await _fetchItems();
        return emit(state.copyWith(
          status: PostStatus.success,
          posts: posts,
          hasReachedMax: false,
        ));
      }
      //final posts = await _fetchPosts(state.posts.length);
      final posts = await _fetchItems(state.posts.length);
      posts.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: PostStatus.success,
                posts: List.of(state.posts)..addAll(posts),
                hasReachedMax: false,
              ),
            );
    } catch (_) {
      emit(state.copyWith(status: PostStatus.failure));
    }
  }

  Future<List<Item>> _fetchItems([int startIndex = 0]) async {
    final response = await httpClient.get(
      Uri.https('api.mercadolibre.com', '/sites/MLU/search', {'q': 'notebook'}),
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body)['results'] as List;
      return body.map((dynamic json) {
        return Item(
            id: json['id'] as String,
            shortTitle: json['title'].toString().split(',')[0],
            title: json['title'] as String,
            thumbnail: json['thumbnail'] as String,
            price: json['price'].toString(),
            currencyId: json['currency_id'] as String);
      }).toList();
    }
    throw Exception('error fetching posts');
  }

  Future<ItemDetail> _fetchItemDetail(String itemID,
      [int startIndex = 0]) async {
    final response = await httpClient.get(
      Uri.https('api.mercadolibre.com', '/items/$itemID}'),
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return ItemDetail(
          id: body['id'] as String,
          shortTitle: body['title'].toString().split(',')[0],
          title: body['title'] as String,
          secureThumbnail: body['secure_thumbnail'] as String,
          price: body['price'].toString(),
          currencyId: body['currency_id'] as String,
          pictures: body['pictures'] as List<dynamic>);
    }
    throw Exception('error fetching item');
  }
}
