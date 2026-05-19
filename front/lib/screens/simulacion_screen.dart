import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'victoria_screen.dart';
import '../widgets/custom_app_bar.dart';

class SimulacionScreen extends StatefulWidget {
  const SimulacionScreen({super.key});

  @override
  SimulacionScreenState createState() => SimulacionScreenState();
}

class SimulacionScreenState extends State<SimulacionScreen> {
  final ApiService api = ApiService();
  int dia = 0;
  List<dynamic> eventos = [];
  List<dynamic> peleas = [];
  List<dynamic> bajas = [];
  List<Map<String, dynamic>> historialDias = [];
  bool finalizado = false;
  String? ganador;
  bool _victoriaAbierta = false;

  void procesarSiguienteCiclo() async {
    try {
      var res = await api.avanzarDia();
      setState(() {
        dia = res['dia'];
        eventos = res['eventos'];
        peleas = res['peleas'];
        bajas = res['bajas'];
        finalizado = res['finalizado'];
        ganador = res['ganador'];
        historialDias.add({
          'dia': res['dia'],
          'eventos': List<dynamic>.from(res['eventos'] ?? []),
          'peleas': List<dynamic>.from(res['peleas'] ?? []),
          'bajas': List<dynamic>.from(res['bajas'] ?? []),
        });
      });

      if (res['finalizado'] == true && mounted && !_victoriaAbierta) {
        _victoriaAbierta = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (c) =>
                  VictoriaScreen(ganador: res['ganador']?.toString()),
            ),
          );
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Arena de Combate - Ciclo Día $dia'),
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
            if (dia == 0)
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                        'Los tributos han ingresado a la Cornucopia.\nPresiona "Siguiente Jornada" para simular el transcurso de los eventos.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            if (dia > 0)
              Expanded(
                child: ListView(
                  children: [
                    ...historialDias.map((diaRegistro) {
                      final listaEventos =
                          List<dynamic>.from(diaRegistro['eventos'] ?? []);
                      final listaPeleas =
                          List<dynamic>.from(diaRegistro['peleas'] ?? []);
                      final listaBajas =
                          List<dynamic>.from(diaRegistro['bajas'] ?? []);

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Día ${diaRegistro['dia']}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orangeAccent)),
                              const SizedBox(height: 10),
                              Text('Peleas y eventos',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              const SizedBox(height: 8),
                              if (listaEventos.isEmpty)
                                Text('No hubo eventos registrados en este día.',
                                    style: TextStyle(color: Colors.grey[400]))
                              else
                                ...listaEventos.map((e) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Text('• ${e.toString()}',
                                          style: const TextStyle(
                                              fontSize: 15, height: 1.3)),
                                    )),
                              const Divider(
                                  height: 24,
                                  thickness: 1.5,
                                  color: Colors.red),
                              Text('Peleas del día',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orangeAccent)),
                              const SizedBox(height: 8),
                              if (listaPeleas.isEmpty)
                                Text('No hubo peleas registradas en este día.',
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey))
                              else
                                ...listaPeleas.map((p) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 18,
                                            backgroundColor: Colors.orange[900],
                                            child: const Text('👑',
                                                style: TextStyle(fontSize: 16)),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${p['atacante']} vs ${p['oponente']}',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Ganó: ${p['vencedor']} • Perdió: ${p['perdedor']}',
                                                  style: const TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.white70),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Icon(Icons.sports_mma,
                                              color: Colors.orangeAccent)
                                        ],
                                      ),
                                    )),
                              const Divider(
                                  height: 24,
                                  thickness: 1.5,
                                  color: Colors.red),
                              Text('Muertes del día',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.redAccent)),
                              const SizedBox(height: 8),
                              if (listaBajas.isEmpty)
                                Text('No se registraron muertes en este día.',
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey))
                              else
                                ...listaBajas.map((b) => Card(
                                      color: const Color(0xFF161616),
                                      margin:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.red[900],
                                          child: const Text('💀',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18)),
                                        ),
                                        title: Text(
                                            '${b['nombre']} (Distrito ${b['distrito']})',
                                            style: const TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold)),
                                        subtitle: const Text(
                                            'Eliminado definitivamente'),
                                        trailing: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                              color: Colors.red[800],
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: const Text('Eliminado',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    )),
                            ],
                          ),
                        ),
                      );
                    })
                  ],
                ),
              ),
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white.withOpacity(0.06)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Abandonar Arena'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  if (!finalizado) const SizedBox(width: 10),
                  if (!finalizado)
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber[700],
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: const Text('Siguiente Jornada'),
                        onPressed: procesarSiguienteCiclo,
                      ),
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
