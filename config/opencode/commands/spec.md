---
description: write plan/context as spec to _IGNORE/specs
agent: build
---

You are writing a SPEC markdown file for the just-finished planning session.

## Inputs
- Today: !`date +%F`
- Project root (cwd): !`pwd`
- Optional title override: "$ARGUMENTS" (if empty, infer from plan)
- Current todos: !`opencode todo list 2>/dev/null || echo "[]"`

## Requirements
1) Ensure `_IGNORE/specs` exists in the project root.
2) Create a spec file in `_IGNORE/specs`.
3) Filename: `YYYY-MM-DD_<slug>.md`
   - `<slug>` derived from title:
     - lowercase
     - spaces/dashes => `_`
     - remove non `[a-z0-9_]`
     - collapse multiple `_`
4) Choose template:
   - Count ALL plan steps from:
     a) Steps discussed/mentioned in the conversation context (look for numbered lists, bullet plans, "we'll do X, Y, Z" sections)
     b) PLUS any items from `todoread` output above
   - If total plan steps `<= 4` => use **SMALL** template
   - Else => use **NORMAL** template
5) Fill the template with the plan + context from THIS conversation.
   - Combine conversation plan + todoread items into a unified implementation checklist
   - If info unknown: keep `<...>` placeholders (do not invent).
   - Include all plan steps as bullets/checkboxes (depending on template).
6) Avoid overwriting:
   - If file exists, append `_2`, `_3`, ... before `.md`.

## Execution (do it, don't just describe)
- Use bash to `mkdir -p _IGNORE/specs` in project root.
- Extract plan steps from conversation + parse todoread output.
- Decide title:
  - If `$ARGUMENTS` not empty => title = `$ARGUMENTS`
  - Else if conversation has clear plan topic => infer from that
  - Else if todoread has items => title = first todo content
  - Else => ask user for a short title, then continue.
- Count total steps (conversation + todos) to choose SMALL vs NORMAL.
- Write the final markdown to the chosen filepath.
- Reply with the created filepath + 1 sentence summary.

## Template: SMALL
```
# <Korte titel>

## Doel
- <1 zin: wat verandert er?>

## Huidig vs gewenst
- Huidig: <...>
- Gewenst: <...>

[OPTIONEEL] Repro
- Stap 1: <...>
- Stap 2: <...>

## Root cause (kort)
- <1–3 bullets>

## Fix (concreet)
- <bullet 1: wat pas je aan?>
- <bullet 2: wat pas je aan?>

[OPTIONEEL] Context & bronnen
- Files bekeken:
  - `<pad/naar/file>`
- Opmerkingen:
  - <observatie>

## Tests
- Voeg toe/wijzig: <testnaam/locatie>
- Verwachting:
  - Voor fix: <faalt/issue>
  - Na fix: <slaat/werkt>

## Files
- Modified:
  - `<pad/naar/file>`
[OPTIONEEL] New:
  - `<pad/naar/file>`

## Commands / validators
- `<command>`

[OPTIONEEL] Notes / risico
- <1 bullet>
```

## Template: NORMAL
```
# <Korte titel>

## 1. Doel
**Wat moet er veranderen?** (1–3 zinnen)

**Succescriteria (testbaar)**
1. <...>
2. <...>
3. <...>

[OPTIONEEL] **Out of scope**
- <wat lossen we expliciet niet op>

## 2. Huidige situatie
**Huidig gedrag**
- <wat gebeurt er nu?>
- Impact: <wie/waarom last?>
- Repro (indien van toepassing):
  - Stap 1: <...>
  - Stap 2: <...>
  - Verwacht nu: <...>
  - Werkelijk nu: <...>

**Gewenst gedrag**
- <wat moet er gebeuren?>

[OPTIONEEL] **Terminologie / definities**
- <begrip> = <betekenis>

## 3. Context & bronnen (voor de agent)
**Gebruikte bronnen tijdens analyse/planning**
- Files bekeken:
  - `<pad/naar/file1>`
- Queries/zoektermen (indien van toepassing):
  - `<...>`
- Externe bronnen (indien van toepassing):
  - <link of referentie>

**Belangrijke observaties uit de context**
- <observatie 1>

## 4. Analyse
**Root cause**
- <oorzaak + korte uitleg>

[OPTIONEEL] **Randvoorwaarden / constraints**
- <bijv. backward compatibility, performance, security, compliance>

[OPTIONEEL] **Risico's & mitigaties**
- Risico: <...> → Mitigatie: <...>

[OPTIONEEL] **Alternatieven overwogen**
- Optie A: <pro/cons>
- Optie B: <pro/cons>
- Keuze: <waarom>

## 5. Oplossing (design)
**Kernidee**
- <1 alinea: wat bouwen/aanpassen we?>

**Gedragsveranderingen (samengevat)**
- Voor: <...>
- Na: <...>

[OPTIONEEL] **Interfaces/contracten**
- API/CLI/event/config wijzigingen:
  - `<interface>`: <wat verandert>
- Required/optional velden:
  - Required: <...>
  - Optional: <...>

[OPTIONEEL] **Data mapping / transformaties**
| Input | Output | Regel/opmerking |
|---|---|---|
| <...> | <...> | <...> |

[OPTIONEEL] **Observability**
- Logging: <wat/waarom>
- Metrics/tracing: <wat/waarom>
- Alerts: <wat/waarom>

## 6. Implementatieplan (checklist)
> Schrijf dit als uitvoerbare stappen. Houd het concreet: "wijzig bestand X", "voeg test Y toe", "pas guard Z aan". Wees niet sturend in hoe exact de oplossing moet worden, dat bepaalt de implementator.

### 6.1 Tests eerst (of regressie)
- [ ] Voeg test(s) toe in `<pad>` die het huidige probleem vangen
- [ ] Verwachte failure vóór fix: <...>
- [ ] Verwachte pass na fix: <...>

### 6.2 Implementatie
- [ ] <todo stap 1>
- [ ] <todo stap 2>

### 6.3 Edge cases & validatie
- [ ] Edge case: <...> → verwacht: <...>
- [ ] Permissions/auth (indien relevant): <...>
- [ ] Performance (indien relevant): <...>

### 6.4 Cleanup
- [ ] Verwijder tijdelijke code/flags (indien van toepassing)
- [ ] Update docs/config (indien van toepassing)

## 7. Bestandswijzigingen (overzicht)
**Nieuw**
- `<pad/naar/new_file>`

**Gewijzigd**
- `<pad/naar/existing_file>`

**Verwijderd**
- `<pad/naar/removed_file>`

[OPTIONEEL] **Migrations / data changes**
- `<pad/naar/migration>` + korte toelichting

## 8. Testplan
**Automated**
- Unit: <...>
- Integration/contract: <...>
- E2E (indien relevant): <...>

[OPTIONEEL] **Manual checks**
- Stap 1: <...>
- Stap 2: <...>

## 9. Commands / validators
- `<command 1>`
- `<command 2>`

## 10. Rollout
**Deploy-impact**
- <downtime? migratie? volgorde?>

[OPTIONEEL] **Backward compatibility**
- <wat blijft werken / welke clients worden beschermd?>

[OPTIONEEL] **Rollback plan**
- <hoe terugdraaien, wat gebeurt er met data?>

## 11. Open punten
- [ ] <open vraag / follow-up ticket>
```
