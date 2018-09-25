package classes {
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class LevelGenerator {
		
		var map:Array;
		var player:Player;
		var walls:MovieClip;
		var scene:MovieClip;
		var main:Main;
		var tileSize:int;
		var sceneWidth:int;
		var sceneHeight:int;
		var offsetX:int = 0;
		var offsetY:int = 0;
		var rng:RandomNumberGenerator;
		//players starting position and origin of generating
		var ox:int;
		var oy:int;
		var levelSize:int;
		
		public function LevelGenerator(player:Player,walls:MovieClip,scene:MovieClip,main:Main) {
			this.player = player;
			this.walls = walls;
			this.scene = scene;
			this.main = main;
			tileSize = main.tileSize;
			sceneWidth = main.sceneWidth;
			sceneHeight = main.sceneHeight;
		}
		
		function run(levelSize:int){
			main.currentlyGenerating = true;
			this.levelSize = levelSize;
			generateLevel();
			initializeLevel();
			main.currentlyGenerating = false;
		}
		
		function generateLevel() {
			//1 wall, 2 player
			/*
			map.push(new Array(1,1,1,1,1,1,1,1,1,1));
			map.push(new Array(1,0,0,0,0,0,0,0,0,1));
			map.push(new Array(1,0,0,1,1,0,0,0,0,1));
			map.push(new Array(1,0,0,1,1,1,0,1,1,1));
			map.push(new Array(1,0,0,1,0,0,0,0,0,1));
			map.push(new Array(1,1,1,1,1,0,1,1,0,1));
			map.push(new Array(1,2,1,0,0,0,1,1,0,1));
			map.push(new Array(1,0,0,0,1,0,1,0,0,1));
			map.push(new Array(1,1,1,1,1,1,1,1,1,1));
			*/

			map = new Array();
			//creates a rectangle of walls
			//minimal is 10 height and 12 width
			//otherwise change the point of view algorithm
			for (var wy:int=0; wy<levelSize; wy++) {//iterate map
				map.push(new Array());
				for (var wx:int=0; wx<levelSize; wx++) {//iterate arrays inside map
					map[wy].push(1);
				}
			}

			rng = new RandomNumberGenerator(Math.random() * 100000000);
			trace(rng.getSeed());

			//these represent the position of downmost and leftmost borders
			var mWidth = map[0].length - 1;
			var mHeight = map.length - 1;
			
			//start point in a random corner
			var st:int = rng.getIntBetween(1,4);
			var mx:int;
			var my:int;
			if(st==1){
				mx = 1;
				my = 1;
			}else if(st==2){
				mx = 1;
				my = mHeight-1;
			}else if(st==3){
				mx = mWidth-1;
				my = 1;
			}else if(st==4){
				mx = mWidth-1;
				my = mHeight-1;
			}
			ox = mx;
			oy = my;
			
			//goBack == false makes more interesting patterns
			//the dungeon looks like it's divided into sections
			//goBack == true looks more like a squiggly line with branches going out
			/*
			var goBack:Boolean = true;
			var a:int = rng.getIntBetween(0,1);
			if(a==1){
				goBack = false;
			}
			trace("goBack: "+goBack+" "+a);
			*/

			var tries:int = 0;
			var lastDirection = 0;
			while (tries<50) {
				//line length between 2 and 5 with increased chance for 2 and 3
				var length:int = rng.getIntBetween(2,7);
				if(length>5){
					if(length==6){
						length = 2;
					}else{
						length = 3;
					}
				}
				//up right down left
				var direction:int = rng.getIntBetween(1,4);
				//if(!goBack){
				while(direction == lastDirection){
					direction = rng.getIntBetween(1,4);
				}
				//}
				lastDirection = direction;
				var dx:int = 0;
				var dy:int = 0;
				if (direction==1) {
					dy = -1;
				} else if (direction==2) {
					dx = 1;
				} else if (direction==3) {
					dy = 1;
				} else if (direction==4) {
					dx = -1;
				}

				var startAgain:Boolean;
				var i:int;
				if (direction==1||direction==3) {
					//check if the point isn't on/outside borders
					var my2:int = my + dy * length;
					if (my2>=mHeight||my2<=0) {
						//start again
						tries++;
						continue;
					}
					
					//check diagonals
					//dir up
					// c  x  c
					// x my2 x
					// x  x  x
					//c should be walls
					if(map[my2+dy][mx+1]==0||map[my2+dy][mx-1]==0){
						tries++;
						continue;
					}
					
					//start checking the first tile y = i
					//do so until "i" has checked my2
					startAgain = false;
					for (i = my+dy; i-dy!=my2; i+=dy) {
						if (map[i][mx] == 0) {
							startAgain = true;
							break;
						}
					}
					if (startAgain) {
						if (map[my2][mx] == 0) {
							my = my2;
						}
						tries++;
						continue;
					}
					//else free to go
					tries = 0;
					for (i = my+dy; i-dy!=my2; i+=dy) {
						map[i][mx] = 0;
					}
					my = my2;
				} else {
					var mx2:int = mx + dx * length;
					if (mx2>=mWidth||mx2<=0) {
						//start again
						tries++;
						continue;
					}
					
					//check diagonals
					if(map[my+1][mx2+dx]==0||map[my-1][mx2+dx]==0){
						tries++;
						continue;
					}
					
					//start checking the first tile y = i
					//do so until "i" has checked my2
					startAgain = false;
					for (i = mx+dx; i-dx!=mx2; i+=dx) {
						if (map[my][i] == 0) {
							startAgain = true;
							break;
						}
					}
					if (startAgain) {
						if (map[my][mx2] == 0) {
							mx = mx2;
						}
						tries++;
						continue;
					}
					//else free to go
					tries = 0;
					for (i = mx+dx; i-dx!=mx2; i+=dx) {
						map[my][i] = 0;
					}
					mx = mx2;
				}

			}
			map[oy][ox] = 2;
			
		}
		
		//make an exit close to opposite corner of the starting position
		function makeExit(startPosX:int,startPosY:int){
			if(startPosX==1){
				startPosX = map[0].length-2;
			}else if(startPosX==map[0].length-2){
				startPosX = 1;
			}
			if(startPosY==1){
				startPosY = map.length-2;
			}else if(startPosY==map.length-2){
				startPosY = 1;
			}
			
			var emptyPoints:Array;
			//diagonal searching, else straight
			if(map.length==map[0].length){
				//if diagonal fails, search straight
				emptyPoints = diagonalExitSearch(startPosX,startPosY);
				if(emptyPoints.length==0){
					emptyPoints = straightExitSearch(startPosX,startPosY);
				}
			}else{
				emptyPoints = straightExitSearch(startPosX,startPosY);
			}
			
			//randomize the array
			var shuffledArray = new Array();
			while(emptyPoints.length!=0){
				var r:int = rng.getIntBetween(0,emptyPoints.length-1);
				shuffledArray.push(emptyPoints[r]);
				emptyPoints.splice(r,1);
			}
			
			var exitMade:Boolean = false;
			for each(var point:Point in shuffledArray){
				var exits:int = 0;
				if(map[point.y+1][point.x]==0){
					exits++;
				}
				if(map[point.y-1][point.x]==0){
					exits++;
				}
				if(map[point.y][point.x+1]==0){
					exits++;
				}
				if(map[point.y][point.x-1]==0){
					exits++;
				}
				if(exits==1){
					map[point.y][point.x]=3;
					//trace("Exit:"+point.x+" "+point.y);
					exitMade = true;
					break;
				}
			}
			if(!exitMade){
				map[shuffledArray[0].y][shuffledArray[0].x]=3;				
				//trace("Exit:"+shuffledArray[0].x+" "+shuffledArray[0].y);
			}
		}
		
		//parameter: starting position of search
		function diagonalExitSearch(startPosX:int,startPosY:int):Array{
			//positions of empty spaces found
			var emptyPoints:Array = new Array();			
			//change of y on each while loop
			var bigDeltaY:int = -1;
			//change of y and x on each scanned line
			var deltaY:int = 1;
			var deltaX:int = -1;
			if(startPosY==1){
				bigDeltaY = 1;
				deltaY = -1;
			}
			if(startPosX==1){
				deltaX = 1;
			}
			//tiles to scan in a line
			var lim:int = 1;
			var pointsToFind:int = 10;
			//trace("startPos: "+startPosX+" "+startPosY+" bigdeltaY:"+bigDeltaY+" deltas:"+deltaX+" "+deltaY);
			while(emptyPoints.length<pointsToFind){
				var sx:int = startPosX;
				var sy:int = startPosY+((lim-1)*bigDeltaY);
				//abort if scanning further than half of the level
				if(sy==map.length||sy==0){
					break;
				}
				//trace(sx+" "+sy);
				for(var i:int = 0;i<lim;i++){
					//trace(sx+" "+sy+" "+i);
					if(map[sy][sx]==0){
						emptyPoints.push(new Point(sx,sy));
					}
					sx+=deltaX;
					sy+=deltaY;
				}
				lim+=1;
			}
			return emptyPoints;
		}

		function straightExitSearch(startPosX:int,startPosY:int):Array{
			//delta in each line (scanning sqaure to square)
			var deltaX:int;
			var deltaY:int;
			//delta of each line (scanning line to line)
			var bigDeltaX:int;
			var bigDeltaY:int;
			var lim:int;
			if(map[0].length>map.length){
				//search left-right
				bigDeltaY = 0;
				deltaX = 0;
				lim = map.length-2;
				if(startPosX==1){
					bigDeltaX = 1;
				}else{
					bigDeltaX = -1;
				}
				if(startPosY==1){
					deltaY = 1;
				}else{
					deltaY = -1;
				}
			}else{
				//search up-down
				lim = map[0].length-2;
				bigDeltaX = 0;
				deltaY = 0;
				if(startPosY==1){
					bigDeltaY = 1;
				}else{
					bigDeltaY = -1;
				}
				if(startPosX==1){
					deltaX = 1;
				}else{
					deltaX = -1;
				}
			}
			
			var emptyPoints:Array = new Array();
			var pointsToFind:int = 10;
			var sx:int = startPosX;
			var sy:int = startPosY;
			while(emptyPoints.length<pointsToFind){
				var sx2:int = sx;
				var sy2:int = sy;
				for(var i:int = 0;i<lim;i++){
					trace(sx2+" "+sy2);
					if(map[sy2][sx2]==0){
						emptyPoints.push(new Point(sx2,sy2));
					}
					sx2+=deltaX;
					sy2+=deltaY;
				}
				sx+=bigDeltaX;
				sy+=bigDeltaY;
			}
			return emptyPoints;
		}

		function initializeLevel() {
			if (walls!=null) {
				if (scene.contains(walls)) {
					scene.removeChild(walls);
				}
			}
			if (scene.contains(player)) {
				scene.removeChild(player);
			}

			walls = new MovieClip();
			var wallsNumber:int = 0;	
			var emptyNumber:int = 0;
			var totalNumber:int = (map.length-1)*(map[0].length-1);//no borders
			var ratio:Number;
			var wy:int;
			var wx:int;
			var tileData:int;
			for (wy=0; wy<map.length; wy++) {//iterate map
				for (wx=0; wx<map[0].length; wx++) {//iterate arrays inside map
					tileData = map[wy][wx];
					if (tileData==1) {
						/*
						var wall:Wall = new Wall();
						wall.x = wx * tileSize;
						wall.y = wy * tileSize;
						walls.addChild(wall);
						*/
						wallsNumber++;
					} else if (tileData==2) {
						player.x = wx * tileSize + tileSize / 2;
						player.y = wy * tileSize + tileSize / 2;
						emptyNumber++;
					}else{
						emptyNumber++;
					}
				}
			}
			ratio = emptyNumber/wallsNumber*100;
			trace("Map total(no borders):"+totalNumber+" walls(with borders):"+wallsNumber+" empty:"+emptyNumber+" ratio:"+ratio);
			
			var minimalRatio:int = 30;
			//maximalRatio may be impossible due to the algorithm
			//not being able to clear out that much space
			var maximalRatio:int = 90;
			
			if(ratio<minimalRatio){
				generateLevel();
				initializeLevel();
				return;
			}		
			//just in case
			if(ratio>maximalRatio){
				generateLevel();
				initializeLevel();
				return;
			}
						
			makeExit(ox,oy);
			
			//center screen on player
			offsetX = sceneWidth / 2 - player.x;
			offsetY = sceneHeight / 2 - player.y;
			//player.x = sceneWidth / 2 - player.width / 2;
			//player.y =sceneHeight / 2 - player.height / 2;
			fixPlayerPos();
			walls.x = offsetX;
			walls.y = offsetY;
			scene.addChild(walls);
			scene.addChild(player);
			
			
			//place walls in wallsLayer and wallsArray
			//get offset converted to map coordinates mx, my ,mx2, my2	
			var wallsArray:Array = new Array();
			main.wallsArray = wallsArray;

			var offsetMapCoordinates:Array = main.getMapCoordinates(-offsetX,-offsetY);
			var mx:int = offsetMapCoordinates[1];
			var my:int = offsetMapCoordinates[0];
			var mx2:int = mx+(main.sceneWidth/tileSize)+1;
			var my2:int = my+(main.sceneHeight/tileSize)+1;
			//don't go outside map borders, yet keep the size of array constant
			var addX:Boolean = false;
			var addY:Boolean = false;
			if(mx2>map[0].length){
				mx2=map[0].length;
				addX = true;
			}
			if(my2>map.length){
				my2=map.length;
				addY = true;
			}
			//trace(offsetX+" "+offsetY);
			//trace(mx+" "+my+" "+mx2+" "+my2);
			//current position whilst iterating wallsArray ax, ay
			var ax:int = 0;
			var ay:int = 0;
			for (wy=my; wy<my2; wy++) {//iterate map, wy
				wallsArray.push(new Array());
				for (wx=mx; wx<mx2; wx++) {//iterate arrays inside map, wx
					//trace(wx+" "+wy);
					tileData = map[wy][wx];
					main.addTile(wx*tileSize,wy*tileSize,tileData,ax,ay);
					ax++;
				}
				if(addX){
					wallsArray[ay][ax] = null;
				}
				ay++;
				ax = 0;
			}
			if(addY){
				wallsArray.push(new Array());
				for(var i:int = 0;i<wallsArray[0].length;i++){
					wallsArray[ay][i]= null;
				}
			}
			for each(var a:Array in wallsArray){
				for each(var w in a){
					if(w!=null){
						walls.addChild(w);
					}
				}
			}
			
			main.player = player;
			main.wallsLayer = walls;
			main.wallsArray = wallsArray;
			main.map = map;
			main.offsetX = offsetX;
			main.offsetY = offsetY;
		}
		
		function fixPlayerPos(){
			var mapPosX:int = player.x;
			var mapPosY:int = player.y;
			var screenMidX:int = sceneWidth / 2 - player.width / 2;
			var screenMidY:int = sceneHeight / 2 - player.height / 2;
			var viewBorderX:int = map[0].length*tileSize-(screenMidX+player.width);
			var viewBorderY:int = map.length*tileSize-(screenMidY+player.height);
			if(mapPosX<screenMidX){
				//fix walls on screen position x = 0
				offsetX = 0;
				player.x-=player.width/2;
			}else if(mapPosX>viewBorderX){
				offsetX = -viewBorderX+screenMidX;
				player.x+=offsetX-player.width/2;
			}else{
				player.x = screenMidX;
			}
			if(mapPosY<screenMidY){
				offsetY = 0;
				player.y-=player.height/2;
			}else if(mapPosY>viewBorderY){
				offsetY = -viewBorderY+screenMidY;
				player.y+=offsetY-player.height/2;
			}else{
				player.y = screenMidY;
			}
		}

	}
	
}
