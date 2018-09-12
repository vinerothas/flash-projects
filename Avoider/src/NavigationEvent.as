package  
{
	import flash.events.Event;
	/**
	 * ...
	 * @author Jan Burak
	 */
	public class NavigationEvent extends Event
	{
	
		public static const RESTART:String = "restart";
		
		public function NavigationEvent(type:String) 
		{
			super(type);
		}
		
	}

}