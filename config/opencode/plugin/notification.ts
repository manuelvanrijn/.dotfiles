import type { Plugin } from "@opencode-ai/plugin";
export const NotificationPlugin: Plugin = async ({
  project,
  client,
  $,
  directory,
  worktree,
}) => {
  return {
    event: async ({ event }) => {
      if (event.type === "session.idle") {
        await $`open raycast://confetti`
      }
    },
  };
};
