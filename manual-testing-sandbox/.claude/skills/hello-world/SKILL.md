---
name: hello-world
description: Greets the user by name.
---

# Skill: hello-world

# Description: Greets the user with a personalized message.

def greet_user(name: str) -> str:
"""
Generates a personalized greeting message.

    Args:
        name: The name of the user to greet.

    Returns:
        A string containing the greeting.
    """
    if not name:
        return "Hello! Please provide a name to receive a greeting."

    return f"Hello, {name}! Welcome to the world of skills."

# Example usage:

# print(greet_user("World"))
