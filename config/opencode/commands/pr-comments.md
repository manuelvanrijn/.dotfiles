---
description: Process PR comments
agent: build
temperature: 0.2
---

- Haal de comments op van de pull request op die nog **niet resolved** zijn
- Bepaal of we er iets mee moeten doen
- Analyzeer per punt het problem, suggestie en wat we mogelijk kunnen doen.
- Texten/vragen etc zijn in het Nederlands, code in het Engels

## QUESTION-TEMPLATE
<template>
{idx}: {SHORT TITLE OF COMMENT}

Comment: {INSERT AUTHOR AND COMMENT TEXT}

Context: {ADDITIONAL CONTEXT OF THE COMMENT}

Analysis: {ANALYSIS}
</template>

Gebruik de questiontool om zo elke comment door te nemen.
- Vraag maximaal 8 comments/questions tegelijk. Als er meer comments zijn, vraag je meerdere keren tot een maximum van 8 het aantal vragen totdat alle comments/questions zijn behandeld
1. Question Titel MOET de "#{IDX}" zijn
2. Question Description MOET het [QUESTION-TEMPLATE] hanteren. Plain tekst, GEEN markdown (zoals `**` of `## headers`.) WEL code zoals `foo`.
3. Question Options MOETEN: Uitvoeren, Negeren zijn. Voeg geen description hieraan toe. Geef de optie die Recommended is als eerst en voeg Recommended toe aan de optie text.

Zodra de antwoorden gegeven zijn zal je eerst:
1. Bepaal welke comments er parallel aan elkaar uitgevoerd kunnen worden
2. Voer parallel de comments uit met een maximum van 5 subagents. Zorg ervoor dat deze agents enkel gerichte testen voor het betreffende probleem draaien.
3. Als alle subagents/comments verwerkt zijn beoordeel je zelf of het handig is nog een @verifier te triggeren die alles onafhankelijk beoordeeld.
