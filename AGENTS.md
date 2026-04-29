# AGENTS.md — Projet Secretarius

## Règles

- Tout ce qui est relatif à ce projet (code, commits, docs, configs) doit être écrit en français

## Workspace

- Mon lieu de travail privilégié est `/workspace/`
- La mémoire de nos échanges (contexte de session) doit être conservée dans `/workspace/` pour permettre la reprise entre sessions

## Gestion du contexte

- **Logs de session** : chaque session significative est consignée dans `/workspace/logs/YYYY-MM-DD-<sujet>.md`
- **Contexte projet** : `/workspace/CONTEXT.md` est mis à jour à chaque session avec l'état courant
- **Santé du contexte** : `/workspace/context_health` suit l'estimation de saturation du contexte
- **Alerte** : quand le contexte approche de la saturation (~70%+), je signale explicitement qu'il est temps de démarrer une nouvelle discussion et je sauvegarde l'état courant avant la coupure
