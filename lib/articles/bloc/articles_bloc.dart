import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';
import 'package:william_gosal_test/articles/models/articles.dart';

part 'articles_event.dart';
part 'articles_state.dart';

const _limit = 20;
const throttleDuration = Duration(milliseconds: 100);

//Abaikan event yang tak penting
EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {
  ArticlesBloc({required this.httpClient}) : super(const ArticlesState()) {
    on<ArticlesFetched>(
      _onFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final http.Client httpClient;

  Future<void> _onFetched(
    ArticlesFetched event,
    Emitter<ArticlesState> emit,
  ) async {
    if (state.isMax) {
      //Artikel habis
      return;
    } else {
      //Artikel masih ada
      try {
        if (state.status == Status.initial) {
          //Saat awal panggil artikel dari API 
          final blogs = await _fetchArticles();
          //Output data menggunakan emit
          return emit(
            state.copyWith(
              status: Status.success,
              blog: blogs,
              isMax: false,
            ),
          );
        } else {
          //Setelah sukses panggil artikel, cek apakah jumlah artikel pada API telah kosong atau belum
          final blogs = await _fetchArticles(state.blog.length);
          if (blogs.isEmpty) {
            //Artikel kosong, maka nilai variabel isMax menjadi true
            emit(state.copyWith(isMax: true));
          } else {
            //Artikel masih ada, maka variabel isMax tetap bernilai false
            emit(
              state.copyWith(
                status: Status.success,
                blog: List.of(state.blog)..addAll(blogs),
                isMax: false,
              ), 
            );
          }
        }
      } catch (_) {
        //Jika terjadi error, maka ubah status menjadi Error
        emit(state.copyWith(status: Status.failure));
      }
    }
  }

  Future<List<Article>> _fetchArticles([int startIndex = 0]) async {
    //Panggil API melalui httpClient
    final response = await httpClient.get(
      Uri.https(
        'jsonplaceholder.typicode.com',
        '/posts',
        <String, String>{'_start': '$startIndex', '_limit': '$_limit'},
      ),
    );
    if (response.statusCode == 200) {
      //API berhasil dipanggil
      final body = json.decode(response.body) as List; //Body's response dipanggil sebagai variabel List
      return body.map((dynamic json) {
        final map = json as Map<String, dynamic>;
        return Article(
          id: map['id'] as int,
          title: map['title'] as String,
          body: map['body'] as String,
        );
      }).toList();
    } else {
      //Gagal
      throw Exception('Gagal mengambil artikel');
    }
  }
}
