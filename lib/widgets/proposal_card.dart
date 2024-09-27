import 'package:flutter/material.dart';

class ProposalCard extends StatelessWidget {
  final String title;
  final String description;
  final String name;
  final String lastName;
  final int likes;
  final VoidCallback onLike;
  final bool? showLike;

  const ProposalCard({
    super.key,
    required this.title,
    required this.description,
    required this.name,
    required this.lastName,
    required this.likes,
    required this.onLike,
    this.showLike = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título y descripción de la propuesta
            ListTile(
              title: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(description),
            ),
            // Información del usuario (nombre y apellido)
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Nombre: ',
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: '$name $lastName',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Botón de "like" y contador de "likes"
            if (showLike == true) ...[
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: onLike,
                        icon: Icon(
                          Icons.favorite,
                          size: 30,
                          color: likes == 0 ? Colors.grey : Colors.redAccent,
                        ),
                      ),
                      Text('$likes'),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
