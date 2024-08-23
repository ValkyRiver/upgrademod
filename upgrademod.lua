--- STEAMODDED HEADER
--- MOD_NAME: upgrademod
--- MOD_ID: upgrademod
--- MOD_AUTHOR: [ValkyRiver]
--- MOD_DESCRIPTION: upgrademod

----------------------------------------------
------------MOD CODE -------------------------

mult_level = 1 -- +Mult joker level
xmult_level = 1 -- XMult joker level
chips_level = 1 -- Chips joker level
econ_level = 1 -- Economy joker level
effect_level = 3 -- Effect and Retrigger joker level
tarot_level = 1 -- Tarot consumable level
planet_level = 1 -- Planet consumable level
spectral_level = 1 -- Spectral consumable level
enhance_level = 1 -- Enhancement level
edition_level = 1 -- Edition and Seal level
pack_level = 1 -- Booster pack level
tag_level = 1  -- Skip Tag level
voucher_level = 1 -- Voucher level
blind_level = 1 -- Blind level

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
  G.P_CENTERS.j_supernova.config.extra = 1 + ((mult_level-1) * 1)
  G.P_CENTERS.j_ride_the_bus.config.extra = 1 + ((mult_level-1) * 1)
  G.P_CENTERS.j_green_joker.config.extra.hand_add = 1 + ((mult_level-1) * 1)
  G.P_CENTERS.j_red_card.config.extra = 3 + ((mult_level-1) * 2)
  G.P_CENTERS.j_erosion.config.extra = 4 + ((mult_level-1) * 1)
  G.P_CENTERS.j_fortune_teller.config.extra = 1 + ((mult_level-1) * 1)
  G.P_CENTERS.j_flash.config.extra = 2 + ((mult_level-1) * 1)
  G.P_CENTERS.j_popcorn.config.mult = 20 + ((mult_level-1) * 3)
  G.P_CENTERS.j_popcorn.config.extra = math.max(1, (4 - ((mult_level-1) * 1)))
  G.P_CENTERS.j_trousers.config.extra = 5 + ((mult_level-1) * 2)
  G.P_CENTERS.j_smiley.config.extra = 5 + ((mult_level-1) * 1)
  G.P_CENTERS.j_swashbuckler.config.mult = 1 + ((mult_level-1) * 1)
  G.P_CENTERS.j_onyx_agate.config.extra = 7 + ((mult_level-1) * 2)
  G.P_CENTERS.j_shoot_the_moon.config.extra = 13 + ((mult_level-1) * 2)
  -- G.P_CENTERS.j_shoot_the_moon: see lovely.toml
  G.P_CENTERS.j_bootstraps.config.extra.mult = 2 + ((mult_level-1) * 1)
  G.P_CENTERS.j_scholar.config.extra.mult = 4 + ((mult_level-1) * 1)
  G.P_CENTERS.j_walkie_talkie.config.extra.mult = 4 + ((mult_level-1) * 1)
  G.P_CENTERS.j_scholar.config.extra.chips = 20 + ((mult_level-1) * 10)
  G.P_CENTERS.j_walkie_talkie.config.extra.chips = 10 + ((mult_level-1) * 15)
  -- G.P_CENTERS.j_raised_fist: see lovely.toml

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
  G.P_CENTERS.j_stuntman.config.extra.h_size = 2 - ((chips_level-1) * 1)

  -- XMULT (complete)
  G.P_CENTERS.j_stencil.config.extra = 1 + ((xmult_level-1) * 0.2)
  -- G.P_CENTERS.j_stencil: see lovely.toml
  G.P_CENTERS.j_loyalty_card.config.extra.Xmult = 4 + ((xmult_level-1) * 0.2)
  G.P_CENTERS.j_loyalty_card.config.extra.every = math.max(1, (5 - ((xmult_level-1) * 1)))
  G.P_CENTERS.j_steel_joker.config.extra = 0.2 + ((xmult_level-1) * 0.05)
  G.P_CENTERS.j_blackboard.config.extra = 3 + ((xmult_level-1) * 0.2)
  G.P_CENTERS.j_constellation.config.extra = 1 + ((xmult_level-1) * 0.05)
  G.P_CENTERS.j_cavendish.config.extra.Xmult = 3 + ((xmult_level-1) * 0.15)
  G.P_CENTERS.j_cavendish.config.extra.odds = 1000 + ((xmult_level-1) * 500)
  G.P_CENTERS.j_card_sharp.config.extra.Xmult = 3 + ((xmult_level-1) * 0.15)
  G.P_CENTERS.j_madness.config.extra = 0.5 + ((xmult_level-1) * 0.25)
  G.P_CENTERS.j_vampire.config.extra = 0.1 + ((xmult_level-1) * 0.05)
  G.P_CENTERS.j_hologram.config.Xmult = 0.1 + ((xmult_level-1) * 0.05)
  G.P_CENTERS.j_baron.config.extra = 1.5 + ((xmult_level-1) * 0.1)
  G.P_CENTERS.j_obelisk.config.extra = 0.2 + ((xmult_level-1) * 0.1)
  G.P_CENTERS.j_photograph.config.extra = 2 + ((xmult_level-1) * 0.1)
  G.P_CENTERS.j_lucky_cat.config.extra = 0.25 + ((xmult_level-1) * 0.05)
  G.P_CENTERS.j_baseball.config.extra = 1.5 + ((xmult_level-1) * 0.2)
  G.P_CENTERS.j_ancient.config.extra = 1.5 + ((xmult_level-1) * 0.15)
  G.P_CENTERS.j_ramen.config.Xmult = 2 + ((xmult_level-1) * 0.2)
  G.P_CENTERS.j_ramen.config.extra = math.max(0.001, (0.01 - ((xmult_level-1) * 0.003)))
  G.P_CENTERS.j_campfire.config.extra = 0.25 + ((xmult_level-1) * 0.1)
  G.P_CENTERS.j_acrobat.config.extra = 3 + ((xmult_level-1) * 0.2)
  G.P_CENTERS.j_throwback.config.extra = 0.25 + ((xmult_level-1) * 0.1)
  G.P_CENTERS.j_bloodstone.config.extra.Xmult = 1.5 + ((xmult_level-1) * 0.1)
  G.P_CENTERS.j_bloodstone.config.extra.odds = math.max(1, (2 - ((xmult_level-1) * 0.2)))
  G.P_CENTERS.j_glass.config.extra = 0.75 + ((xmult_level-1) * 0.15)
  G.P_CENTERS.j_flower_pot.config.extra = 3 + ((xmult_level-1) * 0.25)
  G.P_CENTERS.j_idol.config.extra = 2 + ((xmult_level-1) * 0.1)
  G.P_CENTERS.j_seeing_double.config.extra = 2 + ((xmult_level-1) * 0.2)
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

