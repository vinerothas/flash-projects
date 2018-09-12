package ui{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import zones.Zone;

	public class UI {

		public var pickedZoneMarker:MovieClip;
		public var pickedZone:Zone;
		public var pickedZone2:Zone;
		public var logWindow:LogWindow;
		public var confirmationWindow:ConfirmationWindow;
		public var pickedMode:String;
		public var pickedModeFrame:PickedModeFrame = new PickedModeFrame();
		public var modes:Array = new Array();
		public var main:MovieClip;
		public var activeFrame:MovieClip;
		
		public var attackArrow:AttackArrow;
		public var attackLine:AttackLine;
		public var dragging:Boolean = false;
		public var dragTime:Number = 0;
		public var dragWait:Number = 100;
		
		public function UI(mainStage:MovieClip) {
			main = mainStage;
			
			main.addEventListener(Event.ENTER_FRAME,loop);
			main.addEventListener(MouseEvent.MOUSE_UP,releaseMouse);

			//CHANGE TO NEXT TURN instead of multipleTurns
			main.turnButton.addEventListener(MouseEvent.CLICK, main.multipleTurns);
			main.infoButton.addEventListener(MouseEvent.CLICK, changeMode);
			main.armyButton.addEventListener(MouseEvent.CLICK, changeMode);

			modes.push("info","army");
			pickedMode = modes[0];
			//init visual feedback of chosen mode
			pickedModeFrame.x = main.infoButton.x;
			pickedModeFrame.y = main.infoButton.y;
			main.addChild(pickedModeFrame);

		}
		
		public function loop(evt:Event){
			if(activeFrame!=null)return;
			
			if(dragging){
				if(dragTime!=0){
					if(new Date().time>dragTime+dragWait){
						startDragging();
						dragTime = 0;
					}
				}else if(attackArrow!=null){
					attackArrow.visible = true;
					attackArrow.x = main.mouseX;
					attackArrow.y = main.mouseY;
					var ax:int = attackArrow.x-pickedZone.x;
					var ay:int = pickedZone.y-attackArrow.y;
					if(ax<0&&ay<0)attackArrow.rotation = (Math.atan(ax/ay)*360/(2*Math.PI))+180;
					else if(ay<0)attackArrow.rotation = (Math.atan(ax/ay)*360/(2*Math.PI))+180;
					else if(ax<0)attackArrow.rotation = (Math.atan(ax/ay)*360/(2*Math.PI))+360;
					else attackArrow.rotation = (Math.atan(ax/ay)*360/(2*Math.PI));
				
					var dist:Number = Math.sqrt(ax*ax+ay*ay);
					var arrowHeight:int = 25;
					if(dist<arrowHeight)attackLine.visible = false;
					else attackLine.visible = true;
					//distance between zone center and mouse position minus arrow height divided by line height
					attackLine.scaleY = ((dist-arrowHeight)/10);
					//trace(attackLine.scaleY);
					attackLine.rotation = attackArrow.rotation;
				}else if(dragTime==0){
					dragging = false;
				}
			}
		}
		
		public function releaseMouse(evt:Event){		
			if(activeFrame!=null)return;
			
			dragTime = 0;
			if(attackArrow!=null){
				main.removeChild(attackArrow);
				attackArrow = null;
				main.removeChild(attackLine);
				attackLine = null;
				
				if(evt.target is Zone){
					var attackingZone:Zone = pickedZone;
					var enemyZone:Zone = Zone(evt.target);
					if(attackingZone.ruler != enemyZone.ruler){
						if(attackingZone.neighbours.indexOf(enemyZone)!= -1){
							activeFrame = new AttackFrame(this,attackingZone,enemyZone);
							AttackFrame(activeFrame).checkOrders(main.armyOrders);
							main.addChild(activeFrame);
						}
					}
				}
			}
		}

		public function changeMode(evt:MouseEvent) {
			//jezeli bedzie wiecej przyciskow to uzyc arrayu
			//z objectami {mode:String, button:Object}
			var target:Object = evt.target;
			if (target == main.infoButton) {
				pickedMode = modes[0];
			} else if (target == main.armyButton) {
				pickedMode = modes[1];
			}
			clearPickedZones();

			if (pickedModeFrame == null) {
				pickedModeFrame = new PickedModeFrame();
				main.addChild(pickedModeFrame);
			}
			pickedModeFrame.x = target.x;
			pickedModeFrame.y = target.y;
		}

		public function zonePressed(evt:MouseEvent) {
			if (confirmationWindow!=null) {
				return;
			}
			
			if (pickedMode=="info") {
				pickedZone = Zone(evt.target);
				activeFrame = new InfoFrame(Zone(evt.target),this,null);
				main.addChild(activeFrame);
				activeFrame.init();
				return;
			} else if (pickedMode=="army") {
				if (evt.target.ruler == main.player){
					if(Zone(evt.target) == pickedZone){
						activeFrame = new ArmyFrame(this,null);
						main.addChild(activeFrame);
						activeFrame.init();
						return;
					}
					pickedZone = Zone(evt.target);
					if (pickedZoneMarker!=null) {
						main.removeChild(pickedZoneMarker);
					}
					pickedZoneMarker = new ZoneMarker();
					pickedZoneMarker.mouseEnabled = false;
					pickedZoneMarker.x = evt.target.x;
					pickedZoneMarker.y = evt.target.y;
					main.addChild(pickedZoneMarker);
				}else{
					//press enemy zone
				}
				
				/*
				if (pickedZone!=null && evt.target.ruler!=main.playerRace) {
					confirmationWindow = new ConfirmationWindow();
					main.addChild(confirmationWindow);
					confirmationWindow.x = 435;
					confirmationWindow.y = 359;
					confirmationWindow.init("Do you want to attack this region?");
					return;
				}
				*/
			}
		}
		
		public function zoneDragged(evt:MouseEvent){
			if(pickedMode!="army")return;
			
			if(pickedZone!=evt.target){
				zonePressed(evt);
				dragTime = new Date().time;
				dragging = true;
			}else{		
				dragTime = new Date().time-50;
				dragging = true;
			}
			/*
			if(dragTime==0){
				startDragging();
			}*/
			
		}
		
		public function startDragging(){
			dragging = true;
			if(attackLine!=null){
				if(main.contains(attackLine))main.removeChild(attackLine);
			}
			if(attackArrow!=null){
				if(main.contains(attackArrow))main.removeChild(attackArrow);
			}
			attackLine = new AttackLine();
			attackLine.x = pickedZone.x;
			attackLine.y = pickedZone.y;
			attackLine.visible = false;
			main.addChild(attackLine);
			attackArrow = new AttackArrow();
			attackArrow.x = main.mouseX;
			attackArrow.y = main.mouseY;
			attackArrow.visible = false;
			attackArrow.mouseEnabled = false;
			main.addChild(attackArrow);
		
			if(pickedZoneMarker!=null){
				if(main.contains(pickedZoneMarker)){
				   		main.removeChild(pickedZoneMarker);
						main.addChild(pickedZoneMarker);
				   }
			}

		}
		
		//clear zone markers after leaving army mode
		public function clearPickedZones(){
			pickedZone = null;
			pickedZone2 = null;
			if (pickedZoneMarker!=null) {
				main.removeChild(pickedZoneMarker);
				pickedZoneMarker = null;
			}
		}

	}

}