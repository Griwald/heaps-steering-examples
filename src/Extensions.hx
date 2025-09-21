class Extensions {
	inline public static function limit( v : h2d.col.Point, max : Float ) {
		var magSq = v.lengthSq();
		if (magSq > max * max && magSq > hxd.Math.EPSILON2)
			v.scale(max / Math.sqrt(magSq));
		return v;
	}

	inline public static function setLength( v : h2d.col.Point, n : Float ) {
		v.normalize();
		v.scale(n);
		return v;
	}
}