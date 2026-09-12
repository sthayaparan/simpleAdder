using Serilog;
using SimpleAdder.Api;

var builder = WebApplication.CreateBuilder(args);

builder.Host.UseSerilog((context, services, configuration) => configuration
    .ReadFrom.Configuration(context.Configuration)
    .WriteTo.Console()
    .WriteTo.File("logs/simpleadder-.log", rollingInterval: RollingInterval.Day));

builder.Services.AddOpenApi();
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy => policy
        .WithOrigins("http://localhost:3000")
        .AllowAnyHeader()
        .AllowAnyMethod());
});

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseCors();

app.MapGet("/health", () => Results.Ok());

app.MapPost("/api/add", (AddRequest request, ILogger<Program> logger) =>
{
    if (!double.IsFinite(request.A) || !double.IsFinite(request.B))
    {
        logger.LogWarning("Rejected add request with non-finite operands: {A}, {B}", request.A, request.B);
        return Results.BadRequest("Both numbers must be finite.");
    }

    var result = Adder.Add(request.A, request.B);
    logger.LogInformation("Added {A} + {B} = {Result}", request.A, request.B, result);
    return Results.Ok(new AddResponse(result));
});

app.Run();

public partial class Program;

public record AddRequest(double A, double B);

public record AddResponse(double Result);
