package ui {
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	
	public class ArmyDetailsFrame extends ZoneFrame {
		
		public var army:Army;
		
		public function ArmyDetailsFrame(uI:UI,previousFrame:ActiveFrame,army:Army) {		
			super(uI,previousFrame);
			
			this.army = army;
			
			generalField.text = "Army of "+army.general.getFullTitle();

			var soldierFields:SoldierFields = new SoldierFields();
			soldierFields.x = 30;
			soldierFields.y = 65;
			soldierFields.init(army);
			addChild(soldierFields);
		}
		
	}
	
}
