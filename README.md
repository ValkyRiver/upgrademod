# ValkyRiver: upgrademod [WIP]
**upgrademod** is a [Balatro](https://store.steampowered.com/app/2379780/Balatro/) mod by ValkyRiver which allows every item in the Collection to be upgraded (except for decks, but there are 3 new decks)

This mod is currently only half-complete and is still a work-in-progress project.

Also, this mod has only be tested on 1.0.0~ALPHA-0813a-STEAMODDED.

### Current Progress:
• Most Jokers have upgrades

• Most Consumables have upgrades

• All enhancements, editions, and seals have upgrades

• All booster packs have upgrades

• Higher-level blinds have higher scoring requirements

• The Hook is affected by blind level

• There are 3 new decks: Level 2 Deck, Level 3 Deck, and Level 4 Deck

• All affected items (I think) have modified descriptions

### Yet to be completed:
• Jokers: Four Fingers, Splash, Pareidolia, Shortcut, Midas Mask, Luchador, Smeared Joker, Showman, Blueprint, Brainstorm, Astronomer, and Chicot

• Consumables: Familiar, Grim, Incantation

• Vouchers and Tags

• Blinds: all blinds except for The Hook

• Custom items used for upgrading elements from the game during a run

• Selecting levels for items in the Collection

## Upgrade categories
In this mod, the items in the Collection are split into 14 categories:

• +Mult Jokers

• XMult Jokers

• Chips Jokers

• Econ Jokers

• Effect Jokers

• Tarot Consumables

• Planet Consumables

• Spectral Consumables

• Enhancements

• Editions/Seals

• Booster Packs

• Tags

• Vouchers

• Blinds

After the addition of custom items is completed, the first 13 categories can be upgraded during a run. Higher-level blinds can only be found by using the Level 2, Level 3, or Level 4 decks. Some items (mostly items with non-numerical effects) have a maximum effective level, where upgrading the item to anything higher doesn't make a difference. Other items can be scaled indefinitely by upgrading them.

## Potential compatibility issues due to overwriting (yet to be resolved)

I had to overwrite the entirety of calculate_joker, since with simple hooking, either the ref or the original doesn't proc

I had to overwrite the entirety of generate_card_ui because Steamodded wouldn't let me use lovely to change a line in common_events.lua, and simple hooking caused it to never proc
