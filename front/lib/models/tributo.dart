class Tributo {
  final int id;
  final String nombre;
  final int distrito;
  final String genero;
  final String avatar;
  final bool vivo;
  final int salud;
  final int asesinatos;
  final int diasSobrevividos;
  final List<String> inventario;

  Tributo({
    required this.id,
    required this.nombre,
    required this.distrito,
    required this.genero,
    required this.avatar,
    required this.vivo,
    required this.salud,
    required this.asesinatos,
    required this.diasSobrevividos,
    required this.inventario,
  });

  factory Tributo.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      final s = v.toString();
      return int.tryParse(s) ?? 0;
    }

    bool parseBool(dynamic v) {
      if (v == null) return true;
      if (v is bool) return v;
      final s = v.toString().toLowerCase();
      return s == 'true' || s == '1';
    }

    List<String> parseInventario(dynamic v) {
      if (v == null) return [];
      if (v is List) return v.map((e) => e.toString()).toList();
      return [];
    }

    return Tributo(
      id: parseInt(json['id']),
      nombre: (json['nombre'] ?? '').toString(),
      distrito: parseInt(json['distrito']),
      genero: (json['genero'] ?? '').toString(),
      avatar: (json['avatar'] ?? '').toString(),
      vivo: parseBool(json['vivo']),
      salud: parseInt(json['salud']),
      asesinatos: parseInt(json['asesinatos']),
      diasSobrevividos: parseInt(json['dias_sobrevividos']),
      inventario: parseInventario(json['inventario']),
    );
  }
}
