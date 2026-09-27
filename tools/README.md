# Production Tools

The tools directory is part of the Everdune production system.

## Active

- validate_repo.py — canonical ownership, asset-manifest and obsolete-path validation.

## Required next validators

- pixel asset validator
- sprite-sheet validator
- palette validator
- lore consistency checks
- save compatibility tests
- deterministic content tests
- web asset integrity checks

## Rule

A validator is more valuable when CI runs it automatically. New production rules should become executable checks where practical.
