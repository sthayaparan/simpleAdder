const API_BASE_URL = process.env.NEXT_PUBLIC_API_BASE_URL ?? "http://localhost:5253";

export async function addNumbers(a: number, b: number): Promise<number> {
  const response = await fetch(`${API_BASE_URL}/api/add`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ a, b }),
  });

  if (!response.ok) {
    throw new Error("Failed to add numbers");
  }

  const data: { result: number } = await response.json();
  return data.result;
}
