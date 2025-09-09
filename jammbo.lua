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

--Pools
SMODS.ObjectType({
	key = "Jambatro",
	default = "j_jam_greg",
	cards = {},
	inject = function(self)
		SMODS.ObjectType.inject(self)
	end,
})


--Enhanced Cards
SMODS.Enhancement {
    key = 'jam_diamond',
    loc_txt = {
        name = "Diamond Card",
        text = {
            "{X:chips,C:white} X#1# {} Mult",
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
            "Retriggers card",
            '{C:attention}1{} time',
            '{C:inactive}(Not fully implemented)'
        }
    },
    atlas = 'jam_enhancements',
    pos = { x = 1, y = 0 },
    config = {  },
    loc_vars = function(self, info_queue, card)
        return { vars = {  } }
    end,

    calculate = function(self, card, context)
        if context.repetition then
            return {
                repetitions = 1
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
            'If scored Chips is',
            'below {C:blue}#1#{}, {X:red,C:white}X#2#{} Mult',
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
    config = { extra = { threshold = 50, xmult = 3 } },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.threshold, card.ability.extra.xmult }
        }
    end,

    calculate = function(self, card, context)
        if context.final_scoring_step then
            if hand_chips < card.ability.extra.threshold then
                return { xmult = card.ability.extra.xmult }
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
            'Each played {C:attention}4{} gives',
            '{C:blue}+44{} Chips and {C:red}+4{} Mult',
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

    config = { extra = { chips = 44, mult = 4 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            (context.other_card:get_id() == 4) then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
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
            'losing {C:red}3{} Mult'
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
            '{{X:red,C:white}X1.02{} Mult if played hand',
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
    pools = { ["Jambatro"] = true },

    config = { extra = { xmult = 1.02 } },

    calculate = function (self, card, context)
        if context.joker_main then
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
            'Every {C:attention}8{} in your deck',
            'gives {C:red}+3{} Mult',
            '{C:inactive}(Currently:{}{C:red} +#2#{} {C:inactive}Mult){}',
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

    config = { extra = { mult = 1 } },

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
            'of giving {X:red,C:white}X2{} Mult'
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
    pools = { ["Jambatro"] = true },

    config = { extra = { odds = 3, xmult = 2 } },

    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'tyrsfall')
        return { vars = { numerator, denominator, card.ability.extra.Xmult } }
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
            'empty hand slot'
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
                mult = card.ability.extra.mult * (5 - #context.full_hand)
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
            'If hand played is {C:attention}Not Allowed{}',
            'gains {C:red}+#2#{} Mult',
            '{C:inactive}(Currently: {}{C:red}+#1#{}{C:inactive} Mult){}'
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

    config = { extra = { mult = 0, mult_bonus = 5 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.mult_bonus } }
    end,

    calculate = function(self, card, context)
        if context.debuffed_hand and not context.blueprint then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_bonus
            return {
                message = 'Whas all this then?',
                func = function()
                end
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
        name = {
            'Speedy Joker'
        },
        text = {
            'The faster you play your {C:attention}hand{},',
            'the better rank you get!',
            '--',
            'S Rank: {X:red,C:white}X1.2{} Mult, {C:red}+15{} Mult',
            'A Rank: {C:red}+10{} Mult',
            'B Rank: {C:red}+6{} Mult',
            'C Rank: {C:red}+4{} Mult',
            'D Rank: {C:red}+3{} Mult',
            'E Rank: {C:red}+2{} Mult',
            'F Rank: {C:red}+1{} Mult',
            'AFK Rank: {C:blue}+1{} Chip',
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
            mult = 50,
            xmult = 1.2,
            timer = 0,
            S_rank = 3,
            A_rank = 10,
            B_rank = 15,
            C_rank = 20,
            D_rank = 30,
            E_rank = 40,
            F_rank = 45,
            time_spent = 0,
            do_reset = 1,
            in_seconds_kinda = 0
        } 
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { 
            card.ability.extra.mult, 
            card.ability.extra.xmult,
            card.ability.extra.time_spent, 
            card.ability.extra.do_reset,
            card.ability.extra.S_rank,
            card.ability.extra.A_rank,
            card.ability.extra.B_rank,
            card.ability.extra.C_rank,
            card.ability.extra.D_rank,
            card.ability.extra.E_rank,
            card.ability.extra.F_rank,
        } }
    end,

    calculate = function(self, card, context)
        if context.hand_drawn then
            if card.ability.extra.do_reset == 1 then
                card.ability.extra.time_spent = 0
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
            if card.ability.extra.in_seconds_kinda <= card.ability.extra.S_rank then
                return {
                    xmult = card.ability.extra.xmult,
                    mult = 15,
                    message = 'S Rank!'
                }
            end
            if card.ability.extra.in_seconds_kinda <= card.ability.extra.A_rank then
                return {
                    mult = 10,
                    message = 'A Rank!'
                }
            end
            if card.ability.extra.in_seconds_kinda <= card.ability.extra.B_rank then
                return {
                    mult = 6,
                    message = 'B Rank!'
                }
            end
            if card.ability.extra.in_seconds_kinda <= card.ability.extra.C_rank then
                return {
                    mult = 4,
                    message = 'C Rank!'
                }
            end
            if card.ability.extra.in_seconds_kinda <= card.ability.extra.D_rank then
                return {
                    mult = 3,
                    message = 'D Rank!'
                }
            end
            if card.ability.extra.in_seconds_kinda <= card.ability.extra.E_rank then
                return {
                    mult = 2,
                    message = 'E Rank!'
                }
            end
            if card.ability.extra.in_seconds_kinda <= card.ability.extra.F_rank then
                return {
                    mult = 1,
                    message = 'F Rank!'
                }
            end
            return {
                chips = 1,
                message = 'Someone went AFK, huh?'
            }
        end
    end,

    update = function(self, card, dt)
        local display_message = true
        if not G.SETTINGS.paused and G.GAME.blind and G.GAME.blind.in_blind then
            card.ability.extra.time_spent = card.ability.extra.time_spent + dt
            card.ability.extra.in_seconds_kinda = math.floor(card.ability.extra.time_spent / 4.2)
        end
    end
}

SMODS.Joker {
    key = 'jam_jokerstore',
    loc_txt = {
        name = {
            'Its a Joker Store!',
            'I was buying Jokers!'
        },
        text = {
            'Gains {C:red}+#2#{} Mult for every',
            '{C:attention}Joker{} bought in the {C:attention}Shop{}',
            '{C:inactive}(Currently: {}{C:red}+#1#{}{C:inactive} Mult){}',
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
        if context.buying_card and context.card.ability.set == "Joker" then
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
        name = {
            'Corrupted Data'
        },
        text = {
            'All played {C:attention}cards{}',
            'score a {C:green}random{} amount of Chips and',
            'gain between {C:chips}+#1#{} and',
            '{C:chips}#2#{} Chips {C:attention}permenantly{}',
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
    key = 'jam_lookover',
    loc_txt = {
        name = {
            'Quick! Look Over There!'
        },
        text = {
            'Swaps {C:red}Mult{} and {C:chips}Chips{}',
            '{C:inactive}(This currently doesnt',
            '{C:inactive}work perfectly... still){}'
        }
    },
    blueprint_compat = true,
    rarity = 1,
    cost = 3,
    discovered = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'Jammbo',
    pos = { x = 0, y = 3 },
    pools = { ["Jambatro"] = true },

    config = { extra = { mult = 0, chips = -40, scored_mult = 0, scored_chips = 0 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.chips, card.ability.extra.scored_mult, card.ability.extra.scored_chips } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            card.ability.extra.scored_mult = mult
            card.ability.extra.scored_chips = hand_chips
            return {
                mult = (card.ability.extra.scored_chips - card.ability.extra.scored_mult),
                chips = (card.ability.extra.scored_mult - card.ability.extra.scored_chips)
            }
        end
    end
}

SMODS.Joker {
    key = 'jam_tnetannba',
    loc_txt = {
        name = {
            '0118 999 8819 9911 9725...3'
        },
        text = {
            'Play each {C:attention}digit{} of the new number',
            'for the {C:attention}Emergency Services{} to earn',
            '{X:chips,C:white}X2{} Chips! Each correct',
            'digit gives {C:chips}+50{} Chips',
            '{C:inactive}(Next digit: {C:attention}#2#{}{C:inactive}){}',
            '{C:inactive}(Only counts one digit per hand){}'
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
        if context.joker_main then
            local hascorrectnumber = false
            local digits = { 14, 14, 8, 9, 9, 9, 8, 8, 14, 9, 9, 9, 14, 14, 9, 7, 2, 5, 3, "Complete!" }
            if card.ability.extra.digit < 20 then
                for i = 1, #context.scoring_hand do
                    if context.full_hand[i]:get_id() == digits[card.ability.extra.digit] then
                        hascorrectnumber = true
                    end
                end

                if hascorrectnumber == true then
                    card.ability.extra.digit = card.ability.extra.digit + 1
                    if digits[card.ability.extra.digit] == 14 then
                        card.ability.extra.next_number = "Ace"
                    else
                        card.ability.extra.next_number = digits[card.ability.extra.digit]
                    end
                    return {
                        chips = card.ability.extra.chips,
                        message = "Well, thats easy to remember!",
                        hascorrectnumber = false
                    }
                end
            else
                return {
                    xchips = 2,
                    message = "I've just finished my milk"
                }
            end
        end
    end
}

SMODS.Joker {
    key = 'jam_118',
    loc_txt = {
        name = {
            '118-118!'
        },
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
        name = {
            'JokerPlay Rental'
        },
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
        name = {
            'Fat Joker'
        },
        text = {
            '{C:green}#1# in #2#{} chance of eating each',
            '{C:attention}played card{} and gaining {C:red}+#4#{} Mult',
            '{C:green}#3# in #5#{} chance of having',
            'a {C:attention}fatal heart attack{}',
            '{C:inactive}(Currently: {}{C:red}+#3#{}{C:inactive} Mult){}'
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
        name = {
            'Troll Joker'
        },
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
    end
}

SMODS.Joker {
    key = 'jam_groundhog',
    loc_txt = {
        name = {
            'Groundhog Day'
        },
        text = {
            'When cummulative {C:attention}Jokers{}',
            'reset, gains {C:red}+#2#{} Mult',
            '{C:inactive}(Currently:{}{C:red} +#1#{} {C:inactive}Mult){}'
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
        name = {
            'Free to Play'
        },
        text = {
            'Gains {C:red}+#2#{} Mult when {C:attention}shop{} exited',
            'without gaining or losing any {C:money}money{}',
            '{C:inactive}(Currently:{}{C:red} +#1#{} {C:inactive}Mult){}'
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
        name = {
            'Pembrokeshire County Council'
        },
        text = {
            'When {C:attention}Blind{} is selected, if the {C:attention}shop{} is active,',
            'gain {C:money}$10{} for every {C:attention}spectral card{} bought',
            'For every {C:attention}joker{} bought when opening',
            'an {C:attention}arcana pack{}, gains {C:chips}+70{} chips',
            'At the end of the round, gains',
            '{C:red}+10{} mult if {C:attention}deck{} is 0 cards',
            '{X:red,C:white}X3{} Mult for every {C:attention}tarot card{}',
            'used when the game is {C:attention}paused{}',
            '{C:inactive}(Currently:{}{C:red} +0{} {C:inactive}Mult,{}{C:chips} +0{} {C:inactive}Chips, {X:red,C:white}X1{} {C:inactive}Mult){}'
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
        name = {
            'Magpie'
        },
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
        name = {
            'Salesman'
        },
        text = {
            'Earn {C:money}$1{} for every {C:money}$2{} of profit from the',
            'last {C:attention}shop{} visit at the end of the round'
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
        name = {
            'Crooked Joker'
        },
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

    config = { extra = { hands = 1, dollars = 4, activated = false } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.hands, card.ability.extra.dollars } }
    end,

    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            if card.ability.extra.activated == false then
                G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
                ease_hands_played(card.ability.extra.hands)
                card.ability.extra.activated = true
            end
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
            G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
            return {
                message = 'Just you wait...'
            }
        end
    end
}

SMODS.Joker {
    key = 'jam_stocks',
    loc_txt = {
        name = {
            'Stocks'
        },
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
        name = {
            'Hydraulic Press'
        },
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
        name = {
            'Hormone Therapy'
        },
        text = {
            '{C:green}#1# in #2#{} chance for',
            'each played {C:attention}King{} to turn into a {C:attention}Queen{}',
            '{C:green}#1# in #2#{} chance for',
            'each played {C:attention}Queen{} to turn into a {C:attention}King{}',
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

    config = { extra = { odds = 3 } },

    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "trannygener")
        return { vars = { numerator, denominator } }
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual and context.other_card and not context.blueprint then
            local rank = context.other_card:get_id()
            if rank == 13 then
                if SMODS.pseudorandom_probability(card, "trannygener", 1, card.ability.extra.odds) then
                    SMODS.change_base(context.other_card, nil, 'Queen') 
                    return {
                        message = 'Estrogen!'
                    }
                end
            end
            if rank == 12 then
                if SMODS.pseudorandom_probability(card, "trannygener", 1, card.ability.extra.odds) then
                    SMODS.change_base(context.other_card, nil, 'King') 
                    return {
                        message = 'Testosterone!'
                    }
                end
            end
        end
    end
}

SMODS.Joker {
    key = 'jam_rabbits',
    loc_txt = {
        name = {
            'Like Rabbits'
        },
        text = {
            'When a {C:attention}King{} and {C:attention}Queen{} are scored,',
            'creates a {C:attention}King{}, {C:attention}Queen{} or {C:attention}Jack{} with',
            'a chance of a random {C:attention}enhancement{}'
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
                        message = 'Mother'
                    }
                end
            end
        end
        if (context.drawing_cards or (context.end_of_round and context.game_over == false and context.main_eval)) and card.ability.extra.father and card.ability.extra.mother then
            card.ability.extra.father = false
            card.ability.extra.mother = false
            local chrank = pseudorandom('rabbits', 1, 7)
            if chrank == 1 or chrank == 2 then
                local king = SMODS.create_card { set = "Playing Card", rank = "King", area = G.discard }
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
                local queen = SMODS.create_card { set = "Playing Card", rank = "Queen", area = G.discard }
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
                local jack = SMODS.create_card { set = "Playing Card", rank = "Jack", area = G.discard }
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
                    message = 'Its a boy!',
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
        name = {
            'Monochromatic Joker'
        },
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
            card.ability.extra.suit_number = math.random(1, 3)
            if card.ability.extra.suit == 'Hearts' then
                local suit_no = { 'Clubs', 'Diamonds', 'Spades' }
                card.ability.extra.suit = suit_no[card.ability.extra.suit_number]
                return {
                    message = ''
                }
            end
            if card.ability.extra.suit == 'Clubs' then
                local suit_no = { 'Hearts', 'Diamonds', 'Spades' }
                card.ability.extra.suit = suit_no[card.ability.extra.suit_number]
                return {
                    message = ''
                }
            end
            if card.ability.extra.suit == 'Diamonds' then
                local suit_no = { 'Hearts', 'Clubs', 'Spades' }
                card.ability.extra.suit = suit_no[card.ability.extra.suit_number]
                return {
                    message = ''
                }
            end
            if card.ability.extra.suit == 'Spades' then
                local suit_no = { 'Hearts', 'Clubs', 'Diamonds' }
                card.ability.extra.suit = suit_no[card.ability.extra.suit_number]
                return {
                    message = ''
                }
            end
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
    end
}

SMODS.Sound({key = "Jezza", path = "TG - Jezza.mp3",})
SMODS.Sound({key = "Hamster", path = "TG - Hamster.mp3",})
SMODS.Sound({key = "Slow", path = "TG - James.mp3",})

SMODS.Joker {
    key = 'jam_trinity',
    loc_txt = {
        name = {
            'The Holy Trinity'
        },
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
            man_number = 1, 
            xchips = 1.2, 
            h_size = 2,
        } 
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.man, card.ability.extra.man_number, card.ability.extra.xchips } }
    end,

    calculate = function(self, card, context)
        if context.starting_shop and not context.blueprint then
            card.ability.extra.man_number = math.random(1, 2)
            if card.ability.extra.man == 'Jezza' then
                local man_no = { 'Cpt. Slow', 'Hamster' }
                card.ability.extra.man = man_no[card.ability.extra.man_number]
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
            if card.ability.extra.man == 'Cpt. Slow' then
                G.hand:change_size(-card.ability.extra.h_size)
                local man_no = { 'Jezza', 'Hamster' }
                card.ability.extra.man = man_no[card.ability.extra.man_number]
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
            if card.ability.extra.man == 'Hamster' then
                local man_no = { 'Cpt. Slow', 'Jezza' }
                card.ability.extra.man = man_no[card.ability.extra.man_number]
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
        card.ability.extra.man_number = math.random(1, 3)
            if card.ability.extra.man == 'Jezza' then
                local man_no = { 'Cpt. Slow', 'Hamster', 'Jezza' }
                card.ability.extra.man = man_no[card.ability.extra.man_number]
            end
    end,
}

SMODS.Joker {
    key = 'jam_santa',
    loc_txt = {
        name = {
            'Joker Christmas'
        },
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
        name = {
            'Pissy Joker'
        },
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
        name = {
            'Seagull'
        },
        text = {
            '{C:green}#1# in #2#{} chance to steal up to {C:chips}-50{} Chips',
            'and gain {C:red}+#5#{} Mult',
            '{C:green}#3# in #4#{} chance to release Mult and {C:attention}reset{}',
            '{C:inactive}(Currently: {}{C:red}+#3#{} {C:inactive}Mult){}',
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
        name = {
            'The Original      Star',
            '      Walker'
        },
        text = {
            'Gives {C:chips}+100{} Chips', 
            'or {C:red}+10{} Mult'
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
    pools = { ["Jambatro"] = true },

    config = { extra = { odds = 2 } },

    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "starwalker")
        return { vars = { numerator, denominator } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            if SMODS.pseudorandom_probability(card, "starwalker", 1, card.ability.extra.odds) then
                return {
                    mult = 10
                }
            else
                return {
                    chips = 100
                }
            end
        end
    end
}

SMODS.Joker {
    key = 'jam_thanos',
    loc_txt = {
        name = {
            'Thanos'
        },
        text = {
            'Destroys all {C:attention}cards{} until {C:attention}deck{}',
            'size is {C:attention}#1#{} cards',
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
    pools = { ["Jambatro"] = true },

    config = { extra = { preferred_size = 26, difference = 0 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.preferred_size, card.ability.extra.difference } }
    end,

    calculate = function(self, card, context)
        if card.ability.extra.difference <= 0 then
            if context.after then
                return {
                    message = 'Perfectly balanced'
                }
            end
        else
            for i = 1, card.ability.extra.difference do
                if context.destroy_card and context.cardarea == G.play and not context.blueprint then
                    return {
                        remove = true
                    }
                end
            end
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
        name = {
            'Its Eeffoc...',
            'and its funny'
        },
        text = {
            'If {C:attention}straight{} is played',
            'backwards, {C:red}+13{} mult'
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
        if context.joker_main then
            if context.full_hand[1]:get_id() + 1 == context.full_hand[2]:get_id() then
                if context.full_hand[2]:get_id() + 1 == context.full_hand[3]:get_id() then
                    if context.full_hand[3]:get_id() + 1 == context.full_hand[4]:get_id() then
                        if context.full_hand[4]:get_id() + 1 == context.full_hand[5]:get_id() then
                            return {
                                mult = 13
                            }
                        end
                    end
                end
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
            'a {C:purple}Legendary{} Joker'
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
    pools = { ["Jambatro"] = true },

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
            end
        end
    end
}

SMODS.Joker {
    key = 'jam_chipshop',
    loc_txt = {
        name = "Chip Shop",
        text = {
            'Lose {C:money}$#2#{} (if available) and gain {C:chips}+6{} chips',
            'at the {C:attention}start of the round{}',
            '{C:inactive}(Currently: {}{C:chips}+#1#{} {C:inactive}Chips){}'
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

    config = { extra = { xmult = 1.5, six = false, seven = false, xmult_gain = 0.2 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, card.ability.extra.xmult_gain } }
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual and context.other_card then
            local rank = context.other_card:get_id()
			if rank == 6 and card.ability.extra.six == false and card.ability.extra.seven == true then
                card.ability.extra.six = true
				return {
                    sound = 'jammbo_mustard',
                    message = '6!',
                }
			end
            if rank == 7 and card.ability.extra.seven == false and card.ability.extra.six == true then
                card.ability.extra.seven = true
				return {
                    sound = 'jammbo_mustard',
                    message = '7!',
                }
			end
            if rank == 6 and card.ability.extra.six == false then
                card.ability.extra.six = true
				return {
                    message = '6!',
                }
			end
            if rank == 7 and card.ability.extra.seven == false then
                card.ability.extra.seven = true
				return {
                    message = '7!',
                }
			end
		end

        if context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, "m_jammbo_jam_mustard") then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
            return {
                message 'Upstard!'
            }
        end
        
        if context.joker_main then
            if card.ability.extra.six == true and card.ability.extra.seven == true then
                card.ability.extra.six = false
                card.ability.extra.seven = false
                return {
                    xmult = card.ability.extra.xmult
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
            '{C:inactive}(Currently: {}{C:chips}+#1#{} {C:inactive}Chips){}',
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
            card.ability.extra.rank1 = math.random(2, 14)
            card.ability.extra.rank2 = math.random(2, 14)
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
        card.ability.extra.rank1 = math.random(2, 14)
        card.ability.extra.rank2 = math.random(2, 14)
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
            'Gains {X:red,C:white}X#6#{} Mult for every {C:blue}Spectral{} card used',
            'Gains {C:red}+#2#{} Mult for every {C:planet}Planet{} card used',
            'Gains {C:chips}+#4#{} Chips for every {C:purple}Tarot{} card used',
            '{C:inactive}(Currently: {C:chips}+#3#{} {C:inactive}Chips and {}{C:red}+#1#{} {C:inactive}Mult and {}{X:red,C:white}X#5#{} {C:inactive}Mult){}'
        }
    },
    blueprint_compat = true,
    rarity = 1,
    cost = 8,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    atlas = 'Jammbo',
    pos = { x = 6, y = 4 },
    pools = { ["Jambatro"] = true },

    config = { extra = { mult = 0, mult_gain = 1, chips = 0, chips_gain = 10, xmult = 1, xmult_gain = 0.1 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.mult_gain, card.ability.extra.chips, card.ability.extra.chips_gain, card.ability.extra.xmult, card.ability.extra.xmult_gain } }
    end,

    calculate = function(self, card, context)
        if context.using_consumeable and not context.blueprint and context.consumeable.ability.set == "Tarot" then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_gain
            return {
                message = 'Power Up!'
            }
        end
        if context.using_consumeable and not context.blueprint and context.consumeable.ability.set == "Planet" then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
            return {
                message = 'Power Up!'
            }
        end
        if context.using_consumeable and not context.blueprint and context.consumeable.ability.set == "Spectral" then
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
    end
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
    pools = { ["Jambatro"] = true },
    
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
            'If hand score exceeds {C:attention}1709{}, earn {C:money}$6{}'
        }
    },
    blueprint_compat = true,
    rarity = 1,
    cost = 8,
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
            '{C:inactive}(Currently: #3# Required Chips){}',
            '{C:chips}Extra life{} consumed if a Blind is {C:red}failed{}',
            '{C:inactive}(Can only gain 1 life per Ante){}',
            '{C:inactive}(Requirement scales with amount of lives){}',
            '{C:inactive}(Currently: x{}{C:chips}#1#{}{C:inactive} Life){}'
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
            'Absorbs {C:attention}#2#%{} of all Mult when scored for {C:attention}#1#{} rounds',
            'and scores stored Mult as {X:red,C:white}XMult{} on the final round',
            '{C:inactive}(Currently: {}{X:red,C:white}X#3#{}{C:inactive} Mult){}'

        }
    },
    blueprint_compat = false,
    rarity = 2,
    cost = 8,
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
        if context.joker_main then
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
        name = {
            'Ascended Jimbo'
        },
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
    pools = { ["Jambatro"] = true },

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
        name = {
            'Steak'
        },
        text = {
            'Gains {C:red}+3{} Mult at the end of the round',
            'When Mult reaches {C:red}+21{}, lasts for 2 more rounds',
            'until it burns',
            '{C:inactive}(Currently: {}{C:red}+#1#{}{C:inactive} Mult){}'
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
        name = {
            'Instant Win Button'
        },
        text = {
            '{C:attention}Destroys{} all scored {C:attention}3{}s',
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
    pos = { x = 1, y = 1 },
    pools = { ["Jambatro"] = true },

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
            if G.GAME.dollars ~= 0 then
                ease_dollars(-G.GAME.dollars, true)
            end
            return {
                chips = (( neededscore / currentmult ) - currentchips) + 2
            }
        end
    end
}

SMODS.Joker {
    key = 'jam_swaws',
    loc_txt = {
        name = {
            'SwawS'
        },
        text = {
            'If {C:attention}Two Pair{} is',
            'played mirrored, {C:red}+14{} Mult'
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
        if context.joker_main and #context.scoring_hand == 4 and context.scoring_hand[1]:get_id() == context.scoring_hand[4]:get_id() then
            if context.scoring_hand[2]:get_id() == context.scoring_hand[3]:get_id() then
                return {
                    mult = 14
                }
            end
        end
    end
}

SMODS.Joker {
    key = 'jam_picky',
    loc_txt = {
        name = {
            'Picky Eater'
        },
        text = {
            'Debuffs all {C:purple}Tarot{} cards, creates a random {C:blue}Spectral{}',
            'card at the end of every {C:attention}Boss blind{}',
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
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                SMODS.calculate_effect({message = "Dino Nuggies!"}, card)
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
        name = {
            'Diamond Dealer'
        },
        text = {
            '{X:chips,C:white}X#1#{} Chips for',
            'each {C:attention}Diamond card{} in your deck',
            '{C:inactive}(Currently: {}{X:chips,C:white}X#2#{} {C:inactive}Chips){}',
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
        name = {
            'Discard Master'
        },
        text = {
            'Gain +#2# chips if you have no discards',
            'and you play a High Card is played with',
            '4 other unscored cards',
            '{C:inactive}(Currently: {}{C:chips}+#1#{} {C:inactive}Chips){}',
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
        if context.pre_joker and G.GAME.current_round.discards_left == 0 then
            if #context.full_hand == 5 and #context.scoring_hand == 1 then
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
        name = {
            'The King Will Come'
        },
        text = {
            'Retriggers all {C:attention}Kings',
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
        name = {
            'Jacking It'
        },
        text = {
            'Retriggers all {C:attention}Jacks',
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
    key = "jam_microtransactions",
    loc_txt = {
        name = {
            'Microtransactions'
        },
        text = {
            'Every {C:money}purchase{} has a',
            '{C:green}#1# in #2#{} chance of',
            'creating a {C:purple}Tarot{} card'
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 8,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    atlas = 'Jammbo',
    pos = { x = 10, y = 6 },
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
        name = {
            'Comedy Duo'
        },
        text = {
            'Retriggers all',
            'played {C:attention}Enhanced{} cards'
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
    pools = { ["Jambatro"] = true },

    config = { extra = { repetitions = 1 } },

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and SMODS.has_enhancement then
            return {
                repetitions = card.ability.extra.repetitions
            }
        end
    end
}

SMODS.Joker {
    key = "jam_sploosh",
    loc_txt = {
        name = {
            'Sploosh'
        },
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
    pos = { x = 10, y = 6 },
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
        name = {
            'Sweets Jar'
        },
        text = {
            '+#1# Mult',
            'loses -#3# Mult every round, refills',
            'with #4# less max Mult after #5# rounds'
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
        name = {
            'Cardle'
        },
        text = {
            -- '#1# #2# #3# #4# #5#',
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
            '{X:red,C:white}X#38#{} Mult when board {C:green}Completed'
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
        lines_c = {
            {'8f8f8f', '8f8f8f', '8f8f8f', '8f8f8f', '8f8f8f'},
            {'8f8f8f', '8f8f8f', '8f8f8f', '8f8f8f', '8f8f8f'},
            {'8f8f8f', '8f8f8f', '8f8f8f', '8f8f8f', '8f8f8f'},
            {'8f8f8f', '8f8f8f', '8f8f8f', '8f8f8f', '8f8f8f'},
            {'8f8f8f', '8f8f8f', '8f8f8f', '8f8f8f', '8f8f8f'},
            {'8f8f8f', '8f8f8f', '8f8f8f', '8f8f8f', '8f8f8f'},
        },

        completed = false,

        finished = false,

        mult = 5,
        chips = 20,
        xmult = 2
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
            },

            card.ability.extra.lines[1][1],
            card.ability.extra.lines[1][2],
            card.ability.extra.lines[1][3],
            card.ability.extra.lines[1][4],
            card.ability.extra.lines[1][5],

            card.ability.extra.lines[2][1],
            card.ability.extra.lines[2][2],
            card.ability.extra.lines[2][3],
            card.ability.extra.lines[2][4],
            card.ability.extra.lines[2][5],

            card.ability.extra.lines[3][1],
            card.ability.extra.lines[3][2],
            card.ability.extra.lines[3][3],
            card.ability.extra.lines[3][4],
            card.ability.extra.lines[3][5],

            card.ability.extra.lines[4][1],
            card.ability.extra.lines[4][2],
            card.ability.extra.lines[4][3],
            card.ability.extra.lines[4][4],
            card.ability.extra.lines[4][5],

            card.ability.extra.lines[5][1],
            card.ability.extra.lines[5][2],
            card.ability.extra.lines[5][3],
            card.ability.extra.lines[5][4],
            card.ability.extra.lines[5][5],

            card.ability.extra.lines[6][1],
            card.ability.extra.lines[6][2],
            card.ability.extra.lines[6][3],
            card.ability.extra.lines[6][4],
            card.ability.extra.lines[6][5],

            card.ability.extra.mult,
            card.ability.extra.chips,
            card.ability.extra.xmult,
        } }
    end,

    calculate = function(self, card, context)
        if card.ability.extra.tries == 7 then
            card.ability.extra.finished = true
            for i = 1, 5 do
                card.ability.extra.lines[7][i] = card.ability.extra.lines[6][i]
            end
        end
        if context.before and not context.blueprint and #context.full_hand == 5 then
            if card.ability.extra.completed == false and card.ability.extra.finished == false then
                SMODS.calculate_effect({message = "Update!"}, card)
                card.ability.extra.tries = card.ability.extra.tries + 1
            end
        end
        if context.individual and context.cardarea == G.play and context.other_card and #context.full_hand == 5 and not context.blueprint then
            if card.ability.extra.completed == false then
                if card.ability.extra.finished == false then
                    for i = 1, #context.full_hand do
                        if card.ability.extra.finished == false then
                            if context.full_hand[i]:get_id() >= 2 and context.full_hand[i]:get_id() <= 10 then
                                card.ability.extra.lines[card.ability.extra.tries][i] = context.full_hand[i]:get_id()
                            else
                                if context.full_hand[i]:get_id() == 11 then
                                    card.ability.extra.lines[card.ability.extra.tries][i] = 'J'
                                end
                                if context.full_hand[i]:get_id() == 12 then
                                    card.ability.extra.lines[card.ability.extra.tries][i] = 'Q'
                                end
                                if context.full_hand[i]:get_id() == 13 then
                                    card.ability.extra.lines[card.ability.extra.tries][i] = 'K'
                                end
                                if context.full_hand[i]:get_id() == 14 then
                                    card.ability.extra.lines[card.ability.extra.tries][i] = 'A'
                                end
                            end
                            for p = 1, #card.ability.extra.string do
                                if card.ability.extra.string[p] == context.full_hand[i]:get_id() then
                                    if i ~= p then
                                        card.ability.extra.lines_c[card.ability.extra.tries][i] = card.ability.extra.yellow
                                    else
                                        card.ability.extra.lines_c[card.ability.extra.tries][i] = card.ability.extra.green
                                    end
                                end
                            end
                        end
                    end
                    local correct = 0
                    for i = 1, #context.full_hand do
                        if context.full_hand[i]:get_id() == card.ability.extra.string[i] then
                            correct = correct + 1
                            card.ability.extra.lines_c[card.ability.extra.tries][i] = card.ability.extra.green
                        end
                    end
                    if correct == 5 then
                        card.ability.extra.completed = true
                        SMODS.calculate_effect({message = "Got it!"}, card)
                    end
                end
            end
        end
        if context.joker_main then
            local multrelease = 0
            local chiprelease = 0
            local temptable = {0, 0, 0, 0, 0}
            for i = 1, #temptable do
                if type(card.ability.extra.lines[card.ability.extra.tries][i]) == "string" then
                    if card.ability.extra.lines[card.ability.extra.tries][i] == 'J' then
                        temptable[i] = 11
                    end
                    if card.ability.extra.lines[card.ability.extra.tries][i] == 'Q' then
                        temptable[i] = 12
                    end
                    if card.ability.extra.lines[card.ability.extra.tries][i] == 'K' then
                        temptable[i] = 13
                    end
                    if card.ability.extra.lines[card.ability.extra.tries][i] == 'A' then
                        temptable[i] = 14
                    end
                else
                    if card.ability.extra.lines[card.ability.extra.tries][i] >= 2 and card.ability.extra.lines[card.ability.extra.tries][i] <= 10 then
                        temptable[i] = card.ability.extra.lines[card.ability.extra.tries][i]
                    end
                end
            end
            for i = 1, #context.full_hand do
                for p = 1, #card.ability.extra.string do
                    if card.ability.extra.string[p] == temptable[i] then
                        if i ~= p then
                            chiprelease = chiprelease + 1
                        else
                            multrelease = multrelease + 1
                        end
                    end
                end
            end
            if card.ability.extra.completed == false then
                return {
                    chips = (chiprelease * card.ability.extra.chips),
                    mult = (multrelease * card.ability.extra.mult)
                }
            else
                return {
                    mult = (5 * card.ability.extra.mult),
                    xmult = card.ability.extra.xmult
                }
            end
        end
    end,

    add_to_deck = function(self, card, from_debuff)
        for i = 1, #card.ability.extra.string do
            card.ability.extra.string[i] = math.random(2, 14)
        end
    end,
}

SMODS.Joker {
    key = "jam_autism",
    loc_txt = {
        name = {
            'Autistic Joker'
        },
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
        name = {
            'Jackpot!'
        },
        text = {
            'Played {C:attention}7{}s give {C:money}$#1#{}',
            'Discarded {C:attention}7{}s give {C:money}$#1#{}',
            '{C:money}Payout{} gains {C:money}+#2#{} when',
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
    pos = { x = 10, y = 6 },
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
        name = {
            'Calendar'
        },
        text = {
            '{C:red}+#1#{} Mult',
            '{C:chips}+#2#{} Chips',
            'Mult and Chips depend on',
            'the current {C:red}month{} and {C:chips}year{}'
        }
    },
    blueprint_compat = true,
    rarity = 1,
    cost = 6,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    atlas = 'Jammbo',
    pos = { x = 10, y = 6 },
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
        name = {
            'Clock'
        },
        text = {
            '{C:chips}+#1##2#{} Chips',
            'Chips depend on',
            'the current {C:chips}time{}'
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    discovered = true,
    eternal_compat = true,
    perishable_compat = false,
    atlas = 'Jammbo',
    pos = { x = 10, y = 6 },
    pools = { ["Jambatro"] = true },

    config = { extra = { hour = tonumber(os.date("%I")), minute = tonumber(os.date("%M")) } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.hour, card.ability.extra.minute } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = (card.ability.extra.hour * 100) + card.ability.extra.minute
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
        name = {
            'Elizabeth I'
        },
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
    pos = { x = 10, y = 6 },
    pools = { ["Jambatro"] = true },

    config = { extra = { odds = 4 } },

    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'thequeenie')
        return { vars = { numerator, denominator } }
    end,

    calculate = function(self, card, context)
        if context.destroy_card and context.destroy_card:is_face() and context.cardarea == G.play and SMODS.pseudorandom_probability(card, 'thequeenie', 1, card.ability.extra.odds) and not context.blueprint then
            return { 
                remove = true,
                message = "Off with your head!"
            }
        end
    end
}





--Consumables
SMODS.Consumable {
    key = 'jam_miner',
    loc_txt = {
        name = {
            'Miner'
        },
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
        name = {
            'Mango'
        },
        text = {
            "Enhances {C:attention}#1#{} selected",
            "card into a",
            "{C:attention}Mustard Card",
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
    key = 'jam_misplace',
    loc_txt = {
        name = {
            'Misplaced Joker'
        },
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
        name = {
            'Jamgement'
        },
        text = {
            "Creates a random",
            "{C:attention}Jambatro Joker{}",
            "{C:inactive}(must have room){}",
        }
    },
    set = 'Tarot',
    atlas = 'jam_tarot',
    pos = { x = 3, y = 0 },
    discovered = true,

    use = function(self, card, area, copier)
        SMODS.add_card({ set = 'Jambatro' })
        play_sound("jammbo_clang")
    end,

    can_use = function(self, card)
        return G.jokers and #G.jokers.cards < G.jokers.config.card_limit
    end
}