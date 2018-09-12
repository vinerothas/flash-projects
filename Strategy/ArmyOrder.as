package  {
	import zones.Zone;
	import ui.AttackTrail;
	
	public class ArmyOrder {
		
		public var fromZone:Zone;
		public var toZone:Zone;
		public var armies:Array = new Array();
		public var isAttack:Boolean = true;
		public var attackTrail:AttackTrail;

		public function ArmyOrder() {
			// constructor code
		}

	}
	
}
