package
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Jan Burak
	 */
	public class Level extends Sprite
	{
		public var rows:Array = new Array;
		public var levelWidth:int;
		public var levelHeight:int;
		public var sprites:Array = new Array;
		
		public function Level()
		{
		
		}
		
		public function init():void
		{
			
			for (var column:int = 0; column < rows.length; column++)
			{
				for (var row:int = 0; row < rows[column].length; row++)
				{
					if (rows[column][row] == 1)
					{
						var block:BlockTile = new BlockTile(row, column);
						sprites.push(block);
						addChild(block);
					}
				}
			}
		
		}
	}

}