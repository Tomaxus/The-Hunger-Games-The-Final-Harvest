import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/tributo.dart';
import 'simulacion_screen.dart';
import '../widgets/tributo_card.dart';
import '../widgets/add_tributo_form.dart';
import '../widgets/custom_app_bar.dart';

class GestionScreen extends StatefulWidget {
  const GestionScreen({super.key});

  @override
  GestionScreenState createState() => GestionScreenState();
}

class GestionScreenState extends State<GestionScreen> {
  final ApiService api = ApiService();

  // Controladores para el formulario manual
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController avatarCtrl = TextEditingController();

  int distritoSel = 1;
  String generoSel = 'M';
  String tonoSel = 'Dramático';

  List<Tributo> lista = [];
  bool cargando = false;

  @override
  void initState() {
    super.initState();
    cargarYValidar();
  }

  // Carga tributos y si está vacía, carga los predeterminados
  void cargarYValidar() async {
    setState(() {
      cargando = true;
    });
    try {
      var t = await api.obtenerTributos();
      // Si no hay tributos, cargar automáticamente los predeterminados
      if (t.isEmpty) {
        await registrarTributosPredeterminados();
      } else {
        if (!mounted) return;
        setState(() {
          lista = t;
          cargando = false;
        });
      }
    } catch (e) {
      setState(() {
        cargando = false;
      });
      debugPrint("Error al cargar: $e");
    }
  }

  // Carga los tributos desde el backend
  void cargar() async {
    setState(() {
      cargando = true;
    });
    try {
      var t = await api.obtenerTributos();
      if (!mounted) return;
      setState(() {
        lista = t;
        cargando = false;
      });
    } catch (e) {
      setState(() {
        cargando = false;
      });
      debugPrint("Error al cargar: $e");
    }
  }

