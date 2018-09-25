package classes {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	
	public class FinishScreen extends MovieClip {
		
		
		public function FinishScreen(main:Main) {
			replayButton.addEventListener(MouseEvent.CLICK,main.startGame);
			
			var timeScore:Number = main.timeScore;
			var milliseconds:int = timeScore%1000;
			var seconds:int = (timeScore/1000)%60;
			var minutes:int = timeScore/60000;
			var milString:String;
			var secString:String;
			var minString:String;
			if(milliseconds>99){
				milString = ""+milliseconds;
			}else if(milliseconds>9){
				milString = "0"+milliseconds;
			}else{
				milString = "00"+milliseconds;
			}
			if(seconds>9){
				secString = ""+seconds;
			}else{
				secString = "0"+seconds;
			}
			if(minutes>9){
				minString = ""+minutes;
			}else{
				minString = "0"+minutes;
			}
			scoreField.text = minString+":"+secString+":"+milString;
		}
	}
	
}
