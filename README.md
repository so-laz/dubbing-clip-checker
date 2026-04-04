# 🐘 Dubbing Clip Checker (DCC)

Herramienta web standalone para cotejo automatizado de clips de doblaje. Cruza el Dialog List del cliente (PLDL) contra la sesión de Pro Tools para detectar diálogos faltantes.

Desarrollado para el flujo de QC de **Newart** (doblaje, Ciudad de México).

---

## Cómo funciona

1. Sube la **PLDL** (.xlsx) — Dialog List del cliente
2. *(Opcional)* **Dub Script** (.xlsx) — Guion traducido al español
3. *(Opcional)* **KNP** (.xlsx) — Key Names & Phrases del cliente
4. Exporta tu sesión: `File → Export → Session Info as Text`
5. Ajusta tolerancia y dale **▶ Cotejar**

### Matching de clips (3 niveles)

1. **Track principal** — Mapea SOURCE → track de PT por nombre normalizado
2. **Todos los tracks** — Busca en FUTZ, ALT, SEC_*, etc., verificando que el clip pertenezca al personaje
3. **No encontrado** → marca como FALTANTE

### Normalización

| Caso | PLDL | Pro Tools |
|------|------|-----------|
| Acentos | `MÜLLER` | `MULLER_OscarFlores` |
| Apóstrofes | `ZACK'S MOTHER` | `ZACKS_MOTHER_LauraTorres` |
| Espacios | `VANESSA LACHEY` | `VANESSA_LACHEY_JulietaRivera` |
| Drop frame | `00:08:22;12` | `00:08:22:12` |

Filtra automáticamente stems y mezclas (clips > 2 minutos).

---

## Funciones

### Cotejo
- Tolerancia configurable ±0 a ±24 frames
- Exclusión automática de no-diálogo (WALLA, GRAPHICS, TITLES, SONGS, AD, PRINCIPAL PHOTOGRAPHY)
- Exclusión manual de personajes (👤 Personajes) — aparecen como EXCLUIDO sin inflar faltantes
- Exclusión de reacciones ([REACTION], [REAC], (RISA), etc.)
- Filtros: Todos / Faltantes / Grabados / Excluidos + por personaje + búsqueda libre

### Soporte trilingüe (Dub Script opcional)
- Selector de idioma: Original / ENG / ESP
- **Cmd+L** cicla entre idiomas
- Cruce PLDL ↔ Dub Script: TC exacto + Source → texto inglés → TC overlap (±50s)

### KNP — Key Names & Phrases (opcional)
- Resalta términos en diálogo con tooltip flotante (hover)
- Columna KNP con términos detectados por línea
- Matching por palabra completa (no matchea dentro de otras palabras)

### Tabla tipo Excel
- Columnas configurables y redimensionables
- Navegación: flechas, Tab, Shift+flechas para rango
- **Enter** = textarea con cursor libre dentro de la celda
- **Cmd+C** = copia celdas seleccionadas (funciona en file://)
- **Escape** = salir de modo texto o deseleccionar

### Diccionarios (Cmd+D)
- Popup con links directos a DLE (RAE), DEM (Colmex), DA (ASALE)
- Funciona con texto seleccionado en modo textarea o con celda completa

### Exportar
- **↓ Descargar faltantes** (.tsv)
- **📋 Copiar** al portapapeles (tab-separated, compatible Excel)

---

## Atajos de teclado

| Atajo | Acción |
|-------|--------|
| `↑↓←→` | Navegar entre celdas |
| `Shift+↑↓←→` | Extender selección |
| `Tab` / `Shift+Tab` | Siguiente / anterior celda |
| `Enter` | Modo texto (textarea con cursor) |
| `Escape` | Salir de modo texto / deseleccionar |
| `Cmd+C` | Copiar celdas o texto seleccionado |
| `Cmd+L` | Ciclar idioma (Original → ENG → ESP) |
| `Cmd+D` | Buscar en diccionarios (DLE, DEM, DA) |

---

## Requisitos

- Navegador web moderno (Chrome 90+, Safari 14+, Firefox 88+)
- Conexión a internet (CDN: React 18, Babel, SheetJS)
- No requiere instalación ni servidor

---

## Compatibilidad probada

| Proyecto | FPS | Notas |
|----------|-----|-------|
| Love Is Blind S10 | 23.976 | Netflix |
| Crooks S2 | 24 | Netflix, TCs diferentes entre PLDL y Dub Script |
| Salish & Jordan Matter S1 | 29.97 drop | Netflix, TCs idénticos, TRANSCRIPTION vacía |
| The Boroughs S1 | 24 | Netflix, tracks numéricos, tag MAIN TITLE IN DIALOGUE |
| Stranger Things | 24 | KNP testing |

---

## Licencia

MIT — Ver [LICENSE](LICENSE)
