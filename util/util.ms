proc(_store_battleStatus, @data, @player,
	export('combat.battle.' .@player, @data)
)

proc(_get_battleStatus, @player,
	return(import('combat.battle.' .@player))
)

proc(get_attackTime, @attacker, @target,
	return(import('combat.time.' .@attacker. '.' .@target))

)
proc(store_attackTime, @attacker, @target,
	export('combat.time.' .@attacker. '.' .@target, time())

)
proc(reset_attackTime, @attacker, @target,
	export('combat.time.' .@attacker. '.' .@vicitm, '')

)
