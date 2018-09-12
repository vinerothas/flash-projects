package  
{
	import flash.ui.Mouse;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.errors.StackOverflowError;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Jan Burak
	 */
	public class AvoiderGame extends MovieClip
	{
		public var army:Array;
		public var avatar:Avatar;
		public var gameTimer:Timer;
		public var score:Score;
		
		public function AvoiderGame(screenWidth:int,screenHeight:int) 
		{
			Mouse.hide();
			
			var background:Sprite = new Sprite();
			background.graphics.beginFill(0xFFFFFF);
			background.graphics.drawRect(0, 0, screenWidth,screenHeight);
			background.graphics.endFill();
			addChild(background);
			army = new Array();
			var newEnemy:Enemy = new Enemy(100, -25);
			army.push(newEnemy);
			addChild(newEnemy);
			
			avatar = new Avatar();
			addChild(avatar);
			avatar.x = mouseX;
			avatar.y = mouseY;
			
			score = new Score(screenWidth);
			addChild(score);
			
			gameTimer = new Timer(25);
			gameTimer.addEventListener(TimerEvent.TIMER, onTick);
			gameTimer.start();
		}
		
		public function onTick( timerEvent:TimerEvent):void
		{
			if (Math.random() < 0.08) {				
				var randomX:Number = Math.random() * stage.stageWidth
				var newEnemy:Enemy = new Enemy(randomX, -50);
				army.push(newEnemy);
				addChild(newEnemy);
			}
			
			for each(var enemy:Enemy in army)
			{				
				if (enemy.y > stage.stageHeight) {
					army.splice(army.indexOf(enemy), 1);
					score.addToValue(1);
				}
				else if (avatar.hitTestObject(enemy)) {
					gameTimer.stop();
					avatar.alive = false;
				}
				
				enemy.moveDownABit();
			}			
					
			if(avatar.alive == false)dispatchEvent(new AvatarEvent( AvatarEvent.DEAD));
			
			avatar.x = mouseX;
			avatar.y = mouseY;
		}
		
		public function getScore():Number
		{
			return score.currentValue;
		}
		
	}
	
}