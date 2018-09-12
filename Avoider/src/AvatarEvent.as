package  
{
	import flash.events.Event;
	/**
	 * ...
	 * @author Jan Burak
	 */
	public class AvatarEvent extends Event
	{
	
		public static const DEAD:String = "dead";
		
		public function AvatarEvent(type:String) 
		{
			super(type);
		}
		
	}

}