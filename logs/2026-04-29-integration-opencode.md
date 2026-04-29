# Session Log — Intégration OpenCode dans Secretarius

## Session 2026-04-29

### Contexte initial
- Nettoyage de CONTEXT.md (ancien, délirant) et du worktree `intégration`
- Création de `/workspace/AGENTS.md` avec règle du français et workspace comme lieu de travail
- Lecture de l'historique du projet (`HistoriqueSecretarius.md`, `Nouveau_départ.md`)
- Création de `/workspace/CONTEXT.md` (mémoire projet)
- Push initial sur GitHub (`github.com:mauceri/start_opencode.git`)

### Brainstorming : Intégration OpenCode + Secretarius
**Vision utilisateur** : Conseil en IA, Secretarius comme vitrine et outil de production, apprendre en marchant.

**Rôle d'OpenCode** : Production interne + démonstrateur client.

**Tâches** : Développement IA sur mesure, création de contenu, analyse de données, ingénierie logicielle.

**Modes d'interaction** :
- Pilotage manuel par l'utilisateur
- Délégation automatique d'OpenClaw → OpenCode
- Mode hybride (OpenClaw affaires courantes, OpenCode tâches complexes)

**Critères de succès** :
- Contexte de conversation préservé lors du handoff
- Deliverables de qualité professionnelle
- Capacité à vendre comme service différenciant
- Skills comptabilité/juridique (RGPD, EU AI Act, bureaucratie européenne)

**Approche retenue** : Workspace partagé + protocole de handoff (Approche 2)
- Les deux agents partagent le même workspace/repo
- Protocole : OpenClaw écrit un brief, OpenCode le prend, produit le résultat, signale la fin
- Contexte préservé dans des fichiers partagés (briefs, résultats, logs)
- Skills comptabilité/juridique comme fichiers de référence dans le workspace

### Mécanismes mis en place
- Gestion du contexte : logs de session + fichier `context_health` + alerte quand le contexte sature
- Règles documentées dans AGENTS.md
