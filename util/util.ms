proc(_store_duelOponent, @data, @player,
	export('aczchef.primedduels.duel.' .@player, @data)
)
proc(_get_duelOponent, @player,
	return(import('aczchef.primedduels.duel.' .@player))
)


proc(_get_attackTime, @attacker, @target,
	return(import('aczchef.primedduels.time.attack.' .@attacker. '.' .@target))
)
proc(_store_attackTime, @attacker, @target,
	export('aczchef.primedduels.time.attack.' .@attacker. '.' .@target, time())
)
proc(_reset_attackTime, @attacker, @target,
	export('aczchef.primedduels.time.attack.' .@attacker. '.' .@target, '')
)


proc(_get_requestTime, @attacker, @target,
	return(import('aczchef.primedduels.time.request' .@attacker. '.' .@target))
)
proc(_store_requestTime, @attacker, @target,
	export('aczchef.primedduels.time.request' .@attacker. '.' .@target, time())
)
proc(_reset_requestTime, @attacker, @target,
	export('aczchef.primedduels.time.request' .@attacker. '.' .@target, '')
)


proc(_format, @message, @type,
	@type = to_lower(@type)
	if(@type == 'success') {
		return(color('Dark_Green'). '[' .color('Green'). 'Primed Duel' .color('Dark_Green'). ']' color('Green'). '»' color('White'). @message)
	} else if(@type == 'error') {
		return(color('Dark_red'). '[' .color('Red'). 'Primed Duel' .color('Dark_Red'). ']' color('Red'). '»' color('White'). @message)
	} else if(@type == 'notification') {
		return(color('Blue'). '[' .color('Yellow'). 'Primed Duel' .color('Blue'). ']' color('Yellow'). '»' color('White'). @message)
	}
)
