--Atlas
SMODS.Atlas {
    key = 'Jammbo',
    path = 'jokers.png',
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'modicon',
    path = 'modicon.png',
    px = 32,
    py = 32
}

SMODS.Atlas {
    key = 'jam_enhancements',
    path = 'enhance.png',
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'jam_tarot',
    path = 'tarot.png',
    px = 65,
    py = 95
}

SMODS.Atlas {
    key = 'jam_bugs',
    path = 'bugs.png',
    px = 65,
    py = 95
}

SMODS.Atlas {
    key = 'jam_boosters',
    path = 'jamboosters.png',
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'jam_spectral',
    path = 'jamspectral.png',
    px = 65,
    py = 95
}

SMODS.Atlas {
    key = 'jam_tags',
    path = 'tags.png',
    px = 34,
    py = 34
}

SMODS.Atlas {
    key = 'jam_blinds',
    path = 'blinds.png',
    px = 34,
    py = 34,
    atlas_table = 'ANIMATION_ATLAS', frames = 1
}

SMODS.Atlas {
    key = 'Seals',
    path = 'seals.png',
    px = 71,
    py = 95
}

--Pools
SMODS.ObjectType({
	key = "Jambatro",
	default = "j_jam_greg",
	cards = {},
	inject = function(self)
		SMODS.ObjectType.inject(self)
	end,
})

--Pools
SMODS.ObjectType({
	key = "Jambatro_R",
	default = "j_jam_waste",
	cards = {},
	inject = function(self)
		SMODS.ObjectType.inject(self)
	end,
})

SMODS.ObjectType({
	key = "jam_buggies",
	default = "c_jammbo_jam_caterpillar",
	cards = {},
	inject = function(self)
		SMODS.ObjectType.inject(self)
	end,
})

SMODS.ObjectType({
	key = "Jamboosters",
	default = "p_jammbo_jam_booster_1",
	cards = {},
	inject = function(self)
		SMODS.ObjectType.inject(self)
	end,
})


--Types
SMODS.ConsumableType {
  object_type = "ConsumableType",
  key = 'jam_bugs',
  default = 'c_jammbo_jam_caterpillar',
  collection_rows = { 4,4 },
  primary_colour = HEX("7164C6"),
  secondary_colour = HEX("6F785A"),
  loc_txt = {
      collection = 'Bug Cards',
      name = 'Bugs',
      label = 'Bugs',
      },
  shop_rate = 1.4,
}

--Enhanced Cards
SMODS.Enhancement {
    key = 'jam_diamond',
    loc_txt = {
        name = "Diamond Card",
        text = {
            "{X:chips,C:white} X#1# {} Chips",
            "while this card",
            "stays in hand",
        }
    },
    atlas = 'jam_enhancements',
    pos = { x = 0, y = 0 },
    config = { h_x_chips = 1.3 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.h_x_chips } }
    end,
}

SMODS.Enhancement {
    key = 'jam_mustard',
    loc_txt = {
        name = "Mustard Card",
        text = {
            "Does literally",
            "{C:attention}fuck all{}...?",
        }
    },
    atlas = 'jam_enhancements',
    pos = { x = 1, y = 0 },
    config = {  },
    loc_vars = function(self, info_queue, card)
        return { vars = {  } }
    end,

    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            return {
                message = 'MUSTARRD',
            }
        end
    end
}

SMODS.Enhancement {
    key = 'jam_enlightened',
    loc_txt = {
        name = "Enlightened Card",
        text = {
            'Retrigger card {C:attention}2{} times',
            '{C:green}#1# in #2#{} chance to',
            'remove {C:attention}enhancement{} when',
            'played'
        }
    },
    atlas = 'jam_enhancements',
    pos = { x = 2, y = 0 },
    config = { extra = { odds = 5 } },
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'enlightenment')
        return { vars = { numerator, denominator } }
    end,

    calculate = function(self, card, context)
        if context.repetition then
            return {
                repetitions = 2
            }
        end
        if context.before and context.cardarea == G.play then
            if SMODS.pseudorandom_probability(card, 'enlightenment', 1, card.ability.extra.odds) then
                card:set_ability('c_base', nil, true)
                return {
                    message = 'Lost faith!'
                }
            end
        end
    end,
}

SMODS.Enhancement {
     key = 'jam_battery',
    loc_txt = {
        name = "Battery Card",
        text = {
            '{C:mult}+#1#{} Mult',
            'Gains {C:mult}+#2#{} Mult',
            'when discarded',
            'Loses {C:mult}+#3#{} Mult',
            'after scoring'
        }
    },
    atlas = 'jam_enhancements',
    pos = { x = 3, y = 0 },
    config = { extra = { mult = 0, mult_gain = 5, mult_loss = 3 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.mult_gain, card.ability.extra.mult_loss } }
    end,

    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            return {
                mult = card.ability.extra.mult
            }
        end
        if context.discard and context.other_card == card then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
            return {
                message = 'Charging!'
            }
        end
        if context.after and context.cardarea == G.play then
            card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.mult_loss
            return {
                message = 'Losing Charge!'
            }
        end
    end,
}



-- Jokers
SMODS.Joker {
    key = "jam_amplifier",
    loc_txt = {
        name = "Amplifier",
        text = {
            '{X:red,C:white}X#2#{} Mult for every Chip',
            'difference between the current',
            '{C:chips}Hand Chips{} before scoring and {C:attention}#1#{}',
            '{C:inactive}(Ex:{} {C:chips}80{} {C:inactive}hand chips ={} {X:red,C:white}X2.4{} {C:inactive}Mult)',
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 0, y = 0 },
    pools = { ["Jambatro"] = true },

    config = { extra = { threshold = 150, xmult_gain = 0.02 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.threshold, card.ability.extra.xmult_gain } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            if hand_chips < card.ability.extra.threshold then
                local calculation = ((card.ability.extra.threshold - hand_chips) * card.ability.extra.xmult_gain) + 1
                return {
                    xmult = calculation
                }
            end
        end
    end
}

SMODS.Joker {
    key = "jam_reasonably_priced_star",
    loc_txt = {
        name = "Reasonably Priced Star",
        text = {
            'Played {C:attention}Jacks{} have a',
            '{C:green}#1# in #2#{} chance of giving{C:money} $6{}',
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 5,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 1, y = 0 },
    pools = { ["Jambatro"] = true },
    config = { extra = { odds = 3, dollars = 6 } },

    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "priced_star")
        return { vars = { numerator, denominator, card.ability.extra.dollars } }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 11 then
            if SMODS.pseudorandom_probability(card, "priced_star", 1, card.ability.extra.odds) then
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
                return {
                    dollars = card.ability.extra.dollars,
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.GAME.dollar_buffer = 0
                                return true
                            end
                        }))
                    end
                }
            end
        end
    end
}

SMODS.Joker{
    key = "jam_greg",
    loc_txt = {
        name = "Greg",
        text = {
            '{C:red}+5{} Mult',
            '{C:green}#1# in #2#{} chance',
            'of {X:red,C:white}X2{} Mult',
        }
    },
    blueprint_compat = true,
    rarity = 1,
    cost = 3,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 2, y = 0 },
    pools = { ["Jambatro"] = true },

    config = { extra = { flat_mult = 5, odds = 4, xmult_value = 2 } },

    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "greg")
        return { vars = { numerator, denominator, card.ability.extra.xmult_value } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            if SMODS.pseudorandom_probability(card, "greg", 1, card.ability.extra.odds) then
                return {
                    mult = card.ability.extra.flat_mult,
                    xmult = card.ability.extra.xmult_value,
                }
            else
                return{
                    mult = card.ability.extra.flat_mult
                }
            end
        end
    end
}

SMODS.Joker {
    key = 'jam_fantastic',
    loc_txt = {
        name = "Fantastic Joker",
        text = {
            'Each played {C:attention}4{}',
            'gives {C:blue}+44{} Chips',
        }
    },
    blueprint_compat = true,
    rarity = 1,
    cost = 6,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 5, y = 0 },
    pools = { ["Jambatro"] = true },

    config = { extra = { chips = 44 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            (context.other_card:get_id() == 4) then
            return {
                chips = card.ability.extra.chips,
            }
        end
    end
}

SMODS.Joker {
    key = 'jam_copper',
    loc_txt = {
        name = "Copper Joker",
        text = {
            'Gives {C:money}$2{} at',
            'the end of the round'
        }
    },
    blueprint_compat = false,
    rarity = 1,
    cost = 3,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 6, y = 0 },
    pools = { ["Jambatro"] = true },

    config = { extra = { dollars = 2 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars } }
    end,
    calc_dollar_bonus = function(self, card)
        return card.ability.extra.dollars
    end
}

SMODS.Joker {
    key = 'jam_gross',
    loc_txt = {
        name = "Gross Michael",
        text = {
            '{C:red}+#3#{} Mult',
            '{C:green}#1# in #2#{} chance of',
            'losing {C:red}+3{} Mult'
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    discovered = true,
    eternal_compat = false,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 3, y = 2 },
    pools = { ["Jambatro"] = true },

    config = { extra = { odds = 6, mult = 18, diff = 3 } },

    loc_vars = function (self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'gross')
        return { vars = { numerator, denominator, card.ability.extra.mult } }
    end,

    calculate = function (self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end

        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if SMODS.pseudorandom_probability(card, 'gross', 1, card.ability.extra.odds) then
                if card.ability.extra.mult == 5 then
                    card:remove()
                    return{ message = "Shrivelled!" }
                else
                    card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.diff
                    return { message = "Rotting!" }
                end
            end
        end
    end
}

SMODS.Joker {
    key = 'jam_waste',
    loc_txt = {
        name = "Wasted Slot",
        text = {
            '{X:red,C:white}X1.02{} Mult if played hand',
            'contains a {C:attention}High Card{}',
        }
    },
    blueprint_compat = true,
    rarity = 3,
    cost = 2,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    atlas = 'Jammbo',
    pos = { x = 6, y = 3 },
    pools = { ["Jambatro"] = true, ["Jambatro_R"] = true },

    config = { extra = { xmult = 1.02 } },

    calculate = function (self, card, context)
        if context.joker_main and #context.scoring_hand >= 1 then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
}

SMODS.Sound({key = "plums", path = "michaelrosenplums.mp3",})

SMODS.Joker {
    key = 'jam_rosen',
    loc_txt = {
        name = "The Michael Rosen Joker",
        text = {
            'Each scored {C:attention}6{} has a',
            '{C:green}#1# in 3{} chance of',
            'creating a {C:blue}Planet{} card',
            '{C:inactive}(Must have room){}'
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 7, y = 1 },
    pools = { ["Jambatro"] = true },

    config = { extra = { odds = 3 } },

    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'rosen')
        return { vars = { numerator, denominator } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            if next(SMODS.find_card('j_jammbo_jam_cthoogle')) then
                SMODS.destroy_cards(SMODS.find_card('j_jammbo_jam_cthoogle'))
                SMODS.calculate_effect({message = "With me bare hands!"}, card)
            end
        end
        if context.individual and context.cardarea == G.play and
            #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            if (context.other_card:get_id() == 6) and SMODS.pseudorandom_probability(card, 'rosen', 1, card.ability.extra.odds) then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                return { 
                    message = "Plums!",
                    sound = "jammbo_plums",
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = (function()
                                SMODS.add_card {
                                    set = 'Planet',
                                }
                                G.GAME.consumeable_buffer = 0
                                return true
                            end)
                        }))
                    end
                }
            end
        end
    end,

    add_to_deck = function(self, card, from_debuff)
        if next(SMODS.find_card('j_jammbo_jam_cthoogle')) then
            SMODS.destroy_cards(SMODS.find_card('j_jammbo_jam_cthoogle'))
            SMODS.calculate_effect({message = "With me bare hands!"}, card)
        end
    end
}

