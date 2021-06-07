package core.until;

class ArrayTools {
    static public function one<T>(lists:Array<T>):T {
		if (lists.length == 1){
			return lists[0];
		}
		return null;
	}
	static public function first<T>(lists:Array<T>):T {
		if (lists.length > 0){
			return lists[0];
		}
		return null;
	}
	static public function last<T>(lists:Array<T>):T {
		if (lists.length > 0){
			return lists[lists.length-1];
		}
		return null;
	}
}