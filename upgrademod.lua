--- STEAMODDED HEADER
--- MOD_NAME: upgrademod
--- MOD_ID: upgrademod
--- MOD_AUTHOR: [ValkyRiver]
--- MOD_DESCRIPTION: upgrademod

----------------------------------------------
------------MOD CODE -------------------------

-- Current issues that may affect compatibility
-- I had to overwrite the entirety of calculate_joker, since with simple hooking, either the ref or the original doesn't proc
-- I had to overwrite the entirety of generate_card_ui because Steamodded wouldn't let me use lovely to change a line in common_events.lua, and simple hooking caused it to never proc
-- I had to overwrite a lot of functions to allow for the custom blind leveling

mult_level = 1 -- +Mult joker level
xmult_level = 1 -- XMult joker level
chips_level = 1 -- Chips joker level
econ_level = 1 -- Economy joker level
effect_level = 1 -- Effect and Retrigger joker level
tarot_level = 1 -- Tarot consumable level
planet_level = 1 -- Planet consumable level
spectral_level = 1 -- Spectral consumable level
enhance_level = 1 -- Enhancement level
edition_level = 1 -- Edition and Seal level
pack_level = 1 -- Booster pack level
tag_level = 1  -- Skip Tag level
voucher_level = 1 -- Voucher level

blind_level = 1 -- Blind level
blind_level_old = 1 -- Blind level to reset to after using Chicot or Luchador
out_of_blind = 1
luchadors_sold = 0

function blind_level_chicot_luchador(text)
  if text == nil then text = 'chicot check' end
  probability = 1
  blind_level = blind_level_old
  if text == "chicot sold" then blind_level = blind_level + effect_level end
  if text == "chicot created" then blind_level = blind_level - effect_level end
  for i = 1, #G.jokers.cards do
    if G.jokers.cards[i].ability.name == 'Chicot' then
      blind_level = blind_level - effect_level
    end
  end
  for j = 1, #G.jokers.cards do
    if G.jokers.cards[j].ability.name == 'Oops! All 6s' then
      probability = probability * (effect_level+1)
    end
  end
  blind_level = blind_level - luchadors_sold
  blind_desc(probability)
  print("("..text..") Current blind level: "..blind_level)
  if blind_level >= 0 then
    G.P_BLINDS.bl_wall.mult = 2*(blind_level+1)
    G.P_BLINDS.bl_final_vessel.mult = 2*((2*blind_level)+1)
  elseif blind_level <= -1 then
    G.P_BLINDS.bl_wall.mult = 2*(2^blind_level)
    G.P_BLINDS.bl_final_vessel.mult = 2*(3^blind_level)
  end
  G.localization.descriptions.Joker.j_chicot = {
    name = "Chicot",
    text = {
      "Reduces the level",
      "of every {C:attention}boss blind",
      "by {C:attention}"..effect_level.."{} levels",
      "{C:inactive}(Current blind level {C:attention}"..blind_level.."{C:inactive}){}"
    }
  }
  G.localization.descriptions.Joker.j_luchador = {
    name = "Luchador",
    text = {
      "Sell this card to reduce ",
      "the level of current",
      "{C:attention}boss blind{} by {C:attention}"..effect_level.."{} levels",
      "{C:inactive}(Current blind level {C:attention}"..blind_level.."{C:inactive}){}"
    }
  }
  init_localization()
end

function set_centers()
-- Unimplemented Jokers: 
-- Four Fingers, Splash, Pareidolia, Shortcut, Midas Mask, Luchador, Smeared Joker, Showman, Blueprint, Brainstorm, Astronomer, Chicot
-- Unimplemented Consumables:
-- Familiar, Grim, Incantation
-- Tags, Vouchers, Blinds are currently unimplemented

  -- MULT (complete)
  G.P_CENTERS.j_joker.config.mult = 4 + ((mult_level-1) * 2)
  G.P_CENTERS.j_greedy_joker.config.extra.s_mult = 3 + ((mult_level-1) * 1)
  G.P_CENTERS.j_lusty_joker.config.extra.s_mult = 3 + ((mult_level-1) * 1)
  G.P_CENTERS.j_wrathful_joker.config.extra.s_mult = 3 + ((mult_level-1) * 1)
  G.P_CENTERS.j_gluttenous_joker.config.extra.s_mult = 3 + ((mult_level-1) * 1)
  G.P_CENTERS.j_jolly.config.t_mult = 8 + ((mult_level-1) * 3)
  G.P_CENTERS.j_zany.config.t_mult = 12 + ((mult_level-1) * 3)
  G.P_CENTERS.j_mad.config.t_mult = 10 + ((mult_level-1) * 3)
  G.P_CENTERS.j_crazy.config.t_mult = 12 + ((mult_level-1) * 3)
  G.P_CENTERS.j_droll.config.t_mult = 10 + ((mult_level-1) * 3)
  G.P_CENTERS.j_half.config.extra.mult = 20 + ((mult_level-1) * 4)
  -- G.P_CENTERS.j_ceremonial: see lovely.toml
  G.P_CENTERS.j_mystic_summit.config.extra.mult = 15 + ((mult_level-1) * 3)
  G.P_CENTERS.j_misprint.config.extra.min = 0 + ((mult_level-1) * 3)
  G.P_CENTERS.j_misprint.config.extra.max = 23 + ((mult_level-1) * 3)
  G.P_CENTERS.j_fibonacci.config.extra = 8 + ((mult_level-1) * 2)
  G.P_CENTERS.j_abstract.config.extra = 3 + ((mult_level-1) * 1)
  G.P_CENTERS.j_gros_michel.config.extra.mult = 15 + ((mult_level-1) * 3)
  G.P_CENTERS.j_gros_michel.config.extra.odds = math.max(1, (6 - ((mult_level-1) * 1)))
  G.P_CENTERS.j_even_steven.config.extra = 4 + ((mult_level-1) * 1)
  -- G.P_CENTERS.j_supernova.config.extra: in lovely.toml
  G.P_CENTERS.j_ride_the_bus.config.extra = 1 + ((mult_level-1) * 1)
  G.P_CENTERS.j_green_joker.config.extra.hand_add = 1 + ((mult_level-1) * 1)
  G.P_CENTERS.j_red_card.config.extra = 3 + ((mult_level-1) * 2)
  G.P_CENTERS.j_erosion.config.extra = 4 + ((mult_level-1) * 1)
  G.P_CENTERS.j_fortune_teller.config.extra = 1 + ((mult_level-1) * 1)
  G.P_CENTERS.j_flash.config.extra = 2 + ((mult_level-1) * 1)
  G.P_CENTERS.j_popcorn.config.mult = 20 + ((mult_level-1) * 3)
  G.P_CENTERS.j_popcorn.config.extra = math.max(1, (4 - ((mult_level-1) * 1)))
  G.P_CENTERS.j_trousers.config.extra = 2 + ((mult_level-1) * 1)
  G.P_CENTERS.j_smiley.config.extra = 5 + ((mult_level-1) * 1)
  -- G.P_CENTERS.j_swashbuckler: see lovely.toml
  G.P_CENTERS.j_onyx_agate.config.extra = 7 + ((mult_level-1) * 2)
  G.P_CENTERS.j_shoot_the_moon.config.extra = 13 + ((mult_level-1) * 2)
  -- G.P_CENTERS.j_shoot_the_moon: see lovely.toml
  G.P_CENTERS.j_bootstraps.config.extra.mult = 2 + ((mult_level-1) * 1)
  G.P_CENTERS.j_scholar.config.extra.mult = 4 + ((mult_level-1) * 1)
  G.P_CENTERS.j_walkie_talkie.config.extra.mult = 4 + ((mult_level-1) * 1)
  G.P_CENTERS.j_scholar.config.extra.chips = 20 + ((mult_level-1) * 10)
  G.P_CENTERS.j_walkie_talkie.config.extra.chips = 10 + ((mult_level-1) * 15)
  -- G.P_CENTERS.j_raised_fist: see lovely.toml

  -- XMULT (complete)
  G.P_CENTERS.j_stencil.config.extra = 1 + ((xmult_level-1) * 0.25)
  -- G.P_CENTERS.j_stencil: see lovely.toml
  G.P_CENTERS.j_loyalty_card.config.extra.Xmult = 4 + ((xmult_level-1) * 0.25)
  G.P_CENTERS.j_loyalty_card.config.extra.every = math.max(1, (5 - ((xmult_level-1) * 1)))
  G.P_CENTERS.j_steel_joker.config.extra = 0.2 + ((xmult_level-1) * 0.05)
  G.P_CENTERS.j_blackboard.config.extra = 3 + ((xmult_level-1) * 0.25)
  G.P_CENTERS.j_constellation.config.extra = 0.1 + ((xmult_level-1) * 0.05)
  G.P_CENTERS.j_cavendish.config.extra.Xmult = 3 + ((xmult_level-1) * 0.15)
  G.P_CENTERS.j_cavendish.config.extra.odds = 1000 + ((xmult_level-1) * 500)
  G.P_CENTERS.j_card_sharp.config.extra.Xmult = 3 + ((xmult_level-1) * 0.25)
  G.P_CENTERS.j_madness.config.extra = 0.5 + ((xmult_level-1) * 0.25)
  G.P_CENTERS.j_vampire.config.extra = 0.1 + ((xmult_level-1) * 0.05)
  G.P_CENTERS.j_hologram.config.extra = 0.1 + ((xmult_level-1) * 0.05)
  G.P_CENTERS.j_baron.config.extra = 1.5 + ((xmult_level-1) * 0.1)
  G.P_CENTERS.j_obelisk.config.extra = 0.2 + ((xmult_level-1) * 0.1)
  G.P_CENTERS.j_photograph.config.extra = 2 + ((xmult_level-1) * 0.1)
  G.P_CENTERS.j_lucky_cat.config.extra = 0.25 + ((xmult_level-1) * 0.05)
  G.P_CENTERS.j_baseball.config.extra = 1.5 + ((xmult_level-1) * 0.2)
  G.P_CENTERS.j_ancient.config.extra = 1.5 + ((xmult_level-1) * 0.15)
  G.P_CENTERS.j_ramen.config.Xmult = 2 + ((xmult_level-1) * 0.2)
  G.P_CENTERS.j_ramen.config.extra = math.max(0.001, (0.01 - ((xmult_level-1) * 0.003)))
  G.P_CENTERS.j_campfire.config.extra = 0.25 + ((xmult_level-1) * 0.1)
  G.P_CENTERS.j_acrobat.config.extra = 3 + ((xmult_level-1) * 0.25)
  G.P_CENTERS.j_throwback.config.extra = 0.25 + ((xmult_level-1) * 0.1)
  G.P_CENTERS.j_bloodstone.config.extra.Xmult = 1.5 + ((xmult_level-1) * 0.15)
  G.P_CENTERS.j_bloodstone.config.extra.odds = math.max(1, (2 - ((xmult_level-1) * 0.25)))
  G.P_CENTERS.j_glass.config.extra = 0.75 + ((xmult_level-1) * 0.15)
  G.P_CENTERS.j_flower_pot.config.extra = 3 + ((xmult_level-1) * 0.25)
  G.P_CENTERS.j_idol.config.extra = 2 + ((xmult_level-1) * 0.1)
  G.P_CENTERS.j_seeing_double.config.extra = 2 + ((xmult_level-1) * 0.25)
  G.P_CENTERS.j_hit_the_road.config.extra = 0.5 + ((xmult_level-1) * 0.15)
  G.P_CENTERS.j_duo.config.Xmult = 2 + ((xmult_level-1) * 0.25)
  G.P_CENTERS.j_trio.config.Xmult = 3 + ((xmult_level-1) * 0.25)
  G.P_CENTERS.j_family.config.Xmult = 4 + ((xmult_level-1) * 0.25)
  G.P_CENTERS.j_order.config.Xmult = 3 + ((xmult_level-1) * 0.25)
  G.P_CENTERS.j_tribe.config.Xmult = 2 + ((xmult_level-1) * 0.25)
  G.P_CENTERS.j_drivers_license.config.extra = 3 + ((xmult_level-1) * 0.25)
  G.P_CENTERS.j_caino.config.extra = 1 + ((xmult_level-1) * 0.5)
  G.P_CENTERS.j_triboulet.config.extra = 2 + ((xmult_level-1) * 0.25)
  G.P_CENTERS.j_yorick.config.extra.xmult = 1 + ((xmult_level-1) * 0.25)
  G.P_CENTERS.j_yorick.config.extra.discards = math.max(1, (23 - ((xmult_level-1) * 2)))

  -- CHIPS (complete)
  G.P_CENTERS.j_sly.config.t_chips = 50 + ((chips_level-1) * 20)
  G.P_CENTERS.j_wily.config.t_chips = 100 + ((chips_level-1) * 20)
  G.P_CENTERS.j_clever.config.t_chips = 80 + ((chips_level-1) * 20)
  G.P_CENTERS.j_devious.config.t_chips = 100 + ((chips_level-1) * 20)
  G.P_CENTERS.j_crafty.config.t_chips = 80 + ((chips_level-1) * 20)
  G.P_CENTERS.j_banner.config.extra = 30 + ((chips_level-1) * 10)
  G.P_CENTERS.j_scary_face.config.extra = 30 + ((chips_level-1) * 10)
  G.P_CENTERS.j_odd_todd.config.extra = 31 + ((chips_level-1) * 10)
  G.P_CENTERS.j_runner.config.extra.chip_mod = 15 + ((chips_level-1) * 10)
  G.P_CENTERS.j_ice_cream.config.extra.chips = 100 + ((chips_level-1) * 20)
  G.P_CENTERS.j_ice_cream.config.extra.chip_mod = math.max(1, (5 - ((chips_level-1) * 1)))
  G.P_CENTERS.j_blue_joker.config.extra = 2 + ((chips_level-1) * 1)
  G.P_CENTERS.j_hiker.config.extra = 5 + ((chips_level-1) * 2)
  G.P_CENTERS.j_square.config.extra.chip_mod = 4 + ((chips_level-1) * 3)
  G.P_CENTERS.j_stone.config.extra = 25 + ((chips_level-1) * 5)
  G.P_CENTERS.j_bull.config.extra = 2 + ((chips_level-1) * 1)
  G.P_CENTERS.j_castle.config.extra.chip_mod = 3 + ((chips_level-1) * 2)
  G.P_CENTERS.j_arrowhead.config.extra = 50 + ((chips_level-1) * 15)
  G.P_CENTERS.j_wee.config.extra.chip_mod = 8 + ((chips_level-1) * 4)
  G.P_CENTERS.j_stuntman.config.extra.chip_mod = 250 + ((chips_level-1) * 35)
  G.P_CENTERS.j_stuntman.config.extra.h_size = math.max(0, (2 - ((chips_level-1) * 1)))

-- ECON (complete)
  G.P_CENTERS.j_credit_card.config.extra = 20 + ((econ_level-1) * 10)
  G.P_CENTERS.j_delayed_grat.config.extra = 2 + ((econ_level-1) * 1)
  -- DONE G.P_CENTERS.j_business: see lovely.toml 
  G.P_CENTERS.j_business.config.extra = 2 - math.max(((econ_level-1) * 0.25))
  G.P_CENTERS.j_egg.config.extra = 3 + ((econ_level-1) * 2)
  G.P_CENTERS.j_faceless.config.extra.dollars = 5 + ((econ_level-1) * 3)
  G.P_CENTERS.j_todo_list.config.extra.dollars = 4 + ((econ_level-1) * 2)
  G.P_CENTERS.j_cloud_9.config.extra = 1 + ((econ_level-1) * 1)
  G.P_CENTERS.j_rocket.config.extra.increase = 2 + ((econ_level-1) * 1)
  G.P_CENTERS.j_gift.config.extra = 1 + ((econ_level-1) * 1)
  G.P_CENTERS.j_reserved_parking.config.extra.dollars = 1 + ((econ_level-1) * 1)
  G.P_CENTERS.j_reserved_parking.config.extra.odds = math.max(1, (2 - (econ_level-1) * 0.25))
  G.P_CENTERS.j_mail.config.extra = 5 + ((econ_level-1) * 1)
  G.P_CENTERS.j_to_the_moon.config.extra = 1 + ((econ_level-1) * 1)
  G.P_CENTERS.j_golden.config.extra = 4 + ((econ_level-1) * 2)
  G.P_CENTERS.j_trading.config.extra = 3 + ((econ_level-1) * 2)
  -- G.P_CENTERS.j_trading: see below (hooked); also see lovely.toml
  G.P_CENTERS.j_ticket.config.extra = 4 + ((econ_level-1) * 1)
  G.P_CENTERS.j_rough_gem.config.extra = 1 + ((econ_level-1) * 1)
  G.P_CENTERS.j_matador.config.extra = 8 + ((econ_level-1) * 4)
  G.P_CENTERS.j_satellite.config.extra = 1 + ((econ_level-1) * 1)

-- EFFECT (incomplete: Four Fingers, Marble Joker, Pareidolia, Shortcut, Midas Mask, Luchador, Smeared Joker, Showman, Blueprint, Brainstorm, Astronomer, and Chicot)
  G.P_CENTERS.j_mime.config.extra = 1 + ((effect_level-1) * 1) 
  G.P_CENTERS.j_dusk.config.extra = 1 + ((effect_level-1) * 1)
  G.P_CENTERS.j_hack.config.extra = 1 + ((effect_level-1) * 1)
  G.P_CENTERS.j_selzer.config.extra = 10 + ((effect_level-1) * 5)
  G.P_CENTERS.j_sock_and_buskin.config.extra = 1 + ((effect_level-1) * 1)
  G.P_CENTERS.j_hanging_chad.config.extra = 2 + ((effect_level-1) * 1)
  -- G.P.CENTERS.j_four_fingers: UNDECIDED
  -- G.P_CENTERS.j_marble: UNIMPLEMENTED
  G.P_CENTERS.j_8_ball.config.extra = math.max(1, (4 - ((effect_level-1) * 1)))
  -- G.P.CENTERS.j_8_ball: see lovely.toml
  -- G.P_CENTERS.j_chaos: see lovely.toml
  G.P_CENTERS.j_chaos.config.extra = 1 + ((effect_level-1) * 1)
  G.P_CENTERS.j_space.config.extra = math.max(1, (4 - ((effect_level-1) * 1)))
  G.P_CENTERS.j_burglar.config.extra = 3 + ((effect_level-1) * 1)
  -- G.P.CENTERS.j_dna: see below (hooked); also see lovely.toml
  -- G.P.CENTERS.j_splash: see below (hooked)
  -- G.P.CENTERS.j_pareidolia: UNDECIDED
  -- G.P.CENTERS.j_sixth_sense: see lovely.toml
  -- G.P.CENTERS.j_superposition: see lovely.toml
  -- G.P.CENTERS.j_seance: see lovely.toml
  G.P_CENTERS.j_riff_raff.config.extra = 2 + ((effect_level-1) * 1)
  -- G.P.CENTERS.j_shortcut: UNDECIDED
  G.P_CENTERS.j_vagabond.config.extra = 4 + ((effect_level-1) * 3)
  -- G.P.CENTERS.j_vagabond: see lovely.toml
  -- G.P.CENTERS.j_midas_mask: UNDECIDED
  -- G.P.CENTERS.j_luchador: reverses boss blind, like double / triple / quad Chicot [to be done after blind levels are introduced]
  G.P_CENTERS.j_turtle_bean.config.extra.h_size = 5 + ((effect_level-1) * 1)
  G.P_CENTERS.j_hallucination.config.extra = math.max(1, (2 - ((effect_level-1) * 0.25)))
  -- G.P.CENTERS.j_hallucination: see lovely.toml
  G.P_CENTERS.j_juggler.config.h_size = 1 + ((effect_level-1) * 1)
  G.P_CENTERS.j_drunkard.config.d_size = 1 + ((effect_level-1) * 1)
  -- G.P.CENTERS.j_diet_cola: see lovely.toml
  -- G.P.CENTERS.j_mr_bones: see lovely.toml
  G.P_CENTERS.j_troubadour.config.extra.h_size = 2 + ((effect_level-1) * 1)
  -- G.P.CENTERS.j_certificate: see below (hooked)
  -- G.P.CENTERS.j_smeared: UNDECIDED
  -- G.P.CENTERS.j_showman: UNDECIDED
  -- G.P.CENTERS.j_blueprint: copy joker to the right 2 / 3 / 4 times
  G.P_CENTERS.j_merry_andy.config.d_size = 3 + ((effect_level-1) * 1)
  -- G.P.CENTERS.j_oops: see lovely.toml
  G.P_CENTERS.j_invisible.config.extra = math.max(0, (2 - ((effect_level-1) * 1)))
  -- G.P.CENTERS.j_invisible: see lovely.toml
  -- G.P.CENTERS.j_brainstorm: copy leftmost joker 2 / 3 / 4 times
  -- G.P.CENTERS.j_cartomancer: see lovely.toml
  -- G.P.CENTERS.j_astronomer: UNDECIDED
  -- G.P.CENTERS.j_burnt: see lovely.toml
  -- G.P.CENTERS.j_chicot: reverses boss blind, like double / triple / quad Chicot [to be done after blind levels are introduced]
  -- G.P.CENTERS.j_perkeo: see below (hooked)

-- TAROTS (complete)
  -- G.P.CENTERS.c_fool: see below (hooked)
  G.P_CENTERS.c_magician.config.max_highlighted = math.min(5, 2 + ((tarot_level-1) * 1))
  G.P_CENTERS.c_high_priestess.config.planets = 2 + ((tarot_level-1) * 1)
  G.P_CENTERS.c_empress.config.max_highlighted = math.min(5, 2 + ((tarot_level-1) * 1))
  G.P_CENTERS.c_emperor.config.tarots = 2 + ((tarot_level-1) * 1)
  G.P_CENTERS.c_heirophant.config.max_highlighted = 2 + ((tarot_level-1) * 1)
  G.P_CENTERS.c_lovers.config.max_highlighted = math.min(5, 1 + ((tarot_level-1) * 1))
  G.P_CENTERS.c_chariot.config.max_highlighted = math.min(5, 1 + ((tarot_level-1) * 1))
  G.P_CENTERS.c_justice.config.max_highlighted = math.min(5, 1 + ((tarot_level-1) * 1))
  G.P_CENTERS.c_hermit.config.extra = 20 + ((tarot_level-1) * 10)
  -- G.P_CENTERS.c_hermit: see lovely.toml
  G.P_CENTERS.c_wheel_of_fortune.config.extra = math.max(1, (4 - ((tarot_level-1) * 1)))
  G.P_CENTERS.c_strength.config.max_highlighted = math.min(5, 2 + ((tarot_level-1) * 1))
  G.P_CENTERS.c_hanged_man.config.max_highlighted = math.min(5, 2 + ((tarot_level-1) * 1))
  G.P_CENTERS.c_death.config.max_highlighted = math.min(5, 2 + ((tarot_level-1) * 1))
  G.P_CENTERS.c_temperance.config.extra = 50 + ((tarot_level-1) * 20)
  -- G.P_CENTERS.c_temperance: see lovely.toml
  G.P_CENTERS.c_devil.config.max_highlighted = math.min(5, 1 + ((tarot_level-1) * 1))
  G.P_CENTERS.c_tower.config.max_highlighted = math.min(5, 1 + ((tarot_level-1) * 1))
  G.P_CENTERS.c_star.config.max_highlighted = math.min(5, 3 + ((tarot_level-1) * 1))
  G.P_CENTERS.c_moon.config.max_highlighted = math.min(5, 3 + ((tarot_level-1) * 1))
  G.P_CENTERS.c_sun.config.max_highlighted = math.min(5, 3 + ((tarot_level-1) * 1))
  -- G.P_CENTERS.c_judgement: see below (hooked)
  G.P_CENTERS.c_world.config.max_highlighted = math.min(5, 3 + ((tarot_level-1) * 1))

-- PLANETS (complete)
-- in lovely.toml

-- SPECTRALS (incomplete: Familiar, Grim, Incantation)
  -- G.P_CENTERS.familiar: UNDECIDED
  -- G.P_CENTERS.grim: UNDECIDED
  -- G.P_CENTERS.incantation: UNDECIDED
  G.P_CENTERS.c_talisman.config.max_highlighted = math.min(5, 1 + ((spectral_level-1) * 1))
  -- G.P_CENTERS.aura: see lovely.toml
  -- G.P_CENTERS.wraith: see lovely.toml
  -- G.P_CENTERS.sigil: see below (hooked) 
  -- G.P_CENTERS.ouija: see below (hooked) 
  -- G.P_CENTERS.ectoplasm: see lovely.toml
  -- G.P_CENTERS.immolate: see below (hooked)
  -- G.P_CENTERS.ankh: see lovely.toml
  G.P_CENTERS.c_deja_vu.config.max_highlighted = math.min(5, 1 + ((spectral_level-1) * 1))
  -- G.P_CENTERS.hex: see lovely.toml
  G.P_CENTERS.c_trance.config.max_highlighted = math.min(5, 1 + ((spectral_level-1) * 1))
  G.P_CENTERS.c_medium.config.max_highlighted = math.min(5, 1 + ((spectral_level-1) * 1))
  -- G.P_CENTERS.c_cryptid: see lovely.toml
  -- G.P_CENTERS.soul: see below (hooked)
  -- G.P_CENTERS.black_hole: see lovely.toml

-- ENHANCEMENTS (complete)
  G.P_CENTERS.m_bonus.config.bonus = 30 + ((enhance_level-1) * 15)
  G.P_CENTERS.m_mult.config.mult = 4 + ((enhance_level-1) * 2)
  -- G.P_CENTERS.m_wild: see lovely.toml
  G.P_CENTERS.m_glass.config.Xmult = 2 + ((enhance_level-1) * 0.25)
  G.P_CENTERS.m_glass.config.extra = 4 + ((enhance_level-1) * 2)
  G.P_CENTERS.m_steel.config.h_x_mult = 1.5 + ((enhance_level-1) * 0.25)
  G.P_CENTERS.m_stone.config.bonus = 50 + ((enhance_level-1) * 25)
  G.P_CENTERS.m_gold.config.h_dollars = 3 + ((enhance_level-1) * 2)
  G.P_CENTERS.m_lucky.config.mult = 20 + ((enhance_level-1) * 4)
  G.P_CENTERS.m_lucky.config.p_dollars = 20 + ((enhance_level-1) * 5)
  -- G.P_CENTERS.m_lucky: see lovely.toml

-- EDITIONS (complete)
  G.P_CENTERS.e_foil.config.extra = 50 + ((edition_level-1) * 30)
  G.P_CENTERS.e_holo.config.extra = 10 + ((edition_level-1) * 4)
  G.P_CENTERS.e_polychrome.config.extra = 1.5 + ((edition_level-1) * 0.25)
  G.P_CENTERS.e_negative.config.extra = 1 + ((edition_level-1) * 1)

-- SEALS (complete)
-- all in lovely.toml

-- PACKS (vanilla packs complete)
  G.P_CENTERS.p_arcana_normal_1.config.extra = math.floor(3+(2/3) + ((pack_level-1) * (2/3)))
  G.P_CENTERS.p_arcana_normal_1.config.choose = math.floor(1 + ((pack_level-1) * (1/3)))
  G.P_CENTERS.p_arcana_normal_2.config.extra = math.floor(3+(2/3) + ((pack_level-1) * (2/3)))
  G.P_CENTERS.p_arcana_normal_2.config.choose = math.floor(1 + ((pack_level-1) * (1/3)))
  G.P_CENTERS.p_arcana_normal_3.config.extra = math.floor(3+(2/3) + ((pack_level-1) * (2/3)))
  G.P_CENTERS.p_arcana_normal_3.config.choose = math.floor(1 + ((pack_level-1) * (1/3)))
  G.P_CENTERS.p_arcana_normal_4.config.extra = math.floor(3+(2/3) + ((pack_level-1) * (2/3)))
  G.P_CENTERS.p_arcana_normal_4.config.choose = math.floor(1 + ((pack_level-1) * (1/3)))
  G.P_CENTERS.p_arcana_jumbo_1.config.extra = math.floor(5 + ((pack_level-1) * (2/3)))
  G.P_CENTERS.p_arcana_jumbo_1.config.choose = math.floor(1+(2/3) + ((pack_level-1) * (1/3)))
  G.P_CENTERS.p_arcana_jumbo_2.config.extra = math.floor(5 + ((pack_level-1) * (2/3)))
  G.P_CENTERS.p_arcana_jumbo_2.config.choose = math.floor(1+(2/3) + ((pack_level-1) * (1/3)))
  G.P_CENTERS.p_arcana_mega_1.config.extra = math.floor(5+(2/3) + ((pack_level-1) * (2/3)))
  G.P_CENTERS.p_arcana_mega_1.config.choose = math.floor(2 + ((pack_level-1) * (1/3)))
  G.P_CENTERS.p_arcana_mega_2.config.extra = math.floor(5+(2/3) + ((pack_level-1) * (2/3)))
  G.P_CENTERS.p_arcana_mega_2.config.choose = math.floor(2 + ((pack_level-1) * (1/3)))
  G.P_CENTERS.p_celestial_normal_1.config.extra = math.floor(3+(2/3) + ((pack_level-1) * (2/3)))
  G.P_CENTERS.p_celestial_normal_1.config.choose = math.floor(1 + ((pack_level-1) * (1/3)))
  G.P_CENTERS.p_celestial_normal_2.config.extra = math.floor(3+(2/3) + ((pack_level-1) * (2/3)))
  G.P_CENTERS.p_celestial_normal_2.config.choose = math.floor(1 + ((pack_level-1) * (1/3)))
  G.P_CENTERS.p_celestial_normal_3.config.extra = math.floor(3+(2/3) + ((pack_level-1) * (2/3)))
  G.P_CENTERS.p_celestial_normal_3.config.choose = math.floor(1 + ((pack_level-1) * (1/3)))
  G.P_CENTERS.p_celestial_normal_4.config.extra = math.floor(3+(2/3) + ((pack_level-1) * (2/3)))
  G.P_CENTERS.p_celestial_normal_4.config.choose = math.floor(1 + ((pack_level-1) * (1/3)))
  G.P_CENTERS.p_celestial_jumbo_1.config.extra = math.floor(5 + ((pack_level-1) * (2/3)))
  G.P_CENTERS.p_celestial_jumbo_1.config.choose = math.floor(1+(2/3) + ((pack_level-1) * (1/3)))
  G.P_CENTERS.p_celestial_jumbo_2.config.extra = math.floor(5 + ((pack_level-1) * (2/3)))
  G.P_CENTERS.p_celestial_jumbo_2.config.choose = math.floor(1+(2/3) + ((pack_level-1) * (1/3)))
  G.P_CENTERS.p_celestial_mega_1.config.extra = math.floor(5+(2/3) + ((pack_level-1) * (2/3)))
  G.P_CENTERS.p_celestial_mega_1.config.choose = math.floor(2 + ((pack_level-1) * (1/3)))
  G.P_CENTERS.p_celestial_mega_2.config.extra = math.floor(5+(2/3) + ((pack_level-1) * (2/3)))
  G.P_CENTERS.p_celestial_mega_2.config.choose = math.floor(2 + ((pack_level-1) * (1/3)))
  G.P_CENTERS.p_standard_normal_1.config.extra = math.floor(3+(2/3) + ((pack_level-1) * (2/3)))
  G.P_CENTERS.p_standard_normal_1.config.choose = math.floor(1 + ((pack_level-1) * (1/3)))
  G.P_CENTERS.p_standard_normal_2.config.extra = math.floor(3+(2/3) + ((pack_level-1) * (2/3)))
  G.P_CENTERS.p_standard_normal_2.config.choose = math.floor(1 + ((pack_level-1) * (1/3)))
  G.P_CENTERS.p_standard_normal_3.config.extra = math.floor(3+(2/3) + ((pack_level-1) * (2/3)))
  G.P_CENTERS.p_standard_normal_3.config.choose = math.floor(1 + ((pack_level-1) * (1/3)))
  G.P_CENTERS.p_standard_normal_4.config.extra = math.floor(3+(2/3) + ((pack_level-1) * (2/3)))
  G.P_CENTERS.p_standard_normal_4.config.choose = math.floor(1 + ((pack_level-1) * (1/3)))
  G.P_CENTERS.p_standard_jumbo_1.config.extra = math.floor(5 + ((pack_level-1) * (2/3)))
  G.P_CENTERS.p_standard_jumbo_1.config.choose = math.floor(1+(2/3) + ((pack_level-1) * (1/3)))
  G.P_CENTERS.p_standard_jumbo_2.config.extra = math.floor(5 + ((pack_level-1) * (2/3)))
  G.P_CENTERS.p_standard_jumbo_2.config.choose = math.floor(1+(2/3) + ((pack_level-1) * (1/3)))
  G.P_CENTERS.p_standard_mega_1.config.extra = math.floor(5+(2/3) + ((pack_level-1) * (2/3)))
  G.P_CENTERS.p_standard_mega_1.config.choose = math.floor(2 + ((pack_level-1) * (1/3)))
  G.P_CENTERS.p_standard_mega_2.config.extra = math.floor(5+(2/3) + ((pack_level-1) * (2/3)))
  G.P_CENTERS.p_standard_mega_2.config.choose = math.floor(2 + ((pack_level-1) * (1/3)))
  G.P_CENTERS.p_buffoon_normal_1.config.extra = math.floor(2+(2/3) + ((pack_level-1) * (2/3)))
  G.P_CENTERS.p_buffoon_normal_1.config.choose = math.floor(1 + ((pack_level-1) * (1/3)))
  G.P_CENTERS.p_buffoon_normal_2.config.extra = math.floor(2+(2/3) + ((pack_level-1) * (2/3)))
  G.P_CENTERS.p_buffoon_normal_2.config.choose = math.floor(1 + ((pack_level-1) * (1/3)))
  G.P_CENTERS.p_buffoon_jumbo_1.config.extra = math.floor(4 + ((pack_level-1) * (2/3)))
  G.P_CENTERS.p_buffoon_jumbo_1.config.choose = math.floor(1+(2/3) + ((pack_level-1) * (1/3)))
  G.P_CENTERS.p_buffoon_mega_1.config.extra = math.floor(4+(2/3) + ((pack_level-1) * (2/3)))
  G.P_CENTERS.p_buffoon_mega_1.config.choose = math.floor(2 + ((pack_level-1) * (1/3)))
  G.P_CENTERS.p_spectral_normal_1.config.extra = math.floor(2+(2/3) + ((pack_level-1) * (2/3)))
  G.P_CENTERS.p_spectral_normal_1.config.choose = math.floor(1 + ((pack_level-1) * (1/3)))
  G.P_CENTERS.p_spectral_normal_2.config.extra = math.floor(2+(2/3) + ((pack_level-1) * (2/3)))
  G.P_CENTERS.p_spectral_normal_2.config.choose = math.floor(1 + ((pack_level-1) * (1/3)))
  G.P_CENTERS.p_spectral_jumbo_1.config.extra = math.floor(4 + ((pack_level-1) * (2/3)))
  G.P_CENTERS.p_spectral_jumbo_1.config.choose = math.floor(1+(2/3) + ((pack_level-1) * (1/3)))
  G.P_CENTERS.p_spectral_mega_1.config.extra = math.floor(4+(2/3) + ((pack_level-1) * (2/3)))
  G.P_CENTERS.p_spectral_mega_1.config.choose = math.floor(2 + ((pack_level-1) * (1/3)))

-- TAGS (none have been done yet)

-- VOUCHERS (none have been done yet)

-- BLINDS

