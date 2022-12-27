part of 'articles_bloc.dart';

//Status loading dari API
enum Status { initial, success, failure }

class ArticlesState extends Equatable {
  const ArticlesState({
    this.status = Status.initial,
    this.blog = const <Article>[],
    this.isMax = false,
  });

  final Status status;
  final List<Article> blog;
  final bool isMax;

  //copyWith berfungsi memetakan elemen variabel lama dari class ArticlesState ke elemen baru
  ArticlesState copyWith({
    Status? status,
    List<Article>? blog,
    bool? isMax,
  }) {
    return ArticlesState(
      status: status ?? this.status,
      blog: blog ?? this.blog,
      isMax: isMax ?? this.isMax,
    );
  }

  @override
  String toString() {
    return '''Article status: $status, isMax: $isMax, total: ${blog.length} }''';
  }

  @override
  List<Object> get props => [status, blog, isMax];
}
