package
{
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import levels.Level1;
	
	/**
	 * ...
	 * @author Jan Burak
	 */
	public class GameplayScreen extends MovieClip
	{
		
		public var player:Player;
		public var gameTimer:Timer;
		public var screenWidth:int;
		public var screenHeight:int;
		public var level:Level;
		public const blockSize:int = 30;
		public const gravity:Number = 0.8;
		
		public var leftHeld:Boolean = false;
		public var rightHeld:Boolean = false;
		public var jumpHeld:Boolean = false;
		
		public function GameplayScreen(sW:int, sH:int)
		{
			screenWidth = sW;
			screenHeight = sH;
			
			player = new Player();
			player.x = 50;
			player.y = 120;
			addChild(player);
			
			level = new Level1();
			level.init();
			addChild(level);
			
			gameTimer = new Timer(20);
			gameTimer.addEventListener(TimerEvent.TIMER, onTick);
			gameTimer.start();
		}
		
		private function onTick(timerEvent:TimerEvent):void
		{
			handleMovement();
		
		}
		
		private function handleMovement():void
		{
			var newX:Number = player.x;
			var newY:Number = player.y;
			
			if (rightHeld == true && leftHeld == false)
			{
				newX = player.velocityX + player.x;
			}
			else if (leftHeld == true && rightHeld == false)
			{
				newX = -player.velocityX + player.x;
			}
			if (player.inAir == true)
			{
				newY = player.y + player.velocityY;
				if (player.velocityY < 30)
					player.velocityY = player.velocityY + gravity;
			}
			else if (jumpHeld == true)
			{
				player.inAir = true;
				player.velocityY = player.jumpVelocity;
			}
			
			var newY2:Number = newY + player.playerHeight;
			var newX2:Number = newX + player.playerWidth;
			
			var newPosY:int = Math.floor(newY + 0.1) / blockSize;
			var newPosX:int = Math.floor(newX + 0.1) / blockSize;
			var newPosY2:int = Math.floor(newY2 - 0.1) / blockSize;
			var newPosX2:int = Math.floor(newX2 - 0.1) / blockSize
			
			var oldPosY:int = Math.floor(player.y + 0.1) / blockSize;
			var oldPosX:int = Math.floor(player.x + 0.1) / blockSize;
			var oldPosY2:int = Math.floor(player.y + player.playerHeight - 0.1) / blockSize;
			var oldPosX2:int = Math.floor(player.x + player.playerWidth - 0.1) / blockSize;
			
			var moveX:Boolean = true;
			var moveY:Boolean = true;
			var luCol:Boolean = level.rows[newPosY][newPosX] == 1;
			var ldCol:Boolean = level.rows[newPosY2][newPosX] == 1;
			var ruCol:Boolean = level.rows[newPosY][newPosX2] == 1;
			var rdCol:Boolean = level.rows[newPosY2][newPosX2] == 1;
			
			var leCol:Boolean = luCol && ldCol;
			var reCol:Boolean = ruCol && rdCol;
			var deCol:Boolean = ldCol && rdCol;
			var ueCol:Boolean = luCol && ruCol;
			
			//trace("in air: " + player.inAir);
			
			//check 1D movements only
			if (newY == player.y)
			{ //check x movement only
				moveY = false;
				if (newX > player.x)
				{
					if (reCol)
						moveX = false;
				}
				else if (newX < player.x)
				{
					if (leCol)
						moveX = false;
				}
				//fall if no ground below
				if (level.rows[newPosY2 + 1][newPosX] == 0 && level.rows[newPosY2 + 1][newPosX2] == 0 && player.jump == false) {
				//trace("a");	
					player.inAir = true;
				}
				
			}
			else if (newX == player.x)
			{ //check y movement only
				moveX = false;
				if (newY > player.y)
				{
					if (ldCol || rdCol){
						moveY = false;
						player.inAir = false;
						player.velocityY = 0;
						player.y = newPosY * blockSize;
					}
				}
				else if (newY < player.y)
				{
					if (luCol || ruCol)
						moveY = false;
				}
			}
			
			//check 2D movements
			if (moveY && moveX)
			{
				//trace("1");
				//1. check for both newX and newY
				if (ldCol || rdCol || ruCol || luCol)
				{
					//trace("2");
					//2. if collides, check for newX only, change all collide booleans to oldY
					luCol = level.rows[oldPosY][newPosX] == 1;
					ldCol = level.rows[oldPosY2][newPosX] == 1;
					ruCol = level.rows[oldPosY][newPosX2] == 1;
					rdCol = level.rows[oldPosY2][newPosX2] == 1;
					if (newX > player.x)
					{
						if (ruCol || rdCol)
							moveX = false;
					}
					else if (newX < player.x)
					{
						if (luCol || ldCol)
							moveX = false;
					}
					//3. if x collides, check for newX only, change all collide booleans to oldX
					if (moveX == false)
					{
						//trace("3");
						luCol = level.rows[newPosY][oldPosX] == 1;
						ldCol = level.rows[newPosY2][oldPosX] == 1;
						ruCol = level.rows[newPosY][oldPosX2] == 1;
						rdCol = level.rows[newPosY2][oldPosX2] == 1;
						if (newY > player.y)
						{
							if (ldCol || rdCol){
								moveY = false;
								player.inAir = false;
								player.velocityY = 0;
								player.y = newPosY * blockSize;
								//trace("4");
							}
						}
						else if (newY < player.y)
						{
							if (luCol || ruCol)
								moveY = false;
								//trace("4");
						}
						//4. if y collides, don't move
					}else {
						moveY = false;
					}
				}
					
			}
			
			if (moveX){
				player.x = newX;
				//
					if (newX > screenWidth / 2) {
						//level.x = (screenWidth / 2)-player.x;
						//trace(level.x);
					}
				//
			}
			else if (newX != player.x)
			{ //align to block
				if (newX > player.x)
				{
					player.x = newPosX * blockSize;
				}
				else if (newX < player.x)
				{
					player.x = (newPosX * blockSize) + blockSize;
				}
			}
			
			if (moveY)
				player.y = newY;
			else if (newY != player.y)
			{ //align to block
				if (newY > player.y)
				{
					player.y = newPosY * blockSize;
					player.inAir = false;
					player.velocityY = 0;
				}
				else if (newY < player.y)
				{
					player.y = (newPosY * blockSize) + blockSize;
					player.velocityY = 0;
				}
			}
			
		}
		
		public function keyDownHandler(evt:KeyboardEvent):void
		{
			if ((evt.keyCode == 37) || (evt.keyCode == 65))
			{
				//move left
				leftHeld = true;
			}
			else if ((evt.keyCode == 39) || (evt.keyCode == 68))
			{
				//move right
				rightHeld = true;
			}
			
			if ((evt.keyCode == 38) || (evt.keyCode == 87))
			{
				//jump
				jumpHeld = true;
			}
		}
		
		public function keyUpHandler(evt:KeyboardEvent):void
		{
			if ((evt.keyCode == 37) || (evt.keyCode == 65))
			{
				//move left
				leftHeld = false;
			}
			else if ((evt.keyCode == 39) || (evt.keyCode == 68))
			{
				//move right
				rightHeld = false;
			}
			
			if ((evt.keyCode == 38) || (evt.keyCode == 87))
			{
				//jump
				jumpHeld = false;
			}
		}
	
	}

}