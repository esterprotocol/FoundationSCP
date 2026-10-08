extends RefCounted
## F0-02: conversão de tempo real em ticks, velocidades, pausa e limite de salto.


func run(c: Checks) -> void:
	var clock := SimClock.new()
	c.check(clock.advance(0.25) == 2, "0,25 s a 1× gera 2 ticks de 0,1 s")
	c.check(absf(clock.accumulator - 0.5) < 0.000001, "o resto de 0,05 s (meio tick) fica no acumulador")
	c.check(clock.tick == 0, "o relógio não altera tick: quem executa é o mundo")

	var fast := SimClock.new()
	c.check(fast.set_speed(4) and fast.advance(1.0) == 40, "1 s a 4× gera 40 ticks")

	var double := SimClock.new()
	c.check(double.set_speed(2) and double.advance(1.0) == 20, "1 s a 2× gera 20 ticks")
	c.check(not double.set_speed(3) and double.speed == 2, "velocidade fora de 1/2/4 é rejeitada")

	var paused := SimClock.new()
	paused.advance(0.05)
	var before := paused.accumulator
	paused.set_paused(true)
	c.check(paused.advance(5.0) == 0 and paused.accumulator == before, "pausa não gera ticks nem acumula tempo")
	paused.toggle_pause()
	c.check(not paused.paused, "toggle_pause retoma a simulação")

	var spike := SimClock.new()
	c.check(spike.advance(1000.0) == SimSettings.MAX_TICKS_PER_ADVANCE, "salto grande é limitado")
	c.check(spike.accumulator == 0.0, "o excedente de um salto é descartado, sem rajada posterior")
