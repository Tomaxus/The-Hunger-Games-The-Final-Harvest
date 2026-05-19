import os
import random
from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
from typing import List, Optional, Dict
from groq import Groq
from dotenv import load_dotenv
from pydantic import BaseModel, Field
from typing import Optional

load_dotenv()

app = FastAPI(title="Hunger Games Simulator API - 18 RF Complete")

# Habilitar CORS para conectar sin problemas con Flutter (Web, Desktop, Mobile)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Modelo de datos con validaciones estrictas (RF-001)
class Tributo(BaseModel):
    id: Optional[int] = None
    nombre: str
    distrito: int = Field(..., ge=1, le=12) # Valida que sea entero entre 1 y 12
    genero: str = Field(..., pattern="^(M|F)$") # Exige estrictamente 'M' o 'F' en mayúscula
    avatar: Optional[str] = ""
    vivo: bool = True
    salud: int = 100
    dias_sobrevividos: int = 0
    asesinatos: int = 0
    inventario: List[str] = Field(default_factory=list)
    alianzas: List[int] = Field(default_factory=list)

class ConfigIA(BaseModel):
    tono: str = "Dramático"

class EstadoSimulacion:
    def __init__(self):
        self.tributos: Dict[int, Tributo] = {}
        self.siguiente_id = 1
        self.dia_actual = 0
        self.historial: Dict[int, List[str]] = {}
        self.bajas_por_dia: Dict[int, List[dict]] = {}
        self.activa = False
        self.ganador: Optional[Tributo] = None
        self.tono = "Dramático"

estado = EstadoSimulacion()

# Inicialización segura del cliente Groq (RF-010)
GROQ_KEY = os.getenv("GROQ_API_KEY", "REPLACE_ME")
client_groq = Groq(api_key=GROQ_KEY)

def narrar_evento(evento_base: str) -> str:
    """RF-010 & RF-017: Motor Narrativo con Inteligencia Artificial y Flujo Alternativo"""
    prompt = f"Describe el siguiente suceso de una simulación de los Juegos del Hambre. Tono: {estado.tono}. Evento: '{evento_base}'. Sé breve (máximo 2 oraciones) e inmersivo."
    try:
        response = client_groq.chat.completions.create(
            messages=[
                {"role": "system", "content": "Eres el locutor oficial del Capitolio en los Juegos del Hambre. Traduces eventos lógicos a crónicas dinámicas."},
                {"role": "user", "content": prompt}
            ],
            model="llama3-8b-8192",
            timeout=2.5
        )
        return response.choices[0].message.content.strip()
    except Exception:
        # Flujo Alternativo del RF-010: Generador/Traductor basado en plantillas si la IA falla
        return f"[Crónica del Capitolio] {evento_base}"

# RF-001: Crear Tributo
@app.post("/tributos", response_model=Tributo)
def crear_tributo(nombre: str, distrito: int, genero: str, avatar: str = ""):
    if not nombre or nombre.strip() == "":
        raise HTTPException(status_code=400, detail="El campo nombre es estrictamente obligatorio.")
    if distrito < 1 or distrito > 12:
        raise HTTPException(status_code=400, detail="El distrito debe estar comprendido entre 1 y 12.")
    if genero not in ["M", "F"]:
        raise HTTPException(status_code=400, detail="Género debe ser M (Masculino) o F (Femenino).")
    
    nuevo = Tributo(id=estado.siguiente_id, nombre=nombre.strip(), distrito=distrito, genero=genero, avatar=avatar)
    estado.tributos[estado.siguiente_id] = nuevo
    estado.siguiente_id += 1
    return nuevo

@app.get("/tributos", response_model=List[Tributo])
def listar_tributos():
    return list(estado.tributos.values())

# RF-002: Editar Tributo Existente
@app.put("/tributos/{tributo_id}", response_model=Tributo)
def editar_tributo(tributo_id: int, nombre: str, distrito: int, genero: str, avatar: str = ""):
    if tributo_id not in estado.tributos:
        raise HTTPException(status_code=404, detail="Tributo no encontrado.")
    if not nombre or nombre.strip() == "":
        raise HTTPException(status_code=400, detail="El nombre modificado no puede ser vacío.")
        
    t = estado.tributos[tributo_id]
    t.nombre = nombre.strip()
    t.distrito = distrito
    t.genero = genero
    t.avatar = avatar
    return t

