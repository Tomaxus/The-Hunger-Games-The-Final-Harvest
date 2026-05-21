# The Hunger Games - The Final Harvest

Simulador de Los Juegos del Hambre con backend en FastAPI y frontend en Flutter. Permite registrar tributos, ejecutar la simulacion diaria, narrar eventos con IA y mostrar reportes finales con podio y cronologia.

## Arquitectura

- Backend (API): FastAPI, estado en memoria, motor de simulacion y narrador IA.
- Frontend (UI): Flutter, pantallas para gestion de tributos, simulacion y reportes.

## Requisitos de ejecucion

### Backend

- Python 3.10+
- Dependencias en [back/requirements.txt](back/requirements.txt)
- Variable de entorno `GROQ_API_KEY` (para narracion IA). Si no existe, el backend usa un modo alternativo con plantillas.

### Frontend

- Flutter 3.x
- Dependencias en [front/pubspec.yaml](front/pubspec.yaml)

## Configuracion rapida

### Backend

1) Instalar dependencias

```bash
pip install -r back/requirements.txt
```

2) Exportar variable de entorno

```bash
setx GROQ_API_KEY "tu_api_key"
```

3) Ejecutar API

```bash
uvicorn back.main:app --reload
```

### Frontend

1) Instalar dependencias

```bash
cd front
flutter pub get
```

2) Configurar URL del backend

Editar `baseUrl` en [front/lib/services/api_service.dart](front/lib/services/api_service.dart) para apuntar a tu IP/host.

3) Ejecutar app

```bash
flutter run
```

## Requerimientos funcionales (RF)

Los RF estan codificados y comentados con etiquetas `RF-00X` en el backend. Fuente principal: [back/main.py](back/main.py).

- RF-001: Crear tributo con validaciones estrictas (nombre, distrito 1-12, genero M/F).
- RF-002: Editar tributo existente.
- RF-003: Eliminar tributo.
- RF-004: Control numerico de participantes (6 a 24).
- RF-005: Inicio de simulacion y reinicio de estado base.
- RF-006: Motor de jornadas con aleatoriedad.
- RF-007: Avance diario y registro de eventos.
- RF-008: Criterio de victoria absoluta.
- RF-009: Reporte final y consulta de cierre.
- RF-010: Narracion de eventos con IA (Groq).
- RF-013: Sistema de combate.
- RF-014: Sistema de eliminaciones.
- RF-015: Alianzas y traiciones.
- RF-016: Sistema de objetos e inventario.
- RF-017: Flujo alternativo si falla la IA.
- RF-018: Podio y estadisticas consolidadas.

## Endpoints principales

- `POST /tributos` crear tributo
- `GET /tributos` listar tributos
- `PUT /tributos/{id}` editar tributo
- `DELETE /tributos/{id}` eliminar tributo
- `POST /simulacion/iniciar` iniciar simulacion
- `POST /simulacion/avanzar` avanzar un dia
- `GET /simulacion/reporte` reporte final
- `POST /simulacion/reiniciar` reiniciar simulacion

## Ubicacion de funcionalidades

- Estado de simulacion y reglas de negocio: [back/main.py](back/main.py)
- Cliente HTTP y llamadas a la API: [front/lib/services/api_service.dart](front/lib/services/api_service.dart)
- Gestion de tributos (UI): [front/lib/screens/gestion_screen.dart](front/lib/screens/gestion_screen.dart)
- Simulacion y eventos diarios (UI): [front/lib/screens/simulacion_screen.dart](front/lib/screens/simulacion_screen.dart)
- Reporte final y podio (UI): [front/lib/screens/reporte_screen.dart](front/lib/screens/reporte_screen.dart)

## Requerimientos no funcionales

No se encontraron requerimientos no funcionales explicitados en archivos del proyecto. Si necesitas agregarlos (rendimiento, seguridad, disponibilidad, usabilidad, etc.), puedo incorporarlos en esta seccion.

## Notas

- El backend guarda el estado en memoria, por lo que al reiniciar el servidor se pierde la simulacion actual.
- Si el endpoint de IA falla, la narracion usa un texto alternativo predefinido.

## Mapeo de requerimientos (Excel -> codigo)

Fuente: `Requerimientos_Juegos_Del_Hambre_App.xlsx` (hojas RF1 a RF18).

