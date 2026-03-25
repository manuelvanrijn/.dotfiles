import { tool } from "@opencode-ai/plugin"

export default tool({
  description: "Search the workspace with seek",
  args: {
    pattern: tool.schema.string().describe("seek pattern to run"),
  },
  async execute(args, context) {
    const proc = Bun.spawn(["seek", "--", args.pattern], {
      cwd: context.worktree,
      stdout: "pipe",
      stderr: "pipe",
    })

    const [stdout, stderr, exitCode] = await Promise.all([
      new Response(proc.stdout).text(),
      new Response(proc.stderr).text(),
      proc.exited,
    ])

    if (exitCode === 1 && !stderr.trim()) return ""
    if (exitCode !== 0) throw new Error(stderr.trim() || `seek failed with exit code ${exitCode}`)

    return stdout.trim()
  },
})
