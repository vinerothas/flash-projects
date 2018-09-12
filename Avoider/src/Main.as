package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Jan Burak
	 */
	[Frame(factoryClass="Preloader")]
	
	public class Main extends Sprite
	{
		
		public var playScreen:AvoiderGame;
		public var gameOverScreen:GameOverScreen;
		
		public function Main():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			playScreen = new AvoiderGame(stage.stageWidth, stage.stageHeight);
			playScreen.addEventListener(AvatarEvent.DEAD, onAvatarDeath);
			addChild(playScreen);
		}
		
		public function restartGame():void
		{
			playScreen = new AvoiderGame(stage.stageWidth, stage.stageHeight);
			playScreen.x = 0;
			playScreen.y = 0;
			playScreen.addEventListener(AvatarEvent.DEAD, onAvatarDeath);
			addChild(playScreen);
			
			gameOverScreen = null;
		}
		
		public function onAvatarDeath(avatarEvent:AvatarEvent):void
		{			
			var score:Number = playScreen.getScore();
			gameOverScreen = new GameOverScreen(stage.stageWidth, stage.stageHeight);
			gameOverScreen.setFinalScore(score, stage.stageWidth, stage.stageHeight);
			gameOverScreen.x = 0;
			gameOverScreen.y = 0;
			gameOverScreen.addEventListener(NavigationEvent.RESTART, onRequestRestart);
			
			addChild(gameOverScreen);
			playScreen = null;
		}
		
		public function onRequestRestart(navigationEvent:NavigationEvent):void
		{
			restartGame();	
		}
	
	}

}