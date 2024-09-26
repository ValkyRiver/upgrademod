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
tag_level_old = 1 -- For Coupon Tag
tag_level_new = 1 -- For collection
collection_levels = {mult_level, xmult_level, chips_level, econ_level, effect_level, tarot_level, planet_level, spectral_level, enhance_level, edition_level, pack_level, tag_level, voucher_level, blind_level} -- For collection

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
  blind_desc(blind_level, probability)
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
  G.localization.misc.dictionary.u_blind = "Boss Blinds: "..blind_level
  init_localization()
end

function updateitems(area) -- update items in joker slots, consumable slots, and shop slots, since changing CENTERS doesn't affect existing items.
  if not area then
    return false
  end

  if area and area.cards then
    for i=1, #area.cards do

      -- MULT
      if area.cards[i].ability.name == 'Joker' then
        area.cards[i].ability.mult = G.P_CENTERS.j_joker.config.mult
      elseif area.cards[i].ability.name == 'Greedy Joker' then
        area.cards[i].ability.extra.s_mult = G.P_CENTERS.j_greedy_joker.config.extra.s_mult
      elseif area.cards[i].ability.name == 'Lusty Joker' then
        area.cards[i].ability.extra.s_mult = G.P_CENTERS.j_lusty_joker.config.extra.s_mult
      elseif area.cards[i].ability.name == 'Wrathful Joker' then
        area.cards[i].ability.extra.s_mult = G.P_CENTERS.j_wrathful_joker.config.extra.s_mult
      elseif area.cards[i].ability.name == 'Gluttonous Joker' then
        area.cards[i].ability.extra.s_mult = G.P_CENTERS.j_gluttenous_joker.config.extra.s_mult
      elseif area.cards[i].ability.name == 'Jolly Joker' then
        area.cards[i].ability.t_mult = G.P_CENTERS.j_jolly.config.t_mult
      elseif area.cards[i].ability.name == 'Zany Joker' then
        area.cards[i].ability.t_mult = G.P_CENTERS.j_zany.config.t_mult
      elseif area.cards[i].ability.name == 'Mad Joker' then
        area.cards[i].ability.t_mult = G.P_CENTERS.j_mad.config.t_mult
      elseif area.cards[i].ability.name == 'Crazy Joker' then
        area.cards[i].ability.t_mult = G.P_CENTERS.j_crazy.config.t_mult
      elseif area.cards[i].ability.name == 'Droll Joker' then
        area.cards[i].ability.t_mult = G.P_CENTERS.j_droll.config.t_mult
      elseif area.cards[i].ability.name == 'Half Joker' then
        area.cards[i].ability.extra.mult = G.P_CENTERS.j_half.config.extra.mult
      elseif area.cards[i].ability.name == 'Mystic Summit' then
        area.cards[i].ability.extra.mult = G.P_CENTERS.j_half.config.extra.mult
      elseif area.cards[i].ability.name == 'Misprint' then
        area.cards[i].ability.extra.min = G.P_CENTERS.j_misprint.config.extra.min
        area.cards[i].ability.extra.max = G.P_CENTERS.j_misprint.config.extra.max
      elseif area.cards[i].ability.name == 'Fibonacci' then
        area.cards[i].ability.extra = G.P_CENTERS.j_fibonacci.config.extra
      elseif area.cards[i].ability.name == 'Abstract Joker' then
        area.cards[i].ability.extra = G.P_CENTERS.j_abstract.config.extra
      elseif area.cards[i].ability.name == 'Gros Michel' then
        area.cards[i].ability.extra.mult = G.P_CENTERS.j_gros_michel.config.extra.mult
        area.cards[i].ability.extra.odds = G.P_CENTERS.j_gros_michel.config.extra.odds
      elseif area.cards[i].ability.name == 'Even Steven' then
        area.cards[i].ability.extra = G.P_CENTERS.j_even_steven.config.extra
      elseif area.cards[i].ability.name == 'Ride the Bus' then
        area.cards[i].ability.extra = G.P_CENTERS.j_ride_the_bus.config.extra
      elseif area.cards[i].ability.name == 'Green Joker' then
        area.cards[i].ability.extra.hand_add = G.P_CENTERS.j_green_joker.config.extra.hand_add
      elseif area.cards[i].ability.name == 'Red Card' then
        area.cards[i].ability.extra = G.P_CENTERS.j_red_card.config.extra
      elseif area.cards[i].ability.name == 'Erosion' then
        area.cards[i].ability.extra = G.P_CENTERS.j_erosion.config.extra
      elseif area.cards[i].ability.name == 'Fortune Teller' then
        area.cards[i].ability.extra = G.P_CENTERS.j_fortune_teller.config.extra
      elseif area.cards[i].ability.name == 'Flash Card' then
        area.cards[i].ability.extra = G.P_CENTERS.j_flash.config.extra
      elseif area.cards[i].ability.name == 'Popcorn' then
        area.cards[i].ability.mult = G.P_CENTERS.j_popcorn.config.mult
        area.cards[i].ability.extra = G.P_CENTERS.j_popcorn.config.extra
      elseif area.cards[i].ability.name == 'Spare Trousers' then
        area.cards[i].ability.extra = G.P_CENTERS.j_trousers.config.extra
      elseif area.cards[i].ability.name == 'Smiley Face' then
        area.cards[i].ability.extra = G.P_CENTERS.j_smiley.config.extra
      elseif area.cards[i].ability.name == 'Onyx Agate' then
        area.cards[i].ability.extra = G.P_CENTERS.j_onyx_agate.config.extra
      elseif area.cards[i].ability.name == 'Shoot the Moon' then
        area.cards[i].ability.extra = G.P_CENTERS.j_shoot_the_moon.config.extra
      elseif area.cards[i].ability.name == 'Bootstraps' then
        area.cards[i].ability.extra.mult = G.P_CENTERS.j_bootstraps.config.extra.mult
      elseif area.cards[i].ability.name == 'Scholar' then
        area.cards[i].ability.extra.mult = G.P_CENTERS.j_scholar.config.extra.mult
        area.cards[i].ability.extra.mult = G.P_CENTERS.j_scholar.config.extra.chips
      elseif area.cards[i].ability.name == 'Walkie Talkie' then
        area.cards[i].ability.extra.mult = G.P_CENTERS.j_walkie_talkie.config.extra.mult
        area.cards[i].ability.extra.mult = G.P_CENTERS.j_walkie_talkie.config.extra.chips

      -- XMULT
      elseif area.cards[i].ability.name == 'Joker Stencil' then
        area.cards[i].ability.extra = G.P_CENTERS.j_stencil.config.extra
      elseif area.cards[i].ability.name == 'Loyalty Card' then
        area.cards[i].ability.extra.Xmult = G.P_CENTERS.j_loyalty_card.config.extra.Xmult
        area.cards[i].ability.extra.every = G.P_CENTERS.j_loyalty_card.config.extra.every
      elseif area.cards[i].ability.name == 'Steel Joker' then
        area.cards[i].ability.extra = G.P_CENTERS.j_steel_joker.config.extra
      elseif area.cards[i].ability.name == 'Blackboard' then
        area.cards[i].ability.extra = G.P_CENTERS.j_blackboard.config.extra
      elseif area.cards[i].ability.name == 'Constellation' then
        area.cards[i].ability.extra = G.P_CENTERS.j_constellation.config.extra
      elseif area.cards[i].ability.name == 'Cavendish' then
        area.cards[i].ability.extra.Xmult = G.P_CENTERS.j_cavendish.config.extra.Xmult
        area.cards[i].ability.extra.odds = G.P_CENTERS.j_cavendish.config.extra.odds
      elseif area.cards[i].ability.name == 'Card Sharp' then
        area.cards[i].ability.extra.Xmult = G.P_CENTERS.j_card_sharp.config.extra.Xmult
      elseif area.cards[i].ability.name == 'Madness' then
        area.cards[i].ability.extra = G.P_CENTERS.j_madness.config.extra
      elseif area.cards[i].ability.name == 'Vampire' then
        area.cards[i].ability.extra = G.P_CENTERS.j_vampire.config.extra
      elseif area.cards[i].ability.name == 'Hologram' then
        area.cards[i].ability.extra = G.P_CENTERS.j_hologram.config.extra
      elseif area.cards[i].ability.name == 'Baron' then
        area.cards[i].ability.extra = G.P_CENTERS.j_baron.config.extra
      elseif area.cards[i].ability.name == 'Obelisk' then
        area.cards[i].ability.extra = G.P_CENTERS.j_obelisk.config.extra
      elseif area.cards[i].ability.name == 'Photograph' then
        area.cards[i].ability.extra = G.P_CENTERS.j_photograph.config.extra
      elseif area.cards[i].ability.name == 'Lucky Cat' then
        area.cards[i].ability.extra = G.P_CENTERS.j_lucky_cat.config.extra
      elseif area.cards[i].ability.name == 'Baseball Card' then
        area.cards[i].ability.extra = G.P_CENTERS.j_baseball.config.extra
      elseif area.cards[i].ability.name == 'Ancient Joker' then
        area.cards[i].ability.extra = G.P_CENTERS.j_ancient.config.extra
      elseif area.cards[i].ability.name == 'Ramen' then
        area.cards[i].ability.XMult = G.P_CENTERS.j_ramen.config.XMult
      elseif area.cards[i].ability.name == 'Campfire' then
        area.cards[i].ability.extra = G.P_CENTERS.j_campfire.config.extra
      elseif area.cards[i].ability.name == 'Acrobat' then
        area.cards[i].ability.extra = G.P_CENTERS.j_acrobat.config.extra
      elseif area.cards[i].ability.name == 'Throwback' then
        area.cards[i].ability.extra = G.P_CENTERS.j_throwback.config.extra
      elseif area.cards[i].ability.name == 'Bloodstone' then
        area.cards[i].ability.extra.Xmult = G.P_CENTERS.j_bloodstone.config.extra.Xmult
        area.cards[i].ability.extra.odds = G.P_CENTERS.j_bloodstone.config.extra.odds
      elseif area.cards[i].ability.name == 'Glass Joker' then
        area.cards[i].ability.extra = G.P_CENTERS.j_glass.config.extra
      elseif area.cards[i].ability.name == 'Flower Pot' then
        area.cards[i].ability.extra = G.P_CENTERS.j_flower_pot.config.extra
      elseif area.cards[i].ability.name == 'The Idol' then
        area.cards[i].ability.extra = G.P_CENTERS.j_idol.config.extra
      elseif area.cards[i].ability.name == 'Seeing Double' then
        area.cards[i].ability.extra = G.P_CENTERS.j_seeing_double.config.extra
      elseif area.cards[i].ability.name == 'Hit the Road' then
        area.cards[i].ability.extra = G.P_CENTERS.j_hit_the_road.config.extra
      elseif area.cards[i].ability.name == 'The Duo' then
        area.cards[i].ability.Xmult = G.P_CENTERS.j_duo.config.Xmult
      elseif area.cards[i].ability.name == 'The Trio' then
        area.cards[i].ability.Xmult = G.P_CENTERS.j_trio.config.Xmult
      elseif area.cards[i].ability.name == 'The Family' then
        area.cards[i].ability.Xmult = G.P_CENTERS.j_family.config.Xmult
      elseif area.cards[i].ability.name == 'The Order' then
        area.cards[i].ability.Xmult = G.P_CENTERS.j_order.config.Xmult
      elseif area.cards[i].ability.name == 'The Tribe' then
        area.cards[i].ability.Xmult = G.P_CENTERS.j_tribe.config.Xmult
      elseif area.cards[i].ability.name == "Driver's License" then
        area.cards[i].ability.extra = G.P_CENTERS.j_drivers_license.config.extra
      elseif area.cards[i].ability.name == 'Caino' then
        area.cards[i].ability.extra = G.P_CENTERS.j_caino.config.extra
      elseif area.cards[i].ability.name == 'Triboulet' then
        area.cards[i].ability.extra = G.P_CENTERS.j_triboulet.config.extra
      elseif area.cards[i].ability.name == 'Yorick' then
        area.cards[i].ability.extra.xmult = G.P_CENTERS.j_yorick.config.extra.xmult
        area.cards[i].ability.extra.discards = G.P_CENTERS.j_yorick.config.extra.discards

      -- CHIPS
      elseif area.cards[i].ability.name == 'Sly Joker' then
        area.cards[i].ability.t_chips = G.P_CENTERS.j_sly.config.t_chips
      elseif area.cards[i].ability.name == 'Wily Joker' then
        area.cards[i].ability.t_chips = G.P_CENTERS.j_wily.config.t_chips
      elseif area.cards[i].ability.name == 'Clever Joker' then
        area.cards[i].ability.t_chips = G.P_CENTERS.j_clever.config.t_chips
      elseif area.cards[i].ability.name == 'Devious Joker' then
        area.cards[i].ability.t_chips = G.P_CENTERS.j_devious.config.t_chips
      elseif area.cards[i].ability.name == 'Crafty Joker' then
        area.cards[i].ability.t_chips = G.P_CENTERS.j_crafty.config.t_chips
      elseif area.cards[i].ability.name == 'Banner' then
        area.cards[i].ability.extra = G.P_CENTERS.j_banner.config.extra
      elseif area.cards[i].ability.name == 'Scary Face' then
        area.cards[i].ability.extra = G.P_CENTERS.j_scary_face.config.extra
      elseif area.cards[i].ability.name == 'Odd Todd' then
        area.cards[i].ability.extra = G.P_CENTERS.j_odd_todd.config.extra
      elseif area.cards[i].ability.name == 'Runner' then
        area.cards[i].ability.extra.chip_mod = G.P_CENTERS.j_runner.config.extra.chip_mod
      elseif area.cards[i].ability.name == 'Ice Cream' then
        area.cards[i].ability.extra.chips = G.P_CENTERS.j_ice_cream.config.extra.chips
        area.cards[i].ability.extra.chip_mod = G.P_CENTERS.j_ice_cream.config.extra.chip_mod
      elseif area.cards[i].ability.name == 'Blue Joker' then
        area.cards[i].ability.extra = G.P_CENTERS.j_blue_joker.config.extra
      elseif area.cards[i].ability.name == 'Hiker' then
        area.cards[i].ability.extra = G.P_CENTERS.j_hiker.config.extra
      elseif area.cards[i].ability.name == 'Square Joker' then
        area.cards[i].ability.extra.chip_mod = G.P_CENTERS.j_square.config.extra.chip_mod
      elseif area.cards[i].ability.name == 'Stone Joker' then
        area.cards[i].ability.extra = G.P_CENTERS.j_stone.config.extra
      elseif area.cards[i].ability.name == 'Bull' then
        area.cards[i].ability.extra = G.P_CENTERS.j_bull.config.extra
      elseif area.cards[i].ability.name == 'Castle' then
        area.cards[i].ability.extra.chip_mod = G.P_CENTERS.j_castle.config.extra.chip_mod
      elseif area.cards[i].ability.name == 'Arrowhead' then
        area.cards[i].ability.extra = G.P_CENTERS.j_arrowhead.config.extra
      elseif area.cards[i].ability.name == 'Wee Joker' then
        area.cards[i].ability.extra.chip_mod = G.P_CENTERS.j_wee.config.extra.chip_mod
      elseif area.cards[i].ability.name == 'Stuntman' then
        area.cards[i].ability.extra.chip_mod = G.P_CENTERS.j_stuntman.config.extra.chip_mod
        area.cards[i].ability.extra.h_size = G.P_CENTERS.j_stuntman.config.extra.h_size

      -- ECON
      elseif area.cards[i].ability.name == 'Credit Card' then
        area.cards[i].ability.extra = G.P_CENTERS.j_credit_card.config.extra
      elseif area.cards[i].ability.name == 'Delayed Gratification' then
        area.cards[i].ability.extra = G.P_CENTERS.j_delayed_grat.config.extra
      elseif area.cards[i].ability.name == 'Egg' then
        area.cards[i].ability.extra = G.P_CENTERS.j_egg.config.extra
      elseif area.cards[i].ability.name == 'Faceless Joker' then
        area.cards[i].ability.extra.dollars = G.P_CENTERS.j_faceless.config.extra.dollars
      elseif area.cards[i].ability.name == 'To Do List' then
        area.cards[i].ability.extra.dollars = G.P_CENTERS.j_todo_list.config.extra.dollars
      elseif area.cards[i].ability.name == 'Cloud 9' then
        area.cards[i].ability.extra = G.P_CENTERS.j_cloud_9.config.extra
      elseif area.cards[i].ability.name == 'Rocket' then
        area.cards[i].ability.extra.increase = G.P_CENTERS.j_rocket.config.extra.increase
      elseif area.cards[i].ability.name == 'Reserved Parking' then
        area.cards[i].ability.extra.dollars = G.P_CENTERS.j_reserved_parking.config.extra.dollars
        area.cards[i].ability.extra.odds = G.P_CENTERS.j_reserved_parking.config.extra.odds
      elseif area.cards[i].ability.name == 'Mail-in Rebate' then
        area.cards[i].ability.extra = G.P_CENTERS.j_mail.config.extra
      elseif area.cards[i].ability.name == 'To the Moon' then
        area.cards[i].ability.extra = G.P_CENTERS.j_to_the_moon.config.extra
      elseif area.cards[i].ability.name == 'Golden Joker' then
        area.cards[i].ability.extra = G.P_CENTERS.j_golden.config.extra
      elseif area.cards[i].ability.name == 'Trading Card' then
        area.cards[i].ability.extra = G.P_CENTERS.j_trading.config.extra
      elseif area.cards[i].ability.name == 'Golden Ticket' then
        area.cards[i].ability.extra = G.P_CENTERS.j_ticket.config.extra
      elseif area.cards[i].ability.name == 'Rough Gem' then
        area.cards[i].ability.extra = G.P_CENTERS.j_rough_gem.config.extra
      elseif area.cards[i].ability.name == 'Matador' then
        area.cards[i].ability.extra = G.P_CENTERS.j_matador.config.extra
      elseif area.cards[i].ability.name == 'Satellite' then
        area.cards[i].ability.extra = G.P_CENTERS.j_satellite.config.extra

      -- EFFECT
      elseif area.cards[i].ability.name == 'Mime' then
        area.cards[i].ability.extra = G.P_CENTERS.j_mime.config.extra
      elseif area.cards[i].ability.name == 'Dusk' then
        area.cards[i].ability.extra = G.P_CENTERS.j_dusk.config.extra
      elseif area.cards[i].ability.name == 'Hack' then
        area.cards[i].ability.extra = G.P_CENTERS.j_hack.config.extra
      elseif area.cards[i].ability.name == 'Seltzer' then
        area.cards[i].ability.extra = G.P_CENTERS.j_selzer.config.extra
      elseif area.cards[i].ability.name == 'Sock and Buskin' then
        area.cards[i].ability.extra = G.P_CENTERS.j_sock_and_buskin.config.extra
      elseif area.cards[i].ability.name == 'Hanging Chad' then
        area.cards[i].ability.extra = G.P_CENTERS.j_hanging_chad.config.extra
      elseif area.cards[i].ability.name == '8 Ball' then
        area.cards[i].ability.extra = G.P_CENTERS.j_8_ball.config.extra
      elseif area.cards[i].ability.name == 'Chaos the Clown' then
        area.cards[i].ability.extra = G.P_CENTERS.j_chaos.config.extra
      elseif area.cards[i].ability.name == 'Space Joker' then
        area.cards[i].ability.extra = G.P_CENTERS.j_space.config.extra
      elseif area.cards[i].ability.name == 'Burglar' then
        area.cards[i].ability.extra = G.P_CENTERS.j_burglar.config.extra
      elseif area.cards[i].ability.name == 'Riff-raff' then
        area.cards[i].ability.extra = G.P_CENTERS.j_riff_raff.config.extra
      elseif area.cards[i].ability.name == 'Vagabond' then
        area.cards[i].ability.extra = G.P_CENTERS.j_vagabond.config.extra
      elseif area.cards[i].ability.name == 'Turtle Bean' then
        area.cards[i].ability.extra.h_size = G.P_CENTERS.j_turtle_bean.config.extra.h_size
      elseif area.cards[i].ability.name == 'Hallucination' then
        area.cards[i].ability.extra = G.P_CENTERS.j_hallucination.config.extra
      elseif area.cards[i].ability.name == 'Juggler' then
        area.cards[i].ability.h_size = G.P_CENTERS.j_juggler.config.h_size
      elseif area.cards[i].ability.name == 'Drunkard' then
        area.cards[i].ability.d_size = G.P_CENTERS.j_drunkard.config.d_size
      elseif area.cards[i].ability.name == 'Troubadour' then
        area.cards[i].ability.extra.h_size = G.P_CENTERS.j_troubadour.config.extra.h_size
      elseif area.cards[i].ability.name == 'Merry Andy' then
        area.cards[i].ability.d_size = G.P_CENTERS.j_merry_andy.config.d_size
      elseif area.cards[i].ability.name == 'Invisible' then
        area.cards[i].ability.extra = G.P_CENTERS.j_invisible.config.extra

      -- TAROTS
      elseif area.cards[i].ability.name == 'The Fool' then
        area.cards[i].ability.max_highlighted = G.P_CENTERS.c_fool.config.max_highlighted
      elseif area.cards[i].ability.name == 'The High Priestess' then
        area.cards[i].ability.planets = G.P_CENTERS.c_high_priestess.config.planets
      elseif area.cards[i].ability.name == 'The Empress' then
        area.cards[i].ability.max_highlighted = G.P_CENTERS.c_empress.config.max_highlighted
      elseif area.cards[i].ability.name == 'The Emperor' then
        area.cards[i].ability.tarots = G.P_CENTERS.c_emperor.config.tarots
      elseif area.cards[i].ability.name == 'The Hierophant' then
        area.cards[i].ability.max_highlighted = G.P_CENTERS.c_heirophant.config.max_highlighted
      elseif area.cards[i].ability.name == 'The Lovers' then
        area.cards[i].ability.max_highlighted = G.P_CENTERS.c_lovers.config.max_highlighted
      elseif area.cards[i].ability.name == 'The Chariot' then
        area.cards[i].ability.max_highlighted = G.P_CENTERS.c_chariot.config.max_highlighted
      elseif area.cards[i].ability.name == 'Justice' then
        area.cards[i].ability.max_highlighted = G.P_CENTERS.c_justice.config.max_highlighted
      elseif area.cards[i].ability.name == 'The Hermit' then
        area.cards[i].ability.extra = G.P_CENTERS.c_hermit.config.extra
      elseif area.cards[i].ability.name == 'The Wheel of Fortune' then
        area.cards[i].ability.extra = G.P_CENTERS.c_wheel_of_fortune.config.extra
      elseif area.cards[i].ability.name == 'Strength' then
        area.cards[i].ability.max_highlighted = G.P_CENTERS.c_strength.config.max_highlighted
      elseif area.cards[i].ability.name == 'The Hanged Man' then
        area.cards[i].ability.max_highlighted = G.P_CENTERS.c_hanged_man.config.max_highlighted
      elseif area.cards[i].ability.name == 'Death' then
        area.cards[i].ability.max_highlighted = G.P_CENTERS.c_death.config.max_highlighted
      elseif area.cards[i].ability.name == 'Temperance' then
        area.cards[i].ability.extra = G.P_CENTERS.c_temperance.config.extra
      elseif area.cards[i].ability.name == 'The Devil' then
        area.cards[i].ability.max_highlighted = G.P_CENTERS.c_devil.config.max_highlighted
      elseif area.cards[i].ability.name == 'The Tower' then
        area.cards[i].ability.max_highlighted = G.P_CENTERS.c_tower.config.max_highlighted
      elseif area.cards[i].ability.name == 'The Star' then
        area.cards[i].ability.max_highlighted = G.P_CENTERS.c_star.config.max_highlighted
      elseif area.cards[i].ability.name == 'The Moon' then
        area.cards[i].ability.max_highlighted = G.P_CENTERS.c_moon.config.max_highlighted
      elseif area.cards[i].ability.name == 'The Sun' then
        area.cards[i].ability.max_highlighted = G.P_CENTERS.c_sun.config.max_highlighted
      elseif area.cards[i].ability.name == 'The World' then
        area.cards[i].ability.max_highlighted = G.P_CENTERS.c_world.config.max_highlighted

      -- PLANETS

      -- SPECTRALS
      elseif area.cards[i].ability.name == 'Talisman' then
        area.cards[i].ability.max_highlighted = G.P_CENTERS.c_talisman.config.max_highlighted
      elseif area.cards[i].ability.name == 'Deja Vu' then
        area.cards[i].ability.max_highlighted = G.P_CENTERS.c_deja_vu.config.max_highlighted
      elseif area.cards[i].ability.name == 'Trance' then
        area.cards[i].ability.max_highlighted = G.P_CENTERS.c_trance.config.max_highlighted
      elseif area.cards[i].ability.name == 'Medium' then
        area.cards[i].ability.max_highlighted = G.P_CENTERS.c_medium.config.max_highlighted
      end

    end
  end
end


function set_centers(mult_lvl, xmult_lvl, chips_lvl, econ_lvl, effect_lvl, tarot_lvl, planet_lvl, spectral_lvl, enhance_lvl, edition_lvl, pack_lvl, tag_lvl, voucher_lvl, blind_lvl, updatearea)

-- Note: the suffix _level is the global level, whereas the suffix _lvl is local within the function only

-- Unimplemented Jokers: 
-- Blueprint, Brainstorm

  -- MULT (complete)
  G.P_CENTERS.j_joker.config.mult = 4 + ((mult_lvl-1) * 2)
  G.P_CENTERS.j_greedy_joker.config.extra.s_mult = 3 + ((mult_lvl-1) * 1)
  G.P_CENTERS.j_lusty_joker.config.extra.s_mult = 3 + ((mult_lvl-1) * 1)
  G.P_CENTERS.j_wrathful_joker.config.extra.s_mult = 3 + ((mult_lvl-1) * 1)
  G.P_CENTERS.j_gluttenous_joker.config.extra.s_mult = 3 + ((mult_lvl-1) * 1)
  G.P_CENTERS.j_jolly.config.t_mult = 8 + ((mult_lvl-1) * 3)
  G.P_CENTERS.j_zany.config.t_mult = 12 + ((mult_lvl-1) * 3)
  G.P_CENTERS.j_mad.config.t_mult = 10 + ((mult_lvl-1) * 3)
  G.P_CENTERS.j_crazy.config.t_mult = 12 + ((mult_lvl-1) * 3)
  G.P_CENTERS.j_droll.config.t_mult = 10 + ((mult_lvl-1) * 3)
  G.P_CENTERS.j_half.config.extra.mult = 20 + ((mult_lvl-1) * 4)
  -- G.P_CENTERS.j_ceremonial: see lovely.toml
  G.P_CENTERS.j_mystic_summit.config.extra.mult = 15 + ((mult_lvl-1) * 3)
  G.P_CENTERS.j_misprint.config.extra.min = 0 + ((mult_lvl-1) * 3)
  G.P_CENTERS.j_misprint.config.extra.max = 23 + ((mult_lvl-1) * 3)
  G.P_CENTERS.j_fibonacci.config.extra = 8 + ((mult_lvl-1) * 2)
  G.P_CENTERS.j_abstract.config.extra = 3 + ((mult_lvl-1) * 1)
  G.P_CENTERS.j_gros_michel.config.extra.mult = 15 + ((mult_lvl-1) * 3)
  G.P_CENTERS.j_gros_michel.config.extra.odds = math.max(1, (6 - ((mult_lvl-1) * 1)))
  G.P_CENTERS.j_even_steven.config.extra = 4 + ((mult_lvl-1) * 1)
  -- G.P_CENTERS.j_supernova.config.extra: in lovely.toml
  G.P_CENTERS.j_ride_the_bus.config.extra = 1 + ((mult_lvl-1) * 1)
  G.P_CENTERS.j_green_joker.config.extra.hand_add = 1 + ((mult_lvl-1) * 1)
  G.P_CENTERS.j_red_card.config.extra = 3 + ((mult_lvl-1) * 2)
  G.P_CENTERS.j_erosion.config.extra = 4 + ((mult_lvl-1) * 1)
  G.P_CENTERS.j_fortune_teller.config.extra = 1 + ((mult_lvl-1) * 1)
  G.P_CENTERS.j_flash.config.extra = 2 + ((mult_lvl-1) * 1)
  G.P_CENTERS.j_popcorn.config.mult = 20 + ((mult_lvl-1) * 3)
  G.P_CENTERS.j_popcorn.config.extra = math.max(1, (4 - ((mult_lvl-1) * 1)))
  G.P_CENTERS.j_trousers.config.extra = 2 + ((mult_lvl-1) * 1)
  G.P_CENTERS.j_smiley.config.extra = 5 + ((mult_lvl-1) * 1)
  -- G.P_CENTERS.j_swashbuckler: see lovely.toml
  G.P_CENTERS.j_onyx_agate.config.extra = 7 + ((mult_lvl-1) * 2)
  G.P_CENTERS.j_shoot_the_moon.config.extra = 13 + ((mult_lvl-1) * 2)
  -- G.P_CENTERS.j_shoot_the_moon: see lovely.toml
  G.P_CENTERS.j_bootstraps.config.extra.mult = 2 + ((mult_lvl-1) * 1)
  G.P_CENTERS.j_scholar.config.extra.mult = 4 + ((mult_lvl-1) * 1)
  G.P_CENTERS.j_walkie_talkie.config.extra.mult = 4 + ((mult_lvl-1) * 1)
  G.P_CENTERS.j_scholar.config.extra.chips = 20 + ((mult_lvl-1) * 10)
  G.P_CENTERS.j_walkie_talkie.config.extra.chips = 10 + ((mult_lvl-1) * 10)
  -- G.P_CENTERS.j_raised_fist: see lovely.toml

  -- XMULT (complete)
  G.P_CENTERS.j_stencil.config.extra = 1 + ((xmult_lvl-1) * 0.25)
  -- G.P_CENTERS.j_stencil: see lovely.toml
  G.P_CENTERS.j_loyalty_card.config.extra.Xmult = 4 + ((xmult_lvl-1) * 0.25)
  G.P_CENTERS.j_loyalty_card.config.extra.every = math.max(1, (5 - ((xmult_lvl-1) * 1)))
  G.P_CENTERS.j_steel_joker.config.extra = 0.2 + ((xmult_lvl-1) * 0.05)
  G.P_CENTERS.j_blackboard.config.extra = 3 + ((xmult_lvl-1) * 0.25)
  G.P_CENTERS.j_constellation.config.extra = 0.1 + ((xmult_lvl-1) * 0.05)
  G.P_CENTERS.j_cavendish.config.extra.Xmult = 3 + ((xmult_lvl-1) * 0.15)
  G.P_CENTERS.j_cavendish.config.extra.odds = 1000 + ((xmult_lvl-1) * 500)
  G.P_CENTERS.j_card_sharp.config.extra.Xmult = 3 + ((xmult_lvl-1) * 0.25)
  G.P_CENTERS.j_madness.config.extra = 0.5 + ((xmult_lvl-1) * 0.25)
  G.P_CENTERS.j_vampire.config.extra = 0.1 + ((xmult_lvl-1) * 0.05)
  G.P_CENTERS.j_hologram.config.extra = 0.1 + ((xmult_lvl-1) * 0.05)
  G.P_CENTERS.j_baron.config.extra = 1.5 + ((xmult_lvl-1) * 0.1)
  G.P_CENTERS.j_obelisk.config.extra = 0.2 + ((xmult_lvl-1) * 0.1)
  G.P_CENTERS.j_photograph.config.extra = 2 + ((xmult_lvl-1) * 0.1)
  G.P_CENTERS.j_lucky_cat.config.extra = 0.25 + ((xmult_lvl-1) * 0.05)
  G.P_CENTERS.j_baseball.config.extra = 1.5 + ((xmult_lvl-1) * 0.2)
  G.P_CENTERS.j_ancient.config.extra = 1.5 + ((xmult_lvl-1) * 0.15)
  G.P_CENTERS.j_ramen.config.Xmult = 2 + ((xmult_lvl-1) * 0.25)
  G.P_CENTERS.j_campfire.config.extra = 0.25 + ((xmult_lvl-1) * 0.1)
  G.P_CENTERS.j_acrobat.config.extra = 3 + ((xmult_lvl-1) * 0.25)
  G.P_CENTERS.j_throwback.config.extra = 0.25 + ((xmult_lvl-1) * 0.15)
  G.P_CENTERS.j_bloodstone.config.extra.Xmult = 1.5 + ((xmult_lvl-1) * 0.15)
  G.P_CENTERS.j_bloodstone.config.extra.odds = math.max(1, (2 - ((xmult_lvl-1) * 0.25)))
  G.P_CENTERS.j_glass.config.extra = 0.75 + ((xmult_lvl-1) * 0.25)
  G.P_CENTERS.j_flower_pot.config.extra = 3 + ((xmult_lvl-1) * 0.25)
  G.P_CENTERS.j_idol.config.extra = 2 + ((xmult_lvl-1) * 0.1)
  G.P_CENTERS.j_seeing_double.config.extra = 2 + ((xmult_lvl-1) * 0.25)
  G.P_CENTERS.j_hit_the_road.config.extra = 0.5 + ((xmult_lvl-1) * 0.15)
  G.P_CENTERS.j_duo.config.Xmult = 2 + ((xmult_lvl-1) * 0.25)
  G.P_CENTERS.j_trio.config.Xmult = 3 + ((xmult_lvl-1) * 0.25)
  G.P_CENTERS.j_family.config.Xmult = 4 + ((xmult_lvl-1) * 0.25)
  G.P_CENTERS.j_order.config.Xmult = 3 + ((xmult_lvl-1) * 0.25)
  G.P_CENTERS.j_tribe.config.Xmult = 2 + ((xmult_lvl-1) * 0.25)
  G.P_CENTERS.j_drivers_license.config.extra = (xmult_lvl == 1 and 3) or (xmult_lvl >= 2 and (0.15 + ((xmult_lvl-2) * 0.05)))
  G.P_CENTERS.j_caino.config.extra = 1 + ((xmult_lvl-1) * 0.5)
  G.P_CENTERS.j_triboulet.config.extra = 2 + ((xmult_lvl-1) * 0.25)
  G.P_CENTERS.j_yorick.config.extra.xmult = 1 + ((xmult_lvl-1) * 0.25)
  G.P_CENTERS.j_yorick.config.extra.discards = math.max(1, (23 - ((xmult_lvl-1) * 2)))

  -- CHIPS (complete)
  G.P_CENTERS.j_sly.config.t_chips = 50 + ((chips_lvl-1) * 20)
  G.P_CENTERS.j_wily.config.t_chips = 100 + ((chips_lvl-1) * 20)
  G.P_CENTERS.j_clever.config.t_chips = 80 + ((chips_lvl-1) * 20)
  G.P_CENTERS.j_devious.config.t_chips = 100 + ((chips_lvl-1) * 20)
  G.P_CENTERS.j_crafty.config.t_chips = 80 + ((chips_lvl-1) * 20)
  G.P_CENTERS.j_banner.config.extra = 30 + ((chips_lvl-1) * 10)
  G.P_CENTERS.j_scary_face.config.extra = 30 + ((chips_lvl-1) * 10)
  G.P_CENTERS.j_odd_todd.config.extra = 31 + ((chips_lvl-1) * 10)
  G.P_CENTERS.j_runner.config.extra.chip_mod = 15 + ((chips_lvl-1) * 10)
  G.P_CENTERS.j_ice_cream.config.extra.chips = 100 + ((chips_lvl-1) * 20)
  G.P_CENTERS.j_ice_cream.config.extra.chip_mod = math.max(1, (5 - ((chips_lvl-1) * 1)))
  G.P_CENTERS.j_blue_joker.config.extra = 2 + ((chips_lvl-1) * 1)
  G.P_CENTERS.j_hiker.config.extra = 5 + ((chips_lvl-1) * 2)
  G.P_CENTERS.j_square.config.extra.chip_mod = 4 + ((chips_lvl-1) * 3)
  G.P_CENTERS.j_stone.config.extra = 25 + ((chips_lvl-1) * 5)
  G.P_CENTERS.j_bull.config.extra = 2 + ((chips_lvl-1) * 1)
  G.P_CENTERS.j_castle.config.extra.chip_mod = 3 + ((chips_lvl-1) * 2)
  G.P_CENTERS.j_arrowhead.config.extra = 50 + ((chips_lvl-1) * 15)
  G.P_CENTERS.j_wee.config.extra.chip_mod = 8 + ((chips_lvl-1) * 4)
  G.P_CENTERS.j_stuntman.config.extra.chip_mod = 250 + ((chips_lvl-1) * 50)
  G.P_CENTERS.j_stuntman.config.extra.h_size = math.max(0, (2 - ((chips_lvl-1) * 1)))

