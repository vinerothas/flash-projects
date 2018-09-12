package  {
	
	public class Army {
		
		//archer warrior spearman defender horseman
		//soldiers
		public var s:Array = new Array();
		public var ruler:Ruler;
		public var general:General;

		public function Army() {
			for(var i:int = 0;i<5;i++){
				s[i] = 0;
			}
		}
		
		public function getTotal(){
			var a:int = 0;
			for each(var i:int in s){
					 a+=i;
			}
			return a;
		}
		
		public function addToArmy(troops:Array){
			for(var i:int=0;i<s.length;i++){
					s[i]+=troops[i];
			}
		}
		
		public function removeFromArmy(troops:Array){
			for(var i:int=0;i<s.length;i++){
					s[i]-=troops[i];
			}
		}
		
		public function removeTotal(dead:int){
			var total:int = getTotal();
			if(dead==0||total==0)return;
			var died:int = 0;
			for(var i:int=0;i<s.length;i++){
					if(s[i]==0)continue;
					var deadType:int = (s[i]/total*dead)+Math.round(Math.random()*10-5);
					died+=deadType;
					s[i]-=deadType;
					if(s[i]<0){
						s[i]=0;
					}
			}
			//trace(died+"/"+dead);
		}
		
	}
	
}
