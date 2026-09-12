"use client";

import { useState } from "react";
import { addNumbers } from "@/lib/api";
import styles from "./page.module.css";

export default function Home() {
  const [a, setA] = useState("");
  const [b, setB] = useState("");
  const [result, setResult] = useState<number | null>(null);
  const [error, setError] = useState<string | null>(null);

  async function handleAdd() {
    setError(null);
    setResult(null);

    const numA = Number(a);
    const numB = Number(b);
    if (a.trim() === "" || b.trim() === "" || Number.isNaN(numA) || Number.isNaN(numB)) {
      setError("Enter two valid numbers.");
      return;
    }

    try {
      const sum = await addNumbers(numA, numB);
      setResult(sum);
    } catch {
      setError("Could not reach the add service.");
    }
  }

  return (
    <div className={styles.page}>
      <main className={styles.main}>
        <h1>Simple Adder</h1>
        <div className={styles.form}>
          <input
            type="number"
            value={a}
            onChange={(e) => setA(e.target.value)}
            aria-label="First number"
            placeholder="First number"
          />
          <input
            type="number"
            value={b}
            onChange={(e) => setB(e.target.value)}
            aria-label="Second number"
            placeholder="Second number"
          />
          <button type="button" onClick={handleAdd}>
            Add
          </button>
        </div>
        {result !== null && <p data-testid="result">Result: {result}</p>}
        {error && (
          <p role="alert" data-testid="error">
            {error}
          </p>
        )}
      </main>
    </div>
  );
}