-- ECON (complete)
  G.P_CENTERS.j_credit_card.config.extra = 20 + ((econ_lvl-1) * 10)
  G.P_CENTERS.j_delayed_grat.config.extra = 2 + ((econ_lvl-1) * 1)
  -- G.P_CENTERS.j_business: see lovely.toml 
  G.P_CENTERS.j_business.config.extra = math.max(1, (2 - (econ_lvl-1)*0.25))
  G.P_CENTERS.j_egg.config.extra = 3 + ((econ_lvl-1) * 2)
  G.P_CENTERS.j_faceless.config.extra.dollars = 5 + ((econ_lvl-1) * 3)
  G.P_CENTERS.j_todo_list.config.extra.dollars = 4 + ((econ_lvl-1) * 2)
  G.P_CENTERS.j_cloud_9.config.extra = 1 + ((econ_lvl-1) * 1)
  G.P_CENTERS.j_rocket.config.extra.increase = 2 + ((econ_lvl-1) * 1)
  G.P_CENTERS.j_gift.config.extra = 1 + ((econ_lvl-1) * 1)
  G.P_CENTERS.j_reserved_parking.config.extra.dollars = 1 + ((econ_lvl-1) * 1)
  G.P_CENTERS.j_reserved_parking.config.extra.odds = math.max(1, (2 - (econ_lvl-1)*0.25))
  G.P_CENTERS.j_mail.config.extra = 5 + ((econ_lvl-1) * 1)
  G.P_CENTERS.j_to_the_moon.config.extra = 1 + ((econ_lvl-1) * 1)
  G.P_CENTERS.j_golden.config.extra = 4 + ((econ_lvl-1) * 2)
  G.P_CENTERS.j_trading.config.extra = 3 + ((econ_lvl-1) * 2)
  -- G.P_CENTERS.j_trading: see below (hooked); also see lovely.toml
  G.P_CENTERS.j_ticket.config.extra = 4 + ((econ_lvl-1) * 2)
  G.P_CENTERS.j_rough_gem.config.extra = 1 + ((econ_lvl-1) * 1)
  G.P_CENTERS.j_matador.config.extra = 8 + ((econ_lvl-1) * 4)
  G.P_CENTERS.j_satellite.config.extra = 1 + ((econ_lvl-1) * 1)

-- EFFECT (incomplete: Blueprint, Brainstorm)
  G.P_CENTERS.j_mime.config.extra = math.floor(1 + ((effect_lvl-1) * 0.5))
  G.P_CENTERS.j_dusk.config.extra = math.floor(1 + ((effect_lvl-1) * 0.5))
  G.P_CENTERS.j_hack.config.extra = math.floor(1 + ((effect_lvl-1) * 0.5))
  G.P_CENTERS.j_selzer.config.extra = 10 + ((effect_lvl-1) * 5)
  G.P_CENTERS.j_sock_and_buskin.config.extra = math.floor(1 + ((effect_lvl-1) * 0.5))
  G.P_CENTERS.j_hanging_chad.config.extra = math.floor(2 + ((effect_lvl-1) * 0.5))
  -- G.P.CENTERS.j_four_fingers: see below (hooked)
  -- G.P_CENTERS.j_marble: see lovely.toml
  G.P_CENTERS.j_8_ball.config.extra = math.max(1, (4 - ((effect_lvl-1) * 1)))
  -- G.P.CENTERS.j_8_ball: see lovely.toml
  -- G.P_CENTERS.j_chaos: see lovely.toml
  G.P_CENTERS.j_chaos.config.extra = 1 + ((effect_lvl-1) * 1)
  G.P_CENTERS.j_space.config.extra = math.max(1, (4 - ((effect_lvl-1) * 1)))
  G.P_CENTERS.j_burglar.config.extra = 3 + ((effect_lvl-1) * 1)
  -- G.P.CENTERS.j_dna: see below (hooked); also see lovely.toml
  -- G.P.CENTERS.j_splash: see below (hooked)
  -- G.P.CENTERS.j_pareidolia: level 2 disables Plant and Mark
  -- G.P.CENTERS.j_sixth_sense: see lovely.toml
  -- G.P.CENTERS.j_superposition: see lovely.toml
  -- G.P.CENTERS.j_seance: see lovely.toml
  G.P_CENTERS.j_riff_raff.config.extra = 2 + ((effect_lvl-1) * 1)
  -- G.P.CENTERS.j_shortcut: see below (hooked)
  G.P_CENTERS.j_vagabond.config.extra = 4 + ((effect_lvl-1) * 3)
  -- G.P.CENTERS.j_vagabond: see lovely.toml
  -- G.P.CENTERS.j_midas_mask: see lovely.toml
  -- G.P.CENTERS.j_luchador: reduces blind level
  G.P_CENTERS.j_turtle_bean.config.extra.h_size = 5 + ((effect_lvl-1) * 1)
  G.P_CENTERS.j_hallucination.config.extra = math.max(1, (2 - ((effect_lvl-1) * 0.25)))
  -- G.P.CENTERS.j_hallucination: see lovely.toml
  G.P_CENTERS.j_juggler.config.h_size = math.floor(1 + ((effect_lvl-1) * 0.5))
  G.P_CENTERS.j_drunkard.config.d_size = math.floor(1 + ((effect_lvl-1) * 0.5))
  -- G.P.CENTERS.j_diet_cola: see lovely.toml
  -- G.P.CENTERS.j_mr_bones: see lovely.toml
  G.P_CENTERS.j_troubadour.config.extra.h_size = 2 + ((effect_lvl-1) * 1)
  -- G.P.CENTERS.j_certificate: see below (hooked)
  -- G.P.CENTERS.j_smeared: level 2 prevents suit boss debuffs; level 3 treats all suits the same
  -- G.P.CENTERS.j_showman: see below (hooked)
  -- G.P.CENTERS.j_blueprint: UNIMPLEMENTED
  G.P_CENTERS.j_merry_andy.config.d_size = 3 + ((effect_lvl-1) * 1)
  -- G.P.CENTERS.j_oops: see lovely.toml
  G.P_CENTERS.j_invisible.config.extra = math.max(0, (2 - ((effect_lvl-1) * 1)))
  -- G.P.CENTERS.j_invisible: see lovely.toml
  -- G.P.CENTERS.j_brainstorm: UNIMPLEMENTED
  -- G.P.CENTERS.j_cartomancer: see lovely.toml
  -- G.P.CENTERS.j_astronomer: see lovely.toml
  -- G.P.CENTERS.j_burnt: see lovely.toml
  -- G.P.CENTERS.j_chicot: reduces blind level
  -- G.P.CENTERS.j_perkeo: see below (hooked)

-- TAROTS (complete)
  -- G.P.CENTERS.c_fool: see below (hooked)
  G.P_CENTERS.c_magician.config.max_highlighted = math.min(5, 2 + ((tarot_lvl-1) * 1))
  G.P_CENTERS.c_high_priestess.config.planets = 2 + ((tarot_lvl-1) * 1)
  G.P_CENTERS.c_empress.config.max_highlighted = math.min(5, 2 + ((tarot_lvl-1) * 1))
  G.P_CENTERS.c_emperor.config.tarots = 2 + ((tarot_lvl-1) * 1)
  G.P_CENTERS.c_heirophant.config.max_highlighted = 2 + ((tarot_lvl-1) * 1)
  G.P_CENTERS.c_lovers.config.max_highlighted = math.min(5, 1 + ((tarot_lvl-1) * 1))
  G.P_CENTERS.c_chariot.config.max_highlighted = math.min(5, 1 + ((tarot_lvl-1) * 1))
  G.P_CENTERS.c_justice.config.max_highlighted = math.min(5, 1 + ((tarot_lvl-1) * 1))
  G.P_CENTERS.c_hermit.config.extra = 20 + ((tarot_lvl-1) * 10)
  -- G.P_CENTERS.c_hermit: see lovely.toml
  G.P_CENTERS.c_wheel_of_fortune.config.extra = math.max(1, (4 - ((tarot_lvl-1) * 1)))
  G.P_CENTERS.c_strength.config.max_highlighted = math.min(5, 2 + ((tarot_lvl-1) * 1))
  G.P_CENTERS.c_hanged_man.config.max_highlighted = math.min(5, 2 + ((tarot_lvl-1) * 1))
  G.P_CENTERS.c_death.config.max_highlighted = math.min(5, 2 + ((tarot_lvl-1) * 1))
  G.P_CENTERS.c_temperance.config.extra = 50 + ((tarot_lvl-1) * 20)
  -- G.P_CENTERS.c_temperance: see lovely.toml
  G.P_CENTERS.c_devil.config.max_highlighted = math.min(5, 1 + ((tarot_lvl-1) * 1))
  G.P_CENTERS.c_tower.config.max_highlighted = math.min(5, 1 + ((tarot_lvl-1) * 1))
  G.P_CENTERS.c_star.config.max_highlighted = math.min(5, 3 + ((tarot_lvl-1) * 1))
  G.P_CENTERS.c_moon.config.max_highlighted = math.min(5, 3 + ((tarot_lvl-1) * 1))
  G.P_CENTERS.c_sun.config.max_highlighted = math.min(5, 3 + ((tarot_lvl-1) * 1))
  -- G.P_CENTERS.c_judgement: see below (hooked)
  G.P_CENTERS.c_world.config.max_highlighted = math.min(5, 3 + ((tarot_lvl-1) * 1))

-- PLANETS (complete)
-- in lovely.toml

-- SPECTRALS (complete)
  -- G.P_CENTERS.familiar: see below (hooked)
  -- G.P_CENTERS.grim: see below (hooked)
  -- G.P_CENTERS.incantation: see below (hooked)
  G.P_CENTERS.c_talisman.config.max_highlighted = math.min(5, 1 + ((spectral_lvl-1) * 1))
  -- G.P_CENTERS.aura: see lovely.toml
  -- G.P_CENTERS.wraith: see lovely.toml
  -- G.P_CENTERS.sigil: see below (hooked) 
  -- G.P_CENTERS.ouija: see below (hooked) 
  -- G.P_CENTERS.ectoplasm: see lovely.toml
  -- G.P_CENTERS.immolate: see below (hooked)
  -- G.P_CENTERS.ankh: see lovely.toml
  G.P_CENTERS.c_deja_vu.config.max_highlighted = math.min(5, 1 + ((spectral_lvl-1) * 1))
  -- G.P_CENTERS.hex: see lovely.toml
  G.P_CENTERS.c_trance.config.max_highlighted = math.min(5, 1 + ((spectral_lvl-1) * 1))
  G.P_CENTERS.c_medium.config.max_highlighted = math.min(5, 1 + ((spectral_lvl-1) * 1))
  -- G.P_CENTERS.c_cryptid: see lovely.toml
  -- G.P_CENTERS.soul: see below (hooked)
  -- G.P_CENTERS.black_hole: see lovely.toml

-- ENHANCEMENTS (complete)
  G.P_CENTERS.m_bonus.config.bonus = 30 + ((enhance_lvl-1) * 15)
  G.P_CENTERS.m_mult.config.mult = 4 + ((enhance_lvl-1) * 2)
  -- G.P_CENTERS.m_wild: see lovely.toml
  G.P_CENTERS.m_glass.config.Xmult = 2 + ((enhance_lvl-1) * 0.25)
  G.P_CENTERS.m_glass.config.extra = 4 + ((enhance_lvl-1) * 2)
  G.P_CENTERS.m_steel.config.h_x_mult = 1.5 + ((enhance_lvl-1) * 0.25)
  G.P_CENTERS.m_stone.config.bonus = 50 + ((enhance_lvl-1) * 25)
  G.P_CENTERS.m_gold.config.h_dollars = 3 + ((enhance_lvl-1) * 1)
  G.P_CENTERS.m_lucky.config.mult = 20 + ((enhance_lvl-1) * 4)
  G.P_CENTERS.m_lucky.config.p_dollars = 20 + ((enhance_lvl-1) * 5)
  -- G.P_CENTERS.m_lucky: see lovely.toml

-- EDITIONS (complete)
  G.P_CENTERS.e_foil.config.extra = 50 + ((edition_lvl-1) * 30)
  G.P_CENTERS.e_holo.config.extra = 10 + ((edition_lvl-1) * 4)
  G.P_CENTERS.e_polychrome.config.extra = 1.5 + ((edition_lvl-1) * 0.25)
  G.P_CENTERS.e_negative.config.extra = math.floor(1 + ((edition_lvl-1) * 0.5))

-- SEALS (complete)
-- all in lovely.toml

-- PACKS (vanilla packs complete)
  G.P_CENTERS.p_arcana_normal_1.config.extra = math.floor(3+(2/3) + ((pack_lvl-1) * (2/3)))
  G.P_CENTERS.p_arcana_normal_1.config.choose = math.floor(1 + ((pack_lvl-1) * (1/3)))
  G.P_CENTERS.p_arcana_normal_2.config.extra = math.floor(3+(2/3) + ((pack_lvl-1) * (2/3)))
  G.P_CENTERS.p_arcana_normal_2.config.choose = math.floor(1 + ((pack_lvl-1) * (1/3)))
  G.P_CENTERS.p_arcana_normal_3.config.extra = math.floor(3+(2/3) + ((pack_lvl-1) * (2/3)))
  G.P_CENTERS.p_arcana_normal_3.config.choose = math.floor(1 + ((pack_lvl-1) * (1/3)))
  G.P_CENTERS.p_arcana_normal_4.config.extra = math.floor(3+(2/3) + ((pack_lvl-1) * (2/3)))
  G.P_CENTERS.p_arcana_normal_4.config.choose = math.floor(1 + ((pack_lvl-1) * (1/3)))
  G.P_CENTERS.p_arcana_jumbo_1.config.extra = math.floor(5 + ((pack_lvl-1) * (2/3)))
  G.P_CENTERS.p_arcana_jumbo_1.config.choose = math.floor(1+(2/3) + ((pack_lvl-1) * (1/3)))
  G.P_CENTERS.p_arcana_jumbo_2.config.extra = math.floor(5 + ((pack_lvl-1) * (2/3)))
  G.P_CENTERS.p_arcana_jumbo_2.config.choose = math.floor(1+(2/3) + ((pack_lvl-1) * (1/3)))
  G.P_CENTERS.p_arcana_mega_1.config.extra = math.floor(5+(2/3) + ((pack_lvl-1) * (2/3)))
  G.P_CENTERS.p_arcana_mega_1.config.choose = math.floor(2 + ((pack_lvl-1) * (1/3)))
  G.P_CENTERS.p_arcana_mega_2.config.extra = math.floor(5+(2/3) + ((pack_lvl-1) * (2/3)))
  G.P_CENTERS.p_arcana_mega_2.config.choose = math.floor(2 + ((pack_lvl-1) * (1/3)))
  G.P_CENTERS.p_celestial_normal_1.config.extra = math.floor(3+(2/3) + ((pack_lvl-1) * (2/3)))
  G.P_CENTERS.p_celestial_normal_1.config.choose = math.floor(1 + ((pack_lvl-1) * (1/3)))
  G.P_CENTERS.p_celestial_normal_2.config.extra = math.floor(3+(2/3) + ((pack_lvl-1) * (2/3)))
  G.P_CENTERS.p_celestial_normal_2.config.choose = math.floor(1 + ((pack_lvl-1) * (1/3)))
  G.P_CENTERS.p_celestial_normal_3.config.extra = math.floor(3+(2/3) + ((pack_lvl-1) * (2/3)))
  G.P_CENTERS.p_celestial_normal_3.config.choose = math.floor(1 + ((pack_lvl-1) * (1/3)))
  G.P_CENTERS.p_celestial_normal_4.config.extra = math.floor(3+(2/3) + ((pack_lvl-1) * (2/3)))
  G.P_CENTERS.p_celestial_normal_4.config.choose = math.floor(1 + ((pack_lvl-1) * (1/3)))
  G.P_CENTERS.p_celestial_jumbo_1.config.extra = math.floor(5 + ((pack_lvl-1) * (2/3)))
  G.P_CENTERS.p_celestial_jumbo_1.config.choose = math.floor(1+(2/3) + ((pack_lvl-1) * (1/3)))
  G.P_CENTERS.p_celestial_jumbo_2.config.extra = math.floor(5 + ((pack_lvl-1) * (2/3)))
  G.P_CENTERS.p_celestial_jumbo_2.config.choose = math.floor(1+(2/3) + ((pack_lvl-1) * (1/3)))
  G.P_CENTERS.p_celestial_mega_1.config.extra = math.floor(5+(2/3) + ((pack_lvl-1) * (2/3)))
  G.P_CENTERS.p_celestial_mega_1.config.choose = math.floor(2 + ((pack_lvl-1) * (1/3)))
  G.P_CENTERS.p_celestial_mega_2.config.extra = math.floor(5+(2/3) + ((pack_lvl-1) * (2/3)))
  G.P_CENTERS.p_celestial_mega_2.config.choose = math.floor(2 + ((pack_lvl-1) * (1/3)))
  G.P_CENTERS.p_standard_normal_1.config.extra = math.floor(3+(2/3) + ((pack_lvl-1) * (2/3)))
  G.P_CENTERS.p_standard_normal_1.config.choose = math.floor(1 + ((pack_lvl-1) * (1/3)))
  G.P_CENTERS.p_standard_normal_2.config.extra = math.floor(3+(2/3) + ((pack_lvl-1) * (2/3)))
  G.P_CENTERS.p_standard_normal_2.config.choose = math.floor(1 + ((pack_lvl-1) * (1/3)))
  G.P_CENTERS.p_standard_normal_3.config.extra = math.floor(3+(2/3) + ((pack_lvl-1) * (2/3)))
  G.P_CENTERS.p_standard_normal_3.config.choose = math.floor(1 + ((pack_lvl-1) * (1/3)))
  G.P_CENTERS.p_standard_normal_4.config.extra = math.floor(3+(2/3) + ((pack_lvl-1) * (2/3)))
  G.P_CENTERS.p_standard_normal_4.config.choose = math.floor(1 + ((pack_lvl-1) * (1/3)))
  G.P_CENTERS.p_standard_jumbo_1.config.extra = math.floor(5 + ((pack_lvl-1) * (2/3)))
  G.P_CENTERS.p_standard_jumbo_1.config.choose = math.floor(1+(2/3) + ((pack_lvl-1) * (1/3)))
  G.P_CENTERS.p_standard_jumbo_2.config.extra = math.floor(5 + ((pack_lvl-1) * (2/3)))
  G.P_CENTERS.p_standard_jumbo_2.config.choose = math.floor(1+(2/3) + ((pack_lvl-1) * (1/3)))
  G.P_CENTERS.p_standard_mega_1.config.extra = math.floor(5+(2/3) + ((pack_lvl-1) * (2/3)))
  G.P_CENTERS.p_standard_mega_1.config.choose = math.floor(2 + ((pack_lvl-1) * (1/3)))
  G.P_CENTERS.p_standard_mega_2.config.extra = math.floor(5+(2/3) + ((pack_lvl-1) * (2/3)))
  G.P_CENTERS.p_standard_mega_2.config.choose = math.floor(2 + ((pack_lvl-1) * (1/3)))
  G.P_CENTERS.p_buffoon_normal_1.config.extra = math.floor(2+(2/3) + ((pack_lvl-1) * (2/3)))
  G.P_CENTERS.p_buffoon_normal_1.config.choose = math.floor(1 + ((pack_lvl-1) * (1/3)))
  G.P_CENTERS.p_buffoon_normal_2.config.extra = math.floor(2+(2/3) + ((pack_lvl-1) * (2/3)))
  G.P_CENTERS.p_buffoon_normal_2.config.choose = math.floor(1 + ((pack_lvl-1) * (1/3)))
  G.P_CENTERS.p_buffoon_jumbo_1.config.extra = math.floor(4 + ((pack_lvl-1) * (2/3)))
  G.P_CENTERS.p_buffoon_jumbo_1.config.choose = math.floor(1+(2/3) + ((pack_lvl-1) * (1/3)))
  G.P_CENTERS.p_buffoon_mega_1.config.extra = math.floor(4+(2/3) + ((pack_lvl-1) * (2/3)))
  G.P_CENTERS.p_buffoon_mega_1.config.choose = math.floor(2 + ((pack_lvl-1) * (1/3)))
  G.P_CENTERS.p_spectral_normal_1.config.extra = math.floor(2+(2/3) + ((pack_lvl-1) * (2/3)))
  G.P_CENTERS.p_spectral_normal_1.config.choose = math.floor(1 + ((pack_lvl-1) * (1/3)))
  G.P_CENTERS.p_spectral_normal_2.config.extra = math.floor(2+(2/3) + ((pack_lvl-1) * (2/3)))
  G.P_CENTERS.p_spectral_normal_2.config.choose = math.floor(1 + ((pack_lvl-1) * (1/3)))
  G.P_CENTERS.p_spectral_jumbo_1.config.extra = math.floor(4 + ((pack_lvl-1) * (2/3)))
  G.P_CENTERS.p_spectral_jumbo_1.config.choose = math.floor(1+(2/3) + ((pack_lvl-1) * (1/3)))
  G.P_CENTERS.p_spectral_mega_1.config.extra = math.floor(4+(2/3) + ((pack_lvl-1) * (2/3)))
  G.P_CENTERS.p_spectral_mega_1.config.choose = math.floor(2 + ((pack_lvl-1) * (1/3)))

-- TAGS (complete)
  -- G.P_TAGS.tag_uncommon: see lovely.toml
  -- G.P_TAGS.tag_rare: see lovely.toml
  -- G.P_TAGS.tag_negative: see lovely.toml
  -- G.P_TAGS.tag_foil: see lovely.toml
  -- G.P_TAGS.tag_holo: see lovely.toml
  -- G.P_TAGS.tag_polychrome: see lovely.toml
  G.P_TAGS.tag_investment.config.dollars = 25 + (tag_lvl-1)*10
  -- G.P_TAGS.tag_voucher: see lovely.toml 
  -- G.P_TAGS.tag_boss: see lovely.toml 
  -- G.P_TAGS.tag_standard: see lovely.toml
  -- G.P_TAGS.tag_charm: see lovely.toml
  -- G.P_TAGS.tag_meteor: see lovely.toml
  -- G.P_TAGS.tag_buffoon: see lovely.toml
  G.P_TAGS.tag_handy.config.dollars_per_hand = 1 + (tag_lvl-1)*1
  G.P_TAGS.tag_garbage.config.dollars_per_discard = 1 + (tag_lvl-1)*2
  -- G.P_TAGS.tag_ethereal: see lovely.toml
  -- G.P_TAGS.tag_coupon: see below (hooked); also see lovely.toml
  -- G.P_TAGS.tag_double: see lovely.toml
  G.P_TAGS.tag_juggle.config.h_size = 3 + (tag_lvl-1)*1
  -- G.P_TAGS.tag_d_six: see lovely.toml
  G.P_TAGS.tag_top_up.config.spawn_jokers = math.max(2, 1 + (tag_lvl-1)*1)
  -- G.P_TAGS.tag_top_up: see lovely.toml
  G.P_TAGS.tag_skip.config.skip_bonus = 5 + (tag_lvl-1)*5
  G.P_TAGS.tag_orbital.config.levels = 3 + (tag_lvl-1)*2
  G.P_TAGS.tag_economy.config.max = 40 + (tag_lvl-1)*20

-- VOUCHERS (complete)
  -- G.P_CENTERS.v_overstock_norm: see below (hooked)
  -- G.P_CENTERS.v_overstock_plus: see below (hooked)
  G.P_CENTERS.v_clearance_sale.config.extra = math.min(100, 25 + (voucher_lvl-1)*3)
  G.P_CENTERS.v_liquidation.config.extra = math.min(100, 50 + (voucher_lvl-1)*6)
  G.P_CENTERS.v_hone.config.extra = 2 + (voucher_lvl-1)*0.5
  G.P_CENTERS.v_glow_up.config.extra = 4 + (voucher_lvl-1)*1
  G.P_CENTERS.v_reroll_surplus.config.extra = 2 + (voucher_lvl-1)*1
  G.P_CENTERS.v_reroll_glut.config.extra = 2 + (voucher_lvl-1)*1
  G.P_CENTERS.v_crystal_ball.config.extra = 3 + (voucher_lvl-1)*1
  -- G.P_CENTERS.v_omen_globe: see below (hooked); also see lovely.toml
  -- G.P_CENTERS.v_telescope: UNDECIDED
  G.P_CENTERS.v_observatory.config.extra = 1.5 + (voucher_lvl-1)*0.5
  G.P_CENTERS.v_grabber.config.extra = math.floor(1.5 + (voucher_lvl-1)*0.5)
  G.P_CENTERS.v_nacho_tong.config.extra = math.floor(1.5 + (voucher_lvl-1)*0.5)
  G.P_CENTERS.v_wasteful.config.extra = math.floor(1.5 + (voucher_lvl-1)*0.5)
  G.P_CENTERS.v_recyclomancy.config.extra = math.floor(1.5 + (voucher_lvl-1)*0.5)
  G.P_CENTERS.v_tarot_merchant.config.extra = 6*math.min(3, (2 + (voucher_lvl-1)*0.25)) / (7 - math.min(3, (2 + (voucher_lvl-1)*0.25)))
  G.P_CENTERS.v_tarot_tycoon.config.extra = 6*math.min(6, (4 + (voucher_lvl-1)*0.5)) / (7 - math.min(6, (4 + (voucher_lvl-1)*0.5)))
  G.P_CENTERS.v_planet_merchant.config.extra = 6*math.min(3, (2 + (voucher_lvl-1)*0.25)) / (7 - math.min(3, (2 + (voucher_lvl-1)*0.25)))
  G.P_CENTERS.v_planet_tycoon.config.extra = 6*math.min(6, (4 + (voucher_lvl-1)*0.5)) / (7 - math.min(6, (4 + (voucher_lvl-1)*0.5)))
  G.P_CENTERS.v_seed_money.config.extra = 50 + (voucher_lvl-1)*15
  G.P_CENTERS.v_money_tree.config.extra = 100 + (voucher_lvl-1)*30
  -- G.P_CENTERS.v_blank
  -- G.P_CENTERS.v_antimatter: see below (hooked); also see lovely.toml
  G.P_CENTERS.v_magic_trick.config.extra = 28*math.max(4, (1 + (voucher_lvl-1)*0.5)) / (8 - math.max(4, (1 + (voucher_lvl-1)*0.5)))
  G.P_CENTERS.v_illusion.config.extra = math.max(0, 4 - ((voucher_lvl-1)*4))
  G.P_CENTERS.v_hieroglyph.config.extra = 1 + (voucher_lvl-1)*1
  G.P_CENTERS.v_petroglyph.config.extra = 1 + (voucher_lvl-1)*1
  -- G.P_CENTERS.v_directors_cut: see below (hooked); also see lovely.toml
  -- G.P_CENTERS.v_retcon: see below (hooked); also see lovely.toml
  -- G.P_CENTERS.v_paint_brush: see below (hooked)
  -- G.P_CENTERS.v_palette: see below (hooked)

-- BLINDS (complete)
-- Wall and Violet Vessel
  if blind_lvl >= 0 then
    G.P_BLINDS.bl_wall.mult = 2*(blind_lvl+1)
    G.P_BLINDS.bl_final_vessel.mult = 2*((2*blind_lvl)+1)
  elseif blind_lvl <= -1 then
    G.P_BLINDS.bl_wall.mult = 2*(2^blind_lvl)
    G.P_BLINDS.bl_final_vessel.mult = 2*(3^blind_lvl)
  end
-- Others: see lovely.toml

-- updateitems will not trigger if the area doesn't exist
  updateitems(G.jokers)
  updateitems(G.consumeables)
  updateitems(G.shop_jokers)
end

-- Set levels at start
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
  set_centers(mult_level, xmult_level, chips_level, econ_level, effect_level, tarot_level, planet_level, spectral_level, enhance_level, edition_level, pack_level, tag_level, voucher_level, blind_level)
  desc(mult_level, xmult_level, chips_level, econ_level, effect_level, tarot_level, planet_level, spectral_level, enhance_level, edition_level, pack_level, tag_level, voucher_level, blind_level)
end

-- Upgrade in-game
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
    edition_level = edition_level + amount
  elseif category == "pack" then
    pack_level = pack_level + amount
  elseif category == "tag" then
    tag_level = tag_level + amount
  elseif category == "voucher" and amount == 1 then
    voucher_level = voucher_level + 1
    upgrade_vouchers(voucher_level - 1)
  elseif category == "blind" then
    blind_level = blind_level + amount
  end
  set_centers(mult_level, xmult_level, chips_level, econ_level, effect_level, tarot_level, planet_level, spectral_level, enhance_level, edition_level, pack_level, tag_level, voucher_level, blind_level)
  desc(mult_level, xmult_level, chips_level, econ_level, effect_level, tarot_level, planet_level, spectral_level, enhance_level, edition_level, pack_level, tag_level, voucher_level, blind_level)
end

-- Poll edition is no longer static
-- For Aura and Wheel of Fortune:
--   Level 1: 50% foil, 35% holo, 15% poly
--   Level 2: 40% foil, 30% holo, 30% poly
--   Level 3: 30% foil, 25% holo, 45% poly
--   Level 4: 20% foil, 20% holo, 60% poly

function poll_edition(_key, _mod, _no_neg, _guaranteed)
  _mod = _mod or 1
  local edition_poll = pseudorandom(pseudoseed(_key or 'edition_generic'))
  if _key == 'aura' then
    if edition_poll >= 0.85 - (0.15*(spectral_level-1)) then
      return {polychrome = true}
    elseif edition_poll >= 0.5 - (0.1*(spectral_level-1)) then
      return {holo = true}
    else
      return {foil = true}
    end
  elseif _key == 'wheel_of_fortune' then
    if edition_poll >= 0.85 - (0.15*(tarot_level-1)) then
      return {polychrome = true}
    elseif edition_poll >= 0.5 - (0.1*(tarot_level-1)) then
      return {holo = true}
    else
      return {foil = true}
    end
  elseif _key == 'conedi' then 
    local neg_rate = 0.006*(voucher_level-1)
    local poly_rate = (0.015*(voucher_level-1)) + (0.014*(voucher_level-2))
    local holo_rate = (0.024*(voucher_level-1)) - (0.001*(voucher_level-2)) -- Telescope: lv11 | lvl2 | lvl3 | lvl4 | TO BE COMPLETED
    local foil_rate = (0.035*(voucher_level-1)) - (0.013*(voucher_level-2))
    if edition_poll >= 1 - neg_rate then                                               --  0%  | 0.6% | 1.2% | 1.8% | 
      return {negative = true} 
    elseif edition_poll >= 1 - (neg_rate+poly_rate) then                               --  0%  | 1.5% | 4.4% | 7.3% |               (1.5*(voucher_level-1)) + (1.4*(voucher_level-2))
      return {polychrome = true}
    elseif edition_poll >= 1 - (neg_rate+poly_rate+holo_rate) then                     --  0%  | 2.4% | 4.7% | 7.1% |               (2.4*(voucher_level-1)) - (0.1*(voucher_level-2))
      return {holo = true}
    elseif edition_poll >= 1 - (neg_rate+poly_rate+holo_rate+foil_rate) then           --  0%  | 3.5% | 5.7% | 7.9% |               (3.5*(voucher_level-1)) - (1.3*(voucher_level-2))
      return {foil = true}
    end                                                                          -- Total  0%  |  8%  | 16%  | 24%  |
  elseif _guaranteed then
    if edition_poll >= 1 - 0.003*25 and not _no_neg then
      return {negative = true}
    elseif edition_poll >= 1 - 0.006*25 then
      return {polychrome = true}
    elseif edition_poll >= 1 - 0.02*25 then
      return {holo = true}
    elseif edition_poll >= 1 - 0.04*25 then
      return {foil = true}
    end
  else
    local neg_rate = 0.003
    local poly_rate = 0.003
    local holo_rate = 0.014
    local foil_rate = 0.02
    local neg_modif = 1
    if G.GAME.used_vouchers["v_hone"] or G.GAME.used_vouchers["v_glow_up"] then
      poly_rate = 0.003 + (voucher_level-1)*0.003
      holo_rate = 0.014 - (voucher_level-1)*0.001
      foil_rate = 0.02 - (voucher_level-1)*0.002
      if G.GAME.used_vouchers["v_glow_up"] then
        neg_modif = (1 + (voucher_level-1)*1)
      elseif G.GAME.used_vouchers["v_hone"] then
        neg_modif = (1 + (voucher_level-1)*0.5)
      end
    end
    if edition_poll >= 1 - 0.003*neg_modif*_mod and not _no_neg then                          -- Hone / Glow Up:  Lvl1 | Lvl2 | Lvl3 | Lvl4 | Lvl5 | Lvl6
      return {negative = true}
    elseif edition_poll >= 1 - (0.003*neg_modif + poly_rate)*G.GAME.edition_rate*_mod then                     -- 0.3% | 0.6% | 0.9% | 1.2% | 1.5% | 1.8%
      return {polychrome = true} 
    elseif edition_poll >= 1 - (0.003*neg_modif + poly_rate+holo_rate)*G.GAME.edition_rate*_mod then           -- 1.4% | 1.3% | 1.2% | 1.1% | 1%   | 0.9%
      return {holo = true}
    elseif edition_poll >= 1 - (0.003*neg_modif + poly_rate+holo_rate+foil_rate)*G.GAME.edition_rate*_mod then -- 2%   | 1.8% | 1.6% | 1.4% | 1.2% | 1.0%
      return {foil = true}
    end                                                                                                  -- Total 3.7%
  end
  return nil
end

