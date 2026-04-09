# Dubbing Clip Checker (DCC)
**v1.15.0 — Proyecto Cyrillica · Said R. Nájera**

---

## ¿Qué es?

Dubbing Clip Checker es una herramienta de control de calidad para estudios de doblaje. Cruza automáticamente la Dialog List del cliente (PLDL) contra el Session Info exportado de Pro Tools para detectar clips faltantes: líneas que están en el guion pero no tienen clip grabado en la sesión.

No requiere instalación ni conexión a internet. Funciona directamente en el navegador abriendo el archivo `.html`.

---

## Requisitos

- Navegador moderno (Chrome, Safari, Firefox, Edge — versión 2022 o posterior)
- No requiere instalación, servidor ni conexión a internet

---

## Archivos de prueba incluidos

| Archivo | Descripción |
|---|---|
| `test_PLDL.xlsx` | Dialog List de ejemplo (serie ficticia *Dark Echoes*) |
| `test_DUB_SCRIPT.xlsx` | Guion de doblaje en español |
| `test_ProTools_SessionInfo.txt` | Session Info exportado de Pro Tools |
| `test_KNP.xlsx` | Key Names & Phrases (terminología) |

---

## Cómo usarlo

### 1. Abrir la herramienta
Haz doble clic en `dubbing-clip-checker.html`. Se abre en el navegador sin instalación.

### 2. Cargar los archivos (en este orden recomendado)

| Zona | Archivo | Obligatorio |
|---|---|---|
| **PLDL** | Dialog List del cliente (`.xlsx`) | Sí |
| **Dub Script** | Guion traducido (`.xlsx` o `.docx`) | No |
| **KNP / LL** | Key Names & Phrases o Localization List (`.xlsx`) | No |
| **Pro Tools** | Session Info exportado como texto (`.txt`) | Sí |

> **Exportar Session Info de Pro Tools:**
> `File → Export → Session Info as Text`
> Guardar con codificación **Mac Roman / Latin-1** (opción por defecto en Mac).

### 3. Ajustar tolerancia
El campo **Tolerancia** (en fotogramas) define cuánto puede desfasarse un clip respecto al TC del PLDL y aun así considerarse grabado. El valor por defecto es 6 fotogramas.

### 4. Cotejar
Haz clic en **Cotejar**. Los resultados aparecen en la tabla.

---

## Requisitos de columnas para archivos de entrada

La herramienta detecta columnas por nombre de encabezado (sin distinción de mayúsculas ni acentos). Las siguientes columnas son **obligatorias**:

| Columna | Nombres aceptados (ejemplos) |
|---|---|
| TC In | `IN-TIMECODE`, `TIMECODE IN`, `TC IN` |
| TC Out | `OUT-TIMECODE`, `TIMECODE OUT`, `TC OUT` |
| Personaje / Fuente | `SOURCE`, `CHARACTER`, `CHARACTER :: SOURCE`, `PERSONAJE` |
| Diálogo | `DIALOGUE`, `DIALOG`, `CONTENT :: DIALOGUE TRANSCRIPTION` |

Las demás columnas (anotaciones, tags, onscreen, transcripción) son opcionales. Si falta alguna columna obligatoria, la herramienta indica exactamente cuál no se encontró y lista los encabezados detectados.

---

## Resultados

Cada línea del PLDL aparece con uno de estos estados:

| Estado | Color | Significado |
|---|---|---|
| **GRABADO** | Verde | Se encontró un clip en Pro Tools que corresponde a esta línea |
| **FALTANTE** | Rojo | No hay clip en la sesión que coincida con esta línea |
| **EXCLUIDO** | Gris | La fuente fue excluida manualmente o por filtro de no-diálogo |

### Filtro de no-diálogo
Activado por defecto. Excluye fuentes como `WALLA`, `MAIN TITLE`, `GRAPHICS INSERTS`, `PRINCIPAL PHOTOGRAPHY`, `AD`, entre otras, y líneas con tags `INAUDIBLE`, `SONG`, `GRAPHICS INSERTS`, `MAIN TITLE`.

> El filtro usa coincidencia exacta de tag: `MAIN TITLE IN DIALOGUE` **no** se excluye porque no es exactamente `MAIN TITLE`.

### Exclusión de personajes
El botón 👤 **Personajes** permite excluir fuentes específicas del conteo (por ejemplo, NARRATOR). Las líneas excluidas aparecen en gris y no se cuentan como faltantes.

---

## Atajos de teclado

| Atajo | Acción |
|---|---|
| `↑ ↓ ← →` | Navegar por la tabla |
| `Shift + ↑↓←→` | Extender selección |
| `Enter` | Entrar en modo texto (selección parcial dentro de la celda) |
| `Escape` | Salir de modo texto o deseleccionar |
| `Cmd + C` | Copiar celdas seleccionadas (separadas por tabulador) |
| `Cmd + L` | Cambiar idioma: Original → ENG → ESP |
| `Cmd + D` | Abrir diccionario (DLE/RAE, DEM/Colmex, DA/ASALE) para la palabra seleccionada |

---

## Versión y autoría

**v1.15.0**
Said R. Nájera — Newart, Ciudad de México
Proyecto Cyrillica

---

*Uso interno. No distribuir fuera del estudio.*
