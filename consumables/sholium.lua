SMODS.Consumable {
    key = 'sholium',
    set = 'Spectral',
    pos = { x = 2, y = 0 },
    config = { extra = {
        hands_value = 1,
        joker_slots_value = 1
    } },
    loc_txt = {
      ['default'] = {
        name = 'Sholium',
        text = {
        [1] = '{C:dark_edition}+1{} Joker Slot',
        [2] = 'and spawn a {C:attention}Joker{} with',
        [3] = '{C:dark_edition,E:1}The Expert{} rarity'
    }
            },
    },
    cost = 4,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',
    use = function(self, card, area, copier)
        local used_card = copier or card
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    card_eval_status_text(used_card, 'extra', nil, nil, nil, {message = "+"..tostring(1).." Joker Slot", colour = G.C.DARK_EDITION})
                    G.jokers.config.card_limit = G.jokers.config.card_limit + 1
                    return true
                end
            }))
            delay(0.6)
            G.E_MANAGER:add_event(Event({
                  trigger = 'after',
                  delay = 0.4,
                  func = function()
                      play_sound('timpani')
                      local new_joker = SMODS.add_card({ set = 'Joker', rarity = 'ssr_the_expert' })
                      if new_joker then
                      end
                      used_card:juice_up(0.3, 0.5)
                      return true
                  end
              }))
              delay(0.6)
    end,
    can_use = function(self, card)
        return true
    end
}