-- Wall and Violet Vessel
  if blind_level >= 0 then
    G.P_BLINDS.bl_wall.mult = 2*(blind_level+1)
    G.P_BLINDS.bl_final_vessel.mult = 2*((2*blind_level)+1)
  elseif blind_level <= -1 then
    G.P_BLINDS.bl_wall.mult = 2*(2^blind_level)
    G.P_BLINDS.bl_final_vessel.mult = 2*(3^blind_level)
  end

-- Others: see lovely.toml

  desc()
end


-- Change levels
function set_levels(mult, xmult, chips, econ, effect, tarot, planet, spectral, enhance, edition, pack, tag, voucher, blind)
  mult_level = mult
  xmult_level = xmult
  chips_level = chips
  econ_level = econ
  effect_level = effect
  tarot_level = tarot
  planet_level = planet
  spectral_level = spectral
  enhance_level = enhance
  edition_level = edition
  pack_level = pack
  tag_level = tag
  voucher_level = voucher
  blind_level = blind
  set_centers()
end

function upgrade(category, amount)
  if category == "mult" then
    mult_level = mult_level + amount
  elseif category == "xmult" then
    xmult_level = xmult_level + amount
  elseif category == "chips" then
    chips_level = chips_level + amount
  elseif category == "econ" then
    econ_level = econ_level + amount
  elseif category == "effect" then
    effect_level = effect_level + amount
  elseif category == "tarot" then
    tarot_level = tarot_level + amount
  elseif category == "planet" then
    planet_level = planet_level + amount
  elseif category == "spectral" then
    spectral_level = spectral_level + amount
  elseif category == "enhance" then
    enhance_level = enhance_level + amount
  elseif category == "edition" then
    edition_level = edition + amount
  elseif category == "pack" then
    pack_level = pack_level + amount
  elseif category == "tag" then
    tag_level = tag_level + amount
  elseif category == "voucher" then
    voucher_level = voucher_level + amount
  elseif category == "blind" then
    blind_level = blind_level + amount
  end
  set_centers()
end

-- Overwriting the function "set_consumeable_usage" due to The Fool
function set_consumeable_usage(card)
  if card.config.center_key and card.ability.consumeable then
    if G.PROFILES[G.SETTINGS.profile].consumeable_usage[card.config.center_key] then
      G.PROFILES[G.SETTINGS.profile].consumeable_usage[card.config.center_key].count = G.PROFILES[G.SETTINGS.profile].consumeable_usage[card.config.center_key].count + 1
    else
      G.PROFILES[G.SETTINGS.profile].consumeable_usage[card.config.center_key] = {count = 1, order = card.config.center.order}
    end
    if G.GAME.consumeable_usage[card.config.center_key] then
      G.GAME.consumeable_usage[card.config.center_key].count = G.GAME.consumeable_usage[card.config.center_key].count + 1
    else
      G.GAME.consumeable_usage[card.config.center_key] = {count = 1, order = card.config.center.order, set = card.ability.set}
    end
    G.GAME.consumeable_usage_total = G.GAME.consumeable_usage_total or {tarot = 0, planet = 0, spectral = 0, tarot_planet = 0, all = 0}
    if card.config.center.set == 'Tarot' then
      G.GAME.consumeable_usage_total.tarot = G.GAME.consumeable_usage_total.tarot + 1  
      G.GAME.consumeable_usage_total.tarot_planet = G.GAME.consumeable_usage_total.tarot_planet + 1
    elseif card.config.center.set == 'Planet' then
      G.GAME.consumeable_usage_total.planet = G.GAME.consumeable_usage_total.planet + 1
      G.GAME.consumeable_usage_total.tarot_planet = G.GAME.consumeable_usage_total.tarot_planet + 1
    elseif card.config.center.set == 'Spectral' then  G.GAME.consumeable_usage_total.spectral = G.GAME.consumeable_usage_total.spectral + 1
    end
    G.GAME.consumeable_usage_total.all = G.GAME.consumeable_usage_total.all + 1
    if not card.config.center.discovered then
      discover_card(card)
    end
    if ((card.config.center.set == 'Tarot' or card.config.center.set == 'Planet') and tarot_level == 1) or ((card.config.center.set == 'Tarot' or card.config.center.set == 'Planet' or card.config.center.set == 'Spectral') and tarot_level >= 2) then 
      G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
          G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
              G.GAME.last_tarot_planet = card.config.center_key
              return true
            end
          }))
          return true
        end
      }))
    end
  end
  G:save_settings()
end

-- Hooking for consumables (those that can't be set just by changing G.P_CENTERS or using lovely.toml), including Judgement, The Soul, Sigil, Ouija, Immolate, Talisman,
-- Deja Vu, Trance, Medium
local card_use_consumeable_ref = Card.use_consumeable
function Card.use_consumeable(self, area, copier)
  stop_use()
  if not copier then set_consumeable_usage(self) end
  if self.debuff then return nil end
  local used_tarot = copier or self
  if self.ability.consumeable.max_highlighted then
      update_hand_text({immediate = true, nopulse = true, delay = 0}, {mult = 0, chips = 0, level = '', handname = ''})
  end
  local obj = self.config.center
  if obj.use and type(obj.use) == 'function' then
    obj:use(self, area, copier)
    return
  end
  if self.ability.name == 'Judgement' or self.ability.name == 'The Soul' then -- Judgement and The Soul
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
      play_sound('timpani')
      if self.ability.name == 'Judgement' then
        for i = 1, tarot_level, 1 do
          if #G.jokers.cards < G.jokers.config.card_limit then
            local card = create_card('Joker', G.jokers, self.ability.name == 'The Soul', nil, nil, nil, nil, self.ability.name == 'Judgement' and 'jud' or 'sou')
            card:add_to_deck()
            G.jokers:emplace(card)
            delay(0.8)
          end
        end
      end
      if self.ability.name == 'The Soul' then
        local card = create_card('Joker', G.jokers, self.ability.name == 'The Soul', nil, nil, nil, nil, self.ability.name == 'Judgement' and 'jud' or 'sou')
        if spectral_level >= 2 then
          card:set_edition({negative = true}, true)
        end
        card:add_to_deck()
        G.jokers:emplace(card)
      end
      if self.ability.name == 'The Soul' then check_for_unlock{type = 'spawn_legendary'} end
      used_tarot:juice_up(0.3, 0.5)
    return true end }))
    delay(0.6)
  elseif (self.ability.name == 'Sigil' and spectral_level >= 2) or (self.ability.name == 'Ouija' and spectral_level >= 3) then -- Sigil and Ouija
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
      play_sound('tarot1')
      used_tarot:juice_up(0.3, 0.5)
      return true end }))
    for i=1, #G.hand.cards do
      local percent = 1.15 - (i-0.999)/(#G.hand.cards-0.998)*0.3
      G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.cards[i]:flip();play_sound('card1', percent);G.hand.cards[i]:juice_up(0.3, 0.3);return true end }))
    end
    delay(0.2)
    if self.ability.name == 'Sigil' then -- Sigil
      local _suit = string.sub(G.hand.highlighted[1].base.suit, 1, 1)
      for i=1, #G.hand.cards do
        G.E_MANAGER:add_event(Event({func = function()
          local card = G.hand.cards[i]
          local suit_prefix = _suit..'_'
          local rank_suffix = card.base.id < 10 and tostring(card.base.id) or
                              card.base.id == 10 and 'T' or card.base.id == 11 and 'J' or
                              card.base.id == 12 and 'Q' or card.base.id == 13 and 'K' or
                              card.base.id == 14 and 'A'
          card:set_base(G.P_CARDS[suit_prefix..rank_suffix])
        return true end }))
      end  
    elseif self.ability.name == 'Ouija' then  -- Ouija
      local _rank = nil
      if spectral_level <= 2 then
        _rank = pseudorandom_element({'2','3','4','5','6','7','8','9','T','J','Q','K','A'}, pseudoseed('ouija'))
      else
        _rank = string.sub(G.hand.highlighted[1].base.id, 1, 1)
      end
      for i=1, #G.hand.cards do
        G.E_MANAGER:add_event(Event({func = function()
          local card = G.hand.cards[i]
          local suit_prefix = string.sub(card.base.suit, 1, 1)..'_'
          local rank_suffix =_rank
          card:set_base(G.P_CARDS[suit_prefix..rank_suffix])
        return true end }))
      end  
    end
    for i=1, #G.hand.cards do
      local percent = 0.85 + (i-0.999)/(#G.hand.cards-0.998)*0.3
      G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.cards[i]:flip();play_sound('tarot2', percent, 0.6);G.hand.cards[i]:juice_up(0.3, 0.3);return true end }))
    end
    delay(0.5)
  elseif (self.ability.name == 'Immolate' and spectral_level >= 2) then -- Immolate
    local destroyed_cards = {}
    delay(0.2)
    for i=#G.hand.highlighted, 1, -1 do
      destroyed_cards[#destroyed_cards+1] = G.hand.highlighted[i]
      G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0,
      func = function() 
        local card = G.hand.highlighted[i]
        if card.ability.name == 'Glass Card' then 
          card:shatter()
        else
          card:start_dissolve(nil, i == #G.hand.highlighted)
        end
      return true end }))
    end
    ease_dollars(#G.hand.highlighted*(spectral_level*2 + 2))
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
      play_sound('tarot1')
      used_tarot:juice_up(0.3, 0.5)
      return true end }))
  elseif self.ability.name == 'Talisman' or self.ability.name == 'Deja Vu' or self.ability.name == 'Trance' or self.ability.name == 'Medium' then -- seal-generators
    G.E_MANAGER:add_event(Event({func = function()
      play_sound('tarot1')
      used_tarot:juice_up(0.3, 0.5)
      return true end }))
    delay(0.1)
    for i = 1, #G.hand.highlighted do    
      G.E_MANAGER:add_event(Event({trigger = 'after', func = function()
        G.hand.highlighted[i]:set_seal(self.ability.extra, nil, true)
        return true end }))
    end 
    delay(0.7)
    G.E_MANAGER:add_event(Event({trigger = 'after', func = function() G.hand:unhighlight_all(); return true end }))
  else
    card_use_consumeable_ref(self, area, copier)
  end
end

-- Overwriting for Chaos the Clown
function new_round()
    G.RESET_JIGGLES = nil
    delay(0.4)
    G.E_MANAGER:add_event(Event({
      trigger = 'immediate',
      func = function()
            G.GAME.current_round.discards_left = math.max(0, G.GAME.round_resets.discards + G.GAME.round_bonus.discards)
            G.GAME.current_round.hands_left = (math.max(1, G.GAME.round_resets.hands + G.GAME.round_bonus.next_hands))
            G.GAME.current_round.hands_played = 0
            G.GAME.current_round.discards_used = 0
            G.GAME.current_round.reroll_cost_increase = 0
            G.GAME.current_round.used_packs = {}

            for k, v in pairs(G.GAME.hands) do 
                v.played_this_round = 0
            end

            for k, v in pairs(G.playing_cards) do
                v.ability.wheel_flipped = nil
            end

            local chaos = find_joker('Chaos the Clown')

            -- The number of free rerolls is now the number of Chaos the Clowns MULTIPLIED BY THE EFFECT LEVEL
            G.GAME.current_round.free_rerolls = #chaos * effect_level
            
            calculate_reroll_cost(true)

            G.GAME.round_bonus.next_hands = 0
            G.GAME.round_bonus.discards = 0

            local blhash = ''
            if G.GAME.round_resets.blind == G.P_BLINDS.bl_small then
                G.GAME.round_resets.blind_states.Small = 'Current'
                G.GAME.current_boss_streak = 0
                blhash = 'S'
            elseif G.GAME.round_resets.blind == G.P_BLINDS.bl_big then
                G.GAME.round_resets.blind_states.Big = 'Current'
                G.GAME.current_boss_streak = 0
                blhash = 'B'
            else
                G.GAME.round_resets.blind_states.Boss = 'Current'
                blhash = 'L'
            end
            G.GAME.subhash = (G.GAME.round_resets.ante)..(blhash)

            G.GAME.blind:set_blind(G.GAME.round_resets.blind)
            
            for i = 1, #G.jokers.cards do
                G.jokers.cards[i]:calculate_joker({setting_blind = true, blind = G.GAME.round_resets.blind})
            end
            delay(0.4)

            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    G.STATE = G.STATES.DRAW_TO_HAND
                    G.deck:shuffle('nr'..G.GAME.round_resets.ante)
                    G.deck:hard_set_T()
                    G.STATE_COMPLETE = false
                    return true
                end
            }))
            return true
            end
        }))
end

-- Hooking for Joker Stencil, DNA, Seltzer, 8 Ball, Trading Card, and Certificate
card_calculate_joker_ref = Card.calculate_joker
function Card.calculate_joker(self, context)
  for k, v in pairs(SMODS.Stickers) do
    if self.ability[v.key] then
      if v.calculate and type(v.calculate) == 'function' then
        local override_card = v:calculate(self, context)
        if override_card then return override_card end
      end
    end
  end
  if self.debuff then return nil end
  local obj = self.config.center
  if obj.calculate and type(obj.calculate) == 'function' then
    local o = obj:calculate(self, context)
    if o then return o end
  end
  if self.ability.set == "Joker" and not self.debuff and context.cardarea == G.jokers and context.before and self.ability.name == 'DNA' and (G.GAME.current_round.hands_played == 0 or effect_level >= 3) then
    if #context.full_hand == 1 then
      G.playing_card = (G.playing_card and G.playing_card + 1) or 1
        G.deck.config.card_limit = G.deck.config.card_limit + math.max(1, effect_level-1)
        for i = 1, math.max(1, effect_level-1) do
          local _card = copy_card(context.full_hand[1], nil, nil, G.playing_card)
          _card:add_to_deck()
          table.insert(G.playing_cards, _card)
          G.hand:emplace(_card)
          _card.states.visible = nil
          G.E_MANAGER:add_event(Event({
            func = function()
            _card:start_materialize()
            return true
          end
          }))
        delay(0.8)
        end
        return {
          message = localize('k_copied_ex'),
          colour = G.C.CHIPS,
          card = self,
          playing_cards_created = {true}
        }
      --end
    end
  elseif self.ability.set == "Joker" and not self.debuff and context.cardarea == G.play and context.repetition and self.ability.name == 'Seltzer' then
    return {
       message = localize('k_again_ex'),
       repetitions = effect_level,
       card = self
    }
  elseif self.ability.set == "Joker" and not self.debuff and context.cardarea == G.play and context.individual and self.ability.name == '8 Ball' and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
    if (context.other_card:get_id() == 8) and (pseudorandom('8ball') < G.GAME.probabilities.normal/self.ability.extra) then
      G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
      return {
        extra = {focus = self, message = localize('k_plus_tarot'), func = function()
          G.E_MANAGER:add_event(Event({
            trigger = 'before',
            delay = 0.0,
            func = (function()
            for i = 1, effect_level do
              if #G.consumeables.cards < G.consumeables.config.card_limit then
                local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, nil, '8ba')
              card:add_to_deck()
              G.consumeables:emplace(card)
              G.GAME.consumeable_buffer = 0
              end
            end
            return true
          end)}))
        end},
      colour = G.C.SECONDARY_SET.Tarot,
      card = self
      }
    end
  elseif self.ability.set == "Joker" and not self.debuff and context.discard and self.ability.name == 'Trading Card' and not context.blueprint and #context.full_hand == 1 and (G.GAME.current_round.discards_used <= 0 or econ_level >= 2) then
    ease_dollars(self.ability.extra)
    return {
      message = localize('$')..self.ability.extra,
      colour = G.C.MONEY,
      delay = 0.45, 
      remove = true,
      card = self
    }
  elseif self.ability.set == "Joker" and not self.debuff and context.first_hand_drawn and self.ability.name == 'Certificate' then
    G.E_MANAGER:add_event(Event({
      func = function() 
      local enhancement = pseudorandom(pseudoseed('certen'))
      local _card = create_playing_card({
        front = pseudorandom_element(G.P_CARDS, pseudoseed('cert_fr')), center = G.P_CENTERS.c_base}, G.hand, nil, nil, {G.C.SECONDARY_SET.Enhanced})
      local seal_type = pseudorandom(pseudoseed('certsl'))
      local edition = pseudorandom(pseudoseed('certed'))
      if seal_type > 0.75 then _card:set_seal('Red', true)
      elseif seal_type > 0.5 then _card:set_seal('Blue', true)
      elseif seal_type > 0.25 then _card:set_seal('Gold', true)
      else _card:set_seal('Purple', true)
      end
      if edition > 2/3 and effect_level >= 3 then _card:set_edition({holo = true}, true)
      elseif edition > 1/3 and effect_level >= 3 then _card:set_edition({polychrome = true}, true)
      elseif edition > 0/3 and effect_level >= 3 then _card:set_edition({foil = true}, true)
      end
      if effect_level >= 2 and enhancement > (325/326) then _card:set_ability(G.P_CENTERS.m_stone, nil, true)
      elseif effect_level >= 2 and enhancement > (6*52)/326 then _card:set_ability(G.P_CENTERS.m_wild, nil, true)
      elseif effect_level >= 2 and enhancement > (5*52)/326 then _card:set_ability(G.P_CENTERS.m_mult, nil, true)
      elseif effect_level >= 2 and enhancement > (4*52)/326 then _card:set_ability(G.P_CENTERS.m_bonus, nil, true)
      elseif effect_level >= 2 and enhancement > (3*52)/326 then _card:set_ability(G.P_CENTERS.m_gold, nil, true)
      elseif effect_level >= 2 and enhancement > (2*52)/326 then _card:set_ability(G.P_CENTERS.m_glass, nil, true)
      elseif effect_level >= 2 and enhancement > (1*52)/326 then _card:set_ability(G.P_CENTERS.m_steel, nil, true)
      elseif effect_level >= 2 and enhancement > (0*52)/326 then _card:set_ability(G.P_CENTERS.m_lucky, nil, true)
      end
      G.GAME.blind:debuff_card(_card)
      G.hand:sort()
      if context.blueprint_card then context.blueprint_card:juice_up() else self:juice_up() end
      return true
      end}))
    playing_card_joker_effects({true})
  elseif self.ability.set == "Joker" and not self.debuff and context.ending_shop and self.ability.name == 'Perkeo' then
    if G.consumeables.cards[1] then
      for i = 1, effect_level do
        G.E_MANAGER:add_event(Event({
          func = function() 
            local card = copy_card(pseudorandom_element(G.consumeables.cards, pseudoseed('perkeo')), nil)
            card:set_edition({negative = true}, true)
            card:add_to_deck()
            G.consumeables:emplace(card) 
            return true
          end}))
        card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = localize('k_duplicated_ex')})
      end
      return
    end
  elseif self.ability.set == "Joker" and not self.debuff and context.setting_blind and not self.getting_sliced and self.ability.name == 'Chicot' and not context.blueprint then
    if not (G.GAME.blind and ((not G.GAME.blind.disabled) and (G.GAME.blind:get_type() == 'Boss'))) then
      blind_level_chicot_luchador("chicot")
    end
  elseif self.ability.set == "Joker" and not self.debuff and context.selling_self and self.ability.name == 'Chicot' then
    if not (G.GAME.blind and ((not G.GAME.blind.disabled) and (G.GAME.blind:get_type() == 'Boss'))) then
      blind_level_chicot_luchador("chicot sold")
    end
  elseif self.ability.set == "Joker" and not self.debuff and context.selling_self and self.ability.name == 'Luchador' and G.GAME.blind and ((not G.GAME.blind.disabled) and (G.GAME.blind:get_type() == 'Boss')) then
    luchadors_sold = luchadors_sold + effect_level
    print("(luchador) Luchadors sold: "..luchadors_sold)
  else
--  card calculate_joker_ref(self, context) -- For some reason, this never procs. Replacing "card_calculate_joker_ref = Card.calculate_joker" with
                                            -- "card_calculate_joker_ref = calculate_joker" raises the error "attempt to index value 'card_calculate_joker_ref' (a nil value)",
                                            -- and also replacing "function Card.calculate_joker(self, context)" with "function Card.calculate_joker(self, context)"
                                            -- allows the ref to proc but the new hooked function never procs. Therefore, with my limited knowledge, the only thing I could think of left
                                            -- is to instead copy the entire code of calculate_joker below and overwrite it, instead of hooking.
                                            -- Note: do not edit cards directly here, only ever copy the code from the lovely version of card.lua

-----------------------------------------------------------------------------
--@@@--@-@--@@@--@@---@-@-@--@@---@@@--@@@--@@@-----@@@--@@@--@@@--@@---@@@--
--@-@--@-@--@----@-@--@-@-@--@-@---@----@---@-------@-----@---@-@--@-@---@---
--@-@--@-@--@@---@@---@-@-@--@@----@----@---@@------@@@---@---@@@--@@----@---
--@-@--@-@--@----@-@--@-@-@--@-@---@----@---@---------@---@---@-@--@-@---@---
--@@@---@---@@@--@-@--@@@@@--@-@--@@@---@---@@@-----@@@---@---@-@--@-@---@---
-----------------------------------------------------------------------------

