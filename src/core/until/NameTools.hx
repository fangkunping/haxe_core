package core.until;

class NameTools {
	/**
	 * [Xxxx Zzzz -> XxxxZzzz]
	 * @param name 
	 */
	static public function formatToCamle(name:String) {
		return name.split(" ").filter(e -> e != "").map(e -> firstToUpper(e)).join("");
	}

	/**
	 * [Xxxx Zzzz -> xxxx_zzzz]
	 * @param name 
	 */
	static public function formatToCamleLow(name:String) {
		return name.split(" ").filter(e -> e != "").map(e -> e.toLowerCase()).join("_");
	}

	/**
	 * [Xxxx Zzzz -> XXXX_ZZZZ]
	 * @param name 
	 */
	static public function formatToCamleUpper(name:String) {
		return name.split(" ").filter(e -> e != "").map(e -> e.toUpperCase()).join("_");
	}

	/**
	 * [Xxxx Zzzz -> xxxx-zzzz]
	 * @param name 
	 */
	static public function formatToMidDash(name:String) {
		return name.split(" ").filter(e -> e != "").map(e -> e.toLowerCase()).join("-");
	}

	static public function firstToUpper(name:String) {
		return name.charAt(0).toUpperCase() + name.substr(1);
	}

	static public function firstToLower(name:String) {
		return name.charAt(0).toLowerCase() + name.substr(1);
	}
}
