package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;

	/**
	 * ...
	 * @author Jan Burak
	 */
	[Frame(factoryClass="Preloader")]
	public class Main extends Sprite 
	{
		public var playScreen:GameplayScreen;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			playScreen = new GameplayScreen(stage.stageWidth,stage.stageHeight);
			playScreen.x = 0;
			playScreen.y = 0;
			addChild(playScreen);
						
			stage.addEventListener(KeyboardEvent.KEY_DOWN, playScreen.keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, playScreen.keyUpHandler);
		}

	}

}