# ValkyRiver: upgrademod
**upgrademod** is a [Balatro](https://store.steampowered.com/app/2379780/Balatro/) mod by ValkyRiver which allows every item in the Collection to be upgraded (except for decks, but there are 3 new decks)
This mod is now in version 5.2; version 5 introduced compatibility with the [Balatro Multiplayer](https://github.com/V-rtualized/BalatroMultiplayer) mod.

**If using Balatro Multiplayer, one must replace the file BalatroMultiplayer / Networking / Action_Handlers.lua with the version of the file in the upgrademod zip file**
(Pull request in progress)

**Compatible with: Debug-Plus, Brainstorm, Talisman, Balatro Multiplayer**
**Note: upgrademod is incompatible with most other mods, even some Quality-of-Life mods.**
upgrademod is quite different from most other mods — instead of adding new jokers or consumables etc. to the game, it alters (upgrades) every item in the vanilla game. There are lots of changes to the code, and because of that, it is probably not going to be compatible with many other mods (due to conflicting code changes), and even if it were, the items in the other mod wouldn’t be upgradeable at this moment.

### Current Progress:
• All Jokers have upgrades

• All consumables have upgrades

• All enhancements, editions, and seals have upgrades

• All vanilla booster packs have upgrades

• All Tags have upgrades

• All Vouchers have upgrades 

• Higher-level blinds have higher scoring requirements

• All bosses are affected by blind level (and Chicot / Luchador)

• There are 3 new decks: Level 2 Deck, Level 3 Deck, and Level 4 Deck

• A separate tab to view current upgrade levels

• All implemented items have modified descriptions

• Collection tabs have a "level select" UI

• There are 13 new "Upgrade" items, each of which upgrades one kind of item in the collection

• Within a run, one can pick up the "Choose an Upgrade" item, where one can choose between three different upgrade items (Note: If you have not used an upgrade in this Ante, then this item is guaranteed to appear on the shop before the Boss Blind).
Note: the third version changed the behavior of this item — it no longer appears in the booster pack slot, but it appears 3 times more frequently in the shop. The fourth version increased the number of options to 4.

• Custom music while in the "Choose an Upgrade" item (Music by ValkyRiver)

## Upgrade categories
In this mod, the items in the Collection are split into 14 categories:

• +Mult Jokers (Common upgrade)

• XMult Jokers (Uncommon upgrade)

• Chips Jokers (Common upgrade)

• Econ Jokers (Common upgrade)

• Effect Jokers (Uncommon upgrade)

• Tarot Cards (Common upgrade)

• Planet Cards (Common upgrade)

• Spectral Cards (Uncommon upgrade)

• Enhancements (Rare upgrade)

• Editions and Seals (Rare upgrade)

• Booster Packs (Rare upgrade)

• Tags (Uncommon upgrade)

• Vouchers (Rare upgrade)

• Blinds (Deck only)

The first 13 categories can be upgraded during a run by choosing an upgrade using the "Choose an Upgrade" item. Higher-level blinds can only be found by using the Level 2, Level 3, or Level 4 decks. Some items (mostly items with non-numerical effects) have a maximum effective level, where upgrading the item to anything higher doesn't make a difference. Other items can be scaled indefinitely by upgrading them.

## Known bugs

• Cerulean Bell doesn't function properly when exiting and reentering a run

• When used with Balatro Multiplayer, the context "context.first_hand_drawn" somehow fails to trigger, causing Certificate to not work properly. For a partial workaround, Certificate now triggers when a Blind is selected (like Burglar), but this causes 1 less card to be drawn to hand.

• For some reason, using upgrademod with Balatro Multiplayer and Talisman (some combination) can cause playing cards to give around X100 chips when played. I was unable to replicate the bug using the versions I used: 1.0.1o-FULL, 1.0.0\~ALPHA-1424a-STEAMODDED, 0.1.8.4-MULTIPLAYER, Talisman 2.2.0\~dev, and upgrademod 5.2 (latest)

## Potential compatibility issues (yet to be resolved)

• There is a lot of overwriting in this mod, mostly because Steamodded overwrites all of the files in the "functions" folder (so using lovely.toml doesn't work)
