import 'package:flutter/material.dart';

class AddTributoForm extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController avatarCtrl;
  final int distritoSel;
  final String generoSel;
  final ValueChanged<int> onDistritoChanged;
  final ValueChanged<String> onGeneroChanged;
  final VoidCallback onRegister;
  const AddTributoForm({
    Key? key,
    required this.nameCtrl,
    required this.avatarCtrl,
    required this.distritoSel,
    required this.generoSel,
    required this.onDistritoChanged,
    required this.onGeneroChanged,
    required this.onRegister,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Agregar Tributo',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nombre')),
            const SizedBox(height: 10),
            TextField(
                controller: avatarCtrl,
                decoration: const InputDecoration(labelText: 'URL (opcional)')),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<int>(
                    value: distritoSel,
                    items: List.generate(
                        12,
                        (i) => DropdownMenuItem(
                            value: i + 1, child: Text('D${i + 1}'))),
                    onChanged: (v) => onDistritoChanged(v ?? 1)),
                DropdownButton<String>(
                    value: generoSel,
                    items: const [
                      DropdownMenuItem(value: 'M', child: Text('M')),
                      DropdownMenuItem(value: 'F', child: Text('F'))
                    ],
                    onChanged: (v) => onGeneroChanged(v ?? 'M')),
                ElevatedButton.icon(
                    icon: const Icon(Icons.person_add),
                    label: const Text('Registrar'),
                    onPressed: onRegister)
              ],
            )
          ],
        ),
      ),
    );
  }
}
