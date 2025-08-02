# Descompresor Nemesis Unificado X-Men 2 Clone Wars

## Descripción

Este es un descompresor Nemesis completo que replica exactamente el algoritmo de compresión usado en X-Men 2 Clone Wars para Sega Genesis. Implementa fielmente tanto el bucle principal de descompresión (`comp_init`) como la construcción de tabla de códigos Shannon-Fano (`loc_0015F5CA`).

## Características

- **Replica exacta del assembly original**: Implementa línea por línea el código de `Compression.asm`
- **Construcción de tabla loc_0015F5CA**: Replica exactamente el algoritmo de expansión de tabla Shannon-Fano
- **Compatibilidad total**: Funciona con todos los formatos de archivo Nemesis del juego
- **Verificación automática**: Compara resultados contra archivos de referencia cuando están disponibles

## Uso

```bash
# Compilar el proyecto
dotnet build Tools\x2_gen.Tools\X2Tools.Decompressor\X2Tools.Decompressor.csproj

# Descomprimir un archivo
dotnet run --project Tools\x2_gen.Tools\X2Tools.Decompressor\X2Tools.Decompressor.csproj -- <archivo_entrada> <archivo_salida>
```

## Ejemplo con archivos de prueba

```bash
# Usar los archivos de prueba incluidos
dotnet run --project Tools\x2_gen.Tools\X2Tools.Decompressor\X2Tools.Decompressor.csproj

# El programa usará automáticamente:
# Entrada: research\f4f98_comprimido.bin
# Salida: output_unified_test.bin
# Y verificará contra: research\f4f98_descomprimido_verificado.bin
```

## Formato de archivos soportados

El descompresor maneja automáticamente varios formatos de archivo Nemesis:

1. **Con header**: Archivos que comienzan con 2 bytes de información de tamaño
2. **Sin header**: Archivos que comienzan directamente con la tabla Shannon-Fano
3. **Con terminador**: Tablas que terminan con byte `0xFF`
4. **Sin terminador**: Detección automática del final de tabla

## Estructura del algoritmo

### 1. Lectura de header (opcional)
- Detecta automáticamente si los primeros 2 bytes son header o tabla
- Maneja ambos formatos transparentemente

### 2. Construcción de tabla (loc_0015F5CA)
- Lee tabla Shannon-Fano compacta: `[longitud_bits][valor][longitud_bits][valor]...`
- Construye tabla expandida de 256 entradas para búsqueda O(1)
- Para cada entrada con N bits, crea `2^(8-N)` entradas expandidas

### 3. Descompresión principal (comp_init)
- Mantiene buffer de 16 bits para lectura eficiente
- Procesa tres tipos de datos:
  - **Códigos normales**: Usando tabla de decodificación
  - **Datos inline**: Códigos ≥ 0xFC (datos sin compresión)
  - **Píxeles transparentes**: Nibble bajo = 0

### 4. Construcción de output
- Genera longwords de 32 bits (8 píxeles de 4 bits cada uno)
- Formato big-endian compatible con Sega Genesis VDP

## Archivos de prueba incluidos

- `research\f4f98_comprimido.bin`: Datos extraídos del juego (274 bytes)
- `research\f4f98_descomprimido_verificado.bin`: Resultado esperado (896 bytes)

## Verificación de resultados

El programa verifica automáticamente que el resultado sea idéntico al archivo de referencia:

```
Verificación contra referencia: ✓ IDÉNTICO
```

## Detalles técnicos

### Tablas precalculadas
- `PrecalData1`: Patrones de píxeles para escritura directa
- `PrecalData2`: Máscaras de posición para píxeles repetidos
- `PositionMasks`: Máscaras de posición para píxeles individuales

### Compatibilidad con assembly
- Registros replicados: D0-D7, A0-A4 como variables C#
- Operaciones bit a bit idénticas al código original
- Manejo de buffer y recarga exacto

## Ejemplo de salida

```
=== DESCOMPRESOR NEMESIS UNIFICADO X-MEN 2 ===
Replica exacta de Compression.asm + loc_0015F5CA

Header detectado: 0x00E0
Ejecutando loc_0015F5CA: construcción de tabla expandida Shannon-Fano
Entrada 1: 1 bits -> valor 0x0D (genera 128 entradas expandidas)
Entrada 2: 3 bits -> valor 0x0E (genera 32 entradas expandidas)
...
Tabla construida: 23 entradas compactas -> 252 expandidas
Buffer inicializado: 0xB6DE (16 bits disponibles)
Iniciando bucle principal comp_init...
Total códigos procesados: 439

✓ Descompresión completada en 8 ms
✓ Archivo guardado: output_unified_test.bin
✓ Tamaño descomprimido: 896 bytes
Verificación contra referencia: ✓ IDÉNTICO
```

## Desarrollo

Este descompresor fue desarrollado mediante ingeniería inversa completa del código assembly original de X-Men 2 Clone Wars, asegurando compatibilidad 100% con el algoritmo original del juego.
