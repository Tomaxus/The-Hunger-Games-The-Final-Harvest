import 'package:flutter/material.dart';
import '../models/tributo.dart';

class TributoCard extends StatelessWidget {
  final Tributo tributo;
  final bool eliminado;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const TributoCard({
    Key? key,
    required this.tributo,
    this.eliminado = false,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).cardColor,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            SizedBox(
              width: 44,
              height: 44,
              child: ClipOval(
                child: tributo.avatar.isNotEmpty
                    ? Image.network(
                        tributo.avatar,
                        width: 10,
                        height: 10,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: eliminado
                              ? Theme.of(context).colorScheme.secondary
                              : const Color(0xFFB36B00),
                          child: const Icon(Icons.person,
                              color: Colors.white, size: 16),
                        ),
                      )
                    : Container(
                        color: eliminado
                            ? Theme.of(context).colorScheme.secondary
                            : const Color(0xFFB36B00),
                        child: const Icon(Icons.person,
                            color: Colors.white, size: 16),
                      ),
              ),
            ),
            const SizedBox(width: 1),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    tributo.nombre,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                  if (eliminado)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        '(Eliminado)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.9),
                            fontWeight: FontWeight.w600,
                            fontSize: 12),
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text('Distrito ${tributo.distrito}',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints.tightFor(width: 28, height: 28),
                    icon: const Icon(Icons.edit, size: 16),
                    onPressed: onEdit),
                IconButton(
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints.tightFor(width: 28, height: 28),
                    icon: Icon(Icons.delete,
                        size: 16,
                        color: Theme.of(context).colorScheme.secondary),
                    onPressed: onDelete),
              ],
            )
          ],
        ),
      ),
    );
  }
}