SMODS.Joker {
    key = 'jam_gaster',
    loc_txt = {
        name = "W. D. Joker",
        text = {
            'Each played {C:attention}6{}',
            'gives {C:blue}+66{} Chips',
        }
    },
    blueprint_compat = true,
    rarity = 1,
    cost = 7,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 2, y = 3 },
    pools = { ["Jambatro"] = true },

    config = { extra = { chips = 66 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            (context.other_card:get_id() == 6) then
            return {
                chips = card.ability.extra.chips,
            }
        end
    end
}

SMODS.Joker {
    key = 'jam_inbetweener',
    loc_txt = {
        name = "The Inbetweener",
        text = {
            'Gives {C:red}+3{} Mult for',
            'every {C:attention}8{} in your deck',
            '{C:inactive}(Currently{}{C:red} +#2#{} {C:inactive}Mult){}',
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 8,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 5, y = 2 },
    pools = { ["Jambatro"] = true },

    config = { extra = { mult_amount = 12 } },

    loc_vars = function(self, info_queue, card)
        local eight_tally = 0
        local mult_amount = 0
        if G.playing_cards then
            for _, playing_card in ipairs(G.playing_cards) do
                if playing_card:get_id() == 8 then eight_tally = eight_tally + 1 end
            end
        end
        mult_amount = eight_tally * 3
        return { vars = { eight_tally, mult_amount } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local eight_tally = 0
            for _, playing_card in ipairs(G.playing_cards) do
                if playing_card:get_id() == 8 then eight_tally = eight_tally + 1 end
            end
            return { 
                mult = eight_tally * 3
            }
        end
    end
}

SMODS.Joker {
    key = 'jam_tyrs',
    loc_txt = {
        name = "Tyrsfall_JK",
        text = {
            'Every played {C:attention}King{}',
            'has a {C:green}#1# in #2#{} chance',
            'of giving {X:red,C:white}X#3#{} Mult'
        }
    },
    blueprint_compat = true,
    rarity = 3,
    cost = 7,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 1, y = 1 },
    pools = { ["Jambatro"] = true, ["Jambatro_R"] = true },

    config = { extra = { odds = 3, xmult = 2 } },

    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'tyrsfall')
        return { vars = { numerator, denominator, card.ability.extra.xmult } }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 13 then
            if SMODS.pseudorandom_probability(card, 'tyrsfall', 1, card.ability.extra.odds) then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end
    end,
}

SMODS.Joker {
    key = 'jam_awkward',
    loc_txt = {
        name = "Awkward Joker",
        text = {
            '{C:red}+3{} Mult for each',
            'empty played hand slot',
            '{C:inactive}(ex: Hand with 2 cards = {}{C:mult}+9{}{C:inactive} Mult)'
        }
    },
    blueprint_compat = true,
    rarity = 1,
    cost = 3,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 4, y = 3 },
    pools = { ["Jambatro"] = true },

    config = { extra = { mult = 3 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult * (G.GAME.starting_params.play_limit - #context.full_hand)
            }
        end
    end
}

SMODS.Joker {
    key = 'jam_chudjoker',
    loc_txt = {
        name = "Chud Joker",
        text = {
            'Sets all {C:green}probabilites{} to 0',
            '{C:inactive}(ex: {}{C:green}1 in 4{} {C:inactive} ->{} {C:green}0 in 4{} {C:inactive}){}'
        }
    },
    blueprint_compat = false,
    rarity = 2,
    cost = 5,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 7, y = 0 },
    pools = { ["Jambatro"] = true },

    calculate = function(self, card, context)
        if context.mod_probability and not context.blueprint then
            return {
                numerator = context.numerator * 0
            }
        end
    end,
}

SMODS.Joker {
    key = 'jam_policeofficer',
    loc_txt = {
        name = "Police Officer",
        text = {
            'Gains {C:red}+#2#{} Mult if hand',
            'played is {C:attention}Not Allowed{}',
            '{C:inactive}(Currently {}{C:red}+#1#{}{C:inactive} Mult){}'
        }
    },
    blueprint_compat = true,
    rarity = 1,
    cost = 4,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    atlas = 'Jammbo',
    pos = { x = 1, y = 2 },
    pools = { ["Jambatro"] = true },

    config = { extra = { mult = 0, mult_bonus = 6 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.mult_bonus } }
    end,

    calculate = function(self, card, context)
        if context.debuffed_hand and not context.blueprint then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_bonus
            return {
                message = 'Whas all this then?',
            }
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker {
    key = 'jam_speedyjoker',
    loc_txt = {
        name = 'Speedy Joker',
        text = {
            'The faster you play your {C:attention}hand{},',
            'the better rank you get!',
            '--',
            'S Rank: {X:red,C:white}X#1#{} Mult, {C:red}+#2#{} Mult',
            'A Rank: {C:red}+#3#{} Mult',
            'B Rank: {C:red}+#4#{} Mult',
            'C Rank: {C:red}+#5#{} Mult',
            'D Rank: {C:red}+#6#{} Mult',
            'E Rank: {C:red}+#7#{} Mult',
            'F Rank: {C:red}+#8#{} Mult',
            'AFK Rank: {C:chips}+#9#{} Chip',
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 4,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 4, y = 1 },
    pools = { ["Jambatro"] = true },

    config = { 
        extra = { 
            S_rank = {3, 1.5, 15},
            A_rank = {8, 10},
            B_rank = {15, 6},
            C_rank = {20, 4},
            D_rank = {30, 3},
            E_rank = {40, 2},
            F_rank = {45, 1},
            AFK = {46, 1},
            do_reset = 1,
            starting_time = 0,
            in_seconds_kinda = 0,
        } 
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { 
            card.ability.extra.S_rank[2],
            card.ability.extra.S_rank[3],
            card.ability.extra.A_rank[2],
            card.ability.extra.B_rank[2],
            card.ability.extra.C_rank[2],
            card.ability.extra.D_rank[2],
            card.ability.extra.E_rank[2],
            card.ability.extra.F_rank[2],
            card.ability.extra.AFK[2],
        } }
    end,

    calculate = function(self, card, context)
        if context.hand_drawn then
            if card.ability.extra.do_reset == 1 then
                card.ability.extra.starting_time = os.time{year=tonumber(os.date("%Y")), month=tonumber(os.date("%m")), day=tonumber(os.date("%d")), 
                                                           hour=tonumber(os.date("%H")), min=tonumber(os.date("%M")), sec=tonumber(os.date("%S"))}
                return { message = 'Timer starts now!' }
            else
                return { message = 'Still counting!' }
            end
        end
        if context.discard then
            card.ability.extra.do_reset = 0
        end
        if context.joker_main then
            card.ability.extra.do_reset = 1
            local current_time = os.time{year=tonumber(os.date("%Y")), month=tonumber(os.date("%m")), day=tonumber(os.date("%d")), 
                                         hour=tonumber(os.date("%H")), min=tonumber(os.date("%M")), sec=tonumber(os.date("%S"))}
            card.ability.extra.in_seconds_kinda = os.difftime(current_time, card.ability.extra.starting_time)
            print(card.ability.extra.in_seconds_kinda)
            if card.ability.extra.in_seconds_kinda <= card.ability.extra.S_rank[1] then
                return {
                    xmult = card.ability.extra.S_rank[2],
                    mult = card.ability.extra.S_rank[3],
                    message = 'S Rank!'
                }
            end
            if card.ability.extra.in_seconds_kinda <= card.ability.extra.A_rank[1] then
                return {
                    mult = card.ability.extra.A_rank[2],
                    message = 'A Rank!'
                }
            end
            if card.ability.extra.in_seconds_kinda <= card.ability.extra.B_rank[1] then
                return {
                    mult = card.ability.extra.B_rank[2],
                    message = 'B Rank!'
                }
            end
            if card.ability.extra.in_seconds_kinda <= card.ability.extra.C_rank[1] then
                return {
                    mult = card.ability.extra.C_rank[2],
                    message = 'C Rank!'
                }
            end
            if card.ability.extra.in_seconds_kinda <= card.ability.extra.D_rank[1] then
                return {
                    mult = card.ability.extra.D_rank[2],
                    message = 'D Rank!'
                }
            end
            if card.ability.extra.in_seconds_kinda <= card.ability.extra.E_rank[1] then
                return {
                    mult = card.ability.extra.E_rank[2],
                    message = 'E Rank!'
                }
            end
            if card.ability.extra.in_seconds_kinda <= card.ability.extra.F_rank[1] then
                return {
                    mult = card.ability.extra.F_rank[2],
                    message = 'F Rank!'
                }
            end
            return {
                chips = card.ability.extra.AFK[2],
                message = 'Someone went AFK, huh?'
            }
        end
    end,

    add_to_deck = function(self, card, from_debuff)
        card.ability.extra.starting_time = os.time{year=tonumber(os.date("%Y")), month=tonumber(os.date("%m")), day=tonumber(os.date("%d")), hour=tonumber(os.date("%H")), min=tonumber(os.date("%M")), sec=tonumber(os.date("%S"))}
        print(card.ability.extra.starting_time)
    end,
}

SMODS.Joker {
    key = 'jam_jokerstore',
    loc_txt = {
        name = 'Its a Card Store! I was buying Cards!',
        text = {
            'Gains {C:red}+#2#{} Mult for every',
            '{C:attention}Card{} bought in the {C:attention}Shop{}',
            '{C:inactive}(Currently {}{C:red}+#1#{}{C:inactive} Mult){}',
            '{C:inactive}Does not include Booster Packs{}'
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 7,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    atlas = 'Jammbo',
    pos = { x = 0, y = 2 },
    pools = { ["Jambatro"] = true },

    config = { extra = { mult = 0, mult_bonus = 3 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.mult_bonus } }
    end,

    calculate = function(self, card, context)
        if context.buying_card and not context.blueprint then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_bonus
            return {
                message = 'Doh!',
            }
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker{
    key = 'jam_corrupteddata',
    loc_txt = {
        name = 'Corrupted Data',
        text = {
            'All played {C:attention}cards{} score',
            'a {C:green}random{} amount of Chips and',
            'gain between {C:chips}+#1#{} and {C:chips}#2#{} ',
            'Chips {C:attention}permenantly{}',
        }
    },
    blueprint_compat = false,
    rarity = 1,
    cost = 6,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 3, y = 3 },
    pools = { ["Jambatro"] = true },

    config = { extra = { max = 5, min = -5, bonus_min = 0, bonus_max = 15 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.max, card.ability.extra.min } }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            context.other_card.ability.perma_bonus = (context.other_card.ability.perma_bonus or 0) + pseudorandom('theseed', card.ability.extra.min, card.ability.extra.max)
            return {
                chips = pseudorandom('guurrhhh', card.ability.extra.bonus_min, card.ability.extra.bonus_max)
            }
        end
    end
}

SMODS.Joker {
    key = 'jam_tnetannba',
    loc_txt = {
        name = '0118 999 8819 9911 9725...3',
        text = {
            'Play each {C:attention}digit{} of the new number',
            'for the {C:attention}Emergency Services{} to earn',
            '{X:chips,C:white}X2{} Chips! Each correct',
            'digit gives {C:chips}+50{} Chips',
            '{C:inactive}(Next digit: {C:attention}#2#{}{C:inactive}){}',
            '{C:inactive}Can count multiple digits per hand{}'
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 7,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 4, y = 2 },
    pools = { ["Jambatro"] = true },

    config = { extra = { chips = 50, next_number = "Ace", digit = 1 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.next_number, card.ability.extra.digit } }
    end,

    calculate = function(self, card, context)
        local digits = { 14, 14, 8, 9, 9, 9, 8, 8, 14, 9, 9, 9, 14, 14, 9, 7, 2, 5, 3, "Complete!" }
        if context.individual and context.cardarea == G.play and card.ability.extra.digit < 20 and (context.other_card:get_id() == digits[card.ability.extra.digit]) 
        and not context.blueprint then
            card.ability.extra.digit = card.ability.extra.digit + 1
            if digits[card.ability.extra.digit] == 14 then
                card.ability.extra.next_number = "Ace"
            else
                card.ability.extra.next_number = digits[card.ability.extra.digit]
            end
            return {
                chips = card.ability.extra.chips,
                message = "Well, thats easy to remember!",
            }
        end

        if context.joker_main and card.ability.extra.digit >= 20 then
            return {
                xchips = 2,
                message = "I've just finished my milk"
            }
        end
    end
}

SMODS.Joker {
    key = 'jam_118',
    loc_txt = {
        name = '118-118!',
        text = {
            'If {C:attention}hand{} contains a {C:attention}Pair{} of {C:attention}Aces{}, {C:red}+#1#{} Mult',
            'If {C:attention}hand{} contains an {C:attention}8{}, {C:red}+#2#{} Mult',
            'If {C:attention}hand{} contains {C:attention}both{}, {C:red}+18{} Mult',
        }
    },
    blueprint_compat = true,
    rarity = 1,
    cost = 5,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 0, y = 1 },
    pools = { ["Jambatro"] = true },

    config = { extra = { mult_acepair = 8, mult_8 = 3, bonus_mult = 7, has_ace = false, has_another_ace = false, has_8 = false } },

    loc_vars = function(self, info_queue, card)
        return { vars = { 
            card.ability.extra.mult_acepair, 
            card.ability.extra.mult_8, 
            card.ability.extra.bonus_mult, 
            card.ability.extra.has_ace,
            card.ability.extra.has_another_ace,
            card.ability.extra.has_8
        } }
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual and context.other_card then
            local rank = context.other_card:get_id()
			if rank == 14 then
                if card.ability.extra.has_ace == false then
                    card.ability.extra.has_ace = true
                    return {
                        message = '1!'
                    }
                end
                if card.ability.extra.has_another_ace == false then
                    if card.ability.extra.has_ace == true then
                        card.ability.extra.has_another_ace = true
                        return {
                            message = '1!'
                        }
                    end
                end
			end
            if rank == 8 then
                if card.ability.extra.has_8 == false then
                    card.ability.extra.has_8 = true
				    return {
                        message = '8!',
                    }
                end
			end
        end
        if context.joker_main then
            if card.ability.extra.has_another_ace == true and card.ability.extra.has_8 == true then
                card.ability.extra.has_ace = false
                card.ability.extra.has_another_ace = false
                card.ability.extra.has_8 = false
                return {
                    mult = card.ability.extra.mult_acepair + card.ability.extra.mult_8 + card.ability.extra.bonus_mult
                }
            else
                if card.ability.extra.has_another_ace == true then
                    card.ability.extra.has_ace = false
                    card.ability.extra.has_another_ace = false
                    card.ability.extra.has_8 = false
                    return {
                        mult = card.ability.extra.mult_acepair
                    }
                end
                if card.ability.extra.has_8 == true then
                    card.ability.extra.has_ace = false
                    card.ability.extra.has_another_ace = false
                    card.ability.extra.has_8 = false
                    return {
                        mult = card.ability.extra.mult_8
                    }
                end
            end
            card.ability.extra.has_ace = false
            card.ability.extra.has_another_ace = false
            card.ability.extra.has_8 = false
        end
    end
}

SMODS.Joker {
    key = 'jam_flexplay',
    loc_txt = {
        name = 'JokerPlay Rental',
        text = {
            'Each scored card gains {C:red}+1{} Mult',
            '{C:attention}permenantly{}',
            'Cards destroyed if {C:attention}permenant{}',
            'Mult exceeds {C:red}+5{}',
            '{C:inactive}Mult cards have no effect',
            '{C:inactive}on the rental mechanic'
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 3, y = 0 },
    pools = { ["Jambatro"] = true },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS['m_mult']
        return { vars = {  } }
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual and context.other_card then
            context.other_card.ability.perma_mult = (context.other_card.ability.perma_mult or 0) + 1
            return {
                message = "Upgrade"
            }
		end
        if context.destroy_card and context.cardarea == G.play and context.destroy_card.ability.perma_mult >= 5 then
            return { 
                remove = true,
                message = "Expired!"
            }
        end
    end
}

SMODS.Joker {
    key = 'jam_fat_joker',
    loc_txt = {
        name = 'Fat Joker',
        text = {
            '{C:green}#1# in #2#{} chance of eating each',
            '{C:attention}played card{} and gaining {C:red}+#4#{} Mult',
            '{C:green}#3# in #5#{} chance of having',
            'a {C:attention}fatal heart attack{}',
            '{C:inactive}(Currently {}{C:red}+#3#{}{C:inactive} Mult){}',
            '{C:inactive}Chance of heart attack increases with Mult'
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    discovered = true,
    eternal_compat = false,
    perishable_compat = false,
    atlas = 'Jammbo',
    pos = { x = 4, y = 0 },
    pools = { ["Jambatro"] = true },

    config = { extra = { odds = 6, mult = 0, add = 5, chance = 200 } },

    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'fatman')
        return { vars = { numerator, denominator, card.ability.extra.mult, card.ability.extra.add, card.ability.extra.chance } }
    end,

    calculate = function(self, card, context)
        local eaten = false
        if eaten == false then
            if context.destroy_card and context.cardarea == G.play and SMODS.pseudorandom_probability(card, 'fatman', 1, card.ability.extra.odds) and not context.blueprint then
                eaten = true
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.add
                return { 
                    remove = true,
                    message = "Eaten!"
                }
            end
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if SMODS.pseudorandom_probability(card, 'fatman', card.ability.extra.mult, card.ability.extra.chance) then
                card:remove()
                return{ message = "Heart Attack!" }
            end
        end
    end
}

SMODS.Joker {
    key = 'jam_trolled',
    loc_txt = {
        name = 'Troll Joker',
        text = {
            'All played {C:attention}cards{} lose their Chip',
            'value after first play'
        }
    },
    blueprint_compat = false,
    rarity = 1,
    cost = 1,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 2, y = 1 },
    pools = { ["Jambatro"] = true },

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card and not context.blueprint then
            local rank = context.other_card:get_id()
            if context.other_card.ability.perma_bonus < 0 then
                return {
                    message = ""
                }
            else
                if rank == 14 then
                    context.other_card.ability.perma_bonus = -11
                end
                if rank == 13 or rank == 12 or rank == 11 then
                    context.other_card.ability.perma_bonus = -10
                end
                if rank < 11 then
                    context.other_card.ability.perma_bonus = rank - (rank * 2)
                end
                return {
                    message = 'oops!'
                }
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        card.ability.eternal = true
    end,
}

SMODS.Joker {
    key = 'jam_groundhog',
    loc_txt = {
        name = 'Groundhog Day',
        text = {
            'When cummulative {C:attention}Jokers{}',
            'reset, gains {C:red}+#2#{} Mult',
            '{C:inactive}(Currently{}{C:red} +#1#{} {C:inactive}Mult){}'
        }
    },
    blueprint_compat = true,
    rarity = 1,
    cost = 5,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    atlas = 'Jammbo',
    pos = { x = 1, y = 3 },
    pools = { ["Jambatro"] = true },

    config = { 
        extra = { 
            real_mult = 0,
            real_mult_gain = 6,

            bus_mult_gain = 1, 
            bus_mult = 0,

            camp_xmult = 1,
            camp_xmult_gain = 1,

            obelisk_xmult = 1,
            obelisk_xmult_gain = 0.2,

            road_xmult = 1,
            road_xmult_gain = 0.5
        } 
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS['j_ride_the_bus']
        info_queue[#info_queue + 1] = G.P_CENTERS['j_campfire']
        info_queue[#info_queue + 1] = G.P_CENTERS['j_hit_the_road']
        info_queue[#info_queue + 1] = G.P_CENTERS['j_obelisk']
        return { 
            vars = { 
                card.ability.extra.real_mult,
                card.ability.extra.real_mult_gain,

                card.ability.extra.bus_mult,

                card.ability.extra.camp_xmult,

                card.ability.extra.obelisk_xmult,

                card.ability.extra.road_xmult
            } 
        }
    end,

    calculate = function(self, card, context)
        -- Ride the Bus
        if next(SMODS.find_card('j_ride_the_bus')) then
            if context.before and context.main_eval and not context.blueprint then
                local faces = false
                for _, playing_card in ipairs(context.scoring_hand) do
                    if playing_card:is_face() then
                        faces = true
                        break
                    end
                end
                if faces then
                    local last_mult = card.ability.extra.bus_mult
                    card.ability.extra.bus_mult = 0
                    if last_mult > 0 then
                        card.ability.extra.real_mult = card.ability.extra.real_mult + card.ability.extra.real_mult_gain
                        return {
                            message = "6:00 AM"
                        }
                    end
                else
                    card.ability.extra.bus_mult = card.ability.extra.bus_mult + card.ability.extra.bus_mult_gain
                end
            end
        end

        --Campfire
        if next(SMODS.find_card('j_campfire')) then
            if context.selling_card and not context.blueprint then
                card.ability.extra.camp_xmult = card.ability.extra.camp_xmult + card.ability.extra.camp_xmult_gain
                return {
                    
                }
            end
            if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
                if G.GAME.blind.boss and card.ability.extra.camp_xmult > 1 then
                    card.ability.extra.xmult = 1
                    card.ability.extra.real_mult = card.ability.extra.real_mult + card.ability.extra.real_mult_gain
                    return {
                        message = '6:00 AM',
                    }
                end
            end
        end

        --Obelisk
        if next(SMODS.find_card('j_obelisk')) then
            if context.before and context.main_eval and not context.blueprint then
                local reset = true
                local play_more_than = (G.GAME.hands[context.scoring_name].played or 0)
                for handname, values in pairs(G.GAME.hands) do
                    if handname ~= context.scoring_name and values.played >= play_more_than and SMODS.is_poker_hand_visible(handname) then
                        reset = false
                        break
                    end
                end
                if reset then
                    if card.ability.extra.obelisk_xmult > 1 then
                        card.ability.extra.obelisk_xmult = 1
                        card.ability.extra.real_mult = card.ability.extra.real_mult + card.ability.extra.real_mult_gain
                        return {
                            message = '6:00 AM'
                        }
                    end
                else
                    card.ability.extra.obelisk_xmult = card.ability.extra.obelisk_xmult + card.ability.extra.obelisk_xmult_gain
                end
            end
        end

        --Hit the Road
        if next(SMODS.find_card('j_hit_the_road')) then
            if context.discard and not context.blueprint and
                not context.other_card.debuff and
                context.other_card:get_id() == 11 then
                card.ability.extra.road_xmult = card.ability.extra.road_xmult + card.ability.extra.road_xmult_gain
            end
            if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
                card.ability.extra.road_xmult = 1
                card.ability.extra.real_mult = card.ability.extra.real_mult + card.ability.extra.real_mult_gain
                return {
                    message = '6:00 AM'
                }
            end
        end

        if context.joker_main then
            if not next(SMODS.find_card('j_ride_the_bus')) then
                card.ability.extra.bus_mult = 0
            end
            if not next(SMODS.find_card('j_campfire')) then
                card.ability.extra.camp_xmult = 1
            end
            if not next(SMODS.find_card('j_obelisk')) then
                card.ability.extra.obelisk_xmult = 1
            end
            if not next(SMODS.find_card('j_hit_the_road')) then
                card.ability.extra.obelisk_xmult = 1
            end
            return {
                mult = card.ability.extra.real_mult
            }
        end
    end,

    in_pool = function(self, args)
        if next(SMODS.find_card('j_ride_the_bus')) then
            return true
        end
        if next(SMODS.find_card('j_campfire')) then
            return true
        end
        if next(SMODS.find_card('j_obelisk')) then
            return true
        end
        if next(SMODS.find_card('j_hit_the_road')) then
            return true
        end
        return false
    end
}

SMODS.Joker {
    key = 'jam_f2p',
    loc_txt = {
        name = 'Free to Play',
        text = {
            'Gains {C:red}+#2#{} Mult when {C:attention}shop{} exited',
            'without gaining or losing any {C:money}money{}',
            '{C:inactive}(Currently{}{C:red} +#1#{} {C:inactive}Mult){}'
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    atlas = 'Jammbo',
    pos = { x = 8, y = 0 },
    pools = { ["Jambatro"] = true },

    config = { extra = { mult = 0, mult_gain = 4, stored_dollars = 0 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.mult_gain } }
    end,

    calculate = function(self, card, context)
        if context.starting_shop then
            card.ability.extra.stored_dollars = G.GAME.dollars
        end
        if context.ending_shop and not context.blueprint then
            if card.ability.extra.stored_dollars == G.GAME.dollars then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
                return {
                    message = 'Upgrade!'
                }
            end
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker {
    key = 'jam_pcc',
    loc_txt = {
        name = 'Pembrokeshire County Council',
        text = {
            'When {C:attention}Blind{} is selected, if the {C:attention}shop{} is active,',
            'gain {C:money}$10{} for every {C:attention}spectral card{} bought',
            'For every {C:attention}joker{} bought when opening',
            'an {C:attention}arcana pack{}, gains {C:chips}+70{} chips',
            'At the end of the round, gains',
            '{C:red}+10{} mult if {C:attention}deck{} is 0 cards',
            '{X:red,C:white}X3{} Mult for every {C:attention}tarot card{}',
            'used when the game is {C:attention}paused{}',
            '{C:inactive}(Currently{}{C:red} +0{} {C:inactive}Mult,{}{C:chips} +0{} {C:inactive}Chips, {X:red,C:white}X1{} {C:inactive}Mult){}'
        }
    },
    blueprint_compat = true,
    rarity = 3,
    cost = 10,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 1, y = 4 },
}

SMODS.Joker {
    key = 'jam_magpie',
    loc_txt = {
        name = 'Magpie',
        text = {
            'When {C:attention}Blind{} is selected',
            '{C:green}#1# in #2#{} chance of stealing {C:money}$#3#{}',
            'and giving a random {C:purple}Tarot{} or {C:blue}Spectral{}',
            'card at the end of the round',
            '{C:inactive}(Must have room){}'
        }
    },
    blueprint_compat = true,
    rarity = 1,
    cost = 4,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 8, y = 2 },
    pools = { ["Jambatro"] = true },

    config = { extra = { odds = 3, dollars = 4, yoinked = false } },

    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "magpie")
        return { vars = { numerator, denominator, card.ability.extra.dollars } }
    end,

    calculate = function(self, card, context)
        if context.setting_blind and G.GAME.dollars >= card.ability.extra.dollars and SMODS.pseudorandom_probability(card, "magpie", 1, card.ability.extra.odds) then
            G.GAME.dollars = G.GAME.dollars - card.ability.extra.dollars
            card.ability.extra.yoinked = true
            return {
                message = 'Yoink!'
            }
        end

        if context.end_of_round and context.game_over == false and context.main_eval and card.ability.extra.yoinked == true 
        and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            if pseudorandom('magpenis', 1, 7) == 1 then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                SMODS.add_card {
                                    set = 'Spectral',
                                }
                                G.GAME.consumeable_buffer = 0
                                return true
                            end
                        }))
                        SMODS.calculate_effect({message = " Special Gift!"}, card)
                        card.ability.extra.yoinked = false
                        return true
                    end)
                }))
                return nil, true
            else
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                SMODS.add_card {
                                    set = 'Tarot',
                                }
                                G.GAME.consumeable_buffer = 0
                                return true
                            end
                        }))
                        SMODS.calculate_effect({message = "Gift!"}, card)
                        card.ability.extra.yoinked = false
                        return true
                    end)
                }))
                return nil, true
            end
        end
    end
}

SMODS.Joker {
    key = 'jam_salesman',
    loc_txt = {
        name = 'Salesman',
        text = {
            'Earn {C:money}$1{} for every',
            '{C:money}$2{} of profit from the',
            'last {C:attention}shop{} visit',
            'at the end of the round'
        }
    },
    blueprint_compat = false,
    rarity = 2,
    cost = 6,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 6, y = 1 },
    pools = { ["Jambatro"] = true },

    config = { extra = { mult = 0, mult_gain = 5, stored_dollars = 0, dollar_bonus = 0 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.stored_dollars, card.ability.extra.dollar_bonus } }
    end,

    calculate = function(self, card, context)
        if context.starting_shop then
            card.ability.extra.stored_dollars = G.GAME.dollars
        end
        if context.ending_shop then
            if card.ability.extra.stored_dollars < G.GAME.dollars then
                card.ability.extra.dollar_bonus = math.floor((G.GAME.dollars - card.ability.extra.stored_dollars) / 2)
            else
                card.ability.extra.stored_dollars = 0
                card.ability.extra.dollar_bonus = 0
            end
        end
    end,

    calc_dollar_bonus = function(self, card)
        return card.ability.extra.dollar_bonus
    end
}

SMODS.Joker {
    key = 'jam_crooked',
    loc_txt = {
        name = 'Crooked Joker',
        text = {
            '{C:blue}+#1#{} Hand and lose {C:money}$#2#{}',
            'at the start of the round'
        }
    },
    blueprint_compat = false,
    rarity = 1,
    cost = 4,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 8, y = 3 },
    pools = { ["Jambatro"] = true },

    config = { extra = { hands = 1, dollars = 4 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.hands, card.ability.extra.dollars } }
    end,

    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            G.GAME.dollars = G.GAME.dollars - card.ability.extra.dollars
            if G.GAME.dollars < 0 then
                return {
                    message = 'You owe us.'
                }
            end
            return {
                message = 'Is that for me?'
            }
        end
        if context.selling_self and not context.blueprint then
            return {
                message = 'Just you wait...'
            }
        end
    end,

    add_to_deck = function(self, card, from_debuff)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
        ease_hands_played(card.ability.extra.hands)
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
        ease_hands_played(-card.ability.extra.hands)
    end
}

SMODS.Joker {
    key = 'jam_stocks',
    loc_txt = {
        name = 'Stocks',
        text = {
            '{C:attention}Sell value{} changes randomly',
            'at the end of the round'
        }
    },
    blueprint_compat = false,
    rarity = 2,
    cost = 6,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 3, y = 4 },
    pools = { ["Jambatro"] = true },

    config = { extra = { min = -50, max = 50, bonus = 5 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.min, card.ability.extra.max, card.ability.extra_value } }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            card.ability.extra_value = card.ability.extra_value - (card.ability.extra_value * 2)
            card:set_cost()
            card.ability.extra_value = pseudorandom('thestockmarket!!', card.ability.extra.min, card.ability.extra.max)
            card:set_cost()
            return {
                message = 'Update!'
            }
        end
    end
}

SMODS.Sound({key = "clang", path = "metallic-clang.mp3",})

SMODS.Joker {
    key = 'jam_press',
    loc_txt = {
        name = 'Hydraulic Press',
        text = {
            'First {C:attention}Stone{} card in hand',
            'converted to {C:attention}Glass{} card'
        }
    },
    blueprint_compat = false,
    rarity = 2,
    cost = 4,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 6, y = 2 },
    pools = { ["Jambatro"] = true },

    config = { extra = { smashed = false } },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS['m_glass']
        info_queue[#info_queue + 1] = G.P_CENTERS['m_stone']
        return { vars = {  } }
    end,

    calculate = function(self, card, context)
        if context.hand_drawn then
            card.ability.extra.smashed = false
        end

        if context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, "m_stone") then
            if card.ability.extra.smashed == false then
                context.other_card:set_ability("m_glass", nil, true)
                card.ability.extra.smashed = true
                return {
                    sound = 'jammbo_clang',
                    message = 'Pressed!'
                }
            end
        end
    end
}

SMODS.Joker {
    key = 'jam_hormones',
    loc_txt = {
        name = 'Hormone Therapy',
        text = {
            '{C:green}#1# in #2#{} chance for',
            'each played {C:attention}King{} to turn into a {C:attention}Queen{}',
            '{C:green}#1# in #2#{} chance for',
            'each played {C:attention}Queen{} to turn into a {C:attention}King{}',
            'Gains {C:chips}+#3#{} Chips every transition',
            '{C:inactive}(Currently {}{C:chips}+#4#{} {C:inactive}Chips){}',
        }
    },
    blueprint_compat = false,
    rarity = 1,
    cost = 5,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 7, y = 2 },
    pools = { ["Jambatro"] = true },

    config = { extra = { odds = 3, chips = 0, chip_gain = 7 } },

    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "trannygener")
        return { vars = { numerator, denominator, card.ability.extra.chip_gain, card.ability.extra.chips } }
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual and context.other_card and not context.blueprint then
            local rank = context.other_card:get_id()
            if rank == 13 then
                if SMODS.pseudorandom_probability(card, "trannygeender", 1, card.ability.extra.odds) then
                    card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
                    SMODS.change_base(context.other_card, nil, 'Queen') 
                    return {
                        message = 'Estrogen!'
                    }
                end
            end
            if rank == 12 then
                if SMODS.pseudorandom_probability(card, "trengander", 1, card.ability.extra.odds) then
                    card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
                    SMODS.change_base(context.other_card, nil, 'King') 
                    return {
                        message = 'Testosterone!'
                    }
                end
            end
        end
        if context.joker_main then
            return { chips =  card.ability.extra.chips }
        end
    end
}

SMODS.Joker {
    key = 'jam_rabbits',
    loc_txt = {
        name = 'Like Rabbits',
        text = {
            'When a {C:attention}King{} and {C:attention}Queen{} are scored,',
            'creates a {C:attention}King{}, {C:attention}Queen{} or {C:attention}Jack{} with',
            'a random {C:attention}enhancement{}'
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 5, y = 3 },
    pools = { ["Jambatro"] = true },

    config = { extra = { odds = 2, mother = false, father = false } },

    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "rabbitman")
        return { vars = { numerator, denominator } }
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual and context.other_card and not context.blueprint then
            local rank = context.other_card:get_id()
            if rank == 13 then
                if card.ability.extra.father == false then
                    card.ability.extra.father = true
                    return {
                        message = 'Father!'
                    }
                end
            end
            if rank == 12 then
                if card.ability.extra.mother == false then
                    card.ability.extra.mother = true
                    return {
                        message = 'Mother!'
                    }
                end
            end
        end
        if (context.drawing_cards or (context.end_of_round and context.game_over == false and context.main_eval)) and card.ability.extra.father and card.ability.extra.mother then
            card.ability.extra.father = false
            card.ability.extra.mother = false
            local chrank = pseudorandom('rabbits', 1, 7)
            local cen_pool = {}
            for _, enhancement_center in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                if enhancement_center.key ~= 'm_stone' and not enhancement_center.overrides_base_rank then
                    cen_pool[#cen_pool + 1] = enhancement_center
                end
            end
            local enhancement = pseudorandom_element(cen_pool, 'spe_card')
            if chrank == 1 or chrank == 2 then
                local king = SMODS.create_card { set = "Playing Card", rank = "King", area = G.discard, enhancement = enhancement.key }
                print(enhancement.key)
                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                king.playing_card = G.playing_card
                table.insert(G.playing_cards, king)

                G.E_MANAGER:add_event(Event({
                    func = function()
                        king:start_materialize({ G.C.SECONDARY_SET.Enhanced })
                        G.play:emplace(king)
                        return true
                    end
                }))
                return {
                    message = 'Its a boy!',
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.deck.config.card_limit = G.deck.config.card_limit + 1
                                return true
                            end
                        }))
                        draw_card(G.play, G.deck, 90, 'up')
                        SMODS.calculate_context({ playing_card_added = true, cards = { king } })
                    end
                }
            end
            if chrank == 3 or chrank == 4 then
                local queen = SMODS.create_card { set = "Playing Card", rank = "Queen", area = G.discard, enhancement = enhancement.key }
                print(enhancement.key)
                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                queen.playing_card = G.playing_card
                table.insert(G.playing_cards, queen)

                G.E_MANAGER:add_event(Event({
                    func = function()
                        queen:start_materialize({ G.C.SECONDARY_SET.Enhanced })
                        G.play:emplace(queen)
                        return true
                    end
                }))
                return {
                    message = 'Its a girl!',
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.deck.config.card_limit = G.deck.config.card_limit + 1
                                return true
                            end
                        }))
                        draw_card(G.play, G.deck, 90, 'up')
                        SMODS.calculate_context({ playing_card_added = true, cards = { queen } })
                    end
                }
            end
            if chrank == 5 or chrank == 6 then
                local jack = SMODS.create_card { set = "Playing Card", rank = "Jack", area = G.discard, enhancement = enhancement.key }
                print(enhancement.key)
                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                jack.playing_card = G.playing_card
                table.insert(G.playing_cards, jack)

                G.E_MANAGER:add_event(Event({
                    func = function()
                        jack:start_materialize({ G.C.SECONDARY_SET.Enhanced })
                        G.play:emplace(jack)
                        return true
                    end
                }))
                return {
                    message = 'Its a boy?',
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.deck.config.card_limit = G.deck.config.card_limit + 1
                                return true
                            end
                        }))
                        draw_card(G.play, G.deck, 90, 'up')
                        SMODS.calculate_context({ playing_card_added = true, cards = { jack } })
                    end
                }
            end
            if chrank == 7 then
                return {
                    message = 'Miscarriage :('
                }
            end
        end
        if context.end_of_round and context.game_over == false and context.main_eval then
            card.ability.extra.father = false
            card.ability.extra.mother = false
        end
    end
}

