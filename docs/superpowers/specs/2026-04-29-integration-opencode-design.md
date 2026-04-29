# Design d'intégration OpenCode dans Secretarius

Date : 2026-04-29
Statut : Approuvé — étape intermédiaire

## Objectif

Intégrer OpenCode comme co-agent de Secretarius pour séparer les tâches récurrentes/légères (OpenClaw) des tâches complexes/ponctuelles (OpenCode), dans le cadre d'une activité de conseil en IA.

## Contexte marché

### Concurrents directs
- **Norma** : Agents autonomes en production, déploiement 3 semaines — pas de recherche/académique
- **WorkFlō** : Automatisation processus métier — pas de souveraineté locale
- **ActivDev** : ROI rapide no-code pour PME — pas de SLM local
- **Addepto** : Conformité EU AI Act — pas de local-first
- **Systelium** : Prix imbattables — staff augmentation, pas de produit

### Différenciation Secretarius
- **Local-first** (SLM, Mistral pour le sensible) — aucun concurrent ne le fait
- **Secretarius comme preuve de concept** — vendre ce que l'on utilise
- **Double compétence** : thèse LN + expérience IBM + expertise technique agents IA

### Positionnement
Conseil en IA souveraine, local-first, pour PME/ETI européennes sensibles à la confidentialité (santé, juridique, finance, défense).

## Architecture : Workspace partagé + protocole de handoff

### Principe

Un répertoire `/workspace/handoff/` sert de zone de transfert entre OpenClaw et OpenCode.

### Flux

1. OpenClaw (ou l'utilisateur) crée un brief dans `/workspace/handoff/pending/<id>.md`
2. OpenCode détecte le brief, le traite, écrit le résultat dans `/workspace/handoff/completed/<id>/`
3. OpenClaw est notifié (fichier signal ou polling) et récupère le résultat

### Structure du brief

```
/workspace/handoff/pending/2026-04-29-001-plan-commercial.md
```

Contenu :
- Contexte client
- Tâche demandée
- Contraintes (local, Mistral, etc.)
- Deadline
- Références (fichiers, URLs)

### Structure du résultat

```
/workspace/handoff/completed/2026-04-29-001-plan-commercial/
```

Contenu :
- Deliverable principal
- Notes de production (modèles utilisés, temps, etc.)
- Statut (succès, partiel, échec + raison)

## Modes d'interaction

| Mode | Déclencheur | Qui écrit le brief | Qui traite |
|------|-------------|-------------------|------------|
| **Manuel** | Utilisateur crée le brief | Utilisateur | OpenCode |
| **Délégation** | OpenClaw identifie besoin | OpenClaw | OpenCode |
| **Hybride** | Utilisateur invoque OpenCode | Utilisateur ou OpenClaw | OpenCode |

## Skills comptabilité/juridique

Fichiers de référence dans `/workspace/skills/` :
- `skills/rgpd/SKILL.md` — règles RGPD, templates DPA, checklists
- `skills/eu-ai-act/SKILL.md` — classification risques, obligations
- `skills/comptabilite/SKILL.md` — normes européennes, facturation

OpenClaw et OpenCode les consultent selon le contexte. OpenCode peut les enrichir avec de nouvelles recherches.

## Contexte et mémoire

| Fichier | Rôle |
|---------|------|
| `/workspace/CONTEXT.md` | Contexte projet global |
| `/workspace/logs/` | Logs de session |
| `/workspace/context_health` | Santé du contexte |
| Briefs | Incluent lien vers contexte pertinent |

## Critères de succès

- Contexte de conversation préservé lors du handoff
- Deliverables de qualité professionnelle directement livrables
- Capacité à vendre cette intégration comme service différenciant
- Skills comptabilité/juridique fonctionnels (RGPD, EU AI Act, bureaucratie européenne)

## Prochaines étapes

1. Créer la structure `/workspace/handoff/{pending,completed}/`
2. Définir le format exact des briefs (template)
3. Implémenter la détection de briefs par OpenCode
4. Créer les premiers skills juridiques (RGPD, EU AI Act)
5. Tester le flux complet avec un cas réel
