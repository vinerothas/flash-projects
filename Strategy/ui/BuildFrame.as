package ui {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;	
	import zones.Zone;
	
	public class BuildFrame extends ZoneFrame {
		
		//list containing all the buildable builidings
		public var buildingsList:Buildings = new Buildings();
		//saves the buttons created for each buildable building
		//the crucial part is the position "i" in the array 
		//which corresponds to the correct building in the building list
		public var buildingButtons:Array = new Array();
		//used for adding new entries to the construction list
		public var lastCy:int;
		//fields where the ongoing constructions are printed out
		public var constructionFields:Array = new Array();
		public var mode:String = "resources";
		public var buildingFields:Array = new Array();
		public var buildings:Array;
		public var zone:Zone;
		var constructionsMenu:ScrollingMenu;
		var smx:int = 648;
		var smy:int = 92;
		var smy2:int = 405;
		
		public function BuildFrame(uI:UI,previousFrame:ActiveFrame) {
			super(uI,previousFrame);
			zone = uI.pickedZone;
		}
		
		public function init(){
			barracksButton.addEventListener(MouseEvent.CLICK,changeMode);
			resourcesButton.addEventListener(MouseEvent.CLICK,changeMode);
			
			buildings = buildingsList.resources;
				
			//fill dominions resources fields
			woodField.text = String(zone.ruler.wood);
			stoneField.text = String(zone.ruler.stone);
			treasuryField.text = String(zone.ruler.treasury);
			
			printOutBuildable();
			
			//print out ongoing constructions
			var constructions:Array = zone.constructions;
			var cx:int = currentConstructions.x;
			var cy:int = currentConstructions.y+currentConstructions.height;
			for each(var construction:Object in constructions){
				var currentConst:CurrentConstFields = new CurrentConstFields();
				currentConst.nameField.text = String(construction.buildingName);
				//currentConst.timeField.text = String(Math.ceil(construction.time));
				currentConst.x = cx;
				currentConst.y = cy;
				cy+=currentConst.height;	
				constructionFields.push(currentConst);
			}
			constructionsMenu = new ScrollingMenu(constructionFields,13,smx,smy,smy2);
			addChild(constructionsMenu);
			lastCy = cy;
			updateBuilders();
		}
		
		public function addConstruction(evt:Event){
			var i:int = 0;
			var wood:int;
			var stone:int;
			var money:int;
			//find building corresponding to the button in the building list
			for(0;i<buildingButtons.length;i++){
				if(buildingButtons[i]==evt.target){
					//constructions resource needs
					wood = buildings[i].wood;
					stone = buildings[i].stone;
					money = buildings[i].money;
					
					//check if the ruler has enough resources
					if(zone.ruler.wood<wood ||
					   zone.ruler.stone<stone ||
					   zone.ruler.treasury<money){
						   return;
					}
					   
					//add the construction to zones construction list
					//save buildingName, buildID, time left and builders limit
					zone.constructions.push({
									buildingName:buildings[i].buildingName,
									builders:buildings[i].builders,
									time:buildings[i].time,
									id:i
															});
					break;
				}
			}
			//update dominions resources
			zone.ruler.wood-=wood;
			zone.ruler.stone-=stone;
			zone.ruler.treasury-=money;		
			woodField.text = String(zone.ruler.wood);
			stoneField.text = String(zone.ruler.stone);
			treasuryField.text = String(zone.ruler.treasury);
			
			//add entry to the construction list
			var currentConst:CurrentConstFields = new CurrentConstFields();
			currentConst.nameField.text = buildings[i].buildingName;
			//currentConst.timeField.text = String(Math.ceil(buildingsList.buildings[i].time));
			currentConst.x = currentConstructions.x;;
			currentConst.y = lastCy;
			lastCy+=currentConst.height;
			constructionFields.push(currentConst);	
			
			removeChild(constructionsMenu);
			constructionsMenu = new ScrollingMenu(constructionFields,13,smx,smy,smy2);
			addChild(constructionsMenu);
			
			updateBuilders();
		}
		
		//fill out builders field for each ongoing construction
		//and calculet time left with given number of builders
		public function updateBuilders(){
			var builders:int = zone.getBuilders();
			for(var i:int;i<constructionFields.length;i++){
				var constructionField:CurrentConstFields = constructionFields[i];
				var usedBuilders:int = 0;
				var buildersLim:int = zone.constructions[i].builders;
				if(buildersLim<=builders){
					usedBuilders = buildersLim;
				}else if(builders>0){
					usedBuilders = builders;
				}
				builders-=usedBuilders;
				if(usedBuilders>0){
					var bRatio:Number = usedBuilders/buildersLim;
					var timeLeft:int = Math.ceil(zone.constructions[i].time/bRatio);
					constructionField.timeField.text = String(timeLeft);
				}else{		
					constructionField.timeField.text = "-";
				}
				constructionField.buildersField.text = String(usedBuilders)+"/"+String(buildersLim);
			}
			
		}
		
		//print out the list of buildable buildings
		public function printOutBuildable(){
			for each(var f:ConstructionFields in buildingFields){
				removeChild(f);
			}
			buildingFields = new Array();
			
			for each(var b:BuildButton in buildingButtons){
				b.removeEventListener(MouseEvent.CLICK,addConstruction);
				removeChild(b);
			}
			buildingButtons = new Array();
			
			var cx:int = 0;
			var cy:int = resources.y+resources.height;
			for each(var building:Building in buildings){
				new ConstructionFields();
				var cField:ConstructionFields = new ConstructionFields();
				cField.nameField.text = String(building.buildingName);
				if(building.buildingName.length>15){
					var format:TextFormat = new TextFormat();
					format.size = 16;
					cField.nameField.y+=1;
					if(building.buildingName.length>17){
						format.size = 14;
						cField.nameField.y+=1;
					}
					cField.nameField.setTextFormat(format);
				}
				cField.woodField.text = String(building.wood);
				cField.stoneField.text = String(building.stone);
				cField.moneyField.text = String(building.money);
				cField.buildersField.text = String(building.builders);
				cField.timeField.text = String(building.time);
				cField.x = cx;
				cField.y = cy;
				cy+=cField.height;
				addChild(cField);
				buildingFields.push(cField);
				
				//init the button for initializing construction
				var buildButton:BuildButton = new BuildButton();
				buildButton.x = cx+cField.width+2;
				buildButton.y = cy-23;
				buildButton.width = 20;
				buildButton.height = 20;
				addChild(buildButton);
				buildingButtons.push(buildButton);
				buildButton.addEventListener(MouseEvent.CLICK,addConstruction);
			}
		}
		
		public function changeMode(evt:Event){
			if(evt.target==barracksButton){
				buildings = buildingsList.army;
			}else if(evt.target==resourcesButton){
				buildings = buildingsList.resources;
			}
			printOutBuildable();
		}
		
	}
	
}