SMODS.Joker {
    key = 'jam_monochromatic',
    loc_txt = {
        name = 'Monochromatic Joker',
        text = {
            'Debuffs all suits except for {C:attention}#1#{}',
            '{X:red,C:white}X#2#{} Mult',
            '{C:inactive}(Suit changes at the end of the round){}'
        }
    },
    blueprint_compat = false,
    rarity = 2,
    cost = 5,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 8, y = 1 },
    pools = { ["Jambatro"] = true },

    config = { extra = { suit = 'Hearts', xmult = 3, suit_number = 1 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.suit, card.ability.extra.xmult } }
    end,

    calculate = function(self, card, context)
        if context.starting_shop and not context.blueprint then
            local suits_in_deck = {}
            for k, v in pairs(G.playing_cards) do
                local suit = v.base.suit
                local match = false
                for i = 1, #suits_in_deck do
                    if suit == suits_in_deck[i] or suit == card.ability.extra.suit then
                        match = true
                    end
                end
                if match == false then
                    suits_in_deck[#suits_in_deck + 1] = suit
                end
            end
            local position = pseudorandom('suit', 1, #suits_in_deck)
            card.ability.extra.suit = suits_in_deck[position]
        end
        if context.setting_blind and not context.blueprint then
            for k, v in pairs(G.playing_cards) do
                if not v:is_suit(card.ability.extra.suit) then
                    SMODS.debuff_card(v, true, "thistextisredundant")
                end
            end
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            for k, v in pairs(G.playing_cards) do
                if not v:is_suit(card.ability.extra.suit) then
                    SMODS.debuff_card(v, false, "thistextisredundant")
                end
            end
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        for k, v in pairs(G.playing_cards) do
            if not v:is_suit(card.ability.extra.suit) then
                SMODS.debuff_card(v, false, "thistextisredundant")
            end
        end
    end
}

SMODS.Sound({key = "Jezza", path = "TG - Jezza.mp3",})
SMODS.Sound({key = "Hamster", path = "TG - Hamster.mp3",})
SMODS.Sound({key = "Slow", path = "TG - James.mp3",})

SMODS.Joker {
    key = 'jam_trinity',
    loc_txt = {
        name = 'The Holy Trinity',
        text = {
            'Current presenter: {C:attention}#1#{}',
            'Jezza: {C:attention}Face{} cards give {X:chips,C:white}X1.2{} Chips',
            'Hamster: Destroys first {C:attention}2{} played {C:attention}cards{} in hand',
            'Cpt. Slow: {C:blue}+2{} Hand size',
            '{C:inactive}(Presenter changes at the end of the round){}'
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 3, y = 1 },
    pools = { ["Jambatro"] = true },

    config = { 
        extra = { 
            man = 'Jezza', 
            xchips = 1.2, 
            h_size = 2,
        } 
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.man, card.ability.extra.xchips } }
    end,

    calculate = function(self, card, context)
        if context.starting_shop and not context.blueprint then
            if card.ability.extra.man == 'Cpt. Slow' then
                G.hand:change_size(-card.ability.extra.h_size)
            end
            local trio_table = { 'Jezza', 'Cpt. Slow', 'Hamster' }
            local so_called_empty_table = {}
            for i = 1, #trio_table do
                if trio_table[i] ~= card.ability.extra.man then
                    so_called_empty_table[#so_called_empty_table + 1] = trio_table[i]
                end
            end
            local position = pseudorandom("trinity", 1, #so_called_empty_table)
            card.ability.extra.man = so_called_empty_table[position]
            if card.ability.extra.man == 'Cpt. Slow' then
                return {
                    sound = 'jammbo_Slow',
                    message = ''
                }
            end
            if card.ability.extra.man == 'Hamster' then
                return {
                    sound = 'jammbo_Hamster',
                    message = ''
                }
            end
            if card.ability.extra.man == 'Jezza' then
                return {
                    sound = 'jammbo_Jezza',
                    message = ''
                }
            end
        end
        if card.ability.extra.man == 'Jezza' then
            if context.individual and context.cardarea == G.play and context.other_card:is_face() then
                return {
                    xchips = card.ability.extra.xchips
                }
            end
        end
        if card.ability.extra.man == 'Hamster' then
            if context.destroy_card and context.scoring_hand and context.cardarea == G.play and (context.destroy_card == context.full_hand[1] or context.destroy_card == context.full_hand[2]) and not context.blueprint then
                return {
                    remove = true,
                    message = 'Car Crash!'
                }
            end
        end
        if card.ability.extra.man == 'Cpt. Slow' then
            if context.setting_blind then
                G.hand:change_size(card.ability.extra.h_size)
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        local position = pseudorandom("trinity", 1, 3)
            if card.ability.extra.man == 'Jezza' then
                local man_no = { 'Cpt. Slow', 'Hamster', 'Jezza' }
                card.ability.extra.man = man_no[position]
            end
    end,
}

SMODS.Joker {
    key = 'jam_santa',
    loc_txt = {
        name = 'Joker Christmas',
        text = {
            'On {C:attention}Christmas Day{}, {X:red,C:white}X3{} Mult',
            '{C:inactive}Current date: #2#/#1#{}'
        }
    },
    blueprint_compat = true,
    rarity = 1,
    cost = 5,
    discovered = true,
    eternal_compat = false,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 5, y = 1 },
    pools = { ["Jambatro"] = true },

    config = { extra = { month = tonumber(os.date("%m")), day = tonumber(os.date("%d")), xmult = 3 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.month, card.ability.extra.day } }
    end,

    calculate = function (self, card, context)
        if context.joker_main then
            if (tonumber(os.date("%d")) ~= card.ability.extra.day or tonumber(os.date("%d")) ~= card.ability.extra.day + 1) or tonumber(os.date("%m")) ~= card.ability.extra.month then
                SMODS.destroy_cards(G.jokers.cards)
                return {
                    message = 'Naughty List!'
                }
            end
            if card.ability.extra.month == 12 and card.ability.extra.day == 25 then
                return {
                    xmult = card.ability.extra.xmult,
                    message = 'Merry Christmas!'
                }
            end
        end
        if context.starting_shop and not context.blueprint then
            if (tonumber(os.date("%d")) ~= card.ability.extra.day or tonumber(os.date("%d")) ~= card.ability.extra.day + 1) or tonumber(os.date("%m")) ~= card.ability.extra.month then
                SMODS.destroy_cards(G.jokers.cards)
                return {
                    message = 'Naughty List!'
                }
            end
        end
        if context.end_of_round and context.game_over == false and context.main_eval then
            if (tonumber(os.date("%d")) ~= card.ability.extra.day or tonumber(os.date("%d")) ~= card.ability.extra.day + 1) or tonumber(os.date("%m")) ~= card.ability.extra.month then
                SMODS.destroy_cards(G.jokers.cards)
                return {
                    message = 'Naughty List!'
                }
            end
        end
        if context.setting_blind then
            if (tonumber(os.date("%d")) ~= card.ability.extra.day or tonumber(os.date("%d")) ~= card.ability.extra.day + 1) or tonumber(os.date("%m")) ~= card.ability.extra.month then
                SMODS.destroy_cards(G.jokers.cards)
                return {
                    message = 'Naughty List!'
                }
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        card.ability.extra.month = tonumber(os.date("%m"))
        card.ability.extra.day = tonumber(os.date("%d"))
    end,
}

SMODS.Joker {
    key = 'jam_angery',
    loc_txt = {
        name = 'Pissy Joker',
        text = {
            'If 5 cards are {C:attention}played{}, destroys',
            'the last 2 {C:attention}scored{} cards'
        }
    },
    blueprint_compat = false,
    rarity = 2,
    cost = 6,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 2, y = 2 },
    pools = { ["Jambatro"] = true },

    config = { extra = { crashed = false } },

    calculate = function(self, card, context)
        if context.destroy_card and context.scoring_hand and context.cardarea == G.play and 
        #context.full_hand == 5 and (context.destroy_card == context.scoring_hand[#context.scoring_hand] or context.destroy_card == context.scoring_hand[#context.scoring_hand - 1])
        and not context.blueprint then
            card.ability.extra.crashed = true
            return {
                remove = true,
            }
        end

        if context.after and card.ability.extra.crashed == true then
            card.ability.extra.crashed = false
            return {
                message = 'Crashed out!',
            }
        end
    end
}

SMODS.Joker {
    key = 'jam_seagull',
    loc_txt = {
        name = 'Seagull',
        text = {
            '{C:green}#1# in #2#{} chance to steal up to {C:chips}-50{} Chips',
            'and gain {C:red}+#5#{} Mult',
            '{C:green}#3# in #4#{} chance to release Mult and {C:attention}reset{}',
            '{C:inactive}(Currently {}{C:red}+#3#{} {C:inactive}Mult){}',
            '{C:inactive}(Yes, this is an analogy for bird shit){}'
        }
    },
    blueprint_compat = true,
    rarity = 1,
    cost = 6,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 9, y = 2 },
    pools = { ["Jambatro"] = true },

    config = { extra = { mult = 0, mult_bonus = 6, cum_chips = 0, odds = 1, shitted = false } },

    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "seagull")
        return { vars = { numerator, denominator, card.ability.extra.mult, card.ability.extra.cum_chips, card.ability.extra.mult_bonus } }
    end,

    calculate = function(self, card, context)
        local chip_steal = pseudorandom('sgullemoji', -50, -1)
        if context.joker_main then
            if SMODS.pseudorandom_probability(card, "seagull", 1, card.ability.extra.odds) then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_bonus
                card.ability.extra.cum_chips = card.ability.extra.cum_chips - chip_steal
                return {
                    chips = chip_steal,
                    message = '+6'
                }
            end
            if SMODS.pseudorandom_probability(card, "seagull", card.ability.extra.mult, card.ability.extra.cum_chips) then
                card.ability.extra.shitted = true
                return {
                    message = 'Bombs away!',
                    mult = card.ability.extra.mult
                    
                }
            end
        end
        if context.after and card.ability.extra.shitted == true then
            card.ability.extra.mult = 0
            card.ability.extra.cum_chips = 0
            card.ability.extra.shitted = false
        end
    end,

    update = function(self, card, dt)
        if card.ability.extra.mult == 2 or card.ability.extra.mult == 1 or card.ability.extra.mult == 0 then
            card.ability.extra.odds = 1
        else
            card.ability.extra.odds = math.floor(card.ability.extra.mult / 3)
        end
    end
}

SMODS.Joker {
    key = 'jam_starwalker',
    loc_txt = {
        name = 'The Original      Star   Walker',
        text = {
            'Gives {C:chips}+200{} Chips', 
            'or {C:red}+20{} Mult'
        }
    },
    blueprint_compat = true,
    rarity = 3,
    cost = 7,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 7, y = 3 },
    pools = { ["Jambatro"] = true, ["Jambatro_R"] = true },

    config = { extra = { odds = 2 } },

    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "starwalker")
        return { vars = { numerator, denominator } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            if pseudorandom("starwalker", 1, card.ability.extra.odds) == 2 then
                return {
                    mult = 20
                }
            else
                return {
                    chips = 200
                }
            end
        end
    end
}

SMODS.Joker {
    key = 'jam_thanos',
    loc_txt = {
        name = 'Thanos',
        text = {
            'Destroys all played {C:attention}cards{} until',
            '{C:attention}deck{} size is {C:attention}#1#{} cards',
            'When {C:purple}balanced{}, {X:mult,C:white}X#3#{} for',
            'every {C:attention}Hand{} you have left'
        }
    },
    blueprint_compat = true,
    rarity = 4,
    cost = 20,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 4, y = 4 },
    soul_pos = { x = 9, y = 0 },

    config = { extra = { preferred_size = 26, difference = 0, balanced = false, xmult = 1 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.preferred_size, card.ability.extra.difference, card.ability.extra.xmult } }
    end,

    calculate = function(self, card, context)
        if card.ability.extra.difference <= 0 then
            if context.after then
                card.ability.extra.balanced = true
                return {
                    message = 'Perfectly balanced'
                }
            end
        else
            for i = 1, card.ability.extra.difference do
                if context.destroy_card and context.cardarea == G.play and not context.blueprint then
                    card.ability.extra.balanced = false
                    return {
                        remove = true
                    }
                end
            end
        end
        if context.joker_main and card.ability.extra.balanced == true then
            return {
                xmult = (1 + G.GAME.current_round.hands_left) * card.ability.extra.xmult
            }
        end
    end,

    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            card.ability.extra.preferred_size = G.GAME.starting_deck_size / 2
            card.ability.extra.difference = (#G.playing_cards - card.ability.extra.preferred_size)
        else
            card.ability.extra.preferred_size = 26
            card.ability.extra.difference = 0
        end
    end
}

SMODS.Joker {
    key = 'jam_eeffoc',
    loc_txt = {
        name = 'Its Eeffoc...',
        text = {
            'If {C:attention}straight{} is played',
            'backwards, {C:red}+13{} mult',
            '{C:inactive}(ex: 10, J, Q, K, A)'
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 5,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 7, y = 4 },
    pools = { ["Jambatro"] = true },

    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands['Straight']) then
            local backwards = true
            local rankpr = 0
            for i = 1, #G.play.cards do
                local rank = G.play.cards[i]:get_id()
                if rank < rankpr then
                    backwards = false
                end
                rankpr = rank
            end
            if backwards == true then
                return {
                    mult = 13
                }
            end
        end
    end
}

SMODS.Sound({key = "thoogle", path = "thoogle.mp3",})

SMODS.Joker {
    key = 'jam_cthoogle',
    loc_txt = {
        name = "The Cthoogle Joker",
        text = {
            'Each scored {C:attention}6{} has a',
            '{C:green}#1# in #2#{} chance of',
            'creating a {C:purple}Tarot{} card',
            '{C:inactive}(Must have room){}'
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 7,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 8, y = 4 },
    pools = { ["Jambatro"] = true },

    config = { extra = { odds = 3 } },

    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'thoogle')
        return { vars = { numerator, denominator } }
    end,

    calculate = function(self, card, context)
        if context.setting_blind then
            if next(SMODS.find_card('j_jammbo_jam_rosen')) then
                SMODS.destroy_cards(SMODS.find_card('j_jammbo_jam_rosen'))
                SMODS.calculate_effect({message = "Go to hell"}, card)
            end
        end
        if context.individual and context.cardarea == G.play and
            #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            if (context.other_card:get_id() == 6) and SMODS.pseudorandom_probability(card, 'thoogle', 1, card.ability.extra.odds) then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                return { 
                    message = "???",
                    sound = "jammbo_thoogle",
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = (function()
                                SMODS.add_card {
                                    set = 'Tarot',
                                }
                                G.GAME.consumeable_buffer = 0
                                return true
                            end)
                        }))
                    end
                }
            end
        end
    end,
    
    add_to_deck = function(self, card, from_debuff)
        if next(SMODS.find_card('j_jammbo_jam_rosen')) then
            SMODS.destroy_cards(SMODS.find_card('j_jammbo_jam_rosen'))
            SMODS.calculate_effect({message = "Go to hell"}, card)
        end
    end,
}

SMODS.Joker {
    key = 'jam_soul',
    loc_txt = {
        name = "H265.Soul.Spectral.1080p_[ENG].torrent",
        text = {
            'Sell this joker for',
            'a {C:green}#1# in #2#{} chance of creating',
            'a {C:purple}Legendary{} Joker, or else',
            'creates a {C:blue}Common{} Joker'
        }
    },
    blueprint_compat = true,
    rarity = 3,
    cost = 18,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 5, y = 4 },
    soul_pos = { x = 1, y = 5 },
    pools = { ["Jambatro"] = true, ["Jambatro_R"] = true },

    config = { extra = { odds = 3 } },

    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'soul')
        return { vars = { numerator, denominator } }
    end,

    calculate = function(self, card, context)
        if context.selling_self then
            if SMODS.pseudorandom_probability(card, 'soul', 1, card.ability.extra.odds) then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.4,
                    func = function()
                        card:remove()
                        play_sound('timpani')
                        SMODS.add_card({ set = 'Joker', legendary = true })
                        check_for_unlock { type = 'spawn_legendary' }
                        card:juice_up(0.3, 0.5)
                        return true
                    end
                }))
            else
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.4,
                    func = function()
                        card:remove()
                        play_sound('timpani')
                        SMODS.add_card({ set = 'Joker', rarity = 'Common' })
                        card:juice_up(0.3, 0.5)
                        return true
                    end
                }))
            end
        end
    end
}

SMODS.Joker {
    key = 'jam_chipshop',
    loc_txt = {
        name = "Chip Shop",
        text = {
            'Lose {C:money}$#2#{} and gain {C:chips}+6{} chips',
            'at the {C:attention}start of the round{}',
            '{C:inactive}(Currently {}{C:chips}+#1#{} {C:inactive}Chips){}',
            '{C:inactive}Wont accept money below 0'
        }
    },
    blueprint_compat = true,
    rarity = 1,
    cost = 8,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    atlas = 'Jammbo',
    pos = { x = 9, y = 1 },
    pools = { ["Jambatro"] = true },

    config = { extra = { dollars = 2, chips = 0, chips_bonus = 8 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.dollars } }
    end,

    calculate = function(self, card, context)
        if context.setting_blind and G.GAME.dollars >= card.ability.extra.dollars then
            G.GAME.dollars = G.GAME.dollars - card.ability.extra.dollars
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_bonus
            return {
                message = 'Heres your dinner, luv'
            }
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
    end
}

SMODS.Sound({key = "mustard", path = "mustardbeat.mp3",})

SMODS.Joker {
    key = 'jam_kendrick',
    loc_txt = {
        name = "Jokendrick",
        text = {
            'If hand contains a',
            '{C:attention}6{} and {C:attention}7{}, {X:red,C:white}X#1#{} Mult',
            'Gains {X:red,C:white}X#2#{} Mult when a',
            '{C:attention}Mustard Card{} is scored'
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 8,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 9, y = 3 },
    pools = { ["Jambatro"] = true },

    config = { extra = { xmult = 1.5, six = false, seven = false, xmult_gain = 0.2, mod_conv = 'm_jammbo_jam_mustard' } },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.mod_conv]
        return { vars = { card.ability.extra.xmult, card.ability.extra.xmult_gain } }
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual and context.other_card and not context.blueprint then
            local rank = context.other_card:get_id()
            if rank == 6 then
                card.ability.extra.six = true
			end
            if rank == 7 then
                card.ability.extra.seven = true
			end
            if SMODS.has_enhancement(context.other_card, "m_jammbo_jam_mustard") then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
                return {
                    message = 'Upstard!'
                }
            end
		end
        
        if context.joker_main then
            if card.ability.extra.six == true and card.ability.extra.seven == true then
                card.ability.extra.six = false
                card.ability.extra.seven = false
                return {
                    xmult = card.ability.extra.xmult,
                    sound = 'jammbo_mustard'
                }
            end
        end
    end
}

SMODS.Joker {
    key = 'jam_rufus',
    loc_txt = {
        name = "Whimsy Joker",
        text = {
            'Whether you play a {C:attention}#3#{},',
            'or you discard a {C:attention}#4#{}...',
            'Joker gains {C:chips}+#2#{} Chips',
            '{C:inactive}(Currently {}{C:chips}+#1#{} {C:inactive}Chips){}',
            '{C:inactive}(Ranks change at the end of the round){}'
        }
    },
    blueprint_compat = true,
    rarity = 1,
    cost = 7,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    atlas = 'Jammbo',
    pos = { x = 0, y = 4 },
    pools = { ["Jambatro"] = true },

    config = { extra = { rank1 = 2, rank2 = 3, chips = 0, chips_gain = 7, rank1d = '2', rank2d = '3' } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.chips_gain, card.ability.extra.rank1d, card.ability.extra.rank2d } }
    end,

    calculate = function(self, card, context)
        if context.starting_shop and not context.blueprint then
            card.ability.extra.rank1 = pseudorandom("whimsy", 2, 14)
            card.ability.extra.rank2 = pseudorandom("whimsy", 2, 14)
        end
        if context.cardarea == G.play and context.individual and context.other_card then
            local rank = context.other_card:get_id()
            if rank == card.ability.extra.rank1 then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_gain
                return {
                    message = 'Upgrade!'
                }
            end
        end
         if context.discard and not context.other_card.debuff and context.other_card:get_id() == card.ability.extra.rank2 then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_gain
            return {
                message = 'Upgrade!'
            }
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
    end,

    add_to_deck = function(self, card, from_debuff)
        card.ability.extra.rank1 = pseudorandom("whimsy", 2, 14)
        card.ability.extra.rank2 = pseudorandom("whimsy", 2, 14)
    end,

    update = function(self, card, dt)
        local display_message = true
        if card.ability.extra.rank1 <= 10 then
            card.ability.extra.rank1d = card.ability.extra.rank1
        else
            if card.ability.extra.rank1 == 11 then
                card.ability.extra.rank1d = 'Jack'
            end
            if card.ability.extra.rank1 == 12 then
                card.ability.extra.rank1d = 'Queen'
            end
            if card.ability.extra.rank1 == 13 then
                card.ability.extra.rank1d = 'King'
            end
            if card.ability.extra.rank1 == 14 then
                card.ability.extra.rank1d = 'Ace'
            end
        end
        if card.ability.extra.rank2 <= 10 then
            card.ability.extra.rank2d = card.ability.extra.rank2
        else
            if card.ability.extra.rank2 == 11 then
                card.ability.extra.rank2d = 'Jack'
            end
            if card.ability.extra.ran21 == 12 then
                card.ability.extra.rank2d = 'Queen'
            end
            if card.ability.extra.rank2 == 13 then
                card.ability.extra.rank2d = 'King'
            end
            if card.ability.extra.rank2 == 14 then
                card.ability.extra.rank2d = 'Ace'
            end
        end
    end
}

