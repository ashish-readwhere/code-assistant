import { Tool } from "../..";
import { BUILT_IN_GROUP_NAME, BuiltInToolNames } from "../builtIn";

export const createSkillTool: Tool = {
  type: "function",
  displayTitle: "Create Skill",
  wouldLikeTo: "create skill {{{ name }}}",
  isCurrently: "creating skill {{{ name }}}",
  hasAlready: "created skill {{{ name }}}",
  group: BUILT_IN_GROUP_NAME,
  readonly: false,
  isInstant: true,
  function: {
    name: BuiltInToolNames.CreateSkill,
    description:
      "Create a new skill in the .claude/skills directory of the workspace. A skill is a markdown file with a name, description, and content that can be used to teach the assistant how to perform a specific task.",
    parameters: {
      type: "object",
      required: ["name", "description", "content"],
      properties: {
        name: {
          type: "string",
          description:
            "The name of the skill (used as both the identifier and folder name)",
        },
        description: {
          type: "string",
          description:
            "A short description of what the skill does and when to use it",
        },
        content: {
          type: "string",
          description:
            "The full markdown content of the skill — instructions, examples, and any relevant detail",
        },
      },
    },
  },
  defaultToolPolicy: "allowedWithPermission",
  systemMessageDescription: {
    prefix: `To create a new skill, use the ${BuiltInToolNames.CreateSkill} tool with a name, description, and content:`,
    exampleArgs: [
      ["name", "my-skill"],
      ["description", "Explains what this skill does"],
      ["content", "# My Skill\n\nDetailed instructions here..."],
    ],
  },
};
