typedef Config = {
	var radius:Float;
	var maxSpeed:Float;
	var maxForce:Float;
}

class Vehicle extends h2d.Object {
	var position:h2d.col.Point;
	var velocity:h2d.col.Point;
	var acceleration:h2d.col.Point;

	var r:Float;
	var maxSpeed:Float;
	var maxForce:Float;

	public function new(config, x, y, ?parent) {
		r = config.radius;
		maxSpeed = config.maxSpeed;
		maxForce = config.maxForce;

		super(parent);
		createGraphics();
		setPosition(x, y);
		rotation = hxd.Math.random(hxd.Math.PI * 2);

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
		if (velocity.lengthSq() > hxd.Math.EPSILON2)
			rotation = hxd.Math.atan2(velocity.y, velocity.x);
	}

	public function applyForce(force) {
		acceleration += force;
	}

	public function seek(target:h2d.col.Point) {
		var desired = target - position;
		desired.setLength(maxSpeed);
		var steer = desired - velocity;
		steer.limit(maxForce);
		applyForce(steer);
	}

	public function separate(vehicles:Array<Vehicle>) {
		final desiredSep = r * 4;
		var sum = new h2d.col.Point(0, 0);
		var count = 0;
		for (other in vehicles) {
			var d = position.distance(other.position);
			if (this != other && d < desiredSep) {
				var diff = position - other.position;
				diff.setLength(1. / d);
				sum += diff;
				count++;
			}
		}
		if (count > 0) {
			sum.setLength(maxSpeed);
			var steer = sum - velocity;
			steer.limit(maxForce);
			applyForce(steer);
		}
	}

	public function borders(width, height) {
		if (position.x < -r)
			position.x = width + r;
		if (position.y < -r)
			position.y = height + r;
		if (position.x > width + r)
			position.x = -r;
		if (position.y > height + r)
			position.y = -r;
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