-- Level 2 Shortcut and Four Fingers compatibility for Flushes and Straights
function get_flush(hand)
  local ret = {}
  local four_fingers = 0
  if next(find_joker('Four Fingers')) and effect_level >= 2 then
    four_fingers = 2
  elseif next(find_joker('Four Fingers')) and effect_level == 1 then
    four_fingers = 1
  end
  local suits = SMODS.Suit.obj_buffer
  if #hand < (5 - four_fingers) then return ret else
    for j = 1, #suits do
      local t = {}
      local suit = suits[j]
      local flush_count = 0
      for i=1, #hand do
        if hand[i]:is_suit(suit, nil, true) then flush_count = flush_count + 1;  t[#t+1] = hand[i] end 
      end
      if flush_count >= (5 - four_fingers) then
        table.insert(ret, t)
        return ret
      end
    end
    return {}
  end
end

function get_straight(hand)
  local ret = {}
  local four_fingers = 0
  if next(find_joker('Four Fingers')) and effect_level >= 2 then
    four_fingers = 2
  elseif next(find_joker('Four Fingers')) and effect_level == 1 then
    four_fingers = 1
  end
  if #hand > 5 or #hand < (5 - four_fingers) then return ret else
    local t = {}
    local IDS = {}
    for i=1, #hand do
      local id = hand[i]:get_id()
      if id > 1 and id < 15 then
        if IDS[id] then
          IDS[id][#IDS[id]+1] = hand[i]
        else
          IDS[id] = {hand[i]}
        end
      end
    end
    local straight_length = 0
    local straight = false
    local can_skip = next(find_joker('Shortcut')) 
    local skipped_rank = false
    if effect_level >= 2 then
      for j = 1, 21 do
      if IDS[(j == 1 and 14) or (j == 15 and 2) or (j == 16 and 3) or (j == 17 and 4) or (j == 18 and 5) or (j == 19 and 6) or (j == 20 and 7) or (j == 21 and 8) or j] then
        straight_length = straight_length + 1
        skipped_rank = false
        for k, v in ipairs(IDS[(j == 1 and 14) or (j == 15 and 2) or (j == 16 and 3) or (j == 17 and 4) or (j == 18 and 5) or (j == 19 and 6) or (j == 20 and 7) or (j == 21 and 8) or j]) do
          t[#t+1] = v
        end
      elseif can_skip and not skipped_rank and j ~= 14 then
          skipped_rank = true
      else
        straight_length = 0
        skipped_rank = false
        if not straight then t = {} end
        if straight then break end
      end
      if straight_length >= (5 - four_fingers) then straight = true end 
    end
    if not straight then return ret end
    table.insert(ret, t)
    return ret
    elseif effect_level == 1 then
      for j = 1, 14 do
        if IDS[j == 1 and 14 or j] then
          straight_length = straight_length + 1
          skipped_rank = false
          for k, v in ipairs(IDS[j == 1 and 14 or j]) do
            t[#t+1] = v
          end
        elseif can_skip and not skipped_rank and j ~= 14 then
          skipped_rank = true
        else
          straight_length = 0
          skipped_rank = false
          if not straight then t = {} end
          if straight then break end
        end
        if straight_length >= (5 - four_fingers) then straight = true end 
      end
      if not straight then return ret end
      table.insert(ret, t)
      return ret
    end
  end
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

-- Hooking for consumables (those that can't be set just by changing G.P_CENTERS or using lovely.toml), including Incantation, Grim, Judgement, The Soul, Sigil, Ouija, Immolate,
-- Talisman, Deja Vu, Trance, Medium
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
  if (self.ability.name == 'Grim') and (spectral_level >= 2) then
    for i = 1, spectral_level-1 do
      local _pool, _pool_key = get_current_pool('Tag', nil, nil, append)
      local _tag = pseudorandom_element(_pool, pseudoseed('grim'))
      local it = 1
      while _tag == 'UNAVAILABLE' do
        it = it + 1
        _tag = pseudorandom_element(_pool, pseudoseed('grim_resample'..it))
      end
      add_tag(Tag(_tag))
    end
  elseif (self.ability.name == 'Incantation') and (spectral_level >= 2) then
    incantate = pseudorandom(pseudoseed('incan'))
    destroyed_cards = {}
    for i=#G.hand.highlighted, 1, -1 do
      destroyed_cards[#destroyed_cards+1] = G.hand.highlighted[i]
      print("Booster pack: "..tostring(G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED))
      if incantate <= G.GAME.probabilities.normal/math.max((2 - (effect_level-2)/3), 1) then
        G.hand.highlighted[i]:set_edition({negative = true}, true)
        if G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED then
          G.hand:change_size(G.P_CENTERS.e_negative.config.extra)
        end
      else
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
    end
  elseif self.ability.name == 'Judgement' or self.ability.name == 'The Soul' then -- Judgement and The Soul
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
        _rank = G.hand.highlighted[1].base.id < 10 and tostring(card.base.id) or
                              G.hand.highlighted[1].base.id == 10 and 'T' or G.hand.highlighted[1].base.id == 11 and 'J' or
                              G.hand.highlighted[1].base.id == 12 and 'Q' or G.hand.highlighted[1].base.id == 13 and 'K' or
                              G.hand.highlighted[1].base.id == 14 and 'A'
      end
      for i=1, #G.hand.cards do
        G.E_MANAGER:add_event(Event({func = function()
          local card = G.hand.cards[i]
          local suit_prefix = string.sub(card.base.suit, 1, 1)..'_'
          local rank_suffix = _rank
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
  elseif (self.ability.name == 'Familiar' and spectral_level >= 2) then -- Familiar
    local destroyed_cards = {}
    local cards = {}
    local amount = #G.hand.highlighted
    delay(0.2)
    for i=amount, 1, -1 do
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
      cards[i] = true
      local _rank = pseudorandom_element({'2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A'}, pseudoseed('familiar_create'))
      local _suit = pseudorandom_element({'S','H','D','C'}, pseudoseed('familiar_create'))
      _suit = _suit or 'S'; _rank = _rank or 'A'
      local cen_pool = {}
      for k, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
        if v.key ~= 'm_stone' then 
          cen_pool[#cen_pool+1] = v
        end
      end
      local card_init = {front = G.P_CARDS[_suit..'_'.._rank], center = pseudorandom_element(cen_pool, pseudoseed('spe_card'))}
      local card = Card(G.hand.T.x, G.hand.T.y, G.CARD_W, G.CARD_H, card_init.front, card_init.center, {playing_card = G.playing_card})
      local seal_type = pseudorandom(pseudoseed('famsl'))
      local edition = pseudorandom(pseudoseed('famed'))
      if seal_type > 0.75 and spectral_level >= 3 then card:set_seal('Red', true)
      elseif seal_type > 0.5 and spectral_level >= 3 then card:set_seal('Blue', true)
      elseif seal_type > 0.25 and spectral_level >= 3 then card:set_seal('Gold', true)
      elseif spectral_level >= 3 then card:set_seal('Purple', true)
      end
      if edition >= 2/3 then card:set_edition({holo = true}, true)
      elseif edition >= 1/3 then card:set_edition({polychrome = true}, true)
      elseif edition >= 0/3 then card:set_edition({foil = true}, true)
      end
      table.insert(G.playing_cards, card)
      card.playing_card = G.playing_card
      G.hand:emplace(card)
      card:start_materialize({G.C.SECONDARY_SET.Spectral}, i ~= 1)
    end 
    playing_card_joker_effects(cards)
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
       repetitions = math.floor(1 + (effect_level-1)*0.5),
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
    G.hand.highlighted[1]:start_dissolve(nil, false)
    return {
      message = localize('$')..self.ability.extra,
      colour = G.C.MONEY,
      delay = 0.45, 
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
      if edition >= 2/3 and effect_level >= 3 then _card:set_edition({holo = true}, true)
      elseif edition >= 1/3 and effect_level >= 3 then _card:set_edition({polychrome = true}, true)
      elseif edition >= 0/3 and effect_level >= 3 then _card:set_edition({foil = true}, true)
      end
      if effect_level >= 2 and enhancement >= (6*52)/364 then _card:set_ability(G.P_CENTERS.m_wild, nil, true)
      elseif effect_level >= 2 and enhancement >= (5*52)/364 then _card:set_ability(G.P_CENTERS.m_mult, nil, true)
      elseif effect_level >= 2 and enhancement >= (4*52)/364 then _card:set_ability(G.P_CENTERS.m_bonus, nil, true)
      elseif effect_level >= 2 and enhancement >= (3*52)/364 then _card:set_ability(G.P_CENTERS.m_gold, nil, true)
      elseif effect_level >= 2 and enhancement >= (2*52)/364 then _card:set_ability(G.P_CENTERS.m_glass, nil, true)
      elseif effect_level >= 2 and enhancement >= (1*52)/364 then _card:set_ability(G.P_CENTERS.m_steel, nil, true)
      elseif effect_level >= 2 and enhancement >= (0*52)/364 then _card:set_ability(G.P_CENTERS.m_lucky, nil, true)
      end
      G.GAME.blind:debuff_card(_card)
      G.hand:sort()
      if context.blueprint_card then context.blueprint_card:juice_up() else self:juice_up() end
      return true
      end}))
    playing_card_joker_effects({true})
  elseif self.ability.set == "Joker" and not self.debuff and context.ending_shop and self.ability.name == 'Perkeo' then
    if G.consumeables.cards[1] then
      for i = 1, math.max(1, effect_level-1) do
        G.E_MANAGER:add_event(Event({
          func = function() 
            local card = nil
            if effect_level == 1 then
              card = copy_card(pseudorandom_element(G.consumeables.cards, pseudoseed('perkeo')), nil)
            elseif effect_level >= 2 then
              card = copy_card(G.consumeables.cards[1])
            end
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
    return card_calculate_joker_ref(self, context)
  end
end


-- Overwriting create_card_for_shop due to Level 2 Showman and upgraded vouchers (EDIT: Also need to add higher-level Magic Trick and Illusion)
function create_card_for_shop(area)
      if area == G.shop_jokers and G.SETTINGS.tutorial_progress and G.SETTINGS.tutorial_progress.forced_shop and G.SETTINGS.tutorial_progress.forced_shop[#G.SETTINGS.tutorial_progress.forced_shop] then
        local t = G.SETTINGS.tutorial_progress.forced_shop
        local _center = G.P_CENTERS[t[#t]] or G.P_CENTERS.c_empress
        local card = Card(area.T.x + area.T.w/2, area.T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, _center, {bypass_discovery_center = true, bypass_discovery_ui = true})
        t[#t] = nil
        if not t[1] then G.SETTINGS.tutorial_progress.forced_shop = nil end
        
        create_shop_card_ui(card)
        return card
      else
        local forced_tag = nil
        for k, v in ipairs(G.GAME.tags) do
          if not forced_tag then
            forced_tag = v:apply_to_run({type = 'store_joker_create', area = area})
            if forced_tag then
              for kk, vv in ipairs(G.GAME.tags) do
                if vv:apply_to_run({type = 'store_joker_modify', card = forced_tag}) then break end
              end
              return forced_tag end
          end
        end
          G.GAME.spectral_rate = G.GAME.spectral_rate or 0
          local total_rate = G.GAME.joker_rate + G.GAME.tarot_rate + G.GAME.planet_rate + G.GAME.playing_card_rate + G.GAME.spectral_rate
          local polled_rate = pseudorandom(pseudoseed('cdt'..G.GAME.round_resets.ante))*total_rate
          local check_rate = 0
          for _, v in ipairs({
            {type = 'Joker', val = G.GAME.joker_rate},
            {type = 'Tarot', val = G.GAME.tarot_rate},
            {type = 'Planet', val = G.GAME.planet_rate},
            {type = ((voucher_level == 1 and (G.GAME.used_vouchers["v_illusion"] and pseudorandom(pseudoseed('illusion')) > 0.6) and 'Enhanced')) or 'Base', val = G.GAME.playing_card_rate},
            {type = 'Spectral', val = G.GAME.spectral_rate},
          }) do
            if polled_rate > check_rate and polled_rate <= check_rate + v.val then
              local card = nil
              local showmanduplicate = pseudorandom(pseudoseed('showman'))
              if v.type == 'Joker' and next(find_joker('Showman')) and effect_level >= 2 and showmanduplicate <= G.GAME.probabilities.normal/math.max((30 - (effect_level-2)*5), 1) then
                card = copy_card(pseudorandom_element(G.jokers.cards, pseudoseed('showman')), nil, nil, nil, true)
                local edition = poll_edition('edi'..(key_append or '')..G.GAME.round_resets.ante)
                card:set_edition(edition)
                create_shop_card_ui(card, v.type, area)
              elseif (v.type == 'Tarot' or v.type == 'Planet' or v.type == 'Spectral') and next(find_joker('Showman')) and #G.consumeables.cards >= 1 and effect_level >= 2 and showmanduplicate <= G.GAME.probabilities.normal/math.max((30 - (effect_level-2)*5), 1) then
                local tarots = {}
                local planets = {}
                local spectrals = {}
                local card_to_be_copied = nil
                for i=1, #G.consumeables.cards do
                  if G.consumeables.cards[1].ability.set == 'Tarot' then
                    tarots[#tarots+1] = G.consumeables.cards[1]
                  elseif G.consumeables.cards[1].ability.set == 'Planet' then
                    planets[#planets+1] = G.consumeables.cards[1]
                  elseif G.consumeables.cards[1].ability.set == 'Spectral' then
                    spectrals[#spectrals+1] = G.consumeables.cards[1]
                  end
                end
                if v.type == 'Tarot' and #tarots >= 1 then
                  card_to_be_copied = pseudorandom_element(tarots, pseudoseed('showman'))
                  card = copy_card(card_to_be_copied, nil, nil, nil, true)
                elseif v.type == 'Planet' and #planets >= 1 then
                  card_to_be_copied = pseudorandom_element(planets, pseudoseed('showman'))
                  card = copy_card(card_to_be_copied, nil, nil, nil, true)
                elseif v.type == 'Spectral' and #spectrals >= 1 then
                  card_to_be_copied = pseudorandom_element(spectrals, pseudoseed('showman'))
                  card = copy_card(card_to_be_copied, nil, nil, nil, true)
                else
                  card = create_card(v.type, area, nil, nil, nil, nil, nil, 'sho')  
                end
                if G.GAME.used_vouchers.v_telescope and voucher_level >= 2 then
                  card:set_edition(poll_edition('conedi'))
                end
                create_shop_card_ui(card, v.type, area)
              elseif (v.type == 'Base') then
                if (G.GAME.used_vouchers["v_magic_trick"] and (not G.GAME.used_vouchers["v_illusion"])) and voucher_level >= 2 then -- Level 2 Magic Trick
                  card = create_card(v.type, area, nil, nil, nil, nil, nil, 'sho') -- lvl1 | lvl2 | lvl3 | lvl4
                  local enhancement = pseudorandom(pseudoseed('magenh'))           --  0%  | 12%  | 24%  | 36%
                  local edition = pseudorandom(pseudoseed('magedi'))               --  0%  |  0%  |  7%  | 14%
                  local seal = pseudorandom(pseudoseed('magseal'))                 --  0%  |  0%  |  0%  |  5%
                  if pseudorandom(pseudoseed('magic_trick')) < 0.12*(voucher_level-1) then
                    if enhancement >= 364/377 then _card:set_ability(G.P_CENTERS.m_stone, nil, true)
                    elseif enhancement >= (6*52)/377 then card:set_ability(G.P_CENTERS.m_wild, nil, true)
                    elseif enhancement >= (5*52)/377 then card:set_ability(G.P_CENTERS.m_mult, nil, true)
                    elseif enhancement >= (4*52)/377 then card:set_ability(G.P_CENTERS.m_bonus, nil, true)
                    elseif enhancement >= (3*52)/377 then card:set_ability(G.P_CENTERS.m_gold, nil, true)
                    elseif enhancement >= (2*52)/377 then card:set_ability(G.P_CENTERS.m_glass, nil, true)
                    elseif enhancement >= (1*52)/377 then card:set_ability(G.P_CENTERS.m_steel, nil, true)
                    elseif enhancement >= (0*52)/377 then card:set_ability(G.P_CENTERS.m_lucky, nil, true)
                    end
                  end
                  if pseudorandom(pseudoseed('magic_trick')) < 0.07*(voucher_level-2) then                       -- lvl1 | lvl2 | lvl3 | lvl4
                    if edition >= 0.85 - (voucher_level-1)*0.12 then card:set_edition({polychrome = true}, true) --  0%  | 15%  | 27%  | 39% 
                    elseif edition >= 0.5 - (voucher_level-1)*0.09 then card:set_edition({holo = true}, true)    --  0%  | 35%  | 32%  | 29% 
                    elseif edition >= 0 then card:set_edition({foil = true}, true)                               --  0%  | 50%  | 41%  | 32% 
                    end
                  end
                  if pseudorandom(pseudoseed('magic_trick')) < 0.05*(voucher_level-3) then
                    if seal > 0.75 then card:set_seal('Red', true)
                    elseif seal > 0.5 then card:set_seal('Blue', true)
                    elseif seal > 0.25 then card:set_seal('Gold', true)
                    else card:set_seal('Purple', true)
                    end
                  end
                  create_shop_card_ui(card, v.type, area)
                else
                  card = create_card(v.type, area, nil, nil, nil, nil, nil, 'sho')
                  create_shop_card_ui(card, v.type, area)
                end       
              else
                card = create_card(v.type, area, nil, nil, nil, nil, nil, 'sho')
                if G.GAME.used_vouchers.v_telescope and voucher_level >= 2 then
                  card:set_edition(poll_edition('conedi'))
                end
                create_shop_card_ui(card, v.type, area)
              end
              G.E_MANAGER:add_event(Event({
                  func = (function()
                      for k, v in ipairs(G.GAME.tags) do
                        if v:apply_to_run({type = 'store_joker_modify', card = card}) then break end
                      end
                      return true
                  end)
              }))
              if (v.type == 'Base' or v.type == 'Enhanced') and voucher_level == 1 and G.GAME.used_vouchers["v_illusion"] and pseudorandom(pseudoseed('illusion')) > 0.8 then 
                local edition_poll = pseudorandom(pseudoseed('illusion'))
                local edition = {}
                if edition_poll > 1 - 0.15 then edition.polychrome = true
                elseif edition_poll > 0.5 then edition.holo = true
                else edition.foil = true
                end
                card:set_edition(edition)
              end
              if (v.type == 'Base' or v.type == 'Enhanced') and voucher_level == 1 and G.GAME.used_vouchers["v_illusion"] and pseudorandom(pseudoseed('illusion')) > 0.6 then
                local seal = pseudorandom(pseudoseed('illusion')) -- Illusion bug fix
                if seal > 0.75 then card:set_seal('Red', true)
                elseif seal > 0.5 then card:set_seal('Blue', true)
                elseif seal > 0.25 then card:set_seal('Gold', true)
                else card:set_seal('Purple', true)
                end
              end
              return card
            end
            check_rate = check_rate + v.val
          end
      end
  end

G.FUNCS.reroll_shop = function(e) -- Level 2 Illusion
    stop_use()
    G.CONTROLLER.locks.shop_reroll = true
    if G.CONTROLLER:save_cardarea_focus('shop_jokers') then G.CONTROLLER.interrupt.focus = true end
    if G.GAME.current_round.reroll_cost > 0 then 
      inc_career_stat('c_shop_dollars_spent', G.GAME.current_round.reroll_cost)
      inc_career_stat('c_shop_rerolls', 1)
      ease_dollars(-G.GAME.current_round.reroll_cost)
    end
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
          local final_free = G.GAME.current_round.free_rerolls > 0
          G.GAME.current_round.free_rerolls = math.max(G.GAME.current_round.free_rerolls - 1, 0)
          G.GAME.round_scores.times_rerolled.amt = G.GAME.round_scores.times_rerolled.amt + 1

          calculate_reroll_cost(final_free)
          for i = #G.shop_jokers.cards,1, -1 do
            local c = G.shop_jokers:remove_card(G.shop_jokers.cards[i])
            c:remove()
            c = nil
          end

          play_sound('coin2')
          play_sound('other1')
          
          for i = 1, G.GAME.shop.joker_max - #G.shop_jokers.cards do
            local new_shop_card = create_card_for_shop(G.shop_jokers)
            G.shop_jokers:emplace(new_shop_card)
            new_shop_card:juice_up()
          end
          if G.GAME.used_vouchers["v_illusion"] and voucher_level >= 2 then -- Level 2 Illusion
            card2 = create_card('Base', area, nil, nil, nil, nil, nil, 'sho')
            local enhancement = pseudorandom(pseudoseed('illenh'))
            local edition = pseudorandom(pseudoseed('illedi'))
            local seal = pseudorandom(pseudoseed('illseal')) 
            if enhancement >= 364/377 then card2:set_ability(G.P_CENTERS.m_stone, nil, true)
            elseif enhancement >= (6*52)/377 then card2:set_ability(G.P_CENTERS.m_wild, nil, true)
            elseif enhancement >= (5*52)/377 then card2:set_ability(G.P_CENTERS.m_mult, nil, true)
            elseif enhancement >= (4*52)/377 then card2:set_ability(G.P_CENTERS.m_bonus, nil, true)
            elseif enhancement >= (3*52)/377 then card2:set_ability(G.P_CENTERS.m_gold, nil, true)
            elseif enhancement >= (2*52)/377 then card2:set_ability(G.P_CENTERS.m_glass, nil, true)
            elseif enhancement >= (1*52)/377 then card2:set_ability(G.P_CENTERS.m_steel, nil, true)
            elseif enhancement >= (0*52)/377 then card2:set_ability(G.P_CENTERS.m_lucky, nil, true)
            end
            if edition >= 0.93 then card2:set_edition({negative = true}, true) 
            elseif edition >= 0.62 then card2:set_edition({polychrome = true}, true)
            elseif edition >= 0.31 then card2:set_edition({holo = true}, true)
            elseif edition >= 0 then card2:set_edition({foil = true}, true)
            end
            if seal > 0.75 then card2:set_seal('Red', true)
            elseif seal > 0.5 then card2:set_seal('Blue', true)
            elseif seal > 0.25 then card2:set_seal('Gold', true)
            else card2:set_seal('Purple', true)
            end
            create_shop_card_ui(card2, 'Joker', G.shop_jokers)
            card2.states.visible = false
            card2.ability.couponed = true
            card2:start_materialize()
            G.shop_jokers:emplace(card2)
            card2:set_cost()
            G.shop_jokers.T.w = math.min(4, G.GAME.shop.joker_max+1)*1.01*G.CARD_W
            G.shop:recalculate()
          end
          return true
        end
      }))
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.3,
        func = function()
        G.E_MANAGER:add_event(Event({
          func = function()
            G.CONTROLLER.interrupt.focus = false
            G.CONTROLLER.locks.shop_reroll = false
            G.CONTROLLER:recall_cardarea_focus('shop_jokers')
            for i = 1, #G.jokers.cards do
              G.jokers.cards[i]:calculate_joker({reroll_shop = true})
            end
            return true
          end
        }))
        return true
      end
    }))
    G.E_MANAGER:add_event(Event({ func = function() save_run(); return true end}))
  end


-- Level 2 Ancient Joker card reset
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

-- Reroll cost is no longer static, increasing at $1 per reroll — it can be different.
function calculate_reroll_cost(skip_increment)
  if G.GAME.current_round.free_rerolls < 0 then G.GAME.current_round.free_rerolls = 0 end
  if G.GAME.current_round.free_rerolls > 0 then G.GAME.current_round.reroll_cost = 0; return end
  G.GAME.current_round.reroll_cost_increase = G.GAME.current_round.reroll_cost_increase or 0
  local costlento = 0
  if G.GAME.used_vouchers.v_reroll_surplus then costlento = costlento + 1 end
  if G.GAME.used_vouchers.v_reroll_glut then costlento = costlento + 1 end
  if not skip_increment then G.GAME.current_round.reroll_cost_increase = G.GAME.current_round.reroll_cost_increase + (blind_level_old / (voucher_level ^ costlento)) end
  G.GAME.current_round.reroll_cost = math.floor((G.GAME.round_resets.temp_reroll_cost or G.GAME.round_resets.reroll_cost) + G.GAME.current_round.reroll_cost_increase + (blind_level_old-1))
  if not G.GAME.round_resets.temp_reroll_cost and G.GAME.current_round.reroll_cost <= 0 then
    G.GAME.current_round.reroll_cost = 1
  end
  if G.GAME.shop and G.shop_jokers and G.shop_jokers.cards then
    G.shop_jokers.T.w = math.min(3.96, G.GAME.shop.joker_max)*1.01*G.CARD_W
    G.shop:recalculate()
  end
end

-- Coupon Tag fix
G.FUNCS.cash_out = function(e)
    stop_use()
      if G.round_eval then  
        e.config.button = nil
        G.round_eval.alignment.offset.y = G.ROOM.T.y + 15
        G.round_eval.alignment.offset.x = 0
        G.deck:shuffle('cashout'..G.GAME.round_resets.ante)
        G.deck:hard_set_T()
        delay(0.3)
        G.E_MANAGER:add_event(Event({
          trigger = 'immediate',
          func = function()
              if G.round_eval then 
                G.round_eval:remove()
                G.round_eval = nil
              end
              G.GAME.current_round.jokers_purchased = 0
              G.GAME.current_round.discards_left = math.max(0, G.GAME.round_resets.discards + G.GAME.round_bonus.discards)
              G.GAME.current_round.hands_left = (math.max(1, G.GAME.round_resets.hands + G.GAME.round_bonus.next_hands))
              G.STATE = G.STATES.SHOP
              if G.GAME.shop_free and (tag_level_old >= 2) then
                G.GAME.shop.joker_max = G.GAME.shop.joker_max - (tag_level_old-1)
              end
              tag_level_old = tag_level
              G.GAME.shop_free = nil
              G.GAME.shop_d6ed = nil
              G.STATE_COMPLETE = false
            return true
          end
        }))
        ease_dollars(G.GAME.current_round.dollars)
        G.E_MANAGER:add_event(Event({
          func = function()
              G.GAME.previous_round.dollars = G.GAME.dollars
            return true
          end
        }))
        play_sound("coin7")
        G.VIBRATION = G.VIBRATION + 1
      end
      ease_chips(0)
      if G.GAME.round_resets.blind_states.Boss == 'Defeated' then 
        G.GAME.round_resets.blind_ante = G.GAME.round_resets.ante
        G.GAME.round_resets.blind_tags.Small = get_next_tag_key()
        G.GAME.round_resets.blind_tags.Big = get_next_tag_key()
      end
      reset_blinds()
      delay(0.6)
end

-- Voucher upgrades
function upgrade_vouchers(old_level)
  local bonus_hands = 0
  local bonus_discards = 0
  local minus_ante = 0
  if G.GAME.used_vouchers.v_overstock_norm and old_level == 1 then
    G.E_MANAGER:add_event(Event({func = function()
      change_shop_size(1)
    return true end }))
  end

  if G.GAME.used_vouchers.v_overstock_plus and old_level == 1 then
    G.E_MANAGER:add_event(Event({func = function()
      change_shop_size(1)
    return true end }))
  end
  if G.GAME.used_vouchers.v_liquidation then
    G.E_MANAGER:add_event(Event({func = function()
      G.GAME.discount_percent = G.P_CENTERS.v_liquidation.config.extra
      for k, v in pairs(G.I.CARD) do
        if v.set_cost then v:set_cost() end
      end
    return true end }))
  elseif G.GAME.used_vouchers.v_clearance_sale then
    G.E_MANAGER:add_event(Event({func = function()
      G.GAME.discount_percent = G.P_CENTERS.v_clearance_sale.config.extra
      for k, v in pairs(G.I.CARD) do
        if v.set_cost then v:set_cost() end
      end
    return true end }))
  end
  if G.GAME.used_vouchers.v_glow_up then
    G.E_MANAGER:add_event(Event({func = function()
      G.GAME.edition_rate = G.P_CENTERS.v_glow_up.config.extra
    return true end }))
  elseif G.GAME.used_vouchers.v_glow_up then
    G.E_MANAGER:add_event(Event({func = function()
      G.GAME.edition_rate = G.P_CENTERS.v_hone.config.extra
    return true end }))
  end
  if G.GAME.used_vouchers.v_reroll_surplus then
    G.GAME.round_resets.reroll_cost = G.GAME.round_resets.reroll_cost - 1
    G.GAME.current_round.reroll_cost = G.GAME.current_round.reroll_cost - 1
  end
  if G.GAME.used_vouchers.v_reroll_glut then
    G.GAME.round_resets.reroll_cost = G.GAME.round_resets.reroll_cost - 1
    G.GAME.current_round.reroll_cost = G.GAME.current_round.reroll_cost - 1
  end
  if G.GAME.used_vouchers.v_crystal_ball then
    G.E_MANAGER:add_event(Event({func = function()
      G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1
    return true end }))
  end
  if G.GAME.used_vouchers.v_omen_globe and voucher_level >= 2 then
    G.GAME.spectral_rate = 28*math.max(12, voucher_level-1) / (15 - math.max(12, voucher_level-1))
  end
  if G.GAME.used_vouchers.v_observatory then
    G.P_CENTERS.v_observatory.config.extra = 1.5 + (voucher_level-1)*0.5
  end
  if G.GAME.used_vouchers.v_grabber and math.floor(old_level/2) ~= (old_level/2) then
    bonus_hands = bonus_hands + 1
  end
  if G.GAME.used_vouchers.v_nacho_tong and math.floor(old_level/2) ~= (old_level/2) then
    bonus_hands = bonus_hands + 1
  end
  if G.GAME.used_vouchers.v_wasteful and math.floor(old_level/2) ~= (old_level/2) then
    bonus_discards = bonus_discards + 1
  end  
  if G.GAME.used_vouchers.v_recyclomancy and math.floor(old_level/2) ~= (old_level/2) then
    bonus_discards = bonus_discards + 1 
  end
  if G.GAME.used_vouchers.v_tarot_tycoon then
    G.E_MANAGER:add_event(Event({func = function()
      G.GAME.tarot_rate = 24*math.max(6, (4 + (voucher_level-1)*0.5)) / (7 - math.max(6, (4 + (voucher_level-1)*0.5)))
    return true end }))
  elseif G.GAME.used_vouchers.v_tarot_merchant then
    G.E_MANAGER:add_event(Event({func = function()
      G.GAME.tarot_rate = 24*math.max(3, (2 + (voucher_level-1)*0.25)) / (7 - math.max(3, (2 + (voucher_level-1)*0.25)))
    return true end }))
  end
  if G.GAME.used_vouchers.v_planet_tycoon then
    G.E_MANAGER:add_event(Event({func = function()
      G.GAME.planet_rate = 24*math.max(6, (4 + (voucher_level-1)*0.5)) / (7 - math.max(6, (4 + (voucher_level-1)*0.5)))
    return true end }))
  elseif G.GAME.used_vouchers.v_planet_merchant then
    G.E_MANAGER:add_event(Event({func = function()
      G.GAME.planet_rate = 24*math.max(3, (2 + (voucher_level-1)*0.25)) / (7 - math.max(3, (2 + (voucher_level-1)*0.25)))
    return true end }))
  end
  if G.GAME.used_vouchers.v_money_tree then
    G.E_MANAGER:add_event(Event({func = function()
      G.GAME.interest_cap = 100 + (voucher_level-1)*30
    return true end }))
  elseif G.GAME.used_vouchers.v_seed_money then
    G.E_MANAGER:add_event(Event({func = function()
      G.GAME.interest_cap = 50 + (voucher_level-1)*15
    return true end }))
  end
  if G.GAME.used_vouchers.v_antimatter then
    G.E_MANAGER:add_event(Event({func = function()
      if G.jokers then 
        G.jokers.config.card_limit = G.jokers.config.card_limit + 1
      end
    return true end }))
  end
  if G.GAME.used_vouchers.v_illusion then
    G.E_MANAGER:add_event(Event({func = function()
      G.GAME.playing_card_rate = 0
    return true end }))
    if old_level == 1 then
      card2 = create_card('Base', area, nil, nil, nil, nil, nil, 'sho')
      local enhancement = pseudorandom(pseudoseed('illenh'))
      local edition = pseudorandom(pseudoseed('illedi'))
      local seal = pseudorandom(pseudoseed('illseal')) 
      if enhancement >= 364/377 then card2:set_ability(G.P_CENTERS.m_stone, nil, true)
      elseif enhancement >= (6*52)/377 then card2:set_ability(G.P_CENTERS.m_wild, nil, true)
      elseif enhancement >= (5*52)/377 then card2:set_ability(G.P_CENTERS.m_mult, nil, true)
      elseif enhancement >= (4*52)/377 then card2:set_ability(G.P_CENTERS.m_bonus, nil, true)
      elseif enhancement >= (3*52)/377 then card2:set_ability(G.P_CENTERS.m_gold, nil, true)
      elseif enhancement >= (2*52)/377 then card2:set_ability(G.P_CENTERS.m_glass, nil, true)
      elseif enhancement >= (1*52)/377 then card2:set_ability(G.P_CENTERS.m_steel, nil, true)
      elseif enhancement >= (0*52)/377 then card2:set_ability(G.P_CENTERS.m_lucky, nil, true)
      end
      if edition >= 0.93 then card2:set_edition({negative = true}, true) 
      elseif edition >= 0.62 then card2:set_edition({polychrome = true}, true)
      elseif edition >= 0.31 then card2:set_edition({holo = true}, true)
      elseif edition >= 0 then card2:set_edition({foil = true}, true)
      end
      if seal > 0.75 then card2:set_seal('Red', true)
      elseif seal > 0.5 then card2:set_seal('Blue', true)
      elseif seal > 0.25 then card2:set_seal('Gold', true)
      else card2:set_seal('Purple', true)
      end
      create_shop_card_ui(card2, 'Joker', G.shop_jokers)
      card2.states.visible = false
      card2.ability.couponed = true
      card2:start_materialize()
      G.shop_jokers:emplace(card2)
      card2:set_cost()
      G.shop_jokers.T.w = math.min(4, G.GAME.shop.joker_max+1)*1.01*G.CARD_W
      G.shop:recalculate()
    end
  elseif G.GAME.used_vouchers.v_magic_trick then
    G.E_MANAGER:add_event(Event({func = function()
      G.GAME.playing_card_rate = 28*math.max(4, (1 + (voucher_level-1)*0.5)) / (8 - math.max(4, (1 + (voucher_level-1)*0.5)))
    return true end }))
  end
  if G.GAME.used_vouchers.v_hieroglyph then
    if old_level == 1 then
      bonus_hands = bonus_hands + 1
    else
      minus_ante = minus_ante + 1
    end
  end
  if G.GAME.used_vouchers.v_petroglyph then
    if old_level == 1 then
      bonus_discards = bonus_discards + 1
    else
      minus_ante = minus_ante + 1
    end
  end
  if G.GAME.used_vouchers.v_paint_brush and math.floor(old_level/2) ~= (old_level/2) then
    G.hand:change_size(1)
  end
  if G.GAME.used_vouchers.v_palette and math.floor(old_level/2) ~= (old_level/2) then
    G.hand:change_size(1)
  end

  if bonus_hands >= 1 then
    G.GAME.round_resets.hands = G.GAME.round_resets.hands + bonus_hands
    ease_hands_played(bonus_hands)
  end
  if bonus_discards >= 1 then
    G.GAME.round_resets.discards = G.GAME.round_resets.discards + bonus_discards
    ease_discard(bonus_discards)
  end
  if minus_ante >= 1 then
    G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
    G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante - minus_ante
    ease_ante(-minus_ante)
  end
end

-- Higher levels of Retcon
G.FUNCS.reroll_boss_button = function(e)
    local boss_reroll_cost = 10
    if not G.GAME.round_resets.boss_rerolled then G.GAME.round_resets.boss_rerolled = 0 end
    if G.GAME.used_vouchers["v_retcon"] then
      boss_reroll_cost = math.max(0, 10 - (voucher_level-1)*2)
    end
    if ((G.GAME.dollars-G.GAME.bankrupt_at) - boss_reroll_cost >= 0) and
      (G.GAME.used_vouchers["v_retcon"] or
      (G.GAME.used_vouchers["v_directors_cut"] and G.GAME.round_resets.boss_rerolled < voucher_level)) then 
        e.config.colour = G.C.RED
        e.config.button = 'reroll_boss'
        e.children[1].children[1].config.shadow = true
        if e.children[2] then e.children[2].children[1].config.shadow = true end 
    else
      e.config.colour = G.C.UI.BACKGROUND_INACTIVE
      e.config.button = nil
      e.children[1].children[1].config.shadow = false
      if e.children[2] then e.children[2].children[1].config.shadow = false end 
    end
  end

  G.FUNCS.reroll_boss = function(e) 
    stop_use()
    local boss_reroll_cost = 10
    if not G.GAME.round_resets.boss_rerolled then G.GAME.round_resets.boss_rerolled = 0 end
    if G.GAME.used_vouchers["v_retcon"] then
      boss_reroll_cost = math.max(0, 10 - (voucher_level-1)*2)
    end
    G.GAME.round_resets.boss_rerolled = G.GAME.round_resets.boss_rerolled + 1
    if not G.from_boss_tag then ease_dollars(-boss_reroll_cost) end
    G.from_boss_tag = nil
    G.CONTROLLER.locks.boss_reroll = true
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
          play_sound('other1')
          G.blind_select_opts.boss:set_role({xy_bond = 'Weak'})
          G.blind_select_opts.boss.alignment.offset.y = 20
          return true
        end
      }))
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.3,
      func = (function()
        local par = G.blind_select_opts.boss.parent
        G.GAME.round_resets.blind_choices.Boss = get_new_boss()

        G.blind_select_opts.boss:remove()
        G.blind_select_opts.boss = UIBox{
          T = {par.T.x, 0, 0, 0, },
          definition =
            {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes={
              UIBox_dyn_container({create_UIBox_blind_choice('Boss')},false,get_blind_main_colour('Boss'), mix_colours(G.C.BLACK, get_blind_main_colour('Boss'), 0.8))
            }},
          config = {align="bmi",
                    offset = {x=0,y=G.ROOM.T.y + 9},
                    major = par,
                    xy_bond = 'Weak'
                  }
        }
        par.config.object = G.blind_select_opts.boss
        par.config.object:recalculate()
        G.blind_select_opts.boss.parent = par
        G.blind_select_opts.boss.alignment.offset.y = 0
        
        G.E_MANAGER:add_event(Event({blocking = false, trigger = 'after', delay = 0.5,func = function()
            G.CONTROLLER.locks.boss_reroll = nil
            return true
          end
        }))

        save_run()
        for i = 1, #G.GAME.tags do
          if G.GAME.tags[i]:apply_to_run({type = 'new_blind_choice'}) then break end
        end
          return true
      end)
    }))
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
      "at level {C:attention}2{}",
      "{s:0.8}Shop items cost {s:0.8,C:money}$1{}{s:0.8} more",
      "{s:0.8}Rerolls start at {s:0.8,C:money}$6{}{s:0.8} and",
      "{s:0.8}ramp up by {s:0.8,C:money}$2{}{s:0.8} per reroll",
      "{s:0.8}Higher ante scaling"
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
      "at level {C:attention}3{}",
      "{s:0.8}Shop items cost {s:0.8,C:money}$2{}{s:0.8} more",
      "{s:0.8}Rerolls start at {s:0.8,C:money}$7{}{s:0.8} and",
      "{s:0.8}ramp up by {s:0.8,C:money}$3{}{s:0.8} per reroll",
      "{s:0.8}Higher ante scaling"
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
      "at level {C:attention}4{}",
      "{s:0.8}Shop items cost {s:0.8,C:money}$3{}{s:0.8} more",
      "{s:0.8}Rerolls start at {s:0.8,C:money}$8{}{s:0.8} and",
      "{s:0.8}ramp up by {s:0.8,C:money}$4{}{s:0.8} per reroll",
      "{s:0.8}Higher ante scaling"
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
      luchador = luchadors_sold,
      tag_old = tag_level_old,
      tag_new = tag_level_new
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
    local enhancement_calculated = false
    local center = card.config.center
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

    if not enhancement_calculated and center.set == 'Enhanced' and center.calculate and type(center.calculate) == 'function' then 
        center:calculate(context, ret)
        enhancement_calculated = true
    end
    local seals = card:calculate_seal(context)
    if seals then
        ret.seals = seals
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
-- inside a for loop. Because of this, I am doing a massive overwrite.

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
                        if effects[ii].edition and effects[ii].edition.negative then
                          print("negative")
                        elseif effects[ii].edition then
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
                        if effects[ii].edition and effects[ii].edition.negative then
                          print("negative")
                        elseif effects[ii].edition then
                            hand_chips =

 mod_chips(hand_chips + (effects[ii].edition.chip_mod or 0))
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
                      if effects2[ji].edition and effects2[ji].edition.negative then
                        print("negative")
                      elseif effects2[ji].edition and next(find_joker('Splash')) and (effect_level >= 2) then
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

                        print("hand size: "..G.hand.config.card_limit)
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


-- UI CHANGES

-- Level 2 Strength in booster packs
function G.UIDEF.use_and_sell_buttons(card)
  local sell = nil
  local use = nil
  if card.area and card.area.config.type == 'joker' then
    sell = {n=G.UIT.C, config={align = "cr"}, nodes={
      {n=G.UIT.C, config={ref_table = card, align = "cr",padding = 0.1, r=0.08, minw = 1.25, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'sell_card', func = 'can_sell_card'}, nodes={
        {n=G.UIT.B, config = {w=0.1,h=0.6}},
        {n=G.UIT.C, config={align = "tm"}, nodes={
          {n=G.UIT.R, config={align = "cm", maxw = 1.25}, nodes={
            {n=G.UIT.T, config={text = localize('b_sell'),colour = G.C.UI.TEXT_LIGHT, scale = 0.4, shadow = true}}
          }},
          {n=G.UIT.R, config={align = "cm"}, nodes={
            {n=G.UIT.T, config={text = localize('$'),colour = G.C.WHITE, scale = 0.4, shadow = true}},
            {n=G.UIT.T, config={ref_table = card, ref_value = 'sell_cost_label',colour = G.C.WHITE, scale = 0.55, shadow = true}}
          }}
        }}
      }},
    }}
  end
  if card.ability.consumeable then
    if (card.area == G.pack_cards and G.pack_cards) then
      if card.ability.name == "Strength" and effect_level >= 2 then
        local minus = {n=G.UIT.R, config={ref_table = card, r = 0.08, padding = 0.1, align = "bm", minw = 0.4*card.T.w - 0.15, minh = 0.6*card.T.h, maxw = 0.6*card.T.w - 0.15, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'sell_card', func = 'can_sell_card'}, nodes={
              {n=G.UIT.T, config={text = localize('b_minus'),colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true}}
            }}
        local plus = {n=G.UIT.R, config={ref_table = card, r = 0.08, padding = 0.1, align = "bm", minw = 0.4*card.T.w - 0.15, minh = 0.6*card.T.h, maxw = 0.6*card.T.w - 0.15, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'use_card', func = 'can_use_consumeable'}, nodes={
              {n=G.UIT.T, config={text = localize('b_plus'),colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true}}
            }}
        return {
          n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
          {n=G.UIT.R, config={padding = 0.05, align = 'cl'}, nodes={
            {n=G.UIT.C, config={align = 'cl'}, nodes={
              minus
            }},
            {n=G.UIT.C, config={align = 'cl'}, nodes={
              plus
            }}
          }}
        }}
      else
        return {
          n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
            {n=G.UIT.R, config={mid = true}, nodes={
            }},
            {n=G.UIT.R, config={ref_table = card, r = 0.08, padding = 0.1, align = "bm", minw = 0.5*card.T.w - 0.15, minh = 0.8*card.T.h, maxw = 0.7*card.T.w - 0.15, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'use_card', func = 'can_use_consumeable'}, nodes={
              {n=G.UIT.T, config={text = localize('b_use'),colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true}}
            }},
        }}
      end
    end
    use = 
    {n=G.UIT.C, config={align = "cr"}, nodes={
      
      {n=G.UIT.C, config={ref_table = card, align = "cr",maxw = 1.25, padding = 0.1, r=0.08, minw = 1.25, minh = (card.area and card.area.config.type == 'joker') and 0 or 1, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'use_card', func = 'can_use_consumeable'}, nodes={
        {n=G.UIT.B, config = {w=0.1,h=0.6}},
        {n=G.UIT.T, config={text = localize('b_use'),colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true}}
      }}
    }}
  elseif card.area and card.area == G.pack_cards then
    return {
      n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
        {n=G.UIT.R, config={ref_table = card, r = 0.08, padding = 0.1, align = "bm", minw = 0.5*card.T.w - 0.15, maxw = 0.9*card.T.w - 0.15, minh = 0.3*card.T.h, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'use_card', func = 'can_select_card'}, nodes={
          {n=G.UIT.T, config={text = localize('b_select'),colour = G.C.UI.TEXT_LIGHT, scale = 0.45, shadow = true}}
        }},
    }}
  end
    local t = {
      n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
        {n=G.UIT.C, config={padding = 0.15, align = 'cl'}, nodes={
          {n=G.UIT.R, config={align = 'cl'}, nodes={
            sell
          }},
          {n=G.UIT.R, config={align = 'cl'}, nodes={
            use
          }},
        }},
    }}
  return t
end

-- Shop UI change for Level 2+ Overstock
function G.UIDEF.shop()
    G.shop_jokers = CardArea(
      G.hand.T.x+0,
      G.hand.T.y+G.ROOM.T.y + 9,
      math.min(3.96, G.GAME.shop.joker_max)*1.01*G.CARD_W,
      1.05*G.CARD_H, 
      {card_limit = G.GAME.shop.joker_max, type = 'shop', highlight_limit = 1})

    G.shop_vouchers = CardArea(
      G.hand.T.x+0,
      G.hand.T.y+G.ROOM.T.y + 9,
      2.1*G.CARD_W,
      1.05*G.CARD_H, 
      {card_limit = 1, type = 'shop', highlight_limit = 1})

    G.shop_booster = CardArea(
      G.hand.T.x+0,
      G.hand.T.y+G.ROOM.T.y + 9,
      2.4*G.CARD_W,
      1.15*G.CARD_H, 
      {card_limit = 2, type = 'shop', highlight_limit = 1, card_w = 1.27*G.CARD_W})

    local shop_sign = AnimatedSprite(0,0, 4.4, 2.2, G.ANIMATION_ATLAS['shop_sign'])
    shop_sign:define_draw_steps({
      {shader = 'dissolve', shadow_height = 0.05},
      {shader = 'dissolve'}
    })
    G.SHOP_SIGN = UIBox{
      definition = 
        {n=G.UIT.ROOT, config = {colour = G.C.DYN_UI.MAIN, emboss = 0.05, align = 'cm', r = 0.1, padding = 0.1}, nodes={
          {n=G.UIT.R, config={align = "cm", padding = 0.1, minw = 4.72, minh = 3.1, colour = G.C.DYN_UI.DARK, r = 0.1}, nodes={
            {n=G.UIT.R, config={align = "cm"}, nodes={
              {n=G.UIT.O, config={object = shop_sign}}
            }},
            {n=G.UIT.R, config={align = "cm"}, nodes={
              {n=G.UIT.O, config={object = DynaText({string = {localize('ph_improve_run')}, colours = {lighten(G.C.GOLD, 0.3)},shadow = true, rotate = true, float = true, bump = true, scale = 0.5, spacing = 1, pop_in = 1.5, maxw = 4.3})}}
            }},
          }},
        }},
      config = {
        align="cm",
        offset = {x=0,y=-15},
        major = G.HUD:get_UIE_by_ID('row_blind'),
        bond = 'Weak'
      }
    }
    G.E_MANAGER:add_event(Event({
      trigger = 'immediate',
      func = (function()
          G.SHOP_SIGN.alignment.offset.y = 0
          return true
      end)
    }))
    local t = {n=G.UIT.ROOT, config = {align = 'cl', colour = G.C.CLEAR}, nodes={
            UIBox_dyn_container({
                {n=G.UIT.C, config={align = "cm", padding = 0.1, emboss = 0.05, r = 0.1, colour = G.C.DYN_UI.BOSS_MAIN}, nodes={
                    {n=G.UIT.R, config={align = "cm", padding = 0.05}, nodes={
                      {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
                        {n=G.UIT.R,config={id = 'next_round_button', align = "cm", minw = 2.8, minh = 1.5, r=0.15,colour = G.C.RED, one_press = true, button = 'toggle_shop', hover = true,shadow = true}, nodes = {
                          {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'y', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
                            {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                              {n=G.UIT.T, config={text = localize('b_next_round_1'), scale = 0.4, colour = G.C.WHITE, shadow = true}}
                            }},
                            {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                              {n=G.UIT.T, config={text = localize('b_next_round_2'), scale = 0.4, colour = G.C.WHITE, shadow = true}}
                            }}   
                          }},              
                        }},
                        {n=G.UIT.R, config={align = "cm", minw = 2.8, minh = 1.6, r=0.15,colour = G.C.GREEN, button = 'reroll_shop', func = 'can_reroll', hover = true,shadow = true}, nodes = {
                          {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'x', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
                            {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                              {n=G.UIT.T, config={text = localize('k_reroll'), scale = 0.4, colour = G.C.WHITE, shadow = true}},
                            }},
                            {n=G.UIT.R, config={align = "cm", maxw = 1.3, minw = 1}, nodes={
                              {n=G.UIT.T, config={text = localize('$'), scale = 0.7, colour = G.C.WHITE, shadow = true}},
                              {n=G.UIT.T, config={ref_table = G.GAME.current_round, ref_value = 'reroll_cost', scale = 0.75, colour = G.C.WHITE, shadow = true}},
                            }}
                          }}
                        }},
                      }},
                      {n=G.UIT.C, config={align = "cm", padding = 0.2, r=0.2, colour = G.C.L_BLACK, emboss = 0.05, minw = 8.2}, nodes={
                          {n=G.UIT.O, config={object = G.shop_jokers}},
                      }},
                    }},
                    {n=G.UIT.R, config={align = "cm", minh = 0.2}, nodes={}},
                    {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
                      {n=G.UIT.C, config={align = "cm", padding = 0.15, r=0.2, colour = G.C.L_BLACK, emboss = 0.05}, nodes={
                        {n=G.UIT.C, config={align = "cm", padding = 0.2, r=0.2, colour = G.C.BLACK, maxh = G.shop_vouchers.T.h+0.4}, nodes={
                          {n=G.UIT.T, config={text = localize{type = 'variable', key = 'ante_x_voucher', vars = {G.GAME.round_resets.ante}}, scale = 0.45, colour = G.C.L_BLACK, vert = true}},
                          {n=G.UIT.O, config={object = G.shop_vouchers}},
                        }},
                      }},
                      {n=G.UIT.C, config={align = "cm", padding = 0.15, r=0.2, colour = G.C.L_BLACK, emboss = 0.05}, nodes={
                        {n=G.UIT.O, config={object = G.shop_booster}},
                      }},
                    }}
                }
              },
              
              }, false)
        }}
    return t