| RF | Nombre (Excel) | Ubicacion principal | Como funciona |
|---|---|---|---|
| RF-001 | Crear tributos | `back/main.py` (modelo y POST `/tributos`), `front/lib/widgets/add_tributo_form.dart`, `front/lib/screens/gestion_screen.dart`, `front/lib/services/api_service.dart` | Se valida `nombre`, `distrito (1-12)` y `genero (M/F)`; se crea el tributo en memoria y el frontend lo registra desde el formulario. |
| RF-002 | Editar tributos existentes | `back/main.py` (PUT `/tributos/{id}`), `front/lib/screens/gestion_screen.dart`, `front/lib/services/api_service.dart` | Se abre un dialogo para editar y se persisten los cambios en el backend. |
| RF-003 | Eliminar tributos | `back/main.py` (DELETE `/tributos/{id}`), `front/lib/widgets/tributo_card.dart`, `front/lib/screens/gestion_screen.dart`, `front/lib/services/api_service.dart` | El usuario elimina un tributo y el backend lo borra del estado en memoria. |
| RF-004 | Configurar numero de tributos | `back/main.py` (POST `/simulacion/iniciar`), `front/lib/screens/gestion_screen.dart` | El inicio valida que haya entre 6 y 24 tributos; si no, bloquea el inicio. |
| RF-005 | Ejecutar simulacion | `back/main.py` (POST `/simulacion/iniciar`, `/simulacion/avanzar`), `front/lib/screens/gestion_screen.dart`, `front/lib/screens/simulacion_screen.dart` | Se inicializa la arena y se avanza dia a dia generando eventos, peleas y bajas. |
| RF-006 | Ejecucion en ciclos de dias | `back/main.py` (motor de `avanzar_dia`) | Cada ciclo diario procesa tributos vivos, genera eventos y guarda el historial por dia. |
| RF-007 | Avance de ciclos de dias | `front/lib/screens/simulacion_screen.dart`, `front/lib/services/api_service.dart`, `back/main.py` | El boton "Siguiente Jornada" llama al backend y muestra el nuevo bloque de eventos. |
| RF-008 | Generacion de victoria | `back/main.py` (condicion de ganador), `front/lib/screens/simulacion_screen.dart`, `front/lib/screens/victoria_screen.dart` | Al quedar un solo vivo, se marca ganador y se muestra la pantalla de victoria. |
| RF-009 | Resultados finales con registro | `back/main.py` (GET `/simulacion/reporte`), `front/lib/screens/reporte_screen.dart` | Se expone el reporte final y la UI muestra cronologia completa. |
| RF-010 | Implementacion mediante IA | `back/main.py` (`narrar_evento`) | Se genera narrativa con Groq; si falla, se usa un texto alternativo. |
| RF-011 | Configuracion de motor de IA | `back/main.py` (`ConfigIA`, `estado.tono`), `front/lib/screens/gestion_screen.dart` | El usuario elige tono y se envia al backend al iniciar simulacion. |
| RF-012 | Tablero de bajas | `back/main.py` (`bajas_por_dia`), `front/lib/screens/simulacion_screen.dart` | Se almacenan bajas por jornada y se muestran en la lista de muertes del dia. |
| RF-013 | Sistema de combates | `back/main.py` (bloque `combate`), `front/lib/screens/simulacion_screen.dart` | Se resuelven combates con probabilidades y se registra el ganador/perdedor. |
| RF-014 | Sistema de eliminaciones | `back/main.py` (marcar `vivo = False`), `front/lib/screens/simulacion_screen.dart` | Los tributos muertos pasan a bajas y dejan de participar. |
| RF-015 | Sistema de alianzas | `back/main.py` (bloques `alianza` y traicion) | Alianzas se crean/rompen automaticamente; traiciones pueden matar. |
| RF-016 | Sistema de objetos | `back/main.py` (bloque `objeto`, inventario) | Los objetos influyen en combates y supervivencia. |
| RF-017 | Generacion de sucesos narrados | `back/main.py` (narracion + historial), `front/lib/screens/simulacion_screen.dart` | Cada evento logico se transforma en texto narrado y se muestra en UI. |
| RF-018 | Reporte de estadisticas finales | `back/main.py` (podio y estadisticas), `front/lib/screens/reporte_screen.dart`, `front/lib/screens/victoria_screen.dart` | Se calcula podio y estadisticas finales; la UI lo presenta en pestañas. |