SMODS.Joker {
    key = 'jam_freaky',
    loc_txt = {
        name = "Freaky Joker",
        text = {
            'Gain {X:red,C:white}X#6#{} Mult when a {C:blue}Spectral{} card is used',
            'Gain {C:red}+#2#{} Mult when a {C:planet}Planet{} card is used',
            'Gain {C:chips}+#4#{} Chips when a {C:purple}Tarot{} card is used',
            '{C:inactive}(Currently {C:chips}+#3#{} {C:inactive}Chips and {}{C:red}+#1#{} {C:inactive}Mult and {}{X:red,C:white}X#5#{} {C:inactive}Mult){}'
        }
    },
    blueprint_compat = true,
    rarity = 1,
    cost = 6,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    atlas = 'Jammbo',
    pos = { x = 6, y = 4 },
    pools = { ["Jambatro"] = true },

    config = { extra = { mult = 0, mult_gain = 1, chips = 0, chips_gain = 10, xmult = 1, xmult_gain = 0.1, planets_used = 0, tarots_used = 0, spectrals_used = 0 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.mult_gain, card.ability.extra.chips, card.ability.extra.chips_gain, card.ability.extra.xmult, card.ability.extra.xmult_gain } }
    end,

    calculate = function(self, card, context)
        if context.using_consumeable and not context.blueprint and context.consumeable.ability.set == ("Planet") then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
            return {
                message = 'Power Up!'
            }
        end
        if context.using_consumeable and not context.blueprint and context.consumeable.ability.set == ("Tarot") then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_gain
            return {
                message = 'Power Up!'
            }
        end
        if context.using_consumeable and not context.blueprint and context.consumeable.ability.set == ("Spectral") then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
            return {
                message = 'Power Up!'
            }
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
                xmult = card.ability.extra.xmult
            }
        end
    end,
}

SMODS.Sound({key = "pan", path = "fryingpan.mp3",})

SMODS.Joker {
    key = 'jam_goldenpan',
    loc_txt = {
        name = "Golden Frying Pan",
        text = {
            'Gains obscenely high {C:money}sell{}',
            '{C:money}value{} after {C:attention}#3#{} rounds',
            'When {C:attention}Joker{} sold, {C:green}#1# in #2#{} chance of',
            'being scammed for a lower {C:money}price{}'
        }
    },
    blueprint_compat = false,
    rarity = 3,
    cost = 20,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    atlas = 'Jammbo',
    pos = { x = 9, y = 4 },
    soul_pos = { x = 0, y = 5 },
    pools = { ["Jambatro"] = true, ["Jambatro_R"] = true },
    
    config = { extra = { rounds = 6, gained = false, odds = 6 } },

    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "frying_pan")
        return { vars = { numerator, denominator, card.ability.extra.rounds } }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if card.ability.extra.rounds ~= 0 then
                card.ability.extra.rounds = card.ability.extra.rounds - 1
                return {
                    message = '-1'
                }
            else
                if card.ability.extra.gained == false then
                    card.ability.extra_value = pseudorandom('thestockmarket!!', 150, 200)
                    card:set_cost()
                    card.ability.extra.gained = true
                    return {
                        message = 'Item Tradeable!'
                    }
                end
            end
        end
        if context.selling_self and not context.blueprint then
            if card.ability.extra.gained == true then
                if SMODS.pseudorandom_probability(card, "frying_pan", 1, card.ability.extra.odds) then
                    card.ability.extra_value = card.ability.extra_value - (card.ability.extra_value * 2)
                    card:set_cost()
                    card.ability.extra_value = pseudorandom('thestockmarket!!', 0, 30)
                    card:set_cost()
                    return {
                        message = 'Unlucky!'
                    }
                else
                    return {
                        message = 'Trade Success!'
                    }
                end
            else
                card.ability.extra_value = card.ability.extra_value - (card.ability.extra_value * 2)
                card:set_cost()
                return {
                    message = 'Item Destroyed'
                }
            end
        end
    end,

    add_to_deck = function(self, card, from_debuff)
        play_sound('jammbo_pan')
    end,
}

SMODS.Joker {
    key = 'jam_jammbo',
    loc_txt = {
        name = 'Jammbo TF2',
        text = {
            'If hand score exceeds',
            '{C:attention}1709{}, earn {C:money}$6{}'
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 2, y = 4 },
    pools = { ["Jambatro"] = true },

    calculate = function(self, card, context)
        if context.final_scoring_step then
            if hand_chips * mult > 1709 then
                return {
                    dollars = 6
                }
            end
        end
    end
}

SMODS.Sound({key = "continue", path = "1up.mp3",})
SMODS.Sound({key = "over", path = "gameover.mp3",})
SMODS.Sound({key = "death", path = "sonicded.mp3",})

SMODS.Joker {
    key = 'jam_1up',
    loc_txt = {
        name = "Extra Life Monitor",
        text = {
            'If scored {C:attention}chips{} is over {C:attention}#2#%{} of',
            'required {C:attention}Blind score{}, gain an {C:chips}extra life{}',
            '{C:inactive}(Currently #3# Required Chips){}',
            '{C:chips}Extra life{} consumed if a Blind is {C:red}failed{}',
            '{C:inactive}(Can only gain 1 life per Ante){}',
            '{C:inactive}(Requirement scales with amount of lives){}',
            '{C:inactive}(Currently x{}{C:chips}#1#{}{C:inactive} Life){}'
        }
    },
    blueprint_compat = false,
    rarity = 2,
    cost = 12,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    atlas = 'Jammbo',
    pos = { x = 3, y = 5 },
    pixel_size = { h = 76 },
    pools = { ["Jambatro"] = true },

    config = { extra = { ups = 0, gained_ante = false, required = 1.5, required_p = 150, actual_score = 0 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.ups, card.ability.extra.required_p, card.ability.extra.actual_score } }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint and card.ability.extra.gained_ante == false then
            if G.GAME.chips / G.GAME.blind.chips >= card.ability.extra.required then
                card.ability.extra.ups = card.ability.extra.ups + 1
                card.ability.extra.gained_ante = true
                return {
                    message = 'Extra Life!',
                    sound = 'jammbo_continue'
                }
            end
        end
        if context.end_of_round and context.game_over and context.main_eval and not context.blueprint then
            if card.ability.extra.ups > 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.hand_text_area.blind_chips:juice_up()
                        G.hand_text_area.game_chips:juice_up()
                        play_sound('jammbo_death')
                        card.ability.extra.ups = card.ability.extra.ups - 1
                        return true
                    end
                }))
                return {
                    message = 'Lost a life!',
                    saved = 'ph_extra_life',
                    colour = G.C.RED
                }
            end
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if G.GAME.blind.boss then
                card.ability.extra.gained_ante = false
            end
        end
        if context.end_of_round and context.game_over == true and context.main_eval and not context.blueprint then
            play_sound('jammbo_over')
        end
    end,

    update = function(self, card, dt)
        card.ability.extra.required = 1.5 + (0.5 * card.ability.extra.ups)
        card.ability.extra.required_p = card.ability.extra.required * 100
        if G.STAGE == G.STAGES.RUN then
            card.ability.extra.actual_score = G.GAME.blind.chips * card.ability.extra.required
        else
            card.ability.extra.actual_score = 0
        end
    end
}

SMODS.Joker {
    key = 'jam_solarpanel',
    loc_txt = {
        name = "Solar Panel",
        text = {
            'Absorbs {C:attention}#2#%{} of all Mult when',
            'scored for {C:attention}#1#{} rounds',
            'and scores stored Mult',
            'as {X:red,C:white}XMult{} on the final round',
            '{C:inactive}(Currently {}{X:red,C:white}X#3#{}{C:inactive} Mult){}',
            '{C:inactive}Always scores last{}'

        }
    },
    blueprint_compat = false,
    rarity = 2,
    cost = 7,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 2, y = 5 },
    pools = { ["Jambatro"] = true },

    config = { extra = { rounds = 3, percent = 10, mult = 1, absorb = 0, released = false } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.rounds, card.ability.extra.percent, card.ability.extra.mult, card.ability.extra.absorb } }
    end,

    calculate = function(self, card, context)
        if context.final_scoring_step and not context.blueprint then
            if card.ability.extra.rounds > 0 then
                card.ability.extra.absorb = mult / card.ability.extra.percent
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.absorb
                return {
                    mult = -card.ability.extra.absorb
                }
            else
                if card.ability.extra.released == false then
                    card.ability.extra.released = true
                    return {
                        xmult = card.ability.extra.mult
                    }
                else
                    card.ability.extra.mult = 1
                end
            end
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if card.ability.extra.rounds > 0 then
                card.ability.extra.rounds = card.ability.extra.rounds - 1
            else
                if card.ability.extra.released == true then
                    card.ability.extra.released = false
                    card.ability.extra.mult = 1
                end
                card.ability.extra.rounds = 3
            end
        end
    end
}

SMODS.Joker {
    key = 'jam_ascension',
    loc_txt = {
        name = 'Ascended Jimbo',
        text = {
            '{X:red,C:white}X4{} Mult',
        }
    },
    blueprint_compat = true,
    rarity = 4,
    cost = 10,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 4, y = 5 },
    soul_pos = { x = 5, y = 5 },

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = 4
            }
        end
    end
}

SMODS.Joker {
    key = 'jam_steak',
    loc_txt = {
        name = 'Steak',
        text = {
            'Gains {C:red}+3{} Mult at the end of the round',
            'When Mult reaches {C:red}+21{}, lasts for 2 more rounds',
            'until it burns',
            '{C:inactive}(Currently {}{C:red}+#1#{}{C:inactive} Mult){}'
        }
    },
    blueprint_compat = true,
    rarity = 1,
    cost = 7,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 6, y = 5 },
    pools = { ["Jambatro"] = true },

    config = { extra = { mult = 3, rounds = 1 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.rounds } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if card.ability.extra.rounds <= 6 then
                card.ability.extra.rounds = card.ability.extra.rounds + 1
                card.ability.extra.mult = card.ability.extra.rounds * 3
                return {
                    message = 'Cooking!'
                }
            else
                if card.ability.extra.rounds <= 7 then
                    card.ability.extra.rounds = card.ability.extra.rounds + 1
                    card.ability.extra.mult = 21
                else
                    card:remove()
                    return{ message = "Burnt!" }
                end
            end
        end
    end
}

SMODS.Sound({key = "easy", path = "that_was_easy.mp3",})

SMODS.Joker {
    key = 'jam_instawin',
    loc_txt = {
        name = 'Instant Win Button',
        text = {
            '{C:attention}Destroys{} all scored {C:attention}3s{}',
            'If {C:red}penultimate{} hand of the round is a',
            'single {C:attention}3{}, instantly {C:green}win the round',
            'and sets your {C:money}money{} to {C:attention}0',
            '{C:inactive}(Can be used {}{C:attention}#1#{}{C:inactive} more times){}'
        }
    },
    blueprint_compat = false,
    rarity = 3,
    cost = 9,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 11, y = 0 },
    pools = { ["Jambatro"] = true, ["Jambatro_R"] = true },

    config = { extra = { win = false, uses = 2 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.uses } }
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual and context.other_card and #context.full_hand == 1 and not context.blueprint then
            local rank = context.other_card:get_id()
            if rank == 3 and G.GAME.current_round.hands_left == 1 then
                card.ability.extra.win = true
                return {
                    sound = 'jammbo_easy',
                    message = 'You Win!'
                }
            end
        end
        if context.destroy_card and context.scoring_hand and context.cardarea == G.play and context.destroy_card:get_id() == 3 and not context.blueprint then
            return {
                remove = true
            }
        end
        if context.final_scoring_step and card.ability.extra.win == true and card.ability.extra.uses > 0 and not context.blueprint then
            local currentchips = hand_chips
            local currentmult = mult
            local neededscore = G.GAME.blind.chips - G.GAME.chips
            card.ability.extra.win = false
            card.ability.extra.uses = card.ability.extra.uses - 1
            G.GAME.dollars = 0
            return {
                chips = (( neededscore / currentmult ) - currentchips) + 2
            }
        end
    end
}

SMODS.Joker {
    key = 'jam_swaws',
    loc_txt = {
        name = 'SwawS',
        text = {
            'If {C:attention}Two Pair{} or {C:attention}Full House{}',
            'played mirrored, {C:red}+14{} Mult',
            '{C:inactive}(ex: 10, 4, 4, 4, 10 or 3, 7, 7, 3)',
            '{C:attention}Outliers must be outside the mirror',
            '{C:inactive}(ex: 9, 5, 5, 9, 1 or 1, 9, 5, 5, 9)',
        }
    },
    blueprint_compat = true,
    rarity = 1,
    cost = 4,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 10, y = 1 },
    pools = { ["Jambatro"] = true },

    calculate = function(self, card, context)
        if context.joker_main then
            if #context.scoring_hand == 4 and context.scoring_hand[1]:get_id() == context.scoring_hand[4]:get_id() and 
            context.scoring_hand[2]:get_id() == context.scoring_hand[3]:get_id() then
                return {
                    mult = 14
                }
            end
            if #context.scoring_hand == 5 and 
            context.scoring_hand[1]:get_id() == context.scoring_hand[5]:get_id() and 
            context.scoring_hand[2]:get_id() == context.scoring_hand[3]:get_id() and 
            context.scoring_hand[3]:get_id() == context.scoring_hand[4]:get_id() then
                return {
                    mult = 14
                }
            end
            local mirrored = false
            if next(context.poker_hands['Two Pair']) and not next(context.poker_hands['Full House']) then
                local playedranks = {}
                for i = 1, #context.scoring_hand do
                    playedranks[#playedranks+1] = context.scoring_hand[i]:get_id()
                end
                local leastcommonrank = 0
                local lastcount = 100
                for i = 1, #playedranks do
                    local counter = 0
                    for p = 1, #playedranks do
                        if playedranks[i] == playedranks[p] then counter = counter + 1 end
                    end
                    if counter < lastcount then
                        leastcommonrank = playedranks[i]
                        lastcount = counter
                    end
                end
                if #context.scoring_hand == 5 and context.scoring_hand[1]:get_id() == context.scoring_hand[4]:get_id() and 
                context.scoring_hand[2]:get_id() == context.scoring_hand[3]:get_id() and context.scoring_hand[5] == leastcommonrank then
                    return {
                        mult = 14
                    }
                end
                if #context.scoring_hand == 5 and context.scoring_hand[2]:get_id() == context.scoring_hand[5]:get_id() and 
                context.scoring_hand[3]:get_id() == context.scoring_hand[4]:get_id() and context.scoring_hand[1] == leastcommonrank then
                    return {
                        mult = 14
                    }
                end
                if #context.scoring_hand == 6 and not context.blueprint then
                    return {
                        message = 'Go fuck yourself'
                    }
                end
            end
        end
    end
}

SMODS.Joker {
    key = 'jam_picky',
    loc_txt = {
        name = 'Picky Eater',
        text = {
            'Debuffs all {C:purple}Tarot{} cards,',
            'creates a random {C:blue}Spectral{} card',
            'at the end of every {C:attention}Boss blind{}',
            '{C:inactive}(Leaves a sour taste. All held',
            '{C:inactive}Tarot cards remain Debuffed)',
            '{C:inactive}(Must have room)'
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 7,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 10, y = 2 },
    pools = { ["Jambatro"] = true },

    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval then
            if G.GAME.blind.boss then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 2
                SMODS.calculate_effect({message = "Dino Nuggies!"}, card)
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                for i = 1, 2 do
                                    SMODS.add_card {
                                        set = 'Spectral',
                                    }
                                end
                                G.GAME.consumeable_buffer = 0
                                return true
                            end
                        }))
                        return true
                    end)
                }))
                return nil, true
            end
        end
    end,

    update = function(self, card, dt)
        if next(SMODS.find_card('j_jammbo_jam_picky')) then
            for _, v in pairs(G.I.CARD) do
                if v.ability and v.ability.set and v.ability.set == "Tarot" then
                    SMODS.debuff_card(v, true, "tarotdebuff")
                end
            end
        else
            for _, v in pairs(G.I.CARD) do
                if v.ability and v.ability.set and v.ability.set == "Tarot" then
                    SMODS.debuff_card(v, false, "tarotdebuff")
                end
            end
        end
    end,

}