  // FUNCIÓN PARA PRECARGAR LOS 20 TRIBUTOS POR DEFECTO (RF-001/REGLA DE NEGOCIO)
  Future<void> registrarTributosPredeterminados() async {
    final List<Map<String, dynamic>> predeterminados = [
      {
        'nombre': 'Katniss Everdeen',
        'distrito': 12,
        'genero': 'F',
        'avatar': 'https://i.pravatar.cc/150?img=10'
      },
      {
        'nombre': 'Peeta Mellark',
        'distrito': 12,
        'genero': 'M',
        'avatar': 'https://i.pravatar.cc/150?img=11'
      },
      {
        'nombre': 'Cato',
        'distrito': 2,
        'genero': 'M',
        'avatar': 'https://i.pravatar.cc/150?img=12'
      },
      {
        'nombre': 'Clove',
        'distrito': 2,
        'genero': 'F',
        'avatar': 'https://i.pravatar.cc/150?img=13'
      },
      {
        'nombre': 'Marvel',
        'distrito': 1,
        'genero': 'M',
        'avatar': 'https://i.pravatar.cc/150?img=14'
      },
      {
        'nombre': 'Glimmer',
        'distrito': 1,
        'genero': 'F',
        'avatar': 'https://i.pravatar.cc/150?img=15'
      },
      {
        'nombre': 'Finnick Odair',
        'distrito': 4,
        'genero': 'M',
        'avatar': 'https://i.pravatar.cc/150?img=16'
      },
      {
        'nombre': 'Annie Cresta',
        'distrito': 4,
        'genero': 'F',
        'avatar': 'https://i.pravatar.cc/150?img=17'
      },
      {
        'nombre': 'Thresh',
        'distrito': 11,
        'genero': 'M',
        'avatar': 'https://i.pravatar.cc/150?img=18'
      },
      {
        'nombre': 'Rue',
        'distrito': 11,
        'genero': 'F',
        'avatar': 'https://i.pravatar.cc/150?img=19'
      },
      {
        'nombre': 'Foxface',
        'distrito': 5,
        'genero': 'F',
        'avatar': 'https://i.pravatar.cc/150?img=20'
      },
      {
        'nombre': 'Beetee Latier',
        'distrito': 3,
        'genero': 'M',
        'avatar': 'https://i.pravatar.cc/150?img=21'
      },
      {
        'nombre': 'Wiress',
        'distrito': 3,
        'genero': 'F',
        'avatar': 'https://i.pravatar.cc/150?img=22'
      },
      {
        'nombre': 'Johanna Mason',
        'distrito': 7,
        'genero': 'F',
        'avatar': 'https://i.pravatar.cc/150?img=23'
      },
      {
        'nombre': 'Blight',
        'distrito': 7,
        'genero': 'M',
        'avatar': 'https://i.pravatar.cc/150?img=24'
      },
      {
        'nombre': 'Gloss',
        'distrito': 1,
        'genero': 'M',
        'avatar': 'https://i.pravatar.cc/150?img=25'
      },
      {
        'nombre': 'Cashmere',
        'distrito': 1,
        'genero': 'F',
        'avatar': 'https://i.pravatar.cc/150?img=26'
      },
      {
        'nombre': 'Brutus',
        'distrito': 2,
        'genero': 'M',
        'avatar': 'https://i.pravatar.cc/150?img=27'
      },
      {
        'nombre': 'Enobaria',
        'distrito': 2,
        'genero': 'F',
        'avatar': 'https://i.pravatar.cc/150?img=28'
      },
      {
        'nombre': 'Chaff',
        'distrito': 11,
        'genero': 'M',
        'avatar': 'https://i.pravatar.cc/150?img=29'
      },
    ];

    try {
      for (var tributo in predeterminados) {
        await api.crearTributo(
            tributo['nombre'] as String,
            tributo['distrito'] as int,
            tributo['genero'] as String,
            tributo['avatar'] as String);
      }
      // Recarga la lista completa del backend
      var t = await api.obtenerTributos();
      if (!mounted) return;
      setState(() {
        lista = t;
        cargando = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                Text('¡Se han cosechado los 20 Tributos predeterminados!')));
      }
    } catch (e) {
      // Si hay error, intenta cargar lo que sí se creó
      if (!mounted) return;
      cargar();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al cargar predeterminados: $e')));
      }
    }
  }

  // DIÁLOGO PARA EDITAR TRIBUTO (RF-002)
  void mostrarDialogoEditar(Tributo t) {
    final edtName = TextEditingController(text: t.nombre);
    final edtAvatar = TextEditingController(text: t.avatar);
    int edtDist = t.distrito;
    String edtGen = t.genero;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Editar Tributo'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                    controller: edtName,
                    decoration: InputDecoration(labelText: 'Nombre')),
                TextField(
                    controller: edtAvatar,
                    decoration:
                        InputDecoration(labelText: 'URL Avatar (Opcional)')),
                DropdownButton<int>(
                  value: edtDist,
                  items: List.generate(
                      12,
                      (i) => DropdownMenuItem(
                          value: i + 1, child: Text('Distrito ${i + 1}'))),
                  onChanged: (v) => setDialogState(() => edtDist = v!),
                ),
                DropdownButton<String>(
                  value: edtGen,
                  items: [
                    DropdownMenuItem(value: 'M', child: Text('M')),
                    DropdownMenuItem(value: 'F', child: Text('F'))
                  ],
                  onChanged: (v) => setDialogState(() => edtGen = v!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                child: Text('Cancelar'), onPressed: () => Navigator.pop(ctx)),
            ElevatedButton(
              child: Text('Guardar'),
              onPressed: () async {
                if (edtName.text.trim().isNotEmpty) {
                  try {
                    await api.editarTributo(
                        t.id, edtName.text, edtDist, edtGen, edtAvatar.text);
                    Navigator.pop(ctx);
                    if (!mounted) return;
                    cargar();
                  } catch (e) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Cosecha de Tributos', onRefresh: cargar),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).colorScheme.surface
            ],
          ),
        ),
        child: Column(
          children: [
            // HEADER INTRO
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.amber[700],
                                borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.all(10),
                            child: const Icon(Icons.local_fire_department,
                                color: Colors.white),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Hunger Games Simulator',
                                    style:
                                        Theme.of(context).textTheme.titleLarge),
                                const SizedBox(height: 6),
                                Text(
                                  'Una arena oscura, narrativa generada por IA y una interfaz enfocada en claridad y control.',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),

            // BOTÓN PARA PRECARGA MASIVA (compacto)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Colors.white.withOpacity(0.06)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  icon: const Icon(Icons.auto_awesome_motion),
                  label: const Text('CARGAR 20 TRIBUTOS POR DEFECTO'),
                  onPressed: cargando ? null : registrarTributosPredeterminados,
                ),
              ),
            ),

            // FORMULARIO PARA AGREGAR TRIBUTO INDIVIDUAL (RF-001)
            AddTributoForm(
              nameCtrl: nameCtrl,
              avatarCtrl: avatarCtrl,
              distritoSel: distritoSel,
              generoSel: generoSel,
              onDistritoChanged: (v) => setState(() => distritoSel = v),
              onGeneroChanged: (v) => setState(() => generoSel = v),
              onRegister: () async {
                if (nameCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Escribe un nombre.')));
                  return;
                }
                try {
                  await api.crearTributo(
                      nameCtrl.text, distritoSel, generoSel, avatarCtrl.text);
                  nameCtrl.clear();
                  avatarCtrl.clear();
                  if (!mounted) return;
                  cargar();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tributo registrado.')));
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              },
            ),

            // AJUSTE NARRATIVO
            ListTile(
              title: const Text('Estilo Narrativo de la Arena'),
              trailing: DropdownButton<String>(
                value: tonoSel,
                underline: Container(height: 1, color: Colors.white24),
                items: const ['Dramático', 'Satírico', 'Esperanzador']
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => setState(() => tonoSel = v!),
              ),
            ),
            const Divider(height: 1),

            // LISTADO DE TRIBUTOS CON OPCIONES DE EDITAR/ELIMINAR (vista en cuadrícula)
            Expanded(
              child: cargando
                  ? const Center(child: CircularProgressIndicator())
                  : lista.isEmpty
                      ? const Center(
                          child: Text(
                              'No hay tributos. ¡Usa la precarga o agrégalos!'))
                      : LayoutBuilder(builder: (context, constraints) {
                          final width = constraints.maxWidth;
                          int columns = (width / 160).floor();
                          if (columns < 2) columns = 2;
                          if (columns > 4) columns = 4;
                          return GridView.count(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            crossAxisCount: columns,
                            childAspectRatio: 1.2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            children: lista.map((t) {
                              final eliminado = (!t.vivo) || (t.salud <= 0);
                              return TributoCard(
                                tributo: t,
                                eliminado: eliminado,
                                onEdit: () => mostrarDialogoEditar(t),
                                onDelete: () async {
                                  try {
                                    await api.eliminarTributo(t.id);
                                    cargar();
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Error: $e')));
                                  }
                                },
                              );
                            }).toList(),
                          );
                        }),
            ),

            // BOTÓN DE ACCIÓN PRINCIPAL
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[700],
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.all(16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                child: Text('INICIAR SIMULACIÓN (${lista.length} Tributos)',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.2)),
                onPressed: () async {
                  try {
                    await api.iniciarSimulacion(tonoSel);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => SimulacionScreen()));
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Error al iniciar'),
                        content:
                            Text(e.toString().replaceAll('Exception:', '')),
                        actions: [
                          TextButton(
                              child: const Text('Cerrar'),
                              onPressed: () => Navigator.pop(ctx))
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
