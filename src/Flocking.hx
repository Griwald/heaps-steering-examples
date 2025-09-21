class Flocking extends hxd.App {
	var vehicles:Array<Vehicle> = [];

	override function init() {
		var count = 120;

		var config = {
			radius: 6.,
			maxSpeed: 3.,
			maxForce: 0.05,
			desiredSeparation: 25.,
			neighborDistance: 50.
		};

		for (i in 0...count) {
			var x = hxd.Math.random(s2d.width);
			var y = hxd.Math.random(s2d.height);
			var velX = hxd.Math.srand();
			var velY = hxd.Math.srand();
			vehicles.push(new Vehicle(config, x, y, velX, velY, s2d));
		}
	}

	override function update(dt:Float) {
		for (v in vehicles) {
			var sep = v.separate(vehicles);
			var ali = v.align(vehicles);
			var coh = v.cohere(vehicles);

			sep.scale(1.5);
			ali.scale(1.0);
			coh.scale(1.0);

			v.applyForce(sep);
			v.applyForce(ali);
			v.applyForce(coh);

			v.update();
			v.borders(s2d.width, s2d.height);
		}
	}

	static function main() {
		new Flocking();
	}
}
