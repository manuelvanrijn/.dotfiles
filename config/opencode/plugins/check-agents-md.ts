import { promises as fs } from "fs";
import { join } from "path";

const AGENTS_FILENAME = "AGENTS.md";

export const CheckAgentsMdPlugin = async ({
  project,
  client,
  $,
  directory,
  worktree,
}) => {
  return {
    event: async ({ event }) => {
      if (event.type === "session.created") {
        try {
          const agentsMdPath = join(directory, AGENTS_FILENAME);
          await fs.access(agentsMdPath);
        } catch {
          await client.tui.showToast({
            body: {
              title: "opencode",
              message: `No ${AGENTS_FILENAME} file found. Run /init to get started.`,
              variant: "warning",
              duration: 5000,
            },
          });
        }
      }
    },
  };
};
