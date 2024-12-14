import 'package:flutter/material.dart';

class JokeCard extends StatelessWidget {
  final String type;

  const JokeCard({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/jokes_list', arguments: type);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 4),
              blurRadius: 8.0,
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          leading: CircleAvatar(
            backgroundColor: Colors.redAccent,
            child: Icon(
              Icons.tag,
              color: Colors.white,
            ),
          ),
          title: Text(
            type,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.redAccent,
          ),
        ),
      ),
    );
  }
}
