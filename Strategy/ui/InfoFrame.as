package ui {
	
	import flash.display.MovieClip;
	import zones.Zone;
	import flash.events.Event;
	import fl.events.SliderEvent;
	import flash.events.MouseEvent;
	
	public class InfoFrame extends ZoneFrame {
		
		//screen position of viewed zone
		public var zoneX:int = 116;
		public var zoneY:int = 120;
		//values needed to put the zone back on the world map
		public var orgZoneX:int;
		public var orgZoneY:int;
		public var pickedZone:Zone;
		
		var freemen:int;
		var farmers:int;
		var crafters:int;
		var builders:int;
		var recruits:int;
		var miners:int;
		var lumberjacks:int;
		
		public function InfoFrame(zone:Zone,uI:UI,previousFrame:ActiveFrame) {
			super(uI,previousFrame);
			pickedZone = zone;
		}
		
		public function init(){
			//values needed to put the zone back on the world map
			orgZoneX = pickedZone.x;
			orgZoneY = pickedZone.y;
			//place the zone on info screen
			pickedZone.x = zoneX;
			pickedZone.y = zoneY;
			pickedZone.mouseEnabled = false;
			addChild(pickedZone);
			
			updatePlebeianFields();
			
			//fill the fields with data
			
			nameField.text = pickedZone.zoneName;
			rulerField.text = pickedZone.ruler.race;
			popField.text = String(pickedZone.getLocalPop());
			plebField.text = String(pickedZone.plebeians);
			soldiersField.text = String(pickedZone.getSoldiers());
			townspeopleField.text = String(pickedZone.townspeople);
			foodField.text = String(pickedZone.food);
			
			//last week
			foodCollected.text = String(pickedZone.lastFoodCollected);
			foodSpoiled.text = String(pickedZone.lastFoodSpoiled);
			foodLeft.text = String(pickedZone.lastFoodLeft);
			foodEaten.text = String(pickedZone.lastFoodEaten);
			popBorn.text = String(pickedZone.lastPopBorn);
			starveDeath.text = String(pickedZone.lastStarveDeath);
			otherDeath.text = String(pickedZone.lastOtherDeath);
			soldiersTrained.text = String(pickedZone.lastSoldiersTrained);
			
			//industry
			minesField.text = String(pickedZone.mines);
			lumberMillsField.text = String(pickedZone.lumberMills);
			farmsField.text = String(pickedZone.farms);
			
			//dominion
			woodField.text = String(pickedZone.ruler.wood);
			stoneField.text = String(pickedZone.ruler.stone);
			treasuryField.text = String(pickedZone.ruler.treasury);
			
			//init sliders
			craftersSlider.addEventListener(SliderEvent.THUMB_DRAG, changeCraftersSlider);
			craftersSlider.value = pickedZone.craftersPercent*100;
			
			farmersSlider.addEventListener(SliderEvent.THUMB_DRAG, changeFarmersSlider);
			farmersSlider.value = pickedZone.farmersPercent*100;
			
			buildersSlider.addEventListener(SliderEvent.THUMB_DRAG, changeBuildersSlider);
			buildersSlider.value = pickedZone.buildersPercent*100;
			
			recruitsSlider.addEventListener(SliderEvent.THUMB_DRAG, changeRecruitsSlider);
			recruitsSlider.value = pickedZone.recruitsPercent*100;
			
			farmersTick.addEventListener(MouseEvent.CLICK, pressTick);
			if(pickedZone.farmersPriority)farmersTick.pressTick();
			craftersTick.addEventListener(MouseEvent.CLICK, pressTick);
			if(pickedZone.craftersPriority)craftersTick.pressTick();
			buildersTick.addEventListener(MouseEvent.CLICK, pressTick);
			if(pickedZone.buildersPriority)buildersTick.pressTick();
			recruitsTick.addEventListener(MouseEvent.CLICK, pressTick);
			if(pickedZone.recruitsPriority)recruitsTick.pressTick();
			
			jobSlider.addEventListener(SliderEvent.THUMB_DRAG, changeJobSlider);
			jobSlider.value = pickedZone.lumberjackPercent*100;
		}
		
		public function pressTick(evt:Event){
			if(evt.target==farmersTick)pickedZone.farmersPriority=!pickedZone.farmersPriority;
			else if(evt.target==craftersTick)pickedZone.craftersPriority=!pickedZone.craftersPriority;
			else if(evt.target==buildersTick)pickedZone.buildersPriority=!pickedZone.buildersPriority;
			else if(evt.target==recruitsTick)pickedZone.recruitsPriority=!pickedZone.recruitsPriority;
			evt.target.pressTick();
			
			updatePlebeianFields();
		}
		
		public function changeCraftersSlider(evt:Event){	
			pickedZone.craftersPercent = craftersSlider.value/100;
			updatePlebeianFields();
		}
		
		public function changeFarmersSlider(evt:Event){	
			pickedZone.farmersPercent = farmersSlider.value/100;
			updatePlebeianFields();
		}
		
		public function changeBuildersSlider(evt:Event){	
			pickedZone.buildersPercent = buildersSlider.value/100;
			updatePlebeianFields();
		}
		
		public function changeRecruitsSlider(evt:Event){	
			pickedZone.recruitsPercent = recruitsSlider.value/100;
			updatePlebeianFields();
		}
		
		public function changeJobSlider(evt:Event){	
			pickedZone.lumberjackPercent = jobSlider.value/100;	
			pickedZone.minerPercent = jobSlider.value/100;
			lumberjacks = pickedZone.getLumberjacks(crafters);
			miners = crafters-lumberjacks;
			lumberjacksField.text = String(lumberjacks);
			minersField.text = String(miners);
		}
		
		//fill the dynamic fields and update plebeian variables
		public function updatePlebeianFields(){
			var array:Array = pickedZone.getPlebeianTypes();
			freemen =  array[4];
			farmers = array[0];
			crafters =  array[1];
			builders = array[2];
			recruits = array[3];
			lumberjacks = pickedZone.getLumberjacks(crafters);
			miners = crafters-lumberjacks;
			
			freemenField.text = String(freemen);
			farmersField.text = String(farmers);
			craftersField.text = String(crafters);
			buildersField.text = String(builders);
			recruitsField.text = String(recruits);
			lumberjacksField.text = String(lumberjacks);
			minersField.text = String(miners);
			calculateStarvationChance(farmers,freemen);
		}
		
		public function calculateStarvationChance(farmers:int,freemen:int){
			var foodMinIncrease:Number = Constants.foodMinIncrease;
			var foodMaxIncrease:Number = Constants.foodMaxIncrease;
			var min:int = foodMinIncrease*(farmers+freemen*Constants.foodFreemanFactor);
			var max:int = foodMaxIncrease*(farmers+freemen*Constants.foodFreemanFactor);
			var pop:int = pickedZone.getTotalPop();
			var foodNeeded:int = pop-pickedZone.food;
			var chance:Number;
			if(foodNeeded<0)chance = 0;
			else if(max==0)chance = 1;
			else chance =(foodNeeded-min)/(max-min);
			if(chance<=0){
				starvChanceText.text = "No chance of starvation";
			}else if(chance<0.1){
				starvChanceText.text = "Low chance of starvation";
			}else if(chance<0.3){
				starvChanceText.text = "Moderate chance of starvation";
			}else{
				starvChanceText.text = "High chance of starvation";
			}
			//trace(chance);
		}
		
		override public function exitFrame(evt:Event){
			//free the zone and put it back on the world map
			pickedZone.x = orgZoneX;
			pickedZone.y = orgZoneY;
			pickedZone.mouseEnabled = true;
			super.exitFrame(evt);
			uI.main.addChildAt(pickedZone,1);
		}
	}
	
}
