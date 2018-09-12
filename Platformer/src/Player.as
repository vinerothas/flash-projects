package  
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Jan Burak
	 */
	public class Player extends Sprite
	{
		public var jump:Boolean;
		public var inAir:Boolean = true;
		public const playerWidth:Number = 30;
		public const playerHeight:Number = 30;
		public const jumpVelocity:int = -17;//-19
		public var velocityX:Number = 5;//4
		public var velocityY:Number = 0;
		
		public function Player() 
		{
			graphics.beginFill(0x00FF00);
			graphics.drawRect(0, 0, playerHeight, playerHeight);
			graphics.endFill();
		}
		
		
	}

}