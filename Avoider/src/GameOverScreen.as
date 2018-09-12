package  
{
	import flash.ui.Mouse;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Jan Burak
	 */
	public class GameOverScreen extends MovieClip
	{
		
		public var restartButton:SimpleButton;
		
		public function GameOverScreen(	screenWidth:int, screenHeight:int) 
		{
			Mouse.show();
			setUpGraphics(screenWidth, screenHeight);
			
			restartButton.addEventListener(MouseEvent.CLICK, onClickRestart);
		}
		
		public function onClickRestart(mouseEvent:MouseEvent):void
		{
			dispatchEvent(new NavigationEvent(NavigationEvent.RESTART));
		}
		
		public function setFinalScore(score:Number,screenWidth:int, screenHeight:int):void
		{
			var scoreText:TextField = new TextField();
			scoreText.text = "Score: " + score;	
			var format:TextFormat = new TextFormat();
			format.size = 32;
			format.font = "Arial";
			format.bold = true;
			format.color = 0xFF0000;
			scoreText.setTextFormat(format);
			scoreText.autoSize = TextFieldAutoSize.LEFT;
			scoreText.x = (screenWidth / 2) - (scoreText.width/2);
			scoreText.y = (screenHeight / 2) + 10;
			addChild(scoreText);
		}
		
		private function setUpGraphics(screenWidth:int, screenHeight:int):void {
			var gameOverText:TextField = new TextField();
			var format:TextFormat = new TextFormat();
			var curtain:Sprite = new Sprite();
			curtain.graphics.beginFill(0x000000);
			curtain.graphics.drawRect(0, 0, screenWidth, screenHeight);
			curtain.graphics.endFill();
			addChild(curtain);
			gameOverText.text = "Game Over";
			format.size = 64;
			format.font = "Arial";
			format.bold = true;
			format.color = 0xFF0000;
			gameOverText.setTextFormat(format);
			gameOverText.autoSize = TextFieldAutoSize.LEFT;
			gameOverText.x = (screenWidth / 2) - (gameOverText.width / 2);
			gameOverText.y = (screenHeight / 2) - (gameOverText.height / 2)-30;
			addChild(gameOverText);
			
			var buttonX:int = (screenWidth / 2) - 60;
			var buttonY:int = (screenHeight / 2) + 60;
			var button:Sprite = new Sprite();
			var rectangle:Sprite = new Sprite();
			rectangle.graphics.beginFill(0xFF0000);
			rectangle.graphics.drawRect(0, 0, 120, 50);
			rectangle.graphics.endFill();
			button.addChild(rectangle);	
			button.addChild(getRestartText());
			var buttonOver:Sprite = new Sprite();	
			var rectangle2:Sprite = new Sprite();
			rectangle2.graphics.beginFill(0xFF9900);
			rectangle2.graphics.drawRect(0, 0, 120, 50);
			rectangle2.graphics.endFill();
			buttonOver.addChild(rectangle2);
			buttonOver.addChild(getRestartText());
			restartButton = new SimpleButton(button,buttonOver,buttonOver,rectangle);
			restartButton.x = buttonX;
			restartButton.y = buttonY;
			addChild(restartButton);
		}
		
		private function getRestartText():TextField { 
			var restartText:TextField = new TextField();
			var format:TextFormat = new TextFormat();
			restartText.text = "Restart";
			format.size = 32;
			format.font = "Arial";
			format.bold = true;
			format.color = 0x000000;
			restartText.setTextFormat(format);
			restartText.autoSize = TextFieldAutoSize.LEFT;
			return restartText;
		}
		
	}

}