package ui {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class ScrollingMenu extends MovieClip{

		public var entries:Array = new Array();
		public var maxQuantity:int;
		public var downArrow:WideArrow = new WideArrow();
		public var upArrow:WideArrow = new WideArrow();
		//the arrows are put in the middle of width
		public var menuWidth:int;
		public var currentID:int = 0;

		public function ScrollingMenu(entries:Array,maxQuantity:int,ax:int,ay:int,ay2:int) {
			if(entries.length==0)return;
			this.maxQuantity = maxQuantity;
			this.entries = entries;
			
			if(entries.length<=maxQuantity){
				for each(var entry:MovieClip in entries){
					addChild(entry);
				}
			}else{
				printOutTop();
				addChild(downArrow);
				downArrow.x = ax;
				downArrow.y = ay2;
				downArrow.addEventListener(MouseEvent.CLICK,goDown);
				upArrow.x = ax;
				upArrow.y = ay;
				upArrow.visible = false;
				upArrow.flip();
				addChild(upArrow);
				upArrow.addEventListener(MouseEvent.CLICK,goUp);
			}
		}
		
		public function goDown(evt:MouseEvent){
			if(currentID==0){
				upArrow.visible = true;
				currentID++;
			}
			currentID++;
			y-=entries[0].height;
			downArrow.y+=entries[0].height;
			upArrow.y+=entries[0].height;
			clear();
			
			var i:int;
			//if the last entry is shown
			if(currentID==lastID()){
				for(i=currentID;i<entries.length;i++){
					addChild(entries[i]);
				}
				downArrow.visible = false;
			}else{
				printOutNormal();
			}
		}
		
		public function goUp(evt:MouseEvent){
			if(currentID==lastID()){
				downArrow.visible = true;
			}
			currentID--;
			y+=entries[0].height;
			downArrow.y-=entries[0].height;
			upArrow.y-=entries[0].height;
			if(currentID==1){
				upArrow.visible = false;
				currentID--;
			}
			clear();
			
			//if the first entry is shown
			if(currentID==0){
				printOutTop();
			}else{
				printOutNormal();
			}
		}
		
		public function lastID(){
			return entries.length-maxQuantity+1;
		}
		
		public function printOutNormal(){
			for(var i:int=currentID;i<currentID+maxQuantity-2;i++){
					addChild(entries[i]);
			}
		}
		
		public function printOutTop(){
			for(var i:int=0;i<maxQuantity-1;i++){
					addChild(entries[i]);
			}
		}
		
		public function clear(){
			for each(var entry:MovieClip in entries){
					if(contains(entry))removeChild(entry);
			}
		}

	}
	
}
