package zones {
	
	public class Zone1 extends Zone {
		
		
		public function Zone1() {
			zoneName = "Zone 1";
			
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
			army.s[1] = 300;
			army.s[2] = 200;
			army.s[3] = 200;
			army.s[4] = 150;
			general = new General();
			general.rank = 4;
			general.tactics = 1;
			general.genName = "Other Guy";
			army.general = general;
			army.ruler = ruler;
			armies.push(army);
			
			army = new Army();
			army.s[0] = 150;
			army.s[1] = 200;
			army.s[2] = 100;
			army.s[3] = 300;
			army.s[4] = 250;
			general = new General();
			general.rank = 3;
			general.tactics = 1;
			general.genName = "Another Guy";
			army.general = general;
			army.ruler = ruler;
			armies.push(army);
		}
	}
	
}
