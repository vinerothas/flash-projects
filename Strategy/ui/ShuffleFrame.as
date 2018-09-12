package ui{

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.IBitmapDrawable;
	import flash.text.TextField;

	public class ShuffleFrame extends ZoneFrame {

		public var army1;
		public var army2;
		public var toArmy1:Array = new Array();
		public var toArmy2:Array = new Array();
		public var armyFrame;
		public var confirmationWindow:ConfirmationWindow;

		public function ShuffleFrame(armyFrame:ArmyFrame) {
			super(armyFrame.uI,armyFrame);
		}

		public function init(army1:Army,army2:Army) {
			this.army1 = army1;
			this.army2 = army2;
			this.armyFrame = armyFrame;
			
			armyField1.text = "Army of \n" + army1.general.getFullTitle();
			armyField2.text = "Army of \n" + army2.general.getFullTitle();
			
			var referenceY:int = 123;
			
			var soldierFields:SoldierFields = new SoldierFields();
			soldierFields.x = 90;
			soldierFields.y = referenceY;
			soldierFields.initAll(army1);
			addChild(soldierFields);

			soldierFields = new SoldierFields();
			soldierFields.x = 480;
			soldierFields.y = referenceY;
			soldierFields.initAll(army2);
			addChild(soldierFields);

			var sy:int = new SimpleTextField().height;
			for (var i:int=0; i<army1.s.length; i++) {
				var sif:ShuffleInsertField = new ShuffleInsertField();
				sif.x = 257;
				sif.y = referenceY+1 + i * sy;
				sif.field.text = "";
				sif.field.restrict = "0-9";
				addChild(sif);
				toArmy2.push(sif);
				sif = new ShuffleInsertField();
				sif.x = 400;
				sif.y = referenceY+1 + i * sy;
				sif.field.text = "";
				sif.field.restrict = "0-9";
				addChild(sif);
				toArmy1.push(sif);
			}
			var sab:ShuffleAllButton = new ShuffleAllButton  ;
			sab.x = 257;
			sab.y = referenceY+1 + 15 * sy;
			sab.addEventListener(MouseEvent.CLICK,shuffleAll1);
			addChild(sab);
			sab = new ShuffleAllButton  ;
			sab.x = 400;
			sab.y = referenceY+1 + 15 * sy;
			sab.addEventListener(MouseEvent.CLICK,shuffleAll2);
			addChild(sab);

			shuffleButton.addEventListener(MouseEvent.CLICK,shuffle);
		}

		public function shuffle(evt:Event) {
			var toArmy1int:Array = new Array();
			var toArmy2int:Array = new Array();
			var army1Array:Array = army1.s;
			var army2Array:Array = army2.s;
			var f:ShuffleInsertField;
			var a:int;
			for (var i:int = 0; i<army1.s.length; i++) {
				f = toArmy1[i];
				a = 0;
				if (f.field.text != "") {
					a = int(f.field.text);
				}
				if (a>army2Array[i]) {
					a = army2Array[i];
				}
				toArmy1int.push(a);
			}
			for (var j:int = 0; j<army1.s.length; j++) {
				f = toArmy2[j];
				a = 0;
				if (f.field.text != "") {
					a = int(f.field.text);
				}
				if (a>army1Array[j]) {
					a = army1Array[j];
				}
				toArmy2int.push(a);
			}
			army1.addToArmy(toArmy1int);
			army1.removeFromArmy(toArmy2int);
			army2.addToArmy(toArmy2int);
			army2.removeFromArmy(toArmy1int);
			exitFrameBack(evt);
		}

		//take all from army1 and put in army2
		public function shuffleAll1(evt:Event) {
			if(confirmationWindow!=null)return;
			confirmationWindow = new ConfirmationWindow();
			addChild(confirmationWindow);
			confirmationWindow.x = 400-confirmationWindow.width/2;
			confirmationWindow.y = 300-confirmationWindow.height/2;
			confirmationWindow.initYN("Do you want to merge the armies?");
			confirmationWindow.yesButton.addEventListener(MouseEvent.CLICK,confirmShuffle1);
			confirmationWindow.noButton.addEventListener(MouseEvent.CLICK,cancel);
		}
		
		public function confirmShuffle1(evt:Event){	
			army2.addToArmy(army1.s);
			army1.removeFromArmy(army1.s);
			exitFrameBack(evt);
		}

		//take all from army2 and put in army1
		public function shuffleAll2(evt:Event) {
			if(confirmationWindow!=null)return;
			confirmationWindow = new ConfirmationWindow();
			addChild(confirmationWindow);
			confirmationWindow.x = 400-confirmationWindow.width/2;
			confirmationWindow.y = 300-confirmationWindow.height/2;
			confirmationWindow.initYN("Do you want to merge the armies?");
			confirmationWindow.yesButton.addEventListener(MouseEvent.CLICK,confirmShuffle2);
			confirmationWindow.noButton.addEventListener(MouseEvent.CLICK,cancel);
		}
		
		public function confirmShuffle2(evt:Event){
			army1.addToArmy(army2.s);
			army2.removeFromArmy(army2.s);
			exitFrameBack(evt);
		}
		
		public function cancel(evt:Event){
			removeChild(confirmationWindow);
			confirmationWindow = null;
		}

		override public function exitFrameBack(evt:Event) {
			var af:ArmyFrame = new ArmyFrame(uI,null);
			super.previousFrame = af;
			af.init();
			super.exitFrameBack(evt);
		}

	}

}