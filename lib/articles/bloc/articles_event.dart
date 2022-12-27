part of 'articles_bloc.dart';

abstract class ArticlesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ArticlesFetched extends ArticlesEvent {}