SMODS.Joker {
    key = "jam_diamondcards",
    loc_txt = {
        name = 'Diamond Dealer',
        text = {
            '{X:chips,C:white}X#1#{} Chips for',
            'each {C:attention}Diamond card{} in your deck',
            '{C:inactive}(Currently {}{X:chips,C:white}X#2#{} {C:inactive}Chips){}',
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 7,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 10, y = 5 },
    pools = { ["Jambatro"] = true },

    config = { extra = { xchips = 0.2 } },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS['m_jammbo_jam_diamond']
        local diamond_tally = 0
        if G.playing_cards then
            for _, playing_card in ipairs(G.playing_cards) do
                if SMODS.has_enhancement(playing_card, 'm_jammbo_jam_diamond') then diamond_tally = diamond_tally + 1 end
            end
        end
        return { vars = { card.ability.extra.xchips, (card.ability.extra.xchips * diamond_tally) + 1 } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local diamond_tally = 0
            for _, playing_card in ipairs(G.playing_cards) do
                if SMODS.has_enhancement(playing_card, 'm_jammbo_jam_diamond') then diamond_tally = diamond_tally + 1 end
            end
            return {
                xchips = (card.ability.extra.xchips * diamond_tally) + 1
            }
        end
    end,
    in_pool = function(self, args)
        for _, playing_card in ipairs(G.playing_cards or {}) do
            if SMODS.has_enhancement(playing_card, 'm_jammbo_jam_diamond') then
                return true
            end
        end
        return false
    end
}

SMODS.Joker {
    key = "jam_discards",
    loc_txt = {
        name = 'Discard Master',
        text = {
            'Gain {C:chips}+#2#{} chips if you have no discards',
            'and you play a {C:attention}High Card{} with',
            '4 other {C:attention}unscored{} cards',
            '{C:inactive}(Currently {}{C:chips}+#1#{} {C:inactive}Chips){}',
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 5,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    atlas = 'Jammbo',
    pos = { x = 9, y = 5 },
    pools = { ["Jambatro"] = true },

    config = { extra = { chips = 0, chip_gain = 30 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.chip_gain } }
    end,

    calculate = function(self, card, context)
        if context.before and G.GAME.current_round.discards_left == 0 and not context.blueprint then
            if #context.full_hand >= 5 and #context.scoring_hand == 1 then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
                SMODS.calculate_effect({message = "Upgrade!"}, card)
            end
        end

        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
    end
}

SMODS.Joker {
    key = "jam_kings",
    loc_txt = {
        name = 'The King Will Come',
        text = {
            'Retrigger all {C:attention}Kings',
            'when played or held in hand'
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 7,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    atlas = 'Jammbo',
    pos = { x = 10, y = 0 },
    pools = { ["Jambatro"] = true },

    config = { extra = { repetitions = 1 } },
    
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and context.other_card:get_id() == 13 then
            return {
                repetitions = card.ability.extra.repetitions
            }
        end
        if context.repetition and context.cardarea == G.hand and context.other_card:get_id() == 13 and (next(context.card_effects[1]) or #context.card_effects > 1) then
            return {
                repetitions = card.ability.extra.repetitions
            }
        end
    end,
}

SMODS.Joker {
    key = "jam_jacking",
    loc_txt = {
        name = 'Jacking It',
        text = {
            'Retrigger all {C:attention}Jacks',
            'when played or held in hand'
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 7,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    atlas = 'Jammbo',
    pos = { x = 10, y = 4 },
    pools = { ["Jambatro"] = true },

    config = { extra = { repetitions = 1 } },
    
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and context.other_card:get_id() == 11 then
            return {
                repetitions = card.ability.extra.repetitions
            }
        end
        if context.repetition and context.cardarea == G.hand and context.other_card:get_id() == 11 and (next(context.card_effects[1]) or #context.card_effects > 1) then
            return {
                repetitions = card.ability.extra.repetitions
            }
        end
    end,
}

SMODS.Joker {
    key = "jam_lootbox",
    loc_txt = {
        name = 'Mann Co. Crate',
        text = {
            'Every {C:money}purchase{} has a',
            '{C:green}#1# in #2#{} chance of',
            'creating a {C:purple}Tarot{} card',
            '{C:inactive}(Rerolls are not purchases)'
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 8,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    atlas = 'Jammbo',
    pos = { x = 6, y = 6 },
    soul_pos = { x = 5, y = 6 },
    pools = { ["Jambatro"] = true },

    config = { extra = { odds = 4 } },

    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "micro")
        return { vars = { numerator, denominator } }
    end,

    calculate = function(self, card, context)
        if context.buying_card and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            if SMODS.pseudorandom_probability(card, "micro", 1, card.ability.extra.odds) then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                        SMODS.add_card {
                            set = 'Tarot',
                        }
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
                return {
                    message = 'Free Gift!',
                    colour = G.C.PURPLE,
                }
            end
        end
        if context.open_booster and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            if SMODS.pseudorandom_probability(card, "micro", 1, card.ability.extra.odds) then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                        SMODS.add_card {
                            set = 'Tarot',
                        }
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
                return {
                    message = 'Free Gift!',
                    colour = G.C.PURPLE,
                }
            end
        end
    end
}

SMODS.Joker {
    key = "jam_duo",
    loc_txt = {
        name = 'Comedy Duo',
        text = {
            '{C:green}#1# in #2#{} chance to Retrigger',
            'each played {C:attention}Enhanced{} card'
        }
    },
    blueprint_compat = true,
    rarity = 3,
    cost = 6,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    atlas = 'Jammbo',
    pos = { x = 7, y = 5 },
    pools = { ["Jambatro"] = true, ["Jambatro_R"] = true },

    config = { extra = { repetitions = 1, odds = 2 } },

    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "comedy")
        return { vars = { numerator, denominator } }
    end,

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and context.other_card and context.other_card.config.center.key ~= "c_base" then
            if SMODS.pseudorandom_probability(card, "comedy", 1, card.ability.extra.odds) then
                return {
                    repetitions = card.ability.extra.repetitions
                }
            end
        end
    end
}

SMODS.Joker {
    key = "jam_sploosh",
    loc_txt = {
        name = 'Sploosh',
        text = {
            '{C:chips}+20{} Chips for every',
            '{C:attention}played{} but {C:attention}unscored{} card'
        }
    },
    blueprint_compat = true,
    rarity = 1,
    cost = 6,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    atlas = 'Jammbo',
    pos = { x = 4, y = 6 },
    pools = { ["Jambatro"] = true },

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = (#context.full_hand - #context.scoring_hand) * 20
            }
        end
    end
}

SMODS.Joker {
    key = "jam_sweets",
    loc_txt = {
        name = 'Sweets Jar',
        text = {
            '{C:red}+#1#{} Mult',
            'loses {C:red}-#3#{} Mult every round, {C:red}refills{}',
            'with {C:red}#4#{} less max Mult after {C:red}#5#{} rounds'
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 8,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    atlas = 'Jammbo',
    pos = { x = 10, y = 3 },
    pools = { ["Jambatro"] = true },

    config = { extra = { mult = 16, max = 16, loss = 2, maxloss = 4, rounds = 2, roundcount = 0 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.max, card.ability.extra.loss, card.ability.extra.maxloss, card.ability.extra.rounds } }
    end,

    calculate = function(self, card, context) 
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if card.ability.extra.mult > 0 then
                card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.loss
                card.ability.extra.roundcount = 0
                return {
                    message = '-2'
                }
            else
                card.ability.extra.roundcount = card.ability.extra.roundcount + 1
            end
        end
        if context.setting_blind and not context.blueprint then
            if card.ability.extra.roundcount == 2 then
                card.ability.extra.max = card.ability.extra.max - card.ability.extra.maxloss
                card.ability.extra.mult = card.ability.extra.max
                if card.ability.extra.max == 0 then
                    card:remove()
                    return {
                        message = 'Empty!'
                    }
                else
                    return {
                        message = 'Refill!'
                    }
                end
            end
        end
    end
}

SMODS.Joker {
    key = "jam_wordle",
    loc_txt = {
        name = 'Cardle',
        text = {
            --'#1# #2# #3# #4# #5#',
            '{s:2}{B:1,C:white}#6#{} {B:2,C:white}#7#{} {B:3,C:white}#8#{} {B:4,C:white}#9#{} {B:5,C:white}#10#{}{}',
            '{s:2}{B:6,C:white}#11#{} {B:7,C:white}#12#{} {B:8,C:white}#13#{} {B:9,C:white}#14#{} {B:10,C:white}#15#{}{}',
            '{s:2}{B:11,C:white}#16#{} {B:12,C:white}#17#{} {B:13,C:white}#18#{} {B:14,C:white}#19#{} {B:15,C:white}#20#{}{}',
            '{s:2}{B:16,C:white}#21#{} {B:17,C:white}#22#{} {B:18,C:white}#23#{} {B:19,C:white}#24#{} {B:20,C:white}#25#{}{}',
            '{s:2}{B:21,C:white}#26#{} {B:22,C:white}#27#{} {B:23,C:white}#28#{} {B:24,C:white}#29#{} {B:25,C:white}#30#{}{}',
            '{s:2}{B:26,C:white}#31#{} {B:27,C:white}#32#{} {B:28,C:white}#33#{} {B:29,C:white}#34#{} {B:30,C:white}#35#{}{}',
            ' ',
            'Play {C:attention}5{} cards to attempt',
            ' ',
            '{C:red}+#36#{} Mult for each',
            '{C:green}correct Placement{} in last attempt',
            ' ',
            '{C:chips}+#37#{} Chips for each',
            '{C:attention}correct Guess{} in last attempt',
            ' ',
            '{X:red,C:white}X#38#{} Mult if board {C:green}Completed'
        }
    },
    blueprint_compat = true,
    rarity = 1,
    cost = 7,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    atlas = 'Jammbo',
    pos = { x = 3, y = 6 },
    pools = { ["Jambatro"] = true },

    config = { extra = {
        tries = 0,
        max = 6,

        grey = '8f8f8f',
        yellow = 'ffdd57',
        green = '8ac486',

        string = {1, 2, 3, 4, 5},

        lines = {
            {'#', '#', '#', '#', '#'},
            {'#', '#', '#', '#', '#'},
            {'#', '#', '#', '#', '#'},
            {'#', '#', '#', '#', '#'},
            {'#', '#', '#', '#', '#'},
            {'#', '#', '#', '#', '#'},
            {'#', '#', '#', '#', '#'},
        },
        display = {
            {'#', '#', '#', '#', '#'},
            {'#', '#', '#', '#', '#'},
            {'#', '#', '#', '#', '#'},
            {'#', '#', '#', '#', '#'},
            {'#', '#', '#', '#', '#'},
            {'#', '#', '#', '#', '#'},
            {'#', '#', '#', '#', '#'},
        },
        lines_c = {
            {'8f8f8f', '8f8f8f', '8f8f8f', '8f8f8f', '8f8f8f'},
            {'8f8f8f', '8f8f8f', '8f8f8f', '8f8f8f', '8f8f8f'},
            {'8f8f8f', '8f8f8f', '8f8f8f', '8f8f8f', '8f8f8f'},
            {'8f8f8f', '8f8f8f', '8f8f8f', '8f8f8f', '8f8f8f'},
            {'8f8f8f', '8f8f8f', '8f8f8f', '8f8f8f', '8f8f8f'},
            {'8f8f8f', '8f8f8f', '8f8f8f', '8f8f8f', '8f8f8f'},
            {'8f8f8f', '8f8f8f', '8f8f8f', '8f8f8f', '8f8f8f'},
        },

        mult = 5,
        chips = 20,
        xmult = 2,

        completed = false
    } },

    loc_vars = function(self, info_queue, card)
        return { vars = {
            card.ability.extra.string[1],
            card.ability.extra.string[2],
            card.ability.extra.string[3],
            card.ability.extra.string[4],
            card.ability.extra.string[5],
            
            colours= {
                HEX(card.ability.extra.lines_c[1][1]),
                HEX(card.ability.extra.lines_c[1][2]),
                HEX(card.ability.extra.lines_c[1][3]),
                HEX(card.ability.extra.lines_c[1][4]),
                HEX(card.ability.extra.lines_c[1][5]),

                HEX(card.ability.extra.lines_c[2][1]),
                HEX(card.ability.extra.lines_c[2][2]),
                HEX(card.ability.extra.lines_c[2][3]),
                HEX(card.ability.extra.lines_c[2][4]),
                HEX(card.ability.extra.lines_c[2][5]),
                
                HEX(card.ability.extra.lines_c[3][1]),
                HEX(card.ability.extra.lines_c[3][2]),
                HEX(card.ability.extra.lines_c[3][3]),
                HEX(card.ability.extra.lines_c[3][4]),
                HEX(card.ability.extra.lines_c[3][5]),

                HEX(card.ability.extra.lines_c[4][1]),
                HEX(card.ability.extra.lines_c[4][2]),
                HEX(card.ability.extra.lines_c[4][3]),
                HEX(card.ability.extra.lines_c[4][4]),
                HEX(card.ability.extra.lines_c[4][5]),

                HEX(card.ability.extra.lines_c[5][1]),
                HEX(card.ability.extra.lines_c[5][2]),
                HEX(card.ability.extra.lines_c[5][3]),
                HEX(card.ability.extra.lines_c[5][4]),
                HEX(card.ability.extra.lines_c[5][5]),

                HEX(card.ability.extra.lines_c[6][1]),
                HEX(card.ability.extra.lines_c[6][2]),
                HEX(card.ability.extra.lines_c[6][3]),
                HEX(card.ability.extra.lines_c[6][4]),
                HEX(card.ability.extra.lines_c[6][5]),
                
                HEX(card.ability.extra.lines_c[7][1]),
                HEX(card.ability.extra.lines_c[7][2]),
                HEX(card.ability.extra.lines_c[7][3]),
                HEX(card.ability.extra.lines_c[7][4]),
                HEX(card.ability.extra.lines_c[7][5]),
            },

            card.ability.extra.display[1][1],
            card.ability.extra.display[1][2],
            card.ability.extra.display[1][3],
            card.ability.extra.display[1][4],
            card.ability.extra.display[1][5],

            card.ability.extra.display[2][1],
            card.ability.extra.display[2][2],
            card.ability.extra.display[2][3],
            card.ability.extra.display[2][4],
            card.ability.extra.display[2][5],

            card.ability.extra.display[3][1],
            card.ability.extra.display[3][2],
            card.ability.extra.display[3][3],
            card.ability.extra.display[3][4],
            card.ability.extra.display[3][5],

            card.ability.extra.display[4][1],
            card.ability.extra.display[4][2],
            card.ability.extra.display[4][3],
            card.ability.extra.display[4][4],
            card.ability.extra.display[4][5],

            card.ability.extra.display[5][1],
            card.ability.extra.display[5][2],
            card.ability.extra.display[5][3],
            card.ability.extra.display[5][4],
            card.ability.extra.display[5][5],

            card.ability.extra.display[6][1],
            card.ability.extra.display[6][2],
            card.ability.extra.display[6][3],
            card.ability.extra.display[6][4],
            card.ability.extra.display[6][5],

            card.ability.extra.mult,
            card.ability.extra.chips,
            card.ability.extra.xmult,
        } }
    end,

    calculate = function(self, card, context)
        if context.before and #context.full_hand == 5 and context.main_eval and not context.blueprint and card.ability.extra.completed == false and not context.debuffed_hand then
            card.ability.extra.tries = card.ability.extra.tries + 1
            if card.ability.extra.tries >= 7 then
                card.ability.extra.tries = 7
            end
            if card.ability.extra.tries <= card.ability.extra.max then
                for _, played_card in ipairs(context.full_hand) do
                    card.ability.extra.lines[card.ability.extra.tries][_] = played_card:get_id()
                end
                for i = 1, #context.full_hand do
                    for p = 1, #card.ability.extra.string do
                        if card.ability.extra.string[p] == card.ability.extra.lines[card.ability.extra.tries][i] then
                            card.ability.extra.lines_c[card.ability.extra.tries][i] = card.ability.extra.yellow
                        end
                    end
                end
                for i = 1, #context.full_hand do
                    if card.ability.extra.string[i] == card.ability.extra.lines[card.ability.extra.tries][i] then
                        card.ability.extra.lines_c[card.ability.extra.tries][i] = card.ability.extra.green
                    end
                end
            end
        end
        if context.joker_main then
            if card.ability.extra.tries > 0 then
                local green = 0
                local yellow = 0
                local complete = 1
                for i = 1, #card.ability.extra.lines_c[card.ability.extra.tries] do
                    if card.ability.extra.lines_c[card.ability.extra.tries][i] == card.ability.extra.green then
                        green = green + 1
                    end
                    if card.ability.extra.lines_c[card.ability.extra.tries][i] == card.ability.extra.yellow then
                        yellow = yellow + 1
                    end
                end
                if green == 5 then
                    complete = complete + 1
                    card.ability.extra.completed = true
                end
                return {
                    chips = card.ability.extra.chips * yellow,
                    mult = card.ability.extra.mult * green,
                    xmult = complete
                }
            end
        end
    end,

    add_to_deck = function(self, card, from_debuff)
        for i = 1, #card.ability.extra.string do
            card.ability.extra.string[i] = pseudorandom('wordle', 2, 14)
        end
    end,

    update = function(self, card, dt)
        if card.ability.extra.tries > 0 and card.ability.extra.tries < 7 then
            for i = 1, #card.ability.extra.lines[card.ability.extra.tries] do
                if card.ability.extra.lines[card.ability.extra.tries][i] >= 2 and card.ability.extra.lines[card.ability.extra.tries][i] <= 10 then
                    card.ability.extra.display[card.ability.extra.tries][i] = card.ability.extra.lines[card.ability.extra.tries][i]
                else
                    if card.ability.extra.lines[card.ability.extra.tries][i] == 11 then
                        card.ability.extra.display[card.ability.extra.tries][i] = 'J'
                    end
                    if card.ability.extra.lines[card.ability.extra.tries][i] == 12 then
                        card.ability.extra.display[card.ability.extra.tries][i] = 'Q'
                    end
                    if card.ability.extra.lines[card.ability.extra.tries][i] == 13 then
                        card.ability.extra.display[card.ability.extra.tries][i] = 'K'
                    end
                    if card.ability.extra.lines[card.ability.extra.tries][i] == 14 then
                        card.ability.extra.display[card.ability.extra.tries][i] = 'A'
                    end
                end
            end
        end
        card.ability.extra.lines[7] = card.ability.extra.display[7]
        card.ability.extra.lines_c[6] = card.ability.extra.lines_c[7]
    end
}

SMODS.Joker {
    key = "jam_autism",
    loc_txt = {
        name = 'Autistic Joker',
        text = {
            '{X:red,C:white}X#1#{} Mult',
            'Gains {X:red,C:white}X#2#{} when',
            'a {C:attention}face{} card is discarded'
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 4,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    atlas = 'Jammbo',
    pos = { x = 2, y = 6 },
    pools = { ["Jambatro"] = true },

    config = { extra = { xmult = 1, xmult_gain = 0.05 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, card.ability.extra.xmult_gain } }
    end,

    calculate = function(self, card, context)
        if context.discard and not context.blueprint and context.other_card and context.other_card:is_face() then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
            return {
                message = '...'
            }
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
}

SMODS.Joker{
    key = "jam_jackpot",
    loc_txt = {
        name = 'Jackpot!',
        text = {
            'Played {C:attention}7s{} give {C:money}$#1#{}',
            'Discarded {C:attention}7s{} give {C:money}$#1#{}',
            '{C:money}Payout{} gains {C:money}+$#2#{} when',
            'a {C:attention}7{} is added to your {C:attention}deck{}'
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 8,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    atlas = 'Jammbo',
    pos = { x = 8, y = 6 },
    pools = { ["Jambatro"] = true },

    config = { extra = { dollar = 1, dollar_gain = 1 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollar, card.ability.extra.dollar_gain } }
    end,

    calculate = function(self, card, context)
        if context.discard and not context.blueprint and context.other_card and context.other_card:get_id() == 7 then
            return {
                dollars = card.ability.extra.dollar
            }
        end
        if context.cardarea == G.play and context.individual and context.other_card then
            local rank = context.other_card:get_id()
            if rank == 7 then
                return {
                    dollars = card.ability.extra.dollar
                }
            end
        end
        if context.playing_card_added then
            for i = 1, #context.cards do
                if context.cards[i]:get_id() == 7 then
                    card.ability.extra.dollar = card.ability.extra.dollar + card.ability.extra.dollar_gain
                    return {
                        message = 'Upgrade!'
                    }
                end
            end
        end
    end
}

SMODS.Joker{
    key = "jam_calendar",
    loc_txt = {
        name = 'Calendar',
        text = {
            '{C:red}+#1#{} Mult',
            '{C:chips}+#2#{} Chips',
            'Mult and Chips depend on',
            'the current {C:red}month{} and {C:chips}year{}'
        }
    },
    blueprint_compat = true,
    rarity = 1,
    cost = 4,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    atlas = 'Jammbo',
    pos = { x = 11, y = 2 },
    pools = { ["Jambatro"] = true },

    config = { extra = { month = tonumber(os.date("%m")), year = tonumber(os.date("%y")) } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.month, card.ability.extra.year } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.month,
                chips = card.ability.extra.year
            }
        end
    end,

    update = function(self, card, dt)
        card.ability.extra.month = tonumber(os.date("%m"))
        card.ability.extra.year = tonumber(os.date("%y"))
    end
}

SMODS.Joker{
    key = "jam_clock",
    loc_txt = {
        name = 'Clock',
        text = {
            '{C:red}+#1#{} Mult',
            '{C:chips}+#2#{} Chips',
            'Mult and Chips depend on the',
            'current {C:red}hour{} and {C:chips}minute{} of the day'
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    atlas = 'Jammbo',
    pos = { x = 11, y = 1 },
    pools = { ["Jambatro"] = true },

    config = { extra = { hour = tonumber(os.date("%I")), minute = tonumber(os.date("%M")) } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.hour, card.ability.extra.minute } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.hour,
                chips = card.ability.extra.minute
            }
        end
    end,

    update = function(self, card, dt)
        card.ability.extra.hour = tonumber(os.date("%I"))
        card.ability.extra.minute = tonumber(os.date("%M"))
    end
}

SMODS.Joker{
    key = "jam_lizzy",
    loc_txt = {
        name = 'Elizabeth I',
        text = {
            '{C:green}#1# in #2#{} chance to',
            'destroy each played {C:attention}face{} card'
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 5,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    atlas = 'Jammbo',
    pos = { x = 7, y = 6 },
    pools = { ["Jambatro"] = true },

    config = { extra = { odds = 4 } },

    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'thequeenie')
        return { vars = { numerator, denominator } }
    end,

    calculate = function(self, card, context)
        if context.destroy_card and context.destroy_card:is_face() and context.cardarea == G.play and not context.blueprint then
            if SMODS.pseudorandom_probability(card, 'thequeenie', 1, card.ability.extra.odds) then
                return { 
                    remove = true,
                    message = "Off with your head!"
                }
            end
        end
    end
}

SMODS.Joker{
    key = "jam_spaghet",
    loc_txt = {
        name = 'Spaghettification',
        text = {
            '{C:green}#1# in #2#{} chance to',
            'decrease played hand',
            'level by {C:attention}#3#',
            'and gain {X:red,C:white}X#5#{} Mult',
            '{C:inactive}(Currently {}{X:red,C:white} X#4#{} {C:inactive}Mult){}',
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 5,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    atlas = 'Jammbo',
    pos = { x = 9, y = 6 },
    pools = { ["Jambatro"] = true },

    config = { extra = { odds = 4, level = 1, xmult = 1, xmult_gain = 0.6 } },

    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'spaceiscool')
        return { vars = { numerator, denominator, card.ability.extra.level, card.ability.extra.xmult, card.ability.extra.xmult_gain } }
    end,

    calculate = function(self, card, context)
        if context.before and SMODS.pseudorandom_probability(card, 'spaceiscool', 1, card.ability.extra.odds) and not context.blueprint then
            if G.GAME.hands[context.scoring_name].level > 1 then
                card.ability.extra.xmult =  card.ability.extra.xmult + card.ability.extra.xmult_gain
                return {
                    message = 'Spaghettified!',
                    level_up = -card.ability.extra.level
                }
            end
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
}

SMODS.Joker{
    key = "jam_preacher",
    loc_txt = {
        name = 'Preacher',
        text = {
            'Played {C:attention}Enlightened{}',
            'cards give {C:red}+#4#{} Mult for every',
            '{C:attention}Enlightened{} card in the deck',
            'All discarded {C:attention}face{}',
            'cards become {C:attention}Enlightened{}',
            '{C:inactive}(Currently{}{C:red} +#3#{} {C:inactive}Mult){}',
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 5,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    atlas = 'Jammbo',
    pos = { x = 11, y = 3 },
    pools = { ["Jambatro"] = true },

    config = { extra = { odds = 5, mult = 0, mult_part = 3 } },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS['m_jammbo_jam_enlightened']
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'preacherjam')
        return { vars = { numerator, denominator, card.ability.extra.mult, card.ability.extra.mult_part } }
    end,

    calculate = function(self, card, context)
        if context.discard and not context.other_card.debuff and context.other_card:is_face() and not context.blueprint then
            if context.other_card.config.center.key == "c_base" then
                context.other_card:set_ability("m_jammbo_jam_enlightened", nil, true)
                return {
                    message = 'Welcome...'
                }
            end
        end
        if context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, 'm_jammbo_jam_enlightened') then
            local enlight_tally = 0
            if G.playing_cards then
                for _, playing_card in ipairs(G.playing_cards) do
                    if SMODS.has_enhancement(playing_card, 'm_jammbo_jam_enlightened') then 
                        enlight_tally = enlight_tally + 1 
                    end
                end
            end
            return {
                mult = (card.ability.extra.mult_part * enlight_tally)
            }
        end
    end,

    update = function(self, card, dt)
        local enlight_tally = 0
        if G.playing_cards then
            for _, playing_card in ipairs(G.playing_cards) do
                if SMODS.has_enhancement(playing_card, 'm_jammbo_jam_enlightened') then 
                    enlight_tally = enlight_tally + 1 
                end
            end
        end
        card.ability.extra.mult = (card.ability.extra.mult_part * enlight_tally)
    end
}

SMODS.Joker {
    key = 'jam_perfectionist',
    loc_txt = {
        name = 'Hand Perfectionist',
        text = {
            '{C:attention}+#1#{} Hand Size',
            '{C:attention}-#2#{} Hands',
            '{C:attention}+#3#{} Discards'
        }
    },
    blueprint_compat = true,
    rarity = 3,
    cost = 7,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    atlas = 'Jammbo',
    pos = { x = 0, y = 6 },
    pools = { ["Jambatro"] = true, ["Jambatro_R"] = true },

    config = { extra = { h_size = 2, hands = 2, discards = 2 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.h_size, card.ability.extra.hands, card.ability.extra.discards } }
    end,

    add_to_deck = function(self, card, from_debuff)
        G.hand:change_size(card.ability.extra.h_size)
        G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.discards
        ease_discard(card.ability.extra.discards)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
        ease_hands_played(-card.ability.extra.hands)
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.h_size)
        G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.discards
        ease_discard(-card.ability.extra.discards)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
        ease_hands_played(card.ability.extra.hands)
    end
}

SMODS.Joker {
    key = 'jam_top10',
    loc_txt = {
        name = 'Top 10s',
        text = {
            'Destroy all played {C:attention}10s',
            'Recieve an {C:attention}Enhanced face{} card',
            'for each destroyed {C:attention}10{} at the',
            'start of the {C:attention}next round',
            '{C:inactive}({}{C:attention}#1#{} {C:inactive}10s destroyed this round){}',
            '{C:inactive}(Credits to @codifyd for initial idea and art)'
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    atlas = 'Jammbo',
    pos = { x = 0, y = 7 },
    pools = { ["Jambatro"] = true },

    config = { extra = { destroyed10s = 0, destroying = false } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.destroyed10s } }
    end,

    calculate = function (self, card, context)
        if context.setting_blind then
            for i = 1, card.ability.extra.destroyed10s do
                local cen_pool = {}
                for _, enhancement_center in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                    if enhancement_center.key ~= 'm_stone' and not enhancement_center.overrides_base_rank then
                        cen_pool[#cen_pool + 1] = enhancement_center
                    end
                end
                local enhancement = pseudorandom_element(cen_pool, 'spe_card')
                local ranks = {"King", "Queen", "Jack"}
                local stone_card = SMODS.add_card { set = "Base", rank = ranks[pseudorandom("toptenny", 1,3)], enhancement = enhancement.key, area = G.deck }
                func = function()
                    SMODS.calculate_context({ playing_card_added = true, cards = { stone_card } })
                end
            end
            if card.ability.extra.destroyed10s > 0 then
                SMODS.calculate_effect({message = "Topped!"}, card)
            end
            card.ability.extra.destroyed10s = 0
            card.ability.extra.destroying = false
        end
        if context.destroy_card and context.scoring_hand and context.cardarea == G.play and context.destroy_card:get_id() == 10 and not context.blueprint then
            return {
                remove = true
            }
        end
        if context.remove_playing_cards and not context.blueprint then
            for i = 1, #context.removed do
                if context.removed[i]:get_id() == 10 then
                    card.ability.extra.destroying = true
                    card.ability.extra.destroyed10s = card.ability.extra.destroyed10s + 1
                    SMODS.calculate_effect({message = "+1"}, card)
                end
            end
        end
    end
}

SMODS.Joker {
    key = 'jam_collection',
    loc_txt = {
        name = 'Collection Plate',
        text = {
            'Earn {C:money}$1{} at the end',
            'of the round for',
            'every 2 {C:attention}Enlightened',
            'Cards in your deck',
            '{C:inactive}(Currently{}{C:money} $#1#{}{C:inactive}){}',
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    atlas = 'Jammbo',
    pos = { x = 11, y = 6 },
    pools = { ["Jambatro"] = true },

    config = { extra = { dollarinos = 0 } },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS['m_jammbo_jam_enlightened']
        return { vars = { card.ability.extra.dollarinos } }
    end,

    calc_dollar_bonus = function(self, card)
        return card.ability.extra.dollarinos
    end,

    update = function(self, card, dt)
        local enlight_tally = 0
        if G.playing_cards then
            for _, playing_card in ipairs(G.playing_cards) do
                if SMODS.has_enhancement(playing_card, 'm_jammbo_jam_enlightened') then 
                    enlight_tally = enlight_tally + 1 
                end
            end
        end
        card.ability.extra.dollarinos = math.floor(enlight_tally/2)
    end,

    in_pool = function(self, args)
        for _, playing_card in ipairs(G.playing_cards or {}) do
            if SMODS.has_enhancement(playing_card, 'm_jammbo_jam_enlightened') then
                return true
            end
        end
        return false
    end
}

SMODS.Joker {
    key = 'jam_gem',
    loc_txt = {
        name = "Gem Joker",
        text = {
            'Earn {C:money}$#1#{} at the',
            'end of every {C:attention}boss blind'
        }
    },
    blueprint_compat = false,
    rarity = 2,
    cost = 6,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 11, y = 5 },
    pools = { ["Jambatro"] = true },

    config = { extra = { dollars = 16 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars } }
    end,
    calc_dollar_bonus = function(self, card)
        if G.GAME.blind.boss then
            return card.ability.extra.dollars
        end
    end
}

SMODS.Sound({key = "steam", path = "steam_notification.mp3",})

SMODS.Joker {
    key = 'jam_remaster',
    loc_txt = {
        name = 'Remastered Joker',
        text = {
            '{C:red}+#3#{} Mult',
            '{C:green}#1# in #2#{} chance to download',
            '{C:money}$#4#{} DLC of up to {C:red}+#5#{} Mult'
        }
    },
    blueprint_compat = true,
    rarity = 1,
    cost = 4,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 11, y = 4 },
    pools = { ["Jambatro"] = true },

    config = { extra = { odds = 3, mult = 7, mult_max = 5, dollar = 3 } },

    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'shittyremaster')
        return { vars = { numerator, denominator, card.ability.extra.mult, card.ability.extra.dollar, card.ability.extra.mult_max } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if SMODS.pseudorandom_probability(card, 'shittyremaster', 1, card.ability.extra.odds) then
                G.GAME.dollars = G.GAME.dollars - card.ability.extra.dollar
                card.ability.extra.mult = card.ability.extra.mult + pseudorandom('dlc', 1, card.ability.extra.mult_max)
                return {
                    message = 'DLC Downloaded',
                    sound = 'jammbo_steam'
                }
            end
        end
    end
}

SMODS.Joker {
    key = 'jam_boggy',
    loc_txt = {
        name = 'Boggy',
        text = {
            'Gains {C:chips}+#1#{} Chips when',
            'a card is {C:attention}destroyed',
            '{C:inactive}(Currently{}{C:chips} +#2#{} {C:inactive}Chips){}',
        }
    },
    blueprint_compat = true,
    rarity = 1,
    cost = 5,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 1, y = 7 },
    pools = { ["Jambatro"] = true },

    config = { extra = { chips = 0, chips_gain = 8 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips_gain, card.ability.extra.chips } }
    end,

    calculate = function(self, card, context)
        if context.remove_playing_cards and not context.blueprint then
            for i = 1, #context.removed do
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_gain
                SMODS.calculate_effect({message = "Upgrade!"}, card)
            end
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
    end
}

SMODS.Joker {
    key = 'jam_crusher',
    loc_txt = {
        name = 'Candy Crusher',
        text = {
            '{C:red}+#1#{} Mult for each matching',
            'card over a {C:attention}Pair',
            'Creates a random {C:attention}enhanced{} card if',
            'hand contains a {C:attention}Four of a Kind',
            'Creates a {C:blue}Spectral{} card',
            'if hand is a {C:attention}Flush Five',
            '{C:inactive}(Must have room){}',
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 7,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 3, y = 7 },
    pools = { ["Jambatro"] = true },

    config = { extra = { mult = 8, making_card = false, type_3 = 'Three of a Kind', type_4 = 'Four of a Kind' } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, } }
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            if context.scoring_name == 'Five of a Kind' or context.scoring_name == 'Flush Five' then
                card.ability.extra.making_card = true
                if context.scoring_name == 'Flush Five' and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    SMODS.add_card {
                                        set = 'Spectral',
                                    }
                                    G.GAME.consumeable_buffer = 0
                                    return true
                                end
                            }))
                            SMODS.calculate_effect({message = "Tasty!"}, card)
                            card.ability.extra.yoinked = false
                            return true
                        end)
                    }))
                    return nil, true
                    end
                return {
                    mult = card.ability.extra.mult * 3
                }
            end
            if next(context.poker_hands[card.ability.extra.type_4]) then
                card.ability.extra.making_card = true
                return {
                    mult = card.ability.extra.mult * 2
                }
            end
            if next(context.poker_hands[card.ability.extra.type_3]) then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
        if (context.drawing_cards or (context.end_of_round and context.game_over == false and context.main_eval)) and card.ability.extra.making_card then
            card.ability.extra.making_card =  false
            local cen_pool = {}
            for _, enhancement_center in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                cen_pool[#cen_pool + 1] = enhancement_center
            end
            local enhancement = pseudorandom_element(cen_pool, 'spe_card')
            local king = SMODS.create_card { set = "Playing Card", area = G.discard, enhancement = enhancement.key }
                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                king.playing_card = G.playing_card
                table.insert(G.playing_cards, king)

                G.E_MANAGER:add_event(Event({
                    func = function()
                        king:start_materialize({ G.C.SECONDARY_SET.Enhanced })
                        G.play:emplace(king)
                        return true
                    end
                }))
                return {
                    message = 'Juicy!',
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.deck.config.card_limit = G.deck.config.card_limit + 1
                                return true
                            end
                        }))
                        draw_card(G.play, G.deck, 90, 'up')
                        SMODS.calculate_context({ playing_card_added = true, cards = { king } })
                    end
                }
        end
    end
}

SMODS.Joker {
    key = "jam_underwear",
    loc_txt = {
        name = 'Used Underwear',
        text = {
            'Gains {C:chips}+#1#{} Chips if',
            '{C:attention}second{} hand contains a {C:attention}Pair',
            '{C:inactive}(Currently{}{C:chips} +#2#{} {C:inactive}Chips){}',
        }
    },
    blueprint_compat = true,
    rarity = 1,
    cost = 4,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 2, y = 7 },
    pools = { ["Jambatro"] = true },

    config = { extra = { chips_gain = 22, chips = 0, type = 'Pair' } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips_gain, card.ability.extra.chips, localize(card.ability.extra.type, 'poker_hands') } }
    end,

    calculate = function(self, card, context)
        if context.before and next(context.poker_hands[card.ability.extra.type]) and G.GAME.current_round.hands_left == (G.GAME.round_resets.hands - 2) and not context.blueprint then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_gain
            return {
                message = 'Upgrade!'
            }
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
    end
}

SMODS.Joker {
    key = "jam_woke",
    loc_txt = {
        name = 'Woke Media',
        text = {
            '{C:mult}+#1#{} Mult for',
            'every unique {C:attention}suit{}',
            'in played hand'
        }
    },
    blueprint_compat = true,
    rarity = 1,
    cost = 4,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 6, y = 7 },
    pools = { ["Jambatro"] = true },

    config = { extra = { mult = 5, suits_played = {} } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,

    calculate = function(self, card, context)
        if context.before and context.main_eval and not context.blueprint then
            card.ability.extra.suits_played = {}
            for _, played_card in ipairs(context.full_hand) do
                local suit = played_card.base.suit
                local match = false
                for i = 1, #card.ability.extra.suits_played do
                    if card.ability.extra.suits_played[i] == suit then
                        match = true
                    end
                end
                if match == false then
                    card.ability.extra.suits_played[#card.ability.extra.suits_played + 1] = suit
                end
            end
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult * #card.ability.extra.suits_played
            }
        end
    end
}

SMODS.Joker {
    key = "jam_super_sonic",
    loc_txt = {
        name = 'Super Sonic',
        text = {
            '{X:mult,C:white}X#2#{} Mult',
            'Gains {X:mult,C:white}X#3#{} Mult every second',
            'Resets after playing a hand'
        }
    },
    blueprint_compat = true,
    rarity = 4,
    cost = 15,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 7, y = 8 },
    soul_pos = { x = 6, y = 8 },

    config = { extra = { second = 0, starting_time = 0, xmult = 1, xmult_gain = 0.2, do_reset = 1 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.second, card.ability.extra.xmult, card.ability.extra.xmult_gain } }
    end,

    calculate = function(self, card, context)
        if context.hand_drawn then
            if card.ability.extra.do_reset == 1 then
                card.ability.extra.starting_time = os.time{year=tonumber(os.date("%Y")), month=tonumber(os.date("%m")), day=tonumber(os.date("%d")), 
                                                           hour=tonumber(os.date("%H")), min=tonumber(os.date("%M")), sec=tonumber(os.date("%S"))}
                return { message = 'Building Energy...' }
            else
                
            end
        end
        if context.discard then
            card.ability.extra.do_reset = 0
        end
        if context.joker_main then
            card.ability.extra.do_reset = 1
            return {
                xmult = card.ability.extra.xmult
            }
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            card.ability.extra.xmult = 1
        end
    end,

    add_to_deck = function(self, card, from_debuff)
        card.ability.extra.starting_time = os.time{year=tonumber(os.date("%Y")), month=tonumber(os.date("%m")), day=tonumber(os.date("%d")), hour=tonumber(os.date("%H")), min=tonumber(os.date("%M")), sec=tonumber(os.date("%S"))}
        print(card.ability.extra.starting_time)
    end,

    update = function(self, card, dt)
        if next(SMODS.find_card('j_jammbo_jam_super_sonic')) and G.STATE == 1 then
            local t2 = os.time{year=tonumber(os.date("%Y")), month=tonumber(os.date("%m")), day=tonumber(os.date("%d")), 
                               hour=tonumber(os.date("%H")), min=tonumber(os.date("%M")), sec=tonumber(os.date("%S"))}
            local prev_s = card.ability.extra.second
            card.ability.extra.second = os.difftime(t2, card.ability.extra.starting_time)
            card.ability.extra.xmult = 1 + (card.ability.extra.second * card.ability.extra.xmult_gain)
            if prev_s ~= card.ability.extra.second then
                SMODS.calculate_effect({message = tostring(card.ability.extra.xmult)}, card)
            end
        end
    end,
}

SMODS.Joker {
    key = "jam_uno",
    loc_txt = {
        name = 'You Would Be Losing At UNO',
        text = {
            '{X:mult,C:white}X#1#{} Mult for every',
            'card held in hand',
            'First 2 cards in first played',
            'hand are turned {C:attention}Negative{}',
            '{C:attention}+#2#{} Hand Size',
        }
    },
    blueprint_compat = true,
    rarity = 4,
    cost = 15,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 5, y = 7 },
    soul_pos = { x = 4, y = 7 },

    config = { extra = { xmult = 0.4, h_size = 6, amount = 2 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, card.ability.extra.h_size } }
    end,

    calculate = function (self, card, context)
        if context.joker_main then
            return {
                xmult = #G.hand.cards * card.ability.extra.xmult
            }
        end
        if context.first_hand_drawn and not context.blueprint then
            local eval = function() return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES end
            juice_card_until(card, eval, true)
        end
        if context.before and context.main_eval and not context.blueprint and G.GAME.current_round.hands_played == 0 then
            local amount = 0
            for _, scored_card in ipairs(context.scoring_hand) do
                if amount < card.ability.extra.amount then
                    scored_card:set_edition('e_negative', true)
                end
                amount = amount + 1
            end
        end
    end,

    add_to_deck = function(self, card, from_debuff)
        G.hand:change_size(card.ability.extra.h_size)
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.h_size)
    end
}

SMODS.Joker {
    key = "jam_unique",
    loc_txt = {
        name = 'Everyone is Unique',
        text = {
            '{C:mult}+#1#{} Mult if hand',
            'does not contain a {C:attention}Pair'
        }
    },
    blueprint_compat = true,
    rarity = 1,
    cost = 4,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 7, y = 7 },

    config = { extra = { mult = 7, type = 'Pair' } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end, 

    calculate = function (self, card, context)
        if context.joker_main and not next(context.poker_hands[card.ability.extra.type]) then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker {
    key = "jam_dvision",
    loc_txt = {
        name = 'Double Vision',
        text = {
            'Retrigger {C:attention}all{} played cards',
            '{C:green}#1# in #2#{} chance to retrigger',
            'each played card a {C:attention}second{} time'
        }
    },
    blueprint_compat = true,
    rarity = 4,
    cost = 12,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 9, y = 7 },

    config = { extra = { odds = 3, retrigger = 1 } },

    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'dxvk')
        return { vars = { numerator, denominator } }
    end,

    calculate = function (self, card, context)
        if context.repetition and context.cardarea == G.play and context.other_card then
            card.ability.extra.retrigger = 1
            if SMODS.pseudorandom_probability(card, 'dxvk', 1, card.ability.extra.odds) then
                card.ability.extra.retrigger = 2
            end
            return {
                repetitions = card.ability.extra.retrigger
            }
        end 
    end
}

SMODS.Joker {
    key = 'jam_positive',
    loc_txt = {
        name = "Toxic Positivity",
        text = {
            'All played {C:attention}cards{}',
            'give {X:mult,C:white}X#1#{} Mult and {C:blue}+#2#{} Chips',
        }
    },
    blueprint_compat = true,
    rarity = 4,
    cost = 13,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 12, y = 6 },
    soul_pos = { x = 12, y = 7 },

    config = { extra = { xmult = 1.5, chips = 50 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, card.ability.extra.chips } }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            return {
                xmult = card.ability.extra.xmult,
                chips = card.ability.extra.chips,
            }
        end
    end
}

SMODS.Joker {
    key = 'jam_jokers',
    loc_txt = {
        name = "Jokers4U",
        text = {
            'Creates a random {C:attention}Joker',
            'when selecting a blind'
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 8, y = 7 },
    pools = { ["Jambatro"] = true },

    config = { extra = { creates = 1 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.creates } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
            local jokers_to_create = math.min(card.ability.extra.creates,
                G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
            G.GAME.joker_buffer = G.GAME.joker_buffer + jokers_to_create
            local rarities = {'Common', 'Common', 'Common', 'Uncommon', 'Uncommon', 'Uncommon', 'Rare'}
            G.E_MANAGER:add_event(Event({
                func = function()
                    for _ = 1, jokers_to_create do
                        SMODS.add_card {
                            set = 'Joker',
                            rarity = pseudorandom_element(rarities, 'rarities')
                        }
                        G.GAME.joker_buffer = 0
                    end
                    return true
                end
            }))
            return {
                message = 'Free Joker!',
                colour = G.C.BLUE,
            }
        end
    end,
}

SMODS.Joker {
    key = 'jam_localshopforlocalpeople',
    loc_txt = {
        name = "Local Produce",
        text = {
            'Gains {C:mult}+#2#{} Mult when a {C:attention}Voucher{} is redeemed',
            'Gains {C:chips}+#4#{} Chips when a {C:attention}Booster Pack{} is opened',
            '{C:attention}Vouchers{} and {C:attention}Booster Packs{} cost {C:attention}#5#%{} more',
            '{C:inactive}(Currently{} {C:chips}+#3#{} {C:inactive}Chips and{} {C:mult}+#1#{} {C:inactive}Mult)'
        }
    },
    blueprint_compat = false,
    rarity = 2,
    cost = 6,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 12, y = 3 },
    pools = { ["Jambatro"] = true },

    config = { extra = { mult = 0, mult_gain = 6, chips = 0, chip_gain = 15, percent = 50, vouchers_redeemed = {} } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.mult_gain, card.ability.extra.chips, card.ability.extra.chip_gain, card.ability.extra.percent } }
    end,

    calculate = function (self, card, context)
        if context.buying_card and context.card.ability.set == 'Voucher' and not context.blueprint then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
            return {
                message = 'Upgrade!',
                colour = G.C.RED,
            }
        end
        if context.open_booster and not context.blueprint then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
            return {
                message = 'Upgrade!',
                colour = G.C.BLUE,
            }
        end
        if context.joker_main then
            card.ability.extra.vouchers_redeemed = {}
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult
            }
        end
        if context.starting_shop then
            card.ability.extra.vouchers_redeemed = {}
        end
    end,

    update = function(self, card, dt)
        for _, v in pairs(G.I.CARD) do
            if v.ability and v.ability.set and (v.ability.set == "Voucher" or v.ability.set == "Booster") then
                local match = false
                for i = 1, #card.ability.extra.vouchers_redeemed do
                    if v.config.center.key == card.ability.extra.vouchers_redeemed[i] then
                        match = true
                    end
                end
                if match == false then
                    card.ability.extra.vouchers_redeemed[#card.ability.extra.vouchers_redeemed + 1] = v.config.center.key
                    v.cost = math.floor(v.cost + (v.cost/(100/card.ability.extra.percent)))
                end
            end
        end
    end,
}

SMODS.Joker {
    key = 'jam_mealdeal',
    loc_txt = {
        name = "Meal Deal",
        text = {
            '{C:attention}#1#%{} discount on {C:attention}Vouchers{} and {C:attention}Booster Packs{}',
            'Discount increases by {C:attention}#3#%{} when a',
            '{C:attention}#2#{} is played, up to a maximum of {C:attention}#4#%{}',
            '{C:inactive}(Hand type changes at the end of the round)'
        }
    },
    blueprint_compat = false,
    rarity = 2,
    cost = 7,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 10, y = 7 },
    soul_pos = { x = 11, y = 7 },
    pools = { ["Jambatro"] = true },

    config = { extra = { percent = 5, vouchers_redeemed = {}, hand_type = 'Pair', first_update = false, percent_increase = 5, percent_max = 50 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.percent, card.ability.extra.hand_type, card.ability.extra.percent_increase,card.ability.extra.percent_max } }
    end,

    calculate = function (self, card, context)
        if context.joker_main then
            card.ability.extra.vouchers_redeemed = {}
        end
        if context.starting_shop then
            card.ability.extra.vouchers_redeemed = {}
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            card.ability.extra.hand_type = pseudorandom_element(G.handlist, '4pounds50')
        end
        if context.before and not context.blueprint and context.scoring_name == card.ability.extra.hand_type then
            if card.ability.extra.percent < 50 then
                card.ability.extra.percent = card.ability.extra.percent + card.ability.extra.percent_increase
                return {
                    message = 'Upgrade!'
                }
            end
            if card.ability.extra.percent >= 50 then
                card.ability.extra.percent = 50
            end
        end
    end,

    update = function(self, card, dt)
        for _, v in pairs(G.I.CARD) do
            if v.ability and v.ability.set and (v.ability.set == "Voucher" or v.ability.set == "Booster") then
                local match = false
                for i = 1, #card.ability.extra.vouchers_redeemed do
                    if v.config.center.key == card.ability.extra.vouchers_redeemed[i] then
                        match = true
                    end
                end
                if match == false then
                    card.ability.extra.vouchers_redeemed[#card.ability.extra.vouchers_redeemed + 1] = v.config.center.key
                    v.cost = math.floor(v.cost - (v.cost/(100/card.ability.extra.percent)))
                end
            end
        end
        if card.ability.extra.first_update == false then
            card.ability.extra.first_update = true
            card.ability.extra.hand_type = pseudorandom_element(G.handlist, '4pounds50')
        end
    end,
}

SMODS.Joker {
    key = 'jam_seaside',
    loc_txt = {
        name = "Seaside Town",
        text = {
            'Gives {C:money}$#3#{} at the',
            'end of the round',
            '{C:green}#1# in #2#{} chance to make the',
            'shop {C:red}completely unusable'
        }
    },
    blueprint_compat = false,
    rarity = 1,
    cost = 3,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 12, y = 4 },
    pools = { ["Jambatro"] = true },

    config = { extra = { odds = 2, dollars = 5, store_value = 0, skipping = false } },

    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'cornwall')
        return { vars = { numerator, denominator, card.ability.extra.dollars } }
    end,
    
    calculate = function(self, card, context)
        if context.starting_shop and not context.blueprint then
            if SMODS.pseudorandom_probability(card, 'cornwall', 1, card.ability.extra.odds) then
                card.ability.extra.store_value = G.GAME.dollars
                G.GAME.dollars = -50
                card.ability.extra.skipping = true
                print(card.ability.extra.store_value)
                return {
                    message = 'No shops!'
                }
            end
        end
        if context.ending_shop and not context.blueprint then
            if card.ability.extra.skipping == true then
                G.GAME.dollars = card.ability.extra.store_value
                return {
                    message = 'Carrying on...'
                }
            end
            card.ability.extra.skipping = false
        end
    end,

    calc_dollar_bonus = function(self, card)
        return card.ability.extra.dollars
    end,
}

SMODS.Joker {
    key = 'jam_imdb',
    loc_txt = {
        name = "IMDb",
        text = {
            'Turn all played {C:attention}9s{} and {C:attention}10s{} into {C:attention}7s{}',
            'Played {C:attention}7s{} gain {C:chips}+#3#{} permanent Chips and',
            'have a {C:green}#1# in #2#{} chance to be given a random rank'
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 7,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 12, y = 5 },
    pools = { ["Jambatro"] = true },

    config = { extra = { chip_gain = 7, odds = 3 } },

    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'collective')
        return { vars = { numerator, denominator, card.ability.extra.chip_gain } }
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual and context.other_card then
            local rank = context.other_card:get_id()
            if rank == 10 or rank == 9 then
                SMODS.change_base(context.other_card, nil, '7')
                return {
                    message = 'Could be better'
                }
            end
            if rank == 7 then
                context.other_card.ability.perma_bonus = (context.other_card.ability.perma_bonus or 0) + 7
                if SMODS.pseudorandom_probability(card, 'collective', 1, card.ability.extra.odds) and not context.blueprint then
                    SMODS.change_base(context.other_card, nil, tostring(pseudorandom('ranks', 2, 14))) 
                end
                return {
                    message = 'Upgrade!'
                }
            end
        end
    end
}

SMODS.Joker {
    key = 'jam_fakepng',
    loc_txt = {
        name = "Fake PNG",
        text = {
            'Must play at least {C:attention}#3#{} cards',
            'Gains {C:mult}+#1#{} Mult when played hand',
            'contains less than {C:attention}#3#{} cards',
            '{C:inactive}(Currently{} {C:mult}+#2#{} {C:inactive}Mult)'
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 5,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 12, y = 0 },
    pools = { ["Jambatro"] = true },

    config = { extra = { mult_gain = 2, mult = 0, cards = 5, debuffing_hand = false } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult_gain, card.ability.extra.mult, card.ability.extra.cards } }
    end,

    calculate = function(self, card, context)
        if context.debuff_hand and not context.blueprint then
            if #context.full_hand < card.ability.extra.cards then
                card.ability.extra.debuffing_hand = true
                return {
                    debuff = true
                }
            end
        end
        if (context.drawing_cards or (context.end_of_round and context.game_over == false and context.main_eval)) and card.ability.extra.debuffing_hand then
            card.ability.extra.debuffing_hand = false
        end
        if context.debuffed_hand and not context.blueprint and card.ability.extra.debuffing_hand then
            if #context.full_hand < card.ability.extra.cards then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
                return {
                    message = 'Upgrade!'
                }
            end
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker {
    key = 'jam_yellowsticker',
    loc_txt = {
        name = "Yellow Sticker",
        text = {
            'Gain {C:money}$#1#{} at the end of the round',
            'Payout increases by {C:money}$#2#{} when a purchased',
            '{C:attention}Joker{} was made free using a {C:attention}Tag'
        }
    },
    blueprint_compat = false,
    rarity = 1,
    cost = 6,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 0, y = 3 },
    pools = { ["Jambatro"] = true },

    config = { extra = { dollars = 1, gain = 2 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars, card.ability.extra.gain } }
    end,

    calculate = function(self, card, context)
        if context.buying_card and context.card.ability.set == 'Joker' and not context.blueprint then
            if context.card.ability.couponed == true then
                card.ability.extra.dollars = card.ability.extra.dollars + card.ability.extra.gain
                SMODS.calculate_effect({message = "Upgrade!"}, card)
            end
        end
    end,

    calc_dollar_bonus = function(self, card)
        return card.ability.extra.dollars
    end
}

SMODS.Joker {
    key = 'jam_lager',
    loc_txt = {
        name = "Pint of Lager",
        text = {
            'Sell this Joker to',
            'create a free',
            '{C:attention}Futwiz Tag{}'
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 7,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 12, y = 1 },
    pools = { ["Jambatro"] = true },

    config = { extra = { mult = 10, mult_gain = 2, chips = 20, chip_gain = 10, hands = 1 } },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'tag_jammbo_jam_jumm', set = 'Tag' }
        return { vars = {  } }
    end,

    calculate = function(self, card, context)
        if context.selling_self then
            G.E_MANAGER:add_event(Event({
                func = (function()
                    add_tag(Tag('tag_jammbo_jam_jumm'))
                    play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                    return true
                end)
            }))
            return nil, true
        end
    end,
}

SMODS.Joker {
    key = 'jam_crisps',
    loc_txt = {
        name = "Packet of Crisps",
        text = {
            '{C:red}+#1#{} Mult {C:chips}+#3#{} Chips',
            'lose {C:red}+#2#{} Mult and gain {C:chips}+#4#{} Chips',
            'every {C:attention}2{} hands played'
        }
    },
    blueprint_compat = true,
    rarity = 1,
    cost = 6,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 12, y = 2 },
    pools = { ["Jambatro"] = true },

    config = { extra = { mult = 10, mult_gain = 2, chips = 20, chip_gain = 10, hands = 1 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.mult_gain, card.ability.extra.chips, card.ability.extra.chip_gain } }
    end,

    calculate = function(self, card, context)
        if context.after and context.main_eval and not context.blueprint then
            if card.ability.extra.mult > 0 then
                if card.ability.extra.hands == 0 then
                    card.ability.extra.hands = 1
                    card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.mult_gain
                    card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
                    return {
                        message = 'Crunch!',
                    }
                else
                    card.ability.extra.hands = 0
                end
            end
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult,
                chips = card.ability.extra.chips
            }
        end
    end
}

