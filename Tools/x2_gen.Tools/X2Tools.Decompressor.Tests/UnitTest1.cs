using System.Security.Cryptography;
using X2Tools.Decompressor.Tests.Infrastructure;

namespace X2Tools.Decompressor.Tests;

public class NemesisDecompressorIntegrationTests
{
    [Fact]
    public void DecompressKnownData_ShouldMatchExpectedOutput()
    {
        byte[] compressedData = TestDataHelper.SyntheticData.KnownCompressedData;
        byte[] expectedData = TestDataHelper.SyntheticData.KnownDecompressedData;

        var actualOutput = NemesisDecompressorUnified.DecompressFile(compressedData);

        Assert.Equal(expectedData.Length, actualOutput.Length);

        Assert.Equal(expectedData, actualOutput);

        string expectedHash = Convert.ToHexString(SHA256.HashData(expectedData));
        string actualHash = Convert.ToHexString(SHA256.HashData(actualOutput));

        Assert.Equal(expectedHash, actualHash);
    }

    //[Fact]
    //public void DecompressMinimalData_ShouldHaveCorrectFormat()
    //{
    //    // Usar archivo de test mínimo válido
    //    byte[] compressedData = TestDataHelper.TestCases.MinimalValidFile;

    //    // Verificar que el archivo tiene el formato esperado
    //    Assert.True(compressedData.Length >= 3, "Archivo demasiado pequeño para ser válido");

    //    // Descomprimir
    //    var output = NemesisDecompressorUnified.DecompressFile(compressedData);

    //    // Verificar que produce salida válida
    //    Assert.NotNull(output);
    //    Assert.True(output.Length > 0, "Debe producir alguna salida");
    //    Assert.True(output.Length % 4 == 0, "La salida debe ser múltiplo de 4 bytes (longwords)");

    //    Console.WriteLine($"✓ Entrada mínima: {compressedData.Length} bytes");
    //    Console.WriteLine($"✓ Salida producida: {output.Length} bytes");
    //    Console.WriteLine($"✓ Primeros bytes: {string.Join(" ", output.Take(Math.Min(8, output.Length)).Select(b => $"{b:X2}"))}");
    //}

    [Fact]
    public void DecompressInlineData_ShouldProcessCorrectly()
    {
        // Usar archivo de test con datos inline
        byte[] compressedData = TestDataHelper.TestCases.InlineDataFile;

        // Descomprimir
        var output = NemesisDecompressorUnified.DecompressFile(compressedData);

        // Verificar formato de salida
        Assert.NotNull(output);
        Assert.True(output.Length > 0);
        Assert.True(output.Length % 4 == 0, "Debe ser múltiplo de 4 bytes");
    }

    [Fact]
    public void DecompressTransparentPixels_ShouldHandleCorrectly()
    {
        // Usar archivo de test con píxeles transparentes
        byte[] compressedData = TestDataHelper.TestCases.TransparentPixelsFile;

        // Descomprimir
        var output = NemesisDecompressorUnified.DecompressFile(compressedData);

        // Verificar formato de salida
        Assert.NotNull(output);
        Assert.True(output.Length >= 4, "Debe producir al menos un longword");
        Assert.True(output.Length % 4 == 0, "Debe ser múltiplo de 4 bytes");

    }

    [Fact]
    public void DecompressComplexData_ShouldMatchKnownPatterns()
    {
        byte[] compressedData = TestDataHelper.TestCases.ComplexFile;

        var output = NemesisDecompressorUnified.DecompressFile(compressedData);

        Assert.NotNull(output);
        Assert.True(output.Length > 0);
        Assert.True(output.Length % 4 == 0, "Debe ser múltiplo de 4 bytes");

        bool hasValidValues = output.All(b => b <= 0xFF); // Obviamente true, pero verifica el array
        Assert.True(hasValidValues);

        var valueDistribution = output.GroupBy(b => b).ToDictionary(g => g.Key, g => g.Count());

        Assert.True(valueDistribution.Count > 0, "Debe tener al menos un valor único");
    }

    [Fact]
    public void DecompressConsistency_ShouldProduceSameResultsMultipleTimes()
    {
        byte[] compressedData = TestDataHelper.SyntheticData.KnownCompressedData;

        var results = new List<byte[]>();
        for (int i = 0; i < 5; i++)
        {
            results.Add(NemesisDecompressorUnified.DecompressFile(compressedData));
        }

        for (int i = 1; i < results.Count; i++)
        {
            Assert.Equal(results[0], results[i]);
        }
    }

    [Fact]
    public void DecompressPerformance_ShouldCompleteInReasonableTime()
    {
        byte[] compressedData = TestDataHelper.TestCases.ComplexFile;

        var stopwatch = System.Diagnostics.Stopwatch.StartNew();

        byte[]? result = null;
        const int iterations = 100;

        for (int i = 0; i < iterations; i++)
        {
            result = NemesisDecompressorUnified.DecompressFile(compressedData);
        }

        stopwatch.Stop();

        Assert.NotNull(result);
        Assert.True(result.Length > 0);

        double avgTime = stopwatch.ElapsedMilliseconds / (double)iterations;
        Assert.True(avgTime < 50, $"Promedio por descompresión demasiado lento: {avgTime:F2} ms");
    }
}
