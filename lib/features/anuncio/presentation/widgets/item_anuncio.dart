import 'package:flutter/material.dart';
import '../../domain/entities/anuncio_entity.dart';

class ItemAnuncio extends StatelessWidget {
  final AnuncioEntity anuncio;
  final VoidCallback? onTapItem;
  final VoidCallback? onPressedRemover;

  const ItemAnuncio({
    super.key,
    required this.anuncio,
    this.onTapItem,
    this.onPressedRemover,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapItem,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: anuncio.fotos.isNotEmpty
                    ? Image.network(
                        anuncio.fotos[0],
                        fit: BoxFit.cover,
                      )
                    : Container(color: Colors.grey),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        anuncio.titulo ?? "",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text("R\$ ${anuncio.preco}"),
                    ],
                  ),
                ),
              ),
              if (onPressedRemover != null)
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: onPressedRemover,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
