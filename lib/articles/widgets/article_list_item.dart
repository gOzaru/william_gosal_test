import 'package:flutter/material.dart';
import 'package:william_gosal_test/articles/models/article.dart';

class ArticleListItem extends StatelessWidget {
  const ArticleListItem({super.key, required this.blog});

  final Article blog;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 0, 7.0, 12.0),
        child: Card(
            elevation: 4.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: 50,
                    height: 50,
                    child: Center(
                      child: Text(
                        '${blog.id}',
                        style: const TextStyle(fontSize: 27),
                      ),
                    )),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(3.0, 0, 3.0, 6.0),
                        child: Text(
                          blog.title,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(3.0, 0, 3.0, 6.0),
                        child: Text(
                          blog.body,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