if self.ability.set == "Planet" and not self.debuff then
        if context.joker_main then
            if G.GAME.used_vouchers.v_observatory and self.ability.consumeable.hand_type == context.scoring_name then
                return {
                    message = localize{type = 'variable', key = 'a_xmult', vars = {G.P_CENTERS.v_observatory.config.extra}},
                    Xmult_mod = G.P_CENTERS.v_observatory.config.extra
                }
            end
        end
    end
    if self.ability.set == "Joker" and not self.debuff then
        if self.ability.name == "Blueprint" then
            local other_joker = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == self then other_joker = G.jokers.cards[i+1] end
            end
            if other_joker and other_joker ~= self then
                context.blueprint = (context.blueprint and (context.blueprint + 1)) or 1
                context.blueprint_card = context.blueprint_card or self
                if context.blueprint > #G.jokers.cards + 1 then return end
                local other_joker_ret = other_joker:calculate_joker(context)
                if other_joker_ret then 
                    other_joker_ret.card = context.blueprint_card or self
                    other_joker_ret.colour = G.C.BLUE
                    return other_joker_ret
                end
            end
        end
        if self.ability.name == "Brainstorm" then
            local other_joker = G.jokers.cards[1]
            if other_joker and other_joker ~= self then
                context.blueprint = (context.blueprint and (context.blueprint + 1)) or 1
                context.blueprint_card = context.blueprint_card or self
                if context.blueprint > #G.jokers.cards + 1 then return end
                local other_joker_ret = other_joker:calculate_joker(context)
                if other_joker_ret then 
                    other_joker_ret.card = context.blueprint_card or self
                    other_joker_ret.colour = G.C.RED
                    return other_joker_ret
                end
            end
        end
        if context.open_booster then
            if self.ability.name == 'Hallucination' and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                if pseudorandom('halu'..G.GAME.round_resets.ante) < G.GAME.probabilities.normal/self.ability.extra then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.0,
                        func = (function()
                                for i = 1, effect_level do
                                if #G.consumeables.cards < G.consumeables.config.card_limit then
                                local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, nil, 'hal')
                                card:add_to_deck()
                                G.consumeables:emplace(card)
                                G.GAME.consumeable_buffer = 0
                                end
                                end
                            return true
                        end)}))
                    card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
                end
            end
        elseif context.buying_card then
            
        elseif context.selling_self then
            if self.ability.name == 'Luchador' then
                if G.GAME.blind and ((not G.GAME.blind.disabled) and (G.GAME.blind:get_type() == 'Boss')) then 
                    card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = localize('ph_boss_disabled')})
                    G.GAME.blind:disable()
                end
            end
            if self.ability.name == 'Diet Cola' then
            for i = 1, effect_level do
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        add_tag(Tag('tag_double'))
                        play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                        play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                        return true
                    end)
                }))
            end
            end
            if self.ability.name == 'Invisible Joker' and (self.ability.invis_rounds >= self.ability.extra) and not context.blueprint then
                local eval = function(card) return (card.ability.loyalty_remaining == 0) and not G.RESET_JIGGLES end
                                    juice_card_until(self, eval, true)
                local jokers = {}
                for i=1, #G.jokers.cards do 
                    if G.jokers.cards[i] ~= self then
                        jokers[#jokers+1] = G.jokers.cards[i]
                    end
                end
                if #jokers > 0 then 
                    if #G.jokers.cards <= G.jokers.config.card_limit then 
                        card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = localize('k_duplicated_ex')})
                        chosen_joker = pseudorandom_element(jokers, pseudoseed('invisible'))
                        if effect_level >= 3 then
                          chosen_joker = G.jokers.cards[1]
                        end
                        local card = copy_card(chosen_joker, nil, nil, nil, false)
                        if card.ability.invis_rounds then card.ability.invis_rounds = 0 end
                        if card.edition and card.edition.negative then
                          if effect_level <= 3 then card:set_edition(nil, true) end
                        end
                        card:add_to_deck()
                        G.jokers:emplace(card)
                    else
                        card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = localize('k_no_room_ex')})
                    end
                else
                    card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = localize('k_no_other_jokers')})
                end
            end
        elseif context.selling_card then
                if self.ability.name == 'Campfire' and not context.blueprint then
                    self.ability.x_mult = self.ability.x_mult + self.ability.extra
                    G.E_MANAGER:add_event(Event({
                        func = function() card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')}); return true
                        end}))
                end
            return
        elseif context.reroll_shop then
            if self.ability.name == 'Flash Card' and not context.blueprint then
                self.ability.mult = self.ability.mult + self.ability.extra
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_mult', vars = {self.ability.mult}}, colour = G.C.MULT})
                    return true
                end)}))
            end
        elseif context.ending_shop then
            if self.ability.name == 'Perkeo' then
                if G.consumeables.cards[1] then
                    G.E_MANAGER:add_event(Event({
                        func = function() 
                            local card = copy_card(pseudorandom_element(G.consumeables.cards, pseudoseed('perkeo')), nil)
                            card:set_edition({negative = true}, true)
                            card:add_to_deck()
                            G.consumeables:emplace(card) 
                            return true
                        end}))
                    card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = localize('k_duplicated_ex')})
                end
                return
            end
            return
        elseif context.skip_blind then
            if self.ability.name == 'Throwback' and not context.blueprint then
                G.E_MANAGER:add_event(Event({
                    func = function() 
                        card_eval_status_text(self, 'extra', nil, nil, nil, {
                            message = localize{type = 'variable', key = 'a_xmult', vars = {self.ability.x_mult}},
                                colour = G.C.RED,
                            card = self
                        }) 
                        return true
                    end}))
            end
            return
        elseif context.skipping_booster then
            if self.ability.name == 'Red Card' and not context.blueprint then
                self.ability.mult = self.ability.mult + self.ability.extra
                                G.E_MANAGER:add_event(Event({
                    func = function() 
                        card_eval_status_text(self, 'extra', nil, nil, nil, {
                            message = localize{type = 'variable', key = 'a_mult', vars = {self.ability.extra}},
                            colour = G.C.RED,
                            delay = 0.45, 
                            card = self
                        }) 
                        return true
                    end}))
            end
            return
        elseif context.playing_card_added and not self.getting_sliced then
            if self.ability.name == 'Hologram' and (not context.blueprint)
                and context.cards and context.cards[1] then
                    self.ability.x_mult = self.ability.x_mult + #context.cards*self.ability.extra
                    card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {self.ability.x_mult}}})
            end
        elseif context.first_hand_drawn then
            if self.ability.name == 'Certificate' then
                G.E_MANAGER:add_event(Event({
                    func = function() 
                        local _card = create_playing_card({
                            front = pseudorandom_element(G.P_CARDS, pseudoseed('cert_fr')), 
                            center = G.P_CENTERS.c_base}, G.hand, nil, nil, {G.C.SECONDARY_SET.Enhanced})
                        _card:set_seal(SMODS.poll_seal({guaranteed = true, type_key = 'certsl'}))
                        G.GAME.blind:debuff_card(_card)
                        G.hand:sort()
                        if context.blueprint_card then context.blueprint_card:juice_up() else self:juice_up() end
                        return true
                    end}))

                playing_card_joker_effects({true})
            end
            if self.ability.name == 'DNA' and not context.blueprint then
                local eval = function() return (G.GAME.current_round.hands_played == 0 or (G.GAME.current_round.hands_played >= 0 and effect_level >= 3)) and not G.RESET_JIGGLES end
                juice_card_until(self, eval, true)
            end
            if self.ability.name == 'Burnt Joker' and not context.blueprint then
              local eval = function() return (G.GAME.current_round.discards_used == 0 or (G.GAME.current_round.discards_used >= 0 and effect_level >= 2)) and not G.RESET_JIGGLES end
              juice_card_until(self, eval, true)
            end
            if self.ability.name == 'Trading Card' and not context.blueprint then
                local eval = function() return (G.GAME.current_round.discards_used == 0 or (G.GAME.current_round.discards_used >= 0 and econ_level >= 2)) and not G.RESET_JIGGLES end
                juice_card_until(self, eval, true)
            end
        elseif context.setting_blind and not self.getting_sliced then
            if self.ability.name == 'Chicot' and not context.blueprint
            and context.blind.boss and not self.getting_sliced then
                G.E_MANAGER:add_event(Event({func = function()
                    G.E_MANAGER:add_event(Event({func = function()
                        G.GAME.blind:disable()
                        play_sound('timpani')
                        delay(0.4)
                        return true end }))
                    card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize('ph_boss_disabled')})
                return true end }))
            end
            if self.ability.name == 'Madness' and not context.blueprint and not context.blind.boss then
                self.ability.x_mult = self.ability.x_mult + self.ability.extra
                local destructable_jokers = {}
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i] ~= self and not G.jokers.cards[i].ability.eternal and not G.jokers.cards[i].getting_sliced then destructable_jokers[#destructable_jokers+1] = G.jokers.cards[i] end
                end
                local joker_to_destroy = #destructable_jokers > 0 and pseudorandom_element(destructable_jokers, pseudoseed('madness')) or nil

                if joker_to_destroy and not (context.blueprint_card or self).getting_sliced then 
                    joker_to_destroy.getting_sliced = true
                    G.E_MANAGER:add_event(Event({func = function()
                        (context.blueprint_card or self):juice_up(0.8, 0.8)
                        joker_to_destroy:start_dissolve({G.C.RED}, nil, 1.6)
                    return true end }))
                end
                if not (context.blueprint_card or self).getting_sliced then
                    card_eval_status_text((context.blueprint_card or self), 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {self.ability.x_mult}}})
                end
            end
            if self.ability.name == 'Burglar' and not (context.blueprint_card or self).getting_sliced then
                G.E_MANAGER:add_event(Event({func = function()
                    ease_discard(-G.GAME.current_round.discards_left, nil, true)
                    ease_hands_played(self.ability.extra)
                    card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_hands', vars = {self.ability.extra}}})
                return true end }))
            end
            if self.ability.name == 'Riff-raff' and not (context.blueprint_card or self).getting_sliced and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
                local jokers_to_create = math.min((effect_level+1), G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
                G.GAME.joker_buffer = G.GAME.joker_buffer + jokers_to_create
                G.E_MANAGER:add_event(Event({
                    func = function() 
                        for i = 1, jokers_to_create do
                            local card = create_card('Joker', G.jokers, nil, 0, nil, nil, nil, 'rif')
                            card:add_to_deck()
                            G.jokers:emplace(card)
                            card:start_materialize()
                            G.GAME.joker_buffer = 0
                        end
                        return true
                    end}))   
                    card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = localize('k_plus_joker'), colour = G.C.BLUE}) 
            end
            if self.ability.name == 'Cartomancer' and not (context.blueprint_card or self).getting_sliced and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        G.E_MANAGER:add_event(Event({
                            func = function() 
                                for i = 1, effect_level do
                                if #G.consumeables.cards < G.consumeables.config.card_limit then
                                local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, nil, 'car')
                                card:add_to_deck()
                                G.consumeables:emplace(card)
                                G.GAME.consumeable_buffer = 0
                                end
                                end
                                return true
                            end}))   
                            card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})                       
                        return true
                    end)}))
            end
            if self.ability.name == 'Ceremonial Dagger' and not context.blueprint then
                local my_pos = nil
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i] == self then my_pos = i; break end
                end
                if my_pos and G.jokers.cards[my_pos+1] and not self.getting_sliced and not G.jokers.cards[my_pos+1].ability.eternal and not G.jokers.cards[my_pos+1].getting_sliced then 
                    local sliced_card = G.jokers.cards[my_pos+1]
                    sliced_card.getting_sliced = true
                    G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                    G.E_MANAGER:add_event(Event({func = function()
                        G.GAME.joker_buffer = 0
                        self.ability.mult = self.ability.mult + sliced_card.sell_cost*(2 + ((mult_level-1) * 1))
                        self:juice_up(0.8, 0.8)
                        sliced_card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                        play_sound('slice1', 0.96+math.random()*0.08)
                    return true end }))
                    card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_mult', vars = {self.ability.mult+2*sliced_card.sell_cost}}, colour = G.C.RED, no_juice = true})
                end
            end
            if self.ability.name == 'Marble Joker' and not (context.blueprint_card or self).getting_sliced  then
                G.E_MANAGER:add_event(Event({
                    func = function() 
                        local front = pseudorandom_element(G.P_CARDS, pseudoseed('marb_fr'))
                        G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                        local card = Card(G.play.T.x + G.play.T.w/2, G.play.T.y, G.CARD_W, G.CARD_H, front, G.P_CENTERS.m_stone, {playing_card = G.playing_card})
                        card:start_materialize({G.C.SECONDARY_SET.Enhanced})
                        G.play:emplace(card)
                        table.insert(G.playing_cards, card)
                        return true
                    end}))
                card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = localize('k_plus_stone'), colour = G.C.SECONDARY_SET.Enhanced})

                G.E_MANAGER:add_event(Event({
                    func = function() 
                        G.deck.config.card_limit = G.deck.config.card_limit + 1
                        return true
                    end}))
                    draw_card(G.play,G.deck, 90,'up', nil)  

                playing_card_joker_effects({true})
            end
            return
        elseif (context.destroying_card and effect_level >= 3) or (context.destroying_card and not context.blueprint) then
            if self.ability.name == 'Sixth Sense' and #context.full_hand == 1 and context.full_hand[1]:get_id() == 6 and (G.GAME.current_round.hands_played == 0 or effect_level >= 2) then
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.0,
                        func = (function()
                                for i = 1, math.max(1, effect_level-1) do
                                if #G.consumeables.cards < G.consumeables.config.card_limit then
                                local card = create_card('Spectral',G.consumeables, nil, nil, nil, nil, nil, 'sixth')
                                card:add_to_deck()
                                G.consumeables:emplace(card)
                                G.GAME.consumeable_buffer = 0
                                end
                                end
                            return true
                        end)}))
                    card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral})
                end
               return true
            end
            return nil
        elseif context.cards_destroyed then
            if self.ability.name == 'Caino' and not context.blueprint then
                local faces = 0
                for k, v in ipairs(context.glass_shattered) do
                    if v:is_face() then
                        faces = faces + 1
                    end
                end
                if faces > 0 then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            self.ability.caino_xmult = self.ability.caino_xmult + faces*self.ability.extra
                          return true
                        end
                      }))
                    card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {self.ability.caino_xmult + faces*self.ability.extra}}})
                    return true
                end
              }))
                end

                return
            end
            if self.ability.name == 'Glass Joker' and not context.blueprint then
                local glasses = 0
                for k, v in ipairs(context.glass_shattered) do
                    if v.shattered then
                        glasses = glasses + 1
                    end
                end
                if glasses > 0 then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            self.ability.x_mult = self.ability.x_mult + self.ability.extra*glasses
                          return true
                        end
                      }))
                    card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {self.ability.x_mult + self.ability.extra*glasses}}})
                    return true
                end
              }))
                end

                return
            end
            
        elseif context.remove_playing_cards then
            if self.ability.name == 'Caino' and not context.blueprint then
                local face_cards = 0
                for k, val in ipairs(context.removed) do
                    if val:is_face() then face_cards = face_cards + 1 end
                end
                if face_cards > 0 then
                    self.ability.caino_xmult = self.ability.caino_xmult + face_cards*self.ability.extra
                    G.E_MANAGER:add_event(Event({
                    func = function() card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {self.ability.caino_xmult}}}); return true
                    end}))
                end
                return
            end

            if self.ability.name == 'Glass Joker' and not context.blueprint then
                local glass_cards = 0
                for k, val in ipairs(context.removed) do
                    if val.shattered then glass_cards = glass_cards + 1 end
                end
                if glass_cards > 0 then 
                    G.E_MANAGER:add_event(Event({
                        func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            self.ability.x_mult = self.ability.x_mult + self.ability.extra*glass_cards
                        return true
                        end
                    }))
                    card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {self.ability.x_mult + self.ability.extra*glass_cards}}})
                    return true
                        end
                    }))
                end
                return
            end
        elseif context.using_consumeable then
            if self.ability.name == 'Glass Joker' and not context.blueprint and ((context.consumeable.ability.name == 'The Hanged Man') or (context.consumeable.ability.name == 'Immolate' and spectral_level >= 2)) then
                local shattered_glass = 0
                for k, val in ipairs(G.hand.highlighted) do
                    if val.ability.name == 'Glass Card' then shattered_glass = shattered_glass + 1 end
                end
                if shattered_glass > 0 then
                    self.ability.x_mult = self.ability.x_mult + self.ability.extra*shattered_glass
                    G.E_MANAGER:add_event(Event({
                        func = function() card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_xmult',vars={self.ability.x_mult}}}); return true
                        end}))
                end
                return
            end
            if self.ability.name == 'Fortune Teller' and not context.blueprint and (context.consumeable.ability.set == "Tarot") then
                G.E_MANAGER:add_event(Event({
                    func = function() card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_mult',vars={G.GAME.consumeable_usage_total.tarot}}}); return true
                    end}))
            end
            if self.ability.name == 'Constellation' and not context.blueprint and context.consumeable.ability.set == 'Planet' then
                self.ability.x_mult = self.ability.x_mult + self.ability.extra
                G.E_MANAGER:add_event(Event({
                    func = function() card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_xmult',vars={self.ability.x_mult}}}); return true
                    end}))
                return
            end
            return
        elseif context.debuffed_hand then 
            if self.ability.name == 'Matador' then
                if G.GAME.blind.triggered then 
                    ease_dollars(self.ability.extra)
                    G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + self.ability.extra
                    G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
                    return {
                        message = localize('$')..self.ability.extra,
                        dollars = self.ability.extra,
                        colour = G.C.MONEY
                    }
                end
            end
        elseif context.pre_discard then
            if self.ability.name == 'Burnt Joker' and ((G.GAME.current_round.discards_used <= 0 and not context.hook) or effect_level >= 4) then
                local text,disp_text = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
                card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')})
                update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(text, 'poker_hands'),chips = G.GAME.hands[text].chips, mult = G.GAME.hands[text].mult, level=G.GAME.hands[text].level})
                level_up_hand(context.blueprint_card or self, text, nil, effect_level)
                update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
            end
        elseif context.discard then
            if self.ability.name == 'Ramen' and not context.blueprint then
                if self.ability.x_mult - self.ability.extra <= 1 then 
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('tarot1')
                            self.T.r = -0.2
                            self:juice_up(0.3, 0.4)
                            self.states.drag.is = true
                            self.children.center.pinch.x = true
                            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                                func = function()
                                        G.jokers:remove_card(self)
                                        self:remove()
                                        self = nil
                                    return true; end})) 
                            return true
                        end
                    })) 
                    return {
                        message = localize('k_eaten_ex'),
                        colour = G.C.FILTER
                    }
                else
                    self.ability.x_mult = self.ability.x_mult - self.ability.extra
                    return {
                        delay = 0.2,
                        message = localize{type='variable',key='a_xmult_minus',vars={self.ability.extra}},
                        colour = G.C.RED
                    }
                end
            end
            if self.ability.name == 'Yorick' and not context.blueprint then
                if self.ability.yorick_discards <= 1 then
                    self.ability.yorick_discards = self.ability.extra.discards
                    self.ability.x_mult = self.ability.x_mult + self.ability.extra.xmult
                    return {
                        delay = 0.2,
                        message = localize{type='variable',key='a_xmult',vars={self.ability.x_mult}},
                        colour = G.C.RED
                    }
                else
                    self.ability.yorick_discards = self.ability.yorick_discards - 1
                end
                return
            end
            if self.ability.name == 'Trading Card' and not context.blueprint and 
            G.GAME.current_round.discards_used <= 0 and #context.full_hand == 1 then
                ease_dollars(self.ability.extra)
                return {
                    message = localize('$')..self.ability.extra,
                    colour = G.C.MONEY,
                    delay = 0.45, 
                    remove = true,
                    card = self
                }
            end
            
            if self.ability.name == 'Castle' and
            not context.other_card.debuff and
            context.other_card:is_suit(G.GAME.current_round.castle_card.suit) and not context.blueprint then
                self.ability.extra.chips = self.ability.extra.chips + self.ability.extra.chip_mod
                  
                return {
                    message = localize('k_upgrade_ex'),
                    card = self,
                    colour = G.C.CHIPS
                }
            end
            if self.ability.name == 'Mail-In Rebate' and
            not context.other_card.debuff and
            context.other_card:get_id() == G.GAME.current_round.mail_card.id then
                ease_dollars(self.ability.extra)
                return {
                    message = localize('$')..self.ability.extra,
                    colour = G.C.MONEY,
                    card = self
                }
            end
            if self.ability.name == 'Hit the Road' and
            not context.other_card.debuff and
            context.other_card:get_id() == 11 and not context.blueprint then
                self.ability.x_mult = self.ability.x_mult + self.ability.extra
                return {
                    message = localize{type='variable',key='a_xmult',vars={self.ability.x_mult}},
                        colour = G.C.RED,
                        delay = 0.45, 
                    card = self
                }
            end
            if self.ability.name == 'Green Joker' and not context.blueprint and context.other_card == context.full_hand[#context.full_hand] then
                local prev_mult = self.ability.mult
                self.ability.mult = math.max(0, self.ability.mult - self.ability.extra.discard_sub)
                if self.ability.mult ~= prev_mult then 
                    return {
                        message = localize{type='variable',key='a_mult_minus',vars={self.ability.extra.discard_sub}},
                        colour = G.C.RED,
                        card = self
                    }
                end
            end
            
            if self.ability.name == 'Faceless Joker' and context.other_card == context.full_hand[#context.full_hand] then
                local face_cards = 0
                for k, v in ipairs(context.full_hand) do
                    if v:is_face() then face_cards = face_cards + 1 end
                end
                if face_cards >= self.ability.extra.faces then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            ease_dollars(self.ability.extra.dollars)
                            card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = localize('$')..self.ability.extra.dollars,colour = G.C.MONEY, delay = 0.45})
                            return true
                        end}))
                    return
                end
            end
            return
        elseif context.end_of_round then
            if context.individual then

            elseif context.repetition then
                if context.cardarea == G.hand then
                    if self.ability.name == 'Mime' and
                    (next(context.card_effects[1]) or #context.card_effects > 1) then
                        return {
                            message = localize('k_again_ex'),
                            repetitions = self.ability.extra,
                            card = self
                        }
                    end
                end
            elseif not context.blueprint then
                if self.ability.name == 'Campfire' and G.GAME.blind.boss and self.ability.x_mult > 1 then
                    self.ability.x_mult = 1
                    return {
                        message = localize('k_reset'),
                        colour = G.C.RED
                    }
                end
                if self.ability.name == 'Rocket' and G.GAME.blind.boss then
                    self.ability.extra.dollars = self.ability.extra.dollars + self.ability.extra.increase
                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.MONEY
                    }
                end
                if self.ability.name == 'Turtle Bean' and not context.blueprint then
                    if self.ability.extra.h_size - self.ability.extra.h_mod <= 0 then 
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                play_sound('tarot1')
                                self.T.r = -0.2
                                self:juice_up(0.3, 0.4)
                                self.states.drag.is = true
                                self.children.center.pinch.x = true
                                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                                    func = function()
                                            G.jokers:remove_card(self)
                                            self:remove()
                                            self = nil
                                        return true; end})) 
                                return true
                            end
                        })) 
                        return {
                            message = localize('k_eaten_ex'),
                            colour = G.C.FILTER
                        }
                    else
                        self.ability.extra.h_size = self.ability.extra.h_size - self.ability.extra.h_mod
                        G.hand:change_size(- self.ability.extra.h_mod)
                        return {
                            message = localize{type='variable',key='a_handsize_minus',vars={self.ability.extra.h_mod}},
                            colour = G.C.FILTER
                        }
                    end
                end
                if self.ability.name == 'Invisible Joker' and not context.blueprint then
                    self.ability.invis_rounds = self.ability.invis_rounds + 1
                    if self.ability.invis_rounds == self.ability.extra then 
                        local eval = function(card) return not card.REMOVED end
                        juice_card_until(self, eval, true)
                    end
                    return {
                        message = (self.ability.invis_rounds < self.ability.extra) and (self.ability.invis_rounds..'/'..self.ability.extra) or localize('k_active_ex'),
                        colour = G.C.FILTER
                    }
                end
                if self.ability.name == 'Popcorn' and not context.blueprint then
                    if self.ability.mult - self.ability.extra <= 0 then 
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                play_sound('tarot1')
                                self.T.r = -0.2
                                self:juice_up(0.3, 0.4)
                                self.states.drag.is = true
                                self.children.center.pinch.x = true
                                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                                    func = function()
                                            G.jokers:remove_card(self)
                                            self:remove()
                                            self = nil
                                        return true; end})) 
                                return true
                            end
                        })) 
                        return {
                            message = localize('k_eaten_ex'),
                            colour = G.C.RED
                        }
                    else
                        self.ability.mult = self.ability.mult - self.ability.extra
                        return {
                            message = localize{type='variable',key='a_mult_minus',vars={self.ability.extra}},
                            colour = G.C.MULT
                        }
                    end
                end
                if self.ability.name == 'To Do List' and not context.blueprint then
                    local _poker_hands = {}
                    for k, v in pairs(G.GAME.hands) do
                        if v.visible and k ~= self.ability.to_do_poker_hand then _poker_hands[#_poker_hands+1] = k end
                    end
                    self.ability.to_do_poker_hand = pseudorandom_element(_poker_hands, pseudoseed('to_do'))
                    return {
                        message = localize('k_reset')
                    }
                end
                if self.ability.name == 'Egg' then
                    self.ability.extra_value = self.ability.extra_value + self.ability.extra
                    self:set_cost()
                    return {
                        message = localize('k_val_up'),
                        colour = G.C.MONEY
                    }
                end
                if self.ability.name == 'Gift Card' then
                    for k, v in ipairs(G.jokers.cards) do
                        if v.set_cost then 
                            v.ability.extra_value = (v.ability.extra_value or 0) + self.ability.extra
                            v:set_cost()
                        end
                    end
                    for k, v in ipairs(G.consumeables.cards) do
                        if v.set_cost then 
                            v.ability.extra_value = (v.ability.extra_value or 0) + self.ability.extra
                            v:set_cost()
                        end
                    end
                    return {
                        message = localize('k_val_up'),
                        colour = G.C.MONEY
                    }
                end
                if self.ability.name == 'Hit the Road' and self.ability.x_mult > 1 then
                    self.ability.x_mult = 1
                    return {
                        message = localize('k_reset'),
                        colour = G.C.RED
                    }
                end
                
                if self.ability.name == 'Gros Michel' or self.ability.name == 'Cavendish' then
                    if pseudorandom(self.ability.name == 'Cavendish' and 'cavendish' or 'gros_michel') < G.GAME.probabilities.normal/self.ability.extra.odds then 
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                play_sound('tarot1')
                                self.T.r = -0.2
                                self:juice_up(0.3, 0.4)
                                self.states.drag.is = true
                                self.children.center.pinch.x = true
                                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                                    func = function()
                                            G.jokers:remove_card(self)
                                            self:remove()
                                            self = nil
                                        return true; end})) 
                                return true
                            end
                        })) 
                        if self.ability.name == 'Gros Michel' then G.GAME.pool_flags.gros_michel_extinct = true end
                        return {
                            message = localize('k_extinct_ex')
                        }
                    else
                        return {
                            message = localize('k_safe_ex')
                        }
                    end
                end
                if self.ability.name == 'Mr. Bones' and context.game_over and 
                (G.GAME.chips/G.GAME.blind.chips) >= (2.5 / (10^effect_level)) then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.hand_text_area.blind_chips:juice_up()
                            G.hand_text_area.game_chips:juice_up()
                            play_sound('tarot1')
                            self:start_dissolve()
                            return true
                        end
                    })) 
                    return {
                        message = localize('k_saved_ex'),
                        saved = true,
                        colour = G.C.RED
                    }
                end
            end
        elseif context.individual then
            if context.cardarea == G.play then
                if self.ability.name == 'Hiker' then
                        context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus or 0
                        context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus + self.ability.extra
                        return {
                            extra = {message = localize('k_upgrade_ex'), colour = G.C.CHIPS},
                            colour = G.C.CHIPS,
                            card = self
                        }
                end
                if self.ability.name == 'Lucky Cat' and context.other_card.lucky_trigger and not context.blueprint then
                    self.ability.x_mult = self.ability.x_mult + self.ability.extra
                    return {
                        extra = {focus = self, message = localize('k_upgrade_ex'), colour = G.C.MULT},
                        card = self
                    }
                end
                if self.ability.name == 'Wee Joker' and
                    context.other_card:get_id() == 2 and not context.blueprint then
                        self.ability.extra.chips = self.ability.extra.chips + self.ability.extra.chip_mod
                        
                        return {
                            extra = {focus = self, message = localize('k_upgrade_ex')},
                            card = self,
                            colour = G.C.CHIPS
                        }
                end
                if self.ability.name == 'Photograph' then
                    local first_face = nil
                    for i = 1, #context.scoring_hand do
                        if context.scoring_hand[i]:is_face() then first_face = context.scoring_hand[i]; break end
                    end
                    if context.other_card == first_face then
                        return {
                            x_mult = self.ability.extra,
                            colour = G.C.RED,
                            card = self
                        }
                    end
                end
                if self.ability.name == '8 Ball' and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    if (context.other_card:get_id() == 8) and (pseudorandom('8ball') < G.GAME.probabilities.normal/self.ability.extra) then
                        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                        return {
                            extra = {focus = self, message = localize('k_plus_tarot'), func = function()
                                G.E_MANAGER:add_event(Event({
                                    trigger = 'before',
                                    delay = 0.0,
                                    func = (function()
                                            for i = 1, edition_level do
                                            if #G.consumeables.cards < G.consumeables.config.card_limit then
                                            local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, nil, '8ba')
                                            card:add_to_deck()
                                            G.consumeables:emplace(card)
                                            G.GAME.consumeable_buffer = 0
                                            end
                                            end
                                        return true
                                    end)}))
                            end},
                            colour = G.C.SECONDARY_SET.Tarot,
                            card = self
                        }
                    end
                end
                if self.ability.name == 'The Idol' and
                    context.other_card:get_id() == G.GAME.current_round.idol_card.id and 
                    context.other_card:is_suit(G.GAME.current_round.idol_card.suit) then
                        return {
                            x_mult = self.ability.extra,
                            colour = G.C.RED,
                            card = self
                        }
                    end
                if self.ability.name == 'Scary Face' and (
                    context.other_card:is_face()) then
                        return {
                            chips = self.ability.extra,
                            card = self
                        }
                    end
                if self.ability.name == 'Smiley Face' and (
                    context.other_card:is_face()) then
                        return {
                            mult = self.ability.extra,
                            card = self
                        }
                    end
                if self.ability.name == 'Golden Ticket' and
                    context.other_card.ability.name == 'Gold Card' then
                        G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + self.ability.extra
                        G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
                        return {
                            dollars = self.ability.extra,
                            card = self
                        }
                    end
                if self.ability.name == 'Scholar' and
                    context.other_card:get_id() == 14 then
                        return {
                            chips = self.ability.extra.chips,
                            mult = self.ability.extra.mult,
                            card = self
                        }
                    end
                if self.ability.name == 'Walkie Talkie' and
                (context.other_card:get_id() == 10 or context.other_card:get_id() == 4) then
                    return {
                        chips = self.ability.extra.chips,
                        mult = self.ability.extra.mult,
                        card = self
                    }
                end
                if self.ability.name == 'Business Card' and
                    context.other_card:is_face() and
                    pseudorandom('business') < G.GAME.probabilities.normal/self.ability.extra then
                        G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + 2 + ((econ_level-1) * 1)
                        G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
                        return {
                            dollars = 2,
                            card = self
                        }
                    end
                if self.ability.name == 'Fibonacci' and (
                context.other_card:get_id() == 2 or 
                context.other_card:get_id() == 3 or 
                context.other_card:get_id() == 5 or 
                context.other_card:get_id() == 8 or 
                context.other_card:get_id() == 14) then
                    return {
                        mult = self.ability.extra,
                        card = self
                    }
                end
                if self.ability.name == 'Even Steven' and
                context.other_card:get_id() <= 10 and 
                context.other_card:get_id() >= 0 and
                context.other_card:get_id()%2 == 0
                then
                    return {
                        mult = self.ability.extra,
                        card = self
                    }
                end
                if self.ability.name == 'Odd Todd' and
                ((context.other_card:get_id() <= 10 and 
                context.other_card:get_id() >= 0 and
                context.other_card:get_id()%2 == 1) or
                (context.other_card:get_id() == 14))
                then
                    return {
                        chips = self.ability.extra,
                        card = self
                    }
                end
                if self.ability.effect == 'Suit Mult' and
                    context.other_card:is_suit(self.ability.extra.suit) then
                    return {
                        mult = self.ability.extra.s_mult,
                        card = self
                    }
                end
                if self.ability.name == 'Rough Gem' and
                context.other_card:is_suit("Diamonds") then
                    G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + self.ability.extra
                    G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
                    return {
                        dollars = self.ability.extra,
                        card = self
                    }
                end
                if self.ability.name == 'Onyx Agate' and
                context.other_card:is_suit("Clubs") then
                    return {
                        mult = self.ability.extra,
                        card = self
                    }
                end
                if self.ability.name == 'Arrowhead' and
                context.other_card:is_suit("Spades") then
                    return {
                        chips = self.ability.extra,
                        card = self
                    }
                end
                if self.ability.name ==  'Bloodstone' and
                context.other_card:is_suit("Hearts") and 
                pseudorandom('bloodstone') < G.GAME.probabilities.normal/self.ability.extra.odds then
                    return {
                        x_mult = self.ability.extra.Xmult,
                        card = self
                    }
                end
                if self.ability.name == 'Ancient Joker' and
                context.other_card:is_suit(G.GAME.current_round.ancient_card.suit) then
                    return {
                        x_mult = self.ability.extra,
                        card = self
                    }
                end
                if self.ability.name == 'Triboulet' and
                    (context.other_card:get_id() == 12 or context.other_card:get_id() == 13) then
                        return {
                            x_mult = self.ability.extra,
                            colour = G.C.RED,
                            card = self
                        }
                    end
            end
            if context.cardarea == G.hand then
                    if self.ability.name == 'Shoot the Moon' and
                        context.other_card:get_id() == 12 then
                        if context.other_card.debuff then
                            return {
                                message = localize('k_debuffed'),
                                colour = G.C.RED,
                                card = self,
                            }
                        else
                            return {
                                h_mult = 13 + ((mult_level-1) * 2),
                                card = self
                            }
                        end
                    end
                    if self.ability.name == 'Baron' and
                        context.other_card:get_id() == 13 then
                        if context.other_card.debuff then
                            return {
                                message = localize('k_debuffed'),
                                colour = G.C.RED,
                                card = self,
                            }
                        else
                            return {
                                x_mult = self.ability.extra,
                                card = self
                            }
                        end
                    end
                    if self.ability.name == 'Reserved Parking' and
                    context.other_card:is_face() and
                    pseudorandom('parking') < G.GAME.probabilities.normal/self.ability.extra.odds then
                        if context.other_card.debuff then
                            return {
                                message = localize('k_debuffed'),
                                colour = G.C.RED,
                                card = self,
                            }
                        else
                            G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + self.ability.extra.dollars
                            G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
                            return {
                                dollars = self.ability.extra.dollars,
                                card = self
                            }
                        end
                    end
                    if self.ability.name == 'Raised Fist' then
                        local temp_Mult, temp_ID = 15, 15
                        local raised_card = nil
                        for i=1, #G.hand.cards do
                            if temp_ID >= G.hand.cards[i].base.id and (G.hand.cards[i].ability.effect ~= 'Stone Card' and not G.hand.cards[i].config.center.no_rank) then 
                                temp_Mult = G.hand.cards[i].base.nominal
                                temp_ID = G.hand.cards[i].base.id
                                raised_card = G.hand.cards[i]
                            end
                        end
                        if raised_card == context.other_card then 
                            if context.other_card.debuff then
                                return {
                                    message = localize('k_debuffed'),
                                    colour = G.C.RED,
                                    card = self,
                                }
                            else
                                return {
                                    h_mult = temp_Mult * (2+((mult_level-1) * 1)),
                                    card = self,
                                }
                            end
                        end
                    end
            end
        elseif context.repetition then
            if context.cardarea == G.play then
                if self.ability.name == 'Sock and Buskin' and (
                context.other_card:is_face()) then
                    return {
                        message = localize('k_again_ex'),
                        repetitions = self.ability.extra,
                        card = self
                    }
                end
                if self.ability.name == 'Hanging Chad' and (
                context.other_card == context.scoring_hand[1]) then
                    return {
                        message = localize('k_again_ex'),
                        repetitions = self.ability.extra,
                        card = self
                    }
                end
                if self.ability.name == 'Dusk' and G.GAME.current_round.hands_left == 0 then
                    return {
                        message = localize('k_again_ex'),
                        repetitions = self.ability.extra,
                        card = self
                    }
                end
                if self.ability.name == 'Seltzer' then
                    return {
                        message = localize('k_again_ex'),
                        repetitions = effect_level,
                        card = self
                    }
                end
                if self.ability.name == 'Hack' and (
                context.other_card:get_id() == 2 or 
                context.other_card:get_id() == 3 or 
                context.other_card:get_id() == 4 or 
                context.other_card:get_id() == 5) then
                    return {
                        message = localize('k_again_ex'),
                        repetitions = self.ability.extra,
                        card = self
                    }
                end
            end
            if context.cardarea == G.hand then
                if self.ability.name == 'Mime' and
                (next(context.card_effects[1]) or #context.card_effects > 1) then
                    return {
                        message = localize('k_again_ex'),
                        repetitions = self.ability.extra,
                        card = self
                    }
                end
            end
        elseif context.other_joker then
            if self.ability.name == 'Baseball Card' and context.other_joker.config.center.rarity == 2 and self ~= context.other_joker then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        context.other_joker:juice_up(0.5, 0.5)
                        return true
                    end
                })) 
                return {
                    message = localize{type='variable',key='a_xmult',vars={self.ability.extra}},
                    Xmult_mod = self.ability.extra
                }
            end
        else
            if context.cardarea == G.jokers then
                if context.before then
                    if self.ability.name == 'Spare Trousers' and (next(context.poker_hands['Two Pair']) or next(context.poker_hands['Full House'])) and not context.blueprint then
                        self.ability.mult = self.ability.mult + self.ability.extra
                        return {
                            message = localize('k_upgrade_ex'),
                            colour = G.C.RED,
                            card = self
                        }
                    end
                    if self.ability.name == 'Space Joker' and pseudorandom('space') < G.GAME.probabilities.normal/self.ability.extra then
                        return {
                            card = self,
                            level_up = true,
                            message = localize('k_level_up_ex')
                        }
                    end
                    if self.ability.name == 'Square Joker' and #context.full_hand == 4 and not context.blueprint then
                        self.ability.extra.chips = self.ability.extra.chips + self.ability.extra.chip_mod
                        return {
                            message = localize('k_upgrade_ex'),
                            colour = G.C.CHIPS,
                            card = self
                        }
                    end
                    if self.ability.name == 'Runner' and next(context.poker_hands['Straight']) and not context.blueprint then
                        self.ability.extra.chips = self.ability.extra.chips + self.ability.extra.chip_mod
                        return {
                            message = localize('k_upgrade_ex'),
                            colour = G.C.CHIPS,
                            card = self
                        }
                    end
                    if self.ability.name == 'Midas Mask' and not context.blueprint then
                        local faces = {}
                        for k, v in ipairs(context.scoring_hand) do
                            if v:is_face() then 
                                faces[#faces+1] = v
                                v:set_ability(G.P_CENTERS.m_gold, nil, true)
                                G.E_MANAGER:add_event(Event({
                                    func = function()
                                        v:juice_up()
                                        return true
                                    end
                                })) 
                            end
                        end
                        if #faces > 0 then 
                            return {
                                message = localize('k_gold'),
                                colour = G.C.MONEY,
                                card = self
                            }
                        end
                    end
                    if self.ability.name == 'Vampire' and not context.blueprint then
                        local enhanced = {}
                        for k, v in ipairs(context.scoring_hand) do
                            if v.config.center ~= G.P_CENTERS.c_base and not v.debuff and not v.vampired then 
                                enhanced[#enhanced+1] = v
                                v.vampired = true
                                v:set_ability(G.P_CENTERS.c_base, nil, true)
                                G.E_MANAGER:add_event(Event({
                                    func = function()
                                        v:juice_up()
                                        v.vampired = nil
                                        return true
                                    end
                                })) 
                            end
                        end

                        if #enhanced > 0 then 
                            self.ability.x_mult = self.ability.x_mult + self.ability.extra*#enhanced
                            return {
                                message = localize{type='variable',key='a_xmult',vars={self.ability.x_mult}},
                                colour = G.C.MULT,
                                card = self
                            }
                        end
                    end
                    if self.ability.name == 'To Do List' and context.scoring_name == self.ability.to_do_poker_hand then
                        ease_dollars(self.ability.extra.dollars)
                        G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + self.ability.extra.dollars
                        G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
                        return {
                            message = localize('$')..self.ability.extra.dollars,
                            dollars = self.ability.extra.dollars,
                            colour = G.C.MONEY
                        }
                    end
                    if self.ability.name == 'DNA' and G.GAME.current_round.hands_played == 0 then
                        if #context.full_hand == 1 then
                            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                            local _card = copy_card(context.full_hand[1], nil, nil, G.playing_card)
                            _card:add_to_deck()
                            G.deck.config.card_limit = G.deck.config.card_limit + 1
                            table.insert(G.playing_cards, _card)
                            G.hand:emplace(_card)
                            _card.states.visible = nil

                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    _card:start_materialize()
                                    return true
                                end
                            })) 
                            return {
                                message = localize('k_copied_ex'),
                                colour = G.C.CHIPS,
                                card = self,
                                playing_cards_created = {true}
                            }
                        end
                    end
                    if self.ability.name == 'Ride the Bus' and not context.blueprint then
                        local faces = false
                        for i = 1, #context.scoring_hand do
                            if context.scoring_hand[i]:is_face() then faces = true end
                        end
                        if faces then
                            local last_mult = self.ability.mult
                            self.ability.mult = 0
                            if last_mult > 0 then 
                                return {
                                    card = self,
                                    message = localize('k_reset')
                                }
                            end
                        else
                            self.ability.mult = self.ability.mult + self.ability.extra
                        end
                    end
                    if self.ability.name == 'Obelisk' and not context.blueprint then
                        local reset = true
                        local play_more_than = (G.GAME.hands[context.scoring_name].played or 0)
                        for k, v in pairs(G.GAME.hands) do
                            if k ~= context.scoring_name and v.played >= play_more_than and v.visible then
                                reset = false
                            end
                        end
                        if reset then
                            if self.ability.x_mult > 1 then
                                self.ability.x_mult = 1
                                return {
                                    card = self,
                                    message = localize('k_reset')
                                }
                            end
                        else
                            self.ability.x_mult = self.ability.x_mult + self.ability.extra
                        end
                    end
                    if self.ability.name == 'Green Joker' and not context.blueprint then
                        self.ability.mult = self.ability.mult + self.ability.extra.hand_add
                        return {
                            card = self,
                            message = localize{type='variable',key='a_mult',vars={self.ability.extra.hand_add}}
                        }
                    end
                elseif context.after then
                    if self.ability.name == 'Ice Cream' and not context.blueprint then
                        if self.ability.extra.chips - self.ability.extra.chip_mod <= 0 then 
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    play_sound('tarot1')
                                    self.T.r = -0.2
                                    self:juice_up(0.3, 0.4)
                                    self.states.drag.is = true
                                    self.children.center.pinch.x = true
                                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                                        func = function()
                                                G.jokers:remove_card(self)
                                                self:remove()
                                                self = nil
                                            return true; end})) 
                                    return true
                                end
                            })) 
                            return {
                                message = localize('k_melted_ex'),
                                colour = G.C.CHIPS
                            }
                        else
                            self.ability.extra.chips = self.ability.extra.chips - self.ability.extra.chip_mod
                            return {
                                message = localize{type='variable',key='a_chips_minus',vars={self.ability.extra.chip_mod}},
                                colour = G.C.CHIPS
                            }
                        end
                    end
                    if self.ability.name == 'Seltzer' and not context.blueprint then
                        if self.ability.extra - 1 <= 0 then 
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    play_sound('tarot1')
                                    self.T.r = -0.2
                                    self:juice_up(0.3, 0.4)
                                    self.states.drag.is = true
                                    self.children.center.pinch.x = true
                                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                                        func = function()
                                                G.jokers:remove_card(self)
                                                self:remove()
                                                self = nil
                                            return true; end})) 
                                    return true
                                end
                            })) 
                            return {
                                message = localize('k_drank_ex'),
                                colour = G.C.FILTER
                            }
                        else
                            self.ability.extra = self.ability.extra - 1
                            return {
                                message = self.ability.extra..'',
                                colour = G.C.FILTER
                            }
                        end
                    end
                elseif context.joker_main then
                        if self.ability.name == 'Loyalty Card' then
                            self.ability.loyalty_remaining = (self.ability.extra.every-1-(G.GAME.hands_played - self.ability.hands_played_at_create))%(self.ability.extra.every+1)
                            if context.blueprint then
                                if self.ability.loyalty_remaining == self.ability.extra.every then
                                    return {
                                        message = localize{type='variable',key='a_xmult',vars={self.ability.extra.Xmult}},
                                        Xmult_mod = self.ability.extra.Xmult
                                    }
                                end
                            else
                                if self.ability.loyalty_remaining == 0 then
                                    local eval = function(card) return (card.ability.loyalty_remaining == 0) end
                                    juice_card_until(self, eval, true)
                                elseif self.ability.loyalty_remaining == self.ability.extra.every then
                                    return {
                                        message = localize{type='variable',key='a_xmult',vars={self.ability.extra.Xmult}},
                                        Xmult_mod = self.ability.extra.Xmult
                                    }
                                end
                            end
                        end
                        if self.ability.name ~= 'Seeing Double' and self.ability.x_mult > 1 and (self.ability.type == '' or next(context.poker_hands[self.ability.type])) then
                            return {
                                message = localize{type='variable',key='a_xmult',vars={self.ability.x_mult}},
                                colour = G.C.RED,
                                Xmult_mod = self.ability.x_mult
                            }
                        end
                        if self.ability.t_mult > 0 and next(context.poker_hands[self.ability.type]) then
                            return {
                                message = localize{type='variable',key='a_mult',vars={self.ability.t_mult}},
                                mult_mod = self.ability.t_mult
                            }
                        end
                        if self.ability.t_chips > 0 and next(context.poker_hands[self.ability.type]) then
                            return {
                                message = localize{type='variable',key='a_chips',vars={self.ability.t_chips}},
                                chip_mod = self.ability.t_chips
                            }
                        end
                        if self.ability.name == 'Half Joker' and #context.full_hand <= self.ability.extra.size then
                            return {
                                message = localize{type='variable',key='a_mult',vars={self.ability.extra.mult}},
                                mult_mod = self.ability.extra.mult
                            }
                        end
                        if self.ability.name == 'Abstract Joker' then
                            local x = 0
                            for i = 1, #G.jokers.cards do
                                if G.jokers.cards[i].ability.set == 'Joker' then x = x + 1 end
                            end
                            return {
                                message = localize{type='variable',key='a_mult',vars={x*self.ability.extra}},
                                mult_mod = x*self.ability.extra
                            }
                        end
                        if self.ability.name == 'Acrobat' and G.GAME.current_round.hands_left == 0 then
                            return {
                                message = localize{type='variable',key='a_xmult',vars={self.ability.extra}},
                                Xmult_mod = self.ability.extra
                            }
                        end
                        if self.ability.name == 'Mystic Summit' and G.GAME.current_round.discards_left == self.ability.extra.d_remaining then
                            return {
                                message = localize{type='variable',key='a_mult',vars={self.ability.extra.mult}},
                                mult_mod = self.ability.extra.mult
                            }
                        end
                        if self.ability.name == 'Misprint' then
                            local temp_Mult = pseudorandom('misprint', self.ability.extra.min, self.ability.extra.max)
                            return {
                                message = localize{type='variable',key='a_mult',vars={temp_Mult}},
                                mult_mod = temp_Mult
                            }
                        end
                        if self.ability.name == 'Banner' and G.GAME.current_round.discards_left > 0 then
                            return {
                                message = localize{type='variable',key='a_chips',vars={G.GAME.current_round.discards_left*self.ability.extra}},
                                chip_mod = G.GAME.current_round.discards_left*self.ability.extra
                            }
                        end
                        if self.ability.name == 'Stuntman' then
                            return {
                                message = localize{type='variable',key='a_chips',vars={self.ability.extra.chip_mod}},
                                chip_mod = self.ability.extra.chip_mod,
                            }
                        end
                        if self.ability.name == 'Matador' then
                            if G.GAME.blind.triggered then 
                                ease_dollars(self.ability.extra)
                                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + self.ability.extra
                                G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
                                return {
                                    message = localize('$')..self.ability.extra,
                                    dollars = self.ability.extra,
                                    colour = G.C.MONEY
                                }
                            end
                        end
                        if self.ability.name == 'Supernova' then
                            return {
                                message = localize{type='variable',key='a_mult',vars={G.GAME.hands[context.scoring_name].played}},
                                mult_mod = G.GAME.hands[context.scoring_name].played * mult_level
                            }
                        end
                        if self.ability.name == 'Ceremonial Dagger' and self.ability.mult > 0 then
                            return {
                                message = localize{type='variable',key='a_mult',vars={self.ability.mult}},
                                mult_mod = self.ability.mult
                            }
                        end
                        if self.ability.name == 'Vagabond' and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                            if G.GAME.dollars <= self.ability.extra then
                                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                                G.E_MANAGER:add_event(Event({
                                    trigger = 'before',
                                    delay = 0.0,
                                    func = (function()
                                            for i = 1, effect_level do
                                            if #G.consumeables.cards < G.consumeables.config.card_limit then
                                            local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, nil, 'vag')
                                            card:add_to_deck()
                                            G.consumeables:emplace(card)
                                            G.GAME.consumeable_buffer = 0
                                            end
                                            end
                                        return true
                                    end)}))
                                return {
                                    message = localize('k_plus_tarot'),
                                    card = self
                                }
                            end
                        end
                        if self.ability.name == 'Superposition' and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                            local aces = 0
                            for i = 1, #context.scoring_hand do
                                if context.scoring_hand[i]:get_id() == 14 then aces = aces + 1 end
                            end
                            if aces >= 1 and next(context.poker_hands["Straight"]) then
                                local card_type = 'Tarot'
                                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                                G.E_MANAGER:add_event(Event({
                                    trigger = 'before',
                                    delay = 0.0,
                                    func = (function()
                                            for i = 1, effect_level do
                                            if #G.consumeables.cards < G.consumeables.config.card_limit then
                                            local card = create_card(card_type,G.consumeables, nil, nil, nil, nil, nil, 'sup')
                                            card:add_to_deck()
                                            G.consumeables:emplace(card)
                                            G.GAME.consumeable_buffer = 0
                                            end
                                            end
                                        return true
                                    end)}))
                                return {
                                    message = localize('k_plus_tarot'),
                                    colour = G.C.SECONDARY_SET.Tarot,
                                    card = self
                                }
                            end
                        end
                        if self.ability.name == 'Seance' and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                            if next(context.poker_hands[self.ability.extra.poker_hand]) then
                                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                                G.E_MANAGER:add_event(Event({
                                    trigger = 'before',
                                    delay = 0.0,
                                    func = (function()
                                            for i = 1, effect_level do
                                            if #G.consumeables.cards < G.consumeables.config.card_limit then
                                            local card = create_card('Spectral',G.consumeables, nil, nil, nil, nil, nil, 'sea')
                                            card:add_to_deck()
                                            G.consumeables:emplace(card)
                                            G.GAME.consumeable_buffer = 0
                                            end
                                            end
                                        return true
                                    end)}))
                                return {
                                    message = localize('k_plus_spectral'),
                                    colour = G.C.SECONDARY_SET.Spectral,
                                    card = self
                                }
                            end
                        end
                        if self.ability.name == 'Flower Pot' then
                            local suits = {
                                ['Hearts'] = 0,
                                ['Diamonds'] = 0,
                                ['Spades'] = 0,
                                ['Wilds'] = 0,
                                ['Clubs'] = 0
                            }
                            for i = 1, #context.scoring_hand do
                                if context.scoring_hand[i].ability.name ~= 'Wild Card' and not context.scoring_hand[i].config.center.any_suit then
                                    if xmult_level == 1 then
                                    if context.scoring_hand[i]:is_suit('Hearts', true) and suits["Hearts"] == 0 then suits["Hearts"] = suits["Hearts"] + 1
                                    elseif context.scoring_hand[i]:is_suit('Diamonds', true) and suits["Diamonds"] == 0  then suits["Diamonds"] = suits["Diamonds"] + 1
                                    elseif context.scoring_hand[i]:is_suit('Spades', true) and suits["Spades"] == 0  then suits["Spades"] = suits["Spades"] + 1
                                    elseif context.scoring_hand[i]:is_suit('Clubs', true) and suits["Clubs"] == 0  then suits["Clubs"] = suits["Clubs"] + 1 end
                                    elseif xmult_level >= 2 then
                                      if context.scoring_hand[i]:is_suit('Hearts') and suits["Hearts"] == 0 then suits["Hearts"] = suits["Hearts"] + 1 end
                                      if context.scoring_hand[i]:is_suit('Diamonds') and suits["Diamonds"] == 0 then suits["Diamonds"] = suits["Diamonds"] + 1 end
                                      if context.scoring_hand[i]:is_suit('Spades') and suits["Spades"] == 0 then suits["Spades"] = suits["Spades"] + 1 end
                                      if context.scoring_hand[i]:is_suit('Clubs') and suits["Clubs"] == 0 then suits["Clubs"] = suits["Clubs"] + 1 end
                                    end
                                end
                            end
                            for i = 1, #context.scoring_hand do
                                if context.scoring_hand[i].ability.name == 'Wild Card' or context.scoring_hand[i].config.center.any_suit then
                                if xmult_level >= 2 then suits["Wilds"] = suits["Wilds"] + 1 end
                                    if context.scoring_hand[i]:is_suit('Hearts') and suits["Hearts"] == 0 then suits["Hearts"] = suits["Hearts"] + 1
                                    elseif context.scoring_hand[i]:is_suit('Diamonds') and suits["Diamonds"] == 0  then suits["Diamonds"] = suits["Diamonds"] + 1
                                    elseif context.scoring_hand[i]:is_suit('Spades') and suits["Spades"] == 0  then suits["Spades"] = suits["Spades"] + 1
                                    elseif context.scoring_hand[i]:is_suit('Clubs') and suits["Clubs"] == 0  then suits["Clubs"] = suits["Clubs"] + 1 end
                                end
                            end
                            if (suits["Hearts"] > 0 and
                            suits["Diamonds"] > 0 and
                            suits["Spades"] > 0 and
                            suits["Clubs"] > 0) or (suits["Wilds"] > 0) then
                                return {
                                    message = localize{type='variable',key='a_xmult',vars={self.ability.extra}},
                                    Xmult_mod = self.ability.extra
                                }
                            end
                        end
                        if self.ability.name == 'Seeing Double' then
                            local suits = {
                                ['Hearts'] = 0,
                                ['Diamonds'] = 0,
                                ['Spades'] = 0,
                                ['Wilds'] = 0,
                                ['Clubs'] = 0
                            }
                            for i = 1, #context.scoring_hand do
                                if context.scoring_hand[i].ability.name ~= 'Wild Card' and not context.scoring_hand[i].config.center.any_suit then
                                    if context.scoring_hand[i]:is_suit('Hearts') then suits["Hearts"] = suits["Hearts"] + 1 end
                                    if context.scoring_hand[i]:is_suit('Diamonds') then suits["Diamonds"] = suits["Diamonds"] + 1 end
                                    if context.scoring_hand[i]:is_suit('Spades') then suits["Spades"] = suits["Spades"] + 1 end
                                    if context.scoring_hand[i]:is_suit('Clubs') then suits["Clubs"] = suits["Clubs"] + 1 end
                                end
                            end
                            for i = 1, #context.scoring_hand do
                                if context.scoring_hand[i].ability.name == 'Wild Card' or context.scoring_hand[i].config.center.any_suit then
                                if xmult_level >= 2 then suits["Wilds"] = suits["Wilds"] + 1 end
                                    if context.scoring_hand[i]:is_suit('Clubs') and suits["Clubs"] == 0 then suits["Clubs"] = suits["Clubs"] + 1
                                    elseif context.scoring_hand[i]:is_suit('Diamonds') and suits["Diamonds"] == 0  then suits["Diamonds"] = suits["Diamonds"] + 1
                                    elseif context.scoring_hand[i]:is_suit('Spades') and suits["Spades"] == 0  then suits["Spades"] = suits["Spades"] + 1
                                    elseif context.scoring_hand[i]:is_suit('Hearts') and suits["Hearts"] == 0  then suits["Hearts"] = suits["Hearts"] + 1 end
                                end
                            end
                            if ((suits["Hearts"] > 0 or
                            suits["Diamonds"] > 0 or
                            suits["Spades"] > 0) and
                            suits["Clubs"] > 0) or (suits["Wilds"] > 0) then
                                return {
                                    message = localize{type='variable',key='a_xmult',vars={self.ability.extra}},
                                    Xmult_mod = self.ability.extra
                                }
                            end
                        end
                        if self.ability.name == 'Wee Joker' then
                            return {
                                message = localize{type='variable',key='a_chips',vars={self.ability.extra.chips}},
                                chip_mod = self.ability.extra.chips, 
                                colour = G.C.CHIPS
                            }
                        end
                        if self.ability.name == 'Castle' and (self.ability.extra.chips > 0) then
                            return {
                                message = localize{type='variable',key='a_chips',vars={self.ability.extra.chips}},
                                chip_mod = self.ability.extra.chips, 
                                colour = G.C.CHIPS
                            }
                        end
                        if self.ability.name == 'Blue Joker' and #G.deck.cards > 0 then
                            return {
                                message = localize{type='variable',key='a_chips',vars={self.ability.extra*#G.deck.cards}},
                                chip_mod = self.ability.extra*#G.deck.cards, 
                                colour = G.C.CHIPS
                            }
                        end
                        if self.ability.name == 'Erosion' and (G.GAME.starting_deck_size - #G.playing_cards) > 0 then
                            return {
                                message = localize{type='variable',key='a_mult',vars={self.ability.extra*(G.GAME.starting_deck_size - #G.playing_cards)}},
                                mult_mod = self.ability.extra*(G.GAME.starting_deck_size - #G.playing_cards), 
                                colour = G.C.MULT
                            }
                        end
                        if self.ability.name == 'Square Joker' then
                            return {
                                message = localize{type='variable',key='a_chips',vars={self.ability.extra.chips}},
                                chip_mod = self.ability.extra.chips, 
                                colour = G.C.CHIPS
                            }
                        end
                        if self.ability.name == 'Runner' then
                            return {
                                message = localize{type='variable',key='a_chips',vars={self.ability.extra.chips}},
                                chip_mod = self.ability.extra.chips, 
                                colour = G.C.CHIPS
                            }
                        end
                        if self.ability.name == 'Ice Cream' then
                            return {
                                message = localize{type='variable',key='a_chips',vars={self.ability.extra.chips}},
                                chip_mod = self.ability.extra.chips, 
                                colour = G.C.CHIPS
                            }
                        end
                        if self.ability.name == 'Stone Joker' and self.ability.stone_tally > 0 then
                            return {
                                message = localize{type='variable',key='a_chips',vars={self.ability.extra*self.ability.stone_tally}},
                                chip_mod = self.ability.extra*self.ability.stone_tally, 
                                colour = G.C.CHIPS
                            }
                        end
                        if self.ability.name == 'Steel Joker' and self.ability.steel_tally > 0 then
                            return {
                                message = localize{type='variable',key='a_xmult',vars={1 + self.ability.extra*self.ability.steel_tally}},
                                Xmult_mod = 1 + self.ability.extra*self.ability.steel_tally, 
                                colour = G.C.MULT
                            }
                        end
                        if self.ability.name == 'Bull' and (G.GAME.dollars + (G.GAME.dollar_buffer or 0)) > 0 then
                            return {
                                message = localize{type='variable',key='a_chips',vars={self.ability.extra*math.max(0,(G.GAME.dollars + (G.GAME.dollar_buffer or 0))) }},
                                chip_mod = self.ability.extra*math.max(0,(G.GAME.dollars + (G.GAME.dollar_buffer or 0))), 
                                colour = G.C.CHIPS
                            }
                        end
                        if self.ability.name == "Driver's License" then
                            if (self.ability.driver_tally or 0) >= math.max(0, (16 - (xmult_level-1)*2)) then 
                                return {
                                    message = localize{type='variable',key='a_xmult',vars={self.ability.extra}},
                                    Xmult_mod = self.ability.extra
                                }
                            end
                        end
                        if self.ability.name == "Blackboard" then
                            local black_suits, all_cards = 0, 0
                            for k, v in ipairs(G.hand.cards) do
                                all_cards = all_cards + 1
                                if v:is_suit('Clubs', nil, true) or v:is_suit('Spades', nil, true) then
                                    black_suits = black_suits + 1
                                end
                            end
                            if black_suits == all_cards then 
                                return {
                                    message = localize{type='variable',key='a_xmult',vars={self.ability.extra}},
                                    Xmult_mod = self.ability.extra
                                }
                            end
                        end
                        if self.ability.name == "Joker Stencil" then
                            if (G.jokers.config.card_limit - #G.jokers.cards) > 0 then
                                return {
                                    message = localize{type='variable',key='a_xmult',vars={self.ability.x_mult}},
                                    Xmult_mod = self.ability.x_mult
                                }
                            end
                        end
                        if self.ability.name == 'Swashbuckler' and self.ability.mult > 0 then
                            return {
                                message = localize{type='variable',key='a_mult',vars={self.ability.mult}},
                                mult_mod = self.ability.mult
                            }
                        end
                        if self.ability.name == 'Joker' then
                            return {
                                message = localize{type='variable',key='a_mult',vars={self.ability.mult}},
                                mult_mod = self.ability.mult
                            }
                        end
                        if self.ability.name == 'Spare Trousers' and self.ability.mult > 0 then
                            return {
                                message = localize{type='variable',key='a_mult',vars={self.ability.mult}},
                                mult_mod = self.ability.mult
                            }
                        end
                        if self.ability.name == 'Ride the Bus' and self.ability.mult > 0 then
                            return {
                                message = localize{type='variable',key='a_mult',vars={self.ability.mult}},
                                mult_mod = self.ability.mult
                            }
                        end
                        if self.ability.name == 'Flash Card' and self.ability.mult > 0 then
                            return {
                                message = localize{type='variable',key='a_mult',vars={self.ability.mult}},
                                mult_mod = self.ability.mult
                            }
                        end
                        if self.ability.name == 'Popcorn' and self.ability.mult > 0 then
                            return {
                                message = localize{type='variable',key='a_mult',vars={self.ability.mult}},
                                mult_mod = self.ability.mult
                            }
                        end
                        if self.ability.name == 'Green Joker' and self.ability.mult > 0 then
                            return {
                                message = localize{type='variable',key='a_mult',vars={self.ability.mult}},
                                mult_mod = self.ability.mult
                            }
                        end
                        if self.ability.name == 'Fortune Teller' and G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.tarot > 0 then
                            return {
                                message = localize{type='variable',key='a_mult',vars={G.GAME.consumeable_usage_total.tarot}},
                                mult_mod = G.GAME.consumeable_usage_total.tarot
                            }
                        end
                        if self.ability.name == 'Gros Michel' then
                            return {
                                message = localize{type='variable',key='a_mult',vars={self.ability.extra.mult}},
                                mult_mod = self.ability.extra.mult,
                            }
                        end
                        if self.ability.name == 'Cavendish' then
                            return {
                                message = localize{type='variable',key='a_xmult',vars={self.ability.extra.Xmult}},
                                Xmult_mod = self.ability.extra.Xmult,
                            }
                        end
                        if self.ability.name == 'Red Card' and self.ability.mult > 0 then
                            return {
                                message = localize{type='variable',key='a_mult',vars={self.ability.mult}},
                                mult_mod = self.ability.mult
                            }
                        end
                        if self.ability.name == 'Card Sharp' and G.GAME.hands[context.scoring_name] and G.GAME.hands[context.scoring_name].played_this_round > 1 then
                            return {
                                message = localize{type='variable',key='a_xmult',vars={self.ability.extra.Xmult}},
                                Xmult_mod = self.ability.extra.Xmult,
                            }
                        end
                        if self.ability.name == 'Bootstraps' and math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/self.ability.extra.dollars) >= 1 then 
                            return {
                                message = localize{type='variable',key='a_mult',vars={self.ability.extra.mult*math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/self.ability.extra.dollars)}},
                                mult_mod = self.ability.extra.mult*math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/self.ability.extra.dollars)
                            }
                        end
                        if self.ability.name == 'Caino' and self.ability.caino_xmult > 1 then 
                            return {
                                message = localize{type='variable',key='a_xmult',vars={self.ability.caino_xmult}},
                                Xmult_mod = self.ability.caino_xmult
                            }
                        end
                    end
                end
            end
        end

-------------------------------------------------------------------
--@@@--@-@--@@@--@@---@-@-@--@@---@@@--@@@--@@@-----@@@--@@@--@@---
--@-@--@-@--@----@-@--@-@-@--@-@---@----@---@-------@----@-@--@-@--
--@-@--@-@--@@---@@---@-@-@--@@----@----@---@@------@@---@-@--@-@--
--@-@--@-@--@----@-@--@-@-@--@-@---@----@---@-------@----@-@--@-@--
--@@@---@---@@@--@-@--@@@@@--@-@--@@@---@---@@@-----@@@--@-@--@@---
-------------------------------------------------------------------

  end
end


-- Level 2 Ancient Joker
function reset_ancient_card()
  if xmult_level == 1 then
    local ancient_suits = {}
    for k, v in ipairs({'Spades','Hearts','Clubs','Diamonds'}) do
      if v ~= G.GAME.current_round.ancient_card.suit then ancient_suits[#ancient_suits + 1] = v end
    end
    local ancient_card = pseudorandom_element(ancient_suits, pseudoseed('anc'..G.GAME.round_resets.ante))
    G.GAME.current_round.ancient_card.suit = ancient_card
  elseif xmult_level >= 2 then
    G.GAME.current_round.ancient_card.suit = 'Spades'
    local valid_ancient_cards = {}
    for k, v in ipairs(G.playing_cards) do
      if v.ability.effect ~= 'Stone Card' then
        valid_ancient_cards[#valid_ancient_cards+1] = v
      end
    end
    if valid_ancient_cards[1] then 
      local ancient_card = pseudorandom_element(valid_ancient_cards, pseudoseed('anc'..G.GAME.round_resets.ante))
      G.GAME.current_round.ancient_card.suit = ancient_card.base.suit
    end
  end
end


-- Define the Level 2, Level 3, and Level 4 decks
local lvl2deck = {
  object_type = "Back",
  name = "Level 2 Deck",
  key = "lvl2deck",
  config = {level = 2},
  pos = {x = 0, y = 6},
  loc = {
    name = "Level 2 Deck",
    text = {
      "Everything starts",
      "at level {C:attention}2{}"     
    }
  },
  atlas = atlasdeck
}

local lvl3deck = {
  object_type = "Back",
  name = "Level 3 Deck",
  key = "lvl3deck",
  config = {level = 3},
  pos = {x = 1, y = 6},
  loc = {
    name = "Level 3 Deck",
    text = {
      "Everything starts",
      "at level {C:attention}3{}"     
    }
  },
  atlas = atlasdeck
}

local lvl4deck = {
  object_type = "Back",
  name = "Level 4 Deck",
  key = "lvl4deck",
  config = {level = 4},
  pos = {x = 2, y = 6},
  loc = {
    name = "Level 4 Deck",
    text = {
      "Everything starts",
      "at level {C:attention}4{}"     
    }
  },
  atlas = atlasdeck
}

-- Overwriting save_run to include stored level information
function save_run()
  if G.F_NO_SAVING == true then return end
  local cardAreas = {}
  for k, v in pairs(G) do
    if (type(v) == "table") and v.is and v:is(CardArea) then 
      local cardAreaSer = v:save()
      if cardAreaSer then cardAreas[k] = cardAreaSer end
    end
  end

  local tags = {}
  for k, v in ipairs(G.GAME.tags) do
    if (type(v) == "table") and v.is and v:is(Tag) then 
      local tagSer = v:save()
      if tagSer then tags[k] = tagSer end
    end
  end

  G.culled_table =  recursive_table_cull{
    cardAreas = cardAreas,
    tags = tags,
    GAME = G.GAME,
    STATE = G.STATE,
    LEVEL = {
      mult = mult_level,
      xmult = xmult_level,
      chips = chips_level,
      econ = econ_level,
      effect = effect_level,
      tarot = tarot_level,
      planet = planet_level,
      spectral = spectral_level,
      enhance = enhance_level,
      edition = edition_level,
      pack = pack_level,
      tag = tag_level,
      voucher = voucher_level,
      blind = blind_level,
      blind_old = blind_level_old,
      out = out_of_blind,
      luchador = luchadors_sold
    },
    ACTION = G.action or nil,
    BLIND = G.GAME.blind:save(),
    BACK = G.GAME.selected_back:save(),
    VERSION = G.VERSION
  }
  G.ARGS.save_run = G.culled_table

  G.FILE_HANDLER = G.FILE_HANDLER or {}
  G.FILE_HANDLER.run = true
  G.FILE_HANDLER.update_queued = true
end


-- BLINDS

-- Overwriting for Serpent and negative levels of Hook
G.FUNCS.draw_from_deck_to_hand = function(e)
  if not (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and
    G.hand.config.card_limit <= 0 and #G.hand.cards == 0 then 
    G.STATE = G.STATES.GAME_OVER; G.STATE_COMPLETE = false 
  return true
  end
  local hand_space = e
  if not hand_space then
    local limit = G.hand.config.card_limit - #G.hand.cards
    local n = 0
    while n < #G.deck.cards do
      local card = G.deck.cards[#G.deck.cards-n]
      limit = limit - 1 + (card.edition and card.edition.card_limit or 0)
      if limit < 0 then break end
      n = n + 1
    end
    hand_space = n
  end
  if G.GAME.blind.name == 'The Serpent' and
  (not (blind_level <= 0)) and
  (G.GAME.current_round.hands_played > 0 or
  G.GAME.current_round.discards_used > 0) then
    hand_space = math.min(#G.deck.cards, 2 + blind_level)
  end
  delay(0.3)
  for i=1, hand_space do --draw cards from deckL
    if G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK then 
      draw_card(G.deck,G.hand, i*100/hand_space,'up', true)
    else
      draw_card(G.deck,G.hand, i*100/hand_space,'up', true)
    end
  end
end

-- Hooking for minus chips, minus mult, XChips
card_eval_status_text_ref = card_eval_status_text
function card_eval_status_text(card, eval_type, amt, percent, dir, extra)
  if eval_type == "minus_chips" or eval_type == "minus_mult" or eval_type == "xchips" or eval_type == "div_mult" or eval_type == "div_chips" or eval_type == "again" then
    percent = percent or (0.9 + 0.2*math.random())
    if dir == 'down' then 
      percent = 1-percent
    end
    if extra and extra.focus then card = extra.focus end
    local text = ''
    local sound = nil
    local volume = 1
    local card_aligned = 'bm'
    local y_off = 0.15*G.CARD_H
    if card.area == G.jokers or card.area == G.consumeables then
      y_off = 0.05*card.T.h
    elseif card.area == G.hand then
      y_off = -0.05*G.CARD_H
      card_aligned = 'tm'
    elseif card.area == G.play then
      y_off = -0.05*G.CARD_H
      card_aligned = 'tm'
    elseif card.jimbo then
      y_off = -0.05*G.CARD_H
      card_aligned = 'tm'
    end
    local config = {}
    local delay = 0.65
    local colour = config.colour or (extra and extra.colour) or ( G.C.FILTER )
    local extrafunc = nil

    if eval_type == 'minus_chips' then 
      sound = 'cancel'
      amt = amt
      colour = G.C.RED
      text = localize{type='variable',key='a_chips_minus',vars={amt}}
      delay = 0.6
    elseif eval_type == 'minus_mult' then 
      sound = 'cancel'
      amt = amt
      colour = G.C.RED
      text = localize{type='variable',key='a_mult_minus',vars={amt}}
      delay = 0.6
    elseif eval_type == 'div_mult' then 
      sound = 'cancel'
      amt = amt
      colour = G.C.RED
      text = localize{type='variable',key='a_xmult',vars={amt}}
      delay = 0.6
    elseif eval_type == 'xchips' then 
      sound = 'chips2'
      amt = amt
      colour = G.C.CHIPS
      text = localize{type='variable',key='a_xchips',vars={amt}}
      delay = 0.6
    elseif eval_type == 'div_chips' then 
      sound = 'cancel'
      amt = amt
      colour = G.C.RED
      text = localize{type='variable',key='a_xchips',vars={amt}}
      delay = 0.6
    elseif eval_type == 'again' then 
      G.E_MANAGER:add_event(Event({
        trigger = 'before',
        delay = 0.6,
        func = function()
        attention_text({
          text = localize('k_again_ex'),
          scale = 0.8, 
          hold = 0.4,
          backdrop_colour = G.C.ORANGE,
          align = card_aligned,
          major = card,
          offset = {x = 0, y = y_off}
        })
        play_sound(generic1, 0.8+percent*0.2, volume)
        if not extra or not extra.no_juice then
          card:juice_up(0.6, 0.1)
          G.ROOM.jiggle = G.ROOM.jiggle + 0.7
        end
        return true
        end
      }))
    end
    
    if amt > 0 or amt < 0 then
      if extra and extra.instant then
        if extrafunc then extrafunc() end
        attention_text({
          text = text,
          scale = config.scale or 1, 
          hold = delay - 0.2,
          backdrop_colour = colour,
          align = card_aligned,
          major = card,
          offset = {x = 0, y = y_off}
        })
        play_sound(sound, 0.8+percent*0.2, volume)
        if not extra or not extra.no_juice then
          card:juice_up(0.6, 0.1)
          G.ROOM.jiggle = G.ROOM.jiggle + 0.7
        end
      else
        G.E_MANAGER:add_event(Event({ --Add bonus chips from this card
          trigger = 'before',
          delay = delay,
          func = function()
          if extrafunc then extrafunc() end
          attention_text({
            text = text,
            scale = config.scale or 1, 
            hold = delay - 0.2,
            backdrop_colour = colour,
            align = card_aligned,
            major = card,
            offset = {x = 0, y = y_off}
          })
          play_sound(sound, 0.8+percent*0.2, volume)
          if not extra or not extra.no_juice then
            card:juice_up(0.6, 0.1)
            G.ROOM.jiggle = G.ROOM.jiggle + 0.7
          end
          return true
          end
        }))
      end
    end
    if extra and extra.playing_cards_created then 
      playing_card_joker_effects(extra.playing_cards_created)
    end
  else
    card_eval_status_text_ref(card, eval_type, amt, percent, dir, extra)
  end
end

function eval_card(card, context)
    context = context or {}
    local ret = {}

    if context.repetition_only then
        local seals = card:calculate_seal(context)
        if seals then
            ret.seals = seals
        end
        return ret
    end
    
    if context.cardarea == G.play then
        local chips = card:get_chip_bonus()
        if chips ~= 0 then 
            ret.chips = chips
        end

        local mult = card:get_chip_mult()
        if mult ~= 0 then 
            ret.mult = mult
        end

        local x_mult = card:get_chip_x_mult(context)
        if x_mult > 0 then 
            ret.x_mult = x_mult
        end

        local x_chips = card:get_chip_x_chips()
        if x_chips > 0 then 
            ret.x_chips = x_chips
        end

        local p_dollars = card:get_p_dollars()
        if p_dollars ~= 0 then 
            ret.p_dollars = p_dollars
        end

        local jokers = card:calculate_joker(context)
        if jokers then 
            ret.jokers = jokers
        end

        local edition = card:get_edition(context)
        if edition then 
            ret.edition = edition
        end
    end

    if context.cardarea == G.hand then
        local h_mult = card:get_chip_h_mult()
        if h_mult ~= 0 then 
            ret.h_mult = h_mult
        end

        local h_x_mult = card:get_chip_h_x_mult()
        if h_x_mult > 0 then 
            ret.x_mult = h_x_mult
        end

        local jokers = card:calculate_joker(context)
        if jokers then 
            ret.jokers = jokers
        end
    end

    if context.cardarea == G.jokers or context.card == G.consumeables then
        local jokers = nil
        if context.edition then
            jokers = card:get_edition(context)
        elseif context.other_joker then
            jokers = context.other_joker:calculate_joker(context)
        else
            jokers = card:calculate_joker(context)
        end
        if jokers then 
            ret.jokers = jokers
        end
    end

    return ret
end

-- Overwriting for Cerulean Bell and Crimson Heart
function Blind:drawn_to_hand()
    if not self.disabled then
        local obj = self.config.blind
        if obj.drawn_to_hand and type(obj.drawn_to_hand) == 'function' then
        	obj:drawn_to_hand()
        end
        if self.name == 'Cerulean Bell' and G.hand.cards[1] and ((blind_level == 1) or (blind_level >= 2 and #G.hand.cards <= 1)) then
            local any_forced = nil
            for k, v in ipairs(G.hand.cards) do
                v.cerulean1 = nil
                v.cerulean2 = nil
                if v.ability.forced_selection then
                    any_forced = true
                end
            end
            if not any_forced then 
                G.hand:unhighlight_all()
                local forced_card = pseudorandom_element(G.hand.cards, pseudoseed('cerulean_bell'))
                forced_card.ability.forced_selection = true
                forced_card.cerulean1 = true
                G.hand:add_to_highlighted(forced_card)
            end
        elseif self.name == 'Cerulean Bell' and blind_level >= 2 and #G.hand.cards >= 2 then
            local any_forced = nil
            for k, v in ipairs(G.hand.cards) do
                v.cerulean1 = nil
                v.cerulean2 = nil
                if v.ability.forced_selection then
                    any_forced = true
                end
            end
            if not any_forced then 
                G.hand:unhighlight_all()
                local forced_card1 = pseudorandom_element(G.hand.cards, pseudoseed('cerulean_bell'))
                local forced_card2 = pseudorandom_element(G.hand.cards, pseudoseed('cerulean_bell'))
                forced_card1.ability.forced_selection = true
                forced_card2.ability.forced_selection = true
                forced_card1.cerulean1 = true
                forced_card2.cerulean2 = true
                G.hand:add_to_highlighted(forced_card1)
                G.hand:add_to_highlighted(forced_card2)
            end
        end
        if self.name == 'Crimson Heart' and self.prepped and G.jokers.cards[1] and ((blind_level == 1) or (blind_level >= 2 and #G.jokers.cards <= 1)) then
            local prev_chosen_set = {}
            local fallback_jokers = {}
            local jokers = {}
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.crimson_heart_chosen then
                    G.jokers.cards[i].crimson1 = nil
                    G.jokers.cards[i].crimson2 = nil
                    prev_chosen_set[G.jokers.cards[i]] = true
                    G.jokers.cards[i].ability.crimson_heart_chosen = nil
                    if G.jokers.cards[i].debuff then SMODS.recalc_debuff(G.jokers.cards[i]) end
                end
            end
            for i = 1, #G.jokers.cards do
                if not G.jokers.cards[i].debuff then
                    if not prev_chosen_set[G.jokers.cards[i]] then
                        jokers[#jokers+1] = G.jokers.cards[i]
                    end
                    table.insert(fallback_jokers, G.jokers.cards[i])
                end
            end
            if #jokers == 0 then jokers = fallback_jokers end 
            local _card = pseudorandom_element(jokers, pseudoseed('crimson_heart'))
            if _card then
                _card.ability.crimson_heart_chosen = true
                _card.crimson1 = true
                SMODS.recalc_debuff(_card)
                _card:juice_up()
                self:wiggle()
            end
        elseif self.name == 'Crimson Heart' and self.prepped and blind_level >= 2 and #G.jokers.cards >= 2 then
            local prev_chosen_set = {}
            local fallback_jokers = {}
            local jokers = {}
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.crimson_heart_chosen then
                    G.jokers.cards[i].crimson1 = nil
                    G.jokers.cards[i].crimson2 = nil
                    prev_chosen_set[G.jokers.cards[i]] = true
                    G.jokers.cards[i].ability.crimson_heart_chosen = nil
                    if G.jokers.cards[i].debuff then SMODS.recalc_debuff(G.jokers.cards[i]) end
                end
            end
            for i = 1, #G.jokers.cards do
                if not G.jokers.cards[i].debuff then
                    if not prev_chosen_set[G.jokers.cards[i]] then
                        jokers[#jokers+1] = G.jokers.cards[i]
                    end
                    table.insert(fallback_jokers, G.jokers.cards[i])
                end
            end
            if #jokers == 0 then jokers = fallback_jokers end 
            local _card1 = pseudorandom_element(jokers, pseudoseed('crimson_heart'))
            local _card2 = pseudorandom_element(jokers, pseudoseed('crimson_heart'))
            if _card1 then
                _card1.ability.crimson_heart_chosen = true
                _card1.crimson1 = true
                SMODS.recalc_debuff(_card1)
                _card1:juice_up()
                self:wiggle()
            end
            if _card2 then
                _card2.ability.crimson_heart_chosen = true
                _card2.crimson2 = true
                SMODS.recalc_debuff(_card2)
                _card2:juice_up()
                self:wiggle()
            end
        end
    end
    self.prepped = nil
end

-- Matador triggers on:
-- Hook (NEW)
-- Ox
-- House (NEW)
-- Wall (direct)
-- Wheel (NEW)
-- Arm
-- Club
-- Fish (NEW)
-- Psychic
-- Goad
-- Water (direct)
-- Window
-- Manacle (direct)
-- Eye
-- Mouth
-- Plant
-- Serpent (NEW)
-- Pillar
-- Needle (direct)
-- Head
-- Tooth
-- Flint
-- Mark (NEW)
-- Amber Acorn (direct)
-- Verdant Leaf
-- Violet Vessel (direct)
-- Crimson Heart (direct)
-- Cerulean Bell (direct)

-- STEAMODDED overwrites all of the function files (button_callbacks.lua, common_events.lua, misc_functions.lua, state_events.lua, and UI_definitions.lua), meaning that
-- I can't just use Lovely to overwrite a part of these files. Hooking for G.FUNCS.evaluate_play also doesn't work, since the part that needs to be hooked is
-- inside a for loop. Because of this, I am doing a second massive overwrite.

-----------------------------------------------------------------------------
--@@@--@-@--@@@--@@---@-@-@--@@---@@@--@@@--@@@-----@@@--@@@--@@@--@@---@@@-----
--@-@--@-@--@----@-@--@-@-@--@-@---@----@---@-------@-----@---@-@--@-@---@---
--@-@--@-@--@@---@@---@-@-@--@@----@----@---@@------@@@---@---@@@--@@----@---
--@-@--@-@--@----@-@--@-@-@--@-@---@----@---@---------@---@---@-@--@-@---@---
--@@@---@---@@@--@-@--@@@@@--@-@--@@@---@---@@@-----@@@---@---@-@--@-@---@---
-----------------------------------------------------------------------------

G.FUNCS.play_cards_from_highlighted = function(e)
    if G.play and G.play.cards[1] then return end
    --check the hand first

    stop_use()
    G.GAME.blind.triggered = false
    G.CONTROLLER.interrupt.focus = true
    G.CONTROLLER:save_cardarea_focus('hand')

    for k, v in ipairs(G.playing_cards) do
        v.ability.forced_selection = nil
    end
    
    table.sort(G.hand.highlighted, function(a,b) return a.T.x < b.T.x end)

    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            G.STATE = G.STATES.HAND_PLAYED
            G.STATE_COMPLETE = true
            return true
        end
    }))
    inc_career_stat('c_cards_played', #G.hand.highlighted)
    inc_career_stat('c_hands_played', 1)
    ease_hands_played(-1)
    delay(0.4)

        for i=1, #G.hand.highlighted do

            -- Matador now triggers on face-down cards
            if G.hand.highlighted[i].facing == 'back' then
              G.GAME.blind.triggered = true
            end

            if G.hand.highlighted[i]:is_face() then inc_career_stat('c_face_cards_played', 1) end
            G.hand.highlighted[i].base.times_played = G.hand.highlighted[i].base.times_played + 1
            G.hand.highlighted[i].ability.played_this_ante = true
            G.GAME.round_scores.cards_played.amt = G.GAME.round_scores.cards_played.amt + 1
            draw_card(G.hand, G.play, i*100/#G.hand.highlighted, 'up', nil, G.hand.highlighted[i])
        end

        check_for_unlock({type = 'run_card_replays'})

        if G.GAME.blind:press_play() then
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = (function()
                    G.GAME.blind:juice_up()
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                        play_sound('tarot2', 0.76, 0.4);return true end}))
                    play_sound('tarot2', 1, 0.4)
                    return true
                end)
            }))
            delay(0.4)
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = (function()
                check_for_unlock({type = 'hand_contents', cards = G.play.cards})

                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
                        G.FUNCS.evaluate_play()
                        return true
                    end
                }))

                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                        check_for_unlock({type = 'play_all_hearts'})
                        G.FUNCS.draw_from_play_to_discard()
                        G.GAME.hands_played = G.GAME.hands_played + 1
                        G.GAME.current_round.hands_played = G.GAME.current_round.hands_played + 1
                        return true
                    end
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
                        G.STATE_COMPLETE = false
                        return true
                    end
                }))
                return true
            end)
        }))
