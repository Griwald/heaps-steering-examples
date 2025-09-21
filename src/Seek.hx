class Seek extends hxd.App {
	var vehicle:Vehicle;
	var mouseGraphics:h2d.Graphics;

	override function init() {
		mouseGraphics = new h2d.Graphics(s2d);
		mouseGraphics.beginFill(0xff00ff);
		mouseGraphics.drawCircle(0, 0, 10);
		mouseGraphics.endFill();

		var config = {radius: 12, maxSpeed: 8, maxForce: 0.2};
		vehicle = new Vehicle(config, s2d.width / 2, s2d.height / 2, s2d);
	}

	override function update(dt:Float) {
		var mouse = new h2d.col.Point(s2d.mouseX, s2d.mouseY);
		mouseGraphics.setPosition(mouse.x, mouse.y);

		vehicle.seek(mouse);
		vehicle.update();
	}

	static function main() {
		new Seek();
	}
}
