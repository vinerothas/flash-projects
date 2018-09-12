package  {
	
	public class General {
		
		//amount that the general can command
		public var rank:int;
		//military skill
		public var tactics:int;
		public var genName:String;

		public function General() {
			// constructor code
		}
		
		public function getRank():String{
			return Constants.getRank(rank);
		}
		
		public function getFullTitle():String{
			return getRank()+" "+genName;
		}
	}
	
}
