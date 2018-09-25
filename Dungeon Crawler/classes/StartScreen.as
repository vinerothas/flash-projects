package classes {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	
	public class StartScreen extends MovieClip {
		
		
		public function StartScreen(main:Main) {
			startButton.addEventListener(MouseEvent.CLICK,main.startGame);
		}
	}
	
}
