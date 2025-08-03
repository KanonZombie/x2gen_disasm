using System.Security.Cryptography;
using X2Tools.Decompressor.Tests.Infrastructure;

namespace X2Tools.Decompressor.Tests;

/// <summary>
/// Tests opcionales que usan archivos reales si están disponibles
/// Estos tests se saltan si los archivos no existen
/// </summary>
public class NemesisRealDataTests
{
    private const string CompressedFileName = "f4f98_comp.bin";
    private const string DecompressedFileName = "f4f98.bin";

    [Fact]
    public void DecompressRealData_WhenFilesAvailable_ShouldMatchVerifiedOutput()
    {
        byte[]? compressedData = TryLoadRealFile(CompressedFileName);
        byte[]? expectedData = TryLoadRealFile(DecompressedFileName);

        if (compressedData == null || expectedData == null)
        {
            Assert.Fail();
        }

        var actualOutput = NemesisDecompressorUnified.DecompressFile(compressedData);

        Assert.Equal(expectedData, actualOutput);

        string expectedHash = Convert.ToHexString(SHA256.HashData(expectedData));
        string actualHash = Convert.ToHexString(SHA256.HashData(actualOutput));

        Assert.Equal(expectedHash, actualHash);
    }

    [Fact]
    public void DecompressRealData_WhenFilesAvailable_ShouldMatchVerified_BlizzardBG()
    {
        byte[]? compressedData = TryLoadRealFile("BlizzardBG_comp.bin");
        byte[]? expectedData = TryLoadRealFile("BlizzardBG.bin");

        if (compressedData == null || expectedData == null)
        {
            Assert.Fail();
        }

        var actualOutput = NemesisDecompressorUnified.DecompressFile(compressedData);
        Assert.Equal(expectedData, actualOutput);
    }

    [Fact]
    public void DecompressRealData_WhenAvailable_ShouldHaveExpectedFormat()
    {
        byte[]? compressedData = TryLoadRealFile(CompressedFileName);

        Assert.True(compressedData.Length >= 2, "Archivo demasiado pequeño para tener header");

        ushort header = (ushort)((compressedData[0] << 8) | compressedData[1]);
        Assert.Equal(0x00E0, header);

        var output = NemesisDecompressorUnified.DecompressFile(compressedData);

        Assert.Equal(274, compressedData.Length);
        Assert.Equal(896, output.Length);

        double ratio = (double)compressedData.Length / output.Length;
        Assert.True(ratio > 0.30 && ratio < 0.31, $"Ratio de compresión inesperado: {ratio:P2}");
    }

    [Fact]
    public void DecompressRealData_WhenAvailable_ShouldMatchKnownPatterns()
    {
        byte[]? compressedData = TryLoadRealFile(CompressedFileName);

        var output = NemesisDecompressorUnified.DecompressFile(compressedData);

        Assert.True(output.Length > 10, "Output demasiado pequeño");

        bool hasValidValues = output.All(b => b <= 0xFF); // Obviamente true, pero verifica el array
        Assert.True(hasValidValues);

        var valueDistribution = output.GroupBy(b => b).ToDictionary(g => g.Key, g => g.Count());

        Assert.True(valueDistribution.Count > 5, "Muy pocos valores únicos para datos gráficos");
        Assert.True(valueDistribution.Count < 256, "Demasiados valores únicos");

    }

    /// <summary>
    /// Intenta cargar un archivo real desde TestData, retorna null si no existe
    /// </summary>
    private static byte[]? TryLoadRealFile(string fileName)
    {
        try
        {
            return TestDataHelper.LoadTestFile(fileName);
        }
        catch (FileNotFoundException)
        {
            return null;
        }
        catch (DirectoryNotFoundException)
        {
            return null;
        }
    }
}
