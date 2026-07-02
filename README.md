# TITLE

This repository contains the hands-on material for a workshop on ...

## Start Here

1. Open this repository in GitHub Codespaces.
2. Wait until the Codespace setup has completed.
3. Open `notebooks/01_LLM_exploration.ipynb`.
4. Run the notebooks in order.

The workshop is designed to run inside the provided Codespaces environment.

## Workshop Goals

By the end of the hands-on session, you will be able to:

- GOAL 1
- GOAL 2
- ...

## Workshop Roadmap

| Step | Notebook | Main focus | Output |
|---|---|---|---|
| 1 | `notebooks/01_LLM_exploration.ipynb` | ... | ... |

## How to Follow the Hands-On

### 1. LLM Exploratoin

In the first notebook, you will:

- TASK 1
- TASK 2
- ...

## Tips and Tricks for Jupyter

- Check that the selected kernel is the tutorial Python environment before starting.
- Run notebook cells sequentially unless the instructor tells you to skip ahead.
- Use `Shift+Enter` to run the current cell and move to the next one.
- Use `Esc` to enter command mode, then `B` to add a cell below or `A` to add a cell above.
- In command mode, use `C`, `X`, and `V` to copy, cut, and paste cells.
- If a plot or computation takes time, wait for the cell to finish before running it again.

## Technical Reference for Maintainers

### Working on the Notebooks

#### Local development with the GitHub-like container

To test notebook updates, fixes, or integrations locally in an environment close to the GitHub Codespaces VM, run:

```bash
scripts/local_test.sh
```

The script starts the same tutorial container image used by the devcontainer, mounts this repository into `/workspaces/nfdata-omics-ai-agents-tutorial`, and exposes Jupyter Lab on port `8888`.

You can work in one of two ways:

- Open Jupyter Lab directly from the URL printed in the terminal after the container starts.
- Attach VS Code to the running container with the **Dev Containers** extension. In VS Code, run `Dev Containers: Attach to Running Container...`, select the `ai-agents-tutorial` container, and open `/workspaces/nfdata-omics-ai-agents-tutorial`.

#### Development in GitHub Codespaces

Open the repository on GitHub, select **Code > Codespaces**, and create or resume a Codespace for this repository. After setup completes, open the notebooks from the `notebooks/` directory and run them with the configured tutorial Python environment.

### Git and Quality Checks

Before making changes, configure Git inside the environment if needed:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

Install the repository hooks once per environment:

```bash
prek install
```

The hooks are configured in `.pre-commit-config.yaml` and currently check YAML files, devcontainer schema validity, Dockerfiles, trailing whitespace, end-of-file newlines, large files, and notebook output cleanup through `nbstripout`.

Before opening a pull request, run all checks on the full repository:

```bash
prek run --all-files
```

### Updating the Software Environment

The Python environment used by GitHub Codespaces is defined by the container image referenced in `.devcontainer/devcontainer.json`. Python dependencies are declared in `requirements.in`, locked in `requirements.txt`, and installed during the image build from `.devcontainer/Dockerfile`.

To add, remove, or update Python packages:

1. Edit `requirements.in`.

   Keep this file focused on the direct dependencies needed by the tutorial. Pin versions only when the tutorial needs a specific version, compatibility range, or package build.

2. Recompile the locked dependency file.

   Run this from the repository root, preferably inside the Codespace or the local tutorial container:

   ```bash
   pip-compile requirements.in
   ```

   This updates `requirements.txt`, which records the fully resolved package versions used by the container build.

3. Commit and push the dependency changes.

   ```bash
   git add requirements.in requirements.txt
   git commit -m "Update Python environment"
   git push
   ```

   The GitHub Actions workflow in `.github/workflows/build-devcontainer-image.yml` builds and pushes a new image when changes to `requirements.in` or `requirements.txt` reach `main` or `master`. The image is published to `ghcr.io/nfdata-omics/ai-agents-tutorial` with two tags: the build date in `YYYY-MM-DD` format and `latest`.

4. Update the devcontainer image tag.

   After the image build has completed successfully, update `.devcontainer/devcontainer.json` so that `image` points to the new dated tag:

   ```json
   "image": "ghcr.io/nfdata-omics/ai-agents-tutorial:YYYY-MM-DD"
   ```

   Use the date tag produced by the successful GitHub Actions run, then commit and push this change:

   ```bash
   git add .devcontainer/devcontainer.json
   git commit -m "Update devcontainer image tag"
   git push
   ```

New Codespaces will use the updated image tag. Existing Codespaces may need to be rebuilt from the Codespaces command palette or recreated to pick up the new image.
