import 'package:flutter/material.dart';
import 'package:william_gosal_test/articles/models/articles.dart';

class ArticleListItem extends StatelessWidget {
  const ArticleListItem({super.key, required this.blog});

  final Article blog;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Card(elevation: 4.0, child: 
        Row(
          children: [
            Text('${blog.id}', style: const TextStyle(fontSize: 30)), 
            Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                Text(blog.title, style: const TextStyle(fontSize: 20),),
                Text(blog.body, style: const TextStyle(fontSize: 20),),
              ],
            )
          ],
        )
      ),
    );
  }
}