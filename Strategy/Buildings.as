package {
	
	public class Buildings{
		
		public var resources:Array = new Array();
		public var army:Array = new Array();
		
		public function Buildings(){
			resources.push(new Building(100,150,200,8,100,"Lumber mill"));
			resources.push(new Building(100,150,200,8,100,"Mine"));
			resources.push(new Building(100,150,200,8,100,"Farm"));
			
			army.push(new Building(100,150,200,8,100,"Archer Camp"));
			army.push(new Building(100,150,200,8,100,"Swordsman Barracks"));	
			army.push(new Building(100,150,200,8,100,"Pikeman Barracks"));
			army.push(new Building(100,150,200,8,100,"Guardian Convent"));
			army.push(new Building(100,150,200,8,100,"Stables"));
		}
		
	}
	
}

	
