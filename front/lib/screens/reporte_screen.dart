import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ReporteScreen extends StatefulWidget {
  const ReporteScreen({super.key});

  @override
  ReporteScreenState createState() => ReporteScreenState();
}

class ReporteScreenState extends State<ReporteScreen> {
  final ApiService api = ApiService();
  Map<String, dynamic>? datos;
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    obtener();
  }

  void obtener() async {
    try {
      var r = await api.obtenerReporteFinal();
      if (!mounted) return;
      setState(() {
        datos = r;
        cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    var podio = datos?['podio_y_estadisticas'] as List<dynamic>? ?? [];
    var cronologia =
        datos?['cronologia_completa'] as Map<String, dynamic>? ?? {};

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reporte Final de la Partida'),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1C2440), Color(0xFF0F1730)],
              ),
            ),
          ),
          bottom: TabBar(
            tabs: const [
              Tab(icon: Icon(Icons.bar_chart), text: 'Podio y Estadísticas'),
              Tab(icon: Icon(Icons.history), text: 'Historial Detallado'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: podio.length,
              itemBuilder: (context, index) {
                var p = podio[index];
                String medalla = "";
                if (index == 0 && p['vivo'] == true) {
                  medalla = "🥇 [Ganador] ";
                } else if (index == 1) {
                  medalla = "🥈 [Puesto 2] ";
                } else if (index == 2) {
                  medalla = "🥉 [Puesto 3] ";
                }

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: (p['vivo'] == true)
                          ? Colors.green[900]
                          : Colors.grey[800],
                      child: Text('${index + 1}'),
                    ),
                    title: Text(
                        '$medalla${p['nombre']} (Distrito ${p['distrito']})'),
                    subtitle: Text(
                        'Días Sobrevividos: ${p['dias_sobrevividos']} | Bajas Causadas: ${p['asesinatos']}'),
                    trailing: Chip(
                      label: Text((p['vivo'] == true) ? 'VIVO' : 'ELIMINADO'),
                      backgroundColor:
                          (p['vivo'] == true) ? Colors.green : Colors.red,
                    ),
                  ),
                );
              },
            ),
            ListView(
              children: cronologia.entries.map((entry) {
                List<dynamic> sucesos = entry.value;
                return ExpansionTile(
                  title: Text('Historial del Día ${entry.key}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber[800])),
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                  children: sucesos
                      .map((s) => Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 6.0),
                            child: Text('• ${s.toString()}',
                                style: TextStyle(fontSize: 14)),
                          ))
                      .toList(),
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
