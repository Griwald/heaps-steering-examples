class Vehicle extends h2d.Object {
	var position : h2d.col.Point;
	var velocity : h2d.col.Point;
	var acceleration : h2d.col.Point;

	final r = 6.;
	final maxSpeed = 8.;
	final maxForce = 0.2;

	public function new(x, y, ?parent) {
		super(parent);
		createGraphics();
		setPosition(x, y);

		position = new h2d.col.Point(x, y);
		velocity = new h2d.col.Point(0, 0);
		acceleration = new h2d.col.Point(0, 0);
	}

	public function update() {
		velocity += acceleration;
		velocity.limit(maxSpeed);
		position += velocity;
		acceleration.set(0, 0);

		setPosition(position.x, position.y);
		if( velocity.lengthSq() > hxd.Math.EPSILON2 )
			rotation = hxd.Math.atan2(velocity.y, velocity.x);
	}

	public function applyForce(force) {
		acceleration += force;
	}

	public function seek(target : h2d.col.Point) {
		var desired = target - position;
		desired.setLength(maxSpeed);
		var steer = desired - velocity;
		steer.limit(maxForce);
		applyForce(steer);
	}

	function createGraphics() {
		var g = new h2d.Graphics(this);
		g.beginFill(0xffffff);
		g.moveTo(r * 2, 0);
		g.lineTo(-r * 2, -r);
		g.lineTo(-r * 2, r);
		g.endFill();
	}
}