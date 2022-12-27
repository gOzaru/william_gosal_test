// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:william_gosal_test/articles/bloc/articles_bloc.dart';
import 'package:william_gosal_test/articles/widgets/article_list_item.dart';
import 'package:william_gosal_test/articles/widgets/bottom_loader.dart';

class ArticlesList extends StatefulWidget {
  const ArticlesList({super.key});

  @override
  State<ArticlesList> createState() => _ArticlesListState();
}

class _ArticlesListState extends State<ArticlesList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticlesBloc, ArticlesState>(
      builder: (context, state) {
        switch (state.status) {
          case Status.failure:
            return const Center(child: Text('Gagal loading data dari API'));
          case Status.success:
            if (state.blog.isEmpty) {
              return const Center(child: Text('Tidak ada artikel'));
            }
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                if (state.isMax) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Anda sudah berada pada record terakhir'),
                    ),
                  );
                  return ArticleListItem(blog: state.blog[index]);
                } else {
                  if (index >= state.blog.length) {
                    return const BottomLoader();
                  } else {
                    return ArticleListItem(blog: state.blog[index]);
                  }
                }
              },
              itemCount: state.isMax ? state.blog.length : state.blog.length + 1,
              controller: _scrollController,
            );
          case Status.initial:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<ArticlesBloc>().add(ArticlesFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
