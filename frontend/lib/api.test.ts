import { describe, expect, it, vi, beforeEach } from "vitest";
import { addNumbers } from "./api";

describe("addNumbers", () => {
  beforeEach(() => {
    vi.restoreAllMocks();
  });

  it("posts the two numbers and returns the result", async () => {
    const fetchMock = vi.fn().mockResolvedValue({
      ok: true,
      json: async () => ({ result: 5 }),
    });
    vi.stubGlobal("fetch", fetchMock);

    const result = await addNumbers(2, 3);

    expect(result).toBe(5);
    expect(fetchMock).toHaveBeenCalledWith(
      expect.stringContaining("/api/add"),
      expect.objectContaining({
        method: "POST",
        body: JSON.stringify({ a: 2, b: 3 }),
      }),
    );
  });

  it("throws when the response is not ok", async () => {
    vi.stubGlobal(
      "fetch",
      vi.fn().mockResolvedValue({ ok: false, json: async () => ({}) }),
    );

    await expect(addNumbers(2, 3)).rejects.toThrow("Failed to add numbers");
  });
});
