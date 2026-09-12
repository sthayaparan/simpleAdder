using SimpleAdder.Api;
using Xunit;

namespace SimpleAdder.Api.Tests;

public class AdderTests
{
    [Theory]
    [InlineData(2, 3, 5)]
    [InlineData(-2, 3, 1)]
    [InlineData(0, 0, 0)]
    [InlineData(1.5, 2.25, 3.75)]
    public void Add_ReturnsSum(double a, double b, double expected)
    {
        Assert.Equal(expected, Adder.Add(a, b));
    }
}
