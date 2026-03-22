# 🛡️ GitHub Copilot Security Workshop

## Building Automated Security Into Every Line of Code

### A Full-Day Hands-On Workshop

---

**For the presenter:** This guide walks you through a complete workshop where experienced developers learn to build security automation using GitHub Copilot and GitHub Actions. Every module builds on the last. By the end, your audience will have a working security pipeline they can take back to their own projects.

This is Part 1. It covers the opening, Modules 1 and 2. Part 2 picks up at Module 3 (building the pipeline hands-on) and runs through the end of the day.

**What your audience walks away with:**

1. A working security pipeline with 9 automated scans they can copy to any repo
2. Understanding of when to use Actions vs CLI extensions vs manual tools (and why)
3. Hands-on experience with AI-assisted incident detection and remediation
4. A clear plan for what to do Monday morning

---

### Prerequisites Checklist

Before the workshop, every participant needs the following set up and working. Send this list one week ahead. Send it again two days ahead. Someone will still show up unprepared — have a buddy system ready.

**Repos to clone:**

| Repo | What It's For | Module |
|------|---------------|--------|
| [sautalwar/copilot-workshop](https://github.com/sautalwar/copilot-workshop) | Copilot basics — prompts, instructions, agents, MCP servers | 1 |
| [sautalwar/github-security-demo](https://github.com/sautalwar/github-security-demo) | The 9-workflow security pipeline | 2, 3 |
| [sautalwar/ghcopilot-pii-demo](https://github.com/sautalwar/ghcopilot-pii-demo) | PII scanner and secret detection | 4 |
| [sautalwar/it-security-copilot-demo](https://github.com/sautalwar/it-security-copilot-demo) | Incident response scenarios | 6 |
| [sautalwar/how_APIM_works](https://github.com/sautalwar/how_APIM_works) | API management and OWASP Top 10 | 5 |
| [sautalwar/FlightPlans](https://github.com/sautalwar/FlightPlans) | Legacy code modernization | 7 |

**Tools needed:**

- VS Code with the GitHub Copilot extension installed and signed in
- GitHub account with Copilot access (Individual, Business, or Enterprise)
- Node.js 18 or newer
- Python 3.8 or newer
- Docker Desktop running (we scan containers in Module 3)
- Git CLI
- `gh` CLI (GitHub's command-line tool) — install from <https://cli.github.com>

**Nice to have:**

- A second monitor (you'll follow along and code at the same time)
- Familiarity with YAML (if you've written a GitHub Actions workflow or a docker-compose file, you're fine)

---

## 📋 Workshop Schedule

| Time | Module | What We Cover | Duration |
|------|--------|---------------|----------|
| 9:00 AM | Opening | Why we're here, introductions | 15 min |
| 9:15 AM | Module 1: Meet Your AI Pair Programmer | Copilot basics, 4 building blocks | 45 min |
| 10:00 AM | Break | | 15 min |
| 10:15 AM | Module 2: Why Actions? The Case for Automation | Actions vs CLI vs manual — the honest comparison | 30 min |
| 10:45 AM | Module 3: Building Your Security Pipeline | Hands-on with 5 of the 9 security workflows | 60 min |
| 11:45 AM | Lunch | | 45 min |
| 12:30 PM | Module 4: When Things Go Wrong — Secure Vault | PII scanner, secret detection, auto-remediation | 45 min |
| 1:15 PM | Module 5: Securing APIs at Scale | APIM + OWASP Top 10 + agentic review | 30 min |
| 1:45 PM | Break | | 15 min |
| 2:00 PM | Module 6: A Day in the Life | Live incident response — 12 scenarios | 45 min |
| 2:45 PM | Module 7: Modernizing Without Breaking Security | FlightPlans for legacy code upgrades | 30 min |
| 3:15 PM | Module 8: What to Do Monday Morning | Recap, next steps, Q&A | 20 min |

---

## 🎯 The Story We're Telling

Most teams treat security like a final exam — they cram at the end and hope for the best. A developer writes code for weeks. Then, right before release, someone runs a scanner. It finds 47 issues. Half are false positives. The other half require reworking code that's already been reviewed, tested, and approved. Everyone's frustrated. The deadline slips. Next time, the team quietly skips the scan.

We're going to show you how to make security like spell-check: it runs constantly, catches mistakes as you type, and you barely notice it's there. Every push gets scanned. Every pull request gets checked. Problems show up in the same place your code review comments do — right in the PR, minutes after you push, not weeks later in a PDF report nobody reads. The difference is, now we have AI that makes this practical for the first time. Copilot can write the security checks, explain what they found, and often suggest the fix — all without you leaving your editor.

By 3:30 today, you'll have a working pipeline that does this. Not slides about it. Not a demo of someone else's pipeline. Your own, running on your own fork, scanning real code. And you'll understand every line of YAML in it — because you wrote it.

---

## 📘 Module 1: Meet Your AI Pair Programmer (45 min)

**Repo:** `sautalwar/copilot-workshop`

### What This Module Covers

GitHub Copilot is not autocomplete. Autocomplete predicts the next few characters. Copilot understands your codebase, follows your team's rules, and can call external tools. That distinction matters, because everything we build today depends on it.

This module covers the 4 building blocks:

1. **Prompts** — Pre-written instructions you can reuse. Think of them as saved recipes. Instead of typing "review this code for SQL injection, XSS, and auth bypass" every time, you write it once, save it as a prompt file, and reuse it across your team.

2. **Instructions** — Rules Copilot always follows in your repo. Like a style guide, but for AI. You put them in `.github/copilot-instructions.md` and Copilot reads them every time it generates code. If your team says "always use parameterized queries," put it here and Copilot will follow it.

3. **Skills** — Specific tasks Copilot can perform. You define what the task does and what inputs it needs. Think "run this security check" or "generate a test for this function." Skills turn Copilot from a conversationalist into a tool that does things.

4. **Agents** — Copilot personas for specific jobs. An agent is a skill set with a personality. You might have a "security reviewer" agent that always checks for OWASP Top 10 issues, or a "docs writer" agent that generates API documentation in your team's format.

### Why Start Here

> "Before we talk about security, you need to understand the tool. If I hand you a power drill without explaining the settings, you'll strip every screw. Copilot is the same — powerful, but you need to know the four building blocks before we start wiring them into pipelines."

> "You've all used Copilot for code completion. That's maybe 20% of what it can do. Today we're going to use the other 80%."

### What to Show (Step by Step)

**Step 1: Open the repo**

Open `copilot-workshop` in VS Code. Give people 30 seconds to do the same.

> "This repo is a small Node.js app with intentional security problems. We planted them there. Don't judge."

**Step 2: Show @workspace context**

Open Copilot Chat. Type: `@workspace what does this project do?`

> "See how it read the whole repo — package.json, the route files, the README — and gave you a summary? That's @workspace. It means Copilot isn't guessing. It read your code. This is the biggest difference from ChatGPT or Claude. Those tools only see what you paste into them. Copilot sees your whole repo."

**What to say:** Point out that Copilot referenced specific files. It didn't make up function names. This is grounded in your actual code.

**Step 3: Show copilot-instructions.md**

Open `.github/copilot-instructions.md` in the repo.

> "This file is like a team agreement with your AI. Anything you put here, Copilot follows every time it writes code in this repo. Watch this."

Show the instruction that says something like "always use parameterized queries." Then ask Copilot to write a database query. Point out that it used parameterized queries without you asking.

> "You told it once. It remembers forever. Try getting a junior developer to do that."

**Step 4: Show a prompt file**

Open one of the `.prompt` files in the repo.

> "These are reusable recipes. Your security team writes them, checks them into the repo, and now every developer on the team can run the same security review that your lead engineer would do. The knowledge doesn't live in someone's head anymore — it lives in the repo."

**Step 5: Demo an agent**

Show one of the custom agents. Ask it a question, then ask raw Copilot Chat the same question. Compare the answers.

> "See the difference? The agent stayed focused on security. Raw chat wandered into general advice. Agents are how you keep Copilot on task."

**Step 6: Show the MCP server example**

Open the MCP (Model Context Protocol) server configuration.

> "MCP servers are how Copilot connects to external tools — databases, APIs, security scanners, anything with an interface. This is where it gets really interesting for security, because you can point Copilot at your vulnerability database or your compliance API and let it pull real data."

**What to say:** MCP is an open standard. It's not locked to GitHub. Any AI tool that supports MCP can use these same connections.

**Step 7: Show SAFE vs UNSAFE MCP examples**

This is the most important demo in this module. Show the PII redaction example (safe) and then show what happens without it (unsafe).

> "This is why governance matters. Without guardrails, an MCP server can send customer data — names, emails, credit card numbers — straight to the AI model. The safe version redacts PII before it ever leaves your system. Same functionality, completely different risk profile."

> "When your boss asks 'is this AI stuff safe?' — this is the answer. It's as safe as you build it to be. And we're going to show you how to build it safely."

### The Honest Comparison: Why Copilot Over Other AI Tools?

| Tool | Good At | Not Great At | Best For |
|------|---------|--------------|----------|
| ChatGPT / Claude | General knowledge, brainstorming, explaining concepts | Doesn't know your codebase, no repo integration, no governance controls | Research, learning new topics, one-off questions |
| Cursor / Other AI editors | Fast code generation, inline editing | Less enterprise control, less GitHub integration, limited audit trail | Individual productivity on personal projects |
| GitHub Copilot | Repo-aware, enterprise controls, Actions integration, MCP servers, audit logs | Still learning (like any AI), sometimes confidently wrong | Teams that use GitHub and need governance, auditability, and CI/CD integration |

> "I'm not saying Copilot is better at everything. I'm saying if your code lives on GitHub, Copilot is the only AI that can read your repo, follow your rules, connect to your tools, AND integrate with your CI/CD pipeline — all in one. If your code lives somewhere else, evaluate accordingly."

### Hands-On Exercise (10 min)

> "Open VS Code. You have 10 minutes. Try these 3 things:"

1. **Ask Copilot about your code.** Type `@workspace explain the authentication flow in this app` in Copilot Chat. Read what it says. Does it match the actual code?

2. **Change an instruction.** Open `.github/copilot-instructions.md`. Add a rule: "All error messages must not reveal internal system details." Now ask Copilot to write an error handler. Does it follow your new rule?

3. **Ask Copilot to find security problems.** Type `@workspace find security issues in src/app.js` — read the results. How many did it find? Do you agree with its findings? Did it miss anything you'd have caught?

> "Don't worry if you don't finish all three. The point is to feel how Copilot works before we start building pipelines with it."

### Transition

> "Now you know how Copilot works — prompts, instructions, skills, agents, MCP servers. But Copilot is one developer's assistant. It helps you when you're at your keyboard. What about 2 AM when nobody's at their keyboard? What about the intern who forgot to run the security check? What about the contractor who doesn't have Copilot? That's where GitHub Actions comes in. Actions run whether you're paying attention or not."

---

## 📘 Module 2: Why Actions? The Case for Automated Security (30 min)

**Repo:** `sautalwar/github-security-demo` (overview — we'll build hands-on in Module 3)

### The Problem

> "Quick question for the room: how does your team handle security scanning today? Be honest."

Pause. Let people answer. You'll hear:

- "We run Snyk before releases"
- "Our security team does a pen test once a year"
- "We have SonarQube but nobody looks at the results"
- "We... don't really"

> "All valid answers. No judgment. Here's the follow-up question: what happens between those scans? Last month, between your quarterly pen test and now, how many commits shipped? How many dependencies got updated? How many new API endpoints went live?"

> "I'll tell you what happened — code shipped with vulnerabilities nobody checked for. Not because your team is careless. Because manual processes have gaps. The gap between 'we know we should scan' and 'we actually scan every change' is where vulnerabilities live."

### The Four Approaches to Security Scanning

This is the most important comparison in the entire workshop. Spend time here. Let the table sink in.

| Approach | How It Works | Pros | Cons | When to Use |
|----------|-------------|------|------|-------------|
| **Manual scanning** | Someone remembers to run a tool | No setup needed, no config to maintain | Gaps between scans, depends on humans remembering, no audit trail, results live on someone's laptop | Never as your primary approach. Fine for one-off exploration. |
| **CLI extensions** (`gh` extensions) | Developer runs a command in their terminal | Powerful, flexible, great for investigation, immediate results, interactive | Not automatic — someone must run it, results stay local unless you pipe them somewhere, not auditable by the team | Ad-hoc investigation, one-off deep dives, interactive debugging, "let me look at this specific thing right now" |
| **GitHub Actions** | YAML workflow runs automatically on every push or pull request | Automatic, transparent (YAML in your repo), auditable (logs saved), composable (chain workflows), free for public repos | Initial setup time, YAML has a learning curve, debugging workflow failures can be frustrating | Continuous security scanning — this should be your default for everything that can be automated |
| **3rd-party SaaS** (Snyk, Veracode, Checkmarx, etc.) | Vendor-managed scanning platform, usually with a dashboard | Feature-rich, managed for you, compliance certifications (SOC 2, FedRAMP), dedicated support | Vendor lock-in, cost (often $50K+/year for enterprise), opaque scanning logic (black box), another login to manage, another dashboard to check | When you need specific compliance certifications your auditors require, or when you need a scanner for a language/framework that open-source tools don't cover well |

> "Here's the analogy I use: CLI extensions are like a fire extinguisher — great when you know there's a fire and you're standing right there. Actions are like a smoke detector — they work whether you're paying attention or not, whether you're home or not. For security, you want the smoke detector."

> "But — and this is important — CLI extensions aren't bad. They're different tools for different jobs. Later today, in the incident response module, you'll see how CLI extensions are perfect for investigating problems that Actions detected. The best setup uses both: Actions catch the problem automatically, CLI extensions help you investigate and fix it. They complement each other."

### Why Actions Over Everything Else?

Three reasons, in order of importance:

**1. Automation removes the human gap.**

Every manual process has a gap — the time between when someone should run the scan and when they actually do. For some teams that gap is hours. For others it's months. Actions close the gap to zero. Code pushes, scan runs. No gap.

**2. YAML is transparent and version-controlled.**

Your security pipeline is code. It lives in `.github/workflows/`. Anyone on the team can read it, review it, improve it. When your security team asks "what are we scanning for?" you show them a file, not a dashboard behind a login.

**3. You're not locked in.**

Today you scan containers with Trivy (an open-source scanner made by Aqua Security). Next year, if a better scanner comes out, you change one line in your YAML. Try doing that with a SaaS vendor who has your credit card.

### The GitLab Comparison (Handle With Care)

> "Some of you have used GitLab. Plenty of you are evaluating both platforms. Let's be honest about the differences."

| Feature | GitLab | GitHub Actions | The Real Difference |
|---------|--------|---------------|---------------------|
| Setup | Toggle a switch in project settings | Write a YAML file (or copy ours today) | GitLab is faster to start. Actions gives you full control from day one. Fair trade-off. |
| Customization | Limited — their scanner, their rules, their schedule | Unlimited — pick any tool, write any rule, trigger on any event | When your security team says "we need a custom check for X," GitLab says "submit a feature request." Actions says "add 5 lines of YAML." |
| Scanner choice | GitLab's built-in scanners only | Any tool: Trivy, Checkov, ZAP, Snyk, Semgrep, custom scripts, anything that runs in a container | You're not locked into one vendor's scanner. If a better tool comes out next year, swap it in 5 minutes. |
| Transparency | Proprietary scanners — you can't read the source | Everything is in your YAML, readable by anyone on the team | Your security team can audit exactly what runs, how it's configured, and what it checks for. No black boxes. |
| Ecosystem | GitLab-only integrations | 17,000+ Actions on the Marketplace, plus anything you can run in a container | For any security need, someone has probably already built an Action for it. |
| Cost | Security scanning requires Ultimate tier (starts around $99/user/month) | Free for public repos, included minutes with all paid plans | GitLab charges extra for security features. GitHub includes Actions minutes with your plan. |
| AI integration | GitLab Duo (newer, less mature) | Copilot with full repo context, instructions, agents, MCP servers | Copilot has a multi-year head start and deeper integration with the development workflow. |

> "I'm not here to bash GitLab. They built a good product. Their approach is 'trust us, we'll handle security for you.' Our approach is 'here are the tools — you're in control.' For experienced teams like yours, I think control matters more. But I also know that 'toggle a switch' is appealing when you're starting from nothing. That's why we're going to build the whole pipeline today — so you can see that the setup isn't as hard as it sounds."

### What to Show

**Step 1: Open the repo on GitHub**

Go to `github.com/sautalwar/github-security-demo` in a browser.

> "This is the repo we'll be working with for the rest of the day. It has a real application with real code and 9 security workflows already configured."

**Step 2: Show the workflows directory**

Navigate to `.github/workflows/`.

> "Nine YAML files. Each one does a specific security job. Container scanning, dependency checking, secret detection, infrastructure-as-code validation, and more. We'll build five of these from scratch in the next module."

List the files and briefly say what each one does. Don't go deep — Module 3 is for that.

**Step 3: Show the Actions tab**

Click on the Actions tab. Show the green checkmarks.

> "See? All green. Running on every push. Nobody had to remember to run these. Nobody had to install a tool. Nobody had to read a PDF report. The results show up right here, in the same place you already look at your code."

**Step 4: Open one YAML file**

Open `container-scan.yml` (or whichever is simplest).

> "Look at this — about 80 lines of readable YAML. Your whole team can understand this. Your security team can audit it. Your manager can read it. Try reading GitLab's internal scanner code — you can't, because it's proprietary."

Walk through the YAML structure briefly: name, trigger, job, steps. Don't explain every line — just enough so they see it's approachable.

**Step 5: Show the Security tab**

Click the Security tab. Show where SARIF results (a standard format for scanner output) appear.

> "SARIF is a standard format — Static Analysis Results Interchange Format. Any scanner that outputs SARIF can feed results into this tab. This means you get the same unified view whether you're using Trivy, Checkov, Semgrep, or a custom scanner. One place to look, regardless of which tool found the problem."

### Key Takeaway

> "Here's what I want you to remember from this module: the question isn't 'should we automate security scanning?' The answer to that is obviously yes. The question is 'how much control do we want over what runs and how?' If your answer is 'a lot of control,' GitHub Actions is the right choice. If your answer is 'as little work as possible,' GitLab's toggle-a-switch approach might appeal to you — but you'll hit its limits fast."

### Transition

> "You've seen the overview. Now let's build these pipelines together. We'll start with container scanning — because if your Docker image ships with a known vulnerability in the base image, nothing else matters. Your beautiful, well-tested application code is running on a foundation with a hole in it. Let's fix that first."

---

*Part 1 covers the opening, Module 1 (Copilot fundamentals), and Module 2 (the case for Actions). Part 2 continues with Module 3 (building the pipeline hands-on) through Module 8 (next steps).*


# Security Workshop — Part 2: Hands-On Pipeline, Incident Response, and API Security

---

## 📘 Module 3: Building Your Security Pipeline — Hands-On (60 min)
**Repo: sautalwar/github-security-demo**

> "You've seen the big picture. Now we build. This module is hands-on — you'll walk through real workflow files, real scan results, and real vulnerabilities. By the end, you'll know exactly how to set this up in your own repos."

We cover 5 of the 9 workflows in detail. The other 4 get a quick overview so you know they exist.

---

### Workflow 1: Container Scanning with Trivy (12 min)

**What it does in plain words:**

> "When you build a Docker image, it contains your code plus an operating system plus dozens of libraries. Any of those could have a known security hole. Trivy checks all of them in about 30 seconds."

**What to show:**

1. Open `.github/workflows/container-scan.yml`
2. Walk through the YAML: "Build the image → scan for CVEs → scan for misconfigs → scan for secrets → upload results"
3. Go to the Actions tab → open a completed container-scan run
4. Show the Trivy output — real CVE findings with severity levels
5. Go to the Security tab → show SARIF results integrated natively

**What to say while walking through the YAML:**

> "Notice this is one tool doing three scans. First it checks for CVEs — known vulnerabilities in the OS packages and libraries baked into the image. Then it checks the Dockerfile itself for misconfigurations — running as root, using `latest` tag instead of a pinned version. Finally it looks for secrets — someone hardcoded an API key in the image layers. One tool, one pass, three categories of problems caught."

**Why Trivy (not other scanners)?**

| Scanner | Pros | Cons | Our Pick? |
|---------|------|------|-----------|
| Trivy | Free, fast, covers CVEs + misconfigs + secrets in one pass, huge vulnerability database | Less deep than commercial tools for niche cases | ✅ Yes — best all-around |
| Snyk Container | Good UI, developer-friendly | Costs money, vendor lock-in | Good but paid |
| Grype (Anchore) | Fast, good accuracy | Smaller community than Trivy | Good alternative |
| Docker Scout | Built into Docker Desktop | Limited scanning depth | Quick checks only |

> "We chose Trivy because it does three jobs in one pass: vulnerabilities, misconfigurations, and leaked secrets. Most other tools only do one."

**Hands-on exercise:**

> "Look at the Dockerfile. Can you spot what Trivy will flag before you look at the results?"

Give the audience 2 minutes. Common things they should find:

- Running as root (no `USER` directive)
- Using a base image with known CVEs
- Exposed ports that don't need to be exposed
- Packages installed without version pins

Then show the Trivy results and compare. Most people catch 2 out of 4.

---

### Workflow 2: IaC Scanning with Checkov (12 min)

**What it does:**

> "Before you deploy cloud infrastructure, this checks your Terraform code for security mistakes — open S3 buckets, databases exposed to the internet, security groups that allow traffic from everywhere."

**What to show:**

1. Open `terraform/main.tf` — "I've put 8 intentional security problems in here. Let's see how many you can spot."
2. Give the audience 2 minutes to find problems
3. Open `.github/workflows/iac-scan.yml` — walk through the YAML
4. Show a completed run with Checkov findings
5. Show the PR comment with the summary table (passed/failed/skipped)
6. Show SARIF results in the Security tab

**What to say while the audience reviews main.tf:**

> "This is real Terraform that creates real AWS resources. I've hidden 8 security problems — some obvious, some subtle. See how many you can find in 2 minutes. Hint: think about who can access what, and what's encrypted."

**Common problems the audience should find:**

- S3 bucket without encryption
- Security group allowing 0.0.0.0/0 on port 22
- RDS instance with `publicly_accessible = true`
- Missing access logging
- Default VPC usage

**Why Checkov AND tfsec (dual scanner)?**

| Scanner | Checks | Strength |
|---------|--------|----------|
| Checkov | 1000+ built-in policies, maps to CIS/SOC2/HIPAA/PCI | Breadth — covers the most standards |
| tfsec | Terraform-specific deep analysis | Depth — catches Terraform-specific issues Checkov misses |

> "We run both. It takes 30 extra seconds and catches 15-20% more issues. When it comes to infrastructure security, redundancy is cheap insurance."

**Why Actions instead of `terraform plan` with manual review?**

> "You could review Terraform changes manually. But I've seen experienced engineers miss a `publicly_accessible = true` buried in a 200-line PR. Checkov never misses it. It doesn't get tired. It doesn't skip lines because a meeting starts in 5 minutes."

---

### Workflow 3: License Compliance (10 min)

**What it does:**

> "Every npm package, every pip dependency has a license. Some licenses (like GPL) require you to open-source your own code if you use them. If your legal team finds out you shipped GPL code in a commercial product, that's a very expensive meeting."

**What to show:**

1. Open `.github/license-policy.json` — "This is your company's license rules. Allowed, denied, needs-review."
2. Walk through the categories — explain GPL vs MIT vs Apache in plain words
3. Open the workflow YAML
4. Show a completed run with the license distribution table

**What to say about licenses (keep it simple):**

> "MIT and Apache — do whatever you want, just keep the copyright notice. BSD — same idea. These are permissive. GPL — if you use GPL code, your entire project must also be GPL. That means open source. For a commercial product, that's usually a non-starter. LGPL — a middle ground. You can use the library, but if you change the library itself, those changes must be open source. The gray area is where your legal team earns their salary."

**Why a custom workflow instead of a paid license scanning tool?**

| Approach | Cost | Customization | Maintenance |
|----------|------|--------------|-------------|
| Custom Actions workflow | Free | Total — your legal team defines the rules | You maintain the YAML |
| FOSSA / WhiteSource | $10K+/year | Good but within their framework | Vendor maintains |
| `npm audit` only | Free | None — only checks vulnerabilities, not licenses | Built into npm |

> "For most teams, the custom workflow is enough. If you have 500+ repos and a dedicated compliance team, look at FOSSA. But start here."

**Hands-on exercise:**

> "Open the license policy file. Find a package in the repo's dependencies that uses a license not in the allowed list. What would you do — add it to the allowed list, find an alternative package, or escalate to legal?"

---

### Workflow 4: Compliance as Code with OPA (12 min)

**What it does:**

> "Instead of an auditor checking a spreadsheet once a year, this checks every single commit against your compliance rules. SOC2, HIPAA, CIS benchmarks — all encoded as code that runs automatically."

**What to show:**

1. Open `policies/opa/soc2.rego` — "This is a SOC2 policy written in Rego, a language designed for policy checks"
2. Explain 3-4 of the checks in plain English
3. Open the compliance workflow
4. Show the compliance report output (JSON with passed/failed checks)

**What to say about each check:**

> "This first rule checks that branch protection requires at least 2 reviewers. Why 2? Because SOC2 requires separation of duties — the person who wrote the code shouldn't be the only one who approves it. This next rule checks that encryption is enabled at rest. This one checks that logging is turned on. Each rule maps to a specific SOC2 control number, so when the auditor asks, you point them right here."

**Why OPA/Rego (not a custom bash script)?**

| Approach | Pros | Cons |
|----------|------|------|
| Custom bash scripts | Simple, anyone can write them | Hard to maintain, no standard format, auditors won't trust them |
| OPA/Rego | Industry standard (Kubernetes, Terraform Cloud, Istio all use it), auditors recognize it, testable | Learning curve for Rego syntax |
| Commercial compliance tools | Polished reports, pre-built frameworks | Expensive, less flexible, vendor lock-in |

> "OPA is what the big companies use. When your auditor asks 'how do you enforce access controls?' you can show them the Rego policy file. It's code they can read, version-controlled, and runs on every commit."

**Hands-on exercise:**

> "Open the SOC2 policy. Add a check that verifies log retention is at least 365 days (not the current 90). Push it and watch the compliance check update."

Walk them through the Rego syntax:

```rego
log_retention_adequate {
    input.log_retention_days >= 365
}
```

> "That's it. Four lines. You just updated a compliance policy that will now run on every commit, forever, without anyone needing to remember to check it."

---

### Workflow 5: SBOM Generation (8 min)

**What it does:**

> "An SBOM is a list of every single piece of software in your application — every library, every package, every version. Think of it like an ingredients list on food packaging. Governments are starting to require this. Executive Order 14028 in the US says if you sell software to the federal government, you need an SBOM."

**What to show:**

1. Open the SBOM workflow
2. Show it generates two formats: CycloneDX and SPDX — "Two formats because different customers and regulators prefer different ones"
3. Show the Grype vulnerability scan against the SBOM — "Once you have the ingredients list, you can check if any ingredient has been recalled"
4. Show how SBOMs attach to releases

**What to say:**

> "CycloneDX is the OWASP standard — it's more security-focused. SPDX is the Linux Foundation standard — it's more license-focused. We generate both because it costs us nothing extra, and it means we're ready no matter who asks. The SBOM itself is a JSON file. It lists every dependency, its version, where it came from, and what license it uses. Boring? Yes. Required? Increasingly, yes."

---

### Brief Mention of Remaining Workflows (6 min)

These four workflows are in the repo but we won't deep-dive today:

**DAST (Dynamic Application Security Testing) with OWASP ZAP:**
> "Trivy and Checkov look at your code sitting still. ZAP actually runs your application and attacks it — like a hacker would. It tries SQL injection, cross-site scripting, header manipulation. It finds problems that only show up at runtime."

**API Security with Schemathesis:**
> "This takes your OpenAPI spec and generates thousands of random and malicious requests. 'What happens if I send a string where you expect a number? What if I send a 10MB payload? What if I send special characters in every field?' It finds the edge cases your tests missed."

**Security Policy Gate:**
> "This is the gatekeeper. It looks at all the other scan results and makes a decision: can this PR merge or not? You set the rules — maybe you allow medium-severity findings but block critical ones. It's the last check before code reaches your main branch."

**Security Dashboard:**
> "Everything we've talked about generates data. This workflow collects it all and publishes a dashboard to GitHub Pages. One view showing: how many vulnerabilities, what severity, trend over time, which repos are clean, which need attention."

> "We won't deep-dive all 9 today, but they're all in the repo. Fork it, and you have a complete security pipeline in 5 minutes."

---

### Module 3 Transition

> "Your pipeline catches problems before they merge. But what about problems that already exist? What about a developer who committed a customer's social security number last week and nobody noticed? That's what we cover next."

---

## 📘 Module 4: When Things Go Wrong — Secure Vault (45 min)
**Repo: sautalwar/ghcopilot-pii-demo**

### The Setup

> "You've built your prevention layer. But prevention isn't enough. Things slip through. New developers make mistakes. Legacy code has problems nobody knew about. You need detection AND automated response."

### Why Automated Remediation Matters (Not Just Detection)

> "Most security tools tell you there's a problem. Great. Now what? Someone creates a ticket. It goes in the backlog. Three sprints later, someone fixes it. Meanwhile, that exposed API key has been in production for 4 months. We're going to show you tools that detect AND fix — automatically."

| Response Type | Time to Fix | Risk Window | Example |
|--------------|------------|-------------|---------|
| Manual (ticket → backlog → fix) | Days to months | Huge | "We'll get to it next sprint" |
| Alert + manual fix | Hours to days | Medium | "Pager went off, I'll fix it today" |
| Auto-detect + auto-remediate PR | Minutes | Minimal | "PR created automatically, just review and merge" |

> "That third row is what we're building toward. Not fully hands-off — you still review the PR. But the detection, the fix, the PR creation — all automatic. Your job becomes reviewer, not investigator."

---

### Demo: The 6 Secure Vault Scenarios

Walk through each scenario. For each one: what happens, what to show, what to say.

---

**Scenario 1: Secret Leak (8 min)**

> "Watch this. I'm going to commit an AWS access key to the repo. In a real company, this happens more often than anyone admits."

**What to show:**

1. The simulated secret commit
2. GHAS Secret Scanning detecting it immediately
3. The auto-remediation PR that rotates the key
4. The audit log entry

**What to say:**

> "The key was exposed for less than 2 minutes. Without automation, it could be exposed for weeks. And here's the thing nobody talks about: git history. Even if you delete the file, the secret is still in the commit history. Anyone who clones the repo has it. That's why rotation matters — you don't just remove the secret, you make the old one useless."

**What makes this work:**

- GHAS Secret Scanning runs on push, not on a schedule
- The webhook triggers an automated workflow
- The workflow creates a PR with the rotated credential
- The audit log records the full timeline

---

**Scenario 2: PII Exposure (8 min)**

> "This one is personal — literally. Customer data ends up in source code. Social security numbers in test files. Email addresses in log statements. GHAS catches secrets like API keys, but PII patterns are different — they're specific to your industry."

**What to show:**

1. Code with PII patterns (SSN, email)
2. The custom PII scanner workflow detecting it
3. The auto-redaction PR replacing PII with masked values
4. Explain why this is a CUSTOM scanner, not built-in

**What to say:**

> "See this test file? Someone used real customer data as test data. It happens all the time. The SSN `123-45-6789` is in a unit test. The scanner catches the pattern, creates a PR that replaces it with `XXX-XX-XXXX`, and flags the commit for review. No human had to find this. No one had to remember to check."

**Why a custom PII scanner (not just GHAS)?**

> "GHAS Secret Scanning knows what an AWS key looks like. But does it know what your company's internal employee ID format looks like? Or a medical record number? That's company-specific. This custom scanner lets you define YOUR patterns."

| What It Catches | Tool | Built-in? |
|----------------|------|-----------|
| API keys, tokens, passwords | GHAS Secret Scanning | Yes |
| SSNs, emails, phone numbers | Custom PII Scanner | No — you build it |
| Industry-specific (medical records, financial accounts) | Custom PII Scanner | No — you define the patterns |

---

**Scenario 3: SQL Injection (6 min)**

> "This is the classic web vulnerability. Someone builds a database query by gluing strings together instead of using parameterized queries. An attacker types something clever in a form field, and suddenly they're running their own SQL commands on your database."

**What to show:**

1. CodeQL catching the vulnerable code path
2. The specific finding: user input flows directly into a SQL query
3. Copilot generating the fix — a parameterized query
4. The before/after comparison

**What to say:**

> "CodeQL doesn't just search for patterns — it traces data flow. It sees that user input from a form field reaches a SQL query without being sanitized. That's the vulnerability. The fix is simple: use a parameterized query. The database treats the input as data, never as code. Copilot generates this fix automatically because it's a well-known pattern."

---

**Scenario 4: Vulnerable Dependencies (6 min)**

> "You wrote zero lines of vulnerable code. But a library you depend on has a critical CVE published yesterday. You're vulnerable through no fault of your own."

**What to show:**

1. Dependabot detecting the outdated package
2. The security advisory with severity and description
3. The auto-update PR with the version bump
4. The CI checks running on the Dependabot PR

**What to say:**

> "Dependabot checks your dependency manifest against the GitHub Advisory Database. When a new CVE is published, it creates a PR within hours — sometimes minutes. The PR updates the version, your CI runs, and if tests pass, you merge. The entire process from 'vulnerability disclosed' to 'patched in your repo' can be under an hour."

---

**Scenario 5: Content Exclusion (5 min)**

> ".copilotignore — this is a file that tells Copilot 'never look at this, never suggest code based on this, pretend it doesn't exist.' For sensitive data, proprietary algorithms, or compliance-restricted files."

**What to show:**

1. The `.copilotignore` file and its syntax (same as `.gitignore`)
2. A file that's excluded — try to get Copilot to reference it
3. Show that Copilot genuinely doesn't see the excluded content

**What to say:**

> "This matters for regulated industries. If you have HIPAA-protected data files, or proprietary trading algorithms, or classified information — you need to guarantee that AI tools never train on it, never suggest it, never surface it in completions. `.copilotignore` is that guarantee."

---

**Scenario 6: Audit Trail (5 min)**

> "Everything we just showed you is logged. Every detection, every remediation, every action. When your compliance team asks 'what happened and when?', you hand them the audit report."

**What to show:**

1. The aggregated audit log
2. Timeline view: detection → remediation → resolution
3. How it maps to compliance requirements (SOC2 incident tracking)

**What to say:**

> "This isn't just about security — it's about proof. When an auditor asks 'do you have an incident response process?', you don't show them a wiki page describing what you would do. You show them this: actual incidents, actual responses, actual timelines. All automated, all version-controlled, all searchable."

---

### Why Actions for Detection, CLI for Investigation

> "I said earlier that Actions and CLI extensions are different tools for different jobs. Here's where that comes together: Actions detected the secret leak automatically. But what if you need to investigate — how far did it spread? Who else might have copied it? That's where a CLI extension shines. You run `gh security-audit --secret=AKIAIOSFODNN7EXAMPLE` and it traces everywhere that key was used."

| Task | Best Tool | Why |
|------|-----------|-----|
| Continuous monitoring | GitHub Actions | Runs on every push/PR without human action |
| One-time investigation | CLI extension | Interactive, you can drill down in real time |
| Broad pattern scanning | Actions workflow | Checks every file, every commit, every branch |
| Targeted deep dive | CLI + terminal | You decide what to look at, when, how deep |

> "Think of it like this: Actions is your security camera. Always watching, always recording. The CLI extension is your detective. Called in when something specific needs investigation."

---

### Hands-On Exercise (7 min)

> "Add a fake SSN pattern (like 123-45-6789) to a test file in the PII demo repo. Push it. Watch the scanner catch it and create a remediation PR."

**Steps:**

1. Fork `sautalwar/ghcopilot-pii-demo` (if not already done)
2. Create a new file: `tests/fake_data.txt`
3. Add content with a fake SSN: `Test user SSN: 123-45-6789`
4. Commit and push
5. Watch the Actions tab — the PII scanner should trigger
6. Check for the auto-remediation PR

> "If the scanner doesn't fire within 2 minutes, check that the workflow is enabled in your fork. Forked repos disable Actions by default — you need to go to the Actions tab and click 'I understand my workflows, go ahead and enable them.'"

---

### Module 4 Transition

> "We've covered your application code and your infrastructure code. But there's one more attack surface most teams forget about: your APIs. Every public endpoint is a door — and attackers are very good at opening doors."

---

## 📘 Module 5: Securing APIs at Scale (30 min)
**Repo: sautalwar/how_APIM_works**

### Why APIs Need Special Attention

> "Your app might be locked down tight. But if your API lets someone skip authentication, or returns more data than it should, none of that matters. The OWASP API Top 10 is a list of the most common API attacks. Let me show you the top 3 and how to stop them."

**The reality:**

> "APIs are the fastest-growing attack surface. Ten years ago, attackers targeted your web forms. Five years ago, they targeted your JavaScript. Today, they skip the UI entirely and go straight to your API. They read your documentation (or reverse-engineer it), and they call your endpoints directly. Your beautiful front-end validation means nothing if the API doesn't validate too."

---

### Show 3-4 OWASP API Top 10 Scenarios

**API1: Broken Authentication (10 min)**

> "Someone calls your API without a valid token and gets data back. This is the most common API vulnerability."

**What to show:**

1. An API endpoint that should require authentication
2. The APIM JWT validation policy that blocks unauthenticated requests
3. The policy-as-code (XML) in the repo
4. What happens when a request comes in without a valid token

**What to say:**

> "This XML policy says: every request must have a Bearer token in the Authorization header. The token must be a valid JWT, signed by our identity provider, not expired, and issued for this specific API. If any of those checks fail, the request gets a 401 before it ever reaches your backend code. Your API code doesn't need to check — the gateway already did."

**Why this matters at scale:**

> "If you have 3 APIs, you can put auth checks in each one. If you have 50, you'll miss one. The gateway enforces it for all of them, in one place."

---

**API4: Unrestricted Resource Consumption (8 min)**

> "Someone writes a script that calls your API 10,000 times per second. Your servers crash. Your real users can't log in."

**What to show:**

1. APIM rate limiting and quota policies
2. How the agentic workflow reviews rate limit changes
3. The difference between rate limiting (short-term) and quotas (long-term)

**What to say:**

> "Rate limiting says: no more than 100 requests per minute from a single client. Quotas say: no more than 10,000 requests per month on the free tier. You need both. Rate limiting stops bursts. Quotas stop sustained abuse. Without either, one bad actor — or one buggy client — can take down your entire API."

| Control | What It Stops | Example Setting |
|---------|--------------|-----------------|
| Rate limit | Burst attacks, runaway scripts | 100 requests/minute per client |
| Quota | Sustained abuse, cost control | 10,000 requests/month on free tier |
| Both together | Everything above | Rate limit + quota per API key |

---

**API8: Security Misconfiguration (7 min)**

> "Your API returns stack traces in error messages. It allows HTTP (not just HTTPS). It doesn't set security headers. These aren't bugs in your logic — they're configuration mistakes that give attackers information they shouldn't have."

**What to show:**

1. The Python policy scanner checking 18 security rules
2. Specific misconfigurations it catches: CORS too permissive, missing HTTPS redirect, verbose error responses
3. The GitHub Actions pipeline blocking insecure config changes

**What to say:**

> "A stack trace in a production error response tells an attacker your framework, your version, your file paths, sometimes even your database structure. That's free reconnaissance. The fix is simple: return a generic error message in production. But 'simple' and 'remembered' are different things. That's why we check it automatically."

---

### Why an API Gateway (Not Just App-Level Security)

| Approach | Works When You Have... | Falls Apart When You Have... |
|----------|----------------------|---------------------------|
| App-level security only (checks in your code) | 1-3 services | 50 microservices — you'd need to update all 50 |
| API Gateway (APIM) | Any number of services — one place to enforce rules | Nothing — this is the right approach at scale |
| Both (defense in depth) | The budget and team to maintain both | Neither — but it's the most secure option |

> "App-level checks are like locking each room in your house individually. A gateway is like having a security guard at the front door. You want both, but if you can only pick one, start with the front door."

---

### The Agentic Workflow

> "Here's something unique: when someone changes an API security policy, a GitHub Actions workflow uses AI to review the change. Not just 'does the YAML parse' — it actually understands whether the policy change weakens security."

**What to show:**

1. A PR that changes a rate limit from 100/min to 10,000/min
2. The AI review comment explaining the risk: "This increases the rate limit by 100x. This could expose the backend to resource exhaustion attacks."
3. The comparison: what a traditional linter would catch (syntax errors) vs. what the AI review catches (security implications)

**What to say:**

> "A linter would say 'valid XML.' The AI reviewer says 'you just removed rate limiting for your payment endpoint — are you sure?' That's the difference between syntax checking and understanding intent. This doesn't replace human review. It makes human review faster by highlighting what actually matters."

---

### Module 5 Transition

> "We've covered prevention, detection, response, and API security. But what does all of this look like in a real workday? Let's find out."


# Security Workshop Guide — Part 3

> Modules 6–8, Appendices, and Facilitator Notes

---

## 📘 Module 6: A Day in the Life — Live Security Operations (45 min)

**Repo: sautalwar/it-security-copilot-demo**

### The Narrative

> "It's 8 AM on a Monday. You open your laptop. Your monitoring dashboard has a red alert — unusual DNS traffic patterns from one of your servers. Let's walk through the entire day and see how Copilot helps you handle each problem."

This is the most hands-on module of the day. We stop talking about what could go wrong and start showing what does go wrong — and how to fix it.

This module uses a Python-based interactive CLI that runs 12 security scenarios. Each scenario follows a 5-step cycle:

**SIMULATE → DETECT → REMEDIATE → VERIFY → TEARDOWN**

### Why the 5-Step Cycle

> "In incident response, most teams do steps 1-3: find it, panic, fix it. But they skip verify and cleanup. That's how you create new problems while fixing old ones."

Each step has a specific purpose:

1. **SIMULATE** — We plant the problem so you can see what it looks like. In real life, an attacker does this. You need to recognize it.
2. **DETECT** — Copilot + monitoring find the problem. In real life, your alerting system does this. The question is whether you've tuned your alerts to catch it.
3. **REMEDIATE** — Copilot generates the fix. In real life, you'd write this yourself — but with AI help, you move from detection to fix in minutes instead of hours.
4. **VERIFY** — CI/CD validates the fix actually works and doesn't break anything else. This is the step most teams skip.
5. **TEARDOWN** — Reset to baseline. No leftover test artifacts, no dangling changes. Clean state for the next scenario.

> "This discipline is the difference between 'we fixed it, I think' and 'we fixed it, here's the proof.' Your auditors care about proof."

### Select 4 Scenarios to Demo Live

#### Scenario 1: DNS Exfiltration (8 AM) — 10 min

> "Someone — or something — is sending encoded data out through DNS queries. This is one of the sneakiest ways to steal data because most firewalls allow DNS traffic."

DNS exfiltration works by encoding stolen data (passwords, database records, API keys) into DNS query strings. Because DNS is almost never blocked at the firewall, the data walks right out the door. A typical exfiltration query looks like `aGVsbG8gd29ybGQ=.evil-domain.com` — that Base64 chunk before the dot is your data leaving the building.

**What to show:**

1. Run the simulator — watch DNS anomalies appear in the logs. Point out the query length and encoding patterns.
2. Copilot detects the pattern — "Base64-encoded strings in DNS queries? That's not normal." Show how it flags the entropy level.
3. Copilot generates a network rule to block outbound DNS to non-approved resolvers. Walk through the rule line by line.
4. Verify the fix — run the check again, confirm the exfiltration fails and legitimate DNS still works.
5. Teardown — remove the simulated traffic, reset DNS rules to baseline.

> "Most organizations allow all outbound DNS. That's like locking your front door but leaving the windows open. Restrict DNS to your approved resolvers and you shut down this entire attack category."

#### Scenario 2: Container Escape Risk (10 AM) — 10 min

> "Your container is running as root. That means if someone exploits a vulnerability in your app, they don't just own the container — they own the host machine."

Running containers as root is the single most common container security mistake. It turns a contained problem into an infrastructure-wide compromise. And it's everywhere — most Docker tutorials on the internet default to root because it's easier. Easier for attackers too.

**What to show:**

1. Simulate a container running as root with excessive capabilities (`--privileged`, host network access, `SYS_ADMIN`)
2. Copilot identifies the risk — privileged containers, host network access, missing seccomp profiles, writable root filesystem
3. Remediate — Copilot generates a secure Dockerfile (non-root user, dropped capabilities, read-only filesystem) and a pod security policy that enforces these constraints cluster-wide
4. Verify — re-scan the container, confirm the risks are resolved. Show the before/after comparison.
5. Teardown — remove the test container, policy, and any temporary images

> "The fix is usually three lines in your Dockerfile: add a user, switch to it, drop capabilities. Three lines between 'contained problem' and 'total compromise.'"

#### Scenario 3: CI/CD Pipeline Poisoning (1 PM) — 10 min

> "This is the one that should keep you up at night. An attacker modifies your GitHub Actions workflow to exfiltrate secrets during the build. Your tests pass. Your code is fine. But your pipeline is compromised."

Pipeline poisoning is particularly dangerous because it operates in a trusted context. The build environment has access to secrets, tokens, and deployment credentials. A single malicious step can send all of them to an attacker. And because it happens during CI/CD — not at runtime — your application monitoring won't catch it.

**What to show:**

1. Simulate — a modified workflow file that sends `${{ secrets.DEPLOY_TOKEN }}` to an external URL during a build step. Show how easy this is to hide in a large workflow file.
2. Detect — Copilot spots the suspicious step (outbound HTTP call to a non-approved domain). Walk through the detection logic.
3. Remediate — Copilot generates workflow hardening: pinned action versions (SHA, not tags), least-privilege permissions block, no third-party actions without audit, and network egress restrictions.
4. Verify — the hardened workflow blocks the exfiltration attempt and fails the build with a clear error message.

> "This is why 'just use Actions' isn't enough. You also need to secure your Actions themselves. Pinned versions, minimal permissions, no third-party actions you haven't audited."

#### Scenario 4: Incident Response Automation (4 PM) — 10 min

> "The day's almost over. Let's tie everything together — an automated incident response runbook that detects, responds, documents, and notifies."

This scenario shows the full loop: detection triggers automation, automation fixes the problem, the fix generates documentation, and the documentation goes to the right people. No human had to write a status update or fill out a ticket — the system did it.

**What to show:**

1. The full IR automation workflow — how a single alert triggers a chain of responses
2. How it creates a timeline of events — every action timestamped and logged, in a format auditors can read
3. How it generates a post-incident report — formatted for both engineers and management, with root cause analysis
4. How it notifies the right people — Slack, email, or GitHub Issues depending on severity level

> "The goal isn't to remove humans from incident response. It's to remove the boring parts — the status updates, the ticket creation, the timeline reconstruction. Let humans focus on the hard decisions."

### Why Developers Need to Know This (Not Just Security Teams)

> "Ten years ago, incident response was 100% the security team's job. But modern attacks target developers — your dependencies, your CI/CD pipelines, your containers. If you don't understand these attacks, you can't prevent them. And you definitely can't spot them in code review."

The shift is real: supply chain attacks (SolarWinds, Log4Shell, XZ Utils) all targeted the development pipeline. Developers are now on the front line whether they signed up for it or not. The good news: developers who understand these attacks write more defensible code, review PRs with sharper eyes, and catch things that automated scanners miss.

### Hands-On (5 min)

Pick any unfinished scenario from the 12 available. Run it yourself using the CLI:

```bash
python demo_runner.py
```

Follow the **SIMULATE → DETECT → REMEDIATE → VERIFY → TEARDOWN** cycle. If you finish early, try a second scenario — they're designed to be independent. Compare notes with the person next to you: did Copilot suggest different remediations for the same problem?

### Transition

> "Everything we've covered today applies to new code. But what about the code you already have? The 15-year-old Java app that's still running in production? How do you upgrade it without breaking security? That's our final module."

---

## 📘 Module 7: Modernizing Legacy Code Without Breaking Security (30 min)

**Repo: sautalwar/FlightPlans**

### The Problem

> "Raise your hand if you have an application in production that's more than 5 years old. Keep it up if it's more than 10 years old. Those applications are running on frameworks with known vulnerabilities, using libraries that are no longer maintained, and probably haven't been scanned in years. You know you need to upgrade. But how do you do it without breaking everything?"

Legacy modernization fails for two reasons: either teams try to upgrade everything at once and break the app, or they upgrade piece by piece with no plan and end up in a half-migrated state for years. Both approaches also tend to ignore security — you're so focused on "does it still work?" that you forget to ask "is it still safe?"

### What a Flight Plan Is (in plain words)

> "A Flight Plan is a recipe for modernization. Not just 'upgrade Java 8 to Java 21' — it's a step-by-step process with built-in quality checks, human review points, and an audit trail. Think of it like a pilot's pre-flight checklist: you don't skip steps, you don't improvise, and at the end, everyone can verify the work was done correctly."

A Flight Plan is a YAML file that describes the work, the order, the gates, and the acceptance criteria. It's version-controlled, reviewable, and repeatable. If a new team member joins halfway through, they can read the Flight Plan and know exactly what's been done and what's left.

> "The Flight Plan is the single source of truth for the modernization. Not a Jira board, not a Confluence page, not someone's memory. A file in the repo, next to the code it describes."

### The 7-Step Process

Walk through a real example — Java 8 → Java 21 upgrade:

| Step | What Happens | Why It Matters |
|------|-------------|---------------|
| 1. Assess | Copilot analyzes the codebase — what Java 8 APIs are used? Which are deprecated? | You can't fix what you don't understand |
| 2. Establish Vision | Define the target: Java 21, Spring Boot 3, all tests passing | Everyone agrees on the destination |
| 3. Create Roadmap | Break the work into ordered tasks with dependencies | No one gets paralyzed by the size of the project |
| 4. Track Progress | Automated progress dashboard | Management visibility without status meetings |
| 5. Queue Work | Pick the next task based on dependencies and priority | Systematic, not random |
| 6. Spec the Work | Detailed spec for each task before coding starts | Review the plan before the code |
| 7. Implement + Feedback | Copilot implements, tests validate, human reviews | AI does the tedious work, humans do the judgment |

### Why Agentic Workflows (Not Just Copilot Chat)

| Approach | Speed | Quality | Governance | Audit Trail |
|----------|-------|---------|-----------|-------------|
| **Manual modernization** | Slow (months) | Depends on the team | Whatever process you define | Whatever docs you write |
| **Copilot Chat (ad hoc)** | Fast | Variable — no consistency | None | Chat history only |
| **FlightPlans (agentic)** | Fast | Consistent — same process every time | Built-in gates and checkpoints | Complete — every decision documented |

> "You could open Copilot and say 'upgrade this to Java 21.' It'll try. And for a 200-line app, it'll probably work. But for a 200,000-line enterprise app? You need governance. You need gates. You need to prove to your VP that the upgrade was done systematically, not by an intern asking an AI chatbot to yolo it."

### Connecting to Security

> "Here's the part that ties everything together: every Flight Plan includes security checks. When you upgrade from Java 8 to 21, the Flight Plan automatically:
> - Runs security scans on the new code (the same Trivy, Checkov, etc. from Module 3)
> - Checks for deprecated APIs with known CVEs
> - Validates that new dependencies meet your license policy
> - Runs the compliance checks from your OPA policies
>
> The modernization isn't done until security says it's done."

This is why FlightPlans matter for security teams, not just development teams. Every modernization is also a security upgrade — old frameworks have old vulnerabilities. But only if you verify the upgrade didn't introduce new ones.

### What to Show

1. Open the FlightPlans repo — show the 20+ available scenarios (Java, .NET, Python, Node.js, and more)
2. Walk through one scenario folder (Java 8 → 21) — show the directory structure and explain each file's role
3. Show the `flightplan.yaml` — "This is the governance contract. Every step, gate, and approval is defined here."
4. Show the skills library — "These are the reusable tools Copilot uses. Think of them as functions the AI can call."
5. Show the 7-step prompt sequence — how each step feeds into the next, building context as it goes

### Hands-On (5 min)

Browse the scenarios list. Find one relevant to your team's stack. Read the `flightplan.yaml` and identify the gates and checkpoints. Ask yourself: what would you add for your organization's compliance requirements?

> "The key insight is that flightplan.yaml is just a starting point. Every organization has different rules. The value is the structure, not the specific checks."

### Transition

> "That's our final module. Let's put it all together and talk about what you do Monday morning."

---

## 📘 Module 8: What to Do Monday Morning (20 min)

### The Journey We Took Today

> "We started the day with a simple question: how do you build security into your workflow without slowing down? Here's what we covered, layer by layer:"

| Layer | What It Does | Module | Tool |
|-------|-------------|--------|------|
| **Foundation** | Understand your AI assistant | Module 1 | GitHub Copilot |
| **Prevention** | Catch problems before they merge | Modules 2-3 | GitHub Actions (9 workflows) |
| **Detection** | Find problems that slipped through | Module 4 | Secure Vault (PII, secrets, CodeQL) |
| **API Security** | Protect your front door | Module 5 | Azure APIM + Agentic Review |
| **Operations** | Handle incidents when they happen | Module 6 | Day in the Life (12 scenarios) |
| **Modernization** | Upgrade old code safely | Module 7 | FlightPlans (agentic governance) |

Each layer builds on the one before it. You don't need all of them on day one — but you should know the full picture so you can plan the rollout.

> "Notice the pattern: prevention is cheaper than detection, detection is cheaper than incident response, and incident response is cheaper than a breach. The further left you invest, the more money you save."

### Your Monday Morning Checklist

These are concrete actions, ordered from easiest to hardest. Don't try to do everything. Pick the first one you haven't done and start there.

**This week (under 1 hour each):**

1. **Fork `github-security-demo`** and push it to your org — you have 9 working security workflows in 5 minutes
2. **Add `.copilotignore`** to your most sensitive repo — tell Copilot what to never touch
3. **Create `.github/copilot-instructions.md`** for your main repo — teach Copilot your team's rules

**This month:**

4. **Set up the PII scanner** for repos that handle customer data — customize the patterns for your industry
5. **Run Checkov** against your Terraform/CloudFormation — you'll be surprised what it finds
6. **Create a license policy** — ask your legal team which licenses are approved

**This quarter:**

7. **Implement Compliance as Code** with OPA — start with one framework (SOC2 or CIS)
8. **Set up API gateway policies** for your public APIs — rate limiting and auth validation at minimum
9. **Pick one legacy app** and start a FlightPlan modernization — choose the one with the most known CVEs

> "If you only do one thing from this list, do number 1. Five minutes of work gives you container scanning, dependency auditing, secret detection, and more — all running automatically on every push."

### The GitHub Advantage (Final Summary)

> "If someone in your organization asks 'why GitHub over GitLab or anything else,' here's your answer in one table:"

| Criteria | GitHub | GitLab | Others |
|----------|--------|--------|--------|
| AI pair programmer | Copilot (built-in, repo-aware) | Duo (newer, less mature) | Third-party tools |
| Security scanning | GHAS + Actions (best of both) | Built-in (limited customization) | Paid SaaS tools |
| Customization | Unlimited (YAML, any tool) | Limited to their platform | Varies |
| Ecosystem | 17,000+ Actions, 100M+ developers | GitLab-only marketplace | Varies |
| Transparency | Everything in readable YAML | Proprietary scanners | Black box |
| Agentic workflows | Copilot + Actions + MCP Servers | Limited | Varies |
| Cost of security features | Included in Enterprise | Requires Ultimate ($$$) | Per-tool pricing |

> "And remember — everything we showed you today is BEFORE you add GitHub Advanced Security. GHAS gives you CodeQL for deep code analysis, Dependabot for automated dependency updates, and secret scanning across your entire organization. That's another layer on top of everything we built today."

> "Security isn't a feature you ship. It's a habit you build. Start small. Start Monday. And keep going."

### Q&A Guide (for the presenter)

**"This seems like a lot of setup work."**

> "The initial setup takes about 2 hours for all 9 workflows. After that, it's fully automated. Compare that to the cost of a single security incident — the average data breach costs $4.45 million. Two hours of YAML is cheap insurance."

**"We already use [Snyk/Veracode/Checkmarx]. Why switch?"**

> "You don't have to switch. Actions works WITH those tools. Snyk has a GitHub Action. Checkmarx has a GitHub Action. You can use your existing tools inside the Actions pipeline. We're not replacing your scanner — we're giving you the automation layer."

**"How do we get Copilot approved for our enterprise?"**

> "Start with a pilot team. Use the content exclusion features (.copilotignore) to keep sensitive code out of scope. Run the audit trail from Module 4 to show compliance. Most enterprise approvals happen within 30-60 days when you can show the governance controls."

**"What about compliance? We're in a regulated industry."**

> "That's exactly why Module 4 (Compliance as Code) exists. Instead of telling your auditor 'we check compliance,' you can show them the Rego policy that runs on every commit. Code-based compliance is stronger than spreadsheet-based compliance."

**"GitLab has all of this built in. Why should we use GitHub?"**

> "GitLab's approach is 'trust us, we'll handle it.' GitHub's approach is 'here's the toolbox, you're in control.' If you want to customize a scanner, add a new compliance rule, or swap to a better tool next year, you can — without waiting for GitLab to add a feature. Plus, you get Copilot, which GitLab doesn't have at the same level."

---

## 📎 Appendix A: Prerequisites Checklist

Set these up **before** the workshop day. Nothing kills energy like spending 30 minutes on npm install.

### Repos to Fork

| Repo | URL | Used In |
|------|-----|---------|
| copilot-workshop | github.com/sautalwar/copilot-workshop | Module 1 |
| github-security-demo | github.com/sautalwar/github-security-demo | Modules 2-3 |
| ghcopilot-pii-demo | github.com/sautalwar/ghcopilot-pii-demo | Module 4 |
| how_APIM_works | github.com/sautalwar/how_APIM_works | Module 5 |
| it-security-copilot-demo | github.com/sautalwar/it-security-copilot-demo | Module 6 |
| FlightPlans | github.com/sautalwar/FlightPlans | Module 7 |

### Tools Required

- VS Code with GitHub Copilot extension
- GitHub account with Copilot access
- Node.js 18+ and npm
- Python 3.8+
- Docker Desktop (ensure it's running before the workshop starts)
- Git CLI and GitHub CLI (`gh`)
- Azure CLI (for Module 5 only — install ahead of time, it takes a while)

### Optional But Helpful

- Terraform CLI (for Module 3 IaC demo)
- OPA CLI (for Module 4 compliance demo)
- A second monitor (helpful for following along while running commands)

---

## 📎 Appendix B: Troubleshooting

Common issues and how to fix them:

| Problem | Solution |
|---------|----------|
| Actions workflow won't trigger | Check the `on:` trigger — does the push match the branch/path filter? |
| "Dependencies lock file not found" | Remove `cache: 'npm'` from setup-node, use `npm install` instead of `npm ci` |
| ZAP scan permission error | Add `chmod 777 $GITHUB_WORKSPACE` before the ZAP step |
| Copilot not suggesting code | Check VS Code extension is active, check Copilot subscription |
| OPA eval returns empty | Check the input JSON matches the Rego policy's expected structure |
| SARIF upload fails | Ensure the file exists (use `continue-on-error: true` on the scan step) |
| Docker build fails in CI | Check that Docker-in-Docker is available in your runner, or use a self-hosted runner |
| Python demo_runner.py crashes | Verify Python 3.8+ with `python --version` and install deps with `pip install -r requirements.txt` |

---

## 📎 Appendix C: Resources

### Core Documentation
- GitHub Actions Documentation: docs.github.com/en/actions
- GitHub Copilot Documentation: docs.github.com/en/copilot
- GitHub Advanced Security: docs.github.com/en/get-started/learning-about-github/about-github-advanced-security

### Security Standards
- OWASP API Top 10: owasp.org/API-Security/editions/2023/en/0x11-t10/
- OWASP Top 10 (Web): owasp.org/www-project-top-ten/
- CIS Benchmarks: cisecurity.org/cis-benchmarks

### Tools Used in This Workshop
- Open Policy Agent: openpolicyagent.org/docs/latest/
- Trivy Documentation: aquasecurity.github.io/trivy
- Checkov Documentation: checkov.io/docs
- CycloneDX SBOM Standard: cyclonedx.org
- ZAP (OWASP): zaproxy.org

---

## 📎 Appendix D: Facilitator Notes

### Timing

- The schedule adds up to ~5.5 hours of content + breaks/lunch. You have buffer.
- If you're running short, cut Module 5 (APIM) or Module 7 (FlightPlans). Both are valuable but less critical than the core security content.
- If you have extra time, go deeper on Module 3 (cover all 9 workflows instead of 5).
- Always end on time. Module 8 (Monday Morning) is the most important — don't let it get squeezed.

### Reading the Room

- If the audience is mostly developers: spend more time on Modules 1-3 (Copilot + Actions). They want to see code.
- If the audience includes security teams: spend more time on Modules 4-6 (detection + incident response). They want to see coverage.
- If the audience includes management: emphasize the cost/risk numbers and the compliance story. They want to see ROI.
- Mixed audiences are common — balance by doing the full agenda but adjusting the depth of your explanations.

### Handling Skeptics

**"AI writes bad code"**
> "That's why we have CI/CD. Copilot suggests, the pipeline validates. It's the same as code review — you don't merge without checks."

**"We don't trust third-party Actions"**
> "Good instinct. That's why we pin action versions and audit them. Module 6 covers CI/CD pipeline poisoning — we agree it's a risk."

**"This is too much change at once"**
> "Pick ONE workflow. Start with container scanning. Add more later. The repo is designed to be modular — each workflow file is independent."

### Common Live Demo Failures (and Recovery)

| What Goes Wrong | How to Recover |
|----------------|---------------|
| WiFi drops during live demo | Have screenshots/recordings as backup. Pre-clone all repos locally. |
| GitHub Actions queue is slow | Use `act` (local Actions runner) as a fallback for critical demos. |
| Copilot gives a bad suggestion | Use it as a teaching moment — "This is why we have CI/CD to catch mistakes." |
| Attendee's environment isn't set up | Pair them with a neighbor. Have a shared screen they can follow. |

### Energy Management

- Module 1 should be high-energy — it sets the tone for the entire day. Open with a live Copilot demo that wows people.
- Module 3 is the longest — break it up with hands-on exercises every 15 minutes. Don't lecture for 60 minutes straight.
- After lunch (Module 4), do a quick re-energizer before diving into incident response. A 2-minute stretch or a quick poll works well.
- Module 6 (Day in the Life) is the most engaging — save your energy for the storytelling here. This is where the audience leans in.
- Module 8 should feel like a rallying cry, not a lecture. Keep the energy up through the finish.

### Final Thought for Facilitators

> "The single most important outcome of this workshop is not that attendees remember every tool name or YAML syntax. It's that they leave believing security automation is achievable — not someday, but this week. If they fork one repo and set up one workflow on Monday, the workshop was a success."

---

