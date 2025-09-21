typedef Config = {
	var radius:Float;
	var maxSpeed:Float;
	var maxForce:Float;
	var ?desiredSeparation:Float;
	var ?neighborDistance:Float;
}

class Vehicle extends h2d.Object {
	var config:Config;

	var position:h2d.col.Point;
	var velocity:h2d.col.Point;
	var acceleration:h2d.col.Point;

	public function new(config, x, y, ?velX, ?velY, ?parent) {
		super(parent);
		this.config = config;
		createGraphics();
		setPosition(x, y);
		rotation = hxd.Math.random(hxd.Math.PI * 2);

		position = new h2d.col.Point(x, y);
		velocity = new h2d.col.Point(velX ?? 0, velY ?? 0);
		acceleration = new h2d.col.Point(0, 0);
	}

	public function update() {
		velocity += acceleration;
		velocity.limit(config.maxSpeed);
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
		desired.setLength(config.maxSpeed);
		var steer = desired - velocity;
		steer.limit(config.maxForce);
		return steer;
	}

	public function separate(vehicles:Array<Vehicle>) {
		var desiredSep = config.desiredSeparation ?? config.radius * 2;
		var steer = new h2d.col.Point(0, 0);
		var count = 0;

		for (other in vehicles) {
			var d = position.distance(other.position);
			if (d > 0 && d < desiredSep) {
				var diff = position - other.position;
				diff.setLength(1. / d);
				steer += diff;
				count++;
			}
		}

		if (count > 0)
			steer.scale(1. / count);

		if (steer.lengthSq() > 0) {
			steer.setLength(config.maxSpeed);
			steer -= velocity;
			steer.limit(config.maxForce);
		}

		return steer;
	}

	public function align(vehicles:Array<Vehicle>) {
		var neighborDist = config.neighborDistance ?? config.radius * 4;
		var sum = new h2d.col.Point(0, 0);
		var count = 0;

		for (other in vehicles) {
			var d = position.distance(other.position);
			if (d > 0 && d < neighborDist) {
				sum += other.velocity;
				count++;
			}
		}

		if (count > 0) {
			sum.scale(1. / count);
			sum.setLength(config.maxSpeed);
			var steer = sum - velocity;
			steer.limit(config.maxForce);
			return steer;
		} else {
			return new h2d.col.Point(0, 0);
		}
	}

	public function cohere(vehicles:Array<Vehicle>) {
		var neighborDist = config.neighborDistance ?? config.radius * 4;
		var sum = new h2d.col.Point(0, 0);
		var count = 0;

		for (other in vehicles) {
			var d = position.distance(other.position);
			if (d > 0 && d < neighborDist) {
				sum += other.position;
				count++;
			}
		}

		if (count > 0) {
			sum.scale(1. / count);
			return seek(sum);
		} else {
			return new h2d.col.Point(0, 0);
		}
	}

	public function borders(width, height) {
		if (position.x < -config.radius)
			position.x = width + config.radius;
		if (position.y < -config.radius)
			position.y = height + config.radius;
		if (position.x > width + config.radius)
			position.x = -config.radius;
		if (position.y > height + config.radius)
			position.y = -config.radius;
	}

	function createGraphics() {
		var g = new h2d.Graphics(this);
		g.beginFill(0xffffff);
		g.moveTo(config.radius * 2, 0);
		g.lineTo(-config.radius * 2, -config.radius);
		g.lineTo(-config.radius * 2, config.radius);
		g.endFill();
	}
}
