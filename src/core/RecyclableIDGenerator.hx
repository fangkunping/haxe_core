package core;

class RecyclableIDGenerator {
	public static final NeverID = -1;

	var maxValue:Int = 65535;
	var nextId:Int = NeverID;
	var usedIds:Map<Int, Bool>;

	public function new() {
		usedIds = new Map();
	}

	public function setMaxIDValue(v:Int) {
		maxValue = 65535;
	}

	public function allocateID():Int {
		nextId++;

		if (nextId > maxValue)
			nextId = 0;

		// Skip over any used values to the next free value
		while (usedIds.exists(nextId)) {
			nextId++;

			if (nextId > maxValue)
				nextId = 0;
		}

		// We can now use this ID
		var id = nextId;
		usedIds.set(id, true);
		return id;
	};

	public function freeID(id:Int) {
		usedIds.remove(id);
	};
}
