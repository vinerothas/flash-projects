package ui{

	import flash.display.MovieClip;


	public class SoldierFields extends MovieClip {


		public function SoldierFields() {
			// constructor code
		}
		
		public function initArmies(armies:Array) {
			var army:Army = new Army();
			for each(var a:Army in armies){
				army.addToArmy(a.s);
			}
			init(army);
		}

		//skip soldiers types that there's 0 of
		public function init(army:Army) {
			var sy:int = 0;
			var stf:SimpleTextField;
			var st:Array = new Array();
			/*
			st.push("Archers","Longbowmen","Marksmen","Warriors","Swordsmen","Champions",
					"Spearmen","Pikemen","Halabardiers","Squires","Guardians","Templars",
					"Riders","Horsemen","Knight");
			*/
			st.push("Archers","Swordsmen","Pikemen","Guardians","Horsemen");
			for(var i:int = 0;i<st.length;i++){
				stf = new SimpleTextField();
				if(army.s[i]==0){
					continue;
				}
				stf.field.text = st[i]+": " + String(army.s[i]);
				stf.field.width = 150;
				stf.y = sy;
				sy +=  stf.height;
				addChild(stf);
			}
		}
		
		//don't skip soldiers types that there's 0 of
		public function initAll(army:Army) {
			var sy:int = 0;
			var stf:SimpleTextField;
			var st:Array = new Array();
			st.push("Archers","Swordsmen","Pikemen","Guardians","Horsemen");
			for(var i:int = 0;i<st.length;i++){
				stf = new SimpleTextField();
				stf.field.text = st[i]+": " + String(army.s[i]);
				stf.field.width = 150;
				stf.y = sy;
				sy +=  stf.height;
				addChild(stf);
			}
		}
	}

}