SMODS.Joker {
    key = 'jam_ripoff',
    loc_txt = {
        name = "Bootlegged Playing Cards",
        text = {
            'If {C:attention}second discard{} of round is {C:attention}#3#{} card,',
            'create {C:attention}#4#{} cards of the same {C:attention}rank{}, plus an',
            'additional card of a {C:green}random{} rank, at the start',
            'of the next round and have a {C:green}#1# in #2#{} chance of',
            'destroying the {C:attention}original{} card'
        }
    },
    blueprint_compat = false,
    rarity = 3,
    cost = 4,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 0, y = 8 },
    pools = { ["Jambatro"] = true, ["Jambatro_R"] = true },

    config = { extra = { odds = 3, used_discards = 1, cards = 1, copies = 2, copying = false, rank = 0 } },

    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'piracyiscool')
        return { vars = { numerator, denominator, card.ability.extra.cards, card.ability.extra.copies } }
    end,

    calculate = function(self, card, context)
        if context.discard and not context.blueprint and
            G.GAME.current_round.discards_used == card.ability.extra.used_discards and #context.full_hand == card.ability.extra.cards then
            card.ability.extra.copying = true
            card.ability.extra.rank = context.full_hand[1]:get_id()
            if SMODS.pseudorandom_probability(card, 'piracyiscool', 1, card.ability.extra.odds) then
                SMODS.calculate_effect({message = "Crap!"}, card)
                return {
                    remove = true
                }
            else
                SMODS.calculate_effect({message = "Survived!"}, card)
            end
        end
        if context.setting_blind and card.ability.extra.copying then
            if card.ability.extra.rank > 10 then
                if card.ability.extra.rank == 14 then
                    card.ability.extra.rank = 'Ace'
                end
                if card.ability.extra.rank == 13 then
                    card.ability.extra.rank = 'King'
                end
                if card.ability.extra.rank == 12 then
                    card.ability.extra.rank = 'Queen'
                end
                if card.ability.extra.rank == 11 then
                    card.ability.extra.rank = 'Jack'
                end
            else
                card.ability.extra.rank = tostring(card.ability.extra.rank)
            end
            for i = 1, card.ability.extra.copies do
                local stone_card = SMODS.add_card { set = "Base", rank = card.ability.extra.rank, enhancement = 'c_base', area = G.deck }
                func = function()
                    SMODS.calculate_context({ playing_card_added = true, cards = { stone_card } })
                end
            end
            local stone_card = SMODS.add_card { set = "Base", enhancement = 'c_base', area = G.deck }
            func = function()
                SMODS.calculate_context({ playing_card_added = true, cards = { stone_card } })
            end
            SMODS.calculate_effect({message = "Free Copies!"}, card)
            card.ability.extra.copying = false
        end
    end
}

