import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';
import 'package:william_gosal_test/articles/models/article.dart';

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
  final http.Client httpClient;

  ArticlesBloc({required this.httpClient}) : super(const ArticlesState()) {
    on<ArticlesFetched>(
      _onFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  Future<void> _onFetched(ArticlesFetched event, Emitter<ArticlesState> emit) async {
    if (state.isMax) {
      //Artikel habis
      return;
    } else {
      //Artikel masih ada.
      try {
        if (state.status == Status.initial) {
          /*
            Saat status bernilai awal, panggil artikel dari API menggunakan metode _fetchArticles().
            Jika berhasil, ubah status pada ArticlesState menggunakan emit.
          */
          final blogs = await _fetchArticles();
          return emit(
            state.copyWith(
              status: Status.success,
              blog: blogs,
              isMax: false,
            ),
          );
        } else {
          /*
            Setelah sukses panggil artikel, cek apakah jumlah artikel pada API telah kosong atau belum
            Jika kosong, maka nilai variabel isMax menjadi true
            Jika belum, maka nilainya tetap false
          */
          final blogs = await _fetchArticles(state.blog.length);
          if (blogs.isEmpty) {
            return emit(state.copyWith(isMax: true));
          } else {
            return emit(
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
    //Panggil lokasi url API menggunakan httpClient
    final response = await httpClient.get(
      Uri.https(
        'jsonplaceholder.typicode.com',
        '/posts',
        <String, String>{'_start': '$startIndex', '_limit': '$_limit'},
      ),
    );
    /*
      Jika API berhasil dipanggil (kode 200), maka gunakan hasil respons sebagai variabel List 
      Variabel tersebut perlu dipetakan isinya yang berupa json menggunakan map((){}).toList. Jika gagal, tampilkan
      Exception.
    */
    if (response.statusCode == 200) {
      //Berhasil
      final body = json.decode(response.body) as List;
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
