using System.Net;
using System.Net.Http.Json;
using Microsoft.AspNetCore.Mvc.Testing;
using Xunit;

namespace SimpleAdder.Api.Tests;

public class AddEndpointTests(WebApplicationFactory<Program> factory) : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly HttpClient _client = factory.CreateClient();

    [Fact]
    public async Task PostAdd_WithValidNumbers_ReturnsSum()
    {
        var response = await _client.PostAsJsonAsync("/api/add", new AddRequest(2, 3));

        response.EnsureSuccessStatusCode();
        var body = await response.Content.ReadFromJsonAsync<AddResponse>();
        Assert.Equal(5, body!.Result);
    }

    [Fact]
    public async Task PostAdd_WithMissingBody_ReturnsBadRequest()
    {
        var response = await _client.PostAsync("/api/add", null);

        Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
    }

    [Fact]
    public async Task PostAdd_WithNonNumericField_ReturnsBadRequest()
    {
        var response = await _client.PostAsync(
            "/api/add",
            JsonContent.Create(new { a = "not-a-number", b = 3 }));

        Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
    }
}
