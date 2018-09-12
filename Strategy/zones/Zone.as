package zones  {
	
	import flash.display.SimpleButton;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	
	public class Zone extends SimpleButton {
		
		public var zoneName:String;
		 
		public var lastFoodEaten:int = 0;
		public var lastFoodSpoiled:int =0;
		public var lastFoodCollected:int =0;
		public var lastFoodLeft:int = 0;
		public var lastPopBorn:int =0;
		public var lastStarveDeath:int =0;
		public var lastOtherDeath:int =0;
		public var lastSoldiersTrained:int = 0;
		
		public var poplim:int;
		public var plebeians:int;
		public var townspeople:int;
		
		public var farmersPercent:Number;
		public var craftersPercent:Number;
		public var freemenPercent:Number;
		public var buildersPercent:Number;
		public var lumberjackPercent:Number;
		public var minerPercent:Number;
		public var recruitsPercent:Number;
		
		//not needed in AI controlled zones
		public var farmersPriority:Boolean=false;
		public var craftersPriority:Boolean=false;
		public var buildersPriority:Boolean=true;
		public var recruitsPriority:Boolean=true;
		
		public var lumberMills:int;
		public var mines:int;
		public var farms:int;
		public var barracks:Array = new Array();
		public var constructions:Array = new Array();
		
		public var armies:Array = new Array();
		public var garrison:Army = new Army();
		
		public var neighbours:Array = new Array();
		
		public var ruler:Ruler;
		
		public var food:int;
		
		public function Zone() {
			
		}
		
		public function init(main:MovieClip){
			main.addZoneListener(this);
			
			plebeians = 12500+Math.random()*20000;
			poplim = plebeians*(1.5+Math.random());
			food = plebeians*(2+Math.random()*1.5);
			townspeople = (Math.random()*0.1+0.2)*plebeians;
			poplim+=townspeople/2;
			
			//set a random portion of population to crafters
			//number of factories is derived from this
			craftersPercent = Math.random()*0.12+0.12;
			farmersPercent = 1-craftersPercent;		
			var crafters:int = craftersPercent*plebeians;		
			var farmers:int = farmersPercent*plebeians;
			//to remove one offs
			plebeians = crafters+farmers;
			
			//additional plebeians for new player-built buildings
			plebeians+= 2500;
			
			
			craftersPercent = 1;
			farmersPercent = 1;
			buildersPercent = 1;
			recruitsPercent = 1;
			
			lumberjackPercent = 0.5;
			minerPercent = 0.5;
			
			//between 90 and 100% of needed amount for 100% efficiency
			//0.45 to 0.55 of crafters divided by crafters per lumber mill
			var lumberers:int =  crafters*((Math.random()*0.1)+0.45);
			lumberMills = lumberers/Constants.lumberMillCap*((Math.random()*0.1)+0.9);
			//rest of crafters divided by crafters per mine
			mines = (crafters-lumberers)/Constants.mineCap*((Math.random()*0.1)+0.9);			
			//all farmers divided by farmers per farm
			farms = farmers/Constants.farmCap*((Math.random()*0.1)+0.9);
			
			for(var i:int=0;i<5;i++){
				barracks[i]=0;
			}
			for(var j:int=0;j<5;j++){
				var r:int = Math.random()*barracks.length;
				barracks[r]+=1;
			}
		}
		
		public function getSoldiers():int{
			var soldiers:int = 0;
			for each(var army:Army in armies){
				soldiers+=army.getTotal();
			}
			soldiers+=garrison.getTotal();
			return soldiers;
		}
		
		public function getLocalPop():int{
			return plebeians+townspeople;
		}
		
		public function getTotalPop():int{
			return plebeians+townspeople+getSoldiers();
		}
		
		public function addPopulation(p:int){
			//10% to 20% of decrease goes to townspeople
			var ratio:Number = Math.random()*0.1+0.1;
			plebeians+=Math.round(ratio*p);
			townspeople+=Math.round((1-ratio)*p);
		}
		
		public function removePopulation(p:int){
			//10% to 20% of increase goes to townspeople
			var ratio:Number = Math.random()*0.1+0.1;
			plebeians-=Math.round(ratio*p);
			townspeople-=Math.round((1-ratio)*p);
		}
		
		//returning an array is faster than calculatin
		//each type on its own
		public function getPlebeianTypes():Array{	
			//farmers, crafters, builders, recruits, freemen
			var array:Array = new Array();
			array.push(0,0,0,0,0);
			if(plebeians==0){
				return array;
			}
			var maxFarmers:int = maxFarmers();
			var maxCrafters:int = maxCrafters();
			var maxBuilders:int = maxBuilders();
			var maxRecruits:int = maxRecruits();
			//needed total number of plebeians for all types
			var needed:int = farmersPercent*maxFarmers+craftersPercent*maxCrafters+buildersPercent*maxBuilders+recruitsPercent*maxRecruits;
			if(needed<=plebeians){
				//there's enough plebeians, all needed types are there
				array[0] = maxFarmers*farmersPercent;
				array[1] = maxCrafters*craftersPercent;
				array[2] = maxBuilders*buildersPercent;
				array[3] = maxRecruits*recruitsPercent;
				array[4] = plebeians-needed;
			}else{//not enough plebeians
				var neededPriority:int = 0;
				if(farmersPriority)neededPriority+=maxFarmers;
				if(craftersPriority)neededPriority+=maxCrafters;
				if(buildersPriority)neededPriority+=maxBuilders;
				if(recruitsPriority)neededPriority+=maxRecruits;
				if(neededPriority<=plebeians){//enough plebeians to fill priorities
					var rest:int = plebeians-neededPriority
					needed-=neededPriority;
					var ratio:Number = rest/needed;
					if(farmersPriority)array[0] = maxFarmers*farmersPercent;
					else array[0] = ratio*maxFarmers*farmersPercent;
					if(craftersPriority)array[1] = maxCrafters*craftersPercent;
					else array[1] = ratio*maxCrafters*craftersPercent;
					if(buildersPriority)array[2] = maxBuilders*buildersPercent;
					else array[2] = ratio*maxBuilders*buildersPercent;
					if(recruitsPriority)array[3] = maxRecruits*recruitsPercent;
					else array[3] = ratio*maxRecruits*recruitsPercent;
				}else{
					//not enough plebeians to fill priorities
					//fill only priorities
					ratio = plebeians/neededPriority;
					if(farmersPriority)array[0] = ratio*maxFarmers*farmersPercent;
					if(craftersPriority)array[1] = ratio*maxCrafters*craftersPercent;
					if(buildersPriority)array[2] = ratio*maxBuilders*buildersPercent;
					if(recruitsPriority)array[3] = ratio*maxRecruits*recruitsPercent;
				}
			}
			return array;
		}
		
		/*
		public function getFarmers():int{
			//number of farmers
			var farmers:int;
			//farmers cap decided by number of farms
			var max:int = maxFarmers();
			//needed total number of plebeians for all types
			var needed:int = neededPlebeians();
			if(needed<=plebeians){
				//there's enough plebeians, all needed farmers are there
				farmers= farmersPercent*max;
			}else{
				//not enough plebeians
				//percent pop/needed of pop becomes farmers
				var nRatio:Number = plebeians/needed;
				farmers = nRatio*farmersPercent*max;
			}
			return farmers;
		}
		
		//same as farmers
		public function getCrafters():int{
			var crafters:int;
			var max:int = maxCrafters();
			var needed:int = neededPlebeians();
			if(needed<=plebeians){
				crafters= craftersPercent*max;
			}else{
				var nRatio:Number = plebeians/needed;
				crafters = nRatio*craftersPercent*max;
			}
			return crafters;
		}
		
		//same as farmers
		public function getBuilders():int{
			var builders:int = buildersPercent*maxBuilders();
			var max:int = maxBuilders();
			var needed:int = neededPlebeians();
			if(needed<=plebeians){
				builders = buildersPercent*max;
			}else{
				var nRatio:Number = plebeians/needed;
				builders = nRatio*buildersPercent*max;
			}
			return builders;
		}
		*/
		
		public function getBuilders():int{
			return getPlebeianTypes()[2];
		}
		
		//freemen left over after filling all other plebeian types
		public function getFreemen():int{
			var freemen:int = getPlebeianTypes()[4];
			return freemen;
		}
		
		public function neededPlebeians():int{
			return  farmersPercent*maxFarmers()+craftersPercent*maxCrafters()+buildersPercent*maxBuilders();
		}
		
		public function maxFarmers():int{
			return farms*Constants.farmCap;
		}
		
		public function maxCrafters():int{
			return lumberMills*Constants.lumberMillCap+mines*Constants.mineCap;
		}
		
		public function maxBuilders():int{
			var builders:int = 0;
			for each(var building:Object in constructions){
				builders+=building.builders;
			}
			return builders;
		}
		
		public function maxRecruits():int{
			var recruits:int = 0;
			for each(var b:int in barracks){
				recruits+=b*Constants.barracksCap;
			}
			return recruits;
		}
		
		public function getLumberjacks(crafters:int):int{
			var cap:int = lumberMills*Constants.lumberMillCap;
			if(crafters==maxCrafters()){
				return cap;//enough crafters for all factories
			}else{//not enough crafters for all factories
				var lumberjacks:int = lumberjackPercent*crafters;
				if(lumberjacks>=cap){//all lumber mills filled
					return cap;
				}else{//not all lumber mills filled
					var cap2:int = mines*Constants.mineCap;
					if(crafters-lumberjacks>cap2){//mines filled
						return crafters-cap2;
					}else{//not all mines filled
						return lumberjacks;
					}
				}
			}
		}
		
		public function getMiners(crafters:int):int{
			var miners:int = crafters-getLumberjacks(crafters);
			return miners;
		}
		
		public function addBuilding(id:int){
			//relative to Buildings class
			if(id==0)lumberMills++;
			else if(id==1)mines++;
			else if(id==2)farms++;
		}
	}
	
}