package {
	
	public class Constants{
		
		public static var foodMaxIncrease:Number = 2.10;
		public static var foodMinIncrease:Number = 1.45;
		public static var foodFreemanFactor:Number = 0.25;
		public static var lumberMillCap:int = 200;
		public static var mineCap:int = 350;
		public static var farmCap:int = 500;
		public static var barracksCap:int = 50;
		public static var stonePerCrafter:Number = 0.1;
		public static var woodPerCrafter:Number = 0.1;
		public static var soldierWages:Number = 0.01;
		
		public static var lieutenantAmount:int = 500;
		public static var captainAmount:int = 1000;
		public static var majorAmount:int = 1500;
		public static var colonelAmount:int = 2500;
		public static var generalAmount:int = 4000;
		public static var hetmanAmount:int = 5500;
		public static var marshalAmount:int = 7500;
		public static var warlordAmount:int = 10000;
		
		public static var archerid: int = 0;
		public static var swordsmanid: int = 1;
		public static var pikemanid: int = 2;
		public static var guardianid: int = 3;
		public static var horsemanid: int = 4;
		
		//1 soldier takes on average 10 weeks to train
		public static var soldierInc:Number = 0.1;
		
		public function Constants(){
			
		}
		
		public static function getRank(rank:int):String{
			if(rank==1)return "Lieutenant";
			else if(rank==2)return "Captain";
			else if(rank==3)return "Major";
			else if(rank==4)return "Colonel";
			else if(rank==5)return "General";
			else if(rank==6)return "Hetman";
			else if(rank==7)return "Marshal";
			else if(rank==8)return "Warlord";
			return "";
		}
		
	}
}