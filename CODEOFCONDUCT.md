# Contributing to barbecue.nvim

## Getting Started

1. [Fork](/../../fork) and clone this
   repository

  ```bash
  git clone --branch=dev https://github.com/[user]/barbecue.nvim.git
  ```

2. Change your config so that neovim will load your locally cloned plugin

  - [lazy.nvim](https://github.com/folke/lazy.nvim)

    ```lua
    local spec = {
      "utilyre/barbecue.nvim",
      dev = true,
      -- ...
    }
    ```

  - [packer.nvim](https://github.com/wbthomason/packer.nvim)

    ```lua
    use({
      "~/projects/barbecue.nvim",
      -- ...
    })
    ```

3. Create feature branch and do stuff

  ```bash
  git checkout -b feature/[pr-subject]
  # or
  git checkout -b bugfix/[pr-subject]
  # or
  git checkout -b hotfix/[pr-subject]
  ```

## Development Tools

- Format your code with [stylua](https://github.com/johnnymorganz/stylua).

  The following command will check if everything is formatted based on the [guidelines](/.stylua.toml)

  ```bash
  stylua -c .
  ```

## Best Practices

- Create a draft PR for avoiding duplicate work.
- Use feature branch.
- Base your feature branch off of `dev` branch.
- Title PRs the same way as commit headers.
- Adopt [Karma](https://karma-runner.github.io/latest/dev/git-commit-msg.html)
  git commit conventions.

## FAQ

- What if I accidentally create a branch based on `main`?

  1. Change branch from `main` to `dev` on GitHub web.

  2. Rebase your branch towards `dev`

    ```bash
    git rebase remotes/origin/dev
    ```

  3. Force push

  ```bash
  git push -f
  ```

- How can I keep my branch up to date with `dev`?

  1. Rebase towards `dev`

  ```bash
  git rebase dev
  ```

  2. Force push

  ```bash
  git push -f
  ```
