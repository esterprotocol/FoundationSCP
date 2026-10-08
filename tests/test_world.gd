extends RefCounted
## F0-02: mesma seed e mesmos ticks produzem o mesmo estado, qualquer que seja o caminho.


func run(c: Checks) -> void:
	var a := SimWorld.new(99)
	var b := SimWorld.new(99)
	for _i in 1000:
		a.step()
		b.step()
	c.check(a.clock.tick == 1000 and b.clock.tick == 1000, "1000 passos geram 1000 ticks")
	c.check(a.checksum == b.checksum, "mesma seed e mesmos ticks produzem estado idêntico")

	var other := SimWorld.new(100)
	for _i in 1000:
		other.step()
	c.check(other.checksum != a.checksum, "seed diferente produz estado diferente")

	var timed := SimWorld.new(99)
	for _i in 1000:
		timed.advance(0.1)
	c.check(timed.clock.tick == 1000 and timed.checksum == a.checksum, "advance() por tempo e step() chegam ao mesmo estado")
