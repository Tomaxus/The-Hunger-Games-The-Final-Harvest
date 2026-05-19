import 'package:flutter/material.dart';
import 'reporte_screen.dart';
import 'gestion_screen.dart';
import '../widgets/custom_app_bar.dart';
import '../services/api_service.dart';

class VictoriaScreen extends StatelessWidget {
  final String? ganador;

  const VictoriaScreen({super.key, this.ganador});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Victoria'),
      body: Container(
        width: double.infinity,
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.06),
                    border: Border.all(color: Colors.amber.withOpacity(0.32)),
                  ),
                  child: Icon(Icons.emoji_events,
                      size: 96, color: Colors.amber[300]),
                ),
                const SizedBox(height: 20),
                Text(
                  '¡JUEGOS CONCLUIDOS!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.28),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.06)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'El Capitolio proclama al último superviviente',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.78),
                            fontSize: 14),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        ganador?.toUpperCase() ?? 'SIN GANADOR',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.amber[300],
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF121318),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Colors.white.withOpacity(0.12)),
                    ),
                    icon: const Icon(Icons.bar_chart),
                    label: const Text('Ver Resultados e Historial'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => ReporteScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white54),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: const Icon(Icons.home),
                    label: const Text('Volver al inicio'),
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (c) => GestionScreen()),
                          (route) => false);
                    },
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14)),
                    icon: const Icon(Icons.replay),
                    label: const Text('Reiniciar Juego'),
                    onPressed: () async {
                      // Llamar al backend para restablecer el estado de la simulación
                      try {
                        final api = ApiService();
                        await api.reiniciarSimulacion();
                      } catch (e) {
                        // No bloquear la navegación si falla el reinicio remoto
                        debugPrint('Error reiniciando simulación: $e');
                      }
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (c) => GestionScreen()),
                          (route) => false);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
