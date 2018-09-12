package {
	import ui.UI;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import ui.ExitButton;
	import ui.BackButton;
	import ui.LogButton;
	import ui.BuildButton;
	import ui.ArmyModeButton;
	import ui.InfoFrame;
	import ui.BuildFrame;
	import ui.ArmyFrame;

	public class ActiveFrame extends MovieClip {

		public var uI:UI;
		public var previousFrame:ActiveFrame;
		public var exitButton:ExitButton;
		public var backButton:BackButton;

		public function ActiveFrame(uI:UI,previousFrame:ActiveFrame) {
			this.uI = uI;
			this.previousFrame = previousFrame;

			exitButton = new ExitButton();
			exitButton.x = 762;
			exitButton.y = 3;
			exitButton.addEventListener(MouseEvent.CLICK,exitFrame);
			addChild(exitButton);

			if (previousFrame!=null) {
				backButton = new BackButton();
				backButton.x = 724;
				backButton.y = 3;
				backButton.addEventListener(MouseEvent.CLICK,exitFrameBack);
				addChild(backButton);
			}
			
		}

		public function exitFrame(evt:Event) {
			if (uI.main.contains(this)) {
				uI.main.removeChild(this);
			}
			uI.activeFrame = null;
		}
		
		public function exitFrameBack(evt:Event){
			uI.main.addChild(previousFrame);
			uI.main.removeChild(this);
		}
		
	}

}