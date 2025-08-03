namespace X2Tools.Decompressor
{
    /// <summary>
    /// Descompresor Nemesis unificado que replica exactamente Compression.asm y loc_0015F5CA
    /// Implementación fiel del algoritmo completo de X-Men 2 Clone Wars
    /// </summary>
    public class NemesisDecompressorUnified
    {
        // Tablas precalculadas idénticas al assembly original (0015F4B8 y 0015F51C)
        private static readonly uint[] PrecalData1 = {
            0x00000000, 0x11111111, 0x22222222, 0x33333333,
            0x44444444, 0x55555555, 0x66666666, 0x77777777,
            0x88888888, 0x99999999, 0xAAAAAAAA, 0xBBBBBBBB,
            0xCCCCCCCC, 0xDDDDDDDD, 0xEEEEEEEE, 0xFFFFFFFF
        };

        private static readonly uint[] PrecalData2 = {
            0x00000000, 0x0000000F, 0x000000FF, 0x00000FFF,
            0x0000FFFF, 0x000FFFFF, 0x00FFFFFF, 0x0FFFFFFF,
            0xFFFFFFFF
        };

        private static readonly uint[] PositionMasks = {
            0x00000000, 0x0000000F, 0x000000F0, 0x00000F00,
            0x0000F000, 0x000F0000, 0x00F00000, 0x0F000000,
            0xF0000000
        };

        /// <summary>
        /// Tabla de decodificación expandida que replica exactamente la estructura en A1
        /// Generada por loc_0015F5CA desde tabla Shannon-Fano compacta
        /// </summary>
        private class DecodingTable
        {
            // Tabla expandida de 256 entradas para búsqueda directa O(1)
            // Cada entrada: [longitud_bits | valor_pixel] en formato word
            public ushort[] ExpandedTable { get; } = new ushort[256];
            public int NextIndex { get; set; } = 0;

            public void Clear()
            {
                Array.Clear(ExpandedTable, 0, ExpandedTable.Length);
                NextIndex = 0;
            }

            /// <summary>
            /// Construye tabla expandida replicando exactamente loc_0015F5CA
            /// </summary>
            public void BuildExpandedTable(byte codeLength, byte value)
            {
                // D1 = (codeLength << 8) | value (línea 0015F5DE-0015F5E0)
                ushort tableEntry = (ushort)((codeLength << 8) | value);

                // D0 = 8 - longitud_actual (línea 0015F5E2-0015F5E4)
                int bitsToFill = 8 - codeLength;

                int numEntries;
                if (bitsToFill == 0)
                {
                    // BEQ.b loc_0015F5F0 (línea 0015F5E6)
                    numEntries = 1;
                }
                else
                {
                    // LSL.w D2, D0 (línea 0015F5EC): D0 = 1 << (8-longitud)
                    numEntries = 1 << bitsToFill;
                }

                // MOVE.w D1, (A1)+; DBF D0, loc_0015F5F0 (línea 0015F5F0-0015F5F2)
                for (int i = 0; i < numEntries && NextIndex < 256; i++)
                {
                    ExpandedTable[NextIndex] = tableEntry;
                    NextIndex++;
                }
            }

            /// <summary>
            /// Obtiene longitud del código desde tabla expandida (byte alto)
            /// </summary>
            public byte GetCodeLength(int extractedCode)
            {
                if (extractedCode >= 0 && extractedCode < 256)
                {
                    return (byte)(ExpandedTable[extractedCode] >> 8);
                }
                return 8; // Fallback
            }

            /// <summary>
            /// Obtiene valor decodificado desde tabla expandida (byte bajo)
            /// </summary>
            public byte GetDecodedValue(int extractedCode)
            {
                if (extractedCode >= 0 && extractedCode < 256)
                {
                    return (byte)(ExpandedTable[extractedCode] & 0xFF);
                }
                return (byte)extractedCode; // Fallback
            }
        }

        // Variables de estado que replican registros del assembly
        private BinaryReader reader;
        private DecodingTable decodingTable;
        private ushort bitBuffer;        // D5 en assembly
        private int bitsAvailable;       // D6 en assembly  
        private uint longwordBuffer;     // D4 en assembly
        private int nibblePosition;      // D3 en assembly (8 -> 0)
        private List<byte> output;

        /// <summary>
        /// Descomprime un archivo Nemesis completo
        /// </summary>
        /// <param name="filePath">Ruta del archivo a descomprimir</param>
        /// <returns>Datos descomprimidos</returns>
        public static byte[] DecompressFile(byte[] fileData)
        {
            using var stream = new MemoryStream(fileData);

            var decompressor = new NemesisDecompressorUnified(stream);
            return decompressor.DecompressInternal();
        }

        private NemesisDecompressorUnified(Stream input)
        {
            reader = new BinaryReader(input);
            decodingTable = new DecodingTable();
            bitsAvailable = 0;
            nibblePosition = 8;
            longwordBuffer = 0;
            output = new List<byte>();
        }

        private byte[] DecompressInternal()
        {
            Console.WriteLine("=== DESCOMPRESOR NEMESIS UNIFICADO X-MEN 2 ===");
            Console.WriteLine("Replica exacta de Compression.asm + loc_0015F5CA");
            Console.WriteLine();

            try
            {
                // Paso 1: Leer header si existe (los primeros 2 bytes pueden ser tamaño)
                ReadHeader();

                // Paso 2: Cargar tabla Shannon-Fano usando algoritmo loc_0015F5CA
                LoadDecodingTableLoc0015F5CA();

                // Paso 3: Inicializar buffer de bits para descompresión
                InitializeBitBuffer();

                // Paso 4: Ejecutar bucle principal comp_init
                ExecuteDecompressionLoop();

                // Paso 5: Flush final
                if (nibblePosition < 8)
                {
                    FlushLongwordBuffer();
                }

                Console.WriteLine();
                Console.WriteLine($"=== DESCOMPRESIÓN COMPLETADA ===");
                Console.WriteLine($"Datos descomprimidos: {output.Count} bytes");

                return output.ToArray();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error durante descompresión: {ex.Message}");
                throw;
            }
        }

        /// <summary>
        /// Lee el header del archivo (puede contener tamaño u otra información)
        /// </summary>
        private void ReadHeader()
        {
            // Algunos archivos Nemesis comienzan con un header de 2 bytes
            // Verificar si los primeros bytes son un header válido
            var position = reader.BaseStream.Position;

            byte byte1 = reader.ReadByte();
            byte byte2 = reader.ReadByte();

            // Si los primeros bytes parecen ser tabla Shannon-Fano válida (longitud 1-8), retroceder
            if (byte1 >= 1 && byte1 <= 8)
            {
                reader.BaseStream.Position = position;
                Console.WriteLine("No se detectó header, comenzando directamente con tabla");
            }
            else
            {
                ushort headerValue = (ushort)((byte1 << 8) | byte2);
                Console.WriteLine($"Header detectado: 0x{headerValue:X4}");
            }
        }

        /// <summary>
        /// Carga tabla de decodificación replicando exactamente loc_0015F5CA
        /// A0 = tabla compacta en ROM, A1 = tabla expandida en RAM
        /// </summary>
        private void LoadDecodingTableLoc0015F5CA()
        {
            Console.WriteLine("Ejecutando loc_0015F5CA: construcción de tabla expandida Shannon-Fano");
            decodingTable.Clear();

            int compactEntries = 0;

            // loc_0015F5D2: bucle principal de construcción
            while (true)
            {
                if (reader.BaseStream.Position >= reader.BaseStream.Length)
                {
                    Console.WriteLine("Final del stream alcanzado leyendo tabla");
                    break;
                }

                // MOVE.b (A0)+, D2 (línea 0015F5D4)
                byte codeLength = reader.ReadByte();

                // CMPI.b #$FF, D2; BEQ.b loc_0015F5F8 (línea 0015F5D6-0015F5DA)
                if (codeLength == 0xFF)
                {
                    Console.WriteLine("Terminador de tabla encontrado (0xFF)");
                    break;
                }

                // Validación de longitud
                if (codeLength == 0 || codeLength > 8)
                {
                    Console.WriteLine($"Longitud inválida detectada: {codeLength}, retrocediendo");
                    reader.BaseStream.Position--;
                    break;
                }

                if (reader.BaseStream.Position >= reader.BaseStream.Length)
                {
                    Console.WriteLine("Final del stream después de longitud");
                    break;
                }

                // MOVE.b (A0)+, D1 (parte de línea 0015F5E0)
                byte pixelValue = reader.ReadByte();

                // Construir tabla expandida usando algoritmo exacto de loc_0015F5CA
                decodingTable.BuildExpandedTable(codeLength, pixelValue);
                compactEntries++;

                int bitsToFill = 8 - codeLength;
                int numExpandedEntries = (bitsToFill == 0) ? 1 : (1 << bitsToFill);

                Console.WriteLine($"Entrada {compactEntries}: {codeLength} bits -> valor 0x{pixelValue:X2} " +
                                $"(genera {numExpandedEntries} entradas expandidas)");
            }

            Console.WriteLine($"Tabla construida: {compactEntries} entradas compactas -> {decodingTable.NextIndex} expandidas");
            Console.WriteLine($"Posición después de tabla: 0x{reader.BaseStream.Position:X}");
        }

        /// <summary>
        /// Inicializa buffer de bits (D5, D6) - inicio de comp_init
        /// </summary>
        private void InitializeBitBuffer()
        {
            // Leer primeros 2 bytes del stream comprimido para formar buffer de 16 bits
            byte byte1 = reader.ReadByte();
            byte byte2 = reader.ReadByte();

            bitBuffer = (ushort)((byte1 << 8) | byte2);
            bitsAvailable = 16; // D6 = $0010

            Console.WriteLine($"Buffer inicializado: 0x{bitBuffer:X4} ({bitsAvailable} bits disponibles)");
        }

        /// <summary>
        /// Bucle principal de descompresión - comp_init exacto
        /// </summary>
        private void ExecuteDecompressionLoop()
        {
            Console.WriteLine("Iniciando bucle principal comp_init...");

            int pixelsProcessed = 0;

            while (reader.BaseStream.Position < reader.BaseStream.Length)
            {
                try
                {
                    // Extraer código de 8 bits con desplazamiento (D6 - 8)
                    int shiftValue = bitsAvailable - 8;
                    int extractedCode = (bitBuffer >> shiftValue) & 0xFF;

                    // CMPI.w #$00FC, D1 (línea original del assembly)
                    if (extractedCode >= 0xFC)
                    {
                        ProcessInlineData();
                    }
                    else
                    {
                        ProcessEncodedData(extractedCode);
                    }

                    pixelsProcessed++;

                    // Debug cada 100 píxeles
                    if (pixelsProcessed % 100 == 0)
                    {
                        Console.WriteLine($"Procesados {pixelsProcessed} códigos, output: {output.Count} bytes");
                    }
                }
                catch (EndOfStreamException)
                {
                    Console.WriteLine("Final del stream alcanzado");
                    break;
                }
            }

            Console.WriteLine($"Total códigos procesados: {pixelsProcessed}");
        }

        /// <summary>
        /// Procesa datos inline - Nem_PCD_InlineData exacto
        /// </summary>
        private void ProcessInlineData()
        {
            // SUBQ.w #6, D6 (línea 0015F540)
            bitsAvailable -= 6;

            // Recargar buffer si es necesario
            if (bitsAvailable < 9)
            {
                RefillBitBuffer();
            }

            // Extraer 8 bits de datos
            int shiftValue = bitsAvailable - 8;
            int pixelData = (bitBuffer >> shiftValue) & 0xFF;
            bitsAvailable -= 8;

            // Recargar buffer si es necesario
            if (bitsAvailable < 9)
            {
                RefillBitBuffer();
            }

            ProcessPixelData(pixelData);
        }

        /// <summary>
        /// Procesa datos codificados usando tabla expandida
        /// </summary>
        private void ProcessEncodedData(int extractedCode)
        {
            // Búsqueda directa en tabla expandida
            byte codeLength = decodingTable.GetCodeLength(extractedCode);

            // Restar longitud del código
            bitsAvailable -= codeLength;

            // Recargar buffer si es necesario
            if (bitsAvailable < 9)
            {
                RefillBitBuffer();
            }

            // Obtener valor decodificado
            byte decodedValue = decodingTable.GetDecodedValue(extractedCode);
            ProcessPixelData(decodedValue);
        }

        /// <summary>
        /// Recarga buffer de bits - ADDQ.w #8, D6; ASL.w #8, D5; MOVE.b (A0)+, D5
        /// </summary>
        private void RefillBitBuffer()
        {
            bitsAvailable += 8;
            bitBuffer <<= 8;
            bitBuffer |= reader.ReadByte();
        }

        /// <summary>
        /// Procesa datos de píxel - loc_0015F41A exacto
        /// </summary>
        private void ProcessPixelData(int pixelData)
        {
            int pixelIndex = pixelData & 0x0F;      // Nibble bajo
            int repeatCount = (pixelData & 0xF0) >> 4; // Nibble alto

            if (pixelIndex == 0)
            {
                // Píxeles transparentes
                ProcessTransparentPixels(repeatCount + 1);
            }
            else if (repeatCount == 0)
            {
                // Píxel individual
                ProcessSinglePixel(pixelIndex);
            }
            else
            {
                // Píxeles repetidos
                ProcessRepeatedPixels(pixelIndex, repeatCount + 1);
            }
        }

        /// <summary>
        /// Procesa píxeles transparentes (nibble bajo = 0)
        /// </summary>
        private void ProcessTransparentPixels(int count)
        {
            while (count > 0)
            {
                if (count == nibblePosition)
                {
                    FlushLongwordBuffer();
                    nibblePosition = 8;
                    longwordBuffer = 0;
                    break;
                }
                else if (count > nibblePosition)
                {
                    count -= nibblePosition;
                    FlushLongwordBuffer();
                    nibblePosition = 8;
                    longwordBuffer = 0;
                }
                else
                {
                    nibblePosition -= count;
                    break;
                }
            }
        }

        /// <summary>
        /// Procesa píxel individual (repeat count = 0)
        /// </summary>
        private void ProcessSinglePixel(int pixelIndex)
        {
            uint pixelPattern = PrecalData1[pixelIndex];
            uint positionMask = PositionMasks[nibblePosition];

            longwordBuffer |= pixelPattern & positionMask;
            nibblePosition--;

            if (nibblePosition == 0)
            {
                FlushLongwordBuffer();
                nibblePosition = 8;
                longwordBuffer = 0;
            }
        }

        /// <summary>
        /// Procesa píxeles repetidos (repeat count > 0)
        /// </summary>
        private void ProcessRepeatedPixels(int pixelIndex, int count)
        {
            uint pixelPattern = PrecalData1[pixelIndex];

            while (count > 0)
            {
                uint positionMask = PrecalData2[nibblePosition];

                if (count == nibblePosition)
                {
                    longwordBuffer |= pixelPattern & positionMask;
                    FlushLongwordBuffer();
                    nibblePosition = 8;
                    longwordBuffer = 0;
                    break;
                }
                else if (count > nibblePosition)
                {
                    longwordBuffer |= pixelPattern & positionMask;
                    FlushLongwordBuffer();
                    count -= nibblePosition;
                    nibblePosition = 8;
                    longwordBuffer = 0;
                }
                else
                {
                    nibblePosition -= count;
                    uint adjustedMask = positionMask - PrecalData2[nibblePosition];
                    longwordBuffer |= pixelPattern & adjustedMask;
                    break;
                }
            }
        }

        /// <summary>
        /// Envía longword al output en formato big-endian
        /// </summary>
        private void FlushLongwordBuffer()
        {
            byte[] bytes = new byte[4];
            bytes[0] = (byte)((longwordBuffer >> 24) & 0xFF);
            bytes[1] = (byte)((longwordBuffer >> 16) & 0xFF);
            bytes[2] = (byte)((longwordBuffer >> 8) & 0xFF);
            bytes[3] = (byte)(longwordBuffer & 0xFF);

            output.AddRange(bytes);
        }

        /// <summary>
        /// Programa principal para pruebas
        /// </summary>
        public static void Main(string[] args)
        {
            Console.WriteLine("=== DESCOMPRESOR NEMESIS UNIFICADO X-MEN 2 ===");
            Console.WriteLine("Replica exacta de Compression.asm + loc_0015F5CA");
            Console.WriteLine();

            if (args.Length < 2)
            {
                Console.WriteLine("Uso: NemesisDecompressorUnified <archivo_entrada> <archivo_salida>");
                Console.WriteLine();
                Console.WriteLine("Prueba con archivos de referencia:");
                args = new[] { @"research\f4f98_comprimido.bin", "output_unified_test.bin" };
            }

            try
            {
                string inputFile = args[0];
                string outputFile = args[1];

                Console.WriteLine($"Archivo entrada: {inputFile}");
                Console.WriteLine($"Archivo salida: {outputFile}");
                Console.WriteLine();

                var stopwatch = System.Diagnostics.Stopwatch.StartNew();

                if (!File.Exists(inputFile))
                    throw new FileNotFoundException($"Archivo no encontrado: {inputFile}");

                var fileData = File.ReadAllBytes(inputFile);

                byte[] decompressedData = DecompressFile(fileData);

                stopwatch.Stop();

                File.WriteAllBytes(outputFile, decompressedData);

                Console.WriteLine();
                Console.WriteLine("=== RESULTADO ===");
                Console.WriteLine($"✓ Descompresión completada en {stopwatch.ElapsedMilliseconds} ms");
                Console.WriteLine($"✓ Archivo guardado: {outputFile}");
                Console.WriteLine($"✓ Tamaño descomprimido: {decompressedData.Length} bytes");

                // Mostrar primeros bytes para verificación
                if (decompressedData.Length > 0)
                {
                    Console.WriteLine("Primeros 32 bytes:");
                    for (int i = 0; i < Math.Min(32, decompressedData.Length); i++)
                    {
                        Console.Write($"{decompressedData[i]:X2} ");
                        if ((i + 1) % 16 == 0) Console.WriteLine();
                    }
                    Console.WriteLine();
                }

                // Verificar contra archivo de referencia si existe
                string referenceFile = @"research\f4f98_descomprimido_verificado.bin";
                if (File.Exists(referenceFile))
                {
                    var referenceData = File.ReadAllBytes(referenceFile);
                    bool isIdentical = decompressedData.Length == referenceData.Length &&
                                     decompressedData.SequenceEqual(referenceData);

                    Console.WriteLine($"Verificación contra referencia: {(isIdentical ? "✓ IDÉNTICO" : "✗ DIFERENTE")}");
                    if (!isIdentical)
                    {
                        Console.WriteLine($"Tamaño esperado: {referenceData.Length}, obtenido: {decompressedData.Length}");
                    }
                }

            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}");
                Environment.Exit(1);
            }
        }
    }
}
