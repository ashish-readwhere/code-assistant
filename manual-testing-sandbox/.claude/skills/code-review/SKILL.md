---
name: code-review
description: Performs a comprehensive, structured review of provided code snippets, focusing on best practices, security, performance, and readability across multiple dimensions.
---

### 🔎 General Observations

- **Overall Clarity:** (Is the intent of the code clear? Are function/variable names descriptive?)
- **Architecture/Structure:** (Does the file structure make sense? Are responsibilities separated correctly?)

### 🚀 Performance & Efficiency

- **Time Complexity:** (Identify any parts that could run in O(n^2) or worse. Suggest linear or constant time optimizations.)
- **Memory Usage:** (Is memory allocated efficiently? Are large data structures being handled correctly?)

### 🛡️ Security & Robustness

- **Input Validation:** (Are all external inputs validated? Are there paths sensitive to injection attacks?)
- **Error Handling:** (Is `try...catch` used correctly? Are exceptions caught and logged appropriately?)
- **Vulnerabilities:** (Identify potential injection vectors, hardcoded secrets, or insecure API usage.)

### ✨ Style & Best Practices

- **Readability:** (Are comments sufficient where logic is complex? Is indentation consistent?)
- **Language Idioms:** (Are the best practices of the language being followed? e.g., Python list comprehensions, JavaScript promises.)
- **Documentation:** (Are docstrings present for public functions? Is return type specified?)

### ✅ Suggested Improvements (Action Items)

1.  **[High Priority]:** (Most critical fix, e.g., fixing a security flaw.)
2.  **[Medium Priority]:** (Logic improvement, e.g., simplifying a complex loop.)
3.  **[Low Priority]:** (Style/Readability fix, e.g., renaming a poorly named variable.)

Please provide the code block you would like reviewed.
