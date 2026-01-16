---
name: document-writer
description: Technical writing expert for documentation, README files, API docs, and user guides. Use for any documentation that needs to be clear and professional.
---

# Document Writer Skill

Creating clear, professional technical documentation.

## Model Selection

| Task Type | Recommended Model | Why |
|-----------|-------------------|-----|
| **Technical writing** | **Claude Sonnet 4.5** | Clear, polished prose |
| **API documentation** | **Gemini 3 Pro** | Technical accuracy |
| **Quick READMEs** | **Gemini 3 Flash** | Speed for simple docs |

## When to Use This Skill

- Writing README files
- Creating API documentation
- Writing user guides and tutorials
- Documenting architecture decisions
- Creating changelog entries
- Writing inline code documentation

## Documentation Principles

### 1. Know Your Audience

- **Developers**: Focus on API, code examples, quick start
- **End Users**: Focus on tasks, avoid jargon, include screenshots
- **Stakeholders**: Focus on capabilities, benefits, architecture overview

### 2. Structure for Scanning

- Use clear headings and hierarchy
- Keep paragraphs short (3-5 sentences max)
- Use bullet points for lists
- Include a table of contents for long docs
- Put the most important information first

### 3. Show, Don't Just Tell

- Include code examples for every API
- Add screenshots for UI features
- Provide before/after comparisons
- Link to working demos when possible

## README Template

```markdown
# Project Name

One-paragraph description of what this project does and why it exists.

## Quick Start

\`\`\`bash
# Installation
npm install project-name

# Usage
npx project-name init
\`\`\`

## Features

- ✅ Feature one with brief description
- ✅ Feature two with brief description
- ✅ Feature three with brief description

## Installation

Detailed installation instructions...

## Usage

### Basic Usage
Code examples and explanation...

### Advanced Usage
More complex examples...

## Configuration

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `option1` | string | `'default'` | What it does |
| `option2` | boolean | `false` | What it controls |

## API Reference

### `functionName(param1, param2)`

Description of what the function does.

**Parameters:**
- `param1` (string): Description
- `param2` (object, optional): Description

**Returns:** Description of return value

**Example:**
\`\`\`javascript
const result = functionName('value', { option: true });
\`\`\`

## Contributing

How to contribute to this project...

## License

MIT © [Author Name]
```

## API Documentation Format

### Function Documentation

```markdown
## `functionName(param1, param2, options?)`

Brief description of what the function does.

### Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `param1` | `string` | Yes | Description |
| `param2` | `number` | Yes | Description |
| `options` | `Options` | No | Configuration object |

### Options

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `timeout` | `number` | `5000` | Timeout in ms |
| `retry` | `boolean` | `true` | Whether to retry |

### Returns

`Promise<Result>` - Description of the return value

### Throws

- `ValidationError` - When parameters are invalid
- `NetworkError` - When the request fails

### Example

\`\`\`typescript
import { functionName } from 'package';

const result = await functionName('input', 42, {
  timeout: 10000,
  retry: false
});

console.log(result.data);
\`\`\`
```

## Writing Style Guide

### Be Concise

```diff
- In order to install the package, you will need to run the following command:
+ To install:
```

### Use Active Voice

```diff
- The configuration file is read by the application at startup.
+ The application reads the configuration file at startup.
```

### Use Present Tense

```diff
- This function will return an array.
+ This function returns an array.
```

### Be Direct

```diff
- You might want to consider using the cache option.
+ Use the cache option to improve performance.
```

## Code Examples Best Practices

1. **Make them runnable**: Examples should work when copied
2. **Show common cases first**: Start with typical usage
3. **Include error handling**: Show production-ready patterns
4. **Add comments**: Explain non-obvious parts
5. **Keep them focused**: One concept per example

## Changelog Format

```markdown
# Changelog

## [2.0.0] - 2024-01-15

### Breaking Changes
- Renamed `oldFunction` to `newFunction`

### Added
- New feature description (#123)

### Fixed
- Bug description (#456)

### Changed
- Improvement description

### Deprecated
- Feature that will be removed in next major version
```

## Best Practices

- Review documentation as carefully as code
- Keep docs in sync with code changes
- Include the "why", not just the "what"
- Test all code examples
- Get feedback from fresh eyes
- Version your documentation