SMODS.Joker {
    key = 'jam_net',
    loc_txt = {
        name = "String Net",
        text = {
            'Sell this Joker to',
            'create a free',
            '{C:attention}Comfy Shorts Tag{}'
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 7,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 1, y = 8 },
    pools = { ["Jambatro"] = true },

    config = { extra = { mult = 10, mult_gain = 2, chips = 20, chip_gain = 10, hands = 1 } },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'tag_jammbo_jam_bugstag', set = 'Tag' }
        return { vars = {  } }
    end,

    calculate = function(self, card, context)
        if context.selling_self then
            G.E_MANAGER:add_event(Event({
                func = (function()
                    add_tag(Tag('tag_jammbo_jam_bugstag'))
                    play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                    return true
                end)
            }))
            return nil, true
        end
    end,
}

SMODS.Joker {
    key = 'jam_time',
    loc_txt = {
        name = "Ain't Nobody Got Time For That",
        text = {
            '{X:mult,C:white}X#1#{} Mult',
            'loses {X:mult,C:white}X#2#{} Mult at the',
            'end of {C:blue}Small{} and {C:attention}Big{} Blinds'
        }
    },
    blueprint_compat = true,
    rarity = 3,
    cost = 8,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 3, y = 8 },
    pools = { ["Jambatro"] = true, ["Jambatro_R"] = true },

    config = { extra = { xmult = 5, xmult_gain = 0.15 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, card.ability.extra.xmult_gain } }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if not G.GAME.blind.boss then
                if (card.ability.extra.xmult - card.ability.extra.xmult_gain) <= 0 then
                    card:remove()
                    return {
                        message = "We didn't have time for it..."
                    }
                end
                card.ability.extra.xmult = card.ability.extra.xmult - card.ability.extra.xmult_gain
                return {
                    message = "Running out!"
                }
            end
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
}

SMODS.Joker {
    key = 'jam_cube',
    loc_txt = {
        name = "The Cube",
        text = {
            'All played cards with a {C:attention}square',
            'rank give the {C:attention}cube{} of their',
            '{C:attention}square root{} as Mult',
            '{C:inactive}(Ex:{} {C:attention}4s{} {C:inactive}give{} {C:mult}+8{} {C:inactive}Mult)'
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 2, y = 8 },
    pools = { ["Jambatro"] = true },

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card then
            local simplifier = math.sqrt(context.other_card:get_id())
            if context.other_card:get_id() == 14 then
                simplifier = 1
            end
            local is_square = (simplifier) % 1
            if is_square == 0 then
                return {
                    mult = (simplifier * simplifier * simplifier)
                }
            end
        end
    end
}

SMODS.Joker {
    key = 'jam_braindead',
    loc_txt = {
        name = "Braindead",
        text = {
            '{C:chips}+#2#{} Chips {C:mult}+#1#{} Mult',
            'for every card in',
            '{C:attention}full{} played hand'
        }
    },
    blueprint_compat = true,
    rarity = 3,
    cost = 8,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 5, y = 8 },
    pools = { ["Jambatro"] = true, ["Jambatro_R"] = true },

    config = { extra = { mult = 6, chips = 10 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.chips } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.chips * #context.full_hand,
                mult = card.ability.extra.mult * #context.full_hand
            }
        end
    end
}

SMODS.Joker {
    key = 'jam_random',
    loc_txt = {
        name = "r/iamveryrandom",
        text = {
            '{C:green}#1# in #2#{} chance to give a random {C:purple}Tarot{} card when selecting a blind',
            '{C:green}#3# in #4#{} chance to give between {C:red}+#9#{} and {C:red}+#10#{} Mult',
            '{C:green}#5# in #6#{} chance to give between {C:chips}+#11#{} and {C:chips}+#12#{} Chips',
            '{C:green}#7# in #8#{} chance to give a random {C:planet}Planet{} card at the end of the round'
        }
    },
    blueprint_compat = true,
    rarity = 1,
    cost = 6,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 4, y = 8 },
    pools = { ["Jambatro"] = true },

    config = { extra = { odds = 3, odds1 = 2, odds2 = 4, odds3 = 5, mult_min = 5, mult_max = 15, chips_min = 10, chips_max = 50 } },

    loc_vars = function(self, info_queue, card)
        local numerator, denominator   = SMODS.get_probability_vars(card, 1, card.ability.extra.odds,  'random_tarot')
        local numerator1, denominator1 = SMODS.get_probability_vars(card, 1, card.ability.extra.odds1, 'random_mult')
        local numerator2, denominator2 = SMODS.get_probability_vars(card, 1, card.ability.extra.odds2, 'random_chips')
        local numerator3, denominator3 = SMODS.get_probability_vars(card, 1, card.ability.extra.odds3, 'random_planet')
        return { vars = { numerator, denominator, 
                          numerator1, denominator1, 
                          numerator2, denominator2, 
                          numerator3, denominator3,
                          card.ability.extra.mult_min, card.ability.extra.mult_max,
                          card.ability.extra.chips_min, card.ability.extra.chips_max,
                        } }
    end,

    calculate = function(self, card, context)
        if context.setting_blind and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit
        and SMODS.pseudorandom_probability(card, 'random_tarot', 1, card.ability.extra.odds) then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                func = (function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            SMODS.add_card {
                                set = 'Tarot',
                                key_append = 'quirky'
                            }
                            G.GAME.consumeable_buffer = 0
                            return true
                        end
                    }))
                    SMODS.calculate_effect({ message = localize('k_plus_tarot'), colour = G.C.PURPLE },
                        context.blueprint_card or card)
                    return true
                end)
            }))
            return nil, true
        end
        if context.joker_main then
            local mult_r = 0
            local chips_r = 0
            if SMODS.pseudorandom_probability(card, 'random_mult', 1, card.ability.extra.odds1) then
                mult_r = pseudorandom('mult', card.ability.extra.mult_min,  card.ability.extra.mult_max)
            end
            if SMODS.pseudorandom_probability(card, 'random_chips', 1, card.ability.extra.odds2) then
                chips_r = pseudorandom('chips', card.ability.extra.chips_min,  card.ability.extra.chips_max)
            end
            return {
                mult = mult_r,
                chips = chips_r
            }
        end
        if context.end_of_round and context.game_over == false and context.main_eval and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit and 
        SMODS.pseudorandom_probability(card, 'random_planet', 1, card.ability.extra.odds3) then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                func = (function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            SMODS.add_card {
                                set = 'Planet',
                                key_append = 'quirky'
                            }
                            G.GAME.consumeable_buffer = 0
                            return true
                        end
                    }))
                    SMODS.calculate_effect( { message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet },
                        context.blueprint_card or card)
                    return true
                end)
            }))
            return nil, true
        end
    end
}



--Consumables
SMODS.Consumable {
    key = 'jam_miner',
    loc_txt = {
        name = 'Miner',
        text = {
            "Enhances {C:attention}#1#{} selected",
            "card into a",
            "{C:attention}Diamond Card",
        }
    },
    set = 'Tarot',
    atlas = 'jam_tarot',
    pos = { x = 0, y = 0 },
    discovered = true,
    config = { max_highlighted = 1, mod_conv = 'm_jammbo_jam_diamond' },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.max_highlighted, 'Diamond Card' } }
    end,
}

SMODS.Consumable {
    key = 'jam_mango',
    loc_txt = {
        name = 'Mango',
        text = {
            "Enhances {C:attention}#1#{} selected",
            "cards into",
            "{C:attention}Mustard Cards",
        }
    },
    set = 'Tarot',
    atlas = 'jam_tarot',
    pos = { x = 1, y = 0 },
    discovered = true,
    config = { max_highlighted = 3, mod_conv = 'm_jammbo_jam_mustard' },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.max_highlighted } }
    end,
}

SMODS.Consumable {
    key = 'jam_outlet',
    loc_txt = {
        name = 'Outlet',
        text = {
            "Enhances {C:attention}#1#{} selected",
            "card into a",
            "{C:attention}Battery Card",
        }
    },
    set = 'Tarot',
    atlas = 'jam_tarot',
    pos = { x = 6, y = 0 },
    discovered = true,
    config = { max_highlighted = 1, mod_conv = 'm_jammbo_jam_battery' },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.max_highlighted } }
    end,
}

SMODS.Consumable {
    key = 'jam_misplace',
    loc_txt = {
        name = 'Misplaced Joker',
        text = {
            "{C:red}+4{} Mult",
        }
    },
    set = 'Tarot',
    atlas = 'jam_tarot',
    pos = { x = 2, y = 0 },
    discovered = true,
    config = {  },

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = 4
            }
        end
    end
}

SMODS.Consumable{
    key = 'jam_jamgement',
    loc_txt = {
        name = 'Jamgement',
        text = {
            "Creates a random",
            "{C:attention}Jambatro Joker{}",
            "{C:inactive}(Must have room){}",
        }
    },
    set = 'Tarot',
    atlas = 'jam_tarot',
    pos = { x = 4, y = 0 },
    discovered = true,

    use = function(self, card, area, copier)
        SMODS.add_card({ set = 'Jambatro' })
        play_sound("jammbo_clang")
    end,

    can_use = function(self, card)
        return G.jokers and #G.jokers.cards < G.jokers.config.card_limit
    end
}

SMODS.Consumable {
    key = 'jam_church',
    loc_txt = {
        name = 'Church',
        text = {
            "Enhances {C:attention}#1#{} selected",
            "cards into",
            "{C:attention}Enlightenend Cards",
        }
    },
    set = 'Tarot',
    atlas = 'jam_tarot',
    pos = { x = 5, y = 0 },
    discovered = true,
    config = { max_highlighted = 2, mod_conv = 'm_jammbo_jam_enlightened' },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.max_highlighted } }
    end,
}

SMODS.Consumable {
    key = 'jam_caterpillar',
    loc_txt = {
        name = 'Caterpillar',
        text = {
            'Destroys {C:attention}1{}',
            'selected card',
        }
    },
    set = 'jam_bugs',
    atlas = 'jam_bugs',
    pos = { x = 0, y = 0 },
    discovered = true,
    pools = { ["jam_buggies"] = true },
    config = { max_highlighted = 1 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted } }
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3,1)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                SMODS.destroy_cards(G.hand.highlighted)
                return true
            end
        }))
        delay(0.3)
    end,
}

SMODS.Consumable {
    key = 'jam_ant',
    loc_txt = {
        name = 'Ant',
        text = {
            'Select {C:attention}#1#{} cards',
            'Gives the card on the {C:attention}right{}',
            '{C:attention}half{} of the chips from the the {C:attention}2',
            'cards on the {C:attention}left',
            '{C:inactive}(Credits to @codifyd for idea)'
        }
    },
    set = 'jam_bugs',
    atlas = 'jam_bugs',
    pos = { x = 1, y = 0 },
    discovered = true,
    pools = { ["jam_buggies"] = true },
    config = { max_highlighted = 3, min_highlighted = 3 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted } }
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))

        local rightmost = G.hand.highlighted[1]
        for i = 1, #G.hand.highlighted do
            if G.hand.highlighted[i].T.x > rightmost.T.x then
                rightmost = G.hand.highlighted[i]
            end
        end

        local leftmost = G.hand.highlighted[#G.hand.highlighted]
        for i = 1, #G.hand.highlighted do
            if G.hand.highlighted[i].T.x < leftmost.T.x then
                leftmost = G.hand.highlighted[i]
            end
        end

        local middle = G.hand.highlighted[1]
        for i = 1, #G.hand.highlighted do
            if G.hand.highlighted[i] ~= rightmost and G.hand.highlighted[i] ~= leftmost then
                middle = G.hand.highlighted[i]
            end
        end

        local card2rank = middle:get_id()
        local card3rank = leftmost:get_id()

        if card2rank > 10 then
            card2rank = 10
        end
        if card3rank > 10 then
            card3rank = 10
        end

        local card1chips = 0
        local card2chips = (middle.ability.perma_bonus or 0) + card2rank
        local card3chips = (leftmost.ability.perma_bonus or 0) + card3rank

        rightmost.ability.perma_bonus = (rightmost.ability.perma_bonus or 0) + ((card2chips + card3chips)/2)
        middle.ability.perma_bonus = (middle.ability.perma_bonus or 0) + -(card2chips/2)
        leftmost.ability.perma_bonus = (leftmost.ability.perma_bonus or 0) + -(card3chips/2)

        SMODS.calculate_effect({message = "Transfer!"}, card)

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
        delay(0.5)
    end
}

SMODS.Consumable {
    key = 'jam_soda',
    loc_txt = {
        name = 'Colour Bomb',
        text = {
            'Destroy all cards',
            'held in hand of a',
            'random {C:attention}Suit'
        }
    },
    set = 'Spectral',
    atlas = 'jam_spectral',
    pos = { x = 0, y = 0 },
    discovered = true,
    config = {  },
    use = function (self, card, area, copeier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                return true
            end
        }))
        local suits_in_hand = {}
        for i = 1, #G.hand.cards do
            local suit = G.hand.cards[i].base.suit
            local match = false
            for i = 1, #suits_in_hand do
                if suits_in_hand[i] == suit then
                    match = true
                end
            end
            if match == false then
                suits_in_hand[#suits_in_hand + 1] = suit
            end
        end
        local position = pseudorandom('suit', 1, #suits_in_hand)
        SMODS.calculate_effect({message = suits_in_hand[position]}, card)
        delay(0.1)
        local cards_to_destroy = {}
        local counter = 1
        for i = 1, #G.hand.cards do
            if G.hand.cards[i].base.suit == suits_in_hand[position] then
                cards_to_destroy[counter] = G.hand.cards[i]
                G.hand:add_to_highlighted(G.hand.cards[i])
                counter = counter + 1
                delay(0.1)
            end
        end
        SMODS.destroy_cards(cards_to_destroy)
    end,
    can_use = function(self, card)
        return G.hand and #G.hand.cards > 1
    end,
}

SMODS.Consumable {
    key = 'jam_genetics',
    loc_txt = {
        name = 'Genetic Modification',
        text = {
            'Select {C:attention}#1#{} cards',
            'Gives the card on the {C:attention}right{} all',
            '{C:attention}enhnacements, editions, and seals{}',
            'from the {C:attention}2{} cards on the {C:attention}left',
            '{C:inactive}(Rightmost cards have higher priority)'
        }
    },
    set = 'Spectral',
    atlas = 'jam_spectral',
    pos = { x = 1, y = 0 },
    discovered = true,
    config = { max_highlighted = 3, min_highlighted = 3 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted } }
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))

        local rightmost = G.hand.highlighted[1]
        for i = 1, #G.hand.highlighted do
            if G.hand.highlighted[i].T.x > rightmost.T.x then
                rightmost = G.hand.highlighted[i]
            end
        end

        local leftmost = G.hand.highlighted[#G.hand.highlighted]
        for i = 1, #G.hand.highlighted do
            if G.hand.highlighted[i].T.x < leftmost.T.x then
                leftmost = G.hand.highlighted[i]
            end
        end

        local middle = G.hand.highlighted[1]
        for i = 1, #G.hand.highlighted do
            if G.hand.highlighted[i] ~= rightmost and G.hand.highlighted[i] ~= leftmost then
                middle = G.hand.highlighted[i]
            end
        end

        for i = 1, #G.hand.highlighted do
            local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('card1', percent)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end

        local test = { leftmost, middle }

         G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.15,
            func = function()
                for i = 1, #test do
                    if test[i].config.center.key ~= 'c_base' then
                        rightmost:set_ability(test[i].config.center.key, nil, true)
                        test[i]:set_ability ('c_base', nil, true)
                    end
                    if test[i].seal then
                        rightmost:set_seal(test[i].seal, nil, true)
                        test[i]:set_seal(nil, true, true)
                    end
                    if test[i].edition then
                        rightmost:set_edition(test[i].edition, nil, true)
                        test[i]:set_edition(nil, true, true)
                    end
                end
                return true
            end
        }))

        SMODS.calculate_effect({message = "Transfer!"}, card)

        for i = 1, #G.hand.highlighted do
            local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('card1', percent)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
        delay(0.5)
    end
}


SMODS.Consumable {
    key = 'jam_beetle',
    loc_txt = {
        name = 'Beetle',
        text = {
            'Creates a random',
            '{C:blue}Spectral{} Card'
        }
    },
    set = 'jam_bugs',
    atlas = 'jam_bugs',
    pos = { x = 3, y = 0 },
    discovered = true,
    pools = { ["jam_buggies"] = true },
    config = { },
    loc_vars = function(self, info_queue, card)
        return { vars = { } }
    end,
    use = function(self, card, area, copier)
        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
        G.E_MANAGER:add_event(Event({
            func = (function()
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SMODS.add_card {
                            set = 'Spectral',
                        }
                        G.GAME.consumeable_buffer = 0
                        return true
                    end
                }))
                return true
            end)
        }))
        return nil, true
    end,
    can_use = function(self, card)
        return #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit
    end,
}

SMODS.Consumable {
    key = 'jam_butterfly',
    loc_txt = {
        name = 'Butterfly',
        text = {
            'Gives up to {C:attention}#1#{} cards',
            '{C:attention}random{} enhancements'
        }
    },
    set = 'jam_bugs',
    atlas = 'jam_bugs',
    pos = { x = 2, y = 0 },
    discovered = true,
    pools = { ["jam_buggies"] = true },
    config = { max_highlighted = 2, mod_conv = 'm_jammbo_jam_enlightened' },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted } }
    end,
    use = function(self, card, area, copier)
        local cen_pool = {}
        for _, enhancement_center in pairs(G.P_CENTER_POOLS["Enhanced"]) do
            if enhancement_center.key ~= 'm_stone' and not enhancement_center.overrides_base_rank then
                cen_pool[#cen_pool + 1] = enhancement_center
            end
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        for i = 1, #G.hand.highlighted do
            local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('card1', percent)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        delay(0.2)
        for i = 1, #G.hand.highlighted do
            local enhancement = pseudorandom_element(cen_pool, 'spe_card')
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    G.hand.highlighted[i]:set_ability(enhancement.key)
                    return true
                end
            }))
        end
        for i = 1, #G.hand.highlighted do
            local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('tarot2', percent, 0.6)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
        delay(0.5)
    end
}

