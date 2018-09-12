package  
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Jan Burak
	 */
	public class Counter extends MovieClip
	{
		
		public var currentValue:Number;
		
		public function Counter() 
		{
			reset();
		}
		
		public function addToValue(ammountToAdd:Number):void
		{
			currentValue = currentValue + ammountToAdd;
			updateDisplay();
		}
		
		public function reset():void
		{
			currentValue = 0;
			updateDisplay();
		}
		
		public function updateDisplay():void
		{
			
		}
		
	}

}