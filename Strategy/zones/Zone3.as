package zones{	
	
	public class Zone3 extends Zone {
		
		
		public function Zone3() {
			zoneName = "Zone 3";
			
			var army:Army = new Army();
			army.s[0] = 200;
			army.s[1] = 200;
			army.s[2] = 200;
			army.s[3] = 200;
			army.s[4] = 500;
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
			general.rank = 5;
			general.tactics = 1;
			general.genName = "Some Guy";
			army.general = general;
			army.ruler = ruler;
			armies.push(army);
			
			army = new Army();
			army.s[0] = 200;
			army.s[1] = 150;
			army.s[2] = 400;
			army.s[3] = 300;
			army.s[4] = 150;
			general = new General();
			general.rank = 6;
			general.tactics = 1;
			general.genName = "Best Guy";
			army.general = general;
			army.ruler = ruler;
			armies.push(army);
			
		}
	}
	
}