SMODS.Consumable {
    key = 'jam_woodlouse',
    loc_txt = {
        name = 'Woodlouse',
        text = {
            'Creates {C:attention}#1#',
            '{C:green}Uncommon{} Jokers'
        }
    },
    set = 'jam_bugs',
    atlas = 'jam_bugs',
    pos = { x = 0, y = 1 },
    discovered = true,
    pools = { ["jam_buggies"] = true },
    config = { extra = { jokers = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.jokers } }
    end,
    use = function(self, card, area, copier)
        local jokers_to_create = math.min(card.ability.extra.jokers,
            G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
        G.GAME.joker_buffer = G.GAME.joker_buffer + jokers_to_create
        G.E_MANAGER:add_event(Event({
            func = function()
                for _ = 1, jokers_to_create do
                    SMODS.add_card {
                        set = 'Joker',
                        rarity = 'Uncommon',
                    }
                    G.GAME.joker_buffer = 0
                end
                return true
            end
        }))
    end,
    can_use = function(self, card)
        return #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit
    end,
}

SMODS.Consumable {
    key = 'jam_worm',
    loc_txt = {
        name = 'Worm',
        text = {
            'Destroy {C:attention}2{} random cards,',
            '{C:attention}3{} random {C:attention}enhanced{} cards',
            'added to your hand'
        }
    },
    set = 'jam_bugs',
    atlas = 'jam_bugs',
    pos = { x = 1, y = 1 },
    discovered = true,
    pools = { ["jam_buggies"] = true },
    config = { extra = { destroy = 2, cards = 3 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted } }
    end,
    use = function(self, card, area, copier)
        local used_tarot = copier or card
        local card_to_destroy = pseudorandom_element(G.hand.cards, 'random_destroy')
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                play_sound('tarot1')
                used_tarot:juice_up(0.3, 0.5)
                return true
            end
        }))
        SMODS.destroy_cards(card_to_destroy)

        local used_tarot = copier or card
        local card_to_destroy = pseudorandom_element(G.hand.cards, 'random_destroy')
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                play_sound('tarot1')
                used_tarot:juice_up(0.3, 0.5)
                return true
            end
        }))
        SMODS.destroy_cards(card_to_destroy)

        local ranks = { 'Ace', 'King', 'Queen', 'Jack', '10', '9', '8', '7', '6', '5', '4', '3', '2' }

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.7,
            func = function()
                local cards = {}
                for i = 1, card.ability.extra.cards do
                    local cen_pool = {}
                    for _, enhancement_center in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                        if enhancement_center.key ~= 'm_stone' and not enhancement_center.overrides_base_rank then
                            cen_pool[#cen_pool + 1] = enhancement_center
                        end
                    end
                    local enhancement = pseudorandom_element(cen_pool, 'spe_card')
                    cards[i] = SMODS.add_card { set = "Base", rank = pseudorandom_element(ranks, 'le_ranky'), enhancement = enhancement.key }
                end
                SMODS.calculate_context({ playing_card_added = true, cards = cards })
                return true
            end
        }))
        delay(0.3)
    end,
    can_use = function(self, card)
        return G.hand and #G.hand.cards > 1
    end,
}

SMODS.Consumable {
    key = 'jam_cool',
    loc_txt = {
        name = 'Cool Guy',
        text = {
            "Gives #1# card a",
            '{C:attention}Cool Seal'
        }
    },
    set = 'Spectral',
    atlas = 'jam_spectral',
    pos = { x = 2, y = 0 },
    discovered = true,
    config = { max_highlighted = 1 },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'jammbo_jam_cool', set = 'Seal' }
        return { vars = { card.ability.max_highlighted } }
    end,
    use = function(self, card, area, copier)

        for i = 1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    G.hand.highlighted[i]:set_seal('jammbo_jam_cool', nil, true)
                    return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
        delay(0.5)
    end
}

SMODS.Consumable {
    key = 'jam_fool',
    loc_txt = {
        name = 'Fool Guy',
        text = {
            'Destroy {C:attention}1{} random cards,',
            '{C:attention}3{} random {C:attention}sealed{} cards',
            'added to your hand'
        }
    },
    set = 'Spectral',
    atlas = 'jam_spectral',
    pos = { x = 3, y = 0 },
    discovered = true,
    config = { extra = { destroy = 1, cards = 3 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted } }
    end,
    use = function(self, card, area, copier)
        local used_tarot = copier or card
        local card_to_destroy = pseudorandom_element(G.hand.cards, 'random_destroy')
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                play_sound('tarot1')
                used_tarot:juice_up(0.3, 0.5)
                return true
            end
        }))
        SMODS.destroy_cards(card_to_destroy)

        local ranks = { 'Ace', 'King', 'Queen', 'Jack', '10', '9', '8', '7', '6', '5', '4', '3', '2' }

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.7,
            func = function()
                local cards = {}
                for i = 1, card.ability.extra.cards do
                    cards[i] = SMODS.add_card { set = "Base", seal = SMODS.poll_seal({key = 'supercharge', guaranteed = true}), rank = pseudorandom_element(ranks, 'le_ranky') }
                end
                SMODS.calculate_context({ playing_card_added = true, cards = cards })
                return true
            end
        }))
        delay(0.3)
    end,
    can_use = function(self, card)
        return G.hand and #G.hand.cards > 1
    end,
}

SMODS.Consumable {
    key = 'jam_spider2',
    loc_txt = {
        name = 'Magic Spider',
        text = {
            "Gives #1# card a",
            '{C:attention}Web Seal'
        }
    },
    set = 'Spectral',
    atlas = 'jam_spectral',
    pos = { x = 4, y = 0 },
    discovered = true,
    config = { max_highlighted = 1 },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'jammbo_jam_web', set = 'Seal' }
        return { vars = { card.ability.max_highlighted } }
    end,
    use = function(self, card, area, copier)

        for i = 1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    G.hand.highlighted[i]:set_seal('jammbo_jam_web', nil, true)
                    return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
        delay(0.5)
    end
}

SMODS.Consumable {
    key = 'jam_spider',
    loc_txt = {
        name = 'Spider',
        text = {
            'Level up {C:attention}most played',
            'hand by {C:attention}1{} level plus',
            'an {C:attention}additional{} level',
            'for every {C:attention}Fly{} in your',
            'consumeables'
        }
    },
    set = 'jam_bugs',
    atlas = 'jam_bugs',
    pos = { x = 2, y = 1 },
    discovered = true,
    pools = { ["jam_buggies"] = true },
    config = { extra = { levels = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { } }
    end,
    use = function(self, card, area, copier)
        local _handname, _played = 'High Card', -1
        for hand_key, hand in pairs(G.GAME.hands) do
            if hand.played > _played then
                _played = hand.played
                _handname = hand_key
            end
        end
        local most_played = _handname
        if _played == 0 then
            most_played = 'High Card'
        end
        local levels = 1
        for _, catter in ipairs(SMODS.find_card("c_jammbo_jam_fly")) do
            levels = levels + 1
        end
        delay(0.3)
        SMODS.smart_level_up_hand(card, most_played, nil, levels)
    end,
    can_use = function(self, card)
        return true
    end,
}

SMODS.Consumable {
    key = 'jam_fly',
    loc_txt = {
        name = 'Fly',
        text = {
            'Level up a {C:attention}random{}',
            'hand by {C:attention}1{} level'
        }
    },
    set = 'jam_bugs',
    atlas = 'jam_bugs',
    pos = { x = 3, y = 1 },
    discovered = true,
    pools = { ["jam_buggies"] = true },
    config = { extra = { levels = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { } }
    end,
    use = function(self, card, area, copier)
        delay(0.3)
        SMODS.smart_level_up_hand(card, pseudorandom_element(G.handlist, 'fliesaresofuckingannoying'), nil, levels)
    end,
    can_use = function(self, card)
        return true
    end,
}



--Boss Blinds
SMODS.Blind {
    key = "square",
    loc_txt = {
        name = 'The Square',
        text = {
            'Must play 4 cards'
        },
    },
    dollars = 5,
    mult = 2,
    debuff = { h_size_ge = 4, h_size_le = 4 },
    atlas = 'jam_blinds',
    pos = { x = 0, y = 0 },
    discovered = true,
    boss = { min = 1 },
    boss_colour = HEX("2231f1")
}

SMODS.Blind {
    key = "druggy",
    loc_txt = {
        name = 'Performance Drugs',
        text = {
            'All cards without enhancements,',
            'seals or editions are debuffed'
        },
    },
    dollars = 5,
    mult = 2,
    atlas = 'jam_blinds',
    pos = { x = 0, y = 3 },
    discovered = true,
    boss = { min = 4 },
    boss_colour = HEX("b3633a"),
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.debuff_card and (context.debuff_card.ability.set == 'Default' and not context.debuff_card.seal and not context.debuff_card.edition and not next(SMODS.get_enhancements(context.debuff_card))) then
                return { debuff = true }
            else
                return { debuff = false }
            end
        end
    end,
    disable = function(self)
        if context.debuff_card and (context.debuff_card.ability.set == 'Default' and not context.debuff_card.seal and not context.debuff_card.edition and not next(SMODS.get_enhancements(context.debuff_card))) then
            return { debuff = false }
        end
    end,

}

SMODS.Blind {
    key = "zig",
    loc_txt = {
        name = 'The Zig-Zag',
        text = {
            'First hand: Mult reduced by 20%',
            'Second hand: Chips reduced by 20%',
            'and so on...'
        },
    },
    dollars = 5,
    mult = 2,
    atlas = 'jam_blinds',
    pos = { x = 0, y = 1 },
    discovered = true,
    boss = { min = 2 },
    boss_colour = HEX("68a556"),
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.final_scoring_step then
                if G.GAME.current_round.hands_played % 2 == 1 then
                    mult = (mult * 0.8)
                    return {
                        message = 'Zig!'
                    }
                end
                if G.GAME.current_round.hands_played % 2 == 0 then
                    hand_chips = (hand_chips * 0.8)
                    return {
                        message = 'Zag!'
                    }
                end
            end
        end
    end,

}

SMODS.Blind {
    key = "joe",
    loc_txt = {
        name = 'Average Joe',
        text = {
            'All cards and Jokers with',
            'Editions are debuffed'
        },
    },
    dollars = 5,
    mult = 2,
    atlas = 'jam_blinds',
    pos = { x = 0, y = 2 },
    discovered = true,
    boss = { min = 5 },
    boss_colour = HEX("cfccc1"),
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.debuff_card and context.debuff_card.edition then
                return { debuff = true }
            else
                return { debuff = false }
            end
        end
    end,
    disable = function(self)
        if context.debuff_card and context.debuff_card.edition then
            return { debuff = false }
        end
    end,
}



--Booster Packs
SMODS.Booster {
    key = 'jam_booster_1',
    loc_txt = {
        name = 'Jammbo Pack',
        text = {
            'Choose {C:attention}1{} of',
            '{C:attention}2{} {C:red}Jambatro{} Jokers'
        },
        group_name = 'Jambatro??'
    },
    atlas = 'jam_boosters',
    pos = { x = 0, y = 0 },
    draw_hand = false,
    cost = 5,
    discovered = true,
    weight = 7,
    pools = { ["Jamboosters"] = true },
    config = { extra = 2, choose = 1 },
    create_card = function(self, card)
        return {set = "Jambatro", area = G.pack_cards, skip_materialize = true, soulable = false, key_append = "jammbo"}
    end,
}

SMODS.Booster {
    key = 'jam_booster_2',
    loc_txt = {
        name = 'A Pack of Jammbos',
        text = {
            'Choose {C:attention}1{} of',
            '{C:attention}2{} {C:red}Jambatro{} Jokers'
        },
        group_name = 'Balammbo'
    },
    atlas = 'jam_boosters',
    pos = { x = 0, y = 0 },
    draw_hand = false,
    cost = 5,
    discovered = true,
    weight = 7,
    pools = { ["Jamboosters"] = true },
    config = { extra = 2, choose = 1 },
    create_card = function(self, card)
        return {set = "Jambatro", area = G.pack_cards, skip_materialize = true, soulable = false, key_append = "jammbo"}
    end,
}

SMODS.Booster {
    key = 'jam_booster_3',
    loc_txt = {
        name = 'Jummbo Pack',
        text = {
            'Choose {C:attention}1{} of',
            '{C:attention}5{} {C:red}Jambatro{} Jokers'
        },
        group_name = 'Fortnite'
    },
    atlas = 'jam_boosters',
    pos = { x = 1, y = 0 },
    draw_hand = false,
    cost = 6,
    discovered = true,
    weight = 7,
    pools = { ["Jamboosters"] = true },
    config = { extra = 5, choose = 1 },
    create_card = function(self, card)
        return {set = "Jambatro", area = G.pack_cards, skip_materialize = true, soulable = false, key_append = "jammbo"}
    end,
}

SMODS.Booster {
    key = 'jam_booster_4',
    loc_txt = {
        name = 'Jummbugular Pack',
        text = {
            'Choose {C:attention}2{} of',
            '{C:attention}7{} {C:red}Jambatro{} Jokers'
        },
        group_name = 'Insert Text Here'
    },
    atlas = 'jam_boosters',
    pos = { x = 2, y = 0 },
    draw_hand = false,
    cost = 7,
    discovered = true,
    weight = 5,
    pools = { ["Jamboosters"] = true },
    config = { extra = 7, choose = 2 },
    create_card = function(self, card)
        return {set = "Jambatro", area = G.pack_cards, skip_materialize = true, soulable = false, key_append = "jammbo"}
    end,
}

SMODS.Booster {
    key = 'jam_bugster_1',
    loc_txt = {
        name = 'Bug Pack',
        text = {
            'Choose {C:attention}1{} of',
            '{C:attention}2{} {C:green}Bug{} Cards'
        },
        group_name = 'The Bugs'
    },
    atlas = 'jam_boosters',
    pos = { x = 3, y = 0 },
    draw_hand = true,
    cost = 7,
    discovered = true,
    weight = 5,
    pools = { ["Jamboosters"] = true },
    config = { extra = 2, choose = 1 },
    create_card = function(self, card)
        return {set = "jam_buggies", area = G.pack_cards, skip_materialize = true, soulable = false, key_append = "jammbo"}
    end,
}

SMODS.Booster {
    key = 'jam_bugster_2',
    loc_txt = {
        name = 'Bug Pack II',
        text = {
            'Choose {C:attention}1{} of',
            '{C:attention}2{} {C:green}Bug{} Cards'
        },
        group_name = 'The Bugs'
    },
    atlas = 'jam_boosters',
    pos = { x = 3, y = 0 },
    draw_hand = true,
    cost = 7,
    discovered = true,
    weight = 5,
    pools = { ["Jamboosters"] = true },
    config = { extra = 2, choose = 1 },
    create_card = function(self, card)
        return {set = "jam_buggies", area = G.pack_cards, skip_materialize = true, soulable = false, key_append = "jammbo"}
    end,
}

SMODS.Booster {
    key = 'jam_bugster_3',
    loc_txt = {
        name = 'Big Bug Pack',
        text = {
            'Choose {C:attention}1{} of',
            '{C:attention}3{} {C:green}Bug{} Cards'
        },
        group_name = 'under your skin.'
    },
    atlas = 'jam_boosters',
    pos = { x = 4, y = 0 },
    draw_hand = true,
    cost = 7,
    discovered = true,
    weight = 5,
    pools = { ["Jamboosters"] = true },
    config = { extra = 3, choose = 1 },
    create_card = function(self, card)
        return {set = "jam_buggies", area = G.pack_cards, skip_materialize = true, soulable = false, key_append = "jammbo"}
    end,
}

SMODS.Booster {
    key = 'jam_bugster_4',
    loc_txt = {
        name = 'Infestation',
        text = {
            'Choose {C:attention}2{} of',
            '{C:attention}4{} {C:green}Bug{} Cards'
        },
        group_name = 'Crawlies'
    },
    atlas = 'jam_boosters',
    pos = { x = 4, y = 0 },
    draw_hand = true,
    cost = 7,
    discovered = true,
    weight = 5,
    pools = { ["Jamboosters"] = true },
    config = { extra = 4, choose = 2 },
    create_card = function(self, card)
        return {set = "jam_buggies", area = G.pack_cards, skip_materialize = true, soulable = false, key_append = "jammbo"}
    end,
}

--Never to be seen again until I like do some engine stuff and even then this really doesnt matter
-- SMODS.Booster {
--     key = 'jam_booster_booster',
--     loc_txt = {
--         name = 'Jammbo Booster Pack Pack',
--         text = {
--             'Choose {C:attention}1{} of',
--             '{C:attention}3{} {C:red}Jambatro{} Booster Packs'
--         },
--         group_name = 'Inception'
--     },
--     atlas = 'jam_boosters',
--     pos = { x = 1, y = 0 },
--     draw_hand = false,
--     cost = 7,
--     discovered = true,
--     weight = 5,
--     config = { extra = 3, choose = 1 },
--     create_card = function(self, card)
--         return {set = "Jamboosters", area = G.pack_cards, skip_materialize = true, soulable = false, key_append = "jammbo"}
--     end,
-- }



--Tags
SMODS.Tag {
    key = "jam_jumm",
    loc_txt = {
        name = 'Futwiz Tag',
        text = {
            'Gives a free',
            '{C:attention}Jummbugular Pack'
        },
    },
    min_ante = 2,
    atlas = 'jam_tags',
    pos = { x = 0, y = 0 },
    discovered = true,
    loc_vars = function(self, info_queue, tag)
        info_queue[#info_queue + 1] = G.P_CENTERS['p_jammbo_jam_booster_4']
    end,
    apply = function(self, tag, context)
        if context.type == 'new_blind_choice' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            tag:yep('+', G.C.SECONDARY_SET.Spectral, function()
                local booster = SMODS.create_card { key = 'p_jammbo_jam_booster_4', area = G.play }
                booster.T.x = G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2
                booster.T.y = G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2
                booster.T.w = G.CARD_W * 1.27
                booster.T.h = G.CARD_H * 1.27
                booster.cost = 0
                booster.from_tag = true
                G.FUNCS.use_card({ config = { ref_table = booster } })
                booster:start_materialize()
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            tag.triggered = true
            return true
        end
    end
}

SMODS.Tag {
    key = "jam_bugstag",
    loc_txt = {
        name = 'Comfy Shorts Tag',
        text = {
            'Gives a free',
            '{C:attention}Infestation Pack'
        },
    },
    min_ante = 2,
    atlas = 'jam_tags',
    pos = { x = 2, y = 0 },
    discovered = true,
    loc_vars = function(self, info_queue, tag)
        info_queue[#info_queue + 1] = G.P_CENTERS['p_jammbo_jam_bugster_4']
    end,
    apply = function(self, tag, context)
        if context.type == 'new_blind_choice' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            tag:yep('+', G.C.SECONDARY_SET.Spectral, function()
                local booster = SMODS.create_card { key = 'p_jammbo_jam_bugster_4', area = G.play }
                booster.T.x = G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2
                booster.T.y = G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2
                booster.T.w = G.CARD_W * 1.27
                booster.T.h = G.CARD_H * 1.27
                booster.cost = 0
                booster.from_tag = true
                G.FUNCS.use_card({ config = { ref_table = booster } })
                booster:start_materialize()
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            tag.triggered = true
            return true
        end
    end
}

SMODS.Tag {
    key = "jam_mega",
    loc_txt = {
        name = 'Super Mega Awesome Tag',
        text = {
            'Shop has a free',
            '{C:red}Rare Jambatro{} Joker'
        },
    },
    atlas = 'jam_tags',
    pos = { x = 1, y = 0 },
    discovered = true,
    config = { odds = 3 },
    apply = function(self, tag, context)
        if context.type == 'store_joker_create' then
            local rares_in_posession = { 0 }
            for _, joker in ipairs(G.jokers.cards) do
                if joker.config.center.rarity == 3 and not rares_in_posession[joker.config.center.key] then
                    rares_in_posession[1] = rares_in_posession[1] + 1
                    rares_in_posession[joker.config.center.key] = true
                end
            end
            if #G.P_JOKER_RARITY_POOLS[3] > rares_in_posession[1] then
                local card = SMODS.create_card {
                    set = 'Jambatro_R',
                    area = context.area,
                    key_append = 'willies'
                }
                create_shop_card_ui(card, 'Joker', context.area)
                card.states.visible = false
                tag:yep('+', G.C.RED, function()
                    card:start_materialize()
                    card.ability.couponed = true
                    card:set_cost()
                    return true
                end)
                tag.triggered = true
                return card
            else
                tag:nope()
            end
        end
    end
}

SMODS.Tag {
    key = "jam_jam",
    loc_txt = {
        name = 'Jammbo Tag',
        text = {
            'Shop has a free',
            '{C:red}Jambatro{} Joker'
        },
    },
    atlas = 'jam_tags',
    pos = { x = 0, y = 1 },
    discovered = true,
    config = { odds = 3 },
    apply = function(self, tag, context)
        if context.type == 'store_joker_create' then
            local rares_in_posession = { 0 }
            for _, joker in ipairs(G.jokers.cards) do
                if joker.config.center.rarity == 3 and not rares_in_posession[joker.config.center.key] then
                    rares_in_posession[1] = rares_in_posession[1] + 1
                    rares_in_posession[joker.config.center.key] = true
                end
            end
            if #G.P_JOKER_RARITY_POOLS[3] > rares_in_posession[1] then
                local card = SMODS.create_card {
                    set = 'Jambatro',
                    area = context.area,
                    key_append = 'willies'
                }
                create_shop_card_ui(card, 'Joker', context.area)
                card.states.visible = false
                tag:yep('+', G.C.RED, function()
                    card:start_materialize()
                    card.ability.couponed = true
                    card:set_cost()
                    return true
                end)
                tag.triggered = true
                return card
            else
                tag:nope()
            end
        end
    end
}


--Seals
SMODS.Seal {
    key = "jam_cool",
    loc_txt = {
        name = 'Cool Seal',
        text = {
            'Creates a {C:attention}Super Mega',
            '{C:attention}Awesome Tag{} when held in hand',
            'at the end of the round',
            'Card {C:attention}destoryed{} after use'
        },
    },
    atlas = 'Seals',
    pos = { x = 0, y = 0 },
    discovered = true,
    badge_colour = G.C.RED,
     loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'tag_jammbo_jam_mega', set = 'Tag' }
        return { vars = {  } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.cardarea == G.hand and context.other_card == card then
            G.E_MANAGER:add_event(Event({
                func = (function()
                    add_tag(Tag('tag_jammbo_jam_mega'))
                    play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                    return true
                end)
            }))
            SMODS.calculate_effect({message = "Avenge me!"}, card)
            card:remove()
            return nil, true
        end
    end
}

SMODS.Seal {
    key = "jam_web",
    loc_txt = {
        name = 'Web Seal',
        text = {
            'Creates a {C:attention}Bug Card',
            'when {C:attention}discarded'
        },
    },
    atlas = 'Seals',
    pos = { x = 1, y = 0 },
    discovered = true,
    badge_colour = G.C.PURPLE,
    calculate = function(self, card, context)
        if context.discard and context.other_card == card and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = function()
                    SMODS.add_card({ set = 'jam_buggies', area = G.consumeables })
                    G.GAME.consumeable_buffer = 0
                    return true
                end
            }))
            return { message = 'BUG!', colour = G.C.PURPLE }
        end
    end
}



--Mod Stuff
SMODS.current_mod.calculate = function(self, context)
end