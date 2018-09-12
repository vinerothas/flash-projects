package  {
	
	public class Ruler {
		
		public var color:int;
		public var race:String;
		public var regions:Array;
		public var stone:int = 0;
		public var wood:int = 0;
		public var plebeianTax:Number;
		public var treasury:int = 0;
		
		public function Ruler() {
			regions = new Array();
			plebeianTax = 0.02;
		}

	}
	
}
