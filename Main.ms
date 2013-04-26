include('util/util.msa')

bind(entity_damage_player, null, null, @event,
    #Entity ID (EX: id of the arrow)
    @id = @event['id']
    
    #fetch 
    @damage = @event['amount']
    
    #fetch attacker
    @attacker = @event['data']
    if(!ponline(@attacker)) {
        die()
    }
    
    #fetch target
    @target = @event['player']damage

    @inbattleAttacker = _get_battleStatus(@attacker)
    @inbattleTarget = _get_battleStatus(@target)
    msg(@inbattleAttacker @inbattleTarget)
    if(@inbattleAttacker == '' || is_null(@inbattleAttacker)) {
        if(@inbattleTarget == '' || is_null(@inbattleTarget)) {
            @attackerAttackTime = time()
            @targetAttackTime = _get_attackTime(@attacker, @target)
            if(is_numeric(@targetAttackTime) && ((@attackerAttackTime - @targetAttackTime) / 1000 < 60)) {
                #initiate battle and reset battle times to prevent unwanted rematches
                _store_battleStatus(@attacker, @target)
                _store_battleStatus(@target, @attacker)
                export('combat.time.'. @target. '.' .@attacker, '')
                _reset_attackTime(@attacker, @target)
                _reset_attackTime(@target, @attacker)

                broadcast(@attacker. ' and ' .@target. ' are battling!')
            } else {
                _store_attackTime(@attacker, @target)
                tmsg(@target, @attacker. ' would like to battle, attack back if you accept.')
            }
            cancel()
            # record here that @attacker has attacked @target
        } else {
            tmsg(@attacker, @target. 'is already in battle please wait.')
            cancel()
        }
    } else {
       if(@target != @inbattleAttacker) {
           tmsg(@attacker, 'you can\'t attack other players while in battle with ' .@inbattleAttacker)
           cancel()
        }
    }
)


bind(player_quit, null, null, @event,
    @player = @event['player']
    @inBattle = _get_battleStatus(@player)
    if(@inBattle != ''){
        _store_battleStatus('', @inBattle)
        _store_battleStatus('', @player)
        broadcast(@player. ' has quit in the middle of a battle. Therefor making ' .@inBattle. ' the winner!')

        #test what killing the player does
        kill(player())
    }
)


bind(player_death, null, null, @event,
    @player = @event['player']
    @inBattle = _get_battleStatus(@player)
    if(@inBattle != ''){
        _store_battleStatus('', @player)
        _store_battleStatus('', @inBattle)
        broadcast(@player. ' has died, ' .@inBattle. ' Has won the battle!')
    }
)