# RF-003: Eliminar Tributo
@app.delete("/tributos/{tributo_id}")
def eliminar_tributo(tributo_id: int):
    if tributo_id in estado.tributos:
        del estado.tributos[tributo_id]
        return {"status": "Registro eliminado con éxito de la base de datos."}
    raise HTTPException(status_code=404, detail="El ID del personaje especificado no existe.")

# RF-004 & RF-005: Control Numérico e Inicio de la Simulación
@app.post("/simulacion/iniciar")
def iniciar_simulacion(config: ConfigIA):
    total_tributos = len(estado.tributos)
    if total_tributos < 6 or total_tributos > 24:
        raise HTTPException(status_code=400, detail=f"Inviabilidad de inicio: Se requieren entre 6 y 24 tributos. Actualmente hay {total_tributos} cargados.")
    
    estado.tono = config.tono
    estado.dia_actual = 0
    estado.historial = {}
    estado.bajas_por_dia = {}
    estado.activa = True
    estado.ganador = None
    
    for t in estado.tributos.values():
        t.vivo = True
        t.salud = 100
        t.inventario = []
        t.alianzas = []
        t.asesinatos = 0
        t.dias_sobrevividos = 0
        
    return {"status": "Arena inicializada y lista para ciclos diarios.", "participantes": total_tributos}

# RF-006 & RF-007: Motor de Jornadas y Ciclos de Avance Diario
@app.post("/simulacion/avanzar")
def avanzar_dia():
    if not estado.activa:
        raise HTTPException(status_code=400, detail="La arena se encuentra inactiva. Reinicie la simulación.")
        
    estado.dia_actual += 1
    eventos_hoy = []
    peleas_hoy = []
    bajas_hoy = []
    
    vivos = [t for t in estado.tributos.values() if t.vivo]
    random.shuffle(vivos) # Mezclar para garantizar aleatoriedad en el turno de actuación (RF-006)

    for t in vivos:
        if not t.vivo: continue
        
        # RF-015: Probabilidad de Ruptura y Traición de Alianza Previa
        if t.alianzas and random.random() < 0.20:
            aliado_id = random.choice(t.alianzas)
            if aliado_id in estado.tributos and estado.tributos[aliado_id].vivo:
                traicionado = estado.tributos[aliado_id]
                t.alianzas.remove(aliado_id)
                if t.id in traicionado.alianzas: traicionado.alianzas.remove(t.id)
                
                # Desenlace fatal inmediato de la traición (RF-014)
                traicionado.vivo = False
                t.asesinatos += 1
                bajas_hoy.append(traicionado.dict())
                
                base_ev = f"{t.nombre} traicionó fríamente su pacto con {traicionado.nombre} atacándolo mientras dormía."
                eventos_hoy.append(narrar_evento(base_ev))
                continue

        # Selección de eventos lógicos (RF-013 Sistema de Combate, RF-016 Objetos, RF-015 Alianzas)
        accion = random.choices(["combate", "alianza", "objeto", "accidente", "paz"], weights=[30, 15, 20, 15, 20])[0]
        
        if accion == "combate":
            # Filtro para evitar fuego amigo entre aliados activos (RF-015)
            rivales = [r for r in vivos if r.id != t.id and r.id not in t.alianzas and r.vivo]
            if rivales:
                oponente = random.choice(rivales)
                # RF-016 Modificadores del Inventario de Objetos
                mod_t = 1.4 if "Arma" in t.inventario else 1.0
                mod_o = 1.4 if "Arma" in oponente.inventario else 1.0
                
                if (random.random() * mod_t) > (random.random() * mod_o):
                    vencedor, perdedor = t, oponente
                else:
                    vencedor, perdedor = oponente, t

                peleas_hoy.append({
                    "atacante": t.nombre,
                    "oponente": oponente.nombre,
                    "vencedor": vencedor.nombre,
                    "perdedor": perdedor.nombre,
                })
                
                # Determinación de Fatalidad (RF-014 Sistema de Eliminaciones)
                fatal = 0.70 if "Arma" in vencedor.inventario else 0.35
                if random.random() < fatal:
                    perdedor.vivo = False
                    vencedor.asesinatos += 1
                    bajas_hoy.append(perdedor.dict())
                    base_ev = f"{vencedor.nombre} liquidó a {perdedor.nombre} tras un sangriento duelo en la llanura."
                else:
                    perdedor.salud -= 40
                    base_ev = f"{vencedor.nombre} infligió heridas severas a {perdedor.nombre}, pero este consiguió escabullirse."
            else:
                base_ev = f"{t.nombre} patrulló la zona boscosa con cautela sin divisar objetivos."
                
        elif accion == "alianza":
            candidatos = [c for c in vivos if c.id != t.id and c.id not in t.alianzas and c.vivo]
            if candidatos:
                socio = random.choice(candidatos)
                t.alianzas.append(socio.id)
                socio.alianzas.append(t.id)
                base_ev = f"{t.nombre} y {socio.nombre} acordaron resguardarse mutuamente formando una alianza."
            else:
                base_ev = f"{t.nombre} buscó una señal de tregua en los alrededores sin éxito."
                
        elif accion == "objeto":
            # RF-016 Sistema de Objetos e impactos mecánicos
            item = random.choice(["un Arco de Caza", "una Lanza de Acero", "un Kit Médico Completo", "Suministros del Capitolio"])
            if "Arco" in item or "Lanza" in item:
                t.inventario.append("Arma")
            else:
                t.inventario.append(item)
            base_ev = f"{t.nombre} abrió un paquete patrocinado caído del cielo con {item}."
            
        elif accion == "accidente":
            if random.random() < 0.25:
                t.vivo = False
                bajas_hoy.append(t.dict())
                base_ev = f"{t.nombre} murió asfixiado por un gas venenoso liberado en la arena."
            else:
                t.salud -= 30
                base_ev = f"{t.nombre} cayó desde una cornisa rocosa, sufriendo contusiones."
        else:
            base_ev = f"{t.nombre} pasó desapercibido el día de hoy, racionando sus recursos de agua."
            
        eventos_hoy.append(narrar_evento(base_ev))

    # Incrementar permanencia a los que superaron el día con vida
    for tributo in estado.tributos.values():
        if tributo.vivo:
            tributo.dias_sobrevividos += 1

    estado.historial[estado.dia_actual] = eventos_hoy
    estado.bajas_por_dia[estado.dia_actual] = bajas_hoy

    # RF-008: Evaluación de Criterio de Victoria Absoluta
    restantes = [t for t in estado.tributos.values() if t.vivo]
    if len(restantes) <= 1:
        estado.activa = False
        if restantes:
            estado.ganador = restantes[0]

    return {
        "dia": estado.dia_actual,
        "eventos": eventos_hoy,
        "peleas": peleas_hoy,
        "bajas": bajas_hoy,
        "finalizado": not estado.activa,
        "ganador": estado.ganador.nombre if estado.ganador else None
    }

