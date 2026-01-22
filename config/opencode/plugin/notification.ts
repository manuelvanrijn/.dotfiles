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
        // Get session details to check if it's a subagent
        const sessionData = event.data as { sessionId?: string };
        
        if (sessionData?.sessionId) {
          try {
            const session = await client.session.get({
              path: { id: sessionData.sessionId }
            });
            
            // Only trigger confetti for primary agents (sessions without a parent)
            // Subagents have a parentID property
            if (!session.data?.parentID) {
              await $`open raycast://confetti`;
            }
          } catch (error) {
            // If we can't get session info, skip the notification
            console.error("Failed to get session info:", error);
          }
        }
      }
    },
  };
};
