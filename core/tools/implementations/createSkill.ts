import { ToolImpl } from ".";
import { walkDirCache } from "../../indexing/walkDir";
import { getStringArg } from "../parseArgs";
import { joinPathsToUri } from "../../util/uri";
import { ContinueError, ContinueErrorReason } from "../../util/errors";

function sanitizeSkillName(name: string): string {
  return name
    .toLowerCase()
    .replace(/[^a-z0-9-_]/g, "-")
    .replace(/-+/g, "-")
    .replace(/^-|-$/g, "");
}

function buildSkillContent(
  name: string,
  description: string,
  content: string,
): string {
  return `---\nname: ${name}\ndescription: ${description}\n---\n\n${content}`;
}

export const createSkillImpl: ToolImpl = async (args, extras) => {
  const name = getStringArg(args, "name");
  const description = getStringArg(args, "description");
  const content = getStringArg(args, "content");

  const workspaceDirs = await extras.ide.getWorkspaceDirs();
  if (!workspaceDirs.length) {
    throw new ContinueError(
      ContinueErrorReason.PathResolutionFailed,
      "No workspace directory found to create skill in",
    );
  }

  const dirName = sanitizeSkillName(name);
  const skillDir = joinPathsToUri(
    workspaceDirs[0],
    ".claude",
    "skills",
    dirName,
  );
  const skillFileUri = joinPathsToUri(skillDir, "SKILL.md");

  const fileContent = buildSkillContent(name, description, content);
  await extras.ide.writeFile(skillFileUri, fileContent);
  walkDirCache.invalidate();
  await extras.ide.openFile(skillFileUri);

  return [
    {
      name: `Skill: ${name}`,
      description,
      content: `Skill "${name}" created successfully at .claude/skills/${dirName}/SKILL.md`,
      uri: {
        type: "file",
        value: skillFileUri,
      },
    },
  ];
};
