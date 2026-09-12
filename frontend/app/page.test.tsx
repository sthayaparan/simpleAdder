import { describe, expect, it, vi, beforeEach } from "vitest";
import { render, screen, fireEvent, waitFor } from "@testing-library/react";
import Home from "./page";
import { addNumbers } from "@/lib/api";

vi.mock("@/lib/api", () => ({
  addNumbers: vi.fn(),
}));

describe("Home", () => {
  beforeEach(() => {
    vi.mocked(addNumbers).mockReset();
  });

  it("shows the sum returned by the API", async () => {
    vi.mocked(addNumbers).mockResolvedValue(7);
    render(<Home />);

    fireEvent.change(screen.getByLabelText("First number"), { target: { value: "3" } });
    fireEvent.change(screen.getByLabelText("Second number"), { target: { value: "4" } });
    fireEvent.click(screen.getByRole("button", { name: "Add" }));

    await waitFor(() => expect(screen.getByTestId("result")).toHaveTextContent("Result: 7"));
    expect(addNumbers).toHaveBeenCalledWith(3, 4);
  });

  it("shows a validation error instead of calling the API when a field is empty", async () => {
    render(<Home />);

    fireEvent.change(screen.getByLabelText("First number"), { target: { value: "3" } });
    fireEvent.click(screen.getByRole("button", { name: "Add" }));

    expect(await screen.findByRole("alert")).toHaveTextContent("Enter two valid numbers.");
    expect(addNumbers).not.toHaveBeenCalled();
  });

  it("shows an error message when the API call fails", async () => {
    vi.mocked(addNumbers).mockRejectedValue(new Error("network error"));
    render(<Home />);

    fireEvent.change(screen.getByLabelText("First number"), { target: { value: "1" } });
    fireEvent.change(screen.getByLabelText("Second number"), { target: { value: "2" } });
    fireEvent.click(screen.getByRole("button", { name: "Add" }));

    expect(await screen.findByRole("alert")).toHaveTextContent("Could not reach the add service.");
  });
});