# RF-009 & RF-018: Consultas de Cierre de Sesión y Estadísticas Consolidadas del Podio
@app.get("/simulacion/reporte")
def obtener_reporte_final():
    resumen_tributos = [t.dict() for t in estado.tributos.values()]
    # Clasificación ponderada: Estado de Vida -> Días de resistencia -> Bajas acumuladas (RF-018 Podio)
    resumen_tributos.sort(key=lambda x: (x['vivo'], x['dias_sobrevividos'], x['asesinatos']), reverse=True)
    
    return {
        "ganador": estado.ganador.nombre if estado.ganador else "Ninguno",
        "cronologia_completa": estado.historial,
        "bajas_por_jornada": estado.bajas_por_dia,
        "podio_y_estadisticas": resumen_tributos
    }


@app.post("/simulacion/reiniciar")
def reiniciar_simulacion():
    """Restablece el estado de la simulación dejando a todos los tributos vivos
    y reseteando contadores e historial. Útil para el botón de 'Reiniciar Juego'."""
    estado.dia_actual = 0
    estado.historial = {}
    estado.bajas_por_dia = {}
    estado.activa = False
    estado.ganador = None

    for t in estado.tributos.values():
        t.vivo = True
        t.salud = 100
        t.inventario = []
        t.alianzas = []
        t.asesinatos = 0
        t.dias_sobrevividos = 0

    return {"status": "Simulación reiniciada.", "participantes": len(estado.tributos)}
