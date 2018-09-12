package ui {
	
	import flash.display.SimpleButton;
	
	
	public class WideArrow extends SimpleButton {
		
		
		public function WideArrow() {
			// constructor code
		}
		
		public function flip(){
			rotation = 180;
			y+=height;
		}
	}
	
}
