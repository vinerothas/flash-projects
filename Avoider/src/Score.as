package  
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Jan Burak
	 */
	public class Score extends Counter
	{
		public var scoreText:TextField;
		private var screenWidth:int;
		
		public function Score(sWidth:int) 
		{
			scoreText = new TextField();
			screenWidth = sWidth;
			addChild(scoreText);
			super();
			
		}
		
		override public function updateDisplay():void
		{
			super.updateDisplay();
			scoreText.text = "Score: " + currentValue.toString();	
			var format:TextFormat = new TextFormat();
			format.size = 32;
			format.font = "Arial";
			format.bold = true;
			format.color = 0xFF0000;
			scoreText.setTextFormat(format);
			scoreText.autoSize = TextFieldAutoSize.LEFT;
			scoreText.x = screenWidth-scoreText.width-10;
			scoreText.y = scoreText.height-40;
		}
		
	}

}