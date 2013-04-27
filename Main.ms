include('util/util.ms')

bind(entity_damage_player, null, null, @event,
    @attacker = @event['data']
    if(!ponline(@attacker)) {
        die()
    }

    @target = @event['player']

    @attackerDuelOponent = _get_duelOponent(@attacker)
    @targetDuelOponent = _get_duelOponent(@target)
    if(@attackerDuelOponent == '' || is_null(@attackerDuelOponent)) {
        if(@TargetDuelOponent == '' || is_null(@TargetDuelOponent)) {
            @attackerAttackTime = _get_attackTime(@attacker, @target)
            @targetAttackTime = _get_attackTime(@target, @attacker)
            if(is_numeric(@targetAttackTime) && ((time() - @targetAttackTime) / 1000 < 60)) {
                _store_duelOponent(@attacker, @target)
                _store_duelOponent(@target, @attacker)
                _reset_attackTime(@attacker, @target)
                _reset_attackTime(@target, @attacker)

                broadcast(_format(@attacker. ' and ' .@target. ' are now in a duel!', notification))
            } else if(!is_numeric(@attackerAttackTime) || (time() - @attackerAttackTime) / 1000 > 30) {
                _store_attackTime(@attacker, @target)
                tmsg(@target, _format(@attacker. ' would like to duel, attack back if you accept.', 'notification'))
            }
            cancel()
        } else {
            tmsg(@attacker, _format(@target. 'is already in a duel please wait.', 'notification'))
            cancel()
        }
    } else {
       if(@target != @attackerDuelOponent) {
           tmsg(@attacker, _format('you can\'t attack other players while in a duel with ' .@attackerDuelOponent, 'notification'))
           cancel()
        }
    }
)


bind(player_quit, null, null, @event,
    @player = @event['player']
    @duelOponent = _get_duelOponent(@player)
    if(@duelOponent != ''){
        _store_duelOponent('', @duelOponent)
        _store_duelOponent('', @player)
        broadcast(_format(@player. ' has quit in the middle of a duel. Therefor making ' .@duelOponent. ' the winner!', 'notification'))
        kill(@player)
    }
)


bind(player_death, null, null, @event,
    @player = @event['player']
    @duelOponent = _get_duelOponent(@player)
    if(@duelOponent != ''){
        _store_duelOponent('', @player)
        _store_duelOponent('', @duelOponent)
        broadcast(_format(@player. ' has died, ' .@duelOponent. ' Has won the duel!', notification))
        modify_event('death_message', null)
    }
)