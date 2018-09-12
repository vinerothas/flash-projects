package  
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Jan Burak
	 */
	public class Enemy extends MovieClip
	{
		private const enemyHeight:int = 50;
		
		public function Enemy(startX:Number, startY:Number) 
		{
			y = startY;
			x = startX;
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, enemyHeight, enemyHeight);
			graphics.endFill();
		}
		
		public function moveDownABit():void
		{
			y = y + 3;
			if(Math.random()<0.1)x = x + (Math.random() - 0.5)*6;
		}
		
	}

}