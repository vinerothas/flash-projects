﻿package zones {
	
	public class Zone6 extends Zone {
		
		
		public function Zone6() {
			zoneName = "Zone 6";
			
			var army:Army = new Army();
			army.s[0] = 200;
			army.s[1] = 200;
			army.s[2] = 200;
			army.s[3] = 200;
			army.s[4] = 200;
			var general:General = new General();
			general.rank = 4;
			general.tactics = 1;
			general.genName = "Guy";
			army.general = general;
			army.ruler = ruler;
			garrison = army;
			
			army = new Army();
			army.s[0] = 250;
			army.s[1] = 150;
			army.s[2] = 200;
			army.s[3] = 200;
			army.s[4] = 150;
			general = new General();
			general.rank = 5;
			general.tactics = 1;
			general.genName = "Enemy Guy";
			army.general = general;
			army.ruler = ruler;
			armies.push(army);
		}
	}
	
}
