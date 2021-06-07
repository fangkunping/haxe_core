package core.until;

class HawkRandTools {
	private static final A:Int = 48271;

	private static final INT_MAX_VALUE:Int = 2147483647;

	private static final Q:Int = 44488;

	private static final R:Int = 3399;

	private static var State:Int = -1;

	public static function setRandSeed(seed:Int) {
		State = seed;
	}

	public static function clearRandSeed() {
		State = -1;
	}

	public static function randInt():Int {
		if (State < 0) {
			State = Math.floor(Math.random() * INT_MAX_VALUE);
		}
		final tmpState = Math.floor(A * State % Q - R * State / Q);
		if (tmpState >= 0) {
			State = tmpState;
		} else {
			State = tmpState + INT_MAX_VALUE;
		}
		return State;
	}

	public static function randInt_1(max:Int):Int {
		return randInt() % (max + 1);
	}

	public static function randInt_2(low:Int, high:Int):Int {
		if (low > high) {
			var t = low;
			low = high;
			high = t;
		}
		return randInt_1(high - low) + low;
	}

	public static function randFloat():Float {
		return randInt() / 2.14748365E9;
	}

	public static function randFloat_1(max:Float):Float {
		return randFloat() * max;
	}

	public static function randFloat_2(low:Float, high:Float):Float {
		if (low > high) {
			var t = low;
			low = high;
			high = t;
		}
		return randFloat_1(high - low) + low;
	}

	public static function randPercentRate(rate:Int):Bool {
		var randVal = randInt_2(1, 100);
		if (randVal <= rate) {
			return true;
		}
		return false;
	}

	public static function randonWeightObject_2<T>(objList:Array<T>, objWeight:Array<Int>):T {
		// if (objList == null || objWeight == null || objList.length != objWeight.length)
		//  throw new RuntimeException("random weight object exception");
		var totalWeight = 0;
		var fmtWeight = new Array<Int>();
		for (i in 0...objWeight.length) {
			totalWeight += objWeight[i];
			fmtWeight.push(totalWeight);
		}
		var randomWeight = randInt_2(1, totalWeight);
		for (j in 0...fmtWeight.length) {
			if (randomWeight <= fmtWeight[j])
				return objList[j];
		}
		return null;
	}

	public static function randonWeightObject_3<T>(objList:Array<T>, objWeight:Array<Int>, count:Int):Array<T> {
		// if (objList == null || objWeight == null || count <= 0 || objList.size() != objWeight.size() || count > objList.size())
		//	throw new RuntimeException("random weight object exception");
		var objWeightStub = new Array<Int>();
		for (i in 0...objWeight.length) {
			objWeightStub.push(objWeight[i]);
		}
		var selObjList = new Array<T>();
		while (selObjList.length < count) {
			var totalWeight = 0;
			var fmtWeight = new Array<Int>();
			for (i in 0...objWeightStub.length) {
				totalWeight += objWeightStub[i];
				fmtWeight.push(totalWeight);
			}
			var randomWeight = randInt_2(1, totalWeight);
			for (j in 0...fmtWeight.length) {
				if (randomWeight <= fmtWeight[j]) {
					selObjList.push(objList[j]);
					objWeightStub[j] = 0;
					break;
				}
			}
		}
		return selObjList;
	}

	public static function randomOrder_1<T>(objList:Array<T>) {
		randomOrder_2(objList, 1);
	}

	public static function randomOrder_2<T>(objList:Array<T>, calcTimes:Int) {
		for (i in 0...calcTimes) {
			for (j in 0...objList.length) {
				var exchangeIdx = randInt_2(0, objList.length - 1);
				if (exchangeIdx != j) {
					var obj = objList[j];
					objList[j] = objList[exchangeIdx];
					objList[exchangeIdx] = obj;
				}
			}
		}
	}

	/**
		将一个数切成 part 片， 最小 值为 minVal
	**/
	public static function randomIncision(totalCount:Int, part:Int, minVal:Int):Array<Int> {
		var partCount = new Array<Int>();
		for (i in 0...part) {
			var value = (i == part - 1) ? totalCount : randInt_2(minVal, totalCount - (part - i - 1) * minVal);
			partCount.push(value);
			totalCount -= value;
		}

		return partCount;
	}
}
