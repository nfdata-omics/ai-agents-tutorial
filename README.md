<h1 align="center">
  Exploratory Data Analysis<br>
  with AI
</h1>

This repository contains the hands-on material for the *__'Exploratory data analysis with AI'__* session at the 2026 summer school *‘AI for Life Sciences and Agri-Food Research’*. The workshop uses bulk RNA-seq as a practical case study for exploring LLMs, RAG, and AI agents.

## Hands-on guide

- [Start Here](#start-here)
- [Workshop Goals](#workshop-goals)
- [Workshop Roadmap](#workshop-roadmap)
- [Dataset and Biological Context](#dataset-and-biological-context)
- [How to Follow the Hands-On](#how-to-follow-the-hands-on)
- [Tips and Tricks for Jupyter](#tips-and-tricks-for-jupyter)


## Start Here

#### 1. Open this repository in GitHub Codespaces

#### 2. Wait until the Codespace setup has completed

#### 3. Open `notebooks/01_LLM_exploration.ipynb`

#### 4. Run the notebooks in order

The workshop is designed to run inside the provided Codespaces environment.


## Workshop Goals

By the end of the hands-on session, you will be able to:

- __Explore and control LLM behaviour__ by experimenting with model selection, prompts, context, output formats and reliability strategies.
- __Build and evaluate a retrieval-augmented generation (RAG) workflow__ using embeddings, document chunking, vector stores and retrieval techniques.
- __Design and compare AI agent architectures__ to query and interpret bulk RNA-seq data. 

## Workshop Roadmap

| Step | Notebook | Main focus | 
|---|---|---|
| 1 | [01_LLM_exploration](notebooks/01_LLM_exploration.ipynb) | LLM capabilities for RNA-seq interpretation: comparing models, prompts, context and output methods | 
| 2 | [02_RAG](notebooks/02_RAG.ipynb) | Grounding LLMs with project-specific knowledge: RAG, embeddings, semantic search, vector databases |
| 3 | [03_agent_architectures](notebooks/03_agent_architectures.ipynb) | Building an AI agent to interact with omics data: architectures, tool use, memory and orchestration |

## Dataset and Biological Context

This workshop uses data derived from the Bioconductor [`airway`](https://bioconductor.org/packages/airway/) package, a widely used bulk RNA-seq example. The experiment profiled four primary human airway smooth muscle cell lines under two conditions: untreated and treated with dexamethasone, giving eight samples in a paired design.

Airway smooth muscle cells are specialised lung cells located in the walls of the airways, where they help regulate airway narrowing and relaxation. Dexamethasone, a synthetic glucocorticoid with anti-inflammatory activity, was used to investigate how corticosteroid exposure changes gene expression in these cells.

The data originate from Himes et al. (2014), [*RNA-Seq Transcriptome Profiling Identifies CRISPLD2 as a Glucocorticoid Responsive Gene that Modulates Cytokine Function in Airway Smooth Muscle Cells*](https://journals.plos.org/plosone/article?id=10.1371%2Fjournal.pone.0099625), *PLOS ONE*, 9(6), e99625.


## How to Follow the Hands-On

### 1. [LLM Exploration](notebooks/01_LLM_exploration.ipynb)

In the first notebook, you will:

* Compare how model choice, temperature, prompts, and context affect LLM responses.
* Generate and validate outputs in free-text, JSON, Pydantic, and structured formats.
* Test reliability techniques such as retries, fallback models, streaming, and citations.

### 2. [RAG](notebooks/02_RAG.ipynb)

In the second notebook, you will:

* Prepare bulk RNA-seq literature for retrieval using document splitting and embeddings.
* Build and compare vector stores and retrieval methods.
* Evaluate how chunking, metadata filtering, and top-k selection affect retrieved context.

### 3. [Agent Architectures](notebooks/03_agent_architectures.ipynb)

In the third notebook, you will:

* Create tools for querying and analysing bulk RNA-seq data and results.
* Build and compare tool-calling agents, routers, and sequential chains.
* Explore how memory and tool configuration affect agents’ responses to biological questions.


## Tips and Tricks for Jupyter

- Check that the selected kernel is the tutorial Python environment before starting.
- Run notebook cells sequentially unless the instructor tells you to skip ahead.
- Use `Shift+Enter` to run the current cell and move to the next one.
- Use `Esc` to enter command mode, then `B` to add a cell below or `A` to add a cell above.
- In command mode, use `C`, `X`, and `V` to copy, cut, and paste cells.
- If a plot or computation takes time, wait for the cell to finish before running it again.

<details>

## Technical Reference for Maintainers

<summary><strong>See here for details</strong></summary>

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

</details>
