package  ui {
	import flash.display.MovieClip;
	
	public class AttackTrail extends MovieClip{
		
		public var attackArrow:AttackArrow;
		public var attackLine:AttackLine;

		public function AttackTrail() {
			// constructor code
		}
		
		public function init(x1:int,y1:int,x2:int,y2:int){
			attackLine = new AttackLine();
			attackArrow = new AttackArrow();
			attackLine.x = x1;
			attackLine.y = y1;
			attackArrow.x = x2;
			attackArrow.y = y2;
			var ax:int = attackArrow.x-attackLine.x;
			var ay:int = attackLine.y-attackArrow.y;
			if(ax<0&&ay<0)attackArrow.rotation = (Math.atan(ax/ay)*360/(2*Math.PI))+180;
			else if(ay<0)attackArrow.rotation = (Math.atan(ax/ay)*360/(2*Math.PI))+180;
			else if(ax<0)attackArrow.rotation = (Math.atan(ax/ay)*360/(2*Math.PI))+360;
			else attackArrow.rotation = (Math.atan(ax/ay)*360/(2*Math.PI));
				
			var dist:Number = Math.sqrt(ax*ax+ay*ay);
			var arrowHeight:int = 25;
			//distance between zone center and mouse position minus arrow height divided by line height
			attackLine.scaleY = ((dist-arrowHeight)/10);
			//trace(attackLine.scaleY);
			attackLine.rotation = attackArrow.rotation;
			
			attackLine.mouseEnabled = false;
			attackArrow.mouseEnabled = false;
			mouseEnabled = false;
			
			addChild(attackLine);
			addChild(attackArrow);
		}

	}
	
}
