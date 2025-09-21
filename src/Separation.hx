class Separation extends hxd.App {
	var vehicles:Array<Vehicle> = [];

	override function init() {
		var count = 200;

		var config = {
			radius: 6.,
			maxSpeed: 3.,
			maxForce: 0.2,
			desiredSeparation: 25.
		};

		for (i in 0...count) {
			var x = hxd.Math.random(s2d.width);
			var y = hxd.Math.random(s2d.height);
			vehicles.push(new Vehicle(config, x, y, s2d));
		}
	}

	override function update(dt:Float) {
		for (v in vehicles) {
			var steer = v.separate(vehicles);
			v.applyForce(steer);
			v.update();
			v.borders(s2d.width, s2d.height);
		}
	}

	static function main() {
		new Separation();
	}
}
