package classes{
	import flash.display.MovieClip;
	import classes.*;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.MouseEvent;

	public class Main {

		var map:Array = new Array();
		var wallsLayer:MovieClip;
		var wallsArray:Array;
		var player:Player = new Player();

		//distance of walls from player position (player.x-walls.x)
		var offsetX:int = 0;
		var offsetY:int = 0;
		var deltaOffsetX:int = 0;
		var deltaOffsetY:int = 0;

		var tileSize:int = 50;
		
		var levelSize:int = 20;
		public var currentlyGenerating:Boolean = false;

		public var scene:MovieClip;
		var overlayScreen:MovieClip;
		var sceneWidth:int = 600;
		var sceneHeight:int = 500;
		
		var timeScore:Number = 0;
		var lastTime:Number;
		var timerFrame:TimerFrame;

		var speed:Number = 15;
		var moveRight:Boolean = false;
		var moveUp:Boolean = false;
		var moveLeft:Boolean = false;
		var moveDown:Boolean = false;

		public function Main(scene:MovieClip) {
			this.scene = scene;
			overlayScreen = new StartScreen(this);
			scene.addChild(overlayScreen);
		}
		
		//start the gameplay
		public function startGame(evt:MouseEvent){
			scene.removeChild(overlayScreen);
			scene.stage.focus = scene.stage;
			
			var lg:LevelGenerator = new LevelGenerator(player,wallsLayer,scene,this);
			lg.run(levelSize);
			lastTime = new Date().time;
			
			timerFrame = new TimerFrame();
			scene.addChild(timerFrame);
			timerFrame.y = sceneHeight-timerFrame.height;

			scene.stage.addEventListener(KeyboardEvent.KEY_DOWN, pressKey);
			scene.stage.addEventListener(KeyboardEvent.KEY_UP, releaseKey);
			scene.addEventListener(Event.ENTER_FRAME,loop);
		}

		public function loop(evt:Event) {
			if(currentlyGenerating){
				return;
			}
			
			//change the offsetX and offsetY values
			//in relation to keyboard presses
			movePlayer();
			managePOV();
			
			timeScore+=new Date().time-lastTime;
			lastTime = new Date().time;
			var milliseconds:int = timeScore%1000;
			var seconds:int = (timeScore/1000)%60;
			var minutes:int = timeScore/60000;
			var milString:String;
			var secString:String;
			var minString:String;
			if(milliseconds>99){
				milString = ""+milliseconds;
			}else if(milliseconds>9){
				milString = "0"+milliseconds;
			}else{
				milString = "00"+milliseconds;
			}
			if(seconds>9){
				secString = ""+seconds;
			}else{
				secString = "0"+seconds;
			}
			if(minutes>9){
				minString = ""+minutes;
			}else{
				minString = "0"+minutes;
			}
			timerFrame.timerField.text = minString+":"+secString+":"+milString;
		}
		
		//change the offsetX and offsetY values
		// in relation to keyboard presses
		function movePlayer(){
			//players four corners
			var px:Number = player.x - offsetX;
			var px2:Number = px + player.width;
			var py:Number = player.y - offsetY;
			var py2:Number = py + player.height;
			//trace(px+" "+py);
			//set up the variables used for collisions because this isn't Java
			var ul:Array = getMapCoordinates(px,py);
			var ur:Array = getMapCoordinates(px2,py);
			var ll:Array = getMapCoordinates(px,py2);
			var lr:Array = getMapCoordinates(px2,py2);;
			var ulData:int;
			var urData:int;
			var llData:int;
			var lrData:int;
			
			var advanceLevel:Boolean = false;

			var currentSpeed:Number = speed;
			if ((moveUp||moveDown)&&(moveLeft||moveRight)) {
				currentSpeed *=  Math.SQRT1_2;
				
				//check collisions separately for diagonals
			}

			if (moveUp) {
				py -=  currentSpeed;
				//upper left and upper right corner coordinates
				ul = getMapCoordinates(px,py);
				ur = getMapCoordinates(px2,py);
				ulData = map[ul[0]][ul[1]];
				urData = map[ur[0]][ur[1]];
				if (ulData != 1 && urData != 1) {
					if (ulData == 3 || urData == 3) {
						advanceLevel = true;
					}
					deltaOffsetY =  currentSpeed;
				} else {
					//set the offset almost at the collision border
					ll = getMapCoordinates(px,py2);
					deltaOffsetY = -(offsetY - (player.y - ll[0] * tileSize - 1));
				}
				py +=  currentSpeed;
			} else if (moveDown) {
				py2 +=  currentSpeed;
				//lower left and lower right corner coordinates
				ll = getMapCoordinates(px,py2);
				lr = getMapCoordinates(px2,py2);
				llData = map[ll[0]][ll[1]];
				lrData = map[lr[0]][lr[1]];
				if (llData != 1 && lrData != 1) {
					if (llData == 3 || lrData == 3) {
						advanceLevel = true;
					}
					deltaOffsetY =  -currentSpeed;
				} else {
					//set the offset almost at the collision border
					deltaOffsetY = -(offsetY - (player.y - ll[0] * tileSize + player.height + 1));
				}
				py2 -=  currentSpeed;
			}
			if (moveRight) {
				px2 +=  currentSpeed;
				//lower right and upper right corner coordinates
				lr = getMapCoordinates(px2,py2);
				ur = getMapCoordinates(px2,py);
				lrData = map[lr[0]][lr[1]];
				urData = map[ur[0]][ur[1]];
				if (urData != 1 && lrData != 1) {
					if (urData == 3 || lrData == 3) {
						advanceLevel = true;
					}
					deltaOffsetX =  -currentSpeed;
				} else {
					//set the offset almost at the collision border
					deltaOffsetX = -(offsetX - (player.x - ur[1] * tileSize + player.width + 1));
				}
				px2 -=  currentSpeed;
			} else if (moveLeft) {
				px -=  currentSpeed;
				//lower left and upper left corner coordinates
				ll = getMapCoordinates(px,py);
				ul = getMapCoordinates(px2,py);
				llData = map[ll[0]][ll[1]];
				ulData = map[ul[0]][ul[1]];
				if (llData != 1 && ulData != 1) {
					if (llData == 3 || ulData == 3) {
						advanceLevel = true;
					}
					deltaOffsetX =  currentSpeed;
				} else {
					//set the offset almost at the collision border
					ur = getMapCoordinates(px2,py);
					deltaOffsetX = -(offsetX - (player.x - ur[1] * tileSize - 1));
				}
				px +=  currentSpeed;
			}
			
			if(advanceLevel){
				changeLevel();
			}
		}
		
		//manage point of view
		function managePOV(){
			//players position in relation to walls
			var mapPosX:int = player.x - (offsetX+deltaOffsetX);
			var mapPosY:int = player.y - (offsetY+deltaOffsetY);
			var screenMidX:int = sceneWidth / 2 - player.width / 2;
			var screenMidY:int = sceneHeight / 2 - player.height / 2;
			var viewBorderX:int = map[0].length*tileSize-(screenMidX+player.width);
			var viewBorderY:int = map.length*tileSize-(screenMidY+player.height);
			if(mapPosX<screenMidX){
				//move player in relation to screen
				player.x -= deltaOffsetX;
				//fix walls on screen position x = 0
				offsetX = 0;
			}else if(mapPosX>viewBorderX){
				player.x -= deltaOffsetX;
				offsetX = -viewBorderX+screenMidX;
			}else{
				player.x = screenMidX;
				offsetX += deltaOffsetX;
			}
			if(mapPosY<screenMidY){
				player.y -= deltaOffsetY;
				offsetY = 0;
			}else if(mapPosY>viewBorderY){
				player.y -= deltaOffsetY;
				offsetY = -viewBorderY+screenMidY;
			}else{
				player.y = screenMidY;
				offsetY += deltaOffsetY;
			}
			manageWallsChildren(wallsLayer.x,wallsLayer.y);
			wallsLayer.y = offsetY;
			wallsLayer.x = offsetX;
			deltaOffsetX = 0;
			deltaOffsetY = 0;
			
		}
		
		//removes walls outside of screen borders
		//and adds the new ones
		function manageWallsChildren(oldOffsetX:int,oldOffsetY:int){
			//convert offsets to array positions
			//these values represent the leftmost and upmost visible walls 
			//on screen in accordance to the map array
			var oldOffsetMapCoordinates:Array = getMapCoordinates(-oldOffsetX,-oldOffsetY);
			var omx:int = oldOffsetMapCoordinates[1];
			var omy:int = oldOffsetMapCoordinates[0];
			var newOffsetMapCoordinates:Array = getMapCoordinates(-offsetX,-offsetY);
			var nmx:int = newOffsetMapCoordinates[1];
			var nmy:int = newOffsetMapCoordinates[0];	
			//trace(omx+" "+omy+" "+nmx+" "+nmy);
			
			if(nmx==omx&&nmy==omy)return;
			//trace("---");
			
			/*
			var a2:Array;
			var w2:Wall;			
			for each(a2 in wallsArray){
				trace(a2);
			}*/
			
			var i:int;
			var j:int;
			//delta
			var d:int;	
			//remove walls
			if(nmx!=omx){
				d = nmx-omx;
				//moved right
				if(d>0){
					//trace("go right, remove left");
					for(i = 0;i<d;i++){//x
						for(j = 0;j<wallsArray.length;j++){//y
							if(wallsArray[j][i]!=null){
								wallsLayer.removeChild(wallsArray[j][i]);
								wallsArray[j][i] = null;
							}
						}
					}
				}else{//moved left
					//trace("go left, remove right");
					for(i = wallsArray[0].length+d;i<wallsArray[0].length;i++){//x
						for(j = 0;j<wallsArray.length;j++){//y
							if(wallsArray[j][i]!=null){
								wallsLayer.removeChild(wallsArray[j][i]);
								wallsArray[j][i] = null;
							}
						}
					}
				}
			}
			if(nmy!=omy){
				d = nmy-omy;
				//moved down, remove upper side
				if(d>0){
					//trace("go down, remove upper");
					for(i = 0;i<d;i++){//y
						for(j = 0;j<wallsArray[0].length;j++){//x
							if(wallsArray[i][j]!=null){
								wallsLayer.removeChild(wallsArray[i][j]);
								wallsArray[i][j] = null;
								//trace(j+" "+i);
							}
						}
					}
				}else{//moved up, remove lower side
					//trace("go up, remove lower");
					for(i = wallsArray.length+d;i<wallsArray.length;i++){//y
						for(j = 0;j<wallsArray[0].length;j++){//x
							if(wallsArray[i][j]!=null){
								if(wallsLayer.contains(wallsArray[i][j]))wallsLayer.removeChild(wallsArray[i][j]);
								wallsArray[i][j] = null;
								//trace(j+" "+i);
								//trace(wallsArray[i][j]);
							}
						}
					}
				}
			}
			
			//shift array
			var xlim:int;
			var ylim:int;
			if(nmx!=omx){
				d = nmx-omx;
				//moved right, shift left
				if(d>0){
					//trace("shift left");
					xlim = wallsArray[0].length-1;
					for(i = 0;i<xlim;i++){//x
						for(j = 0;j<wallsArray.length;j++){//y
							//trace(i+" "+j);
							wallsArray[j][i] = wallsArray[j][i+1];
						}
					}
				}else{//moved left, shift right
					//trace("shift right");
					for(i = wallsArray[0].length-1;i>0;i--){//x
						for(j = 0;j<wallsArray.length;j++){//y
							//trace(i+" "+j);
							wallsArray[j][i] = wallsArray[j][i-1];
						}
					}
				}
			}
			if(nmy!=omy){
				d = nmy-omy;
				//moved down, shift up
				if(d>0){
					//trace("shift up");
					ylim = wallsArray.length-1;
					for(i = 0;i<ylim;i++){//y
						wallsArray[i] = wallsArray[i+1];
						//trace("shift "+(i+1)+" to "+i);
					}
				}else{//moved up, shift down
					//trace("shift down");
					for(i = wallsArray.length-1;i>0;i--){//y
						wallsArray[i] = wallsArray[i-1];
						//trace("shift "+(i-1)+" to "+i);
					}
				}
			}
			
			//add new walls to array
			var wy:int;
			var wx:int;
			var ax:int;
			var ay:int;
			var tileData:int;
			var wall:Wall;
			var nmy2:int = nmy+wallsArray.length;
			var nmx2:int = nmx+wallsArray[0].length;
			if(nmy2>map.length){
				//trace("nmy2 lim");
				nmy2=map.length;
				
			}
			if(nmx2>map[0].length){
				//trace("nmx2 lim");
			}
			if(nmx!=omx){
				d = nmx-omx;
				//moved right, add to right side
				if(d>0){
					//trace("add to right");
					ax = wallsArray[0].length-d;
					ay = 0;
					for (wy=nmy; wy<nmy2; wy++) {//iterate map, wy
						for (wx=nmx2-d; wx<nmx2; wx++) {//iterate arrays inside map, wx
							//trace(wx+" "+wy);
							tileData = map[wy][wx];
							addTile(wx * tileSize,wy * tileSize,tileData,ax,ay);
							ax++;
						}
						ay++;
						ax = wallsArray[0].length-d;
					}
				}else{//moved left, add to left side
					//trace("add to left");
					ax = 0;
					ay = 0;
					for (wy=nmy; wy<nmy2; wy++) {//iterate map, wy
						for (wx=nmx; wx<nmx-d; wx++) {//iterate arrays inside map, wx
							//trace(wx+" "+wy);
							tileData = map[wy][wx];
							addTile(wx * tileSize,wy * tileSize,tileData,ax,ay);
							ax++;
						}
						ay++;
						ax = 0;
					}
				}
			}
			if(nmy!=omy){
				d = nmy-omy;
				//moved down, add to lower side
				if(d>0){
					//trace("add to lower");
					ax = 0;
					ay = wallsArray.length-d;
					for (wy=nmy2-d; wy<nmy2; wy++) {//iterate map, wy
						wallsArray[ay] = new Array();
						for (wx=nmx; wx<nmx2; wx++) {//iterate arrays inside map, wx
							//trace(wx+" "+wy);
							tileData = map[wy][wx];
							addTile(wx * tileSize,wy * tileSize,tileData,ax,ay);
							ax++;
						}
						ay++;
						ax = 0;
					}
				}else{//moved up, add to upper side
					//trace("add to upper");
					ax = 0;
					ay = 0;
					for (wy=nmy; wy<nmy-d; wy++) {//iterate map, wy
						wallsArray[ay] = new Array();
						for (wx=nmx; wx<nmx2; wx++) {//iterate arrays inside map, wx
							//trace(wx+" "+wy);
							tileData = map[wy][wx];
							addTile(wx * tileSize,wy * tileSize,tileData,ax,ay);
							ax++;
						}
						ay++;
						ax = 0;
					}
				}
			}
			
			for each(var a:Array in wallsArray){
				for each(var w in a){
					if(w!=null){
					   if(!wallsLayer.contains(w)){
						 wallsLayer.addChild(w);
						}
					}
				}
			}
		}
		
		//advance to the next level and increase level size by 2 (width and height)
		function changeLevel(){
			if(levelSize==38){
				finishGame();
				return;
			}
			levelSize+=2
			
			moveLeft = false;
			moveRight = false;
			moveUp = false;
			moveDown = false;
			
			var lg:LevelGenerator = new LevelGenerator(player,wallsLayer,scene,this);
			lg.run(levelSize);
			
			scene.setChildIndex(timerFrame,1);
		}
		
		function finishGame(){
			scene.removeEventListener(Event.ENTER_FRAME,loop);
			scene.removeChild(timerFrame);
			scene.removeChild(wallsLayer);
			scene.removeChild(player);
					
			overlayScreen = new FinishScreen(this);
			scene.addChild(overlayScreen);
		}
		
		public function addTile(tx:int, ty:int, tileData:int, ax:int, ay:int){
			var tile;
			if(tileData==1){
				tile = new Wall();
				tile.x = tx;
				tile.y = ty;
				wallsArray[ay][ax] = tile;
			}else if(tileData==3){
				tile = new Exit();
				tile.x = tx;
				tile.y = ty;
				wallsArray[ay][ax] = tile;
			}else{
				wallsArray[ay][ax] = null;
			}
		}

		//Returns an array containing x and y coordinates of the map array
		//the first value is y value, corresponds to first value in map array
		public function getMapCoordinates(ax:Number,ay:Number):Array {
			//position of ax and ay if the offset was 0
			var px:Number = ax - offsetX;
			var py:Number = ay - offsetY;

			//coordinates
			var cx:int = Math.floor(ax/tileSize);
			var cy:int = Math.floor(ay/tileSize);
			
			return new Array(cy,cx);
		}

		public function pressKey(evt:KeyboardEvent) {
			if(currentlyGenerating){
				trace("a");
				return;
			}
			var k:int = evt.keyCode;
			//L37 U38 R39 D40
			//W87 A65 S68 D83
			if (k==87||k==38) {
				moveUp = true;
			} else if (k==65||k==37) {
				moveLeft = true;
			} else if (k==68||k==40) {
				moveDown = true;
			} else if (k==83||k==39) {
				moveRight = true;
			}

		}

		public function releaseKey(evt:KeyboardEvent) {
			var k:int = evt.keyCode;
			//L37 U38 R39 D40
			//W87 A65 S68 D83
			if (k==87||k==38) {
				moveUp = false;
			} else if (k==65||k==37) {
				moveLeft = false;
			} else if (k==68||k==40) {
				moveDown = false;
			} else if (k==83||k==39) {
				moveRight = false;
			} else if (k==13) {
				//var lg:LevelGenerator = new LevelGenerator(player,wallsLayer,scene,this);
				//lg.run(levelSize);
			}

		}

	}

}