end

function change_shop_size(mod)
    if not G.GAME.shop then return end
    G.GAME.shop.joker_max = G.GAME.shop.joker_max + mod
    if G.shop_jokers and G.shop_jokers.cards then
        if mod < 0 then
            --Remove jokers in shop
            for i = #G.shop_jokers.cards, G.GAME.shop.joker_max+1, -1 do
                if G.shop_jokers.cards[i] then
                    G.shop_jokers.cards[i]:remove()
                end
            end
        end
        G.shop_jokers.config.card_limit = G.GAME.shop.joker_max
        G.shop_jokers.T.w = math.min(3.96, G.GAME.shop.joker_max)*1.01*G.CARD_W
        G.shop:recalculate()
        if mod > 0 then
            for i = 1, G.GAME.shop.joker_max - #G.shop_jokers.cards do
                G.shop_jokers:emplace(create_card_for_shop(G.shop_jokers))
            end
        end
    end
end

-- Booster packs
function create_UIBox_arcana_pack()
  local _size = G.GAME.pack_size
  G.pack_cards = CardArea(
    G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y,
    math.min(5.5, _size)*G.CARD_W,
    1.05*G.CARD_H, 
    {card_limit = _size, type = 'consumeable', highlight_limit = 1})

    local t = {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
      {n=G.UIT.R, config={align = "cl", colour = G.C.CLEAR,r=0.15, padding = 0.1, minh = 2, shadow = true}, nodes={
        {n=G.UIT.R, config={align = "cm"}, nodes={
        {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
          {n=G.UIT.C, config={align = "cm", r=0.2, colour = G.C.CLEAR, shadow = true}, nodes={
            {n=G.UIT.O, config={object = G.pack_cards}},
          }}
        }}
      }},
      {n=G.UIT.R, config={align = "cm"}, nodes={
      }},
      {n=G.UIT.R, config={align = "tm"}, nodes={
        {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={}},
        {n=G.UIT.C,config={align = "tm", padding = 0.05}, nodes={
        UIBox_dyn_container({
          {n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 4}, nodes={
            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
              {n=G.UIT.O, config={object = DynaText({string = localize('k_arcana_pack'), colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}
            }},
            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
              {n=G.UIT.O, config={object = DynaText({string = {localize('k_choose')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}},
              {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'pack_choices'}}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}}
            }},
          }}
        }),
      }},
        {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={
          {n=G.UIT.R,config={minh =0.2}, nodes={}},
          {n=G.UIT.R,config={align = "tm",padding = 0.2, minh = 1.2, minw = 1.8, r=0.15,colour = G.C.GREY, one_press = true, button = 'skip_booster', hover = true,shadow = true, func = 'can_skip_booster'}, nodes = {
            {n=G.UIT.T, config={text = localize('b_skip'), scale = 0.5, colour = G.C.WHITE, shadow = true, focus_args = {button = 'y', orientation = 'bm'}, func = 'set_button_pip'}}
          }}
        }}
      }}
    }}
  }}
  return t
end

function create_UIBox_spectral_pack()
  local _size = G.GAME.pack_size
  G.pack_cards = CardArea(
    G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y,
    math.min(5.5, _size)*G.CARD_W,
    1.05*G.CARD_H, 
    {card_limit = _size, type = 'consumeable', highlight_limit = 1})

    local t = {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
      {n=G.UIT.R, config={align = "cl", colour = G.C.CLEAR,r=0.15, padding = 0.1, minh = 2, shadow = true}, nodes={
        {n=G.UIT.R, config={align = "cm"}, nodes={
        {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
          {n=G.UIT.C, config={align = "cm", r=0.2, colour = G.C.CLEAR, shadow = true}, nodes={
            {n=G.UIT.O, config={object = G.pack_cards}},
          }}
        }}
      }},
      {n=G.UIT.R, config={align = "cm"}, nodes={
      }},
      {n=G.UIT.R, config={align = "tm"}, nodes={
        {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={}},
        {n=G.UIT.C,config={align = "tm", padding = 0.05}, nodes={
        UIBox_dyn_container({
          {n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 4}, nodes={
            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
              {n=G.UIT.O, config={object = DynaText({string = localize('k_spectral_pack'), colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}
            }},
            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
              {n=G.UIT.O, config={object = DynaText({string = {localize('k_choose')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}},
              {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'pack_choices'}}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}}
            }},
          }}
        }),
      }},
        {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={
          {n=G.UIT.R,config={minh =0.2}, nodes={}},
          {n=G.UIT.R,config={align = "tm",padding = 0.2, minh = 1.2, minw = 1.8, r=0.15,colour = G.C.GREY, one_press = true, button = 'skip_booster', hover = true,shadow = true, func = 'can_skip_booster'}, nodes = {
            {n=G.UIT.T, config={text = localize('b_skip'), scale = 0.5, colour = G.C.WHITE, shadow = true, focus_args = {button = 'y', orientation = 'bm'}, func = 'set_button_pip'}}
          }}
        }}
      }}
    }}
  }}
  return t
end

function create_UIBox_standard_pack()
  local _size = G.GAME.pack_size
  G.pack_cards = CardArea(
    G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y,
    math.min(5.5, _size)*G.CARD_W*1.1,
    1.05*G.CARD_H, 
    {card_limit = _size, type = 'consumeable', highlight_limit = 1})

    local t = {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
      {n=G.UIT.R, config={align = "cl", colour = G.C.CLEAR,r=0.15, padding = 0.1, minh = 2, shadow = true}, nodes={
        {n=G.UIT.R, config={align = "cm"}, nodes={
        {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
          {n=G.UIT.C, config={align = "cm", r=0.2, colour = G.C.CLEAR, shadow = true}, nodes={
            {n=G.UIT.O, config={object = G.pack_cards}},
          }}
        }}
      }},
      {n=G.UIT.R, config={align = "cm"}, nodes={
      }},
      {n=G.UIT.R, config={align = "tm"}, nodes={
        {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={}},
        {n=G.UIT.C,config={align = "tm", padding = 0.05}, nodes={
        UIBox_dyn_container({
          {n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 4}, nodes={
            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
              {n=G.UIT.O, config={object = DynaText({string = localize('k_standard_pack'), colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}
            }},
            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
              {n=G.UIT.O, config={object = DynaText({string = {localize('k_choose')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}},
              {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'pack_choices'}}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}}
            }},
          }}
        }),
      }},
        {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={
          {n=G.UIT.R,config={minh =0.2}, nodes={}},
          {n=G.UIT.R,config={align = "tm",padding = 0.2, minh = 1.2, minw = 1.8, r=0.15,colour = G.C.GREY, one_press = true, button = 'skip_booster', hover = true,shadow = true, func = 'can_skip_booster'}, nodes = {
            {n=G.UIT.T, config={text = localize('b_skip'), scale = 0.5, colour = G.C.WHITE, shadow = true, focus_args = {button = 'y', orientation = 'bm'}, func = 'set_button_pip'}}
          }}
        }}
      }}
    }}
  }}
  return t
end

function create_UIBox_buffoon_pack()
  local _size = G.GAME.pack_size
  G.pack_cards = CardArea(
    G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y,
    math.min(5.5, _size)*G.CARD_W*1.1,
    1.05*G.CARD_H, 
    {card_limit = _size, type = 'consumeable', highlight_limit = 1})

    local t = {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
      {n=G.UIT.R, config={align = "cl", colour = G.C.CLEAR,r=0.15, padding = 0.1, minh = 2, shadow = true}, nodes={
        {n=G.UIT.R, config={align = "cm"}, nodes={
        {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
          {n=G.UIT.C, config={align = "cm", r=0.2, colour = G.C.CLEAR, shadow = true}, nodes={
            {n=G.UIT.O, config={object = G.pack_cards}},
          }}
        }}
      }},
      {n=G.UIT.R, config={align = "cm"}, nodes={
      }},
      {n=G.UIT.R, config={align = "tm"}, nodes={
        {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={}},
        {n=G.UIT.C,config={align = "tm", padding = 0.05}, nodes={
        UIBox_dyn_container({
          {n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 4}, nodes={
            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
              {n=G.UIT.O, config={object = DynaText({string = localize('k_buffoon_pack'), colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}
            }},
            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
              {n=G.UIT.O, config={object = DynaText({string = {localize('k_choose')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}},
              {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'pack_choices'}}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}}
            }},
          }}
        }),
      }},
        {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={
          {n=G.UIT.R,config={minh =0.2}, nodes={}},
          {n=G.UIT.R,config={align = "tm",padding = 0.2, minh = 1.2, minw = 1.8, r=0.15,colour = G.C.GREY, one_press = true, button = 'skip_booster', hover = true,shadow = true, func = 'can_skip_booster'}, nodes = {
            {n=G.UIT.T, config={text = localize('b_skip'), scale = 0.5, colour = G.C.WHITE, shadow = true, focus_args = {button = 'y', orientation = 'bm'}, func = 'set_button_pip'}}
          }}
        }}
      }}
    }}
  }}
  return t
end

function create_UIBox_celestial_pack()
  local _size = G.GAME.pack_size
  G.pack_cards = CardArea(
    G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y,
    math.min(5.5, _size)*G.CARD_W*1.1 + 0.5,
    1.05*G.CARD_H, 
    {card_limit = _size, type = 'consumeable', highlight_limit = 1})

    local t = {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
      {n=G.UIT.R, config={align = "cl", colour = G.C.CLEAR,r=0.15, padding = 0.1, minh = 2, shadow = true}, nodes={
        {n=G.UIT.R, config={align = "cm"}, nodes={
        {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
          {n=G.UIT.C, config={align = "cm", r=0.2, colour = G.C.CLEAR, shadow = true}, nodes={
            {n=G.UIT.O, config={object = G.pack_cards}},
          }}
        }}
      }},
      {n=G.UIT.R, config={align = "cm"}, nodes={
      }},
      {n=G.UIT.R, config={align = "tm"}, nodes={
        {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={}},
        {n=G.UIT.C,config={align = "tm", padding = 0.05}, nodes={
        UIBox_dyn_container({
          {n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 4}, nodes={
            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
              {n=G.UIT.O, config={object = DynaText({string = localize('k_celestial_pack'), colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}
            }},
            {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
              {n=G.UIT.O, config={object = DynaText({string = {localize('k_choose')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}},
              {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'pack_choices'}}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}}
            }},
          }}
        }),
      }},
        {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={
          {n=G.UIT.R,config={minh =0.2}, nodes={}},
          {n=G.UIT.R,config={align = "tm",padding = 0.2, minh = 1.2, minw = 1.8, r=0.15,colour = G.C.GREY, one_press = true, button = 'skip_booster', hover = true,shadow = true, func = 'can_skip_booster'}, nodes = {
            {n=G.UIT.T, config={text = localize('b_skip'), scale = 0.5, colour = G.C.WHITE, shadow = true, focus_args = {button = 'y', orientation = 'bm'}, func = 'set_button_pip'}}
          }}
        }}
      }}
    }}
  }}
  return t
end

-- View Run tab: extra slot for upgrades
function G.UIDEF.run_info()
  return create_UIBox_generic_options({contents ={create_tabs(
    {tabs = {
          {
            label = localize('b_poker_hands'),
            chosen = true,
            tab_definition_function = create_UIBox_current_hands,
        },
        {
          label = localize('b_blinds'),
          tab_definition_function = G.UIDEF.current_blinds,
        },
        {
            label = localize('b_vouchers'),
            tab_definition_function = G.UIDEF.used_vouchers,
        },
        {
            label = localize('b_upgrades'),
            tab_definition_function = G.UIDEF.upgrades,
        },
        G.GAME.stake > 1 and {
          label = localize('b_stake'),
          tab_definition_function = G.UIDEF.current_stake,
        } or nil,
    },
    tab_h = 8,
    snap_to_nav = true})}})
end

function G.UIDEF.upgrades()
  local mult = DynaText({string = {{string = localize('u_mult'), colour = G.C.UI.TEXT_LIGHT}}, colours = {G.C.WHITE}, scale = 0.5, silent = true, pop_delay = 4.5, shadow = true, bump = true, maxw = 10})
  local xmult = DynaText({string = {{string = localize('u_xmult'), colour = G.C.UI.TEXT_LIGHT}}, colours = {G.C.WHITE}, scale = 0.5, silent = true, pop_delay = 4.5, shadow = true, bump = true, maxw = 10})
  local chips = DynaText({string = {{string = localize('u_chips'), colour = G.C.UI.TEXT_LIGHT}}, colours = {G.C.WHITE}, scale = 0.5, silent = true, pop_delay = 4.5, shadow = true, bump = true, maxw = 10})
  local econ = DynaText({string = {{string = localize('u_econ'), colour = G.C.UI.TEXT_LIGHT}}, colours = {G.C.WHITE}, scale = 0.5, silent = true, pop_delay = 4.5, shadow = true, bump = true, maxw = 10})
  local effect = DynaText({string = {{string = localize('u_effect'), colour = G.C.UI.TEXT_LIGHT}}, colours = {G.C.WHITE}, scale = 0.5, silent = true, pop_delay = 4.5, shadow = true, bump = true, maxw = 10})
  local tarot = DynaText({string = {{string = localize('u_tarot'), colour = G.C.UI.TEXT_LIGHT}}, colours = {G.C.WHITE}, scale = 0.5, silent = true, pop_delay = 4.5, shadow = true, bump = true, maxw = 10})
  local planet = DynaText({string = {{string = localize('u_planet'), colour = G.C.UI.TEXT_LIGHT}}, colours = {G.C.WHITE}, scale = 0.5, silent = true, pop_delay = 4.5, shadow = true, bump = true, maxw = 10})
  local spectral = DynaText({string = {{string = localize('u_spectral'), colour = G.C.UI.TEXT_LIGHT}}, colours = {G.C.WHITE}, scale = 0.5, silent = true, pop_delay = 4.5, shadow = true, bump = true, maxw = 10})
  local enhance = DynaText({string = {{string = localize('u_enhance'), colour = G.C.UI.TEXT_LIGHT}}, colours = {G.C.WHITE}, scale = 0.5, silent = true, pop_delay = 4.5, shadow = true, bump = true, maxw = 10})
  local edition = DynaText({string = {{string = localize('u_edition'), colour = G.C.UI.TEXT_LIGHT}}, colours = {G.C.WHITE}, scale = 0.5, silent = true, pop_delay = 4.5, shadow = true, bump = true, maxw = 10})
  local pack = DynaText({string = {{string = localize('u_pack'), colour = G.C.UI.TEXT_LIGHT}}, colours = {G.C.WHITE}, scale = 0.5, silent = true, pop_delay = 4.5, shadow = true, bump = true, maxw = 10})
  local tag = DynaText({string = {{string = localize('u_tag'), colour = G.C.UI.TEXT_LIGHT}}, colours = {G.C.WHITE}, scale = 0.5, silent = true, pop_delay = 4.5, shadow = true, bump = true, maxw = 10})
  local voucher = DynaText({string = {{string = localize('u_voucher'), colour = G.C.UI.TEXT_LIGHT}}, colours = {G.C.WHITE}, scale = 0.5, silent = true, pop_delay = 4.5, shadow = true, bump = true, maxw = 10})
  local blind = DynaText({string = {{string = localize('u_blind'), colour = G.C.UI.TEXT_LIGHT}}, colours = {G.C.WHITE}, scale = 0.5, silent = true, pop_delay = 4.5, shadow = true, bump = true, maxw = 10})
  return {n=G.UIT.ROOT, config={align = "cm", colour = G.C.BLACK, r = 0.1, padding = 0.1}, nodes={
   {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={ 
    {n=G.UIT.R, config={align = "cm", colour = G.C.MULT, r = 0.1, padding = 0.1}, nodes={
      {n=G.UIT.O, config={object = mult}},
    }},
    {n=G.UIT.R, config={align = "cm", colour = G.C.SUITS.Hearts, r = 0.1, padding = 0.1}, nodes={
      {n=G.UIT.O, config={object = xmult}},
    }},
    {n=G.UIT.R, config={align = "cm", colour = G.C.CHIPS, r = 0.1, padding = 0.1}, nodes={
      {n=G.UIT.O, config={object = chips}},
    }},
    {n=G.UIT.R, config={align = "cm", colour = G.C.MONEY, r = 0.1, padding = 0.1}, nodes={
      {n=G.UIT.O, config={object = econ}},
    }},
    {n=G.UIT.R, config={align = "cm", colour = G.C.GREEN, r = 0.1, padding = 0.1}, nodes={
      {n=G.UIT.O, config={object = effect}},
    }},
    {n=G.UIT.R, config={align = "cm", colour = G.C.SECONDARY_SET.Tarot, r = 0.1, padding = 0.1}, nodes={
      {n=G.UIT.O, config={object = tarot}},
    }},
    {n=G.UIT.R, config={align = "cm", colour = G.C.SECONDARY_SET.Planet, r = 0.1, padding = 0.1}, nodes={
      {n=G.UIT.O, config={object = planet}},
    }}
   }},
   {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
    {n=G.UIT.R, config={align = "cm", colour = G.C.SECONDARY_SET.Spectral, r = 0.1, padding = 0.1}, nodes={
      {n=G.UIT.O, config={object = spectral}},
    }},
    {n=G.UIT.R, config={align = "cm", colour = G.C.SECONDARY_SET.Enhanced, r = 0.1, padding = 0.1}, nodes={
      {n=G.UIT.O, config={object = enhance}},
    }},
    {n=G.UIT.R, config={align = "cm", colour = G.C.DARK_EDITION, r = 0.1, padding = 0.1}, nodes={
      {n=G.UIT.O, config={object = edition}},
    }},
    {n=G.UIT.R, config={align = "cm", colour = G.C.BOOSTER, r = 0.1, padding = 0.1}, nodes={
      {n=G.UIT.O, config={object = pack}},
    }},
    {n=G.UIT.R, config={align = "cm", colour = G.C.UI.TEXT_INACTIVE, r = 0.1, padding = 0.1}, nodes={
      {n=G.UIT.O, config={object = tag}},
    }},
    {n=G.UIT.R, config={align = "cm", colour = G.C.SECONDARY_SET.Voucher, r = 0.1, padding = 0.1}, nodes={
      {n=G.UIT.O, config={object = voucher}},
    }},
    {n=G.UIT.R, config={align = "cm", colour = G.C.PURPLE, r = 0.1, padding = 0.1}, nodes={
      {n=G.UIT.O, config={object = blind}},
    }}
   }}
  }}
end

-- Reroll Boss no longer necessarily costs $10 due to higher level Retcon
function create_UIBox_blind_select()
  local boss_reroll_cost = 10
  if G.GAME.used_vouchers["v_retcon"] then
    boss_reroll_cost = math.max(0, 10 - (voucher_level-1)*2)
  end
  G.blind_prompt_box = UIBox{
    definition =
      {n=G.UIT.ROOT, config = {align = 'cm', colour = G.C.CLEAR, padding = 0.2}, nodes={
        {n=G.UIT.R, config={align = "cm"}, nodes={
          {n=G.UIT.O, config={object = DynaText({string = localize('ph_choose_blind_1'), colours = {G.C.WHITE}, shadow = true, bump = true, scale = 0.6, pop_in = 0.5, maxw = 5}), id = 'prompt_dynatext1'}}
        }},
        {n=G.UIT.R, config={align = "cm"}, nodes={
          {n=G.UIT.O, config={object = DynaText({string = localize('ph_choose_blind_2'), colours = {G.C.WHITE}, shadow = true, bump = true, scale = 0.7, pop_in = 0.5, maxw = 5, silent = true}), id = 'prompt_dynatext2'}}
        }},
        (G.GAME.used_vouchers["v_retcon"] or G.GAME.used_vouchers["v_directors_cut"]) and
        UIBox_button({label = {localize('b_reroll_boss'), localize('$')..boss_reroll_cost}, button = "reroll_boss", func = 'reroll_boss_button'}) or nil
      }},
    config = {align="cm", offset = {x=0,y=-15},major = G.HUD:get_UIE_by_ID('row_blind'), bond = 'Weak'}
  }
  G.E_MANAGER:add_event(Event({
    trigger = 'immediate',
    func = (function()
        G.blind_prompt_box.alignment.offset.y = 0
        return true
    end)
  }))

  local width = G.hand.T.w
  G.GAME.blind_on_deck = 
    not (G.GAME.round_resets.blind_states.Small == 'Defeated' or G.GAME.round_resets.blind_states.Small == 'Skipped' or G.GAME.round_resets.blind_states.Small == 'Hide') and 'Small' or
    not (G.GAME.round_resets.blind_states.Big == 'Defeated' or G.GAME.round_resets.blind_states.Big == 'Skipped'or G.GAME.round_resets.blind_states.Big == 'Hide') and 'Big' or 
    'Boss'
  
  G.blind_select_opts = {}
  G.blind_select_opts.small = G.GAME.round_resets.blind_states['Small'] ~= 'Hide' and UIBox{definition = {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes={UIBox_dyn_container({create_UIBox_blind_choice('Small')},false,get_blind_main_colour('Small'))}}, config = {align="bmi", offset = {x=0,y=0}}} or nil
  G.blind_select_opts.big = G.GAME.round_resets.blind_states['Big'] ~= 'Hide' and UIBox{definition = {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes={UIBox_dyn_container({create_UIBox_blind_choice('Big')},false,get_blind_main_colour('Big'))}}, config = {align="bmi", offset = {x=0,y=0}}} or nil
  G.blind_select_opts.boss = G.GAME.round_resets.blind_states['Boss'] ~= 'Hide' and UIBox{definition = {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes={UIBox_dyn_container({create_UIBox_blind_choice('Boss')},false,get_blind_main_colour('Boss'), mix_colours(G.C.BLACK, get_blind_main_colour('Boss'), 0.8))}}, config = {align="bmi", offset = {x=0,y=0}}} or nil
 
  local t = {n=G.UIT.ROOT, config = {align = 'tm',minw = width, r = 0.15, colour = G.C.CLEAR}, nodes={
    {n=G.UIT.R, config={align = "cm", padding = 0.5}, nodes={
      G.GAME.round_resets.blind_states['Small'] ~= 'Hide' and {n=G.UIT.O, config={align = "cm", object = G.blind_select_opts.small}} or nil,
      G.GAME.round_resets.blind_states['Big'] ~= 'Hide' and {n=G.UIT.O, config={align = "cm", object = G.blind_select_opts.big}} or nil,
      G.GAME.round_resets.blind_states['Boss'] ~= 'Hide' and {n=G.UIT.O, config={align = "cm", object = G.blind_select_opts.boss}} or nil,
    }}
  }}
  return t 
end

