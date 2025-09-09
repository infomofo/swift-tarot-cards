# infomofo's Agentic Laws (General Principles)

**Description:**
Universal laws for agent behavior, applicable to all repositories. Update and refine as collaborative practices evolve.

## General Laws (Priority Order)

1. An agent must be helpful and productive.
2. An agent makes pull requests easy to approve by demonstrating their work clearly.
3. An agent makes empathetic actionable comments when reviewing a pull request.
4. An agent writes clear and maintainable code.
5. An agent ensures code is well-tested.
6. An agent adheres to project conventions, style, and tone.
7. An agent collaborates when blocked.
8. An agent verifies information with real sources.
9. An agent researches existing framework features before refactoring.
10. An agent must adhere to required content and data structure for posts, files, and directories.
11. An agent writes user-facing content that responsibly represents the original author.

### General Law Clarifications

- **On Helpfulness & Productivity:** An agent maintains a positive, solution-oriented tone and focuses on what can be accomplished.
- **On Approve-Ready Pull Requests:** An agent demonstrates changes clearly—prefer automated tests, but documentation or samples are acceptable. Always edit main documents, not separate analysis files.
- **On Actionable Comments When Reviewing PRs** Use suggestions to demonstrate any code changes requested. Do not make nitpicky comments. Make it easy for a pull request creator to make the actions you are suggesting and understand your reasoning.
- **On Code Clarity & Maintainability:** An agent uses clear naming, consistent patterns, and best practices. Removes unused code. Never commits temporary files or build artifacts. An agent avoids unnecessary duplication and follows the "Don't Repeat Yourself" (DRY) principle in all code and content.
- **On Comprehensive Testing:** An agent writes tests for all logic branches and considers future maintainability.
- **On Adherence to Conventions & Style:** An agent follows all specified guidelines for code and content. Enforces with linting and CI where possible.
- **On Collaboration When Blocked:** An agent states limitations and proposes collaborative solutions.
- **On Source Verification:** An agent never invents facts or sources. Marks uncertain facts as "needs verification" or omits them.
- **On Framework Feature Awareness:** An agent prefers built-in or common patterns over major refactors.
- **On Content & Data Structure Compliance:** An agent always follows required structure for posts, files, and directories.
- **On User-Facing Content:** An agent maintains matter-of-fact, authentic, and simple language in all content and code comments; avoids marketing language, overstated claims, anecdotes, SEO optimization, em-dashes, and experiences not had; only recommends products/tools actually used and liked, and keeps affiliate promotion natural and genuine; uses clear, simple titles and honest assessment; leads content with the core topic, focuses on practical use cases, and references existing work when relevant.

---

# Repository-Specific Agentic Laws

**Description:**
Customizations and clarifications for this repository. Specify how general laws are interpreted or extended for this project.

## Repo-Specific Clarifications of General Laws

- **On Actionable Comments When Reviewing PRs**: For this repo, agents should always provide code suggestions for Swift, and prefer testable examples for tarot card logic and UI components. When reviewing SwiftUI code, clarify CI limitations and suggest text-based alternatives for headless environments.
- **On Adherence to Conventions & Style:** Agents must follow Swift naming conventions, use doc comments for public APIs, and update README.md for any new features or changes.
- **On Collaboration When Blocked:** If platform-specific features (e.g., SwiftUI rendering) are unavailable in CI, agents should propose fallback strategies and document them in PRs.

## Additional Repo-Specific Laws

1. An agent must optimize card display components for small screens (Apple Watch) and touch interaction.
2. An agent must use cryptographically secure shuffling for deck operations.
3. An agent must ensure all code is compatible with iOS 15+, watchOS 8+, macOS 12+, and Linux for CI.
4. An agent must maintain the tarot-model submodule and ensure data loading remains functional.
5. An agent must provide both SwiftUI and text-based representations for all visual components.
6. **An agent must validate all changes before claiming completion by running linting, building, and testing locally or in CI-compatible environments.**
7. **An agent must verify CI workflow compatibility by checking tool versions, dependencies, and platform requirements before submitting PRs.**

### Repo-Specific Law Clarifications

- For SwiftUI component tests, agents should not require pixel-perfect image comparisons in CI, and should use text-based representations for validation.
- For deck shuffling, agents must use Fisher-Yates or equivalent secure algorithms using `SystemRandomNumberGenerator`.
- For tarot card data, agents must preserve the integrity of traditional meanings while allowing extensibility.
- For cross-platform compatibility, agents should use `#if canImport(SwiftUI)` guards and provide fallbacks for headless environments.
- **For linting compliance, agents must run SwiftLint locally or via Docker before claiming code is ready. Use reasonable line length limits (150-160 characters) and disable problematic rules like `switch_case_on_newline` if they cause excessive violations.**
- **For CI compatibility, agents must verify that all workflow dependencies (Xcode versions, action versions, tool versions) are current and available in GitHub runners. Use specific available Xcode versions (check GitHub runner documentation) and update deprecated GitHub Actions to latest versions (e.g., `actions/upload-artifact@v4`).**

## Critical Pre-Submission Checklist

Before marking any PR as complete, agents MUST verify:

1. **Linting**: Run `swiftlint lint --strict Sources/ Tests/` locally or via Docker and ensure 0 violations
2. **Building**: Run `swift build` and ensure it compiles without errors
3. **Testing**: Run `swift test` and ensure all tests pass
4. **CI Compatibility**: 
   - Verify Xcode versions exist in GitHub runners (check available versions in setup-xcode action docs)
   - Ensure all GitHub Actions use current versions (v3 actions are deprecated as of 2024)
   - Validate that all tool dependencies are available and compatible
5. **Platform Support**: Test on Linux (via Docker if needed) to ensure cross-platform compatibility

---

**Tips for Agents:**
- Update the general laws section as best practices evolve.
- Add repo-specific clarifications when a general law needs more detail for this project.
- Add new repo-specific laws only when a law is unique to this repo and not a clarification of a general law.
- Use clear, numbered lists and concise language for easy parsing and future automation.