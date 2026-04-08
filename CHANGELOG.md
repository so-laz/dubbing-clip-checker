# Changelog

## [1.2.0] - 2026-04-08

### Agregado
- **Soporte Disney**: PLDL formato DIA_ENG (headers en fila 5, sheet "Dialogue List" auto-detectado), Dub Script en .docx (tabla con TC en MM:SS), LL como alternativa a KNP.
- **DOCX Dub Script**: Parsing via mammoth.js → HTML → tabla DOM. TCs MM:SS convertidos a 00:MM:SS:00. Matching inverso: cada línea del DOCX busca su PLDL más cercana, múltiples líneas se agrupan con " / ".
- **LL (Localization List)**: Auto-detectado cuando KNP no encuentra términos. Extrae tipo, contenido, instrucciones de doblaje (DO NOT DUB, TRANSLATE & DUB).
- **TC offset automático**: Detecta sesiones que inician en 00:59:59:00 (Disney) usando el clip más temprano. Aplica offset a todos los TCs de la PLDL.
- **Fuzzy matching** (edit distance ≤ 2): Atrapa typos en tracks/clips de PT. Casos reales: CAMlLLA (l vs I), TIFANNY (doble N), MIKEY vs MICKEY.
- **Guion normalization**: Ahora normaliza guiones a underscores. LARS-ERIK → LARS_ERIK.

### Corregido
- **Reacciones con diálogo**: Regex ahora exige que la reacción sea el contenido completo de la celda (`$` anchor). `[REACTION] Thank you.` ya no se excluye.
- **Dub Script matching**: Reescrito como matching inverso — el DOCX busca la PLDL, no al revés. Elimina desalineamientos en cascada cuando hay diferente cantidad de entradas.

## [1.1.0] - 2026-04-04

### Agregado
- **Exclusión de personajes** (👤 Personajes): Panel para marcar personajes que no deben contarse como faltantes. Aparecen como EXCLUIDO en la tabla pero siguen visibles en "Todos".
- **Exclusión de reacciones**: Checkbox para filtrar [REACTION], [REAC], (RISA), (LLANTO), etc.
- **Cmd+L**: Atajo para ciclar idiomas (Original → ENG → ESP).
- **Cmd+D**: Popup de diccionarios con links a DLE (RAE), DEM (Colmex) y DA (ASALE).
- **Textarea en celda**: Enter abre un textarea real con cursor libre, selección parcial con Shift+flechas, y Cmd+C para copiar texto.
- **Tab Excluidos**: Nuevo filtro en las pestañas cuando hay personajes o reacciones excluidos.
- **Mensajes de error descriptivos**: Cada archivo muestra qué falló específicamente al parsearlo.
- **Error handler visual**: Si hay un error de runtime, aparece en pantalla en vez de quedarse en blanco.

### Corregido
- **Tag "MAIN TITLE IN DIALOGUE"**: Ya no se excluye erróneamente. El filtro ahora usa match exacto por tag individual (separados por coma).
- **KNP word boundaries**: Términos cortos como "Ce" o "Vo" ya no matchean dentro de otras palabras ("hacer", "Voss"). Usa `isLetter()` en vez de regex.
- **Clipboard en file://**: Todas las operaciones de copiado usan fallback con textarea oculto + `execCommand('copy')`.
- **Tooltip KNP**: Cambiado a `position:fixed` con seguimiento del cursor. Ya no se corta por overflow de la tabla.

### Eliminado
- Sistema de anotaciones para bitácora (incompatible con el flujo real de trabajo).
- Botón de exportar markers Pro Tools (PT no importa markers desde .txt).

## [1.0.0] - 2026-03-31

### Funciones principales
- Cotejo PLDL vs Pro Tools Session Info por timecodes con tolerancia configurable.
- Matching en 3 niveles: track principal → nombre de clip → global con validación.
- Normalización: acentos (NFD), apóstrofes, espacios, diéresis.
- Filtro de stems/mezclas (clips > 2 min).
- Soporte drop frame (`;` como separador, 29.97fps).
- Exclusión de no-diálogo: WALLA, GRAPHICS, TITLES, SONGS, AD, PRINCIPAL PHOTOGRAPHY.

### Dub Script
- Cruce en 3 pasadas: TC+Source exacto → texto inglés → TC overlap (±50s).
- Selector de idioma: Original / English / Español.

### KNP
- Highlighting de términos en columna de diálogo con tooltips.
- Columna KNP con términos detectados por línea.

### Tabla
- Columnas configurables y redimensionables.
- Selección de celdas tipo Excel (click, Shift+click, Cmd+C).
- Navegación por teclado (flechas, Tab, Enter, Escape).

### Exportar
- Descargar faltantes (.tsv).
- Copiar al portapapeles.
