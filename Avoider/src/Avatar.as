package  
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Jan Burak
	 */
	public class Avatar extends MovieClip
	{
		private const avatarHeight:int = 50;
		public var alive:Boolean = true;
		
		public function Avatar() 
		{
			graphics.beginFill(0x00FF00);
			graphics.drawRect(0, 0, avatarHeight, avatarHeight);
			graphics.endFill();
		}
		
	}

}