-- Overwriting generate_card_ui for Temperance, Negative playing cards, and Tags that give Booster packs
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
        if _c.name == 'Stone Joker' then info_queue[#info_queue+1] = G.P_CENTERS.m_stone
        elseif _c.name == 'Marble Joker' then
          info_queue[#info_queue+1] = G.P_CENTERS.m_stone
          if effect_level >= 2 then
            info_queue[#info_queue+1] = G.P_CENTERS.e_negative_playing_card
          end
        elseif _c.name == 'Steel Joker' then info_queue[#info_queue+1] = G.P_CENTERS.m_steel 
        elseif _c.name == 'Glass Joker' then info_queue[#info_queue+1] = G.P_CENTERS.m_glass 
        elseif _c.name == 'Golden Ticket' then info_queue[#info_queue+1] = G.P_CENTERS.m_gold 
        elseif _c.name == 'Lucky Cat' then info_queue[#info_queue+1] = G.P_CENTERS.m_lucky 
        elseif _c.name == 'Midas Mask' then
          info_queue[#info_queue+1] = G.P_CENTERS.m_gold
          if effect_level >= 2 then
            info_queue[#info_queue+1] = G.P_CENTERS.e_negative_playing_card
          end
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
        elseif _c.name == 'Charm Tag' then
          if G.SETTINGS.paused then
            info_queue[#info_queue+1] = {name = "Mega Arcana Pack", weight = 0.25, kind = 'Arcana', cost = 8, atlas = 'Booster', set = 'Booster', config = {extra = math.floor(5+(2/3) + ((pack_level-2 + tag_level_new) * (2/3))), choose = math.floor(2 + ((pack_level-2 + tag_level_new) * (1/3)))}}
          else
            info_queue[#info_queue+1] = {name = "Mega Arcana Pack", weight = 0.25, kind = 'Arcana', cost = 8, atlas = 'Booster', set = 'Booster', config = {extra = math.floor(5+(2/3) + ((pack_level-2 + tag_level) * (2/3))), choose = math.floor(2 + ((pack_level-2 + tag_level) * (1/3)))}}
          end
        elseif _c.name == 'Meteor Tag' then
          print(G.SETTINGS.paused)
          print(tag_level)
          print(tag_level_new)
          if G.SETTINGS.paused then
            info_queue[#info_queue+1] = {name = "Mega Celestial Pack", weight = 0.25, kind = 'Celestial', cost = 8, atlas = 'Booster', set = 'Booster', config = {extra = math.floor(5+(2/3) + ((pack_level-2 + tag_level_new) * (2/3))), choose = math.floor(2 + ((pack_level-2 + tag_level_new) * (1/3)))}}
          else
            info_queue[#info_queue+1] = {name = "Mega Celestial Pack", weight = 0.25, kind = 'Celestial', cost = 8, atlas = 'Booster', set = 'Booster', config = {extra = math.floor(5+(2/3) + ((pack_level-2 + tag_level) * (2/3))), choose = math.floor(2 + ((pack_level-2 + tag_level) * (1/3)))}}
          end
        elseif _c.name == 'Standard Tag' then
          if G.SETTINGS.paused then
            info_queue[#info_queue+1] = {name = "Mega Standard Pack", weight = 0.25, kind = 'Standard', cost = 8, atlas = 'Booster', set = 'Booster', config = {extra = math.floor(5+(2/3) + ((pack_level-2 + tag_level_new) * (2/3))), choose = math.floor(2 + ((pack_level-2 + tag_level_new) * (1/3)))}}
          else
            info_queue[#info_queue+1] = {name = "Mega Standard Pack", weight = 0.25, kind = 'Standard', cost = 8, atlas = 'Booster', set = 'Booster', config = {extra = math.floor(5+(2/3) + ((pack_level-2 + tag_level) * (2/3))), choose = math.floor(2 + ((pack_level-2 + tag_level) * (1/3)))}}
          end
        elseif _c.name == 'Buffoon Tag' then
          if G.SETTINGS.paused then
            info_queue[#info_queue+1] = {name = "Mega Buffoon Pack", weight = 0.25, kind = 'Buffoon', cost = 8, atlas = 'Booster', set = 'Booster', config = {extra = math.floor(4+(2/3) + ((pack_level-2 + tag_level_new) * (2/3))), choose = math.floor(2 + ((pack_level-2 + tag_level_new) * (1/3)))}}
          else
            info_queue[#info_queue+1] = {name = "Mega Buffoon Pack", weight = 0.25, kind = 'Buffoon', cost = 8, atlas = 'Booster', set = 'Booster', config = {extra = math.floor(4+(2/3) + ((pack_level-2 + tag_level) * (2/3))), choose = math.floor(2 + ((pack_level-2 + tag_level) * (1/3)))}}
          end
        elseif _c.name == 'Ethereal Tag' then
          if G.SETTINGS.paused then
            if tag_level_new == 1 then
              info_queue[#info_queue+1] = G.P_CENTERS.p_spectral_normal_1
            elseif tag_level_new >= 2 then
              info_queue[#info_queue+1] = {name = "Mega Spectral Pack", weight = 0.25, kind = 'Spectral', cost = 8, atlas = 'Booster', set = 'Booster', config = {extra = math.floor(4+(2/3) + ((pack_level-3 + tag_level_new) * (2/3))), choose = math.floor(2 + ((pack_level-3 + tag_level_new) * (1/3)))}}
            end
          else
            if tag_level == 1 then
              info_queue[#info_queue+1] = G.P_CENTERS.p_spectral_normal_1
            elseif tag_level >= 2 then
              info_queue[#info_queue+1] = {name = "Mega Spectral Pack", weight = 0.25, kind = 'Spectral', cost = 8, atlas = 'Booster', set = 'Booster', config = {extra = math.floor(4+(2/3) + ((pack_level-3 + tag_level) * (2/3))), choose = math.floor(2 + ((pack_level-3 + tag_level) * (1/3)))}}
            end
          end
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
        if _c.name == 'Incantation' and spectral_level >= 2 then
            info_queue[#info_queue+1] = G.P_CENTERS.e_negative_playing_card
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
            if v == 'negative_playing_card' then info_queue[#info_queue+1] = {key = 'e_negative_playing_card', set = 'Edition', config = {extra = 1}} end
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


-- COLLECTION UI (to complete)

function leveldisplace(number, x)
  if (number <= -10) or (number >= 100) then
    return (x - 44)
  elseif (number <= -1) or (number >= 10) then
    return (x - 22)
  else
    return x
  end
end

G.FUNCS.levelsel = function(e)
  local category = e.config.typ[1]

  if e.config.typ[2] == 'inc' and category == 14 then
    collection_levels[category] = math.min(4, collection_levels[category] + 1)
  elseif e.config.typ[2] == 'dec' and category == 14 then
    collection_levels[category] = collection_levels[category] - 1
  elseif e.config.typ[2] == 'inc' and category ~= 14 then
    collection_levels[category] = collection_levels[category] + 1
  elseif e.config.typ[2] == 'dec' and category ~= 14 then
    collection_levels[category] = math.max(1, collection_levels[category] - 1)
  end

  set_centers(collection_levels[1], collection_levels[2], collection_levels[3], collection_levels[4], collection_levels[5], collection_levels[6], collection_levels[7], collection_levels[8], collection_levels[9], collection_levels[10], collection_levels[11], collection_levels[12], collection_levels[13], collection_levels[14])
  if category ~= 12 and category ~= 14 then
    for i=1, #G.your_collection do
      updateitems(G.your_collection[i])
    end
    if category == 9 then
      G.your_collection[1].cards[1].ability.perma_bonus = (collection_levels[category]-1) * 15
      G.your_collection[2].cards[2].ability.perma_bonus = (collection_levels[category]-1) * 25
    end
  elseif category == 12 then
    tag_level_new = collection_levels[12]
  end
  desc(collection_levels[1], collection_levels[2], collection_levels[3], collection_levels[4], collection_levels[5], collection_levels[6], collection_levels[7], collection_levels[8], collection_levels[9], collection_levels[10], collection_levels[11], collection_levels[12], collection_levels[13], collection_levels[14])

  local X = leveldisplace(collection_levels[category], 1977)
  local Y = 0
  local index = 2

  if category == 1 then -- MULT
    X = leveldisplace(collection_levels[category], 1114)
    Y = 1658
  elseif category == 2 then -- XMULT
    index = 5
    X = leveldisplace(collection_levels[category], 1545)
    Y = 1658
  elseif category == 3 then -- CHIPS
    index = 8
    Y = 1658
  elseif category == 4 then -- ECON
    index = 11
    X = leveldisplace(collection_levels[category], 2407)
    Y = 1658
  elseif category == 5 then -- EFFECT
    index = 14
    X = leveldisplace(collection_levels[category], 2838)
    Y = 1658
  elseif category == 6 or category == 7 or category == 8 or category == 13 then -- TAROT, PLANET, SPECTRAL
    Y = 1422
  elseif category == 9 then -- ENHANCE
    Y = 1618
  elseif category == 10 then -- EDITION
    Y = 1326
  elseif category == 11 then -- PACK
    Y = 1585
  elseif category == 12 then -- TAG (need to update descriptions)
    Y = 1444
  elseif category == 14 then -- BLIND
    Y = 1943
  end

  e.parent.children[index].children[1].config.object:pop_out(16)
  e.parent.children[index].children[1].config.object = DynaText({string = {{string = collection_levels[category], colour = G.C.UI.TEXT_LIGHT}}, x_offset = X, y_offset = Y, colours = {G.C.UI.TEXT_LIGHT}, pop_in = 0, pop_in_rate = 8, reset_pop_in = true, shadow = true, float = true, silent = true, bump = true, scale = 0.5, non_recalc = true})

end

function levels(category)
  if category == 'jokers' then
    return {n=G.UIT.R, config={padding = 0.05, align = 'cl', colour = G.C.CLEAR}, nodes={

      -- MULT
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.6, minh = 0.8, maxh = 0.8, shadow = true, hover = true, colour = G.C.MULT, button = 'levelsel', typ = {1, 'dec'}}, nodes={
        {n=G.UIT.T, config={text = "<", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}}
      }},
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.8, minh = 0.8, maxh = 0.8, shadow = false, emboss = 0.1, colour = G.C.MULT}, nodes={
        {n=G.UIT.O, config={object = DynaText({string = {{string = collection_levels[1], colour = G.C.UI.TEXT_LIGHT}}, colours = {G.C.UI.TEXT_LIGHT}, pop_in = 0, pop_in_rate = 8, reset_pop_in = true, shadow = true, float = true, silent = true, bump = true, scale = 0.5, non_recalc = true})}}
      }},
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.6, minh = 0.8, maxh = 0.8, shadow = true, hover = true, colour = G.C.MULT, button = 'levelsel', typ = {1, 'inc'}}, nodes={
        {n=G.UIT.T, config={text = ">", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}}
      }},

      -- XMULT
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.6, minh = 0.8, maxh = 0.8, shadow = true, hover = true, colour = G.C.SUITS.Hearts, button = 'levelsel', typ = {2, 'dec'}}, nodes={
        {n=G.UIT.T, config={text = "<", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}}
      }},
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.8, minh = 0.8, maxh = 0.8, shadow = false, emboss = 0.1, colour = G.C.SUITS.Hearts}, nodes={
        {n=G.UIT.O, config={object = DynaText({string = {{string = collection_levels[2], colour = G.C.UI.TEXT_LIGHT}}, colours = {G.C.UI.TEXT_LIGHT}, pop_in = 0, pop_in_rate = 8, reset_pop_in = true, shadow = true, float = true, silent = true, bump = true, scale = 0.5, non_recalc = true})}}
      }},
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.6, minh = 0.8, maxh = 0.8, shadow = true, hover = true, colour = G.C.SUITS.Hearts, button = 'levelsel', typ = {2, 'inc'}}, nodes={
        {n=G.UIT.T, config={text = ">", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}}
      }},

      -- CHIPS
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.6, minh = 0.8, maxh = 0.8, shadow = true, hover = true, colour = G.C.CHIPS, button = 'levelsel', typ = {3, 'dec'}}, nodes={
        {n=G.UIT.T, config={text = "<", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}}
      }},
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.8, minh = 0.8, maxh = 0.8, shadow = false, emboss = 0.1, colour = G.C.CHIPS}, nodes={
        {n=G.UIT.O, config={object = DynaText({string = {{string = collection_levels[3], colour = G.C.UI.TEXT_LIGHT}}, colours = {G.C.UI.TEXT_LIGHT}, pop_in = 0, pop_in_rate = 8, reset_pop_in = true, shadow = true, float = true, silent = true, bump = true, scale = 0.5, non_recalc = true})}}
      }},
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.6, minh = 0.8, maxh = 0.8, shadow = true, hover = true, colour = G.C.CHIPS, button = 'levelsel', typ = {3, 'inc'}}, nodes={
        {n=G.UIT.T, config={text = ">", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}}
      }},

      -- ECON
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.6, minh = 0.8, maxh = 0.8, shadow = true, hover = true, colour = G.C.MONEY, button = 'levelsel', typ = {4, 'dec'}}, nodes={
        {n=G.UIT.T, config={text = "<", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}}
      }},
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.8, minh = 0.8, maxh = 0.8, shadow = false, emboss = 0.1, colour = G.C.MONEY}, nodes={
        {n=G.UIT.O, config={object = DynaText({string = {{string = collection_levels[4], colour = G.C.UI.TEXT_LIGHT}}, colours = {G.C.UI.TEXT_LIGHT}, pop_in = 0, pop_in_rate = 8, reset_pop_in = true, shadow = true, float = true, silent = true, bump = true, scale = 0.5, non_recalc = true})}}
      }},
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.6, minh = 0.8, maxh = 0.8, shadow = true, hover = true, colour = G.C.MONEY, button = 'levelsel', typ = {4, 'inc'}}, nodes={
        {n=G.UIT.T, config={text = ">", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}}
      }},

      -- EFFECT
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.6, minh = 0.8, maxh = 0.8, shadow = true, hover = true, colour = G.C.GREEN, button = 'levelsel', typ = {5, 'dec'}}, nodes={
        {n=G.UIT.T, config={text = "<", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}}
      }},
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.8, minh = 0.8, maxh = 0.8, shadow = false, emboss = 0.1, colour = G.C.GREEN}, nodes={
        {n=G.UIT.O, config={object = DynaText({string = {{string = collection_levels[5], colour = G.C.UI.TEXT_LIGHT}}, colours = {G.C.UI.TEXT_LIGHT}, pop_in = 0, pop_in_rate = 8, reset_pop_in = true, shadow = true, float = true, silent = true, bump = true, scale = 0.5, non_recalc = true})}}
      }},
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.6, minh = 0.8, maxh = 0.8, shadow = true, hover = true, colour = G.C.GREEN, button = 'levelsel', typ = {5, 'inc'}}, nodes={
        {n=G.UIT.T, config={text = ">", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}}
      }}
    }}

  -- TAROTS
  elseif category == 'tarots' then
    print('test')
    return {n=G.UIT.R, config={padding = 0.05, align = 'cl', colour = G.C.CLEAR}, nodes={
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.6, minh = 0.8, maxh = 0.8, shadow = true, hover = true, colour = G.C.SECONDARY_SET.Tarot, button = 'levelsel', typ = {6, 'dec'}}, nodes={
        {n=G.UIT.T, config={text = "<", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}}
      }},
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.8, minh = 0.8, maxh = 0.8, shadow = false, emboss = 0.1, colour = G.C.SECONDARY_SET.Tarot}, nodes={
        {n=G.UIT.O, config={object = DynaText({string = {{string = collection_levels[6], colour = G.C.UI.TEXT_LIGHT}}, colours = {G.C.UI.TEXT_LIGHT}, pop_in = 0, pop_in_rate = 8, reset_pop_in = true, shadow = true, float = true, silent = true, bump = true, scale = 0.5, non_recalc = true})}}
      }},
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.6, minh = 0.8, maxh = 0.8, shadow = true, hover = true, colour = G.C.SECONDARY_SET.Tarot, button = 'levelsel', typ = {6, 'inc'}}, nodes={
        {n=G.UIT.T, config={text = ">", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}}
      }}
    }}

  -- PLANETS
  elseif category == 'planets' then
    return {n=G.UIT.R, config={padding = 0.05, align = 'cl', colour = G.C.CLEAR}, nodes={
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.6, minh = 0.8, maxh = 0.8, shadow = true, hover = true, colour = G.C.SECONDARY_SET.Planet, button = 'levelsel', typ = {7, 'dec'}}, nodes={
        {n=G.UIT.T, config={text = "<", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}}
      }},
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.8, minh = 0.8, maxh = 0.8, shadow = false, emboss = 0.1, colour = G.C.SECONDARY_SET.Planet}, nodes={
        {n=G.UIT.O, config={object = DynaText({string = {{string = collection_levels[7], colour = G.C.UI.TEXT_LIGHT}}, colours = {G.C.UI.TEXT_LIGHT}, pop_in = 0, pop_in_rate = 8, reset_pop_in = true, shadow = true, float = true, silent = true, bump = true, scale = 0.5, non_recalc = true})}}
      }},
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.6, minh = 0.8, maxh = 0.8, shadow = true, hover = true, colour = G.C.SECONDARY_SET.Planet, button = 'levelsel', typ = {7, 'inc'}}, nodes={
        {n=G.UIT.T, config={text = ">", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}}
      }}
    }}

  -- SPECTRALS
  elseif category == 'spectrals' then
    return {n=G.UIT.R, config={padding = 0.05, align = 'cl', colour = G.C.CLEAR}, nodes={
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.6, minh = 0.8, maxh = 0.8, shadow = true, hover = true, colour = G.C.SECONDARY_SET.Spectral, button = 'levelsel', typ = {8, 'dec'}}, nodes={
        {n=G.UIT.T, config={text = "<", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}}
      }},
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.8, minh = 0.8, maxh = 0.8, shadow = false, emboss = 0.1, colour = G.C.SECONDARY_SET.Spectral}, nodes={
        {n=G.UIT.O, config={object = DynaText({string = {{string = collection_levels[8], colour = G.C.UI.TEXT_LIGHT}}, colours = {G.C.UI.TEXT_LIGHT}, pop_in = 0, pop_in_rate = 8, reset_pop_in = true, shadow = true, float = true, silent = true, bump = true, scale = 0.5, non_recalc = true})}}
      }},
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.6, minh = 0.8, maxh = 0.8, shadow = true, hover = true, colour = G.C.SECONDARY_SET.Spectral, button = 'levelsel', typ = {8, 'inc'}}, nodes={
        {n=G.UIT.T, config={text = ">", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}}
      }}
    }}

  -- ENHANCEMENTS
  elseif category == 'enhancements' then
    return {n=G.UIT.R, config={padding = 0.05, align = 'cl', colour = G.C.CLEAR}, nodes={
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.6, minh = 0.8, maxh = 0.8, shadow = true, hover = true, colour = G.C.SECONDARY_SET.Enhanced, button = 'levelsel', typ = {9, 'dec'}}, nodes={
        {n=G.UIT.T, config={text = "<", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}}
      }},
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.8, minh = 0.8, maxh = 0.8, shadow = false, emboss = 0.1, colour = G.C.SECONDARY_SET.Enhanced}, nodes={
        {n=G.UIT.O, config={object = DynaText({string = {{string = collection_levels[9], colour = G.C.UI.TEXT_LIGHT}}, colours = {G.C.UI.TEXT_LIGHT}, pop_in = 0, pop_in_rate = 8, reset_pop_in = true, shadow = true, float = true, silent = true, bump = true, scale = 0.5, non_recalc = true})}}
      }},
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.6, minh = 0.8, maxh = 0.8, shadow = true, hover = true, colour = G.C.SECONDARY_SET.Enhanced, button = 'levelsel', typ = {9, 'inc'}}, nodes={
        {n=G.UIT.T, config={text = ">", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}}
      }}
    }}

  -- EDITIONS
  elseif category == 'editions' then
    return {n=G.UIT.R, config={padding = 0.05, align = 'cl', colour = G.C.CLEAR}, nodes={
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.6, minh = 0.8, maxh = 0.8, shadow = true, hover = true, colour = G.C.DARK_EDITION, button = 'levelsel', typ = {10, 'dec'}}, nodes={
        {n=G.UIT.T, config={text = "<", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}}
      }},
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.8, minh = 0.8, maxh = 0.8, shadow = false, emboss = 0.1, colour = G.C.DARK_EDITION}, nodes={
        {n=G.UIT.O, config={object = DynaText({string = {{string = collection_levels[10], colour = G.C.UI.TEXT_LIGHT}}, colours = {G.C.UI.TEXT_LIGHT}, pop_in = 0, pop_in_rate = 8, reset_pop_in = true, shadow = true, float = true, silent = true, bump = true, scale = 0.5, non_recalc = true})}}
      }},
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.6, minh = 0.8, maxh = 0.8, shadow = true, hover = true, colour = G.C.DARK_EDITION, button = 'levelsel', typ = {10, 'inc'}}, nodes={
        {n=G.UIT.T, config={text = ">", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}}
      }}
    }}

  -- PACKS
  elseif category == 'packs' then
    return {n=G.UIT.R, config={padding = 0.05, align = 'cl', colour = G.C.CLEAR}, nodes={
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.6, minh = 0.8, maxh = 0.8, shadow = true, hover = true, colour = G.C.BOOSTER, button = 'levelsel', typ = {11, 'dec'}}, nodes={
        {n=G.UIT.T, config={text = "<", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}}
      }},
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.8, minh = 0.8, maxh = 0.8, shadow = false, emboss = 0.1, colour = G.C.BOOSTER}, nodes={
        {n=G.UIT.O, config={object = DynaText({string = {{string = collection_levels[11], colour = G.C.UI.TEXT_LIGHT}}, colours = {G.C.UI.TEXT_LIGHT}, pop_in = 0, pop_in_rate = 8, reset_pop_in = true, shadow = true, float = true, silent = true, bump = true, scale = 0.5, non_recalc = true})}}
      }},
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.6, minh = 0.8, maxh = 0.8, shadow = true, hover = true, colour = G.C.BOOSTER, button = 'levelsel', typ = {11, 'inc'}}, nodes={
        {n=G.UIT.T, config={text = ">", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}}
      }}
    }}

  -- TAGS
  elseif category == 'tags' then
    return {n=G.UIT.R, config={padding = 0.05, align = 'cl', colour = G.C.CLEAR}, nodes={
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.6, minh = 0.8, maxh = 0.8, shadow = true, hover = true, colour = G.C.UI.TEXT_INACTIVE, button = 'levelsel', typ = {12, 'dec'}}, nodes={
        {n=G.UIT.T, config={text = "<", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}}
      }},
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.8, minh = 0.8, maxh = 0.8, shadow = false, emboss = 0.1, colour = G.C.UI.TEXT_INACTIVE}, nodes={
        {n=G.UIT.O, config={object = DynaText({string = {{string = collection_levels[12], colour = G.C.UI.TEXT_LIGHT}}, colours = {G.C.UI.TEXT_LIGHT}, pop_in = 0, pop_in_rate = 8, reset_pop_in = true, shadow = true, float = true, silent = true, bump = true, scale = 0.5, non_recalc = true})}}
      }},
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.6, minh = 0.8, maxh = 0.8, shadow = true, hover = true, colour = G.C.UI.TEXT_INACTIVE, button = 'levelsel', typ = {12, 'inc'}}, nodes={
        {n=G.UIT.T, config={text = ">", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}}
      }}
    }}

  -- VOUCHERS
  elseif category == 'vouchers' then
    return {n=G.UIT.R, config={padding = 0.05, align = 'cl', colour = G.C.CLEAR}, nodes={
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.6, minh = 0.8, maxh = 0.8, shadow = true, hover = true, colour = G.C.SECONDARY_SET.Voucher, button = 'levelsel', typ = {13, 'dec'}}, nodes={
        {n=G.UIT.T, config={text = "<", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}}
      }},
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.8, minh = 0.8, maxh = 0.8, shadow = false, emboss = 0.1, colour = G.C.SECONDARY_SET.Voucher}, nodes={
        {n=G.UIT.O, config={object = DynaText({string = {{string = collection_levels[13], colour = G.C.UI.TEXT_LIGHT}}, colours = {G.C.UI.TEXT_LIGHT}, pop_in = 0, pop_in_rate = 8, reset_pop_in = true, shadow = true, float = true, silent = true, bump = true, scale = 0.5, non_recalc = true})}}
      }},
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.6, minh = 0.8, maxh = 0.8, shadow = true, hover = true, colour = G.C.SECONDARY_SET.Voucher, button = 'levelsel', typ = {13, 'inc'}}, nodes={
        {n=G.UIT.T, config={text = ">", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}}
      }}
    }}

  -- BLINDS
  elseif category == 'blinds' then
    return {n=G.UIT.R, config={padding = 0.05, align = 'cl', colour = G.C.CLEAR}, nodes={
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.6, minh = 0.8, maxh = 0.8, shadow = true, hover = true, colour = G.C.PURPLE, button = 'levelsel', typ = {14, 'dec'}}, nodes={
        {n=G.UIT.T, config={text = "<", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}}
      }},
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.8, minh = 0.8, maxh = 0.8, shadow = false, emboss = 0.1, colour = G.C.PURPLE}, nodes={
        {n=G.UIT.O, config={object = DynaText({string = {{string = collection_levels[14], colour = G.C.UI.TEXT_LIGHT}}, colours = {G.C.UI.TEXT_LIGHT}, pop_in = 0, pop_in_rate = 8, reset_pop_in = true, shadow = true, float = true, silent = true, bump = true, scale = 0.5, non_recalc = true})}}
      }},
      {n=G.UIT.C, config={r = 0.08, padding = 0, align = "cm", minw = 0.6, minh = 0.8, maxh = 0.8, shadow = true, hover = true, colour = G.C.PURPLE, button = 'levelsel', typ = {14, 'inc'}}, nodes={
        {n=G.UIT.T, config={text = ">", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true}}
      }}
    }}

  end
end

-- Hooking create_UIBox_your_collection to reset card levels
function create_UIBox_your_collection()
  tag_level_new = tag_level
  collection_levels = {mult_level, xmult_level, chips_level, econ_level, effect_level, tarot_level, planet_level, spectral_level, enhance_level, edition_level, pack_level, tag_level, voucher_level, blind_level}
  set_centers(mult_level, xmult_level, chips_level, econ_level, effect_level, tarot_level, planet_level, spectral_level, enhance_level, edition_level, pack_level, tag_level, voucher_level, blind_level)
  desc(mult_level, xmult_level, chips_level, econ_level, effect_level, tarot_level, planet_level, spectral_level, enhance_level, edition_level, pack_level, tag_level, voucher_level, blind_level)
  set_discover_tallies()
  G.E_MANAGER:add_event(Event({
    blockable = false,
    func = function()
      G.REFRESH_ALERTS = true
    return true
    end
  }))
  local t = create_UIBox_generic_options({ back_func = G.STAGE == G.STAGES.RUN and 'options' or 'exit_overlay_menu', contents = {
    {n=G.UIT.C, config={align = "cm", padding = 0.15}, nodes={
      UIBox_button({button = 'your_collection_jokers', label = {localize('b_jokers')}, count = G.DISCOVER_TALLIES.jokers,  minw = 5, minh = 1.7, scale = 0.6, id = 'your_collection_jokers'}),
      UIBox_button({button = 'your_collection_decks', label = {localize('b_decks')}, count = G.DISCOVER_TALLIES.backs, minw = 5}),
      UIBox_button({button = 'your_collection_vouchers', label = {localize('b_vouchers')}, count = G.DISCOVER_TALLIES.vouchers, minw = 5, id = 'your_collection_vouchers'}),
      {n=G.UIT.R, config={align = "cm", padding = 0.1, r=0.2, colour = G.C.BLACK}, nodes={
        {n=G.UIT.C, config={align = "cm", maxh=2.9}, nodes={
          {n=G.UIT.T, config={text = localize('k_cap_consumables'), scale = 0.45, colour = G.C.L_BLACK, vert = true, maxh=2.2}},
        }},
        {n=G.UIT.C, config={align = "cm", padding = 0.15}, nodes={
          UIBox_button({button = 'your_collection_tarots2', label = {localize('b_tarot_cards')}, count = G.DISCOVER_TALLIES.tarots, minw = 4, id = 'your_collection_tarots', colour = G.C.SECONDARY_SET.Tarot}),
          UIBox_button({button = 'your_collection_planets2', label = {localize('b_planet_cards')}, count = G.DISCOVER_TALLIES.planets, minw = 4, id = 'your_collection_planets', colour = G.C.SECONDARY_SET.Planet}),
          UIBox_button({button = 'your_collection_spectrals2', label = {localize('b_spectral_cards')}, count = G.DISCOVER_TALLIES.spectrals, minw = 4, id = 'your_collection_spectrals', colour = G.C.SECONDARY_SET.Spectral}),
        }}
      }},
    }},
    {n=G.UIT.C, config={align = "cm", padding = 0.15}, nodes={
      UIBox_button({button = 'your_collection_enhancements', label = {localize('b_enhanced_cards')}, minw = 5}),
      UIBox_button({button = 'your_collection_seals', label = {localize('b_seals')}, minw = 5, id = 'your_collection_seals'}),
      UIBox_button({button = 'your_collection_editions', label = {localize('b_editions')}, count = G.DISCOVER_TALLIES.editions, minw = 5, id = 'your_collection_editions'}),
      UIBox_button({button = 'your_collection_boosters', label = {localize('b_booster_packs')}, count = G.DISCOVER_TALLIES.boosters, minw = 5, id = 'your_collection_boosters'}),
      UIBox_button({button = 'your_collection_tags', label = {localize('b_tags')}, count = G.DISCOVER_TALLIES.tags, minw = 5, id = 'your_collection_tags'}),
      UIBox_button({button = 'your_collection_blinds', label = {localize('b_blinds')}, count = G.DISCOVER_TALLIES.blinds, minw = 5, minh = 2.0, id = 'your_collection_blinds', focus_args = {snap_to = true}}),
    }},
    
  }})
  return t
end

G.FUNCS.your_collection_tarots2 = function(e)
  G.SETTINGS.paused = true
  G.FUNCS.overlay_menu{
    definition = create_UIBox_your_collection_tarots2(),
  }
end

G.FUNCS.your_collection_planets2 = function(e)
  G.SETTINGS.paused = true
  G.FUNCS.overlay_menu{
    definition = create_UIBox_your_collection_planets2(),
  }
end

G.FUNCS.your_collection_spectrals2 = function(e)
  G.SETTINGS.paused = true
  G.FUNCS.overlay_menu{
    definition = create_UIBox_your_collection_spectrals2(),
  }
end

