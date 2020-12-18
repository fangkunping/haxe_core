package core.emu;

import haxe.macro.Expr;
import haxe.macro.Context;

using haxe.macro.ExprTools;
using haxe.macro.MacroStringTools;

class Pipe {
	public static macro function pipeOperator(exprs:Array<Expr>) {
		var exprs = [for (expr in exprs) macro var _ = $expr];
		exprs.push(macro _);
		return macro $b{exprs};
	}
}
