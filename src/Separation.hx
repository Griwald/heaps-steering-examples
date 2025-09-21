class Separation extends hxd.App {
	var vehicles:Array<Vehicle> = [];

	override function init() {
		final count = 200;
		var config = {radius: 6, maxSpeed: 3, maxForce: 0.2};
		for (i in 0...count) {
			vehicles.push(new Vehicle(config, hxd.Math.random(s2d.width), hxd.Math.random(s2d.width), s2d));
		}
	}

	override function update(dt : Float) {
		for (v in vehicles) {
			v.separate(vehicles);
			v.update();
			v.borders(s2d.width, s2d.height);
		}
	}

	static function main() {
		new Separation();
	}
}
