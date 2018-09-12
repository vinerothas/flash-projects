package ui {
	
	import flash.display.MovieClip;
	import zones.Zone;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class AttackFrame extends ActiveFrame {
		
		var attackingZone:Zone;
		var enemyZone:Zone;
		var loupeButtons:Array = new Array();
		var zone1x:int = 490;
		var zoneY:int = 70;
		var zone2x:int = 665;
		var chosenArmies:Array = new Array();
		var chosenSoldierFields:SoldierFields;
		var noSoldiersField:SimpleTextField;
		var ticks:Array = new Array();
		var ordered:Boolean = false;
		var confirmationWindow:ConfirmationWindow;
		var busyArmies:Array = new Array();
		
		var orgZoneX:int;
		var orgZoneY:int;
		var orgZoneX2:int;
		var orgZoneY2:int;		
		
		public function AttackFrame(uI:UI,attackingZone:Zone,enemyZone:Zone) {
			super(uI,null);
			exitButton.visible = false;		
			
			cancelButton.addEventListener(MouseEvent.CLICK,exitFrame);
			attackButton.addEventListener(MouseEvent.CLICK,confirmAttack);
			cancelButton.setText("Cancel");
			attackButton.setText("Attack");
			
			this.attackingZone = attackingZone;
			this.enemyZone = enemyZone;	
			attackingZone.mouseEnabled = false;
			enemyZone.mouseEnabled = false;
			
			//display zones
			addChild(attackingZone);
			orgZoneX = attackingZone.x;
			attackingZone.x = zone1x;
			orgZoneY = attackingZone.y;
			attackingZone.y = zoneY;
			addChild(enemyZone);
			orgZoneX2 = enemyZone.x;
			enemyZone.x = zone2x;
			orgZoneY2 = enemyZone.y;
			enemyZone.y = zoneY;		
			var attackTrail:AttackTrail = new AttackTrail();
			var x1:int = attackingZone.x+attackingZone.width/2+5;
			var x2:int = enemyZone.x-enemyZone.width/2;
			attackTrail.init(x1,attackingZone.y,x2,enemyZone.y);
			addChild(attackTrail);
			//print out zone names
			var sy:int = 130;
			stf = new SimpleTextField();
			stf.y = sy;
			stf.x = zone1x-30;
			stf.field.width = 300;
			stf.field.text = attackingZone.zoneName;
			addChild(stf);
			stf = new SimpleTextField();
			stf.y = sy;
			stf.x = zone2x-30;
			stf.field.width = 300;
			stf.field.text = enemyZone.zoneName;
			addChild(stf);
			
			//name the stationing enemy generals		
			sy = 195;
			if(enemyZone.garrison.general!=null){
				stf = new SimpleTextField();
				stf.y = sy;
				stf.x = 500;
				stf.field.width = 300;
				stf.field.text = enemyZone.garrison.general.getFullTitle();
				addChild(stf);
				sy +=  stf.height;
			}
			for each (var army:Army in enemyZone.armies) {
				stf = new SimpleTextField();
				stf.y = sy;
				stf.x = 500;
				stf.field.width = 300;
				stf.field.text = army.general.getFullTitle();
				addChild(stf);
				sy +=  stf.height;
			}			
			//enemy armies
			var sf:SoldierFields = new SoldierFields();
			var enemyArmies:Array = new Array();
			for each(var a:Army in enemyZone.armies){
				enemyArmies.push(a);
			}
			enemyArmies.push(enemyZone.garrison);
			sf.initArmies(enemyArmies);
			sf.x = 500;
			sf.y = sy;
			addChild(sf);		
			
			//add the armies stationing in attackingZone;
			var armyEntry:MovieClip;
			var armyEntries:Array = new Array();
			var stf:SimpleTextField;
			sy = 52;
			for each (army in attackingZone.armies) {
				armyEntry = new MovieClip();
				stf = new SimpleTextField();
				stf.y = sy;
				stf.x = 52;
				stf.field.width = 400;
				stf.field.text = "Army of " + army.general.getFullTitle() + ", " + army.getTotal() + " soldiers";
				armyEntry.addChild(stf);
				sy +=  stf.height;

				//init the button for viewing the army
				var loupeButton:LoupeButton = new LoupeButton();
				loupeButton.x = 30;
				loupeButton.y = sy - 22;
				loupeButton.width = 20;
				loupeButton.height = 20;
				armyEntry.addChild(loupeButton);
				loupeButtons.push(loupeButton);
				loupeButton.addEventListener(MouseEvent.CLICK,viewArmy);

				var tickButton:TickButton = new TickButton();
				tickButton.x = 8;
				tickButton.y = sy - 22;
				tickButton.width = 20;
				tickButton.height = 20;
				armyEntry.addChild(tickButton);
				tickButton.id = attackingZone.armies.indexOf(army);
				ticks.push(tickButton);
				tickButton.addEventListener(MouseEvent.CLICK,pressTick);		
				armyEntries.push(armyEntry);
			}
			if(attackingZone.armies.length == 0){	
				stf = new SimpleTextField();
				stf.y = sy;
				stf.x = 10;
				stf.field.width = 360;
				stf.field.text = "There are no stationing armies in this region";
				addChild(stf);
			}else{
				addChild(new ScrollingMenu(armyEntries,7,175,58,210));
			}
			//init chosen troops
			displayChosenTroops();
			
		}
		
		//checks if there are already orders concerning this attak
		public function checkOrders(orders:Array){
			var army:Army;
			//trace(" ");
			//trace("orders length "+orders.length);
			var orderToRemove:ArmyOrder = null;
			for each(var order:ArmyOrder in orders){
				//trace("from "+order.fromZone.zoneName+" to "+order.toZone.zoneName);
				if(order.fromZone==attackingZone){
					if(order.toZone==enemyZone){
						//related order found
						//trace("related order "+"from "+order.fromZone.zoneName+" to "+order.toZone.zoneName);
						ordered = true;
						orderToRemove = order;
						for each(army in order.armies){
							//tick the army that's already have been picked to fight
							ticks[attackingZone.armies.indexOf(army)].pressTick();
							chosenArmies.push(army);
						}
						uI.main.removeChild(order.attackTrail);
					}else{
						for each(army in order.armies){
							//trace("tick index "+attackingZone.armies.indexOf(army));
							//trace(ticks[attackingZone.armies.indexOf(army)].pressed);
							var tickButton:TickButton = ticks[attackingZone.armies.indexOf(army)];
							tickButton.mouseoverOff();
							busyArmies.push(army);
						}
					}
				}
			}
			if(orderToRemove!=null){
				orders.splice(orders.indexOf(orderToRemove),1);
				//trace("remove "+"from "+orderToRemove.fromZone.zoneName+" to "+orderToRemove.toZone.zoneName);
			}
			displayChosenTroops();
		}
		
		//go to ArmyDetailsFrame to show details of the picked army;
		public function viewArmy(evt:Event) {
			uI.main.removeChild(this);
			var armyDetailsFrame:ArmyDetailsFrame;
			for (var i:int=0; i<loupeButtons.length; i++) {
				if (evt.target == loupeButtons[i]) {
					armyDetailsFrame = new ArmyDetailsFrame(uI,this,attackingZone.armies[i]);
				}
			}
			uI.main.addChild(armyDetailsFrame);
			armyDetailsFrame.exitButton.visible = false;
			armyDetailsFrame.infoButton.visible = false;
			armyDetailsFrame.armyButton.visible = false;
			armyDetailsFrame.buildButton.visible = false;
			armyDetailsFrame.backButton.x+=armyDetailsFrame.backButton.width;
			
		}
		
		public function displayChosenTroops(){
			if(chosenSoldierFields!=null){
				if(this.contains(chosenSoldierFields)){
					removeChild(chosenSoldierFields);
				}
			}
			if(noSoldiersField!=null){
				if(this.contains(noSoldiersField)){
					removeChild(noSoldiersField);
				}
			}
			chosenSoldierFields = new SoldierFields();
			chosenSoldierFields.initArmies(chosenArmies);
			if(chosenArmies.length==0){
				noSoldiersField = new SimpleTextField();
				noSoldiersField.x = 95;
				noSoldiersField.y = 255;
				noSoldiersField.field.width = 100;
				noSoldiersField.field.text = "None";
				addChild(noSoldiersField);
			}
			chosenSoldierFields.x = 95;
			//chosen troops textField + 35
			chosenSoldierFields.y = 255;
			addChild(chosenSoldierFields);
		}
		
		public function pressTick(evt:Event) {
			var tick:TickButton = TickButton(evt.target);
			//used for making the ticks for busy armies not being pressed
			var taken:Boolean = false;
			if(!tick.pressed){
				//if chosen army isn't already in another order
				if(busyArmies.indexOf(attackingZone.armies[tick.id])==-1){
					chosenArmies.push(attackingZone.armies[tick.id]);
					//trace("push");
				}else{
					taken = true;
					confirmationWindow = new ConfirmationWindow();
					addChild(confirmationWindow);
					confirmationWindow.initInfo("This army already has other orders.");
					confirmationWindow.okButton.addEventListener(MouseEvent.CLICK,confBack);
					confirmationWindow.placeMiddle();
					//trace("taken");
				}
			}else{		
				//if tick is already pressed, remove the army corresponding to the tick from chosenArmies
				chosenArmies.splice(chosenArmies.indexOf(attackingZone.armies[tick.id]),1);
				//trace("splice");
			}
			if(!taken)tick.pressTick();
			displayChosenTroops();
		}
		
		public function confirmAttack(evt:Event){
			if(confirmationWindow!=null)return;
			if(chosenArmies.length==0){
				confirmationWindow = new ConfirmationWindow();
				addChild(confirmationWindow);
				confirmationWindow.placeMiddle();
				confirmationWindow.initInfo("You haven't chosen any armies to attack.");
				confirmationWindow.okButton.addEventListener(MouseEvent.CLICK,confBack);
				return;
			}
			var armyOrder:ArmyOrder = new ArmyOrder();
			armyOrder.fromZone = attackingZone;
			armyOrder.toZone = enemyZone;
			armyOrder.armies = chosenArmies;
			armyOrder.isAttack = true;
			armyOrder.attackTrail = new AttackTrail();
			armyOrder.attackTrail.init(orgZoneX,orgZoneY,orgZoneX2,orgZoneY2);
			uI.main.armyOrders.push(armyOrder);
			uI.main.addChild(armyOrder.attackTrail);
			
			ordered = false;
			exitFrame(evt);
		}
		
		override public function exitFrame(evt:Event){
			if(confirmationWindow!=null)return;
			if(ordered){
				confirmationWindow = new ConfirmationWindow();
				addChild(confirmationWindow);
				confirmationWindow.placeMiddle();
				confirmationWindow.initYN("Do you want to cancel the attack?");
				confirmationWindow.yesButton.addEventListener(MouseEvent.CLICK,confCancel);
				confirmationWindow.noButton.addEventListener(MouseEvent.CLICK,confBack);
				return;
			}
			//free the zone and put it back on the world map
			attackingZone.x = orgZoneX;
			attackingZone.y = orgZoneY;
			enemyZone.x = orgZoneX2;
			enemyZone.y = orgZoneY2;
			attackingZone.mouseEnabled = true;
			enemyZone.mouseEnabled = true;
			super.exitFrame(evt);
			uI.main.addChildAt(attackingZone,1);
			uI.main.addChildAt(enemyZone,1);
		}
		
		public function confCancel(evt:Event){
			ordered = false;
			confirmationWindow = null;
			exitFrame(evt);
		}
		
		public function confBack(evt:Event){
			removeChild(confirmationWindow);
			confirmationWindow = null;
		}
		
	}
	
}
