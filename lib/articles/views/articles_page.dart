import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:william_gosal_test/articles/bloc/articles_bloc.dart';
import 'package:william_gosal_test/articles/views/articles_list.dart';

class ArticlesPage extends StatelessWidget {
  const ArticlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Artikel')),
      body: BlocProvider(
        create: (_) => ArticlesBloc(httpClient: http.Client())..add(ArticlesFetched()),
        child: const ArticlesList(),
      ),
    );
  }
}
