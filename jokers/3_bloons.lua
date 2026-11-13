if Cryptid then --Cryptlib
SMODS.Joker{ --antibloon
    key = "antibloon",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'The Anti-Bloon',
        ['text'] = {
            [1] = '{C:attention}Force-trigger{} adjacent Jokers',
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 1,
        y = 0
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 10,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
	soul_pos = { x = 7, y = 16},

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.round}}
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    local results1 = Cryptid.forcetrigger(G.jokers.cards[i - 1], context) or Spectrallib.get_forcetrigger_results(G.jokers.cards[i - 1], context)
                    local results2 = Cryptid.forcetrigger(G.jokers.cards[i + 1], context) or Spectrallib.get_forcetrigger_results(G.jokers.cards[i + 1], context) -- spectrallib sucks sholll
                    if results1 and results1.jokers then
                        SMODS.calculate_effect(results1.jokers, card) -- holy shit this thing is op
                    end
                    if results2 and results2.jokers then
                        SMODS.calculate_effect(results2.jokers, card)
                    end
                end
            end
        end
    end
}
end

SMODS.Joker{ --Avrejer
    key = "avenger",
    config = {
	    extra = {
			hands = 1
		}
    },
    loc_txt = {
        ['name'] = 'Avenger (v52)',
        ['text'] = {
            [1] = 'Permanently {C:blue}+#1#{} hand if played',
            [2] = '{C:attention}poker hand{} has already been',
            [3] = 'played this round before',
            [4] = '{C:inactive}Ah yes common pt.2{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 9,
        y = 0
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

	loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.hands}}
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.before then
            if G.GAME.hands[context.scoring_name] and G.GAME.hands[context.scoring_name].played_this_round > 1 then
                return {
                    func = function()
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "+"..tostring(1).." Hands", colour = G.C.GREEN})
                            G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
                            ease_hands_played(card.ability.extra.hands)
                        return true
                    end
                }
            end
        end
		if context.forcetrigger then
            G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
            ease_hands_played(card.ability.extra.hands)
		end
    end
}
SMODS.Joker{ --Bloon Exclusion Zone (v38-53)
    key = "bez",
    config = {
        extra = {
            scored = 0,
            pb_xmult = 6,
            perma_xmult = 0
        }
    },
    loc_txt = {
        ['name'] = 'Bloon Exclusion Zone (v38-53)',
        ['text'] = {
            [1] = 'Every scored {C:spades}Spades{}',
            [2] = 'permanently gains {X:red,C:white}X#1#{} Mult'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 6,
        y = 0
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 8,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.pb_xmult}}
    end,
	
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
            if context.other_card:is_suit("Spades") then
                context.other_card.ability.perma_x_mult = context.other_card.ability.perma_x_mult or 0
                context.other_card.ability.perma_x_mult = context.other_card.ability.perma_x_mult + card.ability.extra.pb_xmult
                return {
                    extra = { message = localize('k_upgrade_ex'), colour = G.C.MULT }, card = card
                }
            end
        end
    end
}
SMODS.Joker{ --Bloonchipper
    key = "bloonchipper",
    config = {
        extra = {
            discard = 1
        }
    },
    loc_txt = {
        ['name'] = 'Bloonchipper',
        ['text'] = {
            [1] = '{C:red}+#1#{} discard',
            [2] = 'when a card is discarded',
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 7,
        y = 0
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.discard}}
    end,

    calculate = function(self, card, context)
        if context.discard or context.forcetrigger then
                return {
                    func = function()
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "+"..tostring(card.ability.extra.discard).." Discard", colour = G.C.ORANGE})
                G.GAME.current_round.discards_left = G.GAME.current_round.discards_left + card.ability.extra.discard
                return true
            end
                }
        end
    end
}
SMODS.Joker{ --Boss Farming Guide
    key = "bossfarmingguide",
    config = {
        extra = {
            eor = 2,
        }
    },
    loc_txt = {
        ['name'] = 'Boss Farming Guide', -- would be really funny if this was completely unchanged
        ['text'] = {
            [1] = 'Earn {C:gold}$#1#{} at the end of round',
            [2] = 'Payout increases by {C:gold}$1{} for every {C:gold}$10{}',
            [3] = 'you have at the end of round'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 8,
        y = 0
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 11,
    rarity = 3,
    blueprint_compat = false,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.eor}}
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
                return {
                    func = function()
                    card.ability.extra.eor = lenient_bignum(card.ability.extra.eor) + lenient_bignum(math.floor(math.max(G.GAME.dollars / 10) , 0))
                    return true
                end,
                    message = localize('k_upgrade_ex'),
                    extra = {
                        colour = G.C.MONEY
                        }
                }
        end
        if context.forcetrigger then
            card.ability.extra.eor = lenient_bignum(card.ability.extra.eor) + lenient_bignum(math.floor(math.max(G.GAME.dollars / 10) , 0))
                return {
                    dollars = lenient_bignum(card.ability.extra.eor),
                }
        end
    end,

    calc_dollar_bonus = function(self, card)
        if to_big(card.ability.extra.eor) > to_big(0) then
            return lenient_bignum(card.ability.extra.eor)
        end
    end
}
SMODS.Joker{ --bugged blitz
    key = "buggedblitz",
    config = {
        extra = {
            ignore = 0
        }
    },
    loc_txt = {
        ['name'] = 'Bugged Blitz (v49)',
        ['text'] = {
            [1] = 'Sell this card to {C:red}destroy{}',
            [2] = 'all cards {C:attention}held in hand{}',
            [3] = 'and create a {C:attention}copy{} of this joker'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 5,
        y = 0
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 8,
    rarity = 3,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.selling_self  and not context.blueprint then
                return {
                    func = function()
            local created_joker = true
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.hand_text_area.blind_chips:juice_up()
                    G.hand_text_area.game_chips:juice_up()
                    play_sound('tarot1')
                    card:start_dissolve()
                    return true
                end
            }))
            local destroyed_cards = {}
            for k, v in ipairs(G.hand.cards) do
                destroyed_cards[#destroyed_cards+1] = v
            end
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function() 
                    for i=#destroyed_cards, 1, -1 do
                        local card = destroyed_cards[i]
                        if card.ability.name == 'Glass Card' then 
                            card:shatter()
                        else
                            card:start_dissolve(nil, i == #destroyed_cards)
                        end
                    end
                    return true
                end
            }))
            G.E_MANAGER:add_event(Event({
                func = function()
                    local joker_card = SMODS.add_card({ set = 'Joker', key = 'j_ssr_buggedblitz' })
                    if joker_card then
                        
                        
                    end
                    
                    return true
                end
            }))
            
            if created_joker then
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_joker'), colour = G.C.BLUE})
            end
            return true
        end
                }
        end
    end
}
SMODS.Joker{ --Carrier Flagship
    key = "carrierflagship",
    config = {
        extra = {
            chips = 3,
            odds = 33
        }
    },
    loc_txt = {
        ['name'] = 'Carrier Flagship',
        ['text'] = {
            [1] = 'Each played {C:clubs}Clubs{} has a',
            [2] = '{C:green}#2# in #3#{} chance to {X:planet,C:white}^#1#{} Chips',
            [3] = 'when scored',
            [4] = '{C:inactive}Let\'s go gambling!{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 1,
        y = 1
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, 3, card.ability.extra.odds, 'j_ssr_carrierflagship') 
        return {vars = {card.ability.extra.chips, new_numerator, new_denominator}}
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_suit("Clubs") then
                if SMODS.pseudorandom_probability(card, 'group_0_86561525', 3, card.ability.extra.odds, 'j_ssr_carrierflagship', false) then
                    return {
                      echips = card.ability.extra.chips
                    }
                end
            end
        end
        if context.forcetrigger then
            return {
                echips = card.ability.extra.chips
            }
        end
    end
}
SMODS.Joker{ --Cave Monkey
    key = "cavemonkey",
    loc_txt = {
        ['name'] = 'Cave Monkey',
        ['text'] = {
            [1] = '{C:inactive}Me Hit Rock{}',
            [2] = '50.'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 1,
        y = 6
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 5,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    enhancement_gate = 'm_stone',
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.before then
            local check = false
            for k, v in ipairs(context.full_hand) do
                if SMODS.get_enhancements(v)["m_stone"] == true then
                    v:set_edition('e_negative', true)
                    -- v:juice_up()
                    check = true
                end
            end
            if check then
                card_eval_status_text(card, "extra", nil, nil, nil, { message = "Petrify!", colour = G.C.DARK_EDITION })
            end
        end
        if context.individual and context.cardarea == G.play  then
            if SMODS.get_enhancements(context.other_card)["m_stone"] == true then
                return {
                    x_chips = 50
                }
            end
        end
    end
}
SMODS.Joker{ --Cripple MOAB
    key = "cripplemoab",
    config = {
    },
    loc_txt = {
        ['name'] = 'Cripple MOAB (v37-49)',
        ['text'] = {
            [1] = '{C:attention}-92.8%{} Blind requirement this round',
            [2] = 'when a hand is played'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 5,
        y = 5
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 7,
    rarity = 3,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main or context.forcetrigger then
            return {

                func = function()
                    if G.GAME.blind.in_blind then

                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = 'Crippled!', colour = G.C.GREEN})
                        G.GAME.blind.chips = G.GAME.blind.chips * 0.072
                        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                        G.HUD_blind:recalculate()
                        return true
                    end
                end
            }
        end
    end
}
SMODS.Joker{ --Free Dart Monkey
    key = "freedartmonkey",
    config = {
        extra = {
            chips = 30,
            mult = 2,
            cash = 1
        }
    },
    loc_txt = {
        ['name'] = 'Free Dart Monkey',
        ['text'] = {
            [1] = '{C:blue}+#1#{} Chips',
            [2] = '{C:red}+#2#{} Mult',
            [3] = 'Earn {C:gold}$#3#{} when bought'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 9,
        y = 1
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 1,
    rarity = 1,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    in_pool = function(self, args)
          return (
          not args 
          or args.source ~= 'buf' and args.source ~= 'jud' and args.source ~= 'rif' and args.source ~= 'rta' and args.source ~= 'sou' and args.source ~= 'uta' and args.source ~= 'wra' 
          or args.source == 'sho'
          )
          and true
      end,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.cash}}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main or context.forcetrigger then
                return {
                    chips = card.ability.extra.chips,
                    extra = {
                        mult = card.ability.extra.mult
                        }
                }
        end
        if context.buying_card and context.card.config.center.key == self.key and context.cardarea == G.jokers  then
                return {
                    dollars = card.ability.extra.cash
                }
        end
    end
}
SMODS.Joker{ --Glaive Lord
    key = "glaivelord",
    config = {
        extra = {
            chips = 1,
            chipsmod = 3,
            first = 1
        }
    },
    loc_txt = {
        ['name'] = 'Glaive Lord',
        ['text'] = {
            [1] = 'This Joker gains {X:blue,C:white}X#2#{} Chips',
            [2] = 'for each {C:attention}non-first{} scored card',
            [3] = 'of every {C:attention}hand{}{}',
            [4] = '{C:inactive}(Currently {}{X:blue,C:white}X#1#{}{C:inactive} Chips){}'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 2,
        y = 2
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 7,
    rarity = 2,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    soul_pos = {
        x = 3,
        y = 2
    },

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chips, card.ability.extra.chipsmod}}
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  and not context.blueprint then
            if (card.ability.extra.first or 0) == 1 then
                card.ability.extra.first = 0
            elseif (card.ability.extra.first or 0) ~= 1 then
                card.ability.extra.chips = (card.ability.extra.chips) + card.ability.extra.chipsmod
                return {
                    message = localize('k_upgrade_ex')
                }
            end
        end
        if context.cardarea == G.jokers and context.joker_main  then
                return {
                    xchips = card.ability.extra.chips
                }
        end
        if context.after and context.cardarea == G.jokers  and not context.blueprint then
                return {
                    func = function()
                    card.ability.extra.first = 1
                    return true
                end
                }
        end
        if context.forcetrigger then
	SMODS.scale_card(card, {
		ref_table = card.ability.extra,
		ref_value = "chips",
		scalar_value = "chipsmod",
		message_colour = G.C.BLUE,
			})
	return {
                    xchips = card.ability.extra.chips
            }
        end
    end
}
SMODS.Joker{ --Flavored Trades
    key = "flavoredtrades",
    config = {
        extra = {
            chips = 1,
        }
    },
    loc_txt = {
        ['name'] = 'Flavored Trades',
        ['text'] = {
            [1] = 'This joker gains {X:blue,C:white}XChips{} equals',
            [2] = 'the sell value of all held {C:attention}Jokers{}',
            [3] = 'at the end of shop',
            [4] = '{C:inactive}(Currently {}{X:blue,C:white}X#1#{} {C:inactive}Chips){}'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 0,
        y = 2
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    in_pool = function(self, args)
          return (
          not args 
          or args.source ~= 'buf' and args.source ~= 'jud' and args.source ~= 'rif' and args.source ~= 'rta' and args.source ~= 'sou' and args.source ~= 'uta' and args.source ~= 'wra' 
          or args.source == 'sho'
          )
          and true
      end,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chips}}
    end,

    calculate = function(self, card, context)
        if context.ending_shop and not context.blueprint then
            local total = 0
            for k, v in ipairs(G.jokers and G.jokers.cards or {}) do
                total = total + v.sell_cost
            end
            card.ability.extra.chips = card.ability.extra.chips + total
            return {
                message = localize('k_upgrade_ex'),
            }
        end
        if context.joker_main and context.cardarea == G.jokers then
            return {
                xchips = card.ability.extra.chips
            }
        end
        if context.forcetrigger then
            local total = 0
            for k, v in ipairs(G.jokers and G.jokers.cards or {}) do
                total = total + v.sell_cost
            end
            card.ability.extra.chips = card.ability.extra.chips + total
            return {
                xchips = card.ability.extra.chips
            }
        end
    end
}
SMODS.Joker{ --Galvanic Conduit (v56)
    key = "galvanicconduit",
    config = {
        extra = {
            multmod = 5,
            mult = 1
        }
    },
    loc_txt = {
        ['name'] = 'Galvanic Conduit (v56)',
        ['text'] = {
            [1] = 'This Joker gains {X:red,C:white}X#1#{} Mult',
            [2] = '{C:attention}this round{} for every',
            [3] = '{C:attention}non-scoring{} cards',
            [4] = 'contained in played hand',
            [5] = '{C:inactive}(Currently{} {X:red,C:white}X#2#{} {C:inactive}Mult){}',
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 8,
        y = 5
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    
    loc_vars = function(self, info_queue, card)
        
        return {vars = {card.ability.extra.multmod, card.ability.extra.mult}}
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main or context.forcetrigger then
            return {
                xmult = card.ability.extra.mult
            }
        end
        if context.cardarea == G.jokers and context.before and not context.blueprint then
			cards = 0
			for k, v in ipairs(context.scoring_hand) do
				v.scoring = true
			end
			for k, v in ipairs(context.full_hand) do
				if not v.scoring then
					cards = cards + 1
					G.E_MANAGER:add_event(Event({
						func = function()
							v:juice_up()
							return true
						end,
					}))
				end
			end
			for k, v in ipairs(context.scoring_hand) do
				v.scoring = nil
			end
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.multmod * cards
        end
        if context.end_of_round and context.game_over == false and context.main_eval  and not context.blueprint then
            return {
                func = function()
                    card.ability.extra.mult = 0
                    return true
                end
            }
        end
    end
}
SMODS.Joker{ --Glue Storm (v39+)
    key = "gluestorm",
    config = {
        extra = {
            repetitions = 0,
            active = 0
        }
    },
    loc_txt = {
        ['name'] = 'Glue Storm (v39+)',
        ['text'] = {
            [1] = 'Retrigger all {C:attention}held in hand{} effects {C:attention}2x{} more',
            [2] = 'every other hand {C:inactive}(Currently #1# times){}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 7,
        y = 5
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 4,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
		return {
			vars = {
                card.ability.extra.repetitions
			},
		}
    end,

    calculate = function(self, card, context)
        if context.before and context.cardarea == G.jokers and not context.blueprint then
            if to_big((card.ability.extra.active or 0)) == to_big(0) then
                card.ability.extra.active = 1
            elseif to_big((card.ability.extra.active or 0)) ~= to_big(0) then
                card.ability.extra.active = 0
                card.ability.extra.repetitions = card.ability.extra.repetitions + 2
            end
        end
        if context.repetition and context.cardarea == G.hand and (not context.other_card.debuff) and (next(context.card_effects[1]) or #context.card_effects > 1)  then
            return {
                repetitions = card.ability.extra.repetitions,
                message = localize('k_again_ex')
            }
        end
    end
}
SMODS.Joker{ --Ground Zero (v18-29)
    key = "groundzero",
    config = {
        extra = {
            chips = 700
        }
    },
    loc_txt = {
        ['name'] = 'Ground Zero (v18-29)',
        ['text'] = {
            [1] = '{X:blue,C:white}X#1#{} Chips for the',
            [2] = 'first hand of the round',
            [3] = '{s:0.8,C:inactive}this looks familiar{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 5,
        y = 2
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 8,
    rarity = 2,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chips}}
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
            if G.GAME.current_round.hands_played == 0 then
                return {
                    xchips = card.ability.extra.chips
                }
            end
        end
        if context.forcetrigger then
            return {
                xchips = card.ability.extra.chips
            }
        end
    end
}

SMODS.Joker{ --Jugger nut Hole
    key = "juggernuthole",
    config = {
        extra = {
            repetitions = 100
        }
    },
    loc_txt = {
        ['name'] = 'Jugger nut Hole',
        ['text'] = {
            [1] = 'If played hand contains',
            [2] = '{C:attention}Five of a Kind{} or {C:attention}Flush House{},',
            [3] = '{C:attention}Retrigger{} all played cards {C:attention}#1#{} times'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 9,
        y = 2
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 20,
    rarity = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    in_pool = function(self, args)
          return (
          not args 
          or args.source ~= 'sho' 
          or args.source == 'buf' or args.source == 'jud' or args.source == 'rif' or args.source == 'rta' or args.source == 'sou' or args.source == 'uta' or args.source == 'wra'
          )
          and true
      end,
    
    loc_vars = function(self, info_queue, card)
        
        return {vars = {card.ability.extra.repetitions}}
    end,
    
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play  then
            if (next(context.poker_hands["Five of a Kind"]) or next(context.poker_hands["Flush House"])) then
                return {
                    repetitions = card.ability.extra.repetitions,
                    message = localize('k_again_ex')
                }
            end
        end
    end
}

SMODS.Joker{ --Pop and Awe
    key = "popandawe",
    config = {
		extra = {
			chips = 8,
			xchips = 3
		}
    },
    loc_txt = {
        ['name'] = 'Pop and Awe',
        ['text'] = {
            [1] = '{X:blue,C:white}/#1#{} Chips',
            [2] = '{X:planet,C:white}^#2#{} Chips'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 8,
        y = 3
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 6,
    rarity = 3,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
	
    loc_vars = function(self, info_queue, card)
        
        return {vars = {card.ability.extra.chips, card.ability.extra.xchips}}
    end,
	
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main or context.forcetrigger then
                return {
                    xchips = 1 / card.ability.extra.chips,
                    extra = {
                        echips = card.ability.extra.xchips,
                        colour = G.C.DARK_EDITION
                        }
                }
        end
    end
}
SMODS.Joker{ -- Quincy NFT
    key = "quincy_nft",
    config = {
		extra = {
			multiplier = 1.05,
		}
    },
    loc_txt = {
        ['name'] = 'Quincy Action Figure',
        ['text'] = {
            [1] = 'Initial sell value is its cost',
            [2] = 'Increase sell value by {C:attention}#1#x{}',
            [3] = 'when a hand finishes scoring'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 3,
        y = 0
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 8,
    rarity = 1,
    blueprint_compat = false,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
	
    loc_vars = function(self, info_queue, card)
        
        return {vars = {card.ability.extra.multiplier}}
    end,

    add_to_deck = function(self, card, context)
        if not from_debuff then
            card.ability.extra_value = (card.ability.extra_value or 0) + 4
            card.sell_cost = 8
        end -- bruh who made extra_value and sell_cost different things
    end,

    calculate = function(self, card, context)
        if context.after or context.forcetrigger and not context.blueprint then
            local total = 0
            for k, v in ipairs(G.jokers and G.jokers.cards or {}) do
                if v == card then
                    total = total + v.sell_cost
                end
            end
            local my_pos = nil
            local check = false
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    check = true
                    my_pos = i
                    break
                end
            end
            local target_card = G.jokers.cards[my_pos]
            target_card.ability.extra_value = (card.ability.extra_value or 0) + math.floor(total * (card.ability.extra.multiplier - 1 or 0) * 100 + 0.5) / 100
            target_card:set_cost()
            if check then
            card_eval_status_text(
                card,
                "extra",
                nil,
                nil,
                nil,
                { message = localize('k_upgrade_ex'), colour = G.C.GREEN }
            )
            end
        end
    end
}
SMODS.Joker{ --Riptide Champion (v52)
    key = "ripchamp",
    config = {
        extra = {
            mod = 0.06,
            chips = 1
        }
    },
    loc_txt = {
        ['name'] = 'Riptide Champion (v52)',
        ['text'] = {
            [1] = 'This Joker gains {X:planet,C:white}^#1#{} Chips',
            [2] = 'when each played card is scored',
            [3] = '{C:attention}Resets{} at end of round',
            [4] = '{C:inactive}(Currently{} {X:planet,C:white}^#2#{} {C:inactive}Chips){}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 2,
        y = 4
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    
    loc_vars = function(self, info_queue, card)
        
        return {vars = {card.ability.extra.mod, card.ability.extra.chips}}
    end,
    
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  and not context.blueprint then
            card.ability.extra.chips = (card.ability.extra.chips) + card.ability.extra.mod
            return {
                message = localize('k_upgrade_ex')
            }
        end
        if context.cardarea == G.jokers and context.joker_main  then
            return {
                echips = card.ability.extra.chips
            }
        end
        if context.end_of_round and context.game_over == false and context.main_eval  and not context.blueprint then
            return {
                func = function()
                    card.ability.extra.chips = 1
                    return true
                end,
                message = localize("k_reset")
            }
        end
        if context.forcetrigger then
			SMODS.scale_card(card, {
				ref_table = card.ability.extra,
				ref_value = "chips",
				scalar_value = "mod",
			})
			return {
				echip_mod = lenient_bignum(card.ability.extra.chips),
			}
        end
    end
}
SMODS.Joker{ --Super Brittle (v51)
    key = "sbrit",
    config = {
        extra = {
            chips = 5
        }
    },
    loc_txt = {
        ['name'] = 'Super Brittle (v51)',
        ['text'] = {
            [1] = 'Each held in hand {C:attention}5s{}',
            [2] = 'give {X:blue,C:white}X#1#{} Chips'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 6,
        y = 5
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)

        return {vars = {card.ability.extra.chips}}
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and not context.end_of_round  then
            if context.other_card:get_id() == 5 then
                return {
                    xchips = card.ability.extra.chips
                }
            end
        end
        if context.forcetrigger then
            xchips = card.ability.extra.chips
        end
    end
}
SMODS.Joker{ --:squalch:
    key = "squalch",
    config = {
        extra = {
            chips = 4,
            squarechips = 16
        }
    },
    loc_txt = {
        ['name'] = ':squalch:',
        ['text'] = {
            [1] = '{C:blue}+#2#{} Chips',
            [2] = '{C:attention}Quadratically{} increases',
            [3] = 'when something happens',
            [4] = '{C:inactive,s:0.7}(ex. +16, +25, +36, +49...){}'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 0,
        y = 0
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chips, card.ability.extra.chips ^ 2}}
    end,

    calculate = function(self, card, context)
        if (context.end_of_round or context.reroll_shop or context.buying_card or context.discard or
            context.selling_card or context.ending_shop or context.starting_shop or 
            context.ending_booster or context.skipping_booster or context.open_booster or
            context.skip_blind or context.before or context.setting_blind or
        context.using_consumeable or (context.individual and context.cardarea == G.play)) then
                local squarechips_value = card.ability.extra.squarechips
                return {
                    func = function()
                    card.ability.extra.chips = (card.ability.extra.chips) + 1
                    return true
                    end,
                    message = localize('k_upgrade_ex')
                }
        end
        if context.cardarea == G.jokers and context.joker_main then
                return {
                    chips = card.ability.extra.chips ^ 2
                }
        end
        if context.forcetrigger then
            card.ability.extra.chips = (card.ability.extra.chips) + 1
            return {
                chips = card.ability.extra.chips ^ 2
            }
        end
    end
}
SMODS.Joker{ --tb1 faster firing
    key = "tb1fasterfiring",
    config = {
        extra = {
            scoring = 1
        }
    },
    loc_txt = {
        ['name'] = 'tb1 faster firing',
        ['text'] = {
            [1] = 'This Joker gains {X:planet,C:white}^0.2{} Chips',
            [2] = 'if played hand contains',
            [3] = '{C:attention}5{} scoring cards',
            [4] = 'resets at the end of ante',
            [5] = '{C:inactive}(Currently{} {X:planet,C:white}^#1#{} {C:inactive}Chips){}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 8,
        y = 6
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 7,
    rarity = 2,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.scoring}}
    end,

    calculate = function(self, card, context)
        if context.before and context.cardarea == G.jokers  and not context.blueprint then
            if #context.scoring_hand >= 5 then
                return {
                    func = function()
                    card.ability.extra.scoring = (card.ability.extra.scoring) + 0.2
                    return true
                end,
                    message = localize('k_upgrade_ex'),
                }
            end
        end
        if context.cardarea == G.jokers and context.joker_main then
                return {
                    echips = card.ability.extra.scoring
                }
        end
		if context.forcetrigger then
				card.ability.extra.scoring = (card.ability.extra.scoring) + 0.2
                return {
                    echips = card.ability.extra.scoring
                }
		end
        if context.end_of_round and context.main_eval and G.GAME.blind.boss and not context.blueprint then
            return {
                func = function()
                    card.ability.extra.scoring = 1
                    return true
                end,
                message = localize("k_reset")
            }
        end
    end
}
SMODS.Joker{ --tb1 burny stuff
    key = "tb1burnystuff",
    config = {
        extra = {
            scoring = 1,
            cd = 3
        }
    },
    loc_txt = {
        ['name'] = 'tb1 burny stuff',
        ['text'] = {
            [1] = 'This Joker gains {X:legendary,C:white}^1{} Mult',
            [2] = 'after {C:attention}#2#{} played hands',
            [3] = 'that contain {C:attention}5{} scoring cards',
            [4] = 'resets at the end of ante',
            [5] = '{C:inactive}(Currently{} {X:legendary,C:white}^#1#{} {C:inactive}Mult){}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 9,
        y = 6
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 7,
    rarity = 2,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.scoring, card.ability.extra.cd}}
    end,

    calculate = function(self, card, context)
        if context.before and context.cardarea == G.jokers  and not context.blueprint then
            if (#context.scoring_hand >= 5 and (card.ability.extra.cd or 0) > 1) then
                return {
                    func = function()
                    card.ability.extra.cd = math.max(0, (card.ability.extra.cd) - 1)
                    return true
                end
                }
            elseif (#context.scoring_hand >= 5 and (card.ability.extra.cd or 0) <= 1) then
                return {
                    func = function()
                    card.ability.extra.scoring = (card.ability.extra.scoring) + 1
                    return true
                end,
                    message = localize('k_upgrade_ex'),
                    extra = {
                        func = function()
                    card.ability.extra.cd = 3
                    return true
                end,
                        colour = G.C.BLUE
                        }
                }
            end
        end
        if context.cardarea == G.jokers and context.joker_main then
                return {
                    emult = card.ability.extra.scoring
                }
        end
		if context.forcetrigger then
				card.ability.extra.scoring = (card.ability.extra.scoring) + 1
                return {
                    emult = card.ability.extra.scoring
                }
		end
        if context.end_of_round and context.main_eval and G.GAME.blind.boss and not context.blueprint then
            return {
                func = function()
                    card.ability.extra.scoring = 1
                    return true
                end,
                message = localize("k_reset")
            }
        end
    end
}
SMODS.Joker{ --Tricky tracks
    key = "trickytracks",
    config = {
        extra = {
            mult = 1,
            scale = 0.2
        }
    },
    loc_txt = {
        ['name'] = 'Tricky tracks',
        ['text'] = {
            [1] = '{X:legendary,C:white}^Mult{} increases once if',
            [2] = 'played hand is {C:attention}Three of a Kind{}',
            [3] = '{X:legendary,C:white}^Mult{} scales faster the further',
            [4] = 'it is away from {X:legendary,C:white}^2{} Mult',
            [5] = '{C:inactive}(Currently {}{X:legendary,C:white}^#1#{}{C:inactive} Mult, increases by{} {X:legendary,C:white}#2#{}{C:inactive}){}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 7,
        y = 6
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    
    loc_vars = function(self, info_queue, card)
        
        return {vars = {card.ability.extra.mult, card.ability.extra.scale}}
    end,
    
    calculate = function(self, card, context)
        if context.before and context.cardarea == G.jokers  and not context.blueprint then
            if context.scoring_name == "Three of a Kind" then
                return {
                    func = function()
                        card.ability.extra.mult = lenient_bignum(card.ability.extra.mult) + lenient_bignum(card.ability.extra.scale)
                        return true
                    end,
                    message = localize('k_upgrade_ex'),
                    extra = {
                        func = function()
                            card.ability.extra.scale = lenient_bignum(math.abs(2 - card.ability.extra.mult) * 0.1 + 0.1)
                            return true
                        end,
                        colour = G.C.BLUE
                    }
                }
            end
        end
        if context.cardarea == G.jokers and context.joker_main  then
            return {
                Xmult = card.ability.extra.mult
            }
        end
        if context.forcetrigger then
            return {
                func = function()
                        card.ability.extra.mult = lenient_bignum(card.ability.extra.mult) + lenient_bignum(card.ability.extra.scale)
                        return true
                end,
                message = localize('k_upgrade_ex'),
                extra = {
                    func = function()
                        card.ability.extra.scale = lenient_bignum(math.abs(2 - card.ability.extra.mult) * 0.1 + 0.1)
                        return true
                    end,
                    colour = G.C.BLUE
                    },
                Xmult = card.ability.extra.mult
                }
        end
    end
}


SMODS.Joker{ --Water Tower
    key = "watertower",
    config = {
        extra = {
            mult = 1,
            multmod = 2
        }
    },
    loc_txt = {
        ['name'] = 'Water Tower',
        ['text'] = {
            [1] = 'This Joker gains {X:red,C:white}X#2#{} Mult if',
            [2] = 'played hand is not your',
            [3] = '{C:attention}most played{} Poker Hand',
            [4] = '{C:inactive}(Currently{} {X:red,C:white}X#1#{} {C:inactive}Mult){}'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 0,
        y = 5
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = false,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    
    loc_vars = function(self, info_queue, card)
        
        return {vars = {card.ability.extra.mult, card.ability.extra.multmod}}
    end,
    
    calculate = function(self, card, context)
        if context.before and context.cardarea == G.jokers  and not context.blueprint then
            if (function()
                local current_played = G.GAME.hands[context.scoring_name].played or 0
                for handname, values in pairs(G.GAME.hands) do
                    if handname ~= context.scoring_name and values.played >= current_played and values.visible then
                        return true
                    end
                end
                return false
            end)() then
                return {
                    message = localize('k_upgrade_ex'),
                    func = function()
                        card.ability.extra.mult = (card.ability.extra.mult) + card.ability.extra.multmod
                        return true
                    end
                }
            end
        end
        if context.cardarea == G.jokers and context.joker_main  then
            return {
                xmult = card.ability.extra.mult
            }
        end
        if context.forcetrigger then
            local mult_value = card.ability.extra.mult
            card.ability.extra.mult = (card.ability.extra.mult) + card.ability.extra.multmod
             return {
                xmult = mult_value
            }
        end
    end
}
	
if Talisman then
	
if Cryptid then --Cryptlib
SMODS.Joker{ --tt5
    key = "tt5bug",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Total transformation bug (v38)',
        ['text'] = {
            [1] = '{C:attention}Force-trigger{} Joker to the {C:attention}right{}',
            [2] = 'when Joker to the {C:attention}left{} is triggered', -- what you think this needs a buff?
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 1,
        y = 5
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 20,
    rarity = 4,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
	soul_pos = { x = 2, y = 5, extra = { x = 3, y = 5 } },
    
    calculate = function(self, card, context)
        if context.post_trigger then
            local left_joker = nil
            for k, v in ipairs(G.jokers.cards) do
                if v == card then
                    if k > 1 then
                        left_joker = G.jokers.cards[k - 1]
                    end
                end
            end
            if left_joker and context.other_card == left_joker then
			    for i = 1, #G.jokers.cards do
				    if G.jokers.cards[i] == card then
						local results = Cryptid.forcetrigger(G.jokers.cards[i + 1], context)
						if results and results.jokers then
							return results.jokers
						end
					end
				end
			end
        end
    end
}
end

SMODS.Joker{ --Overclock
    key = "overclock",
    config = {
        extra = {
            ignore = 0
        }
    },
    loc_txt = {
        ['name'] = 'Overclock',
        ['text'] = {
            [1] = '{X:dark_edition,C:white}^($)2{} Mult',
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 5,
        y = 3
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 30,
    rarity = "ssr_the_expert",
    blueprint_compat = true,
    demicoloncompat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    in_pool = function(self, args)
          return (
          not args 
          or args.source ~= 'buf' and args.source ~= 'jud' and args.source ~= 'rif' and args.source ~= 'rta' and args.source ~= 'sou' and args.source ~= 'uta' and args.source ~= 'wra' 
          or args.source == 'sho'
          )
          and true
      end,

    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            return {hypermult = {lenient_bignum(math.max(math.floor(G.GAME.dollars or 0), 1)), 2}}
        end
    end
}
end