function create_UIBox_your_collection_jokers()
  local deck_tables = {}

  G.your_collection = {}
  for j = 1, 3 do
    G.your_collection[j] = CardArea(
      G.ROOM.T.x + 0.2*G.ROOM.T.w/2,G.ROOM.T.h,
      5*G.CARD_W,
      0.95*G.CARD_H, 
      {card_limit = 5, type = 'title', highlight_limit = 0, collection = true})
    table.insert(deck_tables, 
    {n=G.UIT.R, config={align = "cm", padding = 0.07, no_fill = true}, nodes={
      {n=G.UIT.O, config={object = G.your_collection[j]}}
    }}
    )
  end

  local joker_options = {}
  for i = 1, math.ceil(#G.P_CENTER_POOLS.Joker/(5*#G.your_collection)) do
    table.insert(joker_options, localize('k_page')..' '..tostring(i)..'/'..tostring(math.ceil(#G.P_CENTER_POOLS.Joker/(5*#G.your_collection))))
  end

  for i = 1, 5 do
    for j = 1, #G.your_collection do
      local center = G.P_CENTER_POOLS["Joker"][i+(j-1)*5]
      local card = Card(G.your_collection[j].T.x + G.your_collection[j].T.w/2, G.your_collection[j].T.y, G.CARD_W, G.CARD_H, nil, center)
      card.sticker = get_joker_win_sticker(center)
      G.your_collection[j]:emplace(card)
    end
  end

  INIT_COLLECTION_CARD_ALERTS()
  
  local t =  create_UIBox_generic_options({ back_func = 'your_collection', contents = {
        {n=G.UIT.R, config={align = "cm", r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes=deck_tables}, 
        {n=G.UIT.R, config={align = "cm"}, nodes={
          levels('jokers')
        }},
        {n=G.UIT.R, config={align = "cm"}, nodes={
          create_option_cycle({options = joker_options, w = 4.5, cycle_shoulders = true, opt_callback = 'your_collection_joker_page', current_option = 1, colour = G.C.RED, no_pips = true, focus_args = {snap_to = true, nav = 'wide'}})
        }}
    }})
  return t
end

function create_UIBox_your_collection_tarots2()
  local deck_tables = {}

  G.your_collection = {}
  for j = 1, 2 do
    G.your_collection[j] = CardArea(
      G.ROOM.T.x + 0.2*G.ROOM.T.w/2,G.ROOM.T.h,
      (4.25+j)*G.CARD_W,
      1*G.CARD_H, 
      {card_limit = 4 + j, type = 'title', highlight_limit = 0, collection = true})
    table.insert(deck_tables, 
    {n=G.UIT.R, config={align = "cm", padding = 0, no_fill = true}, nodes={
      {n=G.UIT.O, config={object = G.your_collection[j]}}
    }}
    )
  end

  local tarot_options = {}
  for i = 1, math.floor(#G.P_CENTER_POOLS.Tarot/11) do
    table.insert(tarot_options, localize('k_page')..' '..tostring(i)..'/'..tostring(math.floor(#G.P_CENTER_POOLS.Tarot/11)))
  end

    for j = 1, #G.your_collection do
      for i = 1, 4+j do
      local center = G.P_CENTER_POOLS["Tarot"][i+(j-1)*(5)]
      local card = Card(G.your_collection[j].T.x + G.your_collection[j].T.w/2, G.your_collection[j].T.y, G.CARD_W, G.CARD_H, nil, center)
      card:start_materialize(nil, i>1 or j>1)
      G.your_collection[j]:emplace(card)
    end
  end

  INIT_COLLECTION_CARD_ALERTS()

  local t =  create_UIBox_generic_options({ back_func = 'your_collection', contents = {
        {n=G.UIT.R, config={align = "cm", r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes=deck_tables}, 
        {n=G.UIT.R, config={align = "cm"}, nodes={
          levels('tarots')
        }},
        {n=G.UIT.R, config={align = "cm"}, nodes={
          create_option_cycle({options = tarot_options, w = 4.5, cycle_shoulders = true, opt_callback = 'your_collection_tarot_page', current_option = 1, colour = G.C.RED, no_pips = true, focus_args = {snap_to = true, nav = 'wide'}})
        }}
    }})
  return t
end

function create_UIBox_your_collection_planets2()
  local deck_tables = {}

  G.your_collection = {}
  for j = 1, 2 do
    G.your_collection[j] = CardArea(
      G.ROOM.T.x + 0.2*G.ROOM.T.w/2,G.ROOM.T.h,
      (6.25)*G.CARD_W,
      1*G.CARD_H, 
      {card_limit = 6, type = 'title', highlight_limit = 0, collection = true})
    table.insert(deck_tables, 
    {n=G.UIT.R, config={align = "cm", padding = 0, no_fill = true}, nodes={
      {n=G.UIT.O, config={object = G.your_collection[j]}}
    }}
    )
  end

    for j = 1, #G.your_collection do
      for i = 1, 6 do
      local center = G.P_CENTER_POOLS["Planet"][i+(j-1)*(6)]
      local card = Card(G.your_collection[j].T.x + G.your_collection[j].T.w/2, G.your_collection[j].T.y, G.CARD_W, G.CARD_H, nil, center)
      card:start_materialize(nil, i>1 or j>1)
      G.your_collection[j]:emplace(card)
    end
  end

  local planet_options = {}
  for i = 1, math.floor(#G.P_CENTER_POOLS.Planet/12) do
    table.insert(planet_options, localize('k_page')..' '..tostring(i)..'/'..tostring(math.floor(#G.P_CENTER_POOLS.Planet/12)))
  end

  INIT_COLLECTION_CARD_ALERTS()
  
  local t =  create_UIBox_generic_options({ back_func = 'your_collection', contents = {
        {n=G.UIT.R, config={align = "cm", r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes=deck_tables}, 
        {n=G.UIT.R, config={align = "cm"}, nodes={
          levels('planets')
        }},
        {n=G.UIT.R, config={align = "cm"}, nodes={
          create_option_cycle({options = planet_options, w = 4.5, cycle_shoulders = true, opt_callback = 'your_collection_planet_page', current_option = 1, colour = G.C.RED, no_pips = true, focus_args = {snap_to = true, nav = 'wide'}})
        }}
    }})
  return t
end

function create_UIBox_your_collection_spectrals2()
  local deck_tables = {}

  G.your_collection = {}
  for j = 1, 2 do
    G.your_collection[j] = CardArea(
      G.ROOM.T.x + 0.2*G.ROOM.T.w/2,G.ROOM.T.h,
      (3.25+j)*G.CARD_W,
      1*G.CARD_H, 
      {card_limit = 3+j, type = 'title', highlight_limit = 0, collection = true})
    table.insert(deck_tables, 
    {n=G.UIT.R, config={align = "cm", padding = 0, no_fill = true}, nodes={
      {n=G.UIT.O, config={object = G.your_collection[j]}}
    }}
    )
  end

    for j = 1, #G.your_collection do
      for i = 1, 3+j do
      local center = G.P_CENTER_POOLS["Spectral"][i+(j-1)*3 + j - 1]
      
      local card = Card(G.your_collection[j].T.x + G.your_collection[j].T.w/2, G.your_collection[j].T.y, G.CARD_W, G.CARD_H, nil, center)
      card:start_materialize(nil, i>1 or j>1)
      G.your_collection[j]:emplace(card)
    end
  end

  local spectral_options = {}
  for i = 1, math.floor(#G.P_CENTER_POOLS.Spectral/9) do
    table.insert(spectral_options, localize('k_page')..' '..tostring(i)..'/'..tostring(math.floor(#G.P_CENTER_POOLS.Spectral/9)))
  end

  INIT_COLLECTION_CARD_ALERTS()
  
  local t =  create_UIBox_generic_options({ back_func = 'your_collection', contents = {
        {n=G.UIT.R, config={align = "cm", r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes=deck_tables}, 
        {n=G.UIT.R, config={align = "cm"}, nodes={
          levels('spectrals')
        }},
        {n=G.UIT.R, config={align = "cm"}, nodes={
          create_option_cycle({options = spectral_options, w = 4.5, cycle_shoulders = true, opt_callback = 'your_collection_spectral_page', current_option = 1, colour = G.C.RED, no_pips = true, focus_args = {snap_to = true, nav = 'wide'}})
        }}
    }})
  return t
end

function create_UIBox_your_collection_enhancements(exit)
  local deck_tables = {}

  G.your_collection = {}
  for j = 1, 2 do
    G.your_collection[j] = CardArea(
      G.ROOM.T.x + 0.2*G.ROOM.T.w/2,G.ROOM.T.h,
      4.25*G.CARD_W,
      1.03*G.CARD_H, 
      {card_limit = 4, type = 'title', highlight_limit = 0})
    table.insert(deck_tables, 
    {n=G.UIT.R, config={align = "cm", padding = 0, no_fill = true}, nodes={
      {n=G.UIT.O, config={object = G.your_collection[j]}}
    }}
    )
  end

  for i = 1, 4 do
    for j = 1, #G.your_collection do
      local center = G.P_CENTER_POOLS["Enhanced"][i+(j-1)*4]
      local card = Card(G.your_collection[j].T.x + G.your_collection[j].T.w/2, G.your_collection[j].T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, center)
      G.your_collection[j]:emplace(card)
    end
  end
  
  local t = create_UIBox_generic_options({ infotip = localize('ml_edition_seal_enhancement_explanation'), back_func = exit or 'your_collection', snap_back = true, contents = {
            {n=G.UIT.R, config={align = "cm", minw = 2.5, padding = 0.1, r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes=deck_tables},
            {n=G.UIT.R, config={align = "cm"}, nodes={
              levels('enhancements')
            }}
          }})
  return t
end

function create_UIBox_your_collection_editions()
  G.your_collection = {}
  G.your_collection[1] = CardArea(
    G.ROOM.T.x + 0.2*G.ROOM.T.w/2,G.ROOM.T.h,
    5.3*G.CARD_W,
    1.03*G.CARD_H, 
    {card_limit = 5, type = 'title', highlight_limit = 0, collection = true})
  local deck_tables = 
  {n=G.UIT.R, config={align = "cm", padding = 0, no_fill = true}, nodes={
    {n=G.UIT.O, config={object = G.your_collection[1]}}
  }}

  local editions = {'base', 'foil','holo','polychrome','negative'}

  for i = 1, 5 do
      local card = Card(G.your_collection[1].T.x + G.your_collection[1].T.w/2, G.your_collection[1].T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, G.P_CENTERS['e_'..editions[i]])
      card:start_materialize()
      if G.P_CENTERS['e_'..editions[i]].discovered then card:set_edition({[editions[i]] = true}, true, true) end
      G.your_collection[1]:emplace(card)
  end

  INIT_COLLECTION_CARD_ALERTS()
  
  local t = create_UIBox_generic_options({ infotip = localize('ml_edition_seal_enhancement_explanation'), back_func = 'your_collection', snap_back = true, contents = {
            {n=G.UIT.R, config={align = "cm", minw = 2.5, padding = 0.1, r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes={deck_tables}},
            {n=G.UIT.R, config={align = "cm"}, nodes={
              levels('editions')
            }}
          }})
  return t
end

function create_UIBox_your_collection_seals(exit)
  local deck_tables = {}

  G.your_collection = CardArea(
      G.ROOM.T.x + 0.2*G.ROOM.T.w/2,G.ROOM.T.h,
      4.25*G.CARD_W,
      1.03*G.CARD_H, 
      {card_limit = 4, type = 'title', highlight_limit = 0})
    table.insert(deck_tables, 
    {n=G.UIT.R, config={align = "cm", padding = 0, no_fill = true}, nodes={
      {n=G.UIT.O, config={object = G.your_collection}}
    }}
    )

  for k, v in ipairs(G.P_CENTER_POOLS['Seal']) do
    local center = G.P_CENTERS.c_base
    local card = Card(G.your_collection.T.x + G.your_collection.T.w/2, G.your_collection.T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, center)
    card:set_seal(v.key, true)
    G.your_collection:emplace(card)
  end
  
  local t = create_UIBox_generic_options({ infotip = localize('ml_edition_seal_enhancement_explanation'), back_func = exit or 'your_collection', snap_back = true, contents = {
            {n=G.UIT.R, config={align = "cm", minw = 2.5, padding = 0.1, r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes=deck_tables},
            {n=G.UIT.R, config={align = "cm"}, nodes={
              levels('editions')
            }}
          }})
  return t
end

function create_UIBox_your_collection_boosters()
  local deck_tables = {}

  G.your_collection = {}
  for j = 1, 2 do
    G.your_collection[j] = CardArea(
      G.ROOM.T.x + 0.2*G.ROOM.T.w/2,G.ROOM.T.h,
      (5.25)*G.CARD_W,
      1.3*G.CARD_H, 
      {card_limit = 4, type = 'title', highlight_limit = 0, collection = true})
    table.insert(deck_tables, 
    {n=G.UIT.R, config={align = "cm", padding = 0, no_fill = true}, nodes={
      {n=G.UIT.O, config={object = G.your_collection[j]}}
    }}
    )
  end

  local booster_options = {}
  for i = 1, math.ceil(#G.P_CENTER_POOLS.Booster/8) do
    table.insert(booster_options, localize('k_page')..' '..tostring(i)..'/'..tostring(math.ceil(#G.P_CENTER_POOLS.Booster/8)))
  end

    for j = 1, #G.your_collection do
      for i = 1, 4 do
      local center = G.P_CENTER_POOLS["Booster"][i+(j-1)*4]
      local card = Card(G.your_collection[j].T.x + G.your_collection[j].T.w/2, G.your_collection[j].T.y, G.CARD_W*1.27, G.CARD_H*1.27, nil, center)
      card:start_materialize(nil, i>1 or j>1)
      G.your_collection[j]:emplace(card)
    end
  end

  INIT_COLLECTION_CARD_ALERTS()
  
  local t =  create_UIBox_generic_options({ back_func = 'your_collection', contents = {
        {n=G.UIT.R, config={align = "cm", r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes=deck_tables}, 
        {n=G.UIT.R, config={align = "cm"}, nodes={
          levels('packs')
        }},
        {n=G.UIT.R, config={align = "cm"}, nodes={
          create_option_cycle({options = booster_options, w = 4.5, cycle_shoulders = true, opt_callback = 'your_collection_booster_page', current_option = 1, colour = G.C.RED, no_pips = true, focus_args = {snap_to = true, nav = 'wide'}})
        }}
    }})
  return t
end

function create_UIBox_your_collection_tags()
  G.SETTINGS.paused = true

  local tag_matrix = {
    {},{},{},{},
  }
  local tag_tab = {}
  for k, v in pairs(G.P_TAGS) do
    tag_tab[#tag_tab+1] = v
  end

  table.sort(tag_tab, function (a, b) return a.order < b.order end)

  local tags_to_be_alerted = {}
  for k, v in ipairs(tag_tab) do
    local discovered = v.discovered
    local temp_tag = Tag(v.key, true)
    if not v.discovered then temp_tag.hide_ability = true end
    local temp_tag_ui, temp_tag_sprite = temp_tag:generate_UI()
    tag_matrix[math.ceil((k-1)/6+0.001)][1+((k-1)%6)] = {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
      temp_tag_ui,
    }}
    if discovered and not v.alerted then 
      tags_to_be_alerted[#tags_to_be_alerted+1] = temp_tag_sprite
    end
  end

  G.E_MANAGER:add_event(Event({
    trigger = 'immediate',
    func = (function()
        for _, v in ipairs(tags_to_be_alerted) do
          v.children.alert = UIBox{
            definition = create_UIBox_card_alert(), 
            config = { align="tri", offset = {x = 0.1, y = 0.1}, parent = v}
          }
          v.children.alert.states.collide.can = false
        end
        return true
    end)
  }))


  local t = create_UIBox_generic_options({ back_func = 'your_collection', contents = {
    {n=G.UIT.R, config={align = "cm", r = 0.1, colour = G.C.BLACK, padding = 0.1, emboss = 0.05}, nodes={
      {n=G.UIT.C, config={align = "cm"}, nodes={
        {n=G.UIT.R, config={align = "cm"}, nodes={
          {n=G.UIT.R, config={align = "cm"}, nodes=tag_matrix[1]},
          {n=G.UIT.R, config={align = "cm"}, nodes=tag_matrix[2]},
          {n=G.UIT.R, config={align = "cm"}, nodes=tag_matrix[3]},
          {n=G.UIT.R, config={align = "cm"}, nodes=tag_matrix[4]},
        }}
      }}
    }},
    {n=G.UIT.R, config={align = "cm"}, nodes={
      levels('tags')
    }}
  }})
  return t
end

function create_UIBox_your_collection_vouchers(exit)
  local deck_tables = {}

  G.your_collection = {}
  for j = 1, 2 do
    G.your_collection[j] = CardArea(
      G.ROOM.T.x + 0.2*G.ROOM.T.w/2,G.ROOM.T.h,
      4.25*G.CARD_W,
      1*G.CARD_H, 
      {card_limit = 4, type = 'voucher', highlight_limit = 0, collection = true})
    table.insert(deck_tables, 
    {n=G.UIT.R, config={align = "cm", padding = 0, no_fill = true}, nodes={
      {n=G.UIT.O, config={object = G.your_collection[j]}}
    }}
    )
  end

  local voucher_options = {}
  for i = 1, math.ceil(#G.P_CENTER_POOLS.Voucher/(4*#G.your_collection)) do
    table.insert(voucher_options, localize('k_page')..' '..tostring(i)..'/'..tostring(math.ceil(#G.P_CENTER_POOLS.Voucher/(4*#G.your_collection))))
  end

  for i = 1, 4 do
    for j = 1, #G.your_collection do
      local center = G.P_CENTER_POOLS["Voucher"][i+(j-1)*4]
      local card = Card(G.your_collection[j].T.x + G.your_collection[j].T.w/2, G.your_collection[j].T.y, G.CARD_W, G.CARD_H, nil, center)
      card.ability.order = i+(j-1)*4
      card:start_materialize(nil, i>1 or j>1)
      G.your_collection[j]:emplace(card)
    end
  end

  INIT_COLLECTION_CARD_ALERTS()
  
  local t =  create_UIBox_generic_options({ back_func = 'your_collection', contents = {
        {n=G.UIT.R, config={align = "cm", r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes=deck_tables}, 
        {n=G.UIT.R, config={align = "cm"}, nodes={
          levels('vouchers')
        }},
        {n=G.UIT.R, config={align = "cm"}, nodes={
          create_option_cycle({options = voucher_options, w = 4.5, cycle_shoulders = true, opt_callback = 'your_collection_voucher_page', current_option = 1, colour = G.C.RED, no_pips = true, focus_args = {snap_to = true, nav = 'wide'}})
        }}
    }})
  return t
end

function create_UIBox_your_collection_blinds(exit)
  local blind_matrix = {
    {},{},{}, {}, {}, {}
  }
  local blind_tab = {}
  for k, v in pairs(G.P_BLINDS) do
    blind_tab[#blind_tab+1] = v
  end

  table.sort(blind_tab, function (a, b) return a.order < b.order end)

  local blinds_to_be_alerted = {}
  for k, v in ipairs(blind_tab) do
    local discovered = v.discovered
    local temp_blind = AnimatedSprite(0,0,1.3,1.3, G.ANIMATION_ATLAS['blind_chips'], discovered and v.pos or G.b_undiscovered.pos)
    temp_blind:define_draw_steps({
      {shader = 'dissolve', shadow_height = 0.05},
      {shader = 'dissolve'}
    })
    if k == 1 then 
      G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = (function()
          G.CONTROLLER:snap_to{node = temp_blind}
            return true
        end)
      }))
    end
    temp_blind.float = true
    temp_blind.states.hover.can = true
    temp_blind.states.drag.can = false
    temp_blind.states.collide.can = true
    temp_blind.config = {blind = v, force_focus = true}
    if discovered and not v.alerted then 
      blinds_to_be_alerted[#blinds_to_be_alerted+1] = temp_blind
    end
    temp_blind.hover = function()
      if not G.CONTROLLER.dragging.target or G.CONTROLLER.using_touch then 
          if not temp_blind.hovering and temp_blind.states.visible then
            temp_blind.hovering = true
            temp_blind.hover_tilt = 3
            temp_blind:juice_up(0.05, 0.02)
            play_sound('chips1', math.random()*0.1 + 0.55, 0.12)
            temp_blind.config.h_popup = create_UIBox_blind_popup(v, discovered)
            temp_blind.config.h_popup_config ={align = 'cl', offset = {x=-0.1,y=0},parent = temp_blind}
            Node.hover(temp_blind)
            if temp_blind.children.alert then 
              temp_blind.children.alert:remove()
              temp_blind.children.alert = nil
              temp_blind.config.blind.alerted = true
              G:save_progress()
            end
          end
      end
    temp_blind.stop_hover = function() temp_blind.hovering = false; Node.stop_hover(temp_blind); temp_blind.hover_tilt = 0 end
  end
    blind_matrix[math.ceil((k-1)/5+0.001)][1+((k-1)%5)] = {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
      (k==6 or k ==16 or k == 26) and {n=G.UIT.B, config={h=0.2,w=0.5}} or nil,
      {n=G.UIT.O, config={object = temp_blind, focus_with_object = true}},
      (k==5 or k ==15 or k == 25) and {n=G.UIT.B, config={h=0.2,w=0.5}} or nil,
    }}
  end

  G.E_MANAGER:add_event(Event({
    trigger = 'immediate',
    func = (function()
        for _, v in ipairs(blinds_to_be_alerted) do
          v.children.alert = UIBox{
            definition = create_UIBox_card_alert(), 
            config = { align="tri", offset = {x = 0.1, y = 0.1}, parent = v}
          }
          v.children.alert.states.collide.can = false
        end
        return true
    end)
  }))

  local ante_amounts = {}
  for i = 1, math.min(16, math.max(16, G.PROFILES[G.SETTINGS.profile].high_scores.furthest_ante.amt)) do 
    local spacing = 1 - math.min(20, math.max(15, G.PROFILES[G.SETTINGS.profile].high_scores.furthest_ante.amt))*0.06
    if spacing > 0 and i > 1 then 
      ante_amounts[#ante_amounts+1] = {n=G.UIT.R, config={minh = spacing}, nodes={}}
    end
    local blind_chip = Sprite(0,0,0.2,0.2,G.ASSET_ATLAS["ui_"..(G.SETTINGS.colourblind_option and 2 or 1)], {x=0, y=0})
      blind_chip.states.drag.can = false
      ante_amounts[#ante_amounts+1] = {n=G.UIT.R, config={align = "cm", padding = 0.03}, nodes={
        {n=G.UIT.C, config={align = "cm", minw = 0.7}, nodes={
          {n=G.UIT.T, config={text = i, scale = 0.4, colour = G.C.FILTER, shadow = true}},
        }},
        {n=G.UIT.C, config={align = "cr", minw = 2.8}, nodes={
          {n=G.UIT.O, config={object = blind_chip}},
          {n=G.UIT.C, config={align = "cm", minw = 0.03, minh = 0.01}, nodes={}},
          {n=G.UIT.T, config={text =number_format(get_blind_amount(i)), scale = 0.4, colour = i <= G.PROFILES[G.SETTINGS.profile].high_scores.furthest_ante.amt and G.C.RED or G.C.JOKER_GREY, shadow = true}},
        }}
      }}
  end
  
  local extras = nil
  local t = create_UIBox_generic_options({ back_func = exit or 'your_collection', contents = {
   {n=G.UIT.R, config={align = "cm"}, nodes = {
    {n=G.UIT.C, config={align = "cm", r = 0.1, colour = G.C.BLACK, padding = 0.1, emboss = 0.05}, nodes={
      {n=G.UIT.C, config={align = "cm", r = 0.1, colour = G.C.L_BLACK, padding = 0.1, force_focus = true, focus_args = {nav = 'tall'}}, nodes={
        {n=G.UIT.R, config={align = "cm", padding = 0.05}, nodes={
          {n=G.UIT.C, config={align = "cm", minw = 0.7}, nodes={
            {n=G.UIT.T, config={text = localize('k_ante_cap'), scale = 0.4, colour = lighten(G.C.FILTER, 0.2), shadow = true}},
          }},
          {n=G.UIT.C, config={align = "cr", minw = 2.8}, nodes={
            {n=G.UIT.T, config={text = localize('k_base_cap'), scale = 0.4, colour = lighten(G.C.RED, 0.2), shadow = true}},
          }}
        }},
        {n=G.UIT.R, config={align = "cm"}, nodes=ante_amounts}
    }},
    {n=G.UIT.C, config={align = "cm"}, nodes={
      {n=G.UIT.R, config={align = "cm"}, nodes={
        {n=G.UIT.R, config={align = "cm"}, nodes=blind_matrix[1]},
        {n=G.UIT.R, config={align = "cm"}, nodes=blind_matrix[2]},
        {n=G.UIT.R, config={align = "cm"}, nodes=blind_matrix[3]},
        {n=G.UIT.R, config={align = "cm"}, nodes=blind_matrix[4]},
        {n=G.UIT.R, config={align = "cm"}, nodes=blind_matrix[5]},
        {n=G.UIT.R, config={align = "cm"}, nodes=blind_matrix[6]},
      }}
    }}
   }},
  }},
  {n=G.UIT.R, config={align = "cm"}, nodes={
    levels('blinds')
  }} 
  }})
  return t
end





-- DESCRIPTIONS

-- "remove Negative from copy" is now local
G.localization.descriptions.Other.remove_negative = {
  name = "n",
  text = {}
}


-- BLIND DESCRIPTIONS

function blind_desc(blind_lvl, probability)
  if not probability then
    probability = 1
  end

  -- The Hook
  if blind_lvl <= 0 then
    G.localization.descriptions.Blind.bl_hook = {
      name = "The Hook",
      text = {
        "(lvl."..blind_lvl..")",
        "Boss disabled"
      }
    }
  elseif blind_lvl >= 1 then
    G.localization.descriptions.Blind.bl_hook = {
      name = "The Hook",
      text = {
        "(lvl."..blind_lvl..")",
        "Discards "..(blind_lvl+1).." random",
        "cards per hand played"
      }
    }
  end

  -- The Tooth
  if blind_lvl <= -1 then
    G.localization.descriptions.Blind.bl_tooth = {
      name = "The Tooth",
      text = {
        "(lvl."..blind_lvl..")",
        "Gain $"..(-blind_lvl).." per",
        "card played"
      }
    }
  elseif blind_lvl == 0 then
    G.localization.descriptions.Blind.bl_tooth = {
      name = "The Tooth",
      text = {
        "(lvl."..blind_lvl..")",
        "Boss disabled"
      }
    }
  elseif blind_lvl >= 1 then
    G.localization.descriptions.Blind.bl_tooth = {
      name = "The Tooth",
      text = {
        "(lvl."..blind_lvl..")",
        "Lose $"..(blind_lvl).." per",
        "card played"
      }
    }
  end

  -- Water
  if blind_lvl <= -1 then
    G.localization.descriptions.Blind.bl_water = {
      name = "The Water",
      text = {
        "(lvl."..blind_lvl..")",
        "+"..-blind_lvl.." discard"
      }
    }
  elseif blind_lvl == 0 then
    G.localization.descriptions.Blind.bl_water = {
      name = "The Water",
      text = {
        "(lvl."..blind_lvl..")",
        "Boss disabled"
      }
    }
  elseif blind_lvl >= 1 then
    G.localization.descriptions.Blind.bl_water = {
      name = "The Water",
      text = {
        "(lvl."..blind_lvl..")",
        "Start with",
        "0 discards"
      }
    }
  end

  -- Needle
  if blind_lvl <= -1 then
    G.localization.descriptions.Blind.bl_needle = {
      name = "The Needle",
      text = {
        "(lvl."..blind_lvl..")",  
        "+"..-blind_lvl.." hands"
      }
    }
  elseif blind_lvl == 0 then
    G.localization.descriptions.Blind.bl_needle = {
      name = "The Needle",
      text = {
        "(lvl."..blind_lvl..")",
        "Boss disabled"
      }
    }
  elseif blind_lvl >= 1 then
    G.localization.descriptions.Blind.bl_needle = {
      name = "The Needle",
      text = {
        "(lvl."..blind_lvl..")",
        "Play only 1 hand"
      }
    }
  end

  -- Arm
  if blind_lvl <= -1 then
    G.localization.descriptions.Blind.bl_arm = {
      name = "The Arm",
      text = {
        "(lvl."..blind_lvl..")",    
        "Upgrade played poker",
        "hand by "..-blind_lvl.." levels"
      }
    }
  elseif blind_lvl == 0 then
    G.localization.descriptions.Blind.bl_arm = {
      name = "The Arm",
      text = {
        "(lvl."..blind_lvl..")",
        "Boss disabled"
      }
    }
  elseif blind_lvl >= 1 then
    G.localization.descriptions.Blind.bl_arm = {
      name = "The Arm",
      text = {
        "(lvl."..blind_lvl..")",
        "Decrease level of played",
        "poker hand by "..blind_lvl.." levels"
      }
    }
  end

  -- Manacle
  if blind_lvl <= -1 then
    G.localization.descriptions.Blind.bl_manacle = {
      name = "The Manacle",
      text = {
        "(lvl."..blind_lvl..")",    
        "+"..-blind_lvl.." hand size"
      }
    }
  elseif blind_lvl == 0 then
    G.localization.descriptions.Blind.bl_manacle = {
      name = "The Manacle",
      text = {
        "(lvl."..blind_lvl..")",
        "Boss disabled"
      }
    }
  elseif blind_lvl >= 1 then
    G.localization.descriptions.Blind.bl_manacle = {
      name = "The Manacle",
      text = {
        "(lvl."..blind_lvl..")",
        "-"..math.min(2, blind_lvl).." hand size"
      }
    }
  end

  -- Wall
  if blind_lvl <= -1 then
    G.localization.descriptions.Blind.bl_wall = {
      name = "The Wall",
      text = {
        "(lvl."..blind_lvl..")",  
        "1/"..2^(-blind_lvl).."X blind size"
      }
    }
  elseif blind_lvl == 0 then
    G.localization.descriptions.Blind.bl_wall = {
      name = "The Wall",
      text = {
        "(lvl."..blind_lvl..")",
        "Boss disabled"
      }
    }
  elseif blind_lvl >= 1 then
    G.localization.descriptions.Blind.bl_wall = {
      name = "The Wall",
      text = {
        "(lvl."..blind_lvl..")",
        (blind_lvl+1).."X blind size"
      }
    }
  end

  -- Violet Vessel
  if blind_lvl <= -1 then
    G.localization.descriptions.Blind.bl_final_vessel = {
      name = "Violet Vessel",
      text = {
        "(lvl."..blind_lvl..")",   
        "1/"..3^(-blind_lvl).."X blind size"
      }
    }
  elseif blind_lvl == 0 then
    G.localization.descriptions.Blind.bl_final_vessel = {
      name = "Violet Vessel",
      text = {
        "(lvl."..blind_lvl..")",
        "Boss disabled"
      }
    }
  elseif blind_lvl >= 1 then
    G.localization.descriptions.Blind.bl_final_vessel = {
      name = "Violet Vessel",
      text = {
        "(lvl."..blind_lvl..")",
        ((blind_lvl*2)+1).."X blind size"
      }
    }
  end

  -- The Serpent
  if blind_lvl <= 0 then
    G.localization.descriptions.Blind.bl_serpent = {
      name = "The Serpent",
      text = {
        "(lvl."..blind_lvl..")",
        "Boss disabled"
      }
    }
  elseif blind_lvl >= 1 then
    G.localization.descriptions.Blind.bl_serpent = {
      name = "The Serpent",
      text = {
        "(lvl."..blind_lvl..")",
        "After Play or Discard,",
        "always draw "..(blind_lvl+2).." cards"
      }
    }
  end

  -- Debuff bosses
  if blind_lvl <= -1 then
    G.localization.descriptions.Blind.bl_head = {
      name = "The Head",
      text = {
        "(lvl."..blind_lvl..")",
        "All Heart cards",
        "are retriggered"
      }
    }
    G.localization.descriptions.Blind.bl_goad = {
      name = "The Goad",
      text = {
        "(lvl."..blind_lvl..")",
        "All Spade cards",
        "are retriggered"
      }
    }
    G.localization.descriptions.Blind.bl_window = {
      name = "The Window",
      text = {
        "(lvl."..blind_lvl..")",
        "All Diamond cards",
        "are retriggered"
      }
    }
    G.localization.descriptions.Blind.bl_club = {
      name = "The Club",
      text = {
        "(lvl."..blind_lvl..")",
        "All Club cards",
        "are retriggered"
      }
    }
    G.localization.descriptions.Blind.bl_plant = {
      name = "The Plant",
      text = {
        "(lvl."..blind_lvl..")",
        "All face cards",
        "are retriggered"
      }
    }
    G.localization.descriptions.Blind.bl_pillar = {
      name = "The Pillar",
      text = {
        "(lvl."..blind_lvl..")",
        "All cards are",
        "retriggered"
      }
    }
    G.localization.descriptions.Blind.bl_final_leaf = {
      name = "Verdant Leaf",
      text = {
        "(lvl."..blind_lvl..")",
        "All cards are retriggered"
      }
    }
  elseif blind_lvl == 0 then
    G.localization.descriptions.Blind.bl_head = {
      name = "The Head",
      text = {
        "(lvl."..blind_lvl..")",
        "Boss disabled"
      }
    }
    G.localization.descriptions.Blind.bl_goad = {
      name = "The Goad",
      text = {
        "(lvl."..blind_lvl..")",
        "Boss disabled"
      }
    }
    G.localization.descriptions.Blind.bl_window = {
      name = "The Window",
      text = {
        "(lvl."..blind_lvl..")",
        "Boss disabled"
      }
    }
    G.localization.descriptions.Blind.bl_club = {
      name = "The Club",
      text = {
        "(lvl."..blind_lvl..")",
        "Boss disabled"
      }
    }
    G.localization.descriptions.Blind.bl_plant = {
      name = "The Plant",
      text = {
        "(lvl."..blind_lvl..")",
        "Boss disabled"
      }
    }
    G.localization.descriptions.Blind.bl_pillar = {
      name = "The Pillar",
      text = {
        "(lvl."..blind_lvl..")",
        "Boss disabled"
      }
    }
    G.localization.descriptions.Blind.bl_final_leaf = {
      name = "Verdant Leaf",
      text = {
        "(lvl."..blind_lvl..")",
        "Boss disabled"
      }
    }
  elseif blind_lvl == 1 then
    G.localization.descriptions.Blind.bl_head = {
      name = "The Head",
      text = {
        "(lvl."..blind_lvl..")",
        "All Heart cards",
        "are debuffed"
      }
    }
    G.localization.descriptions.Blind.bl_goad = {
      name = "The Goad",
      text = {
        "(Level "..blind_lvl..")",
        "All Spade cards",
        "are debuffed"
      }
    }
    G.localization.descriptions.Blind.bl_window = {
      name = "The Window",
      text = {
        "(lvl."..blind_lvl..")",
        "All Diamond cards",
        "are debuffed"
      }
    }
    G.localization.descriptions.Blind.bl_club = {
      name = "The Club",
      text = {
        "(lvl."..blind_lvl..")",
        "All Club cards",
        "are debuffed"
      }
    }
    G.localization.descriptions.Blind.bl_plant = {
      name = "The Plant",
      text = {
        "(lvl."..blind_lvl..")",
        "All face cards",
        "are debuffed"
      }
    }
    G.localization.descriptions.Blind.bl_pillar = {
      name = "The Pillar",
      text = {
        "(lvl."..blind_lvl..")",
        "Cards played previously",
        "this Ante are debuffed"
      }
    }
    G.localization.descriptions.Blind.bl_final_leaf = {
      name = "Verdant Leaf",
      text = {
        "(lvl."..blind_lvl..")",
        "All cards are debuffed",
        "until "..blind_lvl.." Jokers sold"
      }
    }
  elseif blind_lvl >= 2 then
    G.localization.descriptions.Blind.bl_head = {
      name = "The Head",
      text = {
        "(lvl."..blind_lvl..")",
        "All Heart cards are",
        "debuffed and reversed"
      }
    }
    G.localization.descriptions.Blind.bl_goad = {
      name = "The Goad",
      text = {
        "(lvl."..blind_lvl..")",
        "All Spade cards are",
        "debuffed and reversed"
      }
    }
    G.localization.descriptions.Blind.bl_window = {
      name = "The Window",
      text = {
        "(lvl."..blind_lvl..")",
        "All Diamond cards are",
        "debuffed and reversed"
      }
    }
    G.localization.descriptions.Blind.bl_club = {
      name = "The Club",
      text = {
        "(lvl."..blind_lvl..")",
        "All Club cards are",
        "debuffed and reversed"
      }
    }
    G.localization.descriptions.Blind.bl_plant = {
      name = "The Plant",
      text = {
        "(lvl."..blind_lvl..")",
        "All face cards are",
        "debuffed and reversed"
      }
    }
    G.localization.descriptions.Blind.bl_pillar = {
      name = "The Pillar",
      text = {
        "(lvl."..blind_lvl..")",
        "Cards played previously",
        "this Ante are debuffed",
        "and reversed"
      }
    }
    G.localization.descriptions.Blind.bl_final_leaf = {
      name = "Verdant Leaf",
      text = {
        "(lvl."..blind_lvl..")",
        "All cards are debuffed",
        "and reversed until",
        blind_lvl.." Jokers sold"
      }
    }
  end

  -- The Ox
  if blind_lvl <= -1 then
    G.localization.descriptions.Blind.bl_ox = {
      name = "The Ox",
      text = {
        "(lvl."..blind_lvl..")",
        "X"..(1-blind_lvl).." money when",
        "a #1# is played"
      }
    }
  elseif blind_lvl == 0 then
    G.localization.descriptions.Blind.bl_ox = {
      name = "The Ox",
      text = {
        "(lvl."..blind_lvl..")",
        "Boss disabled"
      }
    }
  elseif blind_lvl >= 1 then
    G.localization.descriptions.Blind.bl_ox = {
      name = "The Ox",
      text = {
        "(lvl."..blind_lvl..")",
        "Playing a #1#",
        "sets money to $0"
      }
    }
  end

  -- The Flint
  if blind_lvl <= -1 then
    G.localization.descriptions.Blind.bl_flint = {
      name = "The Flint",
      text = {
        "(lvl."..blind_lvl..")",
        "Base Chips and Mult",
        "are multipled by "..(-blind_lvl+1)
      }
    }
  elseif blind_lvl == 0 then
    G.localization.descriptions.Blind.bl_flint = {
      name = "The Flint",
      text = {
        "(lvl."..blind_lvl..")",
        "Boss disabled"
      }
    }
  elseif blind_lvl >= 1 then
    G.localization.descriptions.Blind.bl_flint = {
      name = "The Flint",
      text = {
        "(lvl."..blind_lvl..")",
        "Base Chips and Mult",
        "are divided by "..(blind_lvl+1)
      }
    }
  end

  -- The Mark
  if blind_lvl <= 0 then
    G.localization.descriptions.Blind.bl_mark = {
      name = "The Mark",
      text = {
        "(lvl."..blind_lvl..")",
        "Boss disabled"
      }
    }
  elseif blind_lvl >= 1 then
    G.localization.descriptions.Blind.bl_mark = {
      name = "The Mark",
      text = {
        "(lvl."..blind_lvl..")",
        "All face cards are",
        "drawn face down"
      }
    }
  end

  -- The Fish
  if blind_lvl <= 0 then
    G.localization.descriptions.Blind.bl_fish = {
      name = "The Fish",
      text = {
        "(lvl."..blind_lvl..")",
        "Boss disabled"
      }
    }
  elseif blind_lvl >= 1 then
    G.localization.descriptions.Blind.bl_fish = {
      name = "The Fish",
      text = {
        "(lvl."..blind_lvl..")",
        "Cards drawn face down",
        "after each hand played"
      }
    }
  end

  -- The House
  if blind_lvl <= 0 then
    G.localization.descriptions.Blind.bl_house = {
      name = "The House",
      text = {
        "(lvl."..blind_lvl..")",
        "Boss disabled"
      }
    }
  elseif blind_lvl >= 1 then
    G.localization.descriptions.Blind.bl_house = {
      name = "The House",
      text = {
        "(lvl."..blind_lvl..")",
        "First hand is",
        "drawn face down"
      }
    }
  end

  -- The Wheel
  if blind_lvl <= 0 then
    G.localization.descriptions.Blind.bl_wheel = {
      name = "The Wheel",
      text = {
        "(lvl."..blind_lvl..")",
        "Boss disabled"
      }
    }
  elseif blind_lvl >= 1 then
    G.localization.descriptions.Blind.bl_wheel = {
      name = "The Wheel",
      text = {
        "(lvl."..blind_lvl..")",
        probability.." in "..math.max(1, 8-blind_lvl).." cards get",
        "drawn face down"
      }
    }
  end

  -- Amber Acorn
  if blind_lvl <= 0 then
    G.localization.descriptions.Blind.bl_final_acorn = {
      name = "Amber Acorn",
      text = {
        "(lvl."..blind_lvl..")",
        "Boss disabled"
      }
    }
  elseif blind_lvl >= 1 then
    G.localization.descriptions.Blind.bl_final_acorn = {
      name = "Amber Acorn",
      text = {
        "(lvl."..blind_lvl..")",
        "Flips and shuffles",
        "all Joker cards"
      }
    }
  end

  -- Psychic
  if blind_lvl <= -1 then
    G.localization.descriptions.Blind.bl_psychic = {
      name = "The Psychic",
      text = {
        "(lvl."..blind_lvl..")",
        "Hands with 4 cards or",
        "less are retriggered"
      }
    }
  elseif blind_lvl == 0 then
    G.localization.descriptions.Blind.bl_psychic = {
      name = "The Psychic",
      text = {
        "(lvl."..blind_lvl..")",
        "Boss disabled"
      }
    }
  elseif blind_lvl >= 1 then
    G.localization.descriptions.Blind.bl_psychic = {
      name = "The Psychic",
      text = {
        "(lvl."..blind_lvl..")",
        "Must play 5 cards"
      }
    }
  end

  -- Eye
  if blind_lvl <= -1 then
    G.localization.descriptions.Blind.bl_eye = {
      name = "The Eye",
      text = {
        "(lvl."..blind_lvl..")",
        "Retrigger all cards if",
        "hand type has already",
        "been played this round"
      }
    }
  elseif blind_lvl == 0 then
    G.localization.descriptions.Blind.bl_eye = {
      name = "The Eye",
      text = {
        "(lvl."..blind_lvl..")",
        "Boss disabled"
      }
    }
  elseif blind_lvl >= 1 then
    G.localization.descriptions.Blind.bl_eye = {
      name = "The Eye",
      text = {
        "(lvl."..blind_lvl..")",
        "No repeat hand",
        "types this round"
      }
    }
  end

  -- Mouth
  if blind_lvl <= -1 then
    G.localization.descriptions.Blind.bl_mouth = {
      name = "The Mouth",
      text = {
        "(lvl."..blind_lvl..")",
        "Retrigger all cards if hand",
        "type is different from the",
        "first hand played in round"
      }
    }
  elseif blind_lvl == 0 then
    G.localization.descriptions.Blind.bl_mouth = {
      name = "The Mouth",
      text = {
        "(lvl."..blind_lvl..")",
        "Boss disabled"
      }
    }
  elseif blind_lvl >= 1 then
    G.localization.descriptions.Blind.bl_mouth = {
      name = "The Mouth",
      text = {
        "(lvl."..blind_lvl..")",
        "Play only 1 hand",
        "type this round"
      }
    }
  end

  -- Crimson Heart
  if blind_lvl <= 0 then
    G.localization.descriptions.Blind.bl_final_heart = {
      name = "Crimson Heart",
      text = {
        "(lvl."..blind_lvl..")",
        "Boss disabled"
      }
    }
  elseif blind_lvl == 1 then
    G.localization.descriptions.Blind.bl_final_heart = {
      name = "Crimson Heart",
      text = {
        "(lvl."..blind_lvl..")",
        "1 random Joker is",
        "disabled every hand"
      }
    }
  elseif blind_lvl >= 2 then
    G.localization.descriptions.Blind.bl_final_heart = {
      name = "Crimson Heart",
      text = {
        "(lvl."..blind_lvl..")",
        "Up to 2 random Jokers",
        "are disabled every hand"
      }
    }
  end

  -- Cerulean Bell
  if blind_lvl <= 0 then
    G.localization.descriptions.Blind.bl_final_bell = {
      name = "Cerulean Bell",
      text = {
        "(lvl."..blind_lvl..")",
        "Boss disabled"
      }
    }
  elseif blind_lvl == 1 then
    G.localization.descriptions.Blind.bl_final_bell = {
      name = "Cerulean Bell",
      text = {
        "(lvl."..blind_lvl..")",
        "Forces 1 card to",
        "always be selected"
      }
    }
  elseif blind_lvl >= 2 then
    G.localization.descriptions.Blind.bl_final_bell = {
      name = "Cerulean Bell",
      text = {
        "(lvl."..blind_lvl..")",
        "Forces up to 2 cards",
        "to always be selected"
      }
    }
  end

            
  
  -- Debuffed cards
  if blind_lvl >= 2 then
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
function desc(mult_lvl, xmult_lvl, chips_lvl, econ_lvl, effect_lvl, tarot_lvl, planet_lvl, spectral_lvl, enhance_lvl, edition_lvl, pack_lvl, tag_lvl, voucher_lvl, blind_lvl)

  -- JOKERS

  -- MULT
  G.localization.descriptions.Joker.j_ceremonial = {
    name = "Ceremonial Dagger",
    text = {
      "When {C:attention}Blind{} is selected,",
      "destroy Joker to the right",
      "and permanently add {C:attention}"..(mult_lvl+1).."{} times",
      "its sell value to this {C:red}Mult",
      "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
    }
  }
  G.localization.descriptions.Joker.j_raised_fist = {
    name = "Raised Fist",
    text = {
      "Adds {C:attention}"..(mult_lvl+1).."{} times the rank",
      "of {C:attention}lowest{} ranked card",
      "held in hand to Mult"
    }
  }
  G.localization.descriptions.Joker.j_supernova = {
    name = "Supernova",
    text = {
      "Adds {C:attention}"..mult_lvl.."X{} the number of",
      "times {C:attention}poker hand{} has been",
      "played this run to Mult"
    }
  }
  G.localization.descriptions.Joker.j_swashbuckler = {
    name = "Swashbuckler",
    text = {
      "Adds {C:attention}"..1+((mult_lvl-1)/2).."{} times the sell",
      "value of all other",
      "owned {C:attention}Jokers{} to Mult",
      "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
    }
  }
  G.localization.descriptions.Joker.j_misprint = {
    name = "Misprint",
    text = {
      "{C:inactive}(min: "..(0 + ((mult_lvl-1) * 3))..", max: "..(23 + ((mult_lvl-1) * 3))..")"
    }
  }

  -- XMULT
  G.localization.descriptions.Joker.j_stencil = {
    name = "Joker Stencil",
    text = {
      "{X:red,C:white} X"..(1 + (xmult_lvl-1)*0.25).."{} Mult for each",
      "empty {C:attention}Joker{} slot",
      "{s:0.8}Joker Stencil included",
      "{C:inactive}(Currently {X:red,C:white} X#1# {C:inactive})"
    }
  }
  if xmult_lvl == 1 then
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
  elseif xmult_lvl >= 2 then
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
  if xmult_lvl == 1 then
    G.localization.descriptions.Joker.j_ancient= {
      name = "Ancient Joker",
      text = {
        "Each played card with",
        "{V:1}#2#{} suit gives",
        "{X:mult,C:white} X#1# {} Mult when scored,",
        "{s:0.8}suit changes at end of round"
      }
    }
  elseif xmult_lvl >= 2 then
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

  if xmult_lvl == 1 then
    G.localization.descriptions.Joker.j_drivers_license = {
      name = "Driver's License",
      text = {
        "{X:mult,C:white} X#1# {} Mult if you have",
        "at least {C:attention}16{} Enhanced",
        "cards in your full deck",
        "{C:inactive}(Currently {C:attention}#2#{C:inactive})"
      },
      unlock = {
        "Enhance {E:1,C:attention}#1#{} cards",
        "in your deck"
      }
    }
  elseif xmult_lvl >= 2 then
    G.localization.descriptions.Joker.j_drivers_license = {
      name = "Driver's License",
      text = {
        "Gives {X:mult,C:white} X#1# {} Mult",
        "for each {C:attention}Enhanced Card",
        "in your full deck",
        "{C:inactive}(Currently {X:mult,C:white} X#3# {C:inactive} Mult)",
      },
      unlock = {
        "Enhance {E:1,C:attention}#1#{} cards",
        "in your deck"
      }
    }
  end

  -- CHIPS
  if chips_lvl <= 2 then
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
  elseif chips_lvl >= 3 then
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
      "{s:0.8}Triggers on more bosses than in vanilla{}"
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
      "give {C:money}$"..(effect_lvl+1).."{} when scored"
    }
  }
  if econ_lvl == 1 then
    G.localization.descriptions.Joker.j_trading = {
      name = "Trading Card",
      text = {
        "If {C:attention}first discard{} of round",
        "has only {C:attention}1{} card, destroy",
        "it and earn {C:money}$#1#"
      }
    }
  elseif econ_lvl >= 2 then
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
      "abilities {C:attention}"..math.floor(1 + ((effect_lvl-1) * 0.5)).."{} times"
    }
  } 
  G.localization.descriptions.Joker.j_8_ball = {
    name = "8 Ball",
    text = {
      "{C:green}#1# in #2#{} chance for each",
      "played {C:attention}8{} to create {C:attention}"..effect_lvl,
      "{C:tarot}Tarot{} cards when scored",
      "{C:inactive}(Must have room)"
    }
  } 
  G.localization.descriptions.Joker.j_hallucination = {
    name = "Hallucination",
    text = {
      "{C:green}#1# in #2#{} chance to create",
      "{C:attention}"..effect_lvl.." {C:tarot}Tarot{} cards when any",
      "{C:attention}Booster Pack{} is opened",
      "{C:inactive}(Must have room)"
    }
  }
  G.localization.descriptions.Joker.j_dusk = {
    name = "Dusk",
    text = {
      "Retrigger all played",
      "cards in {C:attention}final hand",
      "of round {C:attention}"..math.floor(1 + ((effect_lvl-1) * 0.5)).."{} times"
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
      "{C:attention}"..math.floor(1 + ((effect_lvl-1) * 0.5)).."{} times"
    }
  }
  G.localization.descriptions.Joker.j_sock_and_buskin = {
    name = "Sock and Buskin",
    text = {
      "Retrigger all",
      "played {C:attention}face{} cards",
      "{C:attention}"..math.floor(1 + ((effect_lvl-1) * 0.5)).."{} times"
    },
    unlock = {
      "Play a total of",
      "{C:attention,E:1}#1#{} face cards",
      "{C:inactive}(#2#)"
    }
  }
  G.localization.descriptions.Joker.j_selzer= {
    name = "Seltzer",
    text = {
      "For the next {C:attention}#1#{} hands",
      "Retrigger all played",
      "cards {C:attention}"..math.floor(1 + (effect_level-1)*0.5).."{} times"
    }
  }
  G.localization.descriptions.Joker.j_superposition = {
    name = "Superposition",
    text = {
      "Create {C:attention}"..effect_lvl.." {C:tarot}Tarot{} cards if",
      "poker hand contains an",
      "{C:attention}Ace{} and a {C:attention}Straight{}",
      "{C:inactive}(Must have room)"
    }
  }
  G.localization.descriptions.Joker.j_vagabond = {
    name = "Vagabond",
    text = {
      "Create {C:attention}"..effect_lvl.." {C:purple}Tarot{} cards",
      "if hand is played",
      "with {C:money}$#1#{} or less",
    }
  }
  G.localization.descriptions.Joker.j_diet_cola = {
    name = "Diet Cola",
    text = {
      "Sell this card to",
      "create {C:attention}"..effect_lvl.."{} free",
      "{C:attention}#1#s"
    }
  }
  G.localization.descriptions.Joker.j_mr_bones = {
    name = "Mr. Bones",
    text = {
      "Prevents Death",
      "if chips scored",
      "are at least {C:attention}"..(250 / (10^effect_lvl)).."%",
      "of required chips",
      "{S:1.1,C:red,E:2}self destructs{}"
    },
    unlock = {
      "Lose {C:attention,E:1}#1#{} runs",
      "{C:inactive}(#2#)"
    }
  }
  G.localization.descriptions.Joker.j_oops = {
    name = "Oops! All 6s",
    text = {
      "Multiplies all {C:attention}listed",
      "{C:green,E:1,S:1.1}probabilities{} by {C:attention}"..(effect_lvl+1),
      "{C:inactive}(ex: {C:green}1 in "..(effect_lvl+2).."{C:inactive} -> {C:green}"..(effect_lvl+1).." in "..(effect_lvl+2).."{C:inactive})"
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
      "Create {C:attention}"..effect_lvl.." {C:tarot}Tarot{} cards",
      "when {C:attention}Blind{} is selected",
      "{C:inactive}(Must have room)"
    },
    unlock = {
      "Discover every",
      "{E:1,C:tarot}Tarot{} card"
    }
  }

  -- Perkeo
  if effect_lvl == 1 then
    G.localization.descriptions.Joker.j_perkeo = {
      name = "Perkeo",
      text = {
        "Creates a Negative copy of",
        "{C:attention}"..math.max(1, effect_lvl-1).."{} random {C:attention}consumable{}",
        "card in your possession",
        "at the end of the {C:attention}shop",
      },
      unlock = {
        "{E:1,s:1.3}?????"
      }
    }
  elseif effect_lvl >= 2 then
    G.localization.descriptions.Joker.j_perkeo = {
      name = "Perkeo",
      text = {
        "Creates {C:attention}"..math.max(1, effect_lvl-1).." {C:dark_edition}Negative{} copies of",
        "the leftmost {C:attention}consumable{}",
        "card in your possession",
        "at the end of the {C:attention}shop",
      },
      unlock = {
        "{E:1,s:1.3}?????"
      }
    }
  end

  -- Riff-raff
  if effect_lvl == 1 then
    G.localization.descriptions.Joker.j_riff_raff = {
      name = "Riff-Raff",
      text = {
        "When {C:attention}Blind{} is selected,",
        "create {C:attention}#1# {C:blue}Common{C:attention} Jokers",
        "{C:inactive}(Must have room)"
      }
    }
  elseif effect_lvl >= 2 then
    G.localization.descriptions.Joker.j_riff_raff = {
      name = "Riff-Raff",
      text = {
        "When {C:attention}Blind{} is",
        "selected, create {C:attention}#1#",
        "Jokers of {C:attention}any rarity{}",
        "{C:inactive}(Must have room)"
      }
    }
  end

  -- Splash
  if effect_lvl == 1 then
    G.localization.descriptions.Joker.j_splash = {
      name = "Splash",
      text = {
        "Every {C:attention}played card",
        "counts in scoring"
      }
    }
  elseif effect_lvl >= 2 then
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

  -- Four Fingers
  if effect_lvl == 1 then
    G.localization.descriptions.Joker.j_four_fingers = {
      name = "Splash",
      text = {
        "All {C:attention}Flushes{} and",
        "{C:attention}Straights{} can be",
        "made with {C:attention}4{} cards"
      }
    }
  elseif effect_lvl >= 2 then
    G.localization.descriptions.Joker.j_four_fingers = {
      name = "Four Fingers",
      text = {
        "All {C:attention}Flushes{} and",
        "{C:attention}Straights{} can be",
        "made with {C:attention}3{} cards"
      }
    }
  end

  -- Shortcut
  if effect_lvl == 1 then
    G.localization.descriptions.Joker.j_shortcut = {
      name = "Shortcut",
      text = {
        "Allows {C:attention}Straights{} to be",
        "made with gaps of {C:attention}1 rank",
        "{C:inactive}(ex: {C:attention}10 8 6 5 3{C:inactive})"
      }
    }
  elseif effect_lvl >= 2 then
    G.localization.descriptions.Joker.j_shortcut = {
      name = "Shortcut",
      text = {
        "Allows {C:attention}Straights{} to be",
        "made with gaps of {C:attention}1 rank",
        "Straights can {C:attention}wrap around{}",
        "{C:inactive}(ex: {C:attention}5 3 2 K J{C:inactive})"
      }
    }
  end

  -- DNA
  if effect_lvl <= 2 then
    G.localization.descriptions.Joker.j_dna = {
      name = "DNA",
      text = {
        "If {C:attention}first hand{} of round",
        "has only {C:attention}1{} card, add {C:attention}"..effect_lvl,
        "permanent copies to deck",
        "and draw it to {C:attention}hand"
      }
    }
  elseif effect_lvl >= 3 then
    G.localization.descriptions.Joker.j_dna = {
      name = "DNA",
      text = {
        "If {C:attention}any played hand{} of round",
        "has only {C:attention}1{} card, add {C:attention}"..effect_lvl,
        "permanent copies to deck",
        "and draw it to {C:attention}hand"
      }
    }
  end

  -- Sixth Sense
  if effect_lvl == 1 then
    G.localization.descriptions.Joker.j_sixth_sense = {
      name = "Sixth Sense",
      text = {
        "If {C:attention}first hand{} of round is",
        "a single {C:attention}6{}, destroy it and",
        "create {C:attention}"..math.max(1, effect_lvl-1).." {C:spectral}Spectral{} cards",
        "{C:inactive}(Must have room)"
      }
    }
  elseif effect_lvl == 2 then
    G.localization.descriptions.Joker.j_sixth_sense = {
      name = "Sixth Sense",
      text = {
        "If {C:attention}any played hand{} is",
        "a single {C:attention}6{}, destroy it and",
        "create {C:attention}"..math.max(1, effect_lvl-1).." {C:spectral}Spectral{} cards",
        "{C:inactive}(Must have room)"
      }
    }
  elseif effect_lvl >= 3 then
    G.localization.descriptions.Joker.j_sixth_sense = {
      name = "Sixth Sense",
      text = {
        "If {C:attention}any played hand{} is",
        "a single {C:attention}6{}, destroy it and",
        "create {C:attention}"..math.max(1, effect_lvl-1).." {C:spectral}Spectral{} cards",
        "{C:inactive}(Must have room)",
        "{s:0.8}compatible with Blueprint and Brainstorm"
      }
    }
  end

  -- Seance
  if effect_lvl == 1 then
    G.localization.descriptions.Joker.j_seance = {
      name = "Séance",
      text = {
        "If {C:attention}poker hand{} is a",
        "{C:attention}#1#{}, create {C:attention}"..effect_lvl-1,
        "random {C:spectral}Spectral{} cards",
        "{C:inactive}(Must have room)"
      }
    }
  elseif effect_lvl >= 2 then
    G.localization.descriptions.Joker.j_seance = {
      name = "Séance",
      text = {
        "If {C:attention}poker hand{} is a",
        "{C:attention}#1#{}, create {C:attention}"..effect_lvl-1,
        "random {C:spectral}Spectral{} cards",
        "{C:inactive}(Must have room)"
      }
    }
  end
  
  -- Certificate
  if effect_lvl == 1 then
    G.localization.descriptions.Joker.j_certificate = {
      name = "Certificate",
      text = {
        "When round begins,",
        "add a random {C:attention}playing",
        "{C:attention}card{} with a random",
        "{C:attention}seal{} to your hand"
      }
    }
  elseif effect_lvl == 2 then
    G.localization.descriptions.Joker.j_certificate = {
      name = "Certificate",
      text = {
        "When round begins,",
        "add a random {C:attention}playing",
        "{C:attention}card{} with a random",
        "{C:attention}enhancement{} and {C:attention}seal{} to your hand"
      }
    }
  elseif effect_lvl >= 3 then
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
  if effect_lvl <= 2 then
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
  elseif effect_lvl == 3 then
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
  elseif effect_lvl >= 4 then
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

  -- Space Joker
  G.localization.descriptions.Joker.j_space = {
    name = "Space Joker",
    text = {
      "{C:green}#1# in #2#{} chance to",
      "upgrade level of",
      "played {C:attention}poker hand{}",
      "by {C:attention}"..math.max(1, effect_level-3).."{} levels",
    }
  }

  -- Burnt Joker
  if effect_lvl <= 3 then
    G.localization.descriptions.Joker.j_burnt = {
      name = "Burnt Joker",
      text = {
        "Upgrade the level of the",
        "{C:attention}first discarded{} poker hand",
        "each round by {C:attention}"..effect_lvl.."{} levels"
      }
    }
  elseif effect_lvl >= 4 then
    G.localization.descriptions.Joker.j_burnt = {
      name = "Burnt Joker",
      text = {
        "Upgrade the level of",
        "{C:attention}any discarded{} poker",
        "hand by {C:attention}"..effect_lvl.."{} levels"
      }
    }
  end

  -- Chicot
  G.localization.descriptions.Joker.j_chicot = {
    name = "Chicot",
    text = {
      "Reduces the level",
      "of every {C:attention}boss blind",
      "by {C:attention}"..effect_lvl.."{} levels",
      "{C:inactive}(Current blind level {C:attention}"..blind_lvl.."{C:inactive}){}"
    }
  }

  -- Luchador
  G.localization.descriptions.Joker.j_luchador = {
    name = "Luchador",
    text = {
      "Sell this card to reduce ",
      "the level of current",
      "{C:attention}boss blind{} by {C:attention}"..effect_lvl.."{} levels",
      "{C:inactive}(Current blind level {C:attention}"..blind_lvl.."{C:inactive}){}"
    }
  }

  -- Pareidolia
  if effect_lvl == 1 then
    G.localization.descriptions.Joker.j_pareidolia = {
      name = "Pareidolia",
      text = {
        "All cards are",
        "considered",
        "{C:attention}face{} cards"
      }
    }
  elseif effect_lvl >= 2 then
    G.localization.descriptions.Joker.j_pareidolia = {
      name = "Pareidolia",
      text = {
        "All cards are considered",
        "{C:attention}face{} cards",
        "all cards are {C:attention}immune{}",
        "to The Plant and The Mark"
      }
    }
  end

  -- Smeared
  if effect_lvl == 1 then
    G.localization.descriptions.Joker.j_smeared = {
      name = "Smeared Joker",
      text = {
        "{C:hearts}Hearts{} and {C:diamonds}Diamonds",
        "count as the same suit,",
        "{C:spades}Spades{} and {C:clubs}Clubs",
        "count as the same suit"
      },
      unlock = {
        "Have at least {C:attention}#1#",
        "{E:1,C:attention}#2#{} in",
        "your deck"
      }
    }
  elseif effect_lvl == 2 then
    G.localization.descriptions.Joker.j_smeared = {
      name = "Smeared Joker",
      text = {
        "{C:hearts}Hearts{} and {C:diamonds}Diamonds",
        "count as the same suit,",
        "{C:spades}Spades{} and {C:clubs}Clubs",
        "count as the same suit",
        "all cards are {C:attention}immune{} to",
        "suit-debuffing bosses"
      },
      unlock = {
        "Have at least {C:attention}#1#",
        "{E:1,C:attention}#2#{} in",
        "your deck"
      }
    }
  elseif effect_lvl >= 3 then
    G.localization.descriptions.Joker.j_smeared = {
      name = "Smeared Joker",
      text = {
        "{C:attention}All suits{} count",
        "as the same suit,",
        "all cards are {C:attention}immune{} to",
        "suit-debuffing bosses"
      },
      unlock = {
        "Have at least {C:attention}#1#",
        "{E:1,C:attention}#2#{} in",
        "your deck"
      }
    }
  end
  
  -- Showman
  if effect_lvl == 1 then
    G.localization.descriptions.Joker.j_ring_master = {
      name = "Showman",
      text = {
        "{C:attention}Joker{}, {C:tarot}Tarot{}, {C:planet}Planet{},",
        "and {C:spectral}Spectral{} cards may",
        "appear multiple times"
      },
      unlock = {
        "Reach Ante",
        "level {E:1,C:attention}#1#"
      }
    }
  elseif effect_lvl >= 2 then
    G.localization.descriptions.Joker.j_ring_master = {
      name = "Showman",
      text = {
        "{C:attention}Joker{}, {C:tarot}Tarot{}, {C:planet}Planet{},",
        "and {C:spectral}Spectral{} cards may",
        "appear multiple times",
        "{C:green}"..G.GAME.probabilities.normal.." in "..math.max((30 - (effect_lvl-2)*5), 1).."{} chance to spawn",
        "a duplicate card directly"
      },
      unlock = {
        "Reach Ante",
        "level {E:1,C:attention}#1#"
      }
    }
  end

  -- Midas Mask
  if effect_lvl == 1 then
    G.localization.descriptions.Joker.j_midas_mask = {
      name = "Midas Mask",
      text = {
        "All played {C:attention}face{} cards",
        "become {C:attention}Gold{} cards",
        "when scored"
      }
    }
  elseif effect_lvl == 2 then
    G.localization.descriptions.Joker.j_midas_mask = {
      name = "Midas Mask",
      text = {
        "All played {C:attention}face{} cards",
        "become {C:attention}Gold{} cards with ",
        "{C:attention}Gold Seals{} when scored"
      }
    }
  elseif effect_lvl >= 3 then
    G.localization.descriptions.Joker.j_midas_mask = {
      name = "Midas Mask",
      text = {
        "All played {C:attention}face{} cards",
        "become {C:dark_edition}Negative {C:attention}Gold{} cards",
        "with {C:attention}Gold Seals{} when scored"
      }
    }
  end

  -- Marble Joker
  if effect_lvl == 1 then
    G.localization.descriptions.Joker.j_marble = {
      name = "Marble Joker",
      text = {
        "Adds one {C:attention}Stone{} card",
        "to deck when",
        "{C:attention}Blind{} is selected"
      }
    }
  elseif effect_lvl == 2 then
    G.localization.descriptions.Joker.j_marble = {
      name = "Marble Joker",
      text = {
        "Adds one {C:dark_edition}Negative {C:attention}Stone{}",
        "card to deck when",
        "{C:attention}Blind{} is selected"
      }
    }
  elseif effect_lvl >= 3 then
    G.localization.descriptions.Joker.j_marble = {
      name = "Marble Joker",
      text = {
        "Adds one {C:dark_edition}Negative {C:attention}Stone{}",
        "card to deck with",
        "a random {C:attention}seal{} when",
        "{C:attention}Blind{} is selected"
      }
    }
  end

  -- Astronomer
  if effect_lvl == 1 then
    G.localization.descriptions.Joker.j_astronomer = {
      name = "Astronomer",
      text = {
        "All {C:planet}Planet{} cards and",
        "{C:planet}Celestial Packs{} in",
        "the shop are {C:attention}free"
      },
      unlock = {
        "Discover every",
        "{E:1,C:planet}Planet{} card"
      }
    }
  elseif effect_lvl == 2 then
    G.localization.descriptions.Joker.j_astronomer = {
      name = "Astronomer",
      text = {
        "All {C:planet}Planet{} and {C:tarot}Tarot{} cards as",
        "well as {C:planet}Celestial{} and {C:tarot}Arcana{} Packs",
        "in the shop are {C:attention}free"
      },
      unlock = {
        "Discover every",
        "{E:1,C:planet}Planet{} card"
      }
    }
  elseif effect_lvl >= 3 then
    G.localization.descriptions.Joker.j_astronomer = {
      name = "Astronomer",
      text = {
        "All {C:attention}consumable{} cards and",
        "{C:attention}Booster Packs{} in",
        "the shop are {C:attention}free"
      },
      unlock = {
        "Discover every",
        "{E:1,C:planet}Planet{} card"
      }
    }
  end


  -- CONSUMABLES

  -- TAROTS

  -- Fool, Death, and Strength
  if tarot_lvl == 1 then
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
    G.localization.descriptions.Tarot.c_strength = {
      name = "Strength",
      text = {
        "Increases rank of",
        "up to {C:attention}#1#{} selected",
        "cards by {C:attention}1"
      }
    }
  elseif tarot_lvl >= 2 then
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
    G.localization.descriptions.Tarot.c_strength = {
      name = "Strength",
      text = {
        "{C:attention}Use{} this card to increase rank",
        "of up to {C:attention}#1#{} selected cards by {C:attention}1",
        "{C:attention}Sell{} this card to decrease rank",
        "of up to {C:attention}#1#{} selected cards by {C:attention}1",
      }
    }
  end

  -- Hermit and Temperance
  G.localization.descriptions.Tarot.c_hermit = {
    name = "The Hermit",
    text = {
      "{X:money,C:white} X"..(2 + (tarot_lvl-1)/2).." {} money",
      "{C:inactive}(Max of {C:money}$#1#{C:inactive})"
    }
  }
  G.localization.descriptions.Tarot.c_temperance = {
    name = "Temperance",
    text = {
      "Gives {X:money,C:white} X"..(1 + (tarot_lvl-1)/2).."{} the total sell",
      "value of all current",
      "Jokers {C:inactive}(Max of {C:money}$#1#{C:inactive})",
      "{C:inactive}(Currently {C:money}$#2#{C:inactive})"
    }
  }
  
  -- Wheel of Fortune
  if tarot_lvl == 1 then
    G.localization.descriptions.Tarot.c_wheel_of_fortune = {
      name = "The Wheel of Fortune",
      text = {
        "{C:green}#1# in #2#{} chance to add {C:dark_edition}Foil{} {C:inactive}("..(50-(10*(tarot_lvl-1))).."%){},",
        "{C:dark_edition}Holographic{} {C:inactive}("..(35-(5*(tarot_lvl-1))).."%){}, or {C:dark_edition}Polychrome{} {C:inactive}("..(15+(15*(tarot_lvl-1))).."%)",
        "to a random {C:attention}Joker"
      }
    }
  elseif tarot_lvl == 2 then
    G.localization.descriptions.Tarot.c_wheel_of_fortune = {
      name = "The Wheel of Fortune",
      text = {
        "{C:green}#1# in #2#{} chance to add {C:dark_edition}Foil{} {C:inactive}("..(50-(10*(tarot_lvl-1))).."%){},",
        "{C:dark_edition}Holographic{} {C:inactive}("..(35-(5*(tarot_lvl-1))).."%){}, or {C:dark_edition}Polychrome{} {C:inactive}("..(15+(15*(tarot_lvl-1))).."%)",
        "to a random {C:attention}Joker"
      }
    }
  elseif tarot_lvl == 3 then
    G.localization.descriptions.Tarot.c_wheel_of_fortune = {
      name = "The Wheel of Fortune",
      text = {
        "{C:green}#1# in #2#{} chance to add {C:dark_edition}Foil{} {C:inactive}("..(50-(10*(tarot_lvl-1))).."%){},",
        "{C:dark_edition}Holographic{} {C:inactive}("..(35-(5*(tarot_lvl-1))).."%){}, or {C:dark_edition}Polychrome{} {C:inactive}("..(15+(15*(tarot_lvl-1))).."%)",
        "the leftmost {C:attention}Joker"
      }
    }
  elseif tarot_lvl >= 4 then
    G.localization.descriptions.Tarot.c_wheel_of_fortune = {
      name = "The Wheel of Fortune",
      text = {
        "{C:green}#1# in #2#{} chance to add {C:dark_edition}Foil{} {C:inactive}("..(50-(10*(tarot_lvl-1))).."%){},",
        "{C:dark_edition}Holographic{} {C:inactive}("..(35-(5*(tarot_lvl-1))).."%){}, or {C:dark_edition}Polychrome{} {C:inactive}("..(15+(15*(tarot_lvl-1))).."%)",
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
      "Creates up to {C:attention}"..tarot_lvl,
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
      "by {C:attention}"..planet_lvl.."{} levels",
      "{C:mult}+"..1*planet_lvl.."{} Mult and",
      "{C:chips}+"..15*planet_lvl.."{} chips"
    }
  }
  G.localization.descriptions.Planet.c_venus = {
    name = "Venus",
    text = {
      "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
      "{C:attention}#2#{}",
      "by {C:attention}"..planet_lvl.."{} levels",
      "{C:mult}+"..2*planet_lvl.."{} Mult and",
      "{C:chips}+"..20*planet_lvl.."{} chips"
    }
  }
  G.localization.descriptions.Planet.c_earth = {
    name = "Earth",
    text = {
      "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
      "{C:attention}#2#{}",
      "by {C:attention}"..planet_lvl.."{} levels",
      "{C:mult}+"..2*planet_lvl.."{} Mult and",
      "{C:chips}+"..25*planet_lvl.."{} chips"
    }
  }
  G.localization.descriptions.Planet.c_mars = {
    name = "Mars",
    text = {
      "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
      "{C:attention}#2#{}",
      "by {C:attention}"..planet_lvl.."{} levels",
      "{C:mult}+"..3*planet_lvl.."{} Mult and",
      "{C:chips}+"..30*planet_lvl.."{} chips"
    }
  }
  G.localization.descriptions.Planet.c_jupiter = {
    name = "Jupiter",
    text = {
      "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
      "{C:attention}#2#{}",
      "by {C:attention}"..planet_lvl.."{} levels",
      "{C:mult}+"..2*planet_lvl.."{} Mult and",
      "{C:chips}+"..15*planet_lvl.."{} chips"
    }
  }
  G.localization.descriptions.Planet.c_saturn = {
    name = "Saturn",
    text = {
      "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
      "{C:attention}#2#{}",
      "by {C:attention}"..planet_lvl.."{} levels",
      "{C:mult}+"..3*planet_lvl.."{} Mult and",
      "{C:chips}+"..30*planet_lvl.."{} chips"
    }
  }
  G.localization.descriptions.Planet.c_uranus = {
    name = "Uranus",
    text = {
      "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
      "{C:attention}#2#{}",
      "by {C:attention}"..planet_lvl.."{} levels",
      "{C:mult}+"..1*planet_lvl.."{} Mult and",
      "{C:chips}+"..20*planet_lvl.."{} chips"
    }
  }
  G.localization.descriptions.Planet.c_neptune = {
    name = "Neptune",
    text = {
      "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
      "{C:attention}#2#{}",
      "by {C:attention}"..planet_lvl.."{} levels",
      "{C:mult}+"..4*planet_lvl.."{} Mult and",
      "{C:chips}+"..40*planet_lvl.."{} chips"
    }
  }
  G.localization.descriptions.Planet.c_pluto = {
    name = "Pluto",
    text = {
      "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
      "{C:attention}#2#{}",
      "by {C:attention}"..planet_lvl.."{} levels",
      "{C:mult}+"..1*planet_lvl.."{} Mult and",
      "{C:chips}+"..10*planet_lvl.."{} chips"
    }
  }
  G.localization.descriptions.Planet.c_planet_x = {
    name = "Planet X",
    text = {
      "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
      "{C:attention}#2#{}",
      "by {C:attention}"..planet_lvl.."{} levels",
      "{C:mult}+"..3*planet_lvl.."{} Mult and",
      "{C:chips}+"..35*planet_lvl.."{} chips"
    }
  }
  G.localization.descriptions.Planet.c_ceres = {
    name = "Ceres",
    text = {
      "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
      "{C:attention}#2#{}",
      "by {C:attention}"..planet_lvl.."{} levels",
      "{C:mult}+"..4*planet_lvl.."{} Mult and",
      "{C:chips}+"..40*planet_lvl.."{} chips"
    }
  }
  G.localization.descriptions.Planet.c_eris = {
    name = "Eris",
    text = {
      "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
      "{C:attention}#2#{}",
      "by {C:attention}"..planet_lvl.."{} levels",
      "{C:mult}+"..3*planet_lvl.."{} Mult and",
      "{C:chips}+"..50*planet_lvl.."{} chips"
    }
  }


  -- SPECTRALS

  -- Familiar
  if spectral_lvl == 1 then
    G.localization.descriptions.Spectral.c_familiar = {
      name = "Familiar",
      text = {
        "Destroy {C:attention}1{} random",
        "card in your hand, add",
        "{C:attention}#1#{} random {C:attention}Enhanced face",
        "{C:attention}cards{} to your hand"
      }
    }
  elseif spectral_lvl == 2 then
    G.localization.descriptions.Spectral.c_familiar = {
      name = "Familiar",
      text = {
        "Destroy up to {C:attention}"..math.min(math.max(3, spectral_lvl), 5).."{} selected",
        "cards in hand, and add a random",
        "{C:attention}Enhanced{} card with an {C:attention}Edition{}",
        "to hand for each destroyed card"
      }
    }
  elseif spectral_lvl >= 3 then
    G.localization.descriptions.Spectral.c_familiar = {
      name = "Familiar",
      text = {
        "Destroy up to {C:attention}"..math.min(math.max(3, spectral_lvl), 5).."{} selected cards",
        "in hand, and add a random {C:attention}Enhanced{}",
        "card with an {C:attention}Edition{} and {C:attention}Seal{}",
        "to hand for each destroyed card"
      }
    }
  end

  -- Incantation
  if spectral_lvl == 1 then
    G.localization.descriptions.Spectral.c_incantation = {
      name = "Incantation",
      text = {
        "Destroy {C:attention}1{} random",
        "card in your hand, add {C:attention}#1#",
        "random {C:attention}Enhanced numbered",
        "{C:attention}cards{} to your hand"
      }
    }
  elseif spectral_lvl >= 2 then
    G.localization.descriptions.Spectral.c_incantation = {
      name = "Incantation",
      text = {
        "Select {C:attention}1{} card,",
        "{C:green}"..G.GAME.probabilities.normal.." in "..(math.floor(100*math.max((2 - (effect_lvl-2)/3), 1) + 0.5) / 100).." {}chance to",
        "add {C:dark_edition}Negative{} to card,",
        "otherwise destroy card"
      }
    }
  end

  -- Grim
  if spectral_lvl == 1 then
    G.localization.descriptions.Spectral.c_grim = {
      name = "Grim",
      text = {
        "Destroy {C:attention}1{} random",
        "card in your hand,",
        "add {C:attention}#1#{} random {C:attention}Enhanced",
        "{C:attention}Aces{} to your hand"
      }
    }
  elseif spectral_lvl >= 2 then
    G.localization.descriptions.Spectral.c_grim = {
      name = "Grim",
      text = {
        "Gives {C:attention}"..(spectral_lvl-1).."{} random tags"
      }
    }
  end

  -- Aura
  if spectral_lvl <= 2 then
    G.localization.descriptions.Spectral.c_aura = {
      name = "Aura",
      text = {
        "Add {C:dark_edition}Foil{} {C:inactive}("..math.max(0, (50-(10*(spectral_lvl-1)))).."%){}, {C:dark_edition}Holographic{} {C:inactive}("..math.max(0, (35-(5*(spectral_lvl-1)))).."%){},",
        "or {C:dark_edition}Polychrome{} {C:inactive}("..math.min(100, (15+(15*(spectral_lvl-1)))).."%){} edition to",
        "{C:attention}"..math.min(5, spectral_lvl).."{} selected cards in hand"
      }
    }
  elseif spectral_lvl >= 3 then
    G.localization.descriptions.Spectral.c_aura = {
      name = "Aura",
      text = {
        "Add {C:dark_edition}Foil{} {C:inactive}("..math.max(0, (50-(10*(spectral_lvl-1)))).."%){}, {C:dark_edition}Holographic{} {C:inactive}("..math.max(0, (35-(5*(spectral_lvl-1)))).."%){},",
        "or {C:dark_edition}Polychrome{} {C:inactive}("..math.min(100, (15+(15*(spectral_lvl-1)))).."%){} edition to",
        "{C:attention}"..math.min(5, spectral_lvl).."{} selected cards in hand",
        "Editions can be overwritten"
      }
    }
  end

  -- Wraith
  if spectral_lvl <= 3 then
    G.localization.descriptions.Spectral.c_wraith = {
      name = "Wraith",
      text = {
        "Creates a random",
        "{C:red}Rare{C:attention} Joker{},",
        "{X:money,C:white} X"..(math.floor((spectral_lvl-1)*100/3 + 0.4)/100).." {} money"
      }
    }
  elseif spectral_lvl >= 4 then
    G.localization.descriptions.Spectral.c_wraith = {
      name = "Wraith",
      text = {
        "Creates a random",
        "{C:red}Rare{C:attention} Joker{}",
      }
    }
  end

  -- Sigil
  if spectral_lvl == 1 then
    G.localization.descriptions.Spectral.c_sigil = {
      name = "Sigil",
      text = {
        "Converts all cards",
        "in hand to a single",
        "random {C:attention}suit"
      }
    }
  elseif spectral_lvl >= 2 then
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
  if spectral_lvl == 1 then
    G.localization.descriptions.Spectral.c_ouija = {
      name = "Ouija",
      text = {
        "Converts all cards",
        "in hand to a single",
        "random {C:attention}rank",
        "{C:red}-1{} hand size"
      }
    }
  elseif spectral_lvl == 2 then
    G.localization.descriptions.Spectral.c_ouija = {
      name = "Ouija",
      text = {
        "Converts all cards",
        "in hand to a single",
        "random {C:attention}rank",
      }
    }
  elseif spectral_lvl >= 3 then
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
  if spectral_lvl == 1 then
    G.localization.descriptions.Spectral.c_ectoplasm = {
      name = "Ectoplasm",
      text = {
        "Add {C:dark_edition}Negative{} to",
        "a random {C:attention}Joker,",
        "{C:red}-#1#{} hand size"
      }
    }
  elseif spectral_lvl == 2 then
    G.localization.descriptions.Spectral.c_ectoplasm = {
      name = "Ectoplasm",
      text = {
        "Add {C:dark_edition}Negative{} to",
        "a random {C:attention}Joker"
      }
    }
  elseif spectral_lvl == 3 then
    G.localization.descriptions.Spectral.c_ectoplasm = {
      name = "Ectoplasm",
      text = {
        "Add {C:dark_edition}Negative{} to",
        "the leftmost {C:attention}Joker"
      }
    }
  elseif spectral_lvl >= 4 then
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
  if spectral_lvl == 1 then
    G.localization.descriptions.Spectral.c_immolate = {
      name = "Immolate",
      text = {
        "Destroys {C:attention}#1#{} random",
        "cards in hand,",
        "gain {C:money}$#2#"
      }
    }
  elseif spectral_lvl >= 2 then
    G.localization.descriptions.Spectral.c_immolate = {
      name = "Immolate",
      text = {
        "Destroy up to {C:attention}5{} selected",
        "cards in hand, and gain {C:money}$"..(spectral_lvl+1)*2,
        "for each card destroyed"
      }
    }
  end

  -- Ankh
  if spectral_lvl == 1 then
    G.localization.descriptions.Spectral.c_ankh = {
      name = "Ankh",
      text = {
        "Create a copy of a",
        "random {C:attention}Joker{}, destroy",
        "all other Jokers",
        "{C:inactive,s:0.9}(Removes {C:dark_edition,s:0.9}Negative{C:inactive,s:0.9} from copy)"
      }
    }
  elseif spectral_lvl == 2 then
    G.localization.descriptions.Spectral.c_ankh = {
      name = "Ankh",
      text = {
        "Create a copy of",
        "a random {C:attention}Joker{}",
        "{C:inactive,s:0.9}(Removes {C:dark_edition,s:0.9}Negative{C:inactive,s:0.9} from copy)"
      }
    }
  elseif spectral_lvl == 3 then
    G.localization.descriptions.Spectral.c_ankh = {
      name = "Ankh",
      text = {
        "Create a copy of",
        "the leftmost {C:attention}Joker{}",
        "{C:inactive,s:0.9}(Removes {C:dark_edition,s:0.9}Negative{C:inactive,s:0.9} from copy)"
      }
    }
  elseif spectral_lvl >= 4 then
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
  if spectral_lvl == 1 then
    G.localization.descriptions.Spectral.c_hex = {
      name = "Hex",
      text = {
        "Add {C:dark_edition}Polychrome{} to",
        "random {C:attention}Joker{}, destroy",
        "all other Jokers"
      }
    }
  elseif spectral_lvl == 2 then
    G.localization.descriptions.Spectral.c_hex = {
      name = "Hex",
      text = {
        "Add {C:dark_edition}Polychrome{} to",
        "a random {C:attention}Joker"
      }
    }
  elseif spectral_lvl == 3 then
    G.localization.descriptions.Spectral.c_hex = {
      name = "Hex",
      text = {
        "Add {C:dark_edition}Polychrome{} to",
        "the leftmost {C:attention}Joker"
      }
    }
  elseif spectral_lvl >= 4 then
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
  if spectral_lvl == 1 then
    G.localization.descriptions.Spectral.c_soul = {
      name = "The Soul",
      text = {
        "Creates a",
        "{C:legendary,E:1}Legendary{} Joker",
        "{C:inactive}(Must have room)"
      }
    }
  elseif spectral_lvl >= 2 then
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
      "by {C:attention}"..(2*spectral_lvl - 1).."{} levels"
    }
  }

  -- Seal-generating spectrals
  G.localization.descriptions.Spectral.c_talisman = {
  name = "Talisman",
    text = {
      "Add a {C:attention}Gold Seal{}",
      "to {C:attention}"..math.min(5, spectral_lvl).."{} selected",
      "cards in your hand"
    }
  }
  G.localization.descriptions.Spectral.c_deja_vu = {
  name = "Déjà Vu",
    text = {
      "Add a {C:red}Red Seal{}",
      "to {C:attention}"..math.min(5, spectral_lvl).."{} selected",
      "cards in your hand"
    }
  }
  G.localization.descriptions.Spectral.c_trance = {
  name = "Trance",
    text = {
      "Add a {C:blue}Blue Seal{}",
      "to {C:attention}"..math.min(5, spectral_lvl).."{} selected",
      "cards in your hand"
    }
  }
  G.localization.descriptions.Spectral.c_medium = {
  name = "Medium",
    text = {
      "Add a {C:purple}Purple Seal{}",
      "to {C:attention}"..math.min(5, spectral_lvl).."{} selected",
      "cards in your hand"
    }
  }
  G.localization.descriptions.Spectral.c_cryptid = {
  name = "Cryptid",
    text = {
      "Create {C:attention}"..(spectral_lvl+1).."{} copies of",
      "{C:attention}1{} selected card",
      "in your hand"
    }
  }

  
  -- ENHANCEMENTS

  G.localization.descriptions.Enhanced.m_lucky = {
    name = "Lucky Card",
    text = {
      "{C:green}#1# in "..math.max(1, (5 - (enhance_lvl-1))).."{} chance",
      "for {C:mult}+#2#{} Mult",
      "{C:green}#1# in "..math.max(1, (15 - 2*(enhance_lvl-1))).."{} chance",
      "to win {C:money}$#4#"
    }
  }
  if enhance_lvl == 1 then
    G.localization.descriptions.Enhanced.m_wild = {
      name = "Wild Card",
      text = {
        "Can be used",
        "as any suit"
      }
    }
  elseif enhance_lvl >= 2 then
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
      "Earn {C:money}$"..(3 + (2*(edition_lvl-1))).."{} when this",
      "card is played",
      "and scores"
    }
  }
  G.localization.descriptions.Other.red_seal = {
    name = "Red Seal",
    text = {
      "Retrigger this",
      "card {C:attention}"..math.floor(1 + (edition_level-1)*0.5).."{} times"
    }
  }
  G.localization.descriptions.Other.blue_seal = {
    name = "Blue Seal",
    text = {
      "Creates {C:attention}"..edition_lvl.."{} copies of",
      "the {C:planet}Planet{} card for final",
      "played {C:attention}poker hand{} of",
      "round if {C:attention}held{} in hand",
      "{C:inactive}(Must have room)"
    }
  }
  G.localization.descriptions.Other.purple_seal = {
    name = "Purple Seal",
    text = {
      "Creates {C:attention}"..edition_lvl.."{} random {C:tarot}Tarot",
      "cards when {C:attention}discarded",
      "{C:inactive}(Must have room)"
    }
  }


  -- TAGS

  G.localization.descriptions.Tag.tag_uncommon = {
    name = "Uncommon Tag",
    text = {
      "Shop has {C:attention}"..tag_lvl.."{} free",
      "{C:green}Uncommon Jokers"
    }
  }
  G.localization.descriptions.Tag.tag_rare = {
    name = "Rare Tag",
    text = {
      "Shop has {C:attention}"..tag_lvl.."{} free",
      "{C:red}Rare Jokers"
    }
  }
  G.localization.descriptions.Tag.tag_double = {
    name = "Double Tag",
    text = {
      "Gives {C:attention}"..tag_lvl.."{} copies of the",
      "next selected {C:attention}Tag{}",
      "{s:0.8,C:attention}Double Tag{s:0.8} excluded"
    }
  }

  -- Edition tags
  if tag_lvl == 1 then
    G.localization.descriptions.Tag.tag_negative = {
      name = "Negative Tag",
      text = {
        "Next base edition shop",
        "Joker is free and",
        "becomes {C:dark_edition}Negative"
      }
    }
    G.localization.descriptions.Tag.tag_foil = {
      name = "Foil Tag",
      text = {
        "Next base edition shop",
        "Joker is free and",
        "becomes {C:dark_edition}Foil"
      }
    }
    G.localization.descriptions.Tag.tag_holo = {
      name = "Holographic Tag",
      text = {
        "Next base edition shop",
        "Joker is free and",
        "becomes {C:dark_edition}Holographic"
      }
    }
    G.localization.descriptions.Tag.tag_polychrome = {
      name = "Polychrome Tag",
      text = {
        "Next base edition shop",
        "Joker is free and",
        "becomes {C:dark_edition}Polychrome"
      }
    }
  elseif tag_lvl >= 2 then
    G.localization.descriptions.Tag.tag_negative = {
      name = "Negative Tag",
      text = {
        "Next base edition shop Joker",
        "is free and becomes {C:dark_edition}Negative",
        "Spawn {C:attention}"..(tag_lvl-1).."{} extra {C:dark_edition}Negative{} Jokers"
      }
    }
    G.localization.descriptions.Tag.tag_foil = {
      name = "Foil Tag",
      text = {
        "Next base edition shop Joker",
        "is free and becomes {C:dark_edition}Foil",
        "Spawn {C:attention}"..(tag_lvl-1).."{} extra {C:dark_edition}Foil{} Jokers"
      }
    }
    G.localization.descriptions.Tag.tag_holo = {
      name = "Holographic Tag",
      text = {
        "Next base edition shop Joker",
        "is free and becomes {C:dark_edition}Holographic",
        "Spawn {C:attention}"..(tag_lvl-1).."{} extra {C:dark_edition}Holographic{} Jokers"
      }
    }
    G.localization.descriptions.Tag.tag_polychrome = {
      name = "Polychrome Tag",
      text = {
        "Next base edition shop Joker",
        "is free and becomes {C:dark_edition}Polychrome",
        "Spawn {C:attention}"..(tag_lvl-1).."{} extra {C:dark_edition}Polychrome{} Jokers"
      }
    }
  end

  -- D6 tag
  if tag_lvl == 1 then
    G.localization.descriptions.Tag.tag_d_six = {
      name = "D6 Tag",
      text = {
        "Rerolls in next shop",
        "start at {C:money}$0"
      }
    }
  elseif tag_lvl >= 2 then
    G.localization.descriptions.Tag.tag_d_six = {
      name = "D6 Tag",
      text = {
        "Gives {C:attention}"..tag_lvl.."{} free rerolls,",
        "then rerolls start at {C:money}$1",
      }
    }
  end

  -- Coupon tag
  if tag_lvl == 1 then
    G.localization.descriptions.Tag.tag_coupon = {
      name = "Coupon Tag",
      text = {
        "Initial cards and",
        "booster packs in next",
        "shop are free"
      }
    }
  elseif tag_lvl >= 2 then
    G.localization.descriptions.Tag.tag_coupon = {
      name = "Coupon Tag",
      text = {
        "{C:attention}+"..(tag_lvl-1).."{} slots in next shop",
        "Initial cards and booster",
        "packs in next shop are free"
      }
    }
  end

  -- Top-up Tag
  if tag_lvl == 1 then
    G.localization.descriptions.Tag.tag_top_up = {
      name = "Top-up Tag",
      text = {
        "Create up to {C:attention}"..math.max(2, 1 + (tag_lvl-1)*1),
        "{C:blue}Common{} Jokers",
        "{C:inactive}(Must have room)"
      }
    }
  elseif tag_lvl >= 2 then
    G.localization.descriptions.Tag.tag_top_up = {
      name = "Top-up Tag",
      text = {
        "Create up to {C:attention}"..math.max(2, 1 + (tag_lvl-1)*1),
        "Jokers of {C:attention}any rarity",
        "{C:inactive}(Must have room)"
      }
    }
  end

  -- Voucher Tag
  if tag_lvl == 1 then
    G.localization.descriptions.Tag.tag_voucher = {
      name = "Voucher Tag",
      text = {
        "Adds {C:attention}"..tag_lvl.." {C:voucher}Vouchers",
        "to the next shop"
      }
    }
  elseif tag_lvl >= 2 then
    G.localization.descriptions.Tag.tag_voucher = {
      name = "Voucher Tag",
      text = {
        "Adds {C:attention}"..tag_lvl.." {C:voucher}Vouchers",
        "to the next shop,",
        "{C:attention}"..math.min(100, ((tag_lvl-1)*20)).."%{} off"
      }
    }
  end

  -- Pack-generating Tags
  if tag_lvl == 1 then
    G.localization.descriptions.Tag.tag_charm = {
      name = "Charm Tag",
      text = {
        "Gives a free",
        "{C:tarot}Mega Arcana Pack"
      }
    }
    G.localization.descriptions.Tag.tag_meteor = {
      name = "Meteor Tag",
      text = {
        "Gives a free",
        "{C:planet}Mega Celestial Pack"
      }
    }
    G.localization.descriptions.Tag.tag_standard = {
      name = "Standard Tag",
      text = {
        "Gives a free",
        "{C:attention}Mega Standard Pack"
      }
    }
    G.localization.descriptions.Tag.tag_buffoon = {
      name = "Buffoon Tag",
      text = {
        "Gives a free",
        "{C:attention}Mega Buffoon Pack"
      }
    }
  elseif tag_lvl >= 2 then
    G.localization.descriptions.Tag.tag_charm = {
      name = "Charm Tag",
      text = {
        "Gives a free {C:attention}+"..(tag_lvl-1).." level",
        "{C:tarot}Mega Arcana Pack"
      }
    }
    G.localization.descriptions.Tag.tag_meteor = {
      name = "Meteor Tag",
      text = {
        "Gives a free {C:attention}+"..(tag_lvl-1).." level",
        "{C:planet}Mega Celestial Pack"
      }
    }
    G.localization.descriptions.Tag.tag_standard = {
      name = "Standard Tag",
      text = {
        "Gives a free {C:attention}+"..(tag_lvl-1).." level",
        "{C:attention}Mega Standard Pack"
      }
    }
    G.localization.descriptions.Tag.tag_buffoon = {
      name = "Buffoon Tag",
      text = {
        "Gives a free {C:attention}+"..(tag_lvl-1).." level",
        "{C:attention}Mega Buffoon Pack"
      }
    }
  end
  if tag_lvl == 1 then
    G.localization.descriptions.Tag.tag_ethereal = {
      name = "Ethereal Tag",
      text = {
        "Gives a free",
        "{C:spectral}Spectral Pack"
      }
    }
  elseif tag_lvl == 2 then
    G.localization.descriptions.Tag.tag_ethereal = {
      name = "Ethereal Tag",
      text = {
        "Gives a free",
        "{C:spectral}Mega Spectral Pack"
      }
    }
  elseif tag_lvl >= 3 then
    G.localization.descriptions.Tag.tag_ethereal = {
      name = "Ethereal Tag",
      text = {
        "Gives a free {C:attention}+"..(tag_lvl-2).." level",
        "{C:spectral}Mega Spectral Pack"
      }
    }
  end

  -- Boss Tag
  if tag_lvl == 1 then
    G.localization.descriptions.Tag.tag_boss = {
      name = "Boss Tag",
      text = {
        "Rerolls the",
        "{C:attention}Boss Blind"
      }
    }
  elseif tag_lvl >= 2 then
    G.localization.descriptions.Tag.tag_boss = {
      name = "Boss Tag",
      text = {
        "Rerolls the {C:attention}Boss Blind and",
        "reduce its blind level by {C:attention}"..(tag_lvl-1)
      }
    }
  end

  G.localization.descriptions.Tag.tag_investment = {
    name = "Investment Tag",
    text = {
      "After defeating",
      "the Boss Blind,",
      "gain {C:money}$"..(25 + (tag_lvl-1)*10)
    }
  }
  G.localization.descriptions.Tag.tag_handy = {
    name = "Handy Tag",
    text = {
      "Gives {C:money}$"..(1 + (tag_lvl-1)*1).."{} per played",
      "{C:blue}hand{} this run",
      "{C:inactive}(Will give {C:money}$"..(((G and G.GAME and G.GAME.hands_played) or 0)*(1 + (tag_lvl-1)*1)).."{C:inactive})"
    }
  }
  G.localization.descriptions.Tag.tag_garbage = {
    name = "Garbage Tag",
    text = {
      "Gives {C:money}$"..(1 + (tag_lvl-1)*2).."{} per unused",
      "{C:red}discard{} this run",
      "{C:inactive}(Will give {C:money}$"..(((G and G.GAME and G.GAME.unused_discards) or 0)*(1 + (tag_lvl-1)*2)).."{C:inactive})",
    }
  }
  G.localization.descriptions.Tag.tag_juggle = {
    name = "Juggle Tag",
    text = {
      "{C:attention}+"..(3 + (tag_lvl-1)*1).."{} hand size",
      "next round"
    }
  }
  G.localization.descriptions.Tag.tag_skip = {
    name = "Speed Tag",
    text = {
      "Gives {C:money}$"..(5 + (tag_lvl-1)*5).."{} per skipped",
      "Blind this run",
      "{C:inactive}(Will give {C:money}$"..(((G and G.GAME and G.GAME.skips) or 0)*(5 + (tag_lvl-1)*5)).."{C:inactive})"
    }
  }
  G.localization.descriptions.Tag.tag_orbital = {
    name = "Orbital Tag",
    text = {
      "Upgrade {C:attention}#1#",
      "by {C:attention}"..(3 + (tag_lvl-1)*2).." levels"
    }
  }
  G.localization.descriptions.Tag.tag_economy = {
    name = "Economy Tag",
    text = {
      "{X:money,C:white} X"..(2 + (tag_lvl-1)/2).." {} money",
      "{C:inactive}(Max of {C:money}$"..(40 + (tag_lvl-1)*20).."{C:inactive})"
    }
  }


  -- VOUCHERS

  -- Overstock and Overstock Plus
  if voucher_lvl == 1 then
    G.localization.descriptions.Voucher.v_overstock_norm = {
      name = "Overstock",
      text = {
        "{C:attention}+1{} card slot",
        "available in shop"
      }
    }
    G.localization.descriptions.Voucher.v_overstock_plus = {
      name = "Overstock Plus",
      text = {
        "{C:attention}+2{} card slot",
        "available in shop"
      },
      unlock = {
        "Spend a total of",
        "{C:money}$#1#{} at the shop",
        "{C:inactive}($#2#)"
      }
    }
  elseif voucher_lvl == 2 then
    G.localization.descriptions.Voucher.v_overstock_norm = {
      name = "Overstock",
      text = {
        "{C:attention}+2{} card slot",
        "available in shop"
      }
    }
    G.localization.descriptions.Voucher.v_overstock_plus = {
      name = "Overstock Plus",
      text = {
        "{C:attention}+2{} card slot",
        "available in shop"
      },
      unlock = {
        "Spend a total of",
        "{C:money}$#1#{} at the shop",
        "{C:inactive}($#2#)"
      }
    }
  elseif voucher_lvl >= 3 then
    G.localization.descriptions.Voucher.v_overstock_norm = {
      name = "Overstock",
      text = {
        "{C:attention}+2{} card slot and",
        "{C:attention}+1{} booster pack slot",
        "available in shop"
      }
    }
    G.localization.descriptions.Voucher.v_overstock_plus = {
      name = "Overstock Plus",
      text = {
        "{C:attention}+2{} card slot and",
        "{C:attention}+1{} booster pack slot",
        "available in shop"
      },
      unlock = {
        "Spend a total of",
        "{C:money}$#1#{} at the shop",
        "{C:inactive}($#2#)"
      }
    }
  end

  G.localization.descriptions.Voucher.v_clearance_sale = {
    name = "Clearance Sale",
    text = {
      "All cards and packs in",
      "shop are {C:attention}#1#%{} off",
      "{C:inactive}(Minimum cost {C:money}$1{C:inactive})"
    }
  }
  G.localization.descriptions.Voucher.v_liquidation = {
    name = "Liquidation",
    text = {
      "All cards and packs in",
      "shop are {C:attention}#1#%{} off",
      "{C:inactive}(Minimum cost {C:money}$1{C:inactive})"
    }
  }

  -- Hone and Glow Up
  if voucher_lvl == 1 then
    G.localization.descriptions.Voucher.v_hone = {
      name = "Hone",
      text = {
        "{C:dark_edition}Foil{}, {C:dark_edition}Holographic{}, and",
        "{C:dark_edition}Polychrome{} cards",
        "appear {C:attention}#1#X{} more often",
        "{C:inactive}Foil: "..(2 - (voucher_lvl-1)*0.2).."% -> "..((2 - (voucher_lvl-1)*0.2)*(2 + (voucher_lvl-1)*0.5)).."%",
        "{C:inactive}Holographic: "..(1.4 - (voucher_lvl-1)*0.1).."% -> "..((1.4 - (voucher_lvl-1)*0.1)*(2 + (voucher_lvl-1)*0.5)).."%",
        "{C:inactive}Polychrome: "..(0.3 + (voucher_lvl-1)*0.3).."% -> "..((0.3 + (voucher_lvl-1)*0.3)*(2 + (voucher_lvl-1)*0.5)).."%",
        "{C:inactive}Negative: 0.3% -> "..(0.3*voucher_lvl).."%",
      }
    }
    G.localization.descriptions.Voucher.v_glow_up= {
      name = "Glow Up",
      text = {
        "{C:dark_edition}Foil{}, {C:dark_edition}Holographic{}, and {C:dark_edition}Polychrome{}",
        "cards appear {C:attention}#1#X{} more often",
        "{C:inactive}Foil: "..(2 - (voucher_lvl-1)*0.2).."% -> "..((2 - (voucher_lvl-1)*0.2)*(2 + (voucher_lvl-1)*0.5)).."% -> "..((2 - (voucher_lvl-1)*0.2)*(4 + (voucher_lvl-1)*0.5)).."%",
        "{C:inactive}Holographic: "..(1.4 - (voucher_lvl-1)*0.1).."% -> "..((1.4 - (voucher_lvl-1)*0.1)*(2 + (voucher_lvl-1)*0.5)).."% -> "..((1.4 - (voucher_lvl-1)*0.1)*(4 + (voucher_lvl-1)*1)).."%",
        "{C:inactive}Polychrome: "..(0.3 + (voucher_lvl-1)*0.3).."% -> "..((0.3 + (voucher_lvl-1)*0.3)*(2 + (voucher_lvl-1)*0.5)).."% -> "..((0.3 + (voucher_lvl-1)*0.3)*(4 + (voucher_lvl-1)*1)).."%",
        "{C:inactive}Negative: 0.3% -> "..(0.3*(1 + (voucher_lvl-1)*0.5)).."% -> "..(0.3*(1 + (voucher_lvl-1)*1)).."%",
      }
    }
  elseif voucher_lvl >= 2 then
    G.localization.descriptions.Voucher.v_hone = {
      name = "Hone",
      text = {
        "{C:dark_edition}Negative{} cards appear {C:attention}"..math.min(333, (1 + (voucher_lvl-1)*0.5)).."X{} more often",
        "Other {C:dark_edition}Editions{} appear {C:attention}"..math.min(math.floor((100-(0.3*(1 + (voucher_lvl-1)*0.5))) / 3.7), (2 + (voucher_lvl-1)*0.5)).."X{} more often",
        "{C:inactive}Foil: "..math.max(0, (2 - (voucher_lvl-1)*0.2)).."% -> "..math.max(0, (2 - (voucher_lvl-1)*0.2)*(2 + (voucher_lvl-1)*0.5)).."%",
        "{C:inactive}Holographic: "..math.max(0, (1.4 - (voucher_lvl-1)*0.1)).."% -> "..math.max(0, (1.4 - (voucher_lvl-1)*0.1)*(2 + (voucher_lvl-1)*0.5)).."%",
        "{C:inactive}Polychrome: "..math.min(99.7, (0.3 + (voucher_lvl-1)*0.3)).."% -> "..math.min(100 - math.min(100, (0.3*(1 + (voucher_lvl-1)*0.5))), ((0.3 + (voucher_lvl-1)*0.3)*(2 + (voucher_lvl-1)*0.5))).."%",
        "{C:inactive}Negative: 0.3% -> "..math.min(100, (0.3*(1 + (voucher_lvl-1)*0.5))).."%"
      }
    }
    G.localization.descriptions.Voucher.v_glow_up = {
      name = "Glow Up",
      text = {
        "{C:dark_edition}Negative{} cards appear {C:attention}"..math.min(333, (1 + (voucher_lvl-1)*1)).."X{} more often",
        "Other {C:dark_edition}Editions{} appear {C:attention}"..math.min(math.floor((100-(0.3*(1 + (voucher_lvl-1)*1))) / 3.7), (4 + (voucher_lvl-1)*1)).."X{} more often",
        "{C:inactive}Foil: "..math.max(0, (2 - (voucher_lvl-1)*0.2)).."% -> "..math.max(0, (2 - (voucher_lvl-1)*0.2)*(2 + (voucher_lvl-1)*0.5)).."% -> "..math.max(0, (2 - (voucher_lvl-1)*0.2)*(4 + (voucher_lvl-1)*0.5)).."%",
        "{C:inactive}Holographic: "..math.max(0, (1.4 - (voucher_lvl-1)*0.1)).."% -> "..math.max(0, (1.4 - (voucher_lvl-1)*0.1)*(2 + (voucher_lvl-1)*0.5)).."% -> "..math.max(0, (1.4 - (voucher_lvl-1)*0.1)*(4 + (voucher_lvl-1)*1)).."%",
        "{C:inactive}Polychrome: "..math.min(99.7, (0.3 + (voucher_lvl-1)*0.3)).."% -> "..math.min(100 - math.min(100, (0.3*(1 + (voucher_lvl-1)*0.5))), ((0.3 + (voucher_lvl-1)*0.3)*(2 + (voucher_lvl-1)*0.5))).."% -> "..math.min(100 - math.min(100, (0.3*(1 + (voucher_lvl-1)*1))), ((0.3 + (voucher_lvl-1)*0.3)*(4 + (voucher_lvl-1)*1))).."%",
        "{C:inactive}Negative: 0.3% -> "..math.min(100, (0.3*(1 + (voucher_lvl-1)*0.5))).."% -> "..math.min(100, (0.3*(1 + (voucher_lvl-1)*1))).."%"
      }
    }
  end

  -- Reroll Surplus and Reroll Glut
  if voucher_lvl == 1 then
    G.localization.descriptions.Voucher.v_reroll_surplus = {
      name = "Reroll Surplus",
      text = {
        "Rerolls cost",
        "{C:money}$#1#{} less"
      }
    }
    G.localization.descriptions.Voucher.v_reroll_glut = {
      name = "Reroll Glut",
      text = {
        "Rerolls cost",
        "{C:money}$#1#{} less"
      }
    }
  elseif voucher_lvl >= 2 then
    G.localization.descriptions.Voucher.v_reroll_surplus = {
      name = "Reroll Surplus",
      text = {
        "Rerolls cost {C:money}$#1#{} less",
        "Reroll costs ramp up",
        "{C:attention}"..voucher_lvl.."{} times slower"
      }
    }
    G.localization.descriptions.Voucher.v_reroll_glut = {
      name = "Reroll Glut",
      text = {
        "Rerolls cost {C:money}$#1#{} less",
        "Reroll costs ramp up",
        "{C:attention}"..(voucher_lvl^2).."{} times slower"
      }
    }
  end

  G.localization.descriptions.Voucher.v_crystal_ball = {
    name = "Crystal Ball",
    text = {
      "{C:attention}+"..voucher_lvl.."{} consumable slots"
    }
  }

  -- Omen Globe
  if voucher_lvl == 1 then
    G.localization.descriptions.Voucher.v_omen_globe = {
      name = "Omen Globe",
      text = {
        "{C:spectral}Spectral{} cards may",
        "appear in any of",
        "the {C:attention}Arcana Packs"
      },
      unlock = {
        "Use a total of {C:attention}#1#",
        "{C:tarot}Tarot{} cards from any",
        "{C:tarot}Arcana Pack",
        "{C:inactive}(#2#)"
      }
    }
  elseif voucher_lvl == 2 then
    G.localization.descriptions.Voucher.v_omen_globe = {
      name = "Omen Globe",
      text = {
        "{C:spectral}Spectral{} cards can",
        "appear in the {C:attention}shop{}",
        "and in {C:attention}Arcana Packs"
      },
      unlock = {
        "Use a total of {C:attention}#1#",
        "{C:tarot}Tarot{} cards from any",
        "{C:tarot}Arcana Pack",
        "{C:inactive}(#2#)"
      }
    }
  elseif voucher_lvl >= 3 then
    G.localization.descriptions.Voucher.v_omen_globe = {
      name = "Omen Globe",
      text = {
        "{C:spectral}Spectral{} cards appear {C:attention}"..math.min(12, (voucher_lvl-1)).."X{}",
        "more frequently in the {C:attention}shop{}",
        "{C:spectral}Spectral{} cards can also",
        "appear in {C:attention}Arcana Packs"
      },
      unlock = {
        "Use a total of {C:attention}#1#",
        "{C:tarot}Tarot{} cards from any",
        "{C:tarot}Arcana Pack",
        "{C:inactive}(#2#)"
      }
    }
  end

  -- Telescope
  if voucher_lvl == 1 then
    G.localization.descriptions.Voucher.v_telescope = {
      name = "Telescope",
      text = {
        "{C:attention}Celestial Packs{} always",
        "contain the {C:planet}Planet{}",
        "card for your most",
        "played {C:attention}poker hand"
      }
    }
  elseif voucher_lvl >= 2 then
    G.localization.descriptions.Voucher.v_telescope = {
      name = "Telescope",
      text = {
        "{C:attention}Celestial Packs{} always contain the {C:planet}Planet{}",
        "card for your most played {C:attention}poker hand",
        "Consumables in the shop can have {C:dark_edition}Foil{C:inactive} ("..((3.5*(voucher_lvl-1)) - (1.3*(voucher_lvl-2))).."%){},",
        "{C:dark_edition}Holographic{C:inactive} ("..((2.4*(voucher_lvl-1)) - (0.1*(voucher_lvl-2))).."%){}, {C:dark_edition}Polychrome{C:inactive} ("..((1.5*(voucher_lvl-1)) + (1.4*(voucher_lvl-2))).."%){}, or {C:dark_edition}Negative{C:inactive} ("..(0.6*(voucher_lvl-1)).."%)"
      }
    }
  end

  G.localization.descriptions.Voucher.v_grabber = {
    name = "Grabber",
    text = {
      "Permanently",
      "gain {C:blue}+#1#{} hands",
      "per round"
    }
  }
  G.localization.descriptions.Voucher.v_nacho_tong = {
    name = "Nacho Tong",
    text = {
      "Permanently",
      "gain {C:blue}+#1#{} hands",
      "per round"
    }
  }

  G.localization.descriptions.Voucher.v_wasteful = {
    name = "Wasteful",
    text = {
      "Permanently",
      "gain {C:red}+#1#{} discards",
      "each round"
    }
  }
  G.localization.descriptions.Voucher.v_recyclomancy = {
    name = "Recyclomancy",
    text = {
      "Permanently",
      "gain {C:red}+#1#{} discards",
      "each round"
    }
  }

  G.localization.descriptions.Voucher.v_tarot_merchant = {
    name = "Tarot Merchant",
    text = {
      "{C:tarot}Tarot{} cards appear",
      "{C:attention}"..math.max(3, (2 + (voucher_lvl-1)*0.25)).."X{} more frequently",
      "in the shop"
    }
  }
  G.localization.descriptions.Voucher.v_tarot_tycoon = {
    name = "Tarot Tycoon",
    text = {
      "{C:tarot}Tarot{} cards appear",
      "{C:attention}"..math.max(6, (4 + (voucher_lvl-1)*0.5)).."X{} more frequently",
      "in the shop"
    }
  }

  G.localization.descriptions.Voucher.v_planet_merchant = {
    name = "Planet Merchant",
    text = {
      "{C:planet}Planet{} cards appear",
      "{C:attention}"..math.max(3, (2 + (voucher_lvl-1)*0.25)).."X{} more frequently",
      "in the shop"
    }
  }
  G.localization.descriptions.Voucher.v_planet_tycoon = {
    name = "Planet Tycoon",
    text = {
      "{C:planet}Planet{} cards appear",
      "{C:attention}"..math.max(6, (4 + (voucher_lvl-1)*0.5)).."X{} more frequently",
      "in the shop"
    }
  }

  G.localization.descriptions.Voucher.v_antimatter = {
    name = "Antimatter",
    text = {
      "{C:dark_edition}+"..voucher_lvl.."{} Joker slots"
    },
    unlock = {
      "Redeem {C:voucher}Blank{}",
      "{C:attention}#1#{} total times",
      "{C:inactive}(#2#)"
    }
  }

  -- Magic Trick
  if voucher_lvl == 1 then
    G.localization.descriptions.Voucher.v_magic_trick = {
      name = "Magic Trick",
      text = {
        "{C:attention}Playing cards{} can",
        "be purchased",
        "from the {C:attention}shop"
      }
    }
  elseif voucher_lvl == 2 then
    G.localization.descriptions.Voucher.v_magic_trick = {
      name = "Magic Trick",
      text = {
        "{C:attention}Playing cards{} can appear {C:attention}"..math.max(4, (1 + (voucher_level-1)*0.5)).."X",
        "more frequently in the shop",
        "{C:attention}"..math.min(100, (12*(voucher_lvl-1))).."%{} to have an {C:enhanced}Enhancement{}"
      }
    }
  elseif voucher_lvl == 3 then
    G.localization.descriptions.Voucher.v_magic_trick = {
      name = "Magic Trick",
      text = {
        "{C:attention}Playing cards{} can appear {C:attention}"..math.max(4, (1 + (voucher_level-1)*0.5)).."X",
        "more frequently in the shop",
        "{C:attention}"..math.min(100, (12*(voucher_lvl-1))).."%{} to have an {C:enhanced}Enhancement{}",
        "{C:attention}"..math.min(100, (7*(voucher_lvl-2))).."%{} to have a non-Negative {C:dark_edition}Edition{}"
      }
    }
  elseif voucher_lvl >= 4 then
    G.localization.descriptions.Voucher.v_magic_trick = {
      name = "Magic Trick",
      text = {
        "{C:attention}Playing cards{} can appear {C:attention}"..math.max(4, (1 + (voucher_level-1)*0.5)).."X",
        "more frequently in the shop",
        "{C:attention}"..math.min(100, (12*(voucher_lvl-1))).."%{} to have an {C:enhanced}Enhancement{}",
        "{C:attention}"..math.min(100, (7*(voucher_lvl-2))).."%{} to have a non-Negative {C:dark_edition}Edition{}",
        "{C:attention}"..math.min(100, (5*(voucher_lvl-3))).."%{} to have a {C:attention}Seal{}"
      }
    }
  end

  -- Illusion
  if voucher_lvl == 1 then
    G.localization.descriptions.Voucher.v_illusion = {
      name = "Illusion",
      text = {
        "{C:attention}Playing cards{} in shop",
        "may have an {C:enhanced}Enhancement{},",
        "{C:dark_edition}Edition{}, and/or a {C:attention}Seal{}"
      },
      unlock = {
        "Buy a total of",
        "{C:attention}#1#{} playing cards",
        "from the shop",
        "{C:inactive}(#2#)"
      }
    }
  elseif voucher_lvl >= 2 then
    G.localization.descriptions.Voucher.v_illusion = {
      name = "Illusion",
      text = {
        "Shop has an extra slot",
        "specifically for playing cards",
        "{C:attention}Playing cards{} in shop are free and",
        "are guaranteed to have an {C:enhanced}Enhancement{},",
        "{C:dark_edition}Edition{} (can be Negative), and {C:attention}Seal{}"
      },
      unlock = {
        "Buy a total of",
        "{C:attention}#1#{} playing cards",
        "from the shop",
        "{C:inactive}(#2#)"
      }
    }
  end

  -- Hieroglyph and Petroglyph
  if voucher_lvl == 1 then
    G.localization.descriptions.Voucher.v_hieroglyph = {
      name = "Hieroglyph",
      text = {
        "{C:attention}-#1#{} Ante,",
        "{C:blue}-#1#{} hand",
        "each round"
      }
    }
    G.localization.descriptions.Voucher.v_petroglyph = {
      name = "Petroglyph",
      text = {
        "{C:attention}-#1#{} Ante,",
        "{C:red}-#1#{} discard",
        "each round"
      }
    }
  elseif voucher_lvl >= 2 then
    G.localization.descriptions.Voucher.v_hieroglyph = {
      name = "Hieroglyph",
      text = {
        "{C:attention}-#1#{} Ante",
      }
    }
    G.localization.descriptions.Voucher.v_petroglyph = {
      name = "Petroglyph",
      text = {
        "{C:attention}-#1#{} Ante"
      }
    }
  end

  G.localization.descriptions.Voucher.v_directors_cut = {
    name = "Director's Cut",
    text = {
      "Reroll Boss Blind",
      "{C:attention}"..voucher_lvl.."{} times per Ante,",
      "{C:money}$#1#{} per roll"
    }
  }
  G.localization.descriptions.Voucher.v_retcon = {
    name = "Retcon",
    text = {
      "Reroll Boss Blind",
      "{C:attention}unlimited{} times,",
      "{C:money}$"..math.max(0, (10 - (voucher_lvl-1)*2)).."{} per roll"
    },
    unlock = {
      "Discover",
      "{C:attention}#1#{} Blinds"
    }
  }

  G.localization.descriptions.Voucher.v_paint_brush = {
    name = "Paint Brush",
    text = {
      "{C:attention}+"..math.floor(1.5 + (voucher_lvl-1)*0.5).."{} hand size",
    }
  }
  G.localization.descriptions.Voucher.v_palette = {
    name = "Palette",
    text = {
      "{C:attention}+"..math.floor(1.5 + (voucher_lvl-1)*0.5).."{} hand size",
    },
    unlock = {
      "Reduce hand size",
      "down to {C:attention}#1#{} cards"
    }
  }

  -- Special Negative Editions
  G.localization.descriptions.Edition.e_negative = {
    name = "Negative",
    text = {
      "{C:dark_edition}+#1#{} Joker slots"
    }
  }
  G.localization.descriptions.Edition.e_negative_consumable = {
    name = "Negative",
    text = {
      "{C:dark_edition}+"..math.floor(1 + ((edition_lvl-1) * 0.5)).."{} consumable slots"
    }
  }
  G.localization.descriptions.Edition.e_negative_playing_card = {
    name = "Negative",
    text = {
      "{C:dark_edition}+"..math.floor(1 + ((edition_lvl-1) * 0.5)).."{} hand size"
    }
  }

  -- Upgrades (note: this is global _level, not local _lvl)
  G.localization.misc.dictionary.u_mult = "Mult Jokers: "..mult_level
  G.localization.misc.dictionary.u_xmult = "XMult Jokers: "..xmult_level
  G.localization.misc.dictionary.u_chips = "Chips Jokers: "..chips_level
  G.localization.misc.dictionary.u_econ = "Economy Jokers: "..econ_level
  G.localization.misc.dictionary.u_effect = "Effect Jokers: "..effect_level
  G.localization.misc.dictionary.u_tarot = "Tarot Cards: "..tarot_level
  G.localization.misc.dictionary.u_planet = "Planet Cards: "..planet_level
  G.localization.misc.dictionary.u_spectral = "Spectral Cards: "..spectral_level
  G.localization.misc.dictionary.u_enhance = "Enhancements: "..enhance_level
  G.localization.misc.dictionary.u_edition = "Editions and Seals: "..edition_level
  G.localization.misc.dictionary.u_pack = "Booster Packs: "..pack_level
  G.localization.misc.dictionary.u_tag = "Tags: "..tag_level
  G.localization.misc.dictionary.u_voucher = "Vouchers: "..voucher_level
  G.localization.misc.dictionary.u_blind = "Boss Blinds: "..blind_level

  G.localization.misc.v_dictionary.a_xchips = "X#1# chips"
  G.localization.misc.dictionary.k_plus_tarot = "+Tarot"
  G.localization.misc.dictionary.k_plus_planet = "+Planet"
  G.localization.misc.dictionary.k_plus_spectral = "+Spectral"
  G.localization.misc.dictionary.k_plus_joker = "+Joker"
  G.localization.misc.dictionary.k_plus_stone = "+Stone"
  G.localization.misc.dictionary.b_upgrades = "Upgrades"
  G.localization.misc.dictionary.b_plus = "+"
  G.localization.misc.dictionary.b_minus = "-"

  blind_desc(blind_lvl)
  init_localization()
end

function SMODS.INIT.upgrademod()

  -- Switch the order of Buffoon, Handy, and Garbage Tags to prevent Buffoon Tag flickering
  G.P_TAGS.tag_buffoon.order = 15
  G.P_TAGS.tag_handy.order = 13
  G.P_TAGS.tag_garbage.order = 14

  local atlasdeck = SMODS.Atlas({key = "centers", atlas_table = path, path = "newdecks.png", px = 71, py = 95})
  atlasdeck:register()
  local level2deck = SMODS.Deck:new(lvl2deck.name, 1, lvl2deck.config, lvl2deck.pos, lvl2deck.loc)
  local level3deck = SMODS.Deck:new(lvl3deck.name, 2, lvl3deck.config, lvl3deck.pos, lvl3deck.loc)
  local level4deck = SMODS.Deck:new(lvl4deck.name, 3, lvl4deck.config, lvl4deck.pos, lvl4deck.loc)
  level2deck:register()
  level3deck:register()
  level4deck:register()
  set_centers(mult_level, xmult_level, chips_level, econ_level, effect_level, tarot_level, planet_level, spectral_level, enhance_level, edition_level, pack_level, tag_level, voucher_level, blind_level)
  desc(mult_level, xmult_level, chips_level, econ_level, effect_level, tarot_level, planet_level, spectral_level, enhance_level, edition_level, pack_level, tag_level, voucher_level, blind_level)
end