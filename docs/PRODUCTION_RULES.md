# AI PRODUCTION RULES

1. Read the source of truth before editing.
2. Reuse existing systems before inventing new ones.
3. Prefer data-driven content over hardcoded content.
4. Keep assets semantically named and catalogued.
5. Never introduce contradictory lore.
6. Never replace canonical art with generic substitutes.
7. Keep single-player and multiplayer state concerns separate.
8. Every feature needs a reason to exist in the core player loop.
9. Every system must have a test or deterministic verification path where practical.
10. Preserve the ability to expand the world without rewriting the foundation.


11. Treat every knowingly temporary implementation as an explicit placeholder; register it in docs/PLACEHOLDER_REGISTRY.md and keep it visible until it passes Second-Eyes.
12. Never scale world/content to hide unresolved P0 vertical-slice quality gaps.

13. Treat main.gd as orchestration. New gameplay content belongs in canonical data Resources and systems.
14. Retire obsolete implementations instead of keeping parallel compatibility paths.
15. Runtime asset manifest drift is a CI failure.
16. Deterministic vertical-slice and save/migration checks are required before architecture changes are considered complete.
