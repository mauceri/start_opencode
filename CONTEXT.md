# Contexte Projet Secretarius — Mémoire Session

> Fichier de reprise de contexte pour opencode. À lire à chaque redémarrage.

## Vision

Assistant documentaire personnel, **local, confidentiel et frugal**, fonctionnant sans cloud sur une machine de jeu AMD (Ryzen 9 6900HX, 30 Go RAM, GPU 8 Go VRAM).

## Historique

1. **Première tentative** : Indexation par extraction d'expressions caractéristiques via Phi-4-mini fine-tuné (LoRA) pour imiter DeepSeek. Chunking sémantique + corpus synthétique (GPT-5) + Wikipédia. Résultat : perplexité 1,3-1,4 mais performances inférieures à ColBERT (late interaction). **Abandonné.**
2. **Pivot** : Découverte du pattern LLM Wiki d'Andrej Karpathy → implémentation d'un wiki personnel géré par LLM.
3. **Intégration** : Fusion du wiki avec OpenClaw pour créer un assistant complet (Tiron) avec ingestion, recherche, et communication (Telegram).

## Architecture

### Backends LLM (2 backends distincts, ne pas modifier)

| Backend | URL | Modèle | Rôle |
|---------|-----|--------|------|
| llama.cpp server | `127.0.0.1:8989` | Phi-4-mini LoRA (Wikipedia FR) | `expression_extractor.py` |
| Ollama | `localhost:11434` | Qwen | `llm_ollama.py` (Chef d'Orchestre) |

### Composants principaux (`Prototype/secretarius_local/`)

- `expression_extractor.py` — extraction expressions via Phi-4/llama.cpp
- `embeddings.py` — BGE-M3 (BAAI/bge-m3), 1024 dim, L2-normalisé
- `semantic_graph.py` — Milvus 2.2 (COSINE → IP avec vecteurs normalisés)
- `document_pipeline.py` — pipeline : chunking → expressions → embeddings → Milvus
- `chef_orchestre.py` — cycle ReAct, max 2 outils/cycle, recovery JSON
- `mcp_server.py` — 6 outils MCP exposés

### Wiki_LM

- Pipeline de knowledge base personnelle (pattern Karpathy)
- Ingestion batch depuis `raw/` avec déduplication (SHA-256 / URL normalisée)
- Enrichissement Wikipedia anti-hallucination (ZIM Kiwix → cache SQLite → API REST)
- Recherche BM25 + BGE-M3 hybride (Reciprocal Rank Fusion)
- Serveur Flask local + intégration Obsidian
- ~21 000 fichiers ingérés (signets Brave), ~4 000 fichiers raw avec doublons
- 74 tests pytest, zéro réseau

## Répartition des agents

| Agent | Responsabilité | Workspace |
|-------|----------------|-----------|
| **Claude Code** | Wiki_LM (ingestion, déduplication, recherche BM25, cache Wikipedia, clustering HDBSCAN) | `/root/Secretarius/` |
| **opencode (moi)** | OpenClaw, déploiement, intégration, infrastructure | `/workspace/` |

## État des branches

- Branches `intégration` et `développement` **mergées dans `main`**
- Dernier commit : `e9c4c4f` — spec design wiki clustering (similarité + HDBSCAN + Obsidian)

## Plan d'action

| # | Phase | Statut |
|---|-------|--------|
| 1 | Late Interaction ColBERT (`aggregate_late_interaction`) | **Abandonné** (remplacé par LLM Wiki) |
| 2 | Consolidation tests Wiki_LM | En cours (Claude Code) |
| 3 | Wiki clustering (similarité + HDBSCAN + Obsidian) | Spec rédigée, à implémenter |
| 4 | Déploiement systemd + Milvus Docker | **Priorité opencode** |
| 5 | Intégration OpenClaw + OpenCode | Idée validée, design à faire |

## OpenClaw — Configuration

- Config : `/root/Secretarius/install.conf`
- Templates : `openclaw-config/` (openclaw.json.template, gateway.systemd.env.template, openclaw-gateway.service)
- **Skills** : `openclaw-config/skills/` (12 skills : wiki-lm, secretarius-document-normalizer, switch-model, obsidian, scout, archivage-arbath, gog, mail-summary, sequential-thinking, prompt-injection-guard, email-prompt-injection-defense, c)
- Assistant name : **Tiron**
- LLM backend par défaut : deepseek
- Obsidian path : `$HOME/Documents/Obsidian`
- Script d'installation : `openclaw-config/install.sh` (génère ~/.openclaw/ + installe les skills)

## Services locaux (machine sanroque)

| Service | Port | Rôle |
|---------|------|------|
| llama.cpp server | 8989 | Extraction d'expressions |
| Ollama | 11434 | Routeur / Chef d'Orchestre |
| session_bot.service | — | Bot Session Messenger |

## Règles importantes

- **NE JAMAIS** proposer de charger un GGUF dans Ollama
- **NE JAMAIS** modifier `llm_ollama.py` pour pointer vers llama.cpp
- Déploiement cible : **systemd** (pas Docker pour l'app, Docker uniquement pour Milvus)
- Confirmation requise avant : `systemctl start/stop/enable`, `docker compose up/down`, `git push`

## Machine

- OS : Linux (AMD iGPU gfx900 / ROCm)
- Hostname : `sanroque`
- Utilisateur hôte : `mauceric` (UID 1000) / root dans le conteneur

## Idées en cours — Intégration OpenClaw + OpenCode

**Vision** : Répartir les rôles entre les deux agents :
- **OpenClaw** : Affaires courantes, confidentialité, Telegram, ingestion wiki, gestion quotidienne
- **OpenCode** : Code, brainstorming superpowers/gstack, développement, architecture

**Ponts possibles à explorer** :
1. **MCP** — OpenClaw expose des outils MCP que OpenCode consomme (ou l'inverse)
2. **Partage de workspace** — les deux agents sur le même repo avec rôles séparés
3. **OpenCode Zen comme backend LLM** pour OpenClaw (déjà supporté nativement)

**Statut** : Idée validée par l'utilisateur, design formel à faire plus tard.

## Emplacements clés

| Chemin | Description |
|--------|-------------|
| `~/Secretarius/` | Repo principal sur l'hôte |
| `/workspace/` | Workspace du conteneur Docker |
| `/workspace/Secretarius/` | Copie du repo dans le conteneur |
| `~/Documents/Arbath/Secretarius_dev/` | Archives du projet (historique, briefings) |
| `~/Secretarius/Prototype/` | Scripts Python du prototype |
| `~/lora_local/` | Artefacts LoRA (NE PAS déplacer) |
| `~/lora_slm/` | Scripts pipeline LoRA |
