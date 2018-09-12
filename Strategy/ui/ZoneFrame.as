package ui {
	
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class ZoneFrame extends ActiveFrame{
		
		public var infoButton:LogButton;
		public var buildButton:BuildButton;
		public var armyButton:ArmyModeButton;

		public function ZoneFrame(uI:UI,previousFrame:ActiveFrame){
			super(uI,previousFrame);
			
			infoButton = new LogButton();
			infoButton.x = 4;
			infoButton.y = 3;
			infoButton.addEventListener(MouseEvent.CLICK,enterInfoFrame);
			addChild(infoButton);
			
			buildButton = new BuildButton();
			buildButton.x = 42;
			buildButton.y = 3;
			buildButton.addEventListener(MouseEvent.CLICK,enterBuildFrame);
			addChild(buildButton);
			
			armyButton = new ArmyModeButton();
			armyButton.x = 80;
			armyButton.y = 3;
			armyButton.addEventListener(MouseEvent.CLICK,enterArmyFrame);
			addChild(armyButton);
		}
		
		public function enterInfoFrame(evt:Event){
			exitFrame(evt);
			var infoFrame:InfoFrame = new InfoFrame(uI.pickedZone,uI,null);
			infoFrame.init();
			uI.main.addChild(infoFrame);
		}
		
		public function enterBuildFrame(evt:Event){
			exitFrame(evt);
			var buildFrame:BuildFrame = new BuildFrame(uI,null);
			buildFrame.init();
			uI.main.addChild(buildFrame);
		}
		
		public function enterArmyFrame(evt:Event){
			exitFrame(evt);
			var armyFrame:ArmyFrame = new ArmyFrame(uI,null);
			armyFrame.init();
			uI.main.addChild(armyFrame);
		}

	}
	
}
