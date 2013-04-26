bind(entity_damage_player, null, null, @event,
    #Entity ID (EX: id of the arrow)
    @id = @event['id']
    
    #fetch damage
    @damage = @event['amount']
    
    #fetch attacker
    @attacker = @event['data']
    if(!ponline(@attacker)) {
        die()
    }
    
    #fetch target
    @target = @event['player']

    @inbattleAttacker = import('combat.battle.' .@attacker)
    @inbattleTarget = import('combat.battle.' .@target)
    msg(@inbattleAttacker @inbattleTarget)
    if(@inbattleAttacker == '' || is_null(@inbattleAttacker)) {
        if(@inbattleTarget == '' || is_null(@inbattleTarget)) {
            @attackerAttackTime = time()
            @targetAttackTime = import('combat.time.'. @target. '.' .@attacker)
            if(is_numeric(@targetAttackTime) && ((@attackerAttackTime - @targetAttackTime) / 1000 < 60)) {
                #initiate battle and reset battle times to prevent unwanted rematches
                export('combat.battle.' .@attacker, @target)
                export('combat.battle.' .@target, @attacker)
                export('combat.time.'. @target. '.' .@attacker, '')
                export('combat.time.'. @attacker. '.' .@target, '')

                broadcast(@attacker. ' and ' .@target. ' are battling!')
            } else {
                export('combat.time.'. @attacker. '.' .@target, time())
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
@inBattle = import('combat.battle.' .@player)
if(@inBattle != ''){
        export('combat.battle.' .@player, '')
        export('combat.battle.' .@inBattle, '')
        broadcast(@player. ' has quit in the middle of a battle. Therefor making ' .@inBattle. ' the winner!')
#test what killing the player does
        kill(player())
    }
)


bind(player_death, null, null, @event,
@player = @event['player']
@inBattle = import('combat.battle.' .@player)
if(@inBattle != ''){
        export('combat.battle.' .@player, '')
        export('combat.battle.' .@inBattle, '')
        broadcast(@player. ' has died, ' .@inBattle. ' Has won the battle!')
    }
)