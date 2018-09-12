package ui {
	
	import flash.display.SimpleButton;
	import flash.display.DisplayObject;
	
	
	public class TickButton extends SimpleButton {
		
		public var pressed:Boolean = false;
		public var up:DisplayObject = upState;
		public var down:DisplayObject = downState;
		public var over:DisplayObject = overState;		
		public var id:int;
		public var mouseover:Boolean = true;
		
		public function TickButton() {
			// constructor code
		}
		
		//manages the visual effect of tick being pressed or let go
		public function pressTick(){
			//trace("pressTick");
			if (pressed) {
				upState = up;
				overState = over;
				pressed = false;
			} else {
				upState = down;
				overState = down;
				pressed = true;
			}
		}
		
		//turns off the mouseover visual effect
		public function mouseoverOff(){
			//trace("mouseoverOff");
			mouseover = false;
			overState = up;
			downState = up;
		}
		
	}
	
}
