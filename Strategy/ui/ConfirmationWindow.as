package  ui{
	
	import flash.display.MovieClip;
	
	
	public class ConfirmationWindow extends MovieClip {
		
		
		public function ConfirmationWindow() {
			
		}
		
		//initializes window with yes/no buttons
		public function initYN(string:String){
			textField.text = string;
			okButton.visible = false;
			yesButton.setText("Yes");
			noButton.setText("No");
		}
		
		//initializes window with ok button
		public function initInfo(string:String){
			textField.text = string;
			okButton.setText("Ok");
			yesButton.visible=false;
			noButton.visible=false;
		}
		
		public function placeMiddle(){
			x = (800-width)/2;
			y = (600-height)/2;
		}
		
	}
	
}
