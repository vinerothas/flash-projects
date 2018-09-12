package ui{

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.text.TextFormatAlign;
	import flash.text.TextFormat;

	public class ArmyFrame extends ZoneFrame {

		var loupeButtons:Array = new Array();
		var tickButtons:Array = new Array();
		var pressedTicks:Array = new Array();
		var shuffleOn:Boolean = false;

		public function ArmyFrame(uI:UI,previousFrame:ActiveFrame) {
			super(uI,previousFrame);
		}

		public function init() {
			
			//init the top army text
			armyField.text = "Armies in "+uI.pickedZone.zoneName;

			var refPointY:int = 65;
			//init garrison commander text field
			var stf:SimpleTextField = new SimpleTextField();
			stf.y = refPointY;
			stf.x = 460;
			stf.field.width = 350;
			stf.field.text = "Garrison Commander: " + uI.pickedZone.garrison.general.getFullTitle();
			addChild(stf);

			//init garrison soldiers fields
			var soldierFields:SoldierFields = new SoldierFields();
			soldierFields.x = 530;
			soldierFields.y = stf.y + stf.height;
			soldierFields.init(uI.pickedZone.garrison);
			addChild(soldierFields);

			//add garrison to the list of stationing armies
			var sy:int = refPointY;
			stf = new SimpleTextField();
			stf.y = sy;
			stf.x = 30;
			stf.field.width = 350;
			stf.field.text = "Garrison of " + uI.pickedZone.garrison.general.getFullTitle() + ", " + uI.pickedZone.garrison.getTotal() + " soldiers";
			addChild(stf);
			sy +=  stf.height;
			var tickButton:TickButton = new TickButton();
			tickButton.x = 8;
			tickButton.y = sy - 22;
			tickButton.width = 20;
			tickButton.height = 20;
			tickButtons.push(tickButton);
			tickButton.addEventListener(MouseEvent.CLICK,pressTick);
			tickButton.id = -1;
			//add the rest of stationing armies;
			for each (var army:Army in uI.pickedZone.armies) {
				stf = new SimpleTextField();
				stf.y = sy;
				stf.x = 30;
				stf.field.width = 350;
				stf.field.text = "Army of " + army.general.getFullTitle() + ", " + army.getTotal() + " soldiers";
				addChild(stf);
				sy +=  stf.height;

				//init the button for viewing the army
				var loupeButton:LoupeButton = new LoupeButton();
				loupeButton.x = 8;
				loupeButton.y = sy - 22;
				loupeButton.width = 20;
				loupeButton.height = 20;
				addChild(loupeButton);
				loupeButtons.push(loupeButton);
				loupeButton.addEventListener(MouseEvent.CLICK,viewArmy);

				var tickButton2:TickButton = new TickButton();
				tickButton2.x = 8;
				tickButton2.y = sy - 22;
				tickButton2.width = 20;
				tickButton2.height = 20;
				tickButton2.id = tickButtons.length - 1;
				tickButtons.push(tickButton2);
				tickButton2.addEventListener(MouseEvent.CLICK,pressTick);
			}

			//init shuffle button
			var shuffleButton:ShuffleButton = new ShuffleButton();
			shuffleButton.x = 8;
			shuffleButton.y = sy + 5;
			addChild(shuffleButton);
			shuffleButton.addEventListener(MouseEvent.CLICK,initShuffle);
			
			//print out barracks		
			var barracks:Array = uI.pickedZone.barracks;
			var b:Array = new Array();
			b.push(barracks[Constants.horsemanid]);
			b.push(barracks[Constants.archerid]);
			b.push(barracks[Constants.pikemanid]);
			b.push(barracks[Constants.guardianid]);
			b.push(barracks[Constants.swordsmanid]);
			for(var i:int=0;i<barracks.length;i++){
				stf = new SimpleTextField();
				stf.x = 182;
				stf.y = 480+22.8*i;
				stf.field.width = 30;
				stf.field.text = String(b[i]);
				addChild(stf);
			}
		}

		//go to ArmyDetailsFrame to show details of the picked army;
		public function viewArmy(evt:Event) {
			uI.main.removeChild(this);
			var armyDetailsFrame:ArmyDetailsFrame;
			for (var i:int=0; i<loupeButtons.length; i++) {
				if (evt.target == loupeButtons[i]) {
					armyDetailsFrame = new ArmyDetailsFrame(uI,this,uI.pickedZone.armies[i]);
				}
			}
			uI.main.addChild(armyDetailsFrame);
		}

		public function initShuffle(evt:Event) {
			if (shuffleOn) {
				if (pressedTicks.length == 2) {
					uI.main.removeChild(this);
					var shuffleFrame:ShuffleFrame = new ShuffleFrame(this) ;
					var army1:Army;
					var army2:Army;
					if (pressedTicks[0].id == -1) {
						army1 = uI.pickedZone.garrison;
					} else {
						army1 = uI.pickedZone.armies[pressedTicks[0].id];
					}
					if (pressedTicks[1].id == -1) {
						army2 = uI.pickedZone.garrison;
					} else {
						army2 = uI.pickedZone.armies[pressedTicks[1].id];
					}
					shuffleFrame.init(army1,army2);
					uI.main.addChild(shuffleFrame);
					removeTick(pressedTicks[0]);
					removeTick(pressedTicks[0]);
				}
				if (pressedTicks.length == 1) {
					removeTick(pressedTicks[0]);
				}
				shuffleOn = false;
				for each (var button:LoupeButton in loupeButtons) {
					addChild(button);
				}
				for each (var button3:TickButton in tickButtons) {
					removeChild(button3);
				}
			} else {
				shuffleOn = true;
				for each (var button2:LoupeButton in loupeButtons) {
					removeChild(button2);
				}
				for each (var button4:TickButton in tickButtons) {
					addChild(button4);
				}
			}
		}

		public function pressTick(evt:Event) {
			if (evt.target.pressed) {
				removeTick(TickButton(evt.target));
			} else {
				pressedTicks.push(evt.target);
				if (pressedTicks.length > 2) {
					removeTick(pressedTicks[0]);
				}
				evt.target.pressTick();
			}
		}

		public function removeTick(tick:TickButton) {
			for each (var t:TickButton in pressedTicks) {
				if (t==tick) {
					pressedTicks.splice(pressedTicks.indexOf(t),1);
					t.pressTick();
					return;
				}
			}
		}

	}

}