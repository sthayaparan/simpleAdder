import { test, expect } from "@playwright/test";

test("adds two numbers using the backend API", async ({ page }) => {
  await page.goto("/");

  await page.getByLabel("First number").fill("12");
  await page.getByLabel("Second number").fill("30");
  await page.getByRole("button", { name: "Add" }).click();

  await expect(page.getByTestId("result")).toHaveText("Result: 42");
});

test("shows a validation error when a field is left empty", async ({ page }) => {
  await page.goto("/");

  await page.getByLabel("First number").fill("5");
  await page.getByRole("button", { name: "Add" }).click();

  await expect(page.getByTestId("error")).toHaveText("Enter two valid numbers.");
});
