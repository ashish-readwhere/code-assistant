---
name: debug-error
description: Analyzes provided error messages and stack traces to identify the root cause, determine origin (code vs. dependency), and suggest concrete, prioritized fixes, along with suggested search terms and a git commit line.
---

# Debug Error Analysis

## Inputs

Please paste the full error message and stack trace you are encountering. If possible, also include the context (e.g., the specific function or file being executed).

## Analysis Steps

1.  **Analyze & Identify:**
    - **Error Type:** What is the specific type of error (e.g., `TypeError`, `NameError`, `ReferenceError`, network timeouts, etc.)?
    - **Root Cause:** What is the fundamental reason this error is occurring? (Be as precise as possible, e.g., "Attempting to read a non-existent file path," or "Passing a null value where an object was expected.")
2.  **Determine Origin:**
    - Based on the stack trace, does the error appear to originate from:
      - A core dependency (e.g., React, pandas, Django)?
      - My own application code?
      - A combination of both?
3.  **Suggest Fixes:**
    - Provide 2-3 concrete, actionable fixes. These fixes must be ranked by likelihood (Most Likely First).
      - _Fix 1 (Highest Likelihood):_ [Description of the fix, usually indicating a missing check or incorrect parameter].
      - _Fix 2 (Medium Likelihood):_ [Description of the fix, e.g., upgrading dependency, changing configuration].
      - _Fix 3 (Lower Likelihood):_ [Description of the fix, e.g., adjusting the calling order].
4.  **If unable to resolve:**
    - If the error is ambiguous or requires external context, provide 2-3 specific search queries (including relevant error snippets and library names) that I should use to search the web or documentation.
5.  **Final Output:**
    - Provide a single, concise, one-liner explanation that could be used as a message for a `git commit -m` command after the fix has been implemented.

**Example Output Structure:**

- **Error Type:** UsageError (Incorrect parameter type)
- **Root Cause:** The `calculate` function expects an integer for `items_count` but is receiving a string ('N/A') due to prior data transformation.
- **Origin:** My own application code (File: `utils.py`)
- **Suggested Fixes:**
  1.  **(Most Likely):** Before calling `calculate`, explicitly convert the input data field in `utils.py` to an integer: `int(data['items_count'])`.
  2.  **(Medium Likelihood):** Add a validation check in the data loading pipeline to ensure `items_count` fields are never null or non-numeric.
  3.  **(Lower Likelihood):** Review the `calculate` function signature to ensure robust type hinting or default values are applied.
- **Search Terms:**
  - "python TypeError: unsupported operand type(s) for +: 'int' and 'str'"
  - "validate data type in python list comprehension"
- **Git Commit Line:** `Fix: Ensure items_count is an integer before calculating totals.`
