package zones {
	
	public class Zone4 extends Zone {
		
		
		public function Zone4() {
			zoneName = "Zone 4";
			
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
			army.s[0] = Math.round(100+Math.random()*300);
			army.s[1] = Math.round(100+Math.random()*300);
			army.s[2] = Math.round(100+Math.random()*300);
			army.s[3] = Math.round(100+Math.random()*300);
			army.s[4] = Math.round(100+Math.random()*300);
			general = new General();
			general.rank = 5;
			general.tactics = 1;
			general.genName = "Only Guy";
			army.general = general;
			army.ruler = ruler;
			armies.push(army);
		}
	}
	
}