end

G.FUNCS.evaluate_play = function(e)
    local text,disp_text,poker_hands,scoring_hand,non_loc_disp_text = G.FUNCS.get_poker_hand_info(G.play.cards)
    
    G.GAME.hands[text].played = G.GAME.hands[text].played + 1
    G.GAME.hands[text].played_this_round = G.GAME.hands[text].played_this_round + 1
    G.GAME.last_hand_played = text
    set_hand_usage(text)
    G.GAME.hands[text].visible = true

    --Add all the pure bonus cards to the scoring hand
    local pures = {}
    for i=1, #G.play.cards do
        if next(find_joker('Splash')) then
            scoring_hand[i] = G.play.cards[i]
        else
            if G.play.cards[i].ability.effect == 'Stone Card' then
                local inside = false
                for j=1, #scoring_hand do
                    if scoring_hand[j] == G.play.cards[i] then
                        inside = true
                    end
                end
                if not inside then table.insert(pures, G.play.cards[i]) end
            end
        end
    end
    for i=1, #pures do
        table.insert(scoring_hand, pures[i])
    end
    table.sort(scoring_hand, function (a, b) return a.T.x < b.T.x end )
    delay(0.2)
    for i=1, #scoring_hand do
        --Highlight all the cards used in scoring and play a sound indicating highlight
        highlight_card(scoring_hand[i],(i-0.999)/5,'up')
    end

    local percent = 0.3
    local percent_delta = 0.08

    if G.GAME.current_round.current_hand.handname ~= disp_text then delay(0.3) end
    update_hand_text({sound = G.GAME.current_round.current_hand.handname ~= disp_text and 'button' or nil, volume = 0.4, immediate = true, nopulse = nil,
                delay = G.GAME.current_round.current_hand.handname ~= disp_text and 0.4 or 0}, {handname=disp_text, level=G.GAME.hands[text].level, mult = G.GAME.hands[text].mult, chips = G.GAME.hands[text].chips})

    if G.GAME.blind.name == 'The Hook' and #G.hand.cards >= 1 and blind_level >= 1 then
      G.GAME.blind.triggered = true
    elseif G.GAME.blind.name == 'The Serpent' or G.GAME.blind.name == 'Amber Acorn' and blind_level >= 1 then
      G.GAME.blind.triggered = true
    elseif G.GAME.blind.name == 'The Water' or G.GAME.blind.name == 'The Wall' or G.GAME.blind.name == 'The Manacle' or G.GAME.blind.name == 'The Needle' or G.GAME.blind.name == 'Cerulean Bell' or G.GAME.blind.name == 'Crimson Heart' or G.GAME.blind.name == 'Violet Vessel' and blind_level ~= 0 then
      G.GAME.blind.triggered = true
    end

    if (not (G.GAME.blind:debuff_hand(G.play.cards, poker_hands, text)) or (blind_level <= 0)) then
        mult = mod_mult(G.GAME.hands[text].mult)
        hand_chips = mod_chips(G.GAME.hands[text].chips)

        check_for_unlock({type = 'hand', handname = text, disp_text = non_loc_disp_text, scoring_hand = scoring_hand, full_hand = G.play.cards})

        delay(0.4)

        if G.GAME.first_used_hand_level and G.GAME.first_used_hand_level > 0 then
            level_up_hand(G.deck.cards[1], text, nil, G.GAME.first_used_hand_level)
            G.GAME.first_used_hand_level = nil
        end

        local hand_text_set = false
        for i=1, #G.jokers.cards do
            --calculate the joker effects
            local effects = eval_card(G.jokers.cards[i], {cardarea = G.jokers, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, before = true})
            if effects.jokers then
                card_eval_status_text(G.jokers.cards[i], 'jokers', nil, percent, nil, effects.jokers)
                percent = percent + percent_delta
                if effects.jokers.level_up then
                    level_up_hand(G.jokers.cards[i], text)
                end
            end
        end

        mult = mod_mult(G.GAME.hands[text].mult)
        hand_chips = mod_chips(G.GAME.hands[text].chips)

        local modded = false

        mult, hand_chips, modded = G.GAME.blind:modify_hand(G.play.cards, poker_hands, text, mult, hand_chips)
        mult, hand_chips = mod_mult(mult), mod_chips(hand_chips)
        if modded then update_hand_text({sound = 'chips2', modded = modded}, {chips = hand_chips, mult = mult}) end
        for i=1, #scoring_hand do
            --add cards played to list
            if scoring_hand[i].ability.effect ~= 'Stone Card' then 
                G.GAME.cards_played[scoring_hand[i].base.value].total = G.GAME.cards_played[scoring_hand[i].base.value].total + 1
                G.GAME.cards_played[scoring_hand[i].base.value].suits[scoring_hand[i].base.suit] = true 
            end

            if scoring_hand[i].debuff and not (G.GAME.blind.name == 'The Club' or G.GAME.blind.name == 'The Plant' or G.GAME.blind.name == 'The Goad' or G.GAME.blind.name == 'The Window' or G.GAME.blind.name == 'The Head' or G.GAME.blind.name == 'The Pillar' or G.GAME.blind.name == "Verdant Leaf") and blind_level == 1 then
                G.GAME.blind.triggered = true
                card_eval_status_text(scoring_hand[i], 'debuff')
            elseif scoring_hand[i].debuff and (G.GAME.blind.name == 'The Club' or G.GAME.blind.name == 'The Plant' or G.GAME.blind.name == 'The Goad' or G.GAME.blind.name == 'The Window' or G.GAME.blind.name == 'The Head' or G.GAME.blind.name == 'The Pillar' or G.GAME.blind.name == "Verdant Leaf") and blind_level >= 2 then
                G.GAME.blind.triggered = true


                -- NEW PART: DEBUFFED CARDS ARE STILL TRIGGERED IN LEVEL 2 BOSSES, BUT THEY MINUS THEIR ABILITY INSTEAD OF ADDING

                local reps = {1}
                local eval = eval_card(scoring_hand[i], {repetition_only = true, cardarea = G.play, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, repetition = true})
                if next(eval) then 
                    for h = 1, eval.seals.repetitions do
                        reps[#reps+1] = eval
                    end
                end
                for j=1,#reps do
                    percent = percent + percent_delta
                    if reps[j] ~= 1 then
                        card_eval_status_text((reps[j].jokers or reps[j].seals).card, 'jokers', nil, nil, nil, (reps[j].jokers or reps[j].seals))
                    end
                    
                    --calculate the hand effects
                    local effects = {eval_card(scoring_hand[i], {cardarea = G.play, full_hand = G.play.cards, scoring_hand = scoring_hand, poker_hand = text})}
                    for k=1, #G.jokers.cards do
                        --calculate the joker individual card effects
                        local eval = G.jokers.cards[k]:calculate_joker({cardarea = G.play, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, other_card = scoring_hand[i], individual = true})
                        if eval then 
                            table.insert(effects, eval)
                        end
                    end
                    scoring_hand[i].lucky_trigger = nil

                    for ii = 1, #effects do
                        --If chips added, do chip add event and minus the chips to the total
                        if effects[ii].chips then 
                            if effects[ii].card then juice_card(effects[ii].card) end
                            hand_chips = math.max(0, mod_chips(hand_chips + effects[ii].chips))
                            update_hand_text({delay = 0}, {chips = hand_chips})
                            card_eval_status_text(scoring_hand[i], 'minus_chips', -effects[ii].chips, percent)
                        end

                        --If mult added, do mult add event and minus the mult to the total
                        if effects[ii].mult then 
                            if effects[ii].card then juice_card(effects[ii].card) end
                            mult = math.max(0, mod_mult(mult + effects[ii].mult))
                            update_hand_text({delay = 0}, {mult = mult})
                            card_eval_status_text(scoring_hand[i], 'minus_mult', -effects[ii].mult, percent)
                        end

                        --If play dollars added, minus dollars to total
                        if effects[ii].p_dollars then 
                            if effects[ii].card then juice_card(effects[ii].card) end
                            ease_dollars(effects[ii].p_dollars)
                            card_eval_status_text(scoring_hand[i], 'dollars', effects[ii].p_dollars, percent)
                        end

                        --If dollars added, minus dollars to total
                        if effects[ii].dollars then 
                            if effects[ii].card then juice_card(effects[ii].card) end
                            ease_dollars(effects[ii].dollars)
                            card_eval_status_text(scoring_hand[i], 'dollars', -effects[ii].dollars, percent)
                        end

                        --If x_mult added, do mult add event and divide the mult to the total
                        if effects[ii].x_mult and effects[ii].x_mult ~= 1 then 
                            if effects[ii].card then juice_card(effects[ii].card) end
                            mult = math.max(0, mod_mult(mult*math.floor(100/(effects[ii].x_mult))/100))
                            update_hand_text({delay = 0}, {mult = mult})
                            card_eval_status_text(scoring_hand[i], 'div_mult', effects[ii].x_mult, percent)
                        end

                        --If x_chips added, do chips add event and divide the chips to the total
                        if effects[ii].x_chips then 
                            if effects[ii].card then juice_card(effects[ii].card) end
                            hand_chips = math.max(0, mod_chips(hand_chips*math.floor(100/(effects[ii].x_chips))/100))
                            update_hand_text({delay = 0}, {chips = hand_chips})
                            card_eval_status_text(scoring_hand[i], 'div_chips', effects[ii].x_chips, percent)
                        end

                        --calculate the card edition effects
                        if effects[ii].edition then
                            local chip_mod = 0
                            local mult_mod = 0
                            local x_mult_mod = 1
                            if effects[ii].edition.chip_mod then chip_mod = effects[ii].edition.chip_mod end
                            if effects[ii].edition.mult_mod then mult_mod = effects[ii].edition.mult_mod end
                            if effects[ii].edition.x_mult_mod then x_mult_mod = effects[ii].edition.x_mult_mod end
                            hand_chips = math.max(0, mod_chips(hand_chips + chip_mod))
                            mult = math.max(0, mod_mult(mult + mult_mod))
                            mult = math.max(0, mod_mult(mult * x_mult_mod))
                            update_hand_text({delay = 0}, {
                                chips = chip_mod and hand_chips or nil,
                                mult = (mult_mod or x_mult_mod) and mult or nil,
                            })
                            card_eval_status_text(scoring_hand[i], 'extra', nil, percent, nil, {
                                message = (effects[ii].edition.chip_mod and localize{type='variable',key='a_chips_minus',vars={-chip_mod}}) or
                                        (effects[ii].edition.mult_mod and localize{type='variable',key='a_mult_minus',vars={-mult_mod}}) or
                                        (effects[ii].edition.x_mult_mod and localize{type='variable',key='a_xmult',vars={x_mult_mod}}),
                                chip_mod = chip_mod,
                                mult_mod = mult_mod,
                                x_mult_mod = x_mult_mod,
                                colour = G.C.DARK_EDITION,
                                edition = true})
                        end
                    end
                end
                
            else
                --Check for play doubling
                local reps = {1}
                
                --From Red seal
                local eval = eval_card(scoring_hand[i], {repetition_only = true,cardarea = G.play, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, repetition = true})
                if next(eval) then 
                    for h = 1, eval.seals.repetitions do
                        reps[#reps+1] = eval
                    end
                end
                --From jokers
                for j=1, #G.jokers.cards do
                    --calculate the joker effects
                    local eval = eval_card(G.jokers.cards[j], {cardarea = G.play, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, other_card = scoring_hand[i], repetition = true})
                    if next(eval) and eval.jokers then 
                        for h = 1, eval.jokers.repetitions do
                            reps[#reps+1] = eval
                        end
                    end
                end


                -- NEW: negative level debuff blinds now retrigger cards

                if (G.GAME.blind.name == 'The Pillar') and blind_level <= -1 then
                   reps[#reps+1] = "again"
                   G.GAME.blind.triggered = true
                elseif (G.GAME.blind.name == 'The Club') and blind_level <= -1 and scoring_hand[i]:is_suit("Clubs", true) then
                   reps[#reps+1] = "again"
                   G.GAME.blind.triggered = true
                elseif (G.GAME.blind.name == 'The Head') and blind_level <= -1 and scoring_hand[i]:is_suit("Hearts", true) then
                   reps[#reps+1] = "again"
                   G.GAME.blind.triggered = true
                elseif (G.GAME.blind.name == 'The Goad') and blind_level <= -1 and scoring_hand[i]:is_suit("Spades", true) then
                   reps[#reps+1] = "again"
                   G.GAME.blind.triggered = true
                elseif (G.GAME.blind.name == 'The Window') and blind_level <= -1 and scoring_hand[i]:is_suit("Diamonds", true) then
                   reps[#reps+1] = "again"
                   G.GAME.blind.triggered = true
                elseif (G.GAME.blind.name == 'The Plant') and blind_level <= -1 and scoring_hand[i]:is_face(true) then
                   reps[#reps+1] = "again"
                   G.GAME.blind.triggered = true
                elseif (G.GAME.blind.name == 'Verdant Leaf') and blind_level <= -1 then
                   reps[#reps+1] = "again"
                   G.GAME.blind.triggered = true
                elseif G.GAME.blind:debuff_hand(G.play.cards, poker_hands, text, true) and blind_level <= -1 then
                   reps[#reps+1] = "again"
                   G.GAME.blind.triggered = true
                end

                for j=1,#reps do
                    percent = percent + percent_delta
                    if reps[j] ~= 1 then
                        if reps[j] == "again" then
                          card_eval_status_text(scoring_hand[i], "again", 0)
                        else
                          card_eval_status_text((reps[j].jokers or reps[j].seals).card, 'jokers', nil, nil, nil, (reps[j].jokers or reps[j].seals))
                        end
                    end
                    
                    --calculate the hand effects
                    local effects = {eval_card(scoring_hand[i], {cardarea = G.play, full_hand = G.play.cards, scoring_hand = scoring_hand, poker_hand = text})}
                    for k=1, #G.jokers.cards do
                        --calculate the joker individual card effects
                        local eval = G.jokers.cards[k]:calculate_joker({cardarea = G.play, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, other_card = scoring_hand[i], individual = true})
                        if eval then 
                            table.insert(effects, eval)
                        end
                    end
                    scoring_hand[i].lucky_trigger = nil

                    for ii = 1, #effects do
                        --If chips added, do chip add event and add the chips to the total
                        if effects[ii].chips then 
                            if effects[ii].card then juice_card(effects[ii].card) end
                            hand_chips = mod_chips(hand_chips + effects[ii].chips)
                            update_hand_text({delay = 0}, {chips = hand_chips})
                            card_eval_status_text(scoring_hand[i], 'chips', effects[ii].chips, percent)
                        end

                        --If mult added, do mult add event and add the mult to the total
                        if effects[ii].mult then 
                            if effects[ii].card then juice_card(effects[ii].card) end
                            mult = mod_mult(mult + effects[ii].mult)
                            update_hand_text({delay = 0}, {mult = mult})
                            card_eval_status_text(scoring_hand[i], 'mult', effects[ii].mult, percent)
                        end

                        --If play dollars added, add dollars to total
                        if effects[ii].p_dollars then 
                            if effects[ii].card then juice_card(effects[ii].card) end
                            ease_dollars(effects[ii].p_dollars)
                            card_eval_status_text(scoring_hand[i], 'dollars', effects[ii].p_dollars, percent)
                        end

                        --If dollars added, add dollars to total
                        if effects[ii].dollars then 
                            if effects[ii].card then juice_card(effects[ii].card) end
                            ease_dollars(effects[ii].dollars)
                            card_eval_status_text(scoring_hand[i], 'dollars', effects[ii].dollars, percent)
                        end

                        --Any extra effects
                        if effects[ii].extra then 
                            if effects[ii].card then juice_card(effects[ii].card) end
                            local extras = {mult = false, hand_chips = false}
                            if effects[ii].extra.mult_mod then mult =mod_mult( mult + effects[ii].extra.mult_mod);extras.mult = true end
                            if effects[ii].extra.chip_mod then hand_chips = mod_chips(hand_chips + effects[ii].extra.chip_mod);extras.hand_chips = true end
                            if effects[ii].extra.swap then 
                                local old_mult = mult
                                mult = mod_mult(hand_chips)
                                hand_chips = mod_chips(old_mult)
                                extras.hand_chips = true; extras.mult = true
                            end
                            if effects[ii].extra.func then effects[ii].extra.func() end
                            update_hand_text({delay = 0}, {chips = extras.hand_chips and hand_chips, mult = extras.mult and mult})
                            card_eval_status_text(scoring_hand[i], 'extra', nil, percent, nil, effects[ii].extra)
                        end

                        --If x_mult added, do mult add event and mult the mult to the total
                        if effects[ii].x_mult then 
                            if effects[ii].card then juice_card(effects[ii].card) end
                            mult = mod_mult(mult*effects[ii].x_mult)
                            update_hand_text({delay = 0}, {mult = mult})
                            card_eval_status_text(scoring_hand[i], 'x_mult', effects[ii].x_mult, percent)
                        end

                        --If x_chips added, do chips add event and chips the chips to the total
                        if effects[ii].x_chips then 
                            if effects[ii].card then juice_card(effects[ii].card) end
                            hand_chips = mod_chips(hand_chips*effects[ii].x_chips)
                            update_hand_text({delay = 0}, {chips = hand_chips})
                            card_eval_status_text(scoring_hand[i], 'x_chips', effects[ii].x_chips, percent)
                        end

                        --calculate the card edition effects
                        if effects[ii].edition then
                            hand_chips = mod_chips(hand_chips + (effects[ii].edition.chip_mod or 0))
                            mult = mult + (effects[ii].edition.mult_mod or 0)
                            mult = mod_mult(mult*(effects[ii].edition.x_mult_mod or 1))
                            update_hand_text({delay = 0}, {
                                chips = effects[ii].edition.chip_mod and hand_chips or nil,
                                mult = (effects[ii].edition.mult_mod or effects[ii].edition.x_mult_mod) and mult or nil,
                            })
                            card_eval_status_text(scoring_hand[i], 'extra', nil, percent, nil, {
                                message = (effects[ii].edition.chip_mod and localize{type='variable',key='a_chips',vars={effects[ii].edition.chip_mod}}) or
                                        (effects[ii].edition.mult_mod and localize{type='variable',key='a_mult',vars={effects[ii].edition.mult_mod}}) or
                                        (effects[ii].edition.x_mult_mod and localize{type='variable',key='a_xmult',vars={effects[ii].edition.x_mult_mod}}),
                                chip_mod =  effects[ii].edition.chip_mod,
                                mult_mod =  effects[ii].edition.mult_mod,
                                x_mult_mod =  effects[ii].edition.x_mult_mod,
                                colour = G.C.DARK_EDITION,
                                edition = true})
                        end
                    end
                end
            end
        end

        delay(0.3)
        local mod_percent = false
            for i=1, #G.hand.cards do
                if mod_percent then percent = percent + percent_delta end
                mod_percent = false

                --Check for hand doubling
                local reps = {1}
                local j = 1
                while j <= #reps do
                    if reps[j] ~= 1 then
                        if reps[j] == "again" then
                          card_eval_status_text(G.hand.cards[i], "again", 0)
                        else
                          card_eval_status_text((reps[j].jokers or reps[j].seals).card, 'jokers', nil, nil, nil, (reps[j].jokers or reps[j].seals))
                        end
                        percent = percent + percent_delta
                    end

                    --calculate the hand effects
                    local effects = {eval_card(G.hand.cards[i], {cardarea = G.hand, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands})}
                    local effects2 = {eval_card(G.hand.cards[i], {cardarea = G.play, full_hand = G.play.cards, scoring_hand = scoring_hand, poker_hand = text})}

                    for k=1, #G.jokers.cards do
                        --calculate the joker individual card effects
                        local eval = G.jokers.cards[k]:calculate_joker({cardarea = G.hand, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, other_card = G.hand.cards[i], individual = true})
                        if eval then 
                            mod_percent = true
                            table.insert(effects, eval)
                        end
                    end

                    if reps[j] == 1 then 
                        --Check for hand doubling

                        --From Red seal
                        local eval = eval_card(G.hand.cards[i], {repetition_only = true,cardarea = G.hand, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, repetition = true, card_effects = effects})
                        if next(eval) and (next(effects[1]) or #effects > 1) then 
                            for h  = 1, eval.seals.repetitions do
                                reps[#reps+1] = eval
                            end
                        end

                        --From Joker
                        for j=1, #G.jokers.cards do
                            --calculate the joker effects
                            local eval = eval_card(G.jokers.cards[j], {cardarea = G.hand, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, other_card = G.hand.cards[i], repetition = true, card_effects = effects})
                            if next(eval) then 
                                for h  = 1, eval.jokers.repetitions do
                                    reps[#reps+1] = eval
                                end
                            end
                        end

                        -- NEW: negative level debuff blinds now retrigger cards

                        local temp_Mult, temp_ID = 15, 15
                        local raised_card = nil
                        for ij=1, #G.hand.cards do
                            if temp_ID >= G.hand.cards[ij].base.id and (G.hand.cards[ij].ability.effect ~= 'Stone Card' and not G.hand.cards[ij].config.center.no_rank) then 
                                temp_Mult = G.hand.cards[ij].base.nominal
                                temp_ID = G.hand.cards[ij].base.id
                                raised_card = G.hand.cards[ij]
                            end
                        end

                      local editionretrig = false
                      for ji=1, #effects2 do
                        if effects2[ji].edition and (effects2[ji].edition.chip_mod or effects2[ji].edition.mult_mod or effects2[ji].edition.x_mult_mod) and next(find_joker('Splash')) and effect_level >= 2 then
                          editionretrig = true
                        end
                      end

                      if G.hand.cards[i].ability.effect == "Steel Card" or (G.hand.cards[i]:get_id() == 13 and next(find_joker('Baron'))) or (G.hand.cards[i]:get_id() == 12 and next(find_joker('Shoot the Moon'))) or (G.hand.cards[i]:is_face(true) and next(find_joker('Business Card'))) or (G.hand.cards[i] == raised_card and next(find_joker('Raised Fist'))) or editionretrig then
                        if (G.GAME.blind.name == 'The Pillar') and blind_level <= -1 then
                          reps[#reps+1] = "again"
                          G.GAME.blind.triggered = true
                        elseif (G.GAME.blind.name == 'The Club') and blind_level <= -1 and G.hand.cards[i]:is_suit("Clubs", true) then
                          reps[#reps+1] = "again"
                          G.GAME.blind.triggered = true
                        elseif (G.GAME.blind.name == 'The Head') and blind_level <= -1 and G.hand.cards[i]:is_suit("Hearts", true) then
                          reps[#reps+1] = "again"
                          G.GAME.blind.triggered = true
                        elseif (G.GAME.blind.name == 'The Goad') and blind_level <= -1 and G.hand.cards[i]:is_suit("Spades", true) then
                          reps[#reps+1] = "again"
                          G.GAME.blind.triggered = true
                        elseif (G.GAME.blind.name == 'The Window') and blind_level <= -1 and G.hand.cards[i]:is_suit("Diamonds", true) then
                          reps[#reps+1] = "again"
                          G.GAME.blind.triggered = true
                        elseif (G.GAME.blind.name == 'The Plant') and blind_level <= -1 and G.hand.cards[i]:is_face(true) then
                          reps[#reps+1] = "again"
                          G.GAME.blind.triggered = true
                        elseif (G.GAME.blind.name == 'Verdant Leaf') and blind_level <= -1 then
                          reps[#reps+1] = "again"
                          G.GAME.blind.triggered = true
                        end
                      end
                    end
    
                    for ii = 1, #effects do
                        --if this effect came from a joker
                        if effects[ii].card then
                            mod_percent = true
                            G.E_MANAGER:add_event(Event({
                                trigger = 'immediate',
                                func = (function() effects[ii].card:juice_up(0.7);return true end)
                            }))
                        end
                        
                        --If hold mult added, do hold mult add event and add the mult to the total
                        
                        --If dollars added, add dollars to total
                        if effects[ii].dollars then 
                            ease_dollars(effects[ii].dollars)
                            card_eval_status_text(G.hand.cards[i], 'dollars', effects[ii].dollars, percent)
                        end

                        if effects[ii].h_mult then
                            mod_percent = true
                            mult = mod_mult(mult + effects[ii].h_mult)
                            update_hand_text({delay = 0}, {mult = mult})
                            card_eval_status_text(G.hand.cards[i], 'h_mult', effects[ii].h_mult, percent)
                        end

                        if effects[ii].x_mult then
                            mod_percent = true
                            mult = mod_mult(mult*effects[ii].x_mult)
                            update_hand_text({delay = 0}, {mult = mult})
                            card_eval_status_text(G.hand.cards[i], 'x_mult', effects[ii].x_mult, percent)
                        end

                        if effects[ii].message then
                            mod_percent = true
                            update_hand_text({delay = 0}, {mult = mult})
                            card_eval_status_text(G.hand.cards[i], 'extra', nil, percent, nil, effects[ii])
                        end

                    end
                    for ji=1, #effects2 do
                      if effects2[ji].edition and next(find_joker('Splash')) and (effect_level >= 2) then
                        if G.hand.cards[i].debuff then
                            local chip_mod = 0
                            local mult_mod = 0
                            local x_mult_mod = 1
                            if effects2[ji].edition.chip_mod then chip_mod = effects2[ji].edition.chip_mod end
                            if effects2[ji].edition.mult_mod then mult_mod = effects2[ji].edition.mult_mod end
                            if effects2[ji].edition.x_mult_mod then x_mult_mod = effects2[ji].edition.x_mult_mod end
                            hand_chips = math.max(0, mod_chips(hand_chips + chip_mod))
                            mult = math.max(0, mod_mult(mult + mult_mod))
                            mult = math.max(0, mod_mult(mult * x_mult_mod))
                            update_hand_text({delay = 0}, {
                                chips = chip_mod and hand_chips or nil,
                                mult = (mult_mod or x_mult_mod) and mult or nil,
                            })
                            card_eval_status_text(G.hand.cards[i], 'extra', nil, percent, nil, {
                                message = (effects2[ji].edition.chip_mod and localize{type='variable',key='a_chips_minus',vars={-chip_mod}}) or
                                        (effects2[ji].edition.mult_mod and localize{type='variable',key='a_mult_minus',vars={-mult_mod}}) or
                                        (effects2[ji].edition.x_mult_mod and localize{type='variable',key='a_xmult',vars={x_mult_mod}}),
                                chip_mod = chip_mod,
                                mult_mod = mult_mod,
                                x_mult_mod = x_mult_mod,
                                colour = G.C.DARK_EDITION,
                                edition = true})
                        else
                            hand_chips = mod_chips(hand_chips + (effects2[ji].edition.chip_mod or 0))
                            mult = mult + (effects2[ji].edition.mult_mod or 0)
                            mult = mod_mult(mult*(effects2[ji].edition.x_mult_mod or 1))
                            update_hand_text({delay = 0}, {
                                chips = effects2[ji].edition.chip_mod and hand_chips or nil,
                                mult = (effects2[ji].edition.mult_mod or effects2[ji].edition.x_mult_mod) and mult or nil,
                            })
                            card_eval_status_text(G.hand.cards[i], 'extra', nil, percent, nil, {
                                message = (effects2[ji].edition.chip_mod and localize{type='variable',key='a_chips',vars={effects2[ji].edition.chip_mod}}) or
                                        (effects2[ji].edition.mult_mod and localize{type='variable',key='a_mult',vars={effects2[ji].edition.mult_mod}}) or
                                        (effects2[ji].edition.x_mult_mod and localize{type='variable',key='a_xmult',vars={effects2[ji].edition.x_mult_mod}}),
                                chip_mod =  effects2[ji].edition.chip_mod,
                                mult_mod =  effects2[ji].edition.mult_mod,
                                x_mult_mod =  effects2[ji].edition.x_mult_mod,
                                colour = G.C.DARK_EDITION,
                                edition = true})
                        end
                      end
                    end
                    j = j +1
                end
            end
        --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
        --Joker Effects
        --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
        percent = percent + percent_delta
        for i=1, #G.jokers.cards + #G.consumeables.cards do
            local _card = G.jokers.cards[i] or G.consumeables.cards[i - #G.jokers.cards]
            --calculate the joker edition effects
            local edition_effects = eval_card(_card, {cardarea = G.jokers, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, edition = true})
            if edition_effects.jokers then
                edition_effects.jokers.edition = true
                if edition_effects.jokers.chip_mod then
                    hand_chips = mod_chips(hand_chips + edition_effects.jokers.chip_mod)
                    update_hand_text({delay = 0}, {chips = hand_chips})
                    card_eval_status_text(_card, 'jokers', nil, percent, nil, {
                        message = localize{type='variable',key='a_chips',vars={edition_effects.jokers.chip_mod}},
                        chip_mod =  edition_effects.jokers.chip_mod,
                        colour =  G.C.EDITION,
                        edition = true})
                end
                if edition_effects.jokers.mult_mod then
                    mult = mod_mult(mult + edition_effects.jokers.mult_mod)
                    update_hand_text({delay = 0}, {mult = mult})
                    card_eval_status_text(_card, 'jokers', nil, percent, nil, {
                        message = localize{type='variable',key='a_mult',vars={edition_effects.jokers.mult_mod}},
                        mult_mod =  edition_effects.jokers.mult_mod,
                        colour = G.C.DARK_EDITION,
                        edition = true})
                end
                percent = percent+percent_delta
            end

            --calculate the joker effects
            local effects = eval_card(_card, {cardarea = G.jokers, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, joker_main = true})

            --Any Joker effects
            if effects.jokers then 
                local extras = {mult = false, hand_chips = false}
                if effects.jokers.mult_mod then mult = mod_mult(mult + effects.jokers.mult_mod);extras.mult = true end
                if effects.jokers.chip_mod then hand_chips = mod_chips(hand_chips + effects.jokers.chip_mod);extras.hand_chips = true end
                if effects.jokers.Xmult_mod then mult = mod_mult(mult*effects.jokers.Xmult_mod);extras.mult = true  end
                update_hand_text({delay = 0}, {chips = extras.hand_chips and hand_chips, mult = extras.mult and mult})
                card_eval_status_text(_card, 'jokers', nil, percent, nil, effects.jokers)
                percent = percent+percent_delta
            end

            --Joker on Joker effects
            for _, v in ipairs(G.jokers.cards) do
                local effect = v:calculate_joker{full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, other_joker = _card}
                if effect then
                    local extras = {mult = false, hand_chips = false}
                    if effect.mult_mod then mult = mod_mult(mult + effect.mult_mod);extras.mult = true end
                    if effect.chip_mod then hand_chips = mod_chips(hand_chips + effect.chip_mod);extras.hand_chips = true end
                    if effect.Xmult_mod then mult = mod_mult(mult*effect.Xmult_mod);extras.mult = true  end
                    if extras.mult or extras.hand_chips then update_hand_text({delay = 0}, {chips = extras.hand_chips and hand_chips, mult = extras.mult and mult}) end
                    if extras.mult or extras.hand_chips then card_eval_status_text(v, 'jokers', nil, percent, nil, effect) end
                    percent = percent+percent_delta
                end
            end

            if edition_effects.jokers then
                if edition_effects.jokers.x_mult_mod then
                    mult = mod_mult(mult*edition_effects.jokers.x_mult_mod)
                    update_hand_text({delay = 0}, {mult = mult})
                    card_eval_status_text(_card, 'jokers', nil, percent, nil, {
                        message = localize{type='variable',key='a_xmult',vars={edition_effects.jokers.x_mult_mod}},
                        x_mult_mod =  edition_effects.jokers.x_mult_mod,
                        colour =  G.C.EDITION,
                        edition = true})
                end
                percent = percent+percent_delta
            end
        end

        local nu_chip, nu_mult = G.GAME.selected_back:trigger_effect{context = 'final_scoring_step', chips = hand_chips, mult = mult}
        mult = mod_mult(nu_mult or mult)
        hand_chips = mod_chips(nu_chip or hand_chips)

        local cards_destroyed = {}
        for i=1, #scoring_hand do
            local destroyed = nil
            --un-highlight all cards
            highlight_card(scoring_hand[i],(i-0.999)/(#scoring_hand-0.998),'down')

            for j = 1, #G.jokers.cards do
                destroyed = G.jokers.cards[j]:calculate_joker({destroying_card = scoring_hand[i], full_hand = G.play.cards})
                if destroyed then break end
            end

            if scoring_hand[i].ability.name == 'Glass Card' and not scoring_hand[i].debuff and pseudorandom('glass') < G.GAME.probabilities.normal/scoring_hand[i].ability.extra then 
                destroyed = true
            end

            if destroyed then 
                if scoring_hand[i].ability.name == 'Glass Card' then 
                    scoring_hand[i].shattered = true
                else 
                    scoring_hand[i].destroyed = true
                end 
                cards_destroyed[#cards_destroyed+1] = scoring_hand[i]
            end
        end
        for j=1, #G.jokers.cards do
            eval_card(G.jokers.cards[j], {cardarea = G.jokers, remove_playing_cards = true, removed = cards_destroyed})
        end

        local glass_shattered = {}
        for k, v in ipairs(cards_destroyed) do
            if v.shattered then glass_shattered[#glass_shattered+1] = v end
        end

        check_for_unlock{type = 'shatter', shattered = glass_shattered}
        
        for i=1, #cards_destroyed do
            G.E_MANAGER:add_event(Event({
                func = function()
                    if cards_destroyed[i].ability.name == 'Glass Card' then 
                        cards_destroyed[i]:shatter()
                    else
                        cards_destroyed[i]:start_dissolve()
                    end
                  return true
                end
              }))
        end
    else
        mult = mod_mult(0)
        hand_chips = mod_chips(0)
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = (function()
                G.GAME.blind:juice_up()
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                    play_sound('tarot2', 0.76, 0.4);return true end}))
                play_sound('tarot2', 1, 0.4)
                return true
            end)
        }))

        play_area_status_text("Not Allowed!")--localize('k_not_allowed_ex'), true)
        --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
        --Joker Debuff Effects
        --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
        for i=1, #G.jokers.cards do
            
            --calculate the joker effects
            local effects = eval_card(G.jokers.cards[i], {cardarea = G.jokers, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, debuffed_hand = true})

            --Any Joker effects
            if effects.jokers then
                card_eval_status_text(G.jokers.cards[i], 'jokers', nil, percent, nil, effects.jokers)
                percent = percent+percent_delta
            end
        end
    end
    G.E_MANAGER:add_event(Event({
        trigger = 'after',delay = 0.4,
        func = (function()  update_hand_text({delay = 0, immediate = true}, {mult = 0, chips = 0, chip_total = math.floor(hand_chips*mult), level = '', handname = ''});play_sound('button', 0.9, 0.6);return true end)
      }))
      check_and_set_high_score('hand', hand_chips*mult)

      check_for_unlock({type = 'chip_score', chips = math.floor(hand_chips*mult)})
   
    if hand_chips*mult > 0 then 
        delay(0.8)
        G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = (function() play_sound('chips2');return true end)
        }))
    end
    G.E_MANAGER:add_event(Event({
      trigger = 'ease',
      blocking = false,
      ref_table = G.GAME,
      ref_value = 'chips',
      ease_to = G.GAME.chips + math.floor(hand_chips*mult),
      delay =  0.5,
      func = (function(t) return math.floor(t) end)
    }))
    G.E_MANAGER:add_event(Event({
      trigger = 'ease',
      blocking = true,
      ref_table = G.GAME.current_round.current_hand,
      ref_value = 'chip_total',
      ease_to = 0,
      delay =  0.5,
      func = (function(t) return math.floor(t) end)
    }))
    G.E_MANAGER:add_event(Event({
      trigger = 'immediate',
      func = (function() G.GAME.current_round.current_hand.handname = '';return true end)
    }))
    delay(0.3)

    for i=1, #G.jokers.cards do
        --calculate the joker after hand played effects
        local effects = eval_card(G.jokers.cards[i], {cardarea = G.jokers, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, after = true})
        if effects.jokers then
            card_eval_status_text(G.jokers.cards[i], 'jokers', nil, percent, nil, effects.jokers)
            percent = percent + percent_delta
        end
    end

    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = (function()     
            if G.GAME.modifiers.debuff_played_cards then 
                for k, v in ipairs(scoring_hand) do v.ability.perma_debuff = true end
            end
        return true end)
      }))

  end
  
  G.FUNCS.draw_from_play_to_discard = function(e)
    local play_count = #G.play.cards
    local it = 1
    for k, v in ipairs(G.play.cards) do
        if (not v.shattered) and (not v.destroyed) then 
            draw_card(G.play,G.discard, it*100/play_count,'down', false, v)
            it = it + 1
        end
    end
  end

  G.FUNCS.draw_from_play_to_hand = function(cards)
    local gold_count = #cards
    for i=1, gold_count do --draw cards from play
        if not cards[i].shattered and not cards[i].destroyed then
            draw_card(G.play,G.hand, i*100/gold_count,'up', true, cards[i])
        end
    end
  end
  
  G.FUNCS.draw_from_discard_to_deck = function(e)
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            local discard_count = #G.discard.cards
            for i=1, discard_count do --draw cards from deck
                draw_card(G.discard, G.deck, i*100/discard_count,'up', nil ,nil, 0.005, i%2==0, nil, math.max((21-i)/20,0.7))
            end
            return true
        end
      }))
  end

  G.FUNCS.draw_from_hand_to_deck = function(e)
    local hand_count = #G.hand.cards
    for i=1, hand_count do --draw cards from deck
        draw_card(G.hand, G.deck, i*100/hand_count,'down', nil, nil,  0.08)
    end
  end
  
  G.FUNCS.draw_from_hand_to_discard = function(e)
    local hand_count = #G.hand.cards
    for i=1, hand_count do
        draw_card(G.hand,G.discard, i*100/hand_count,'down', nil, nil, 0.07)
    end
end

function end_round()
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.2,
      func = function()
        local game_over = true
        local game_won = false
        G.RESET_BLIND_STATES = true
        G.RESET_JIGGLES = true
            if G.GAME.chips - G.GAME.blind.chips >= 0 then
                game_over = false
            end
            for i = 1, #G.jokers.cards do
                local eval = nil
                eval = G.jokers.cards[i]:calculate_joker({end_of_round = true, game_over = game_over})
                if eval then
                    if eval.saved then
                        game_over = false
                    end
                    card_eval_status_text(G.jokers.cards[i], 'jokers', nil, nil, nil, eval)
                end
                G.jokers.cards[i]:calculate_rental()
                G.jokers.cards[i]:calculate_perishable()
            end
            if G.GAME.round_resets.ante == G.GAME.win_ante and G.GAME.blind:get_type() == 'Boss' then
                game_won = true
                G.GAME.won = true
            end
            if game_over then
                G.STATE = G.STATES.GAME_OVER
                if not G.GAME.won and not G.GAME.seeded and not G.GAME.challenge then 
                    G.PROFILES[G.SETTINGS.profile].high_scores.current_streak.amt = 0
                end
                G:save_settings()
                G.FILE_HANDLER.force = true
                G.STATE_COMPLETE = false
            else
                G.GAME.unused_discards = (G.GAME.unused_discards or 0) + G.GAME.current_round.discards_left
                if G.GAME.blind and G.GAME.blind.config.blind then 
                    discover_card(G.GAME.blind.config.blind)
                end

                if G.GAME.blind:get_type() == 'Boss' then
                    local _handname, _played, _order = 'High Card', -1, 100
                    for k, v in pairs(G.GAME.hands) do
                        if v.played > _played or (v.played == _played and _order > v.order) then 
                            _played = v.played
                            _handname = k
                        end
                    end
                    G.GAME.current_round.most_played_poker_hand = _handname
                end

                if G.GAME.blind:get_type() == 'Boss' and not G.GAME.seeded and not G.GAME.challenge  then
                    G.GAME.current_boss_streak = G.GAME.current_boss_streak + 1
                    check_and_set_high_score('boss_streak', G.GAME.current_boss_streak)
                end
                
                if G.GAME.current_round.hands_played == 1 then 
                    inc_career_stat('c_single_hand_round_streak', 1)
                else
                    if not G.GAME.seeded and not G.GAME.challenge  then
                        G.PROFILES[G.SETTINGS.profile].career_stats.c_single_hand_round_streak = 0
                        G:save_settings()
                    end
                end

                check_for_unlock({type = 'round_win'})
                set_joker_usage()
                if game_won and not G.GAME.win_notified then
                    G.GAME.win_notified = true
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        blocking = false,
                        blockable = false,
                        func = (function()
                            if G.STATE == G.STATES.ROUND_EVAL then 
                                win_game()
                                G.GAME.won = true
                                return true
                            end
                        end)
                    }))
                end
                for i=1, #G.hand.cards do
                    --Check for hand doubling
                    local reps = {1}
                    local j = 1
                    while j <= #reps do
                        local percent = (i-0.999)/(#G.hand.cards-0.998) + (j-1)*0.1
                        if reps[j] ~= 1 then card_eval_status_text((reps[j].jokers or reps[j].seals).card, 'jokers', nil, nil, nil, (reps[j].jokers or reps[j].seals)) end
    
                        --calculate the hand effects
                        local effects = {G.hand.cards[i]:get_end_of_round_effect()}
                        for k=1, #G.jokers.cards do
                            --calculate the joker individual card effects
                            local eval = G.jokers.cards[k]:calculate_joker({cardarea = G.hand, other_card = G.hand.cards[i], individual = true, end_of_round = true})
                            if eval then 
                                table.insert(effects, eval)
                            end
                        end

                        if reps[j] == 1 then 
                            --Check for hand doubling
                            --From Red seal
                            local eval = eval_card(G.hand.cards[i], {end_of_round = true,cardarea = G.hand, repetition = true, repetition_only = true})
                            if next(eval) and (next(effects[1]) or #effects > 1)  then 
                                for h = 1, eval.seals.repetitions do
                                    reps[#reps+1] = eval
                                end
                            end

                            --from Jokers
                            for j=1, #G.jokers.cards do
                                --calculate the joker effects
                                local eval = eval_card(G.jokers.cards[j], {cardarea = G.hand, other_card = G.hand.cards[i], repetition = true, end_of_round = true, card_effects = effects})
                                if next(eval) then 
                                    for h  = 1, eval.jokers.repetitions do
                                        reps[#reps+1] = eval
                                    end
                                end
                            end

                      if G.hand.cards[i].ability.effect == "Gold Card" or G.hand.cards[i].seal == "Blue Seal" then
                        if (G.GAME.blind.name == 'The Pillar') and blind_level <= -1 then
                          reps[#reps+1] = "again"
                        elseif (G.GAME.blind.name == 'The Club') and blind_level <= -1 and G.hand.cards[i]:is_suit("Clubs", true) then
                          reps[#reps+1] = "again"
                        elseif (G.GAME.blind.name == 'The Head') and blind_level <= -1 and G.hand.cards[i]:is_suit("Hearts", true) then
                          reps[#reps+1] = "again"
                        elseif (G.GAME.blind.name == 'The Goad') and blind_level <= -1 and G.hand.cards[i]:is_suit("Spades", true) then
                          reps[#reps+1] = "again"
                        elseif (G.GAME.blind.name == 'The Window') and blind_level <= -1 and G.hand.cards[i]:is_suit("Diamonds", true) then
                          reps[#reps+1] = "again"
                        elseif (G.GAME.blind.name == 'The Plant') and blind_level <= -1 and G.hand.cards[i]:is_face(true) then
                          reps[#reps+1] = "again"
                        elseif (G.GAME.blind.name == 'Verdant Leaf') and blind_level <= -1 then
                          reps[#reps+1] = "again"
                        end
                      end

                        end
        
                        for ii = 1, #effects do
                            --if this effect came from a joker
                            if effects[ii].card then
                                G.E_MANAGER:add_event(Event({
                                    trigger = 'immediate',
                                    func = (function() effects[ii].card:juice_up(0.7);return true end)
                                }))
                            end

                            if G.hand.cards[i].ability.effect == "Gold Card" and G.hand.cards[i].debuff and (G.GAME.blind.name == 'The Club' or G.GAME.blind.name == 'The Plant' or G.GAME.blind.name == 'The Goad' or G.GAME.blind.name == 'The Window' or G.GAME.blind.name == 'The Head' or G.GAME.blind.name == 'The Pillar' or G.GAME.blind.name == "Verdant Leaf") and blind_level >= 2 then
                              ease_dollars(-(3 + (enhance_level-1)*2))
                              card_eval_status_text(G.hand.cards[i], 'dollars', -(3 + (enhance_level-1)*2), percent)
                            end
                            
                            --If dollars
                            if effects[ii].h_dollars then 
                                ease_dollars(effects[ii].h_dollars)
                                card_eval_status_text(G.hand.cards[i], 'dollars', effects[ii].h_dollars, percent)
                            end

                            --Any extras
                            if effects[ii].extra then
                                card_eval_status_text(G.hand.cards[i], 'extra', nil, percent, nil, effects[ii].extra)
                            end
                        end
                        j = j + 1
                    end
                end
                delay(0.3)


                G.FUNCS.draw_from_hand_to_discard()
                if G.GAME.blind:get_type() == 'Boss' then
                    G.GAME.voucher_restock = nil
                    if G.GAME.modifiers.set_eternal_ante and (G.GAME.round_resets.ante == G.GAME.modifiers.set_eternal_ante) then 
                        for k, v in ipairs(G.jokers.cards) do
                            v:set_eternal(true)
                        end
                    end
                    if G.GAME.modifiers.set_joker_slots_ante and (G.GAME.round_resets.ante == G.GAME.modifiers.set_joker_slots_ante) then 
                        G.jokers.config.card_limit = 0
                    end
                    delay(0.4); ease_ante(1); delay(0.4); check_for_unlock({type = 'ante_up', ante = G.GAME.round_resets.ante + 1})
                end
                G.FUNCS.draw_from_discard_to_deck()
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    func = function()
                        G.STATE = G.STATES.ROUND_EVAL
                        G.STATE_COMPLETE = false

                        if G.GAME.round_resets.blind == G.P_BLINDS.bl_small then
                            G.GAME.round_resets.blind_states.Small = 'Defeated'
                        elseif G.GAME.round_resets.blind == G.P_BLINDS.bl_big then
                            G.GAME.round_resets.blind_states.Big = 'Defeated'
                        else
                            G.GAME.current_round.voucher = get_next_voucher_key()
                            G.GAME.round_resets.blind_states.Boss = 'Defeated'
                            for k, v in ipairs(G.playing_cards) do
                                v.ability.played_this_ante = nil
                            end
                        end

                        if G.GAME.round_resets.temp_handsize then G.hand:change_size(-G.GAME.round_resets.temp_handsize); G.GAME.round_resets.temp_handsize = nil end
                        if G.GAME.round_resets.temp_reroll_cost then G.GAME.round_resets.temp_reroll_cost = nil; calculate_reroll_cost(true) end

                        reset_idol_card()
                        reset_mail_rank()
                        reset_ancient_card()
                        reset_castle_card()
                        for k, v in ipairs(G.playing_cards) do
                            v.ability.discarded = nil
                            v.ability.forced_selection = nil
                        end
                    return true
                    end
                }))
            end
        return true
      end
    }))
  end

function create_UIBox_blind_popup(blind, discovered, vars)
  local blind_text = {}
  
  local _dollars = blind.dollars
  local loc_vars = nil
  if blind.collection_loc_vars and type(blind.collection_loc_vars) == 'function' then
  	local res = blind:collection_loc_vars() or {}
  	loc_vars = res.vars
  end
  local loc_target = localize{type = 'raw_descriptions', key = blind.key, set = 'Blind', vars = loc_vars or vars or blind.vars}
  local loc_name = localize{type = 'name_text', key = blind.key, set = 'Blind'}

  if discovered then 
    local ability_text = {}
    if loc_target then 
      for k, v in ipairs(loc_target) do
        ability_text[#ability_text + 1] = {n=G.UIT.R, config={align = "cm"}, nodes={{n=G.UIT.T, config={text = v, scale = 0.35, shadow = true, colour = G.C.WHITE}}}}
      end
    end
    local stake_sprite = get_stake_sprite(G.GAME.stake or 1, 0.4)
    blind_text[#blind_text + 1] =
      {n=G.UIT.R, config={align = "cm", emboss = 0.05, r = 0.1, minw = 2.5, padding = 0.07, colour = G.C.WHITE}, nodes={
        {n=G.UIT.R, config={align = "cm", maxw = 2.4}, nodes={
          {n=G.UIT.T, config={text = localize('ph_blind_score_at_least'), scale = 0.35, colour = G.C.UI.TEXT_DARK}},
        }},
        {n=G.UIT.R, config={align = "cm"}, nodes={
          {n=G.UIT.O, config={object = stake_sprite}},
          {n=G.UIT.T, config={text = blind.mult..localize('k_x_base'), scale = 0.4, colour = G.C.RED}},
        }},
        {n=G.UIT.R, config={align = "cm"}, nodes={
          {n=G.UIT.T, config={text = localize('ph_blind_reward'), scale = 0.35, colour = G.C.UI.TEXT_DARK}},
          {n=G.UIT.O, config={object = DynaText({string = {_dollars and string.rep(localize('$'),_dollars) or '-'}, colours = {G.C.MONEY}, rotate = true, bump = true, silent = true, scale = 0.45})}},
        }},
        ability_text[1] and {n=G.UIT.R, config={align = "cm", padding = 0.08, colour = mix_colours(blind.boss_colour, G.C.GREY, 0.4), r = 0.1, emboss = 0.05, minw = 2.5, minh = 0.9}, nodes=ability_text} or nil
      }}
  else
    blind_text[#blind_text + 1] =
      {n=G.UIT.R, config={align = "cm", emboss = 0.05, r = 0.1, minw = 2.5, padding = 0.1, colour = G.C.WHITE}, nodes={
        {n=G.UIT.R, config={align = "cm"}, nodes={
          {n=G.UIT.T, config={text = localize('ph_defeat_this_blind_1'), scale = 0.4, colour = G.C.UI.TEXT_DARK}},
        }},
        {n=G.UIT.R, config={align = "cm"}, nodes={
          {n=G.UIT.T, config={text = localize('ph_defeat_this_blind_2'), scale = 0.4, colour = G.C.UI.TEXT_DARK}},
        }},
      }}
  end
 return {n=G.UIT.ROOT, config={align = "cm", padding = 0.05, colour = lighten(G.C.JOKER_GREY, 0.5), r = 0.1, emboss = 0.05}, nodes={
  {n=G.UIT.R, config={align = "cm", emboss = 0.05, r = 0.1, minw = 2.5, padding = 0.1, colour = not discovered and G.C.JOKER_GREY or blind.boss_colour or G.C.GREY}, nodes={
    {n=G.UIT.O, config={object = DynaText({string = discovered and loc_name or localize('k_not_discovered'), colours = {G.C.UI.TEXT_LIGHT}, shadow = true, rotate = not discovered, spacing = discovered and 2 or 0, bump = true, scale = 0.4})}},
  }},
  {n=G.UIT.R, config={align = "cm"}, nodes=blind_text},
 }}
end 

-------------------------------------------------------------------
--@@@--@-@--@@@--@@---@-@-@--@@---@@@--@@@--@@@-----@@@--@@@--@@---
--@-@--@-@--@----@-@--@-@-@--@-@---@----@---@-------@----@-@--@-@--
--@-@--@-@--@@---@@---@-@-@--@@----@----@---@@------@@---@-@--@-@--
--@-@--@-@--@----@-@--@-@-@--@-@---@----@---@-------@----@-@--@-@--
--@@@---@---@@@--@-@--@@@@@--@-@--@@@---@---@@@-----@@@--@-@--@@---
-------------------------------------------------------------------
  


-- DESCRIPTIONS

-- FOR TEMPERANCE'S SAKE, I HAD TO OVERWRITE THE ENTIRETY OF GENERATE_CARD_UI BECAUSE STEAMODDED WOULDN'T LET ME USE LOVELY TO OVERWRITE A SINGLE LINE COMMON_EVENTS.LUA >:( 
function generate_card_ui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end)
    local first_pass = nil
    if not full_UI_table then 
        first_pass = true
        full_UI_table = {
            main = {},
            info = {},
            type = {},
            name = nil,
            badges = badges or {}
        }
    end

    local desc_nodes = (not full_UI_table.name and full_UI_table.main) or full_UI_table.info
    local name_override = nil
    local info_queue = {}

    if full_UI_table.name then
        full_UI_table.info[#full_UI_table.info+1] = {}
        desc_nodes = full_UI_table.info[#full_UI_table.info]
    end

    if not full_UI_table.name then
        if specific_vars and specific_vars.no_name then
            full_UI_table.name = true
        elseif card_type == 'Locked' then
            full_UI_table.name = localize{type = 'name', set = 'Other', key = 'locked', nodes = {}}
        elseif card_type == 'Undiscovered' then 
            full_UI_table.name = localize{type = 'name', set = 'Other', key = 'undiscovered_'..(string.lower(_c.set)), name_nodes = {}}
        elseif specific_vars and (card_type == 'Default' or card_type == 'Enhanced') then
            if (_c.name == 'Stone Card') then full_UI_table.name = true end
            if (specific_vars.playing_card and (_c.name ~= 'Stone Card')) then
                full_UI_table.name = {}
                localize{type = 'other', key = 'playing_card', set = 'Other', nodes = full_UI_table.name, vars = {localize(specific_vars.value, 'ranks'), localize(specific_vars.suit, 'suits_plural'), colours = {specific_vars.colour}}}
                full_UI_table.name = full_UI_table.name[1]
            end
        elseif card_type == 'Booster' then
            
        else
            full_UI_table.name = localize{type = 'name', set = _c.set, key = _c.key, nodes = full_UI_table.name}
        end
        full_UI_table.card_type = card_type or _c.set
    end 

    local loc_vars = {}
    if main_start then 
        desc_nodes[#desc_nodes+1] = main_start 
    end

    if _c.set == 'Other' then
        localize{type = 'other', key = _c.key, nodes = desc_nodes, vars = specific_vars or _c.vars}
    elseif card_type == 'Locked' then
        if _c.wip then localize{type = 'other', key = 'wip_locked', set = 'Other', nodes = desc_nodes, vars = loc_vars}
        elseif _c.demo and specific_vars then localize{type = 'other', key = 'demo_shop_locked', nodes = desc_nodes, vars = loc_vars}  
        elseif _c.demo then localize{type = 'other', key = 'demo_locked', nodes = desc_nodes, vars = loc_vars}
        else
            if _c.name == 'Golden Ticket' then
            elseif _c.name == 'Mr. Bones' then loc_vars = {_c.unlock_condition.extra, G.PROFILES[G.SETTINGS.profile].career_stats.c_losses}
            elseif _c.name == 'Acrobat' then loc_vars = {_c.unlock_condition.extra, G.PROFILES[G.SETTINGS.profile].career_stats.c_hands_played}
            elseif _c.name == 'Sock and Buskin' then loc_vars = {_c.unlock_condition.extra, G.PROFILES[G.SETTINGS.profile].career_stats.c_face_cards_played}
            elseif _c.name == 'Swashbuckler' then loc_vars = {_c.unlock_condition.extra, G.PROFILES[G.SETTINGS.profile].career_stats.c_jokers_sold}
            elseif _c.name == 'Troubadour' then loc_vars = {_c.unlock_condition.extra}
            elseif _c.name == 'Certificate' then
            elseif _c.name == 'Smeared Joker' then loc_vars = {_c.unlock_condition.extra.count,localize{type = 'name_text', key = _c.unlock_condition.extra.e_key, set = 'Enhanced'}}
            elseif _c.name == 'Throwback' then
            elseif _c.name == 'Hanging Chad' then loc_vars = {localize(_c.unlock_condition.extra, 'poker_hands')}
            elseif _c.name == 'Rough Gem' then loc_vars = {_c.unlock_condition.extra.count, localize(_c.unlock_condition.extra.suit, 'suits_singular')}
            elseif _c.name == 'Bloodstone' then loc_vars = {_c.unlock_condition.extra.count, localize(_c.unlock_condition.extra.suit, 'suits_singular')}
            elseif _c.name == 'Arrowhead' then loc_vars = {_c.unlock_condition.extra.count, localize(_c.unlock_condition.extra.suit, 'suits_singular')}
            elseif _c.name == 'Onyx Agate' then loc_vars = {_c.unlock_condition.extra.count, localize(_c.unlock_condition.extra.suit, 'suits_singular')}
            elseif _c.name == 'Glass Joker' then loc_vars = {_c.unlock_condition.extra.count, localize{type = 'name_text', key = _c.unlock_condition.extra.e_key, set = 'Enhanced'}}
            elseif _c.name == 'Showman' then loc_vars = {_c.unlock_condition.ante}
            elseif _c.name == 'Flower Pot' then loc_vars = {_c.unlock_condition.ante}
            elseif _c.name == 'Blueprint' then
            elseif _c.name == 'Wee Joker' then loc_vars = {_c.unlock_condition.n_rounds}
            elseif _c.name == 'Merry Andy' then loc_vars = {_c.unlock_condition.n_rounds}
            elseif _c.name == 'Oops! All 6s' then loc_vars = {number_format(_c.unlock_condition.chips)}
            elseif _c.name == 'The Idol' then loc_vars = {number_format(_c.unlock_condition.chips)}
            elseif _c.name == 'Seeing Double' then loc_vars = {localize("ph_4_7_of_clubs")}
            elseif _c.name == 'Matador' then
            elseif _c.name == 'Hit the Road' then
            elseif _c.name == 'The Duo' then loc_vars = {localize(_c.unlock_condition.extra, 'poker_hands')}
            elseif _c.name == 'The Trio' then loc_vars = {localize(_c.unlock_condition.extra, 'poker_hands')}
            elseif _c.name == 'The Family' then loc_vars = {localize(_c.unlock_condition.extra, 'poker_hands')}
            elseif _c.name == 'The Order' then loc_vars = {localize(_c.unlock_condition.extra, 'poker_hands')}
            elseif _c.name == 'The Tribe' then loc_vars = {localize(_c.unlock_condition.extra, 'poker_hands')}
            elseif _c.name == 'Stuntman' then loc_vars = {number_format(_c.unlock_condition.chips)}
            elseif _c.name == 'Invisible Joker' then
            elseif _c.name == 'Brainstorm' then
            elseif _c.name == 'Satellite' then loc_vars = {_c.unlock_condition.extra}
            elseif _c.name == 'Shoot the Moon' then
            elseif _c.name == "Driver's License" then loc_vars = {_c.unlock_condition.extra.count}
            elseif _c.name == 'Cartomancer' then loc_vars = {_c.unlock_condition.tarot_count}
            elseif _c.name == 'Astronomer' then
            elseif _c.name == 'Burnt Joker' then loc_vars = {_c.unlock_condition.extra, G.PROFILES[G.SETTINGS.profile].career_stats.c_cards_sold}
            elseif _c.name == 'Bootstraps' then loc_vars = {_c.unlock_condition.extra.count}
                --Vouchers
            elseif _c.name == 'Overstock Plus' then loc_vars = {_c.unlock_condition.extra, G.PROFILES[G.SETTINGS.profile].career_stats.c_shop_dollars_spent}
            elseif _c.name == 'Liquidation' then loc_vars = {_c.unlock_condition.extra}
            elseif _c.name == 'Tarot Tycoon' then loc_vars = {_c.unlock_condition.extra, G.PROFILES[G.SETTINGS.profile].career_stats.c_tarots_bought}
            elseif _c.name == 'Planet Tycoon' then loc_vars = {_c.unlock_condition.extra, G.PROFILES[G.SETTINGS.profile].career_stats.c_planets_bought}
            elseif _c.name == 'Glow Up' then loc_vars = {_c.unlock_condition.extra}
            elseif _c.name == 'Reroll Glut' then loc_vars = {_c.unlock_condition.extra, G.PROFILES[G.SETTINGS.profile].career_stats.c_shop_rerolls}
            elseif _c.name == 'Omen Globe' then loc_vars = {_c.unlock_condition.extra, G.PROFILES[G.SETTINGS.profile].career_stats.c_tarot_reading_used}
            elseif _c.name == 'Observatory' then loc_vars = {_c.unlock_condition.extra, G.PROFILES[G.SETTINGS.profile].career_stats.c_planetarium_used}
            elseif _c.name == 'Nacho Tong' then loc_vars = {_c.unlock_condition.extra, G.PROFILES[G.SETTINGS.profile].career_stats.c_cards_played}
            elseif _c.name == 'Recyclomancy' then loc_vars = {_c.unlock_condition.extra, G.PROFILES[G.SETTINGS.profile].career_stats.c_cards_discarded}
            elseif _c.name == 'Money Tree' then loc_vars = {_c.unlock_condition.extra, G.PROFILES[G.SETTINGS.profile].career_stats.c_round_interest_cap_streak}
            elseif _c.name == 'Antimatter' then loc_vars = {_c.unlock_condition.extra, G.PROFILES[G.SETTINGS.profile].voucher_usage.v_blank and G.PROFILES[G.SETTINGS.profile].voucher_usage.v_blank.count or 0}
            elseif _c.name == 'Illusion' then loc_vars = {_c.unlock_condition.extra, G.PROFILES[G.SETTINGS.profile].career_stats.c_playing_cards_bought}
            elseif _c.name == 'Petroglyph' then loc_vars = {_c.unlock_condition.extra}
            elseif _c.name == 'Retcon' then loc_vars = {_c.unlock_condition.extra}
            elseif _c.name == 'Palette' then loc_vars = {_c.unlock_condition.extra}
            end
            
            if _c.rarity and _c.rarity == 4 and specific_vars and not specific_vars.not_hidden then 
                localize{type = 'unlocks', key = 'joker_locked_legendary', set = 'Other', nodes = desc_nodes, vars = loc_vars}
            else

            localize{type = 'unlocks', key = _c.key, set = _c.set, nodes = desc_nodes, vars = loc_vars}
            end
        end
    elseif hide_desc then
        localize{type = 'other', key = 'undiscovered_'..(string.lower(_c.set)), set = _c.set, nodes = desc_nodes}
    elseif specific_vars and specific_vars.debuffed then
        localize{type = 'other', key = 'debuffed_'..(specific_vars.playing_card and 'playing_card' or 'default'), nodes = desc_nodes}
    elseif _c.set == 'Joker' then
        if _c.name == 'Stone Joker' or _c.name == 'Marble Joker' then info_queue[#info_queue+1] = G.P_CENTERS.m_stone
        elseif _c.name == 'Steel Joker' then info_queue[#info_queue+1] = G.P_CENTERS.m_steel 
        elseif _c.name == 'Glass Joker' then info_queue[#info_queue+1] = G.P_CENTERS.m_glass 
        elseif _c.name == 'Golden Ticket' then info_queue[#info_queue+1] = G.P_CENTERS.m_gold 
        elseif _c.name == 'Lucky Cat' then info_queue[#info_queue+1] = G.P_CENTERS.m_lucky 
        elseif _c.name == 'Midas Mask' then info_queue[#info_queue+1] = G.P_CENTERS.m_gold
        elseif _c.name == 'Invisible Joker' then 
            if G.jokers and G.jokers.cards then
                for k, v in ipairs(G.jokers.cards) do
                    if (v.edition and v.edition.negative) and (G.localization.descriptions.Other.remove_negative)then 
                        main_end = {}
                        localize{type = 'other', key = 'remove_negative', nodes = main_end, vars = {}}
                        main_end = main_end[1]
                        break
                    end
                end
            end 
        elseif _c.name == 'Diet Cola' then info_queue[#info_queue+1] = {key = 'tag_double', set = 'Tag'}
        elseif _c.name == 'Perkeo' then info_queue[#info_queue+1] = {key = 'e_negative_consumable', set = 'Edition', config = {extra = 1}}
        end
        if specific_vars and specific_vars.pinned then info_queue[#info_queue+1] = {key = 'pinned_left', set = 'Other'} end
        if specific_vars and specific_vars.sticker then info_queue[#info_queue+1] = {key = string.lower(specific_vars.sticker)..'_sticker', set = 'Other'} end
        localize{type = 'descriptions', key = _c.key, set = _c.set, nodes = desc_nodes, vars = specific_vars or {}}
    elseif _c.set == 'Tag' then
        if _c.name == 'Negative Tag' then info_queue[#info_queue+1] = G.P_CENTERS.e_negative
        elseif _c.name == 'Foil Tag' then info_queue[#info_queue+1] = G.P_CENTERS.e_foil 
        elseif _c.name == 'Holographic Tag' then info_queue[#info_queue+1] = G.P_CENTERS.e_holo
        elseif _c.name == 'Polychrome Tag' then info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome 
        elseif _c.name == 'Charm Tag' then info_queue[#info_queue+1] = G.P_CENTERS.p_arcana_mega_1 
        elseif _c.name == 'Meteor Tag' then info_queue[#info_queue+1] = G.P_CENTERS.p_celestial_mega_1 
        elseif _c.name == 'Ethereal Tag' then info_queue[#info_queue+1] = G.P_CENTERS.p_spectral_normal_1 
        elseif _c.name == 'Standard Tag' then info_queue[#info_queue+1] = G.P_CENTERS.p_standard_mega_1 
        elseif _c.name == 'Buffoon Tag' then info_queue[#info_queue+1] = G.P_CENTERS.p_buffoon_mega_1 
        end
        localize{type = 'descriptions', key = _c.key, set = 'Tag', nodes = desc_nodes, vars = specific_vars or {}}
    elseif _c.set == 'Voucher' then
        if _c.name == "Overstock" or _c.name == 'Overstock Plus' then
        elseif _c.name == "Tarot Merchant" or _c.name == "Tarot Tycoon" then loc_vars = {_c.config.extra_disp}
        elseif _c.name == "Planet Merchant" or _c.name == "Planet Tycoon" then loc_vars = {_c.config.extra_disp}
        elseif _c.name == "Hone" or _c.name == "Glow Up" then loc_vars = {_c.config.extra}
        elseif _c.name == "Reroll Surplus" or _c.name == "Reroll Glut" then loc_vars = {_c.config.extra}
        elseif _c.name == "Grabber" or _c.name == "Nacho Tong" then loc_vars = {_c.config.extra}
        elseif _c.name == "Wasteful" or _c.name == "Recyclomancy" then loc_vars = {_c.config.extra}
        elseif _c.name == "Seed Money" or _c.name == "Money Tree" then loc_vars = {_c.config.extra/5}
        elseif _c.name == "Blank" or _c.name == "Antimatter" then
        elseif _c.name == "Hieroglyph" or _c.name == "Petroglyph" then loc_vars = {_c.config.extra}
        elseif _c.name == "Director's Cut" or _c.name == "Retcon" then loc_vars = {_c.config.extra}
        elseif _c.name == "Paint Brush" or _c.name == "Palette" then loc_vars = {_c.config.extra}
        elseif _c.name == "Telescope" or _c.name == "Observatory" then loc_vars = {_c.config.extra}
        elseif _c.name == "Clearance Sale" or _c.name == "Liquidation" then loc_vars = {_c.config.extra}
        end
        localize{type = 'descriptions', key = _c.key, set = _c.set, nodes = desc_nodes, vars = loc_vars}
    elseif _c.set == 'Edition' then
        loc_vars = {_c.config.extra}
        localize{type = 'descriptions', key = _c.key, set = _c.set, nodes = desc_nodes, vars = loc_vars}
    elseif _c.set == 'Default' and specific_vars then 
        if specific_vars.nominal_chips then 
            localize{type = 'other', key = 'card_chips', nodes = desc_nodes, vars = {specific_vars.nominal_chips}}
        end
        if specific_vars.bonus_chips then
            localize{type = 'other', key = 'card_extra_chips', nodes = desc_nodes, vars = {specific_vars.bonus_chips}}
        end
    elseif _c.set == 'Enhanced' then 
        if specific_vars and _c.name ~= 'Stone Card' and specific_vars.nominal_chips then
            localize{type = 'other', key = 'card_chips', nodes = desc_nodes, vars = {specific_vars.nominal_chips}}
        end
        if _c.effect == 'Mult Card' then loc_vars = {_c.config.mult}
        elseif _c.effect == 'Wild Card' then
        elseif _c.effect == 'Glass Card' then loc_vars = {_c.config.Xmult, G.GAME.probabilities.normal, _c.config.extra}
        elseif _c.effect == 'Steel Card' then loc_vars = {_c.config.h_x_mult}
        elseif _c.effect == 'Stone Card' then loc_vars = {((specific_vars and specific_vars.bonus_chips) or _c.config.bonus)}
        elseif _c.effect == 'Gold Card' then loc_vars = {_c.config.h_dollars}
        elseif _c.effect == 'Lucky Card' then loc_vars = {G.GAME.probabilities.normal, _c.config.mult, 5, _c.config.p_dollars, 15}
        end
        localize{type = 'descriptions', key = _c.key, set = _c.set, nodes = desc_nodes, vars = loc_vars}
        if _c.name ~= 'Stone Card' and ((specific_vars and specific_vars.bonus_chips) or _c.config.bonus) then
            localize{type = 'other', key = 'card_extra_chips', nodes = desc_nodes, vars = {((specific_vars and specific_vars.bonus_chips) or _c.config.bonus)}}
        end
    elseif _c.set == 'Booster' then 
        local desc_override = 'p_arcana_normal'
        if _c.name == 'Arcana Pack' then desc_override = 'p_arcana_normal'; loc_vars = {_c.config.choose, _c.config.extra}
        elseif _c.name == 'Jumbo Arcana Pack' then desc_override = 'p_arcana_jumbo'; loc_vars = {_c.config.choose, _c.config.extra}
        elseif _c.name == 'Mega Arcana Pack' then desc_override = 'p_arcana_mega'; loc_vars = {_c.config.choose, _c.config.extra}
        elseif _c.name == 'Celestial Pack' then desc_override = 'p_celestial_normal'; loc_vars = {_c.config.choose, _c.config.extra}
        elseif _c.name == 'Jumbo Celestial Pack' then desc_override = 'p_celestial_jumbo'; loc_vars = {_c.config.choose, _c.config.extra}
        elseif _c.name == 'Mega Celestial Pack' then desc_override = 'p_celestial_mega'; loc_vars = {_c.config.choose, _c.config.extra}
        elseif _c.name == 'Spectral Pack' then desc_override = 'p_spectral_normal'; loc_vars = {_c.config.choose, _c.config.extra}
        elseif _c.name == 'Jumbo Spectral Pack' then desc_override = 'p_spectral_jumbo'; loc_vars = {_c.config.choose, _c.config.extra}
        elseif _c.name == 'Mega Spectral Pack' then desc_override = 'p_spectral_mega'; loc_vars = {_c.config.choose, _c.config.extra}
        elseif _c.name == 'Standard Pack' then desc_override = 'p_standard_normal'; loc_vars = {_c.config.choose, _c.config.extra}
        elseif _c.name == 'Jumbo Standard Pack' then desc_override = 'p_standard_jumbo'; loc_vars = {_c.config.choose, _c.config.extra}
        elseif _c.name == 'Mega Standard Pack' then desc_override = 'p_standard_mega'; loc_vars = {_c.config.choose, _c.config.extra}
        elseif _c.name == 'Buffoon Pack' then desc_override = 'p_buffoon_normal'; loc_vars = {_c.config.choose, _c.config.extra}
        elseif _c.name == 'Jumbo Buffoon Pack' then desc_override = 'p_buffoon_jumbo'; loc_vars = {_c.config.choose, _c.config.extra}
        elseif _c.name == 'Mega Buffoon Pack' then desc_override = 'p_buffoon_mega'; loc_vars = {_c.config.choose, _c.config.extra}
        end
        name_override = desc_override
        if not full_UI_table.name then full_UI_table.name = localize{type = 'name', set = 'Other', key = name_override, nodes = full_UI_table.name} end
        localize{type = 'other', key = desc_override, nodes = desc_nodes, vars = loc_vars}
    elseif _c.set == 'Spectral' then 
        if _c.name == 'Familiar' or _c.name == 'Grim' or _c.name == 'Incantation' then loc_vars = {_c.config.extra}
        elseif _c.name == 'Immolate' then loc_vars = {_c.config.extra.destroy, _c.config.extra.dollars}
        elseif _c.name == 'Hex' then info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome
        elseif _c.name == 'Talisman' then info_queue[#info_queue+1] = {key = 'gold_seal', set = 'Other'}
        elseif _c.name == 'Deja Vu' then info_queue[#info_queue+1] = {key = 'red_seal', set = 'Other'}
        elseif _c.name == 'Trance' then info_queue[#info_queue+1] = {key = 'blue_seal', set = 'Other'}
        elseif _c.name == 'Medium' then info_queue[#info_queue+1] = {key = 'purple_seal', set = 'Other'}
        elseif _c.name == 'Ankh' then
            if G.jokers and G.jokers.cards then
                for k, v in ipairs(G.jokers.cards) do
                    if (v.edition and v.edition.negative) and (G.localization.descriptions.Other.remove_negative)then 
                        info_queue[#info_queue+1] = G.P_CENTERS.e_negative
                        main_end = {}
                        localize{type = 'other', key = 'remove_negative', nodes = main_end, vars = {}}
                        main_end = main_end[1]
                        break
                    end
                end
            end
        elseif _c.name == 'Cryptid' then loc_vars = {_c.config.extra}
        end
        if _c.name == 'Ectoplasm' then info_queue[#info_queue+1] = G.P_CENTERS.e_negative; loc_vars = {G.GAME.ecto_minus or 1} end
        if _c.name == 'Aura' then
            info_queue[#info_queue+1] = G.P_CENTERS.e_foil
            info_queue[#info_queue+1] = G.P_CENTERS.e_holo
            info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome
        end
        localize{type = 'descriptions', key = _c.key, set = _c.set, nodes = desc_nodes, vars = loc_vars}
    elseif _c.set == 'Planet' then
        loc_vars = {
            G.GAME.hands[_c.config.hand_type].level,localize(_c.config.hand_type, 'poker_hands'), G.GAME.hands[_c.config.hand_type].l_mult, G.GAME.hands[_c.config.hand_type].l_chips,
            colours = {(G.GAME.hands[_c.config.hand_type].level==1 and G.C.UI.TEXT_DARK or G.C.HAND_LEVELS[math.min(7, G.GAME.hands[_c.config.hand_type].level)])}
        }
        localize{type = 'descriptions', key = _c.key, set = _c.set, nodes = desc_nodes, vars = loc_vars}
    elseif _c.set == 'Tarot' then
       if _c.name == "The Fool" then
            local fool_c = G.GAME.last_tarot_planet and G.P_CENTERS[G.GAME.last_tarot_planet] or nil
            local last_tarot_planet = fool_c and localize{type = 'name_text', key = fool_c.key, set = fool_c.set} or localize('k_none')
            local colour = (not fool_c or fool_c.name == 'The Fool') and G.C.RED or G.C.GREEN
            main_end = {
                {n=G.UIT.C, config={align = "bm", padding = 0.02}, nodes={
                    {n=G.UIT.C, config={align = "m", colour = colour, r = 0.05, padding = 0.05}, nodes={
                        {n=G.UIT.T, config={text = ' '..last_tarot_planet..' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true}},
                    }}
                }}
            }
           loc_vars = {last_tarot_planet}
           if not (not fool_c or fool_c.name == 'The Fool') then
                info_queue[#info_queue+1] = fool_c
           end
       elseif _c.name == "The Magician" then loc_vars = {_c.config.max_highlighted, localize{type = 'name_text', set = 'Enhanced', key = _c.config.mod_conv}}; info_queue[#info_queue+1] = G.P_CENTERS[_c.config.mod_conv]
       elseif _c.name == "The High Priestess" then loc_vars = {_c.config.planets}
       elseif _c.name == "The Empress" then loc_vars = {_c.config.max_highlighted, localize{type = 'name_text', set = 'Enhanced', key = _c.config.mod_conv}}; info_queue[#info_queue+1] = G.P_CENTERS[_c.config.mod_conv]
       elseif _c.name == "The Emperor" then loc_vars = {_c.config.tarots}
       elseif _c.name == "The Hierophant" then loc_vars = {_c.config.max_highlighted, localize{type = 'name_text', set = 'Enhanced', key = _c.config.mod_conv}}; info_queue[#info_queue+1] = G.P_CENTERS[_c.config.mod_conv]
       elseif _c.name == "The Lovers" then loc_vars = {_c.config.max_highlighted, localize{type = 'name_text', set = 'Enhanced', key = _c.config.mod_conv}}; info_queue[#info_queue+1] = G.P_CENTERS[_c.config.mod_conv]
       elseif _c.name == "The Chariot" then loc_vars = {_c.config.max_highlighted, localize{type = 'name_text', set = 'Enhanced', key = _c.config.mod_conv}}; info_queue[#info_queue+1] = G.P_CENTERS[_c.config.mod_conv]
       elseif _c.name == "Justice" then loc_vars = {_c.config.max_highlighted, localize{type = 'name_text', set = 'Enhanced', key = _c.config.mod_conv}}; info_queue[#info_queue+1] = G.P_CENTERS[_c.config.mod_conv]
       elseif _c.name == "The Hermit" then loc_vars = {_c.config.extra}
       elseif _c.name == "The Wheel of Fortune" then loc_vars = {G.GAME.probabilities.normal, _c.config.extra};  info_queue[#info_queue+1] = G.P_CENTERS.e_foil; info_queue[#info_queue+1] = G.P_CENTERS.e_holo; info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome; 
       elseif _c.name == "Strength" then loc_vars = {_c.config.max_highlighted}
       elseif _c.name == "The Hanged Man" then loc_vars = {_c.config.max_highlighted}
       elseif _c.name == "Death" then loc_vars = {_c.config.max_highlighted}
       elseif _c.name == "Temperance" then
        local _money = 0
        if G.jokers then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.set == 'Joker' then
                    _money = _money + G.jokers.cards[i].sell_cost
                end
            end
        end
        loc_vars = {_c.config.extra, math.min(_c.config.extra, math.floor(_money*(1 + (tarot_level-1)/2)))}
       elseif _c.name == "The Devil" then loc_vars = {_c.config.max_highlighted, localize{type = 'name_text', set = 'Enhanced', key = _c.config.mod_conv}}; info_queue[#info_queue+1] = G.P_CENTERS[_c.config.mod_conv]
       elseif _c.name == "The Tower" then loc_vars = {_c.config.max_highlighted, localize{type = 'name_text', set = 'Enhanced', key = _c.config.mod_conv}}; info_queue[#info_queue+1] = G.P_CENTERS[_c.config.mod_conv]
       elseif _c.name == "The Star" then loc_vars = {_c.config.max_highlighted,  localize(_c.config.suit_conv, 'suits_plural'), colours = {G.C.SUITS[_c.config.suit_conv]}}
       elseif _c.name == "The Moon" then loc_vars = {_c.config.max_highlighted, localize(_c.config.suit_conv, 'suits_plural'), colours = {G.C.SUITS[_c.config.suit_conv]}}
       elseif _c.name == "The Sun" then loc_vars = {_c.config.max_highlighted, localize(_c.config.suit_conv, 'suits_plural'), colours = {G.C.SUITS[_c.config.suit_conv]}}
       elseif _c.name == "Judgement" then
       elseif _c.name == "The World" then loc_vars = {_c.config.max_highlighted, localize(_c.config.suit_conv, 'suits_plural'), colours = {G.C.SUITS[_c.config.suit_conv]}}
       end
       localize{type = 'descriptions', key = _c.key, set = _c.set, nodes = desc_nodes, vars = loc_vars}
   end

    if main_end then 
        desc_nodes[#desc_nodes+1] = main_end 
    end

   --Fill all remaining info if this is the main desc
    if not ((specific_vars and not specific_vars.sticker) and (card_type == 'Default' or card_type == 'Enhanced')) then
        if desc_nodes == full_UI_table.main and not full_UI_table.name then
            localize{type = 'name', key = _c.key, set = _c.set, nodes = full_UI_table.name} 
            if not full_UI_table.name then full_UI_table.name = {} end
        elseif desc_nodes ~= full_UI_table.main then 
            desc_nodes.name = localize{type = 'name_text', key = name_override or _c.key, set = name_override and 'Other' or _c.set} 
        end
    end

    if first_pass and not (_c.set == 'Edition') and badges then
        for k, v in ipairs(badges) do
            if v == 'foil' then info_queue[#info_queue+1] = G.P_CENTERS['e_foil'] end
            if v == 'holographic' then info_queue[#info_queue+1] = G.P_CENTERS['e_holo'] end
            if v == 'polychrome' then info_queue[#info_queue+1] = G.P_CENTERS['e_polychrome'] end
            if v == 'negative' then info_queue[#info_queue+1] = G.P_CENTERS['e_negative'] end
            if v == 'negative_consumable' then info_queue[#info_queue+1] = {key = 'e_negative_consumable', set = 'Edition', config = {extra = 1}} end
            if v == 'gold_seal' then info_queue[#info_queue+1] = {key = 'gold_seal', set = 'Other'} end
            if v == 'blue_seal' then info_queue[#info_queue+1] = {key = 'blue_seal', set = 'Other'} end
            if v == 'red_seal' then info_queue[#info_queue+1] = {key = 'red_seal', set = 'Other'} end
            if v == 'purple_seal' then info_queue[#info_queue+1] = {key = 'purple_seal', set = 'Other'} end
            if v == 'eternal' then info_queue[#info_queue+1] = {key = 'eternal', set = 'Other'} end
            if v == 'perishable' then info_queue[#info_queue+1] = {key = 'perishable', set = 'Other', vars = {G.GAME.perishable_rounds or 1, specific_vars.perish_tally or G.GAME.perishable_rounds}} end
            if v == 'rental' then info_queue[#info_queue+1] = {key = 'rental', set = 'Other', vars = {G.GAME.rental_rate or 1}} end
            if v == 'pinned_left' then info_queue[#info_queue+1] = {key = 'pinned_left', set = 'Other'} end
        end
    end

    for _, v in ipairs(info_queue) do
        generate_card_ui(v, full_UI_table)
    end

    return full_UI_table
end

-- "remove Negative from copy" is now local
G.localization.descriptions.Other.remove_negative = {
  name = "n",
  text = {}
}

-- Unimplemented bosses: Crimson Heart, Cerulean Bell

-- BLIND DESCRIPTIONS
function blind_desc(probability)
  if not probability then
    probability = 1
  end

  -- The Hook
  if blind_level <= 0 then
    G.localization.descriptions.Blind.bl_hook = {
      name = "The Hook",
      text = {
        "(lvl."..blind_level..")",
        "Boss disabled"
      }
    }
  elseif blind_level >= 1 then
    G.localization.descriptions.Blind.bl_hook = {
      name = "The Hook",
      text = {
        "(lvl."..blind_level..")",
        "Discards "..(blind_level+1).." random",
        "cards per hand played"
      }
    }
  end

  -- The Tooth
  if blind_level <= -1 then
    G.localization.descriptions.Blind.bl_tooth = {
      name = "The Tooth",
      text = {
        "(lvl."..blind_level..")",
        "Gain $"..(-blind_level).." per",
        "card played"
      }
    }
  elseif blind_level == 0 then
    G.localization.descriptions.Blind.bl_tooth = {
      name = "The Tooth",
      text = {
        "(lvl."..blind_level..")",
        "Boss disabled"
      }
    }
  elseif blind_level >= 1 then
    G.localization.descriptions.Blind.bl_tooth = {
      name = "The Tooth",
      text = {
        "(lvl."..blind_level..")",
        "Lose $"..(blind_level).." per",
        "card played"
      }
    }
  end

  -- Water
  if blind_level <= -1 then
    G.localization.descriptions.Blind.bl_water = {
      name = "The Water",
      text = {
        "(lvl."..blind_level..")",
        "+"..-blind_level.." discard"
      }
    }
  elseif blind_level == 0 then
    G.localization.descriptions.Blind.bl_water = {
      name = "The Water",
      text = {
        "(lvl."..blind_level..")",
        "Boss disabled"
      }
    }
  elseif blind_level >= 1 then
    G.localization.descriptions.Blind.bl_water = {
      name = "The Water",
      text = {
        "(lvl."..blind_level..")",
        "Start with",
        "0 discards"
      }
    }
  end

  -- Needle
  if blind_level <= -1 then
    G.localization.descriptions.Blind.bl_needle = {
      name = "The Needle",
      text = {
        "(lvl."..blind_level..")",  
        "+"..-blind_level.." hands"
      }
    }
  elseif blind_level == 0 then
    G.localization.descriptions.Blind.bl_needle = {
      name = "The Needle",
      text = {
        "(lvl."..blind_level..")",
        "Boss disabled"
      }
    }
  elseif blind_level >= 1 then
    G.localization.descriptions.Blind.bl_needle = {
      name = "The Needle",
      text = {
        "(lvl."..blind_level..")",
        "Play only 1 hand"
      }
    }
  end

  -- Arm
  if blind_level <= -1 then
    G.localization.descriptions.Blind.bl_arm = {
      name = "The Arm",
      text = {
        "(lvl."..blind_level..")",    
        "Upgrade played poker",
        "hand by "..-blind_level.." levels"
      }
    }
  elseif blind_level == 0 then
    G.localization.descriptions.Blind.bl_arm = {
      name = "The Arm",
      text = {
        "(lvl."..blind_level..")",
        "Boss disabled"
      }
    }
  elseif blind_level >= 1 then
    G.localization.descriptions.Blind.bl_arm = {
      name = "The Arm",
      text = {
        "(lvl."..blind_level..")",
        "Decrease level of played",
        "poker hand by "..blind_level.." levels"
      }
    }
  end

  -- Manacle
  if blind_level <= -1 then
    G.localization.descriptions.Blind.bl_manacle = {
      name = "The Manacle",
      text = {
        "(lvl."..blind_level..")",    
        "+"..-blind_level.." hand size"
      }
    }
  elseif blind_level == 0 then
    G.localization.descriptions.Blind.bl_manacle = {
      name = "The Manacle",
      text = {
        "(lvl."..blind_level..")",
        "Boss disabled"
      }
    }
  elseif blind_level >= 1 then
    G.localization.descriptions.Blind.bl_manacle = {
      name = "The Manacle",
      text = {
        "(lvl."..blind_level..")",
        "-"..math.min(2, blind_level).." hand size"
      }
    }
  end

  -- Wall
  if blind_level <= -1 then
    G.localization.descriptions.Blind.bl_wall = {
      name = "The Wall",
      text = {
        "(lvl."..blind_level..")",  
        "1/"..2^(-blind_level).."X blind size"
      }
    }
  elseif blind_level == 0 then
    G.localization.descriptions.Blind.bl_wall = {
      name = "The Wall",
      text = {
        "(lvl."..blind_level..")",
        "Boss disabled"
      }
    }
  elseif blind_level >= 1 then
    G.localization.descriptions.Blind.bl_wall = {
      name = "The Wall",
      text = {
        "(lvl."..blind_level..")",
        (blind_level+1).."X blind size"
      }
    }
  end

  -- Violet Vessel
  if blind_level <= -1 then
    G.localization.descriptions.Blind.bl_final_vessel = {
      name = "Violet Vessel",
      text = {
        "(lvl."..blind_level..")",   
        "1/"..3^(-blind_level).."X blind size"
      }
    }
  elseif blind_level == 0 then
    G.localization.descriptions.Blind.bl_final_vessel = {
      name = "Violet Vessel",
      text = {
        "(lvl."..blind_level..")",
        "Boss disabled"
      }
    }
  elseif blind_level >= 1 then
    G.localization.descriptions.Blind.bl_final_vessel = {
      name = "Violet Vessel",
      text = {
        "(lvl."..blind_level..")",
        ((blind_level*2)+1).."X blind size"
      }
    }
  end

  -- The Serpent
  if blind_level <= 0 then
    G.localization.descriptions.Blind.bl_serpent = {
      name = "The Serpent",
      text = {
        "(lvl."..blind_level..")",
        "Boss disabled"
      }
    }
  elseif blind_level >= 1 then
    G.localization.descriptions.Blind.bl_serpent = {
      name = "The Serpent",
      text = {
        "(lvl."..blind_level..")",
        "After Play or Discard,",
        "always draw "..(blind_level+2).." cards"
      }
    }
  end

  -- Debuff bosses
  if blind_level <= -1 then
    G.localization.descriptions.Blind.bl_head = {
      name = "The Head",
      text = {
        "(lvl."..blind_level..")",
        "All Heart cards",
        "are retriggered"
      }
    }
    G.localization.descriptions.Blind.bl_goad = {
      name = "The Goad",
      text = {
        "(lvl."..blind_level..")",
        "All Spade cards",
        "are retriggered"
      }
    }
    G.localization.descriptions.Blind.bl_window = {
      name = "The Window",
      text = {
        "(lvl."..blind_level..")",
        "All Diamond cards",
        "are retriggered"
      }
    }
    G.localization.descriptions.Blind.bl_club = {
      name = "The Club",
      text = {
        "(lvl."..blind_level..")",
        "All Club cards",
        "are retriggered"
      }
    }
    G.localization.descriptions.Blind.bl_plant = {
      name = "The Plant",
      text = {
        "(lvl."..blind_level..")",
        "All face cards",
        "are retriggered"
      }
    }
    G.localization.descriptions.Blind.bl_pillar = {
      name = "The Pillar",
      text = {
        "(lvl."..blind_level..")",
        "All cards are",
        "retriggered"
      }
    }
    G.localization.descriptions.Blind.bl_final_leaf = {
      name = "Verdant Leaf",
      text = {
        "(lvl."..blind_level..")",
        "All cards are retriggered"
      }
    }
  elseif blind_level == 0 then
    G.localization.descriptions.Blind.bl_head = {
      name = "The Head",
      text = {
        "(lvl."..blind_level..")",
        "Boss disabled"
      }
    }
    G.localization.descriptions.Blind.bl_goad = {
      name = "The Goad",
      text = {
        "(lvl."..blind_level..")",
        "Boss disabled"
      }
    }
    G.localization.descriptions.Blind.bl_window = {
      name = "The Window",
      text = {
        "(lvl."..blind_level..")",
        "Boss disabled"
      }
    }
    G.localization.descriptions.Blind.bl_club = {
      name = "The Club",
      text = {
        "(lvl."..blind_level..")",
        "Boss disabled"
      }
    }
    G.localization.descriptions.Blind.bl_plant = {
      name = "The Plant",
      text = {
        "(lvl."..blind_level..")",
        "Boss disabled"
      }
    }
    G.localization.descriptions.Blind.bl_pillar = {
      name = "The Pillar",
      text = {
        "(lvl."..blind_level..")",
        "Boss disabled"
      }
    }
    G.localization.descriptions.Blind.bl_final_leaf = {
      name = "Verdant Leaf",
      text = {
        "(lvl."..blind_level..")",
        "Boss disabled"
      }
    }
  elseif blind_level == 1 then
    G.localization.descriptions.Blind.bl_head = {
      name = "The Head",
      text = {
        "(lvl."..blind_level..")",
        "All Heart cards",
        "are debuffed"
      }
    }
    G.localization.descriptions.Blind.bl_goad = {
      name = "The Goad",
      text = {
        "(Level "..blind_level..")",
        "All Spade cards",
        "are debuffed"
      }
    }
    G.localization.descriptions.Blind.bl_window = {
      name = "The Window",
      text = {
        "(lvl."..blind_level..")",
        "All Diamond cards",
        "are debuffed"
      }
    }
    G.localization.descriptions.Blind.bl_club = {
      name = "The Club",
      text = {
        "(lvl."..blind_level..")",
        "All Club cards",
        "are debuffed"
      }
    }
    G.localization.descriptions.Blind.bl_plant = {
      name = "The Plant",
      text = {
        "(lvl."..blind_level..")",
        "All face cards",
        "are debuffed"
      }
    }
    G.localization.descriptions.Blind.bl_pillar = {
      name = "The Pillar",
      text = {
        "(lvl."..blind_level..")",
        "Cards played previously",
        "this Ante are debuffed"
      }
    }
    G.localization.descriptions.Blind.bl_final_leaf = {
      name = "Verdant Leaf",
      text = {
        "(lvl."..blind_level..")",
        "All cards are debuffed",
        "until "..blind_level.." Jokers sold"
      }
    }
  elseif blind_level >= 2 then
    G.localization.descriptions.Blind.bl_head = {
      name = "The Head",
      text = {
        "(lvl."..blind_level..")",
        "All Heart cards are",
        "debuffed and reversed"
      }
    }
    G.localization.descriptions.Blind.bl_goad = {
      name = "The Goad",
      text = {
        "(lvl."..blind_level..")",
        "All Spade cards are",
        "debuffed and reversed"
      }
    }
    G.localization.descriptions.Blind.bl_window = {
      name = "The Window",
      text = {
        "(lvl."..blind_level..")",
        "All Diamond cards are",
        "debuffed and reversed"
      }
    }
    G.localization.descriptions.Blind.bl_club = {
      name = "The Club",
      text = {
        "(lvl."..blind_level..")",
        "All Club cards are",
        "debuffed and reversed"
      }
    }
    G.localization.descriptions.Blind.bl_plant = {
      name = "The Plant",
      text = {
        "(lvl."..blind_level..")",
        "All face cards are",
        "debuffed and reversed"
      }
    }
    G.localization.descriptions.Blind.bl_pillar = {
      name = "The Pillar",
      text = {
        "(lvl."..blind_level..")",
        "Cards played previously",
        "this Ante are debuffed",
        "and reversed"
      }
    }
    G.localization.descriptions.Blind.bl_final_leaf = {
      name = "Verdant Leaf",
      text = {
        "(lvl."..blind_level..")",
        "All cards are debuffed",
        "and reversed until",
        blind_level.." Jokers sold"
      }
    }
  end

  -- The Ox
  if blind_level <= -1 then
    G.localization.descriptions.Blind.bl_ox = {
      name = "The Ox",
      text = {
        "(lvl."..blind_level..")",
        "X"..(1-blind_level).." money when",
        "a #1# is played"
      }
    }
  elseif blind_level == 0 then
    G.localization.descriptions.Blind.bl_ox = {
      name = "The Ox",
      text = {
        "(lvl."..blind_level..")",
        "Boss disabled"
      }
    }
  elseif blind_level >= 1 then
    G.localization.descriptions.Blind.bl_ox = {
      name = "The Ox",
      text = {
        "(lvl."..blind_level..")",
        "Playing a #1#",
        "sets money to $0"
      }
    }
  end

  -- The Flint
  if blind_level <= -1 then
    G.localization.descriptions.Blind.bl_flint = {
      name = "The Flint",
      text = {
        "(lvl."..blind_level..")",
        "Base Chips and Mult",
        "are multipled by "..(-blind_level+1)
      }
    }
  elseif blind_level == 0 then
    G.localization.descriptions.Blind.bl_flint = {
      name = "The Flint",
      text = {
        "(lvl."..blind_level..")",
        "Boss disabled"
      }
    }
  elseif blind_level >= 1 then
    G.localization.descriptions.Blind.bl_flint = {
      name = "The Flint",
      text = {
        "(lvl."..blind_level..")",
        "Base Chips and Mult",
        "are divided by "..(blind_level+1)
      }
    }
  end

  -- The Mark
  if blind_level <= 0 then
    G.localization.descriptions.Blind.bl_mark = {
      name = "The Mark",
      text = {
        "(lvl."..blind_level..")",
        "Boss disabled"
      }
    }
  elseif blind_level >= 1 then
    G.localization.descriptions.Blind.bl_mark = {
      name = "The Mark",
      text = {
        "(lvl."..blind_level..")",
        "All face cards are",
        "drawn face down"
      }
    }
  end

  -- The Fish
  if blind_level <= 0 then
    G.localization.descriptions.Blind.bl_fish = {
      name = "The Fish",
      text = {
        "(lvl."..blind_level..")",
        "Boss disabled"
      }
    }
  elseif blind_level >= 1 then
    G.localization.descriptions.Blind.bl_fish = {
      name = "The Fish",
      text = {
        "(lvl."..blind_level..")",
        "Cards drawn face down",
        "after each hand played"
      }
    }
  end

  -- The House
  if blind_level <= 0 then
    G.localization.descriptions.Blind.bl_house = {
      name = "The House",
      text = {
        "(lvl."..blind_level..")",
        "Boss disabled"
      }
    }
  elseif blind_level >= 1 then
    G.localization.descriptions.Blind.bl_house = {
      name = "The House",
      text = {
        "(lvl."..blind_level..")",
        "First hand is",
        "drawn face down"
      }
    }
  end

  -- The Wheel
  if blind_level <= 0 then
    G.localization.descriptions.Blind.bl_wheel = {
      name = "The Wheel",
      text = {
        "(lvl."..blind_level..")",
        "Boss disabled"
      }
    }
  elseif blind_level >= 1 then
    G.localization.descriptions.Blind.bl_wheel = {
      name = "The Wheel",
      text = {
        "(lvl."..blind_level..")",
        probability.." in "..math.max(1, 8-blind_level).." cards get",
        "drawn face down"
      }
    }
  end

  -- Amber Acorn
  if blind_level <= 0 then
    G.localization.descriptions.Blind.bl_final_acorn = {
      name = "Amber Acorn",
      text = {
        "(lvl."..blind_level..")",
        "Flips and shuffles",
        "all Joker cards"
      }
    }
  elseif blind_level >= 1 then
    G.localization.descriptions.Blind.bl_final_acorn = {
      name = "Amber Acorn",
      text = {
        "(lvl."..blind_level..")",
        "Boss disabled"
      }
    }
  end

  -- Psychic
  if blind_level <= -1 then
    G.localization.descriptions.Blind.bl_psychic = {
      name = "The Psychic",
      text = {
        "(lvl."..blind_level..")",
        "Hands with 4 cards or",
        "less are retriggered"
      }
    }
  elseif blind_level == 0 then
    G.localization.descriptions.Blind.bl_psychic = {
      name = "The Psychic",
      text = {
        "(lvl."..blind_level..")",
        "Boss disabled"
      }
    }
  elseif blind_level >= 1 then
    G.localization.descriptions.Blind.bl_psychic = {
      name = "The Psychic",
      text = {
        "(lvl."..blind_level..")",
        "Must play 5 cards"
      }
    }
  end

  -- Eye
  if blind_level <= -1 then
    G.localization.descriptions.Blind.bl_eye = {
      name = "The Eye",
      text = {
        "(lvl."..blind_level..")",
        "Retrigger all cards if",
        "hand type has already",
        "been played this round"
      }
    }
  elseif blind_level == 0 then
    G.localization.descriptions.Blind.bl_eye = {
      name = "The Eye",
      text = {
        "(lvl."..blind_level..")",
        "Boss disabled"
      }
    }
  elseif blind_level >= 1 then
    G.localization.descriptions.Blind.bl_eye = {
      name = "The Eye",
      text = {
        "(lvl."..blind_level..")",
        "No repeat hand",
        "types this round"
      }
    }
  end

  -- Mouth
  if blind_level <= -1 then
    G.localization.descriptions.Blind.bl_mouth = {
      name = "The Mouth",
      text = {
        "(lvl."..blind_level..")",
        "Retrigger all cards if hand",
        "type is different from the",
        "first hand played in round"
      }
    }
  elseif blind_level == 0 then
    G.localization.descriptions.Blind.bl_mouth = {
      name = "The Mouth",
      text = {
        "(lvl."..blind_level..")",
        "Boss disabled"
      }
    }
  elseif blind_level >= 1 then
    G.localization.descriptions.Blind.bl_mouth = {
      name = "The Mouth",
      text = {
        "(lvl."..blind_level..")",
        "Play only 1 hand",
        "type this round"
      }
    }
  end

  -- Crimson Heart
  if blind_level <= 0 then
    G.localization.descriptions.Blind.bl_final_heart = {
      name = "Crimson Heart",
      text = {
        "(lvl."..blind_level..")",
        "Boss disabled"
      }
    }
  elseif blind_level == 1 then
    G.localization.descriptions.Blind.bl_final_heart = {
      name = "Crimson Heart",
      text = {
        "(lvl."..blind_level..")",
        "1 random Joker is",
        "disabled every hand"
      }
    }
  elseif blind_level >= 2 then
    G.localization.descriptions.Blind.bl_final_heart = {
      name = "Crimson Heart",
      text = {
        "(lvl."..blind_level..")",
        "Up to 2 random Jokers",
        "are disabled every hand"
      }
    }
  end

  -- Cerulean Bell
  if blind_level <= 0 then
    G.localization.descriptions.Blind.bl_final_bell = {
      name = "Cerulean Bell",
      text = {
        "(lvl."..blind_level..")",
        "Boss disabled"
      }
    }
  elseif blind_level == 1 then
    G.localization.descriptions.Blind.bl_final_bell = {
      name = "Cerulean Bell",
      text = {
        "(lvl."..blind_level..")",
        "Forces 1 card to",
        "always be selected"
      }
    }
  elseif blind_level >= 2 then
    G.localization.descriptions.Blind.bl_final_bell = {
      name = "Cerulean Bell",
      text = {
        "(lvl."..blind_level..")",
        "Forces up to 2 cards",
        "to always be selected"
      }
    }
  end

            
  
  -- Debuffed cards
  if blind_level >= 2 then
    G.localization.descriptions.Other.debuffed_playing_card = {
      name = "Debuffed",
      text = {
        "Scores minus chips",
        "and all abilities",
        "are reversed"
      }
    }
  else
    G.localization.descriptions.Other.debuffed_playing_card = {
      name = "Debuffed",
      text = {
        "Scores no chips",
        "and all abilities",
        "are disabled"
      }
    }
  end

  init_localization()
end


-- OTHERS
function desc()

  -- JOKERS

  -- MULT
  G.localization.descriptions.Joker.j_ceremonial = {
    name = "Ceremonial Dagger",
    text = {
      "When {C:attention}Blind{} is selected,",
      "destroy Joker to the right",
      "and permanently add {C:attention}"..(mult_level+1).."{} times",
      "its sell value to this {C:red}Mult",
      "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
    }
  }
  G.localization.descriptions.Joker.j_raised_fist = {
    name = "Raised Fist",
    text = {
      "Adds {C:attention}"..(mult_level+1).."{} times the rank",
      "of {C:attention}lowest{} ranked card",
      "held in hand to Mult"
    }
  }
  G.localization.descriptions.Joker.j_supernova = {
    name = "Supernova",
    text = {
      "Adds {C:attention}"..mult_level.."x{} the number of",
      "times {C:attention}poker hand{} has been",
      "played this run to Mult"
    }
  }
  G.localization.descriptions.Joker.j_swashbuckler = {
    name = "Swashbuckler",
    text = {
      "Adds {C:attention}"..1+((mult_level-1)/2).."{} times the sell",
      "value of all other",
      "owned {C:attention}Jokers{} to Mult",
      "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
    }
  }
  G.localization.descriptions.Joker.j_misprint = {
    name = "Misprint",
    text = {
      "{C:inactive}(min: "..(0 + ((mult_level-1) * 3))..", max: "..(23 + ((mult_level-1) * 3))..")"
    }
  }

  -- XMULT
  G.localization.descriptions.Joker.j_stencil = {
    name = "Joker Stencil",
    text = {
      "{X:red,C:white} X"..(1 + (xmult_level-1)*0.25).."{} Mult for each",
      "empty {C:attention}Joker{} slot",
      "{s:0.8}Joker Stencil included",
      "{C:inactive}(Currently {X:red,C:white} X#1# {C:inactive})"
    }
  }
  if xmult_level == 1 then
    G.localization.descriptions.Joker.j_flower_pot = {
      name = "Flower Pot",
      text = {
        "{X:mult,C:white} X#1# {} Mult if played hand",
        "contains a scoring",
        "{C:diamonds}Diamond{} card, {C:clubs}Club{} card,",
        "{C:hearts}Heart{} card, and {C:spades}Spade{} card"
      },
      unlock = {
        "Reach Ante",
        "level {E:1,C:attention}#1#"
      }
    }
    G.localization.descriptions.Joker.j_seeing_double = {
      name = "Seeing Double",
      text = {
        "{X:mult,C:white} X#1# {} Mult if played",
        "hand has a scoring",
        "{C:clubs}Club{} card and a scoring",
        "card of any other {C:attention}suit",
      },
      unlock = {
        "Play a hand",
        "that contains",
        "{E:1,C:attention}#1#"
      }
    }
  elseif xmult_level >= 2 then
    G.localization.descriptions.Joker.j_flower_pot = {
      name = "Flower Pot",
      text = {
        "{X:mult,C:white} X#1# {} Mult if played hand contains",
        "a scoring {C:diamonds}Diamond{} card, {C:clubs}Club",
        "card, {C:hearts}Heart{} card, and {C:spades}Spade{} card",
        "Cards can count for multiple {C:attention}suits{}"
      },
      unlock = {
        "Reach Ante",
        "level {E:1,C:attention}#1#"
      }
    }
    G.localization.descriptions.Joker.j_seeing_double = {
      name = "Seeing Double",
      text = {
        "{X:mult,C:white} X#1# {} Mult if played hand has",
        "a scoring {C:clubs}Club{} card and a",
        "scoring card of any other {C:attention}suit",
        "Cards can count for multiple {C:attention}suits{}"
      },
      unlock = {
        "Play a hand",
        "that contains",
        "{E:1,C:attention}#1#"
      }
    }
  end
  if xmult_level == 1 then
    G.localization.descriptions.Joker.j_ancient= {
      name = "Ancient Joker",
      text = {
        "Each played card with",
        "{V:1}#2#{} suit gives",
        "{X:mult,C:white} X#1# {} Mult when scored,",
        "{s:0.8}suit changes at end of round"
      }
    }
  elseif xmult_level >= 2 then
    G.localization.descriptions.Joker.j_ancient= {
      name = "Ancient Joker",
      text = {
        "Each played card with {V:1}#2#{} suit",
        "gives {X:mult,C:white} X#1# {} Mult when scored, suit",
        "is chosen from a card in your deck",
        "{s:0.8}suit changes at end of round"
      }
    }
  end

  -- CHIPS
  if chips_level <= 2 then
    G.localization.descriptions.Joker.j_stuntman = {
      name = "Stuntman",
      text = {
        "{C:chips}+#1#{} Chips,",
        "{C:attention}-#2#{} hand size"
      },
      unlock = {
        "In one hand,",
        "earn at least",
        "{E:1,C:attention}#1#{} chips"
      }
    }
  elseif chips_level >= 3 then
    G.localization.descriptions.Joker.j_stuntman = {
      name = "Stuntman",
      text = {
        "{C:chips}+#1#{} Chips",
      },
      unlock = {
        "In one hand,",
        "earn at least",
        "{E:1,C:attention}#1#{} chips"
      }
    }
  end

  -- ECON
  G.localization.descriptions.Joker.j_matador = {
    name = "Matador",
    text = {
      "Earn {C:money}$#1#{} if played hand",
      "triggers the {C:attention}Boss Blind{} ability",
      "{s:0.8}triggers on more bosses than in vanilla{}"
    },
    unlock = {
      "Defeat a Boss Blind",
      "in {E:1,C:attention}1 hand{} without",
      "using any discards"
    }
  }
  G.localization.descriptions.Joker.j_business = {
    name = "Business Card",
    text = {
      "Played {C:attention}face{} cards have",
      "a {C:green}#1# in #2#{} chance to",
      "give {C:money}$"..(effect_level+1).."{} when scored"
    }
  }
  if econ_level == 1 then
    G.localization.descriptions.Joker.j_trading = {
      name = "Trading Card",
      text = {
        "If {C:attention}first discard{} of round",
        "has only {C:attention}1{} card, destroy",
        "it and earn {C:money}$#1#"
      }
    }
  elseif econ_level >= 2 then
    G.localization.descriptions.Joker.j_trading = {
      name = "Trading Card",
      text = {
        "If {C:attention}any discard{} has",
        "only {C:attention}1{} card, destroy",
        "it and earn {C:money}$#1#"
      }
    }
  end

  -- EFFECT
  G.localization.descriptions.Joker.j_mime = {
    name = "Mime",
    text = {
      "Retrigger all card",
      "{C:attention}held in hand",
      "abilities {C:attention}"..effect_level.."{} times"
    }
  } 
  G.localization.descriptions.Joker.j_8_ball = {
    name = "8 Ball",
    text = {
      "{C:green}#1# in #2#{} chance for each",
      "played {C:attention}8{} to create {C:attention}"..effect_level,
      "{C:tarot}Tarot{} card when scored",
      "{C:inactive}(Must have room)"
    }
  } 
  G.localization.descriptions.Joker.j_hallucination = {
    name = "Hallucination",
    text = {
      "{C:green}#1# in #2#{} chance to create",
      "{C:attention}"..effect_level.." {C:tarot}Tarot{} cards when any",
      "{C:attention}Booster Pack{} is opened",
      "{C:inactive}(Must have room)"
    }
  }
  G.localization.descriptions.Joker.j_dusk = {
    name = "Dusk",
    text = {
      "Retrigger all played",
      "cards in {C:attention}final hand",
      "of round {C:attention}"..effect_level.."{} times"
    }
  }
  G.localization.descriptions.Joker.j_chaos = {
    name = "Chaos the Clown",
    text = {
      "{C:attention}#1#{} free {C:green}Rerolls",
      "per shop"
    }
  }
  G.localization.descriptions.Joker.j_hack = {
    name = "Hack",
    text = {
      "Retrigger each",
      "played {C:attention}2{}, {C:attention}3{}, {C:attention}4{}, or {C:attention}5{}",
      "{C:attention}"..effect_level.."{} times"
    }
  }
  G.localization.descriptions.Joker.j_selzer= {
    name = "Seltzer",
    text = {
      "For the next {C:attention}#1#{} hands",
      "Retrigger all played",
      "cards {C:attention}"..effect_level.."times"
    }
  }
  G.localization.descriptions.Joker.j_superposition = {
    name = "Superposition",
    text = {
      "Create {C:attention}"..effect_level.." {C:tarot}Tarot{} cards if",
      "poker hand contains an",
      "{C:attention}Ace{} and a {C:attention}Straight{}",
      "{C:inactive}(Must have room)"
    }
  }
  G.localization.descriptions.Joker.j_vagabond = {
    name = "Vagabond",
    text = {
      "Create {C:attention}"..effect_level.." {C:purple}Tarot{} cards",
      "if hand is played",
      "with {C:money}$#1#{} or less",
    }
  }
  G.localization.descriptions.Joker.j_diet_cola = {
    name = "Diet Cola",
    text = {
      "Sell this card to",
      "create {C:attention}"..effect_level.."{} free",
      "{C:attention}#1#s"
    }
  }
  G.localization.descriptions.Joker.j_mr_bones = {
    name = "Mr. Bones",
    text = {
      "Prevents Death",
      "if chips scored",
      "are at least {C:attention}"..(250 / (10^effect_level)).."%",
      "of required chips",
      "{S:1.1,C:red,E:2}self destructs{}"
    },
    unlock = {
      "Lose {C:attention,E:1}#1#{} runs",
      "{C:inactive}(#2#)"
    }
  }
  G.localization.descriptions.Joker.j_sock_and_buskin = {
    name = "Sock and Buskin",
    text = {
      "Retrigger all",
      "played {C:attention}face{} cards",
      "{C:attention}"..effect_level.."{} times"
    },
    unlock = {
      "Play a total of",
      "{C:attention,E:1}#1#{} face cards",
      "{C:inactive}(#2#)"
    }
  }
  G.localization.descriptions.Joker.j_oops = {
    name = "Oops! All 6s",
    text = {
      "Multiplies all {C:attention}listed",
      "{C:green,E:1,S:1.1}probabilities{} by {C:attention}"..(effect_level+1),
      "{C:inactive}(ex: {C:green}1 in "..(effect_level+2).."{C:inactive} -> {C:green}"..(effect_level+1).." in "..(effect_level+2).."{C:inactive})"
    },
    unlock = {
      "In one hand,",
      "earn at least",
      "{E:1,C:attention}#1#{} chips"
    }
  }
  G.localization.descriptions.Joker.j_cartomancer = {
    name = "Cartomancer",
    text = {
      "Create {C:attention}"..effect_level.." {C:tarot}Tarot{} cards",
      "when {C:attention}Blind{} is selected",
      "{C:inactive}(Must have room)"
    },
    unlock = {
      "Discover every",
      "{E:1,C:tarot}Tarot{} card"
    }
  }
  G.localization.descriptions.Joker.j_perkeo = {
    name = "Perkeo",
    text = {
      "Creates {C:attention}"..effect_level.." {C:dark_edition}Negative{} copies of",
      "{C:attention}1{} random {C:attention}consumable{}",
      "card in your possession",
      "at the end of the {C:attention}shop",
    },
    unlock = {
      "{E:1,s:1.3}?????"
    }
  }

  -- Splash
  if effect_level == 1 then
    G.localization.descriptions.Joker.j_splash = {
      name = "Splash",
      text = {
        "Every {C:attention}played card",
        "counts in scoring"
      }
    }
  elseif effect_level >= 2 then
    G.localization.descriptions.Joker.j_splash = {
      name = "Splash",
      text = {
        "Every {C:attention}played card",
        "counts in scoring",
        "Trigger {C:attention}editions{} of",
        "cards {C:attention}held in hand{}"
      }
    }
  end

  -- DNA
  if effect_level <= 2 then
    G.localization.descriptions.Joker.j_dna = {
      name = "DNA",
      text = {
        "If {C:attention}first hand{} of round",
        "has only {C:attention}1{} card, add {C:attention}"..effect_level,
        "permanent copies to deck",
        "and draw it to {C:attention}hand"
      }
    }
  elseif effect_level >= 3 then
    G.localization.descriptions.Joker.j_dna = {
      name = "DNA",
      text = {
        "If {C:attention}any played hand{} of round",
        "has only {C:attention}1{} card, add {C:attention}"..effect_level,
        "permanent copies to deck",
        "and draw it to {C:attention}hand"
      }
    }
  end

  -- Sixth Sense
  if effect_level == 1 then
    G.localization.descriptions.Joker.j_sixth_sense = {
      name = "Sixth Sense",
      text = {
        "If {C:attention}first hand{} of round is",
        "a single {C:attention}6{}, destroy it and",
        "create {C:attention}"..math.max(1, effect_level-1).." {C:spectral}Spectral{} cards",
        "{C:inactive}(Must have room)"
      }
    }
  elseif effect_level == 2 then
    G.localization.descriptions.Joker.j_sixth_sense = {
      name = "Sixth Sense",
      text = {
        "If {C:attention}any played hand{} is",
        "a single {C:attention}6{}, destroy it and",
        "create {C:attention}"..math.max(1, effect_level-1).." {C:spectral}Spectral{} cards",
        "{C:inactive}(Must have room)"
      }
    }
  elseif effect_level >= 3 then
    G.localization.descriptions.Joker.j_sixth_sense = {
      name = "Sixth Sense",
      text = {
        "If {C:attention}any played hand{} is",
        "a single {C:attention}6{}, destroy it and",
        "create {C:attention}"..math.max(1, effect_level-1).." {C:spectral}Spectral{} cards",
        "{C:inactive}(Must have room)",
        "{s:0.8}compatible with Blueprint and Brainstorm"
      }
    }
  end

  -- Seance
  if effect_level == 1 then
    G.localization.descriptions.Joker.j_seance = {
      name = "Séance",
      text = {
        "If {C:attention}poker hand{} is a",
        "{C:attention}#1#{}, create {C:attention}"..effect_level-1,
        "random {C:spectral}Spectral{} cards",
        "{C:inactive}(Must have room)"
      }
    }
  elseif effect_level >= 2 then
    G.localization.descriptions.Joker.j_seance = {
      name = "Séance",
      text = {
        "If {C:attention}poker hand{} is a",
        "{C:attention}#1#{}, create {C:attention}"..effect_level-1,
        "random {C:spectral}Spectral{} cards",
        "{C:inactive}(Must have room)"
      }
    }
  end
  
  -- Certificate
  if effect_level == 1 then
    G.localization.descriptions.Joker.j_certificate = {
      name = "Certificate",
      text = {
        "When round begins,",
        "add a random {C:attention}playing",
        "{C:attention}card{} with a random",
        "{C:attention}seal{} to your hand"
      }
    }
  elseif effect_level == 2 then
    G.localization.descriptions.Joker.j_certificate = {
      name = "Certificate",
      text = {
        "When round begins,",
        "add a random {C:attention}playing",
        "{C:attention}card{} with a random",
        "{C:attention}enhancement{} and {C:attention}seal{} to your hand"
      }
    }
  elseif effect_level >= 3 then
    G.localization.descriptions.Joker.j_certificate = {
      name = "Certificate",
      text = {
        "When round begins,",
        "add a random {C:attention}playing card",
        "with a random {C:attention}enhancement{},",
        "{C:attention}edition{}, and {C:attention}seal{} to your hand"
      }
    }
  end

  -- Invisible Joker
  if effect_level <= 2 then
    G.localization.descriptions.Joker.j_invisible = {
      name = "Invisible Joker",
      text = {
        "After {C:attention}#1#{} rounds,",
        "sell this card to",
        "{C:attention}Duplicate{} a random Joker",
        "{C:inactive}(Currently {C:attention}#2#{C:inactive}/#1#)",
        "{C:inactive,s:0.9}(Removes {C:dark_edition,s:0.9}Negative{C:inactive,s:0.9} from copy)"
      },
      unlock = {
        "Win a run without",
        "ever having more",
        "than {E:1,C:attention}4 Jokers{}"
      }
    }
  elseif effect_level == 3 then
    G.localization.descriptions.Joker.j_invisible = {
      name = "Invisible Joker",
      text = {
        "Sell this card to {C:attention}Duplicate{}",
        "the leftmost Joker",
        "{C:inactive,s:0.9}(Removes {C:dark_edition,s:0.9}Negative{C:inactive,s:0.9} from copy)"
      },
      unlock = {
        "Win a run without",
        "ever having more",
        "than {E:1,C:attention}4 Jokers{}"
      }
    }
  elseif effect_level >= 4 then
    G.localization.descriptions.Joker.j_invisible = {
      name = "Invisible Joker",
      text = {
        "Sell this card to {C:attention}Duplicate{}",
        "the leftmost Joker, no longer",
        "removes {C:dark_edition}Negative{} from copy"
      },
      unlock = {
        "Win a run without",
        "ever having more",
        "than {E:1,C:attention}4 Jokers{}"
      }
    }
  end

  -- Burnt Joker
  if effect_level == 1 then
    G.localization.descriptions.Joker.j_burnt = {
      name = "Burnt Joker",
      text = {
        "Upgrade the level of the",
        "{C:attention}first discarded{} poker hand",
        "each round by {C:attention}"..effect_level.."{} levels"
      }
    }
  elseif effect_level >= 2 then
    G.localization.descriptions.Joker.j_burnt = {
      name = "Burnt Joker",
      text = {
        "Upgrade the level of",
        "{C:attention}any discarded{} poker",
        "hand by {C:attention}"..effect_level.."{} levels"
      }
    }
  end

  -- Chicot
  G.localization.descriptions.Joker.j_chicot = {
    name = "Chicot",
    text = {
      "Reduces the level",
      "of every {C:attention}boss blind",
      "by {C:attention}"..effect_level.."{} levels",
      "{C:inactive}(Current blind level {C:attention}"..blind_level.."{C:inactive}){}"
    }
  }

  -- Luchador
  G.localization.descriptions.Joker.j_luchador = {
    name = "Luchador",
    text = {
      "Sell this card to reduce ",
      "the level of current",
      "{C:attention}boss blind{} by {C:attention}"..effect_level.."{} levels",
      "{C:inactive}(Current blind level {C:attention}"..blind_level.."{C:inactive}){}"
    }
  }
  

  -- CONSUMABLES

  -- TAROTS

  -- Fool and Death
  if tarot_level == 1 then
    G.localization.descriptions.Tarot.c_fool = {
      name = "The Fool",
      text = {
        "Creates the last",
        "{C:tarot}Tarot{} or {C:planet}Planet{} card",
        "used during this run",
        "{s:0.8,C:tarot}The Fool{s:0.8} excluded"
      }
    }
    G.localization.descriptions.Tarot.c_death = {
      name = "Death",
      text = {
        "Select {C:attention}#1#{} cards,",
        "convert the {C:attention}left{} card",
        "into the {C:attention}right{} card",
        "{C:inactive}(Drag to rearrange)"
      }
    }
  elseif tarot_level >= 2 then
    G.localization.descriptions.Tarot.c_fool = {
      name = "The Fool",
      text = {
        "Creates the last {C:tarot}Tarot{},",
        "{C:planet}Planet{}, or {C:spectral}Spectral{} card",
        "used during this run",
        "{s:0.8,C:tarot}The Fool{s:0.8} excluded"
      }
    }
    G.localization.descriptions.Tarot.c_death = {
      name = "Death",
      text = {
        "Select {C:attention}2-{C:attention}#1#{} cards,",
        "convert all other cards",
        "into the {C:attention}rightmost{} card",
        "{C:inactive}(Drag to rearrange)"
      }
    }
  end

  -- Hermit and Temperance
  G.localization.descriptions.Tarot.c_hermit = {
    name = "The Hermit",
    text = {
      "{X:money,C:white} X"..(2 + (tarot_level-1)/2).." {} money",
      "{C:inactive}(Max of {C:money}$#1#{C:inactive})"
    }
  }
  G.localization.descriptions.Tarot.c_temperance = {
    name = "Temperance",
    text = {
      "Gives {X:money,C:white} X"..(1 + (tarot_level-1)/2).."{} the total sell",
      "value of all current",
      "Jokers {C:inactive}(Max of {C:money}$#1#{C:inactive})",
      "{C:inactive}(Currently {C:money}$#2#{C:inactive})"
    }
  }
  
  -- Wheel of Fortune
  if tarot_level == 1 then
    G.localization.descriptions.Tarot.c_wheel_of_fortune = {
      name = "The Wheel of Fortune",
      text = {
        "{C:green}#1# in #2#{} chance to add {C:dark_edition}Foil{} {C:inactive}("..(50-(10*(tarot_level-1))).."%){},",
        "{C:dark_edition}Holographic{} {C:inactive}("..(35-(5*(tarot_level-1))).."%){}, or {C:dark_edition}Polychrome{} {C:inactive}("..(15+(15*(tarot_level-1))).."%)",
        "to a random {C:attention}Joker"
      }
    }
  elseif tarot_level == 2 then
    G.localization.descriptions.Tarot.c_wheel_of_fortune = {
      name = "The Wheel of Fortune",
      text = {
        "{C:green}#1# in #2#{} chance to add {C:dark_edition}Foil{} {C:inactive}("..(50-(10*(tarot_level-1))).."%){},",
        "{C:dark_edition}Holographic{} {C:inactive}("..(35-(5*(tarot_level-1))).."%){}, or {C:dark_edition}Polychrome{} {C:inactive}("..(15+(15*(tarot_level-1))).."%)",
        "to a random {C:attention}Joker"
      }
    }
  elseif tarot_level == 3 then
    G.localization.descriptions.Tarot.c_wheel_of_fortune = {
      name = "The Wheel of Fortune",
      text = {
        "{C:green}#1# in #2#{} chance to add {C:dark_edition}Foil{} {C:inactive}("..(50-(10*(tarot_level-1))).."%){},",
        "{C:dark_edition}Holographic{} {C:inactive}("..(35-(5*(tarot_level-1))).."%){}, or {C:dark_edition}Polychrome{} {C:inactive}("..(15+(15*(tarot_level-1))).."%)",
        "the leftmost {C:attention}Joker"
      }
    }
  elseif tarot_level == 4 then
    G.localization.descriptions.Tarot.c_wheel_of_fortune = {
      name = "The Wheel of Fortune",
      text = {
        "{C:green}#1# in #2#{} chance to add {C:dark_edition}Foil{} {C:inactive}("..(50-(10*(tarot_level-1))).."%){},",
        "{C:dark_edition}Holographic{} {C:inactive}("..(35-(5*(tarot_level-1))).."%){}, or {C:dark_edition}Polychrome{} {C:inactive}("..(15+(15*(tarot_level-1))).."%)",
        "edition to the leftmost {C:attention}Joker",
        "Editions can be overwritten"
      }
    }
  end

  -- Other tarot cards
  G.localization.descriptions.Tarot.c_lovers = {
    name = "The Lovers",
    text = {
      "Enhances {C:attention}#1#{} selected",
      "cards into",
      "{C:attention}#2#s"
    }
  }
  G.localization.descriptions.Tarot.c_chariot = {
    name = "The Chariot",
    text = {
      "Enhances {C:attention}#1#{} selected",
      "cards into",
      "{C:attention}#2#s"
    }
  }
  G.localization.descriptions.Tarot.c_justice = {
    name = "Justice",
    text = {
      "Enhances {C:attention}#1#{} selected",
      "cards into",
      "{C:attention}#2#s"
    }
  }
  G.localization.descriptions.Tarot.c_devil = {
    name = "The Devil",
    text = {
      "Enhances {C:attention}#1#{} selected",
      "cards into",
      "{C:attention}#2#s"
    }
  }
  G.localization.descriptions.Tarot.c_tower = {
    name = "The Tower",
    text = {
      "Enhances {C:attention}#1#{} selected",
      "cards into",
      "{C:attention}#2#s"
    }
  }
  G.localization.descriptions.Tarot.c_judgement = {
    name = "Judgement",
    text = {
      "Creates up to {C:attention}"..tarot_level,
      "random {C:attention}Joker{} cards",
      "{C:inactive}(Must have room)"
    }
  }


  -- PLANETS

  G.localization.descriptions.Planet.c_mercury = {
    name = "Mercury",
    text = {
      "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
      "{C:attention}#2#{}",
      "by {C:attention}"..planet_level.."{} levels",
      "{C:mult}+"..1*planet_level.."{} Mult and",
      "{C:chips}+"..15*planet_level.."{} chips"
    }
  }
  G.localization.descriptions.Planet.c_venus = {
    name = "Venus",
    text = {
      "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
      "{C:attention}#2#{}",
      "by {C:attention}"..planet_level.."{} levels",
      "{C:mult}+"..2*planet_level.."{} Mult and",
      "{C:chips}+"..20*planet_level.."{} chips"
    }
  }
  G.localization.descriptions.Planet.c_earth = {
    name = "Earth",
    text = {
      "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
      "{C:attention}#2#{}",
      "by {C:attention}"..planet_level.."{} levels",
      "{C:mult}+"..2*planet_level.."{} Mult and",
      "{C:chips}+"..25*planet_level.."{} chips"
    }
  }
  G.localization.descriptions.Planet.c_mars = {
    name = "Mars",
    text = {
      "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
      "{C:attention}#2#{}",
      "by {C:attention}"..planet_level.."{} levels",
      "{C:mult}+"..3*planet_level.."{} Mult and",
      "{C:chips}+"..30*planet_level.."{} chips"
    }
  }
  G.localization.descriptions.Planet.c_jupiter = {
    name = "Jupiter",
    text = {
      "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
      "{C:attention}#2#{}",
      "by {C:attention}"..planet_level.."{} levels",
      "{C:mult}+"..2*planet_level.."{} Mult and",
      "{C:chips}+"..15*planet_level.."{} chips"
    }
  }
  G.localization.descriptions.Planet.c_saturn = {
    name = "Saturn",
    text = {
      "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
      "{C:attention}#2#{}",
      "by {C:attention}"..planet_level.."{} levels",
      "{C:mult}+"..3*planet_level.."{} Mult and",
      "{C:chips}+"..30*planet_level.."{} chips"
    }
  }
  G.localization.descriptions.Planet.c_uranus = {
    name = "Uranus",
    text = {
      "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
      "{C:attention}#2#{}",
      "by {C:attention}"..planet_level.."{} levels",
      "{C:mult}+"..1*planet_level.."{} Mult and",
      "{C:chips}+"..20*planet_level.."{} chips"
    }
  }
  G.localization.descriptions.Planet.c_neptune = {
    name = "Neptune",
    text = {
      "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
      "{C:attention}#2#{}",
      "by {C:attention}"..planet_level.."{} levels",
      "{C:mult}+"..4*planet_level.."{} Mult and",
      "{C:chips}+"..40*planet_level.."{} chips"
    }
  }
  G.localization.descriptions.Planet.c_pluto = {
    name = "Pluto",
    text = {
      "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
      "{C:attention}#2#{}",
      "by {C:attention}"..planet_level.."{} levels",
      "{C:mult}+"..1*planet_level.."{} Mult and",
      "{C:chips}+"..10*planet_level.."{} chips"
    }
  }
  G.localization.descriptions.Planet.c_planet_x = {
    name = "Planet X",
    text = {
      "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
      "{C:attention}#2#{}",
      "by {C:attention}"..planet_level.."{} levels",
      "{C:mult}+"..3*planet_level.."{} Mult and",
      "{C:chips}+"..35*planet_level.."{} chips"
    }
  }
  G.localization.descriptions.Planet.c_ceres = {
    name = "Ceres",
    text = {
      "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
      "{C:attention}#2#{}",
      "by {C:attention}"..planet_level.."{} levels",
      "{C:mult}+"..4*planet_level.."{} Mult and",
      "{C:chips}+"..40*planet_level.."{} chips"
    }
  }
  G.localization.descriptions.Planet.c_eris = {
    name = "Eris",
    text = {
      "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
      "{C:attention}#2#{}",
      "by {C:attention}"..planet_level.."{} levels",
      "{C:mult}+"..3*planet_level.."{} Mult and",
      "{C:chips}+"..50*planet_level.."{} chips"
    }
  }


  -- SPECTRALS

  -- Aura
  if spectral_level <= 2 then
    G.localization.descriptions.Spectral.c_aura = {
      name = "Aura",
      text = {
        "Add {C:dark_edition}Foil{} {C:inactive}("..math.max(0, (50-(10*(spectral_level-1)))).."%){}, {C:dark_edition}Holographic{} {C:inactive}("..math.max(0, (35-(5*(spectral_level-1)))).."%){},",
        "or {C:dark_edition}Polychrome{} {C:inactive}("..math.min(100, (15+(15*(spectral_level-1)))).."%){} edition to",
        "{C:attention}"..spectral_level.."{} selected cards in hand"
      }
    }
  elseif spectral_level >= 3 then
    G.localization.descriptions.Spectral.c_aura = {
      name = "Aura",
      text = {
        "Add {C:dark_edition}Foil{} {C:inactive}("..math.max(0, (50-(10*(spectral_level-1)))).."%){}, {C:dark_edition}Holographic{} {C:inactive}("..math.max(0, (35-(5*(spectral_level-1)))).."%){},",
        "or {C:dark_edition}Polychrome{} {C:inactive}("..math.min(100, (15+(15*(spectral_level-1)))).."%){} edition to",
        "{C:attention}"..spectral_level.."{} selected cards in hand",
        "Editions can be overwritten"
      }
    }
  end

  -- Wraith
  if spectral_level <= 3 then
    G.localization.descriptions.Spectral.c_wraith = {
      name = "Wraith",
      text = {
        "Creates a random",
        "{C:red}Rare{C:attention} Joker{},",
        "{X:money,C:white} X"..(math.floor((spectral_level-1)*100/3 + 0.4)/100).." {} money"
      }
    }
  elseif spectral_level >= 4 then
    G.localization.descriptions.Spectral.c_wraith = {
      name = "Wraith",
      text = {
        "Creates a random",
        "{C:red}Rare{C:attention} Joker{}",
      }
    }
  end

  -- Sigil
  if spectral_level == 1 then
    G.localization.descriptions.Spectral.c_sigil = {
      name = "Sigil",
      text = {
        "Converts all cards",
        "in hand to a single",
        "random {C:attention}suit"
      }
    }
  elseif spectral_level >= 2 then
    G.localization.descriptions.Spectral.c_sigil = {
      name = "Sigil",
      text = {
        "Select {C:attention}1{} card,",
        "convert all cards in",
        "hand to the {C:attention}suit{} of",
        "of the selected card"
      }
    }
  end

  -- Ouija
  if spectral_level == 1 then
    G.localization.descriptions.Spectral.c_ouija = {
      name = "Ouija",
      text = {
        "Converts all cards",
        "in hand to a single",
        "random {C:attention}rank",
        "{C:red}-1{} hand size"
      }
    }
  elseif spectral_level == 2 then
    G.localization.descriptions.Spectral.c_ouija = {
      name = "Ouija",
      text = {
        "Converts all cards",
        "in hand to a single",
        "random {C:attention}rank",
      }
    }
  elseif spectral_level >= 3 then
    G.localization.descriptions.Spectral.c_ouija = {
      name = "Ouija",
      text = {
        "Select {C:attention}1{} card,",
        "convert all cards in",
        "hand to the {C:attention}rank{} of",
        "of the selected card"
      }
    }
  end

  -- Ectoplasm
  if spectral_level == 1 then
    G.localization.descriptions.Spectral.c_ectoplasm = {
      name = "Ectoplasm",
      text = {
        "Add {C:dark_edition}Negative{} to",
        "a random {C:attention}Joker,",
        "{C:red}-#1#{} hand size"
      }
    }
  elseif spectral_level == 2 then
    G.localization.descriptions.Spectral.c_ectoplasm = {
      name = "Ectoplasm",
      text = {
        "Add {C:dark_edition}Negative{} to",
        "a random {C:attention}Joker"
      }
    }
  elseif spectral_level == 3 then
    G.localization.descriptions.Spectral.c_ectoplasm = {
      name = "Ectoplasm",
      text = {
        "Add {C:dark_edition}Negative{} to",
        "the leftmost {C:attention}Joker"
      }
    }
  elseif spectral_level >= 4 then
    G.localization.descriptions.Spectral.c_ectoplasm = {
      name = "Ectoplasm",
      text = {
        "Add {C:dark_edition}Negative{} to",
        "the leftmost {C:attention}Joker",
        "Editions can be overwritten"
      }
    }
  end

  -- Immolate
  if spectral_level == 1 then
    G.localization.descriptions.Spectral.c_immolate = {
      name = "Immolate",
      text = {
        "Destroys {C:attention}#1#{} random",
        "cards in hand,",
        "gain {C:money}$#2#"
      }
    }
  elseif spectral_level >= 2 then
    G.localization.descriptions.Spectral.c_immolate = {
      name = "Immolate",
      text = {
        "Remove up to {C:attention}5{} selected",
        "cards in hand, and gain {C:money}$"..(spectral_level+1)*2,
        "for each removed card"
      }
    }
  end

  -- Ankh
  if spectral_level == 1 then
    G.localization.descriptions.Spectral.c_ankh = {
      name = "Ankh",
      text = {
        "Create a copy of a",
        "random {C:attention}Joker{}, destroy",
        "all other Jokers",
        "{C:inactive,s:0.9}(Removes {C:dark_edition,s:0.9}Negative{C:inactive,s:0.9} from copy)"
      }
    }
  elseif spectral_level == 2 then
    G.localization.descriptions.Spectral.c_ankh = {
      name = "Ankh",
      text = {
        "Create a copy of",
        "a random {C:attention}Joker{}",
        "{C:inactive,s:0.9}(Removes {C:dark_edition,s:0.9}Negative{C:inactive,s:0.9} from copy)"
      }
    }
  elseif spectral_level == 3 then
    G.localization.descriptions.Spectral.c_ankh = {
      name = "Ankh",
      text = {
        "Create a copy of",
        "the leftmost {C:attention}Joker{}",
        "{C:inactive,s:0.9}(Removes {C:dark_edition,s:0.9}Negative{C:inactive,s:0.9} from copy)"
      }
    }
  elseif spectral_level >= 4 then
    G.localization.descriptions.Spectral.c_ankh = {
      name = "Ankh",
      text = {
        "Create a copy of the",
        "leftmost {C:attention}Joker{}, no longer",
        "removes {C:dark_edition}Negative{} from copy"
      }
    }
  end

  -- Hex
  if spectral_level == 1 then
    G.localization.descriptions.Spectral.c_hex = {
      name = "Hex",
      text = {
        "Add {C:dark_edition}Polychrome{} to",
        "random {C:attention}Joker{}, destroy",
        "all other Jokers"
      }
    }
  elseif spectral_level == 2 then
    G.localization.descriptions.Spectral.c_hex = {
      name = "Hex",
      text = {
        "Add {C:dark_edition}Polychrome{} to",
        "a random {C:attention}Joker"
      }
    }
  elseif spectral_level == 3 then
    G.localization.descriptions.Spectral.c_hex = {
      name = "Hex",
      text = {
        "Add {C:dark_edition}Polychrome{} to",
        "the leftmost {C:attention}Joker"
      }
    }
  elseif spectral_level >= 4 then
    G.localization.descriptions.Spectral.c_hex = {
      name = "Hex",
      text = {
        "Add {C:dark_edition}Polychrome{} to",
        "the leftmost {C:attention}Joker",
        "Editions can be overwritten"
      }
    }
  end

  -- The Soul
  if spectral_level == 1 then
    G.localization.descriptions.Spectral.c_soul = {
      name = "The Soul",
      text = {
        "Creates a",
        "{C:legendary,E:1}Legendary{} Joker",
        "{C:inactive}(Must have room)"
      }
    }
  elseif spectral_level >= 2 then
    G.localization.descriptions.Spectral.c_soul = {
      name = "The Soul",
      text = {
        "Creates a {C:dark_edition}Negative{}",
        "{C:legendary,E:1}Legendary{} Joker"
      }
    }
  end

  -- Black Hole
  G.localization.descriptions.Spectral.c_black_hole = {
    name = "Black Hole",
    text = {
      "Upgrade every",
      "{C:legendary,E:1}poker hand",
      "by {C:attention}"..(2*spectral_level - 1).."{} levels"
    }
  }

  -- Seal-generating spectrals
  G.localization.descriptions.Spectral.c_talisman = {
  name = "Talisman",
    text = {
      "Add a {C:attention}Gold Seal{}",
      "to {C:attention}"..spectral_level.."{} selected",
      "cards in your hand"
    }
  }
  G.localization.descriptions.Spectral.c_deja_vu = {
  name = "Déjà Vu",
    text = {
      "Add a {C:red}Red Seal{}",
      "to {C:attention}"..spectral_level.."{} selected",
      "cards in your hand"
    }
  }
  G.localization.descriptions.Spectral.c_trance = {
  name = "Trance",
    text = {
      "Add a {C:blue}Blue Seal{}",
      "to {C:attention}"..spectral_level.."{} selected",
      "cards in your hand"
    }
  }
  G.localization.descriptions.Spectral.c_medium = {
  name = "Medium",
    text = {
      "Add a {C:purple}Purple Seal{}",
      "to {C:attention}"..spectral_level.."{} selected",
      "cards in your hand"
    }
  }
  G.localization.descriptions.Spectral.c_cryptid = {
  name = "Cryptid",
    text = {
      "Create {C:attention}"..(spectral_level+1).."{} copies of",
      "{C:attention}1{} selected card",
      "in your hand"
    }
  }

  
  -- ENHANCEMENTS

  G.localization.descriptions.Enhanced.m_lucky = {
    name = "Lucky Card",
    text = {
      "{C:green}#1# in "..math.max(1, (5 - (enhance_level-1))).."{} chance",
      "for {C:mult}+#2#{} Mult",
      "{C:green}#1# in "..math.max(1, (15 - 2*(enhance_level-1))).."{} chance",
      "to win {C:money}$#4#"
    }
  }
  if enhance_level == 1 then
    G.localization.descriptions.Enhanced.m_wild = {
      name = "Wild Card",
      text = {
        "Can be used",
        "as any suit"
      }
    }
  elseif enhance_level >= 2 then
    G.localization.descriptions.Enhanced.m_wild = {
      name = "Wild Card",
      text = {
        "Can be used as",
        "any suit, {C:attention}immune",
        "{C:attention}to debuffs{}"
      }
    }
  end

  -- SEALS

  G.localization.descriptions.Other.gold_seal = {
    name = "Gold Seal",
    text = {
      "Earn {C:money}$"..(3 + (2*(edition_level-1))).."{} when this",
      "card is played",
      "and scores"
    }
  }
  G.localization.descriptions.Other.red_seal = {
    name = "Red Seal",
    text = {
      "Retrigger this",
      "card {C:attention}"..edition_level.."{} times"
    }
  }
  G.localization.descriptions.Other.blue_seal = {
    name = "Blue Seal",
    text = {
      "Creates {C:attention}"..edition_level.."{} copies of",
      "the {C:planet}Planet{} card for final",
      "played {C:attention}poker hand{} of",
      "round if {C:attention}held{} in hand",
      "{C:inactive}(Must have room)"
    }
  }
  G.localization.descriptions.Other.purple_seal = {
    name = "Purple Seal",
    text = {
      "Creates {C:attention}"..edition_level.."{} random {C:tarot}Tarot",
      "cards when {C:attention}discarded",
      "{C:inactive}(Must have room)"
    }
  }

  -- Special Negative Editions
  G.localization.descriptions.Edition.e_negative_consumable = {
    name = "Negative",
    text = {
      "{C:dark_edition}+"..edition_level.."{} consumable slot"
    }
  }
  G.localization.descriptions.Edition.e_negative_card = {
    name = "Negative",
    text = {
      "{C:dark_edition}+"..edition_level.."{} hand size"
    }
  }

  G.localization.misc.v_dictionary.a_xchips = "X#1# chips"

  blind_desc()
  init_localization()
end

function SMODS.INIT.upgrademod()
  local atlasdeck = SMODS.Atlas({key = "centers", atlas_table = path, path = "newdecks.png", px = 71, py = 95})
  atlasdeck:register()
  local level2deck = SMODS.Deck:new(lvl2deck.name, 1, lvl2deck.config, lvl2deck.pos, lvl2deck.loc)
  local level3deck = SMODS.Deck:new(lvl3deck.name, 2, lvl3deck.config, lvl3deck.pos, lvl3deck.loc)
  local level4deck = SMODS.Deck:new(lvl4deck.name, 3, lvl4deck.config, lvl4deck.pos, lvl4deck.loc)
  level2deck:register()
  level3deck:register()
  level4deck:register()
  set_centers()
end