-- EFFECT (incomplete: Four Fingers, Splash, Pareidolia, Shortcut, Midas Mask, Luchador, Smeared Joker, Showman, Blueprint, Brainstorm, Astronomer, and Chicot)
  G.P_CENTERS.j_mime.config.extra = 1 + ((effect_level-1) * 1) 
  G.P_CENTERS.j_dusk.config.extra = 1 + ((effect_level-1) * 1)
  G.P_CENTERS.j_hack.config.extra = 1 + ((effect_level-1) * 1)
  G.P_CENTERS.j_selzer.config.extra = 10 + ((effect_level-1) * 5)
  G.P_CENTERS.j_sock_and_buskin.config.extra = 1 + ((effect_level-1) * 1)
  G.P_CENTERS.j_hanging_chad.config.extra = 2 + ((effect_level-1) * 1)
  -- G.P.CENTERS.j_four_fingers: UNDECIDED
  G.P_CENTERS.j_marble.config.extra = 1 + ((effect_level-1) * 1)
  G.P_CENTERS.j_8_ball.config.extra = math.max(1, (4 - ((effect_level-1) * 1)))
  -- G.P.CENTERS.j_8_ball: see lovely.toml
  -- G.P_CENTERS.j_chaos: see lovely.toml
  G.P_CENTERS.j_space.config.extra = math.max(1, (4 - ((effect_level-1) * 1)))
  G.P_CENTERS.j_burglar.config.extra = 3 + ((effect_level-1) * 1)
  -- G.P.CENTERS.j_dna: see below (hooked); also see lovely.toml
  -- G.P.CENTERS.j_splash: UNDECIDED
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
  G.P_CENTERS.j_turtle_bean.config.extra = 5 + ((effect_level-1) * 1)
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
  G.P_CENTERS.c_wheel_of_fortune.config.extra = math.max(1, (4 - ((tarot_level-1) * 1)))
  G.P_CENTERS.c_strength.config.max_highlighted = math.min(5, 2 + ((tarot_level-1) * 1))
  G.P_CENTERS.c_hanged_man.config.max_highlighted = math.min(5, 2 + ((tarot_level-1) * 1))
  G.P_CENTERS.c_death.config.max_highlighted = math.min(5, 2 + ((tarot_level-1) * 1))
  G.P_CENTERS.c_temperance.config.extra = 50 + ((tarot_level-1) * 20)
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

-- BLINDS (Only Ox has been complete; scaling complete)
-- see lovely.toml
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
  local used_tarot = copier or self
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
    for i=#G.hand.highlighted, 1, -1 do
      destroyed_cards[#destroyed_cards+1] = G.hand.highlighted[i]
    end
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
      play_sound('tarot1')
      used_tarot:juice_up(0.3, 0.5)
      return true end }))
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.2,
      func = function() 
        for i=#G.hand.highlighted, 1, -1 do
          local card = G.hand.highlighted[i]
          if card.ability.name == 'Glass Card' then 
            card:shatter()
          else
            card:start_dissolve(nil, i == #G.hand.highlighted)
          end
        ease_dollars(#G.hand.highlighted*(spectral_level*2 + 2))
        end
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
  if self.ability.set == "Joker" and not self.debuff and context.cardarea == G.jokers and context.before and self.ability.name == 'DNA' and (G.GAME.current_round.hands_played == 0 or effect_level >= 2) then
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
  elseif context.joker_main then

-- For some reason, the context.joker_main from card.lua never procs, so I had to copy that part of the code here.

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
                                mult_mod = G.GAME.hands[context.scoring_name].played
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
                                    if context.scoring_hand[i]:is_suit('Hearts', true) and suits["Hearts"] == 0 then suits["Hearts"] = suits["Hearts"] + 1
                                    elseif context.scoring_hand[i]:is_suit('Diamonds', true) and suits["Diamonds"] == 0  then suits["Diamonds"] = suits["Diamonds"] + 1
                                    elseif context.scoring_hand[i]:is_suit('Spades', true) and suits["Spades"] == 0  then suits["Spades"] = suits["Spades"] + 1
                                    elseif context.scoring_hand[i]:is_suit('Clubs', true) and suits["Clubs"] == 0  then suits["Clubs"] = suits["Clubs"] + 1 end
                                end
                            end
                            for i = 1, #context.scoring_hand do
                                if context.scoring_hand[i].ability.name == 'Wild Card' or context.scoring_hand[i].config.center.any_suit then
                                if xmult_level >= 3 then suits["Wilds"] = suits["Wilds"] + 1 end
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
                                if xmult_level >= 3 then suits["Wilds"] = suits["Wilds"] + 1 end
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
                            if (self.ability.driver_tally or 0) >= 16 then 
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

  else
    card_calculate_joker_ref(self, context)
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
      blind = blind_level
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


-- DESCRIPTIONS


function desc()

  -- CONSUMABLES

  -- TAROTS

  -- Fool
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
  end

  -- Hermit and Temperance
  G.localization.descriptions.Tarot.c_hermit = {
    name = "The Hermit",
    text = {
      "{X:attention,C:white} X"..(2 + (tarot_level-1)/2).." {} money",
      "{C:inactive}(Max of {C:money}$#1#{C:inactive})"
    }
  }
  G.localization.descriptions.Tarot.c_temperance = {
    name = "Temperance",
    text = {
      "Gives {X:attention,C:white} X"..(1 + (tarot_level-1)/2).."{} the total sell",
      "value of all current",
      "Jokers {C:inactive}(Max of {C:money}$#1#{C:inactive})",
      "{C:inactive}(Currently {C:money}$#2#{C:inactive})"
    }
  }
  
  -- Wheel of Fortune
  if tarot_level <= 2 then
    G.localization.descriptions.Tarot.c_wheel_of_fortune = {
      name = "The Wheel of Fortune",
      text = {
        "{C:green}#1# in #2#{} chance to add",
        "{C:dark_edition}Foil{}, {C:dark_edition}Holographic{}, or",
        "{C:dark_edition}Polychrome{} edition",
        "to a random {C:attention}Joker"
      }
    }
  elseif tarot_level == 3 then
    G.localization.descriptions.Tarot.c_wheel_of_fortune = {
      name = "The Wheel of Fortune",
      text = {
        "{C:green}#1# in #2#{} chance to add",
        "{C:dark_edition}Foil{}, {C:dark_edition}Holographic{}, or",
        "{C:dark_edition}Polychrome{} edition",
        "the leftmost {C:attention}Joker"
      }
    }
  elseif tarot_level == 4 then
    G.localization.descriptions.Tarot.c_wheel_of_fortune = {
      name = "The Wheel of Fortune",
      text = {
        "{C:green}#1# in #2#{} chance to add {C:dark_edition}Foil{},",
        "{C:dark_edition}Holographic{}, or {C:dark_edition}Polychrome{}",
        "edition to the leftmost {C:attention}Joker{},",
        "editions can be overwritten"
      }
    }
  end

  -- Other tarot cards
  G.localization.descriptions.Tarot.c_lovers = {
    name = "The Lovers",
    text = {
      "Enhances {C:attention}#1#{} selected",
      "cards into a",
      "{C:attention}#2#"
    }
  }
  G.localization.descriptions.Tarot.c_chariot = {
    name = "The Chariot",
    text = {
      "Enhances {C:attention}#1#{} selected",
      "cards into a",
      "{C:attention}#2#"
    }
  }
  G.localization.descriptions.Tarot.c_justice = {
    name = "Justice",
    text = {
      "Enhances {C:attention}#1#{} selected",
      "cards into a",
      "{C:attention}#2#"
    }
  }
  G.localization.descriptions.Tarot.c_devil = {
    name = "The Devil",
    text = {
      "Enhances {C:attention}#1#{} selected",
      "cards into a",
      "{C:attention}#2#"
    }
  }
  G.localization.descriptions.Tarot.c_tower = {
    name = "The Tower",
    text = {
      "Enhances {C:attention}#1#{} selected",
      "cards into a",
      "{C:attention}#2#"
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

  init_localization()
end

function SMODS.INIT.upgrademod()
  local atlasdeck = SMODS.Sprite:new("centers", path, "newdecks.png", 71, 95, "asset_atli")
  atlasdeck:register()
  local level2deck = SMODS.Deck:new(lvl2deck.name, 1, lvl2deck.config, lvl2deck.pos, lvl2deck.loc)
  local level3deck = SMODS.Deck:new(lvl3deck.name, 2, lvl3deck.config, lvl3deck.pos, lvl3deck.loc)
  local level4deck = SMODS.Deck:new(lvl4deck.name, 3, lvl4deck.config, lvl4deck.pos, lvl4deck.loc)
  level2deck:register()
  level3deck:register()
  level4deck:register()
  set_centers()
end


