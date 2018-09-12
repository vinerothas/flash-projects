package ui {
	
	import flash.display.MovieClip;
	
	
	public class SmallButton extends MovieClip {
		
		public function SmallButton() {
			textField.text = "";
			textField.mouseEnabled = false;
		}
		
		public function setText(string:String){
			textField.text = string;
		}
	}
	
}
