package  
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Jan Burak
	 */
	public class BlockTile extends Sprite
	{
		
		public const blockWidth:int = 30;
		public const blockHeight:int = 30;
		
		public function BlockTile(posX:int,posY:int) 
		{
			x = posX * blockWidth;
			y = posY * blockHeight;
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, blockWidth, blockHeight);
			graphics.endFill();
		}
		
	}

}