---
name: cost-estimate
description: Estimate development cost of a codebase based on lines of code and complexity
---

# Cost Estimate Command

You are a senior software engineering consultant tasked with estimating the development cost of the current codebase.

## Step 1: Analyze the Codebase

Read the entire codebase to understand:
- Total lines of code per language
- Architectural complexity (frameworks, integrations, APIs)
- Advanced features and specialized domains
- Testing coverage
- Documentation quality

Use the Glob and Read tools to systematically review:
- All source files
- All test files
- Build scripts and configuration files

## Step 2: Calculate Development Hours

Based on industry standards for a **senior full-stack developer** (5+ years experience):

**Hourly Productivity Estimates**:
- Simple CRUD/UI code: 30-50 lines/hour
- Complex business logic: 20-30 lines/hour
- GPU/compute programming: 10-20 lines/hour
- Native interop (FFI, C extensions): 10-20 lines/hour
- Media processing (video/audio): 10-15 lines/hour
- System extensions/plugins: 8-12 lines/hour
- Comprehensive tests: 25-40 lines/hour

**Additional Time Factors**:
- Architecture & design: +15-20% of coding time
- Debugging & troubleshooting: +25-30% of coding time
- Code review & refactoring: +10-15% of coding time
- Documentation: +10-15% of coding time
- Integration & testing: +20-25% of coding time
- Learning curve (new frameworks): +10-20% for specialized tech

**Calculate total hours** considering:
1. Base coding hours (lines of code / productivity rate)
2. Multipliers for complexity and overhead
3. Phases completed vs. remaining
4. Specialized knowledge required (CoreMediaIO, Metal, etc.)

## Step 3: Research Market Rates

Use WebSearch to find current 2025 hourly rates for:
- Senior full-stack developers (5-10 years experience)
- Specialized iOS/macOS developers
- Contractors vs. employees
- Geographic variations (US markets: SF Bay Area, NYC, Austin, Remote)

Search queries to use:
- "senior full stack developer hourly rate 2025"
- "macOS/iOS/web/backend developer contractor rate 2025" (adjust to project domain)
- "senior software engineer hourly rate United States 2025"
- "[primary language] developer freelance rate 2025"

## Step 4: Calculate Organizational Overhead

Real companies don't have developers coding 40 hours/week. Account for typical organizational overhead to convert raw development hours into realistic calendar time.

**Weekly Time Allocation for Typical Company**:

| Activity              | Hours/Week | Notes                              |
| --------------------- | ---------- | ---------------------------------- |
| **Pure coding time**  | 20-25 hrs  | Actual focused development         |
| Daily standups        | 1.25 hrs   | 15 min × 5 days                    |
| Weekly team sync      | 1-2 hrs    | All-hands, team meetings           |
| 1:1s with manager     | 0.5-1 hr   | Weekly or biweekly                 |
| Sprint planning/retro | 1-2 hrs    | Per week average                   |
| Code reviews (giving) | 2-3 hrs    | Reviewing teammates' work          |
| Slack/email/async     | 3-5 hrs    | Communication overhead             |
| Context switching     | 2-4 hrs    | Interruptions, task switching      |
| Ad-hoc meetings       | 1-2 hrs    | Unplanned discussions              |
| Admin/HR/tooling      | 1-2 hrs    | Timesheets, tools, access requests |

**Coding Efficiency Factor**:
- **Startup (lean)**: 60-70% coding time (~24-28 hrs/week)
- **Growth company**: 50-60% coding time (~20-24 hrs/week)
- **Enterprise**: 40-50% coding time (~16-20 hrs/week)
- **Large bureaucracy**: 30-40% coding time (~12-16 hrs/week)

**Calendar Weeks Calculation**:
```
Calendar Weeks = Raw Dev Hours ÷ (40 × Efficiency Factor)
```

Example: 3,288 raw dev hours at 50% efficiency = 3,288 ÷ 20 = **164.4 weeks** (~3.2 years)

## Step 5: Calculate Full Team Cost

Engineering doesn't ship products alone. Calculate the fully-loaded team cost including all supporting roles.

**Supporting Role Ratios** (expressed as ratio to engineering hours):

| Role                       | Ratio to Eng Hours | Typical Rate | Notes                                  |
| -------------------------- | ------------------ | ------------ | -------------------------------------- |
| Product Management         | 0.25-0.40×         | $125-200/hr  | PRDs, roadmap, stakeholder mgmt        |
| UX/UI Design               | 0.20-0.35×         | $100-175/hr  | Wireframes, mockups, design systems    |
| Engineering Management     | 0.12-0.20×         | $150-225/hr  | 1:1s, hiring, performance, strategy    |
| QA/Testing                 | 0.15-0.25×         | $75-125/hr   | Test plans, manual testing, automation |
| Project/Program Management | 0.08-0.15×         | $100-150/hr  | Schedules, dependencies, status        |
| Technical Writing          | 0.05-0.10×         | $75-125/hr   | User docs, API docs, internal docs     |
| DevOps/Platform            | 0.10-0.20×         | $125-200/hr  | CI/CD, infra, deployments              |

**Team Composition by Company Stage**:

| Stage          | PM  | Design | EM  | QA  | PgM | Docs | DevOps |
| -------------- | --- | ------ | --- | --- | --- | ---- | ------ |
| Solo/Founder   | 0%  | 0%     | 0%  | 0%  | 0%  | 0%   | 0%     |
| Lean Startup   | 15% | 15%    | 5%  | 5%  | 0%  | 0%   | 5%     |
| Growth Company | 30% | 25%    | 15% | 20% | 10% | 5%   | 15%    |
| Enterprise     | 40% | 35%    | 20% | 25% | 15% | 10%  | 20%    |

**Full Team Multiplier**:
- **Solo/Founder**: 1.0× (just engineering)
- **Lean Startup**: ~1.45× engineering cost
- **Growth Company**: ~2.2× engineering cost
- **Enterprise**: ~2.65× engineering cost

**Calculation**:
```
Full Team Cost = Engineering Cost × Team Multiplier
```

Example: $500K engineering cost at Growth Company = $500K × 2.2 = **$1.1M total team cost**

## Step 6: Generate Cost Estimate

Provide a comprehensive estimate in this format:

---

## [Project Name] - Development Cost Estimate

**Analysis Date**: [Current Date]

### Codebase Metrics

- **Total Lines of Code**: [number]
  - [Language 1]: [number] lines
  - [Language 2]: [number] lines
  - Tests: [number] lines
  - Documentation: [number] lines

- **Complexity Factors**:
  - Advanced frameworks: [list key ones]
  - Specialized domains: [list]
  - Third-party integrations: [list]

### Development Time Estimate

**Base Development Hours**: [number] hours
- [Phase 1]: [hours] hours
- [Phase 2]: [hours] hours
- [Phase N]: [hours] hours

**Overhead Multipliers**:
- Architecture & Design: +[X]% ([hours] hours)
- Debugging & Troubleshooting: +[X]% ([hours] hours)
- Code Review & Refactoring: +[X]% ([hours] hours)
- Documentation: +[X]% ([hours] hours)
- Integration & Testing: +[X]% ([hours] hours)
- Learning Curve: +[X]% ([hours] hours)

**Total Estimated Hours**: [number] hours

### Realistic Calendar Time (with Organizational Overhead)

| Company Type        | Efficiency | Coding Hrs/Week | Calendar Weeks | Calendar Time |
| ------------------- | ---------- | --------------- | -------------- | ------------- |
| Solo/Startup (lean) | 65%        | 26 hrs          | [X] weeks      | ~[X] months   |
| Growth Company      | 55%        | 22 hrs          | [X] weeks      | ~[X] years    |
| Enterprise          | 45%        | 18 hrs          | [X] weeks      | ~[X] years    |
| Large Bureaucracy   | 35%        | 14 hrs          | [X] weeks      | ~[X] years    |

**Overhead Assumptions**:
- Standups, team syncs, 1:1s, sprint ceremonies
- Code reviews (giving), Slack/email, ad-hoc meetings
- Context switching, admin/tooling overhead

### Market Rate Research

**Senior Full-Stack Developer Rates (2025)**:
- Low end: $[X]/hour (remote, mid-level market)
- Average: $[X]/hour (standard US market)
- High end: $[X]/hour (SF Bay Area, NYC, specialized)

**Recommended Rate for This Project**: $[X]/hour

*Rationale*: [Explain why this rate based on the project's specific technology requirements]

### Total Cost Estimate

| Scenario | Hourly Rate | Total Hours | **Total Cost** |
| -------- | ----------- | ----------- | -------------- |
| Low-end  | $[X]        | [hours]     | **$[X,XXX]**   |
| Average  | $[X]        | [hours]     | **$[X,XXX]**   |
| High-end | $[X]        | [hours]     | **$[X,XXX]**   |

**Recommended Estimate (Engineering Only)**: **$[X,XXX] - $[X,XXX]**

### Full Team Cost (All Roles)

| Company Stage  | Team Multiplier | Engineering Cost | **Full Team Cost** |
| -------------- | --------------- | ---------------- | ------------------ |
| Solo/Founder   | 1.0×            | $[X]             | **$[X]**           |
| Lean Startup   | 1.45×           | $[X]             | **$[X]**           |
| Growth Company | 2.2×            | $[X]             | **$[X]**           |
| Enterprise     | 2.65×           | $[X]             | **$[X]**           |

**Role Breakdown (Growth Company Example)**:

| Role                   | Hours       | Rate    | Cost     |
| ---------------------- | ----------- | ------- | -------- |
| Engineering            | [X] hrs     | $[X]/hr | $[X]     |
| Product Management     | [X] hrs     | $[X]/hr | $[X]     |
| UX/UI Design           | [X] hrs     | $[X]/hr | $[X]     |
| Engineering Management | [X] hrs     | $[X]/hr | $[X]     |
| QA/Testing             | [X] hrs     | $[X]/hr | $[X]     |
| Project Management     | [X] hrs     | $[X]/hr | $[X]     |
| Technical Writing      | [X] hrs     | $[X]/hr | $[X]     |
| DevOps/Platform        | [X] hrs     | $[X]/hr | $[X]     |
| **TOTAL**              | **[X] hrs** |         | **$[X]** |

### Grand Total Summary

| Metric            | Solo     | Lean Startup | Growth Co | Enterprise |
| ----------------- | -------- | ------------ | --------- | ---------- |
| Calendar Time     | [X]      | [X]          | [X]       | [X]        |
| Total Human Hours | [X]      | [X]          | [X]       | [X]        |
| **Total Cost**    | **$[X]** | **$[X]**     | **$[X]**  | **$[X]**   |

### Assumptions

1. Rates based on US market averages (2025)
2. Full-time equivalent allocation for all roles
3. Includes complete implementation of MVP features
4. Does not include:
   - Marketing & sales
   - Legal & compliance
   - Office/equipment
   - Hosting/infrastructure
   - Ongoing maintenance post-launch

### Comparison: AI-Assisted Development

**Estimated time savings with LLM**: [X]%
**Effective hourly rate with AI assistance**: ~$[X]/hour equivalent productivity

## Step 7: Calculate LLM ROI — Value Per LLM Hour

This is the most important metric for understanding AI-assisted development efficiency. It answers: **"What did each hour of LLM's actual working time produce?"**

### 7a: Determine Actual LLM Clock Time

**Method 1: Git History (preferred)**

Run `git log --format="%ai" | sort` to get all commit timestamps. Then:
1. **First commit** = project start
2. **Last commit** = current state
3. **Total calendar days** = last - first
4. **Cluster commits into sessions**: group commits within 4-hour windows as one session
5. **Estimate session duration**: each session ≈ 1-4 hours of active LLM work (use commit density as signal — many commits = longer session)

**Session Duration Heuristics**:
- 1-2 commits in a window → ~1 hour session
- 3-5 commits in a window → ~2 hour session
- 6-10 commits in a window → ~3 hour session
- 10+ commits in a window → ~4 hour session

**Method 2: File Modification Timestamps (no git)**

Use `find . -name "*.ts" -o -name "*.swift" -o -name "*.py" | xargs stat -f "%Sm" | sort` to get file mod times. Apply same session clustering logic.

**Method 3: Fallback Estimate**

If no reliable timestamps, estimate from lines of code:
- Assume LLM writes 200-500 lines of meaningful code per hour (much faster than humans)
- LLM active hours ≈ Total LOC ÷ 350

### 7b: Calculate Value per LLM Hour

```
Value per LLM Hour = Total Code Value (from Step 5) ÷ Estimated LLM Active Hours
```

Calculate across scenarios:

| Code Value Scenario               | LLM Hours (est.) | Value per LLM Hour |
| --------------------------------- | ------------------- | --------------------- |
| Engineering only (avg)            | [X] hrs             | **$[X,XXX]/hr**       |
| Full team equivalent (Growth Co)  | [X] hrs             | **$[X,XXX]/hr**       |
| Full team equivalent (Enterprise) | [X] hrs             | **$[X,XXX]/hr**       |

### 7c: LLM Efficiency vs. Human Developer

**Speed Multiplier**:
```
Speed Multiplier = Human Dev Hours ÷ LLM Active Hours
```

Example: If a human would need 500 hours but LLM did it in 20 hours → 25× faster

**Cost Efficiency**:
```
Human Cost = Human Hours × $150/hr
LLM Cost = Subscription ($20-200/month) + API costs (estimate from project size)
Savings = Human Cost - LLM Cost
ROI = Savings ÷ LLM Cost
```

### 7d: Output Format

Add this section to the final report:

---

### LLM ROI Analysis

**Project Timeline**:
- First commit / project start: [date]
- Latest commit: [date]
- Total calendar time: [X] days ([X] weeks)

**LLM Active Hours Estimate**:
- Total sessions identified: [X] sessions
- Estimated active hours: [X] hours
- Method: [git clustering / file timestamps / LOC estimate]

**Value per LLM Hour**:

| Value Basis           | Total Value | LLM Hours | $/LLM Hour          |
| --------------------- | ----------- | ------------ | ---------------------- |
| Engineering only      | $[X]        | [X] hrs      | **$[X,XXX]/LLM hr** |
| Full team (Growth Co) | $[X]        | [X] hrs      | **$[X,XXX]/LLM hr** |

**Speed vs. Human Developer**:
- Estimated human hours for same work: [X] hours
- LLM active hours: [X] hours
- **Speed multiplier: [X]×** (LLM was [X]× faster)

**Cost Comparison**:
- Human developer cost: $[X] (at $150/hr avg)
- Estimated LLM cost: $[X] (subscription + API)
- **Net savings: $[X]**
- **ROI: [X]×** (every $1 spent on LLM produced $[X] of value)

**The headline number**: *LLM worked for approximately [X] hours and produced the equivalent of $[X] in professional development value — roughly **$[X,XXX] per LLM hour**.*

---

---

## Notes

Present the estimate in a clear, professional format suitable for sharing with stakeholders. Include confidence intervals and key assumptions. Highlight areas of highest complexity that drive cost.
