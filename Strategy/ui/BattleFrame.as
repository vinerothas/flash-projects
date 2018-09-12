package ui{

	import flash.display.MovieClip;
	import zones.Zone;
	import flash.events.MouseEvent;


	public class BattleFrame extends ActiveFrame {

		var playerArmies:Array = new Array();
		var enemyArmies:Array = new Array();
		var zone:Zone;
		var phase:int = 1;
		var relatedOrders:Array = new Array();
		var enemyZone:Zone;
		//maneuvers and flanking
		var playerAdvantage:Number = 1;
		var enemyAdvantage:Number = 1;
		var buttons:Array = new Array();
		var tactics:Array = new Array();
		var depiction:String;
		
		var playerTroops:Army = new Army();
		var enemyTroops:Army = new Army();
		
		var sf1:SoldierFields;
		var sf2:SoldierFields;

		public function BattleFrame(uI:UI) {
			super(uI,null);
			exitButton.visible = false;
			
			depictionField.text = " ";
			
			var armyOrders:Array = uI.main.armyOrders;
			var order:ArmyOrder = armyOrders[0];
			relatedOrders.push(order);
			playerArmies = playerArmies.concat(order.armies);
			enemyZone = order.toZone;
			for (var i:int = 1; i<armyOrders.length; i++) {
				if (armyOrders[i].toZone == order.toZone) {
					relatedOrders.push(armyOrders[i]);
					playerArmies = playerArmies.concat(armyOrders[i].armies);
					playerAdvantage+=0.1;
				}
			}	
			
			if(playerAdvantage>enemyAdvantage){
				depictionField.text = " We are flanking the enemy.";
			}else if(playerAdvantage<enemyAdvantage){
				depictionField.text = " The enemy is flanking us.";
			}
			
			//zobaczyc czy nie da sie tego zrobic lepiej z normalnym for loop zamiast while
			var removed:int = 0;
			while(removed!=relatedOrders.length){
				for each(var order2:ArmyOrder in armyOrders){
					if(relatedOrders.indexOf(order2)!=-1){
						armyOrders.splice(armyOrders.indexOf(order2),1);
						removed++;
						break;
					}
				}
			}
			
			for each(var a:Army in enemyZone.armies){
				enemyArmies.push(a);
			}
			enemyArmies.push(enemyZone.garrison);
			
			for each(var army:Army in playerArmies){
				playerTroops.addToArmy(army.s);
			}
			for each(army in enemyArmies){
				enemyTroops.addToArmy(army.s);
			}
			
			printOutTroops();
			
			//tactics buttons
			tactics.push("Skirmish","Charge","Maneuver","Defend","Retreat","Flee");
			var by:int = 325;
			for each(var string:String in tactics){
				var sb:SmallButton = new SmallButton();
				sb.y = by;
				sb.inner.width = 100;
				sb.textField.width = 100;
				sb.x = 350;
				by+=sb.height;
				sb.textField.text = string;
				addChild(sb);
				sb.addEventListener(MouseEvent.CLICK,fight);
				buttons.push(sb.inner);
			}
		}
		
		public function printOutTroops(){
			//print out player soldiers
			if(sf1!=null)removeChild(sf1);
			sf1 = new SoldierFields();
			sf1.initAll(playerTroops);
			sf1.x = 125;
			sf1.y = 325;
			addChild(sf1);	
			
			//print out enemy soldiers
			if(sf2!=null)removeChild(sf2);
			sf2 = new SoldierFields();
			sf2.x = 550;
			sf2.y = 325;
			addChild(sf2);	
			sf2.initAll(enemyTroops);
		}
		
		public function printOutPhase(){
			var string:String = "XV";
			if(phase==1){
				string = "I";
			}else if(phase==2){
				string = "II";
			}else if(phase==3){
				string = "III";
			}else if(phase==4){
				string = "IV";
			}else if(phase==5){
				string = "V";
			}else if(phase==6){
				string = "VI";
			}else if(phase==7){
				string = "VII";
			}else if(phase==8){
				string = "VIII";
			}else if(phase==9){
				string = "IX";
			}else if(phase==10){
				string = "X";
			}else if(phase==11){
				string = "XI";
			}else if(phase==12){
				string = "XII";
			}else if(phase==13){
				string = "XIII";
			}else if(phase==14){
				string = "XIV";
			}
			phaseField.text = string;
		}
		
		public function fight(evt:MouseEvent){
			depiction = new String();
			
			var enemyTactic:String = rollEnemyTactic();
			var tactic:String;
			for each(var button in buttons){
				if(button == evt.target)tactic = tactics[buttons.indexOf(button)];
			}
			var playerAttack:int = getArmyAttack(playerTroops,tactic);
			var enemyAttack:int = getArmyAttack(enemyTroops,enemyTactic);
			var playerDef:int = getArmyDef(playerTroops,tactic);
			var enemyDef:int = getArmyDef(enemyTroops,enemyTactic);
			playerAttack = addTacticAttackBonus(playerAttack,tactic,enemyTactic)*playerAdvantage;
			enemyAttack = addTacticAttackBonus(enemyAttack,enemyTactic,tactic)*enemyAdvantage;
			playerDef = addTacticDefBonus(playerDef,tactic,enemyTactic)*playerAdvantage;
			enemyDef = addTacticDefBonus(enemyDef,enemyTactic,tactic)*enemyAdvantage;
			
			//part of soldiers that are dying in each phase
			var battlePace:Number = 0.1;
			var min:int = Math.min(enemyTroops.getTotal(),playerTroops.getTotal());
			if(min<1500){
				//battlePace is increased with 0.01 per 100 of min below 1500
				battlePace = (1500-min)/10000 + 0.1;
			}
			var playerLoss:Number = battlePace*(enemyAttack/playerDef)*playerTroops.getTotal();
			var enemyLoss:Number = battlePace*(playerAttack/enemyDef)*enemyTroops.getTotal();
			playerLoss*=((Math.random()*0.1)+0.95);
			enemyLoss*=((Math.random()*0.1)+0.95);
			playerLoss = Math.round(playerLoss);
			enemyLoss = Math.round(enemyLoss);	
			if(enemyLoss>enemyTroops.getTotal()){
				enemyLoss = enemyTroops.getTotal();
			}
			if(playerLoss>playerTroops.getTotal()){
				playerLoss = playerTroops.getTotal();
			}

			trace("Player attack: "+playerAttack+" Player def: "+playerDef+
				  " Player loss: "+playerLoss+"/"+playerTroops.getTotal()+" Advantage: "+playerAdvantage);
			trace("Enemy attack: "+enemyAttack+" Enemy def: "+enemyDef+
				  " Enemy loss: "+enemyLoss+"/"+enemyTroops.getTotal()+" Advantage: "+enemyAdvantage);
			trace("Pace: "+battlePace+" Min: "+min);
			trace();
			
			
			playerTroops.removeTotal(playerLoss);
			enemyTroops.removeTotal(enemyLoss);
					
			phase++;
			printOutPhase();			
			printOutTroops();
			
			depict(tactic,enemyTactic);
			if(playerLoss>1){
				depiction += "We lost "+playerLoss+" troops ";
			}else if(playerLoss==1){
				depiction += "We lost "+playerLoss+" soldier ";
			}else if(playerLoss==0){
				depiction += "We didn't lose any soldiers ";
			}
			if(enemyLoss>1){
				depiction += "and the enemy lost "+enemyLoss+" troops.";
			}else if(enemyLoss==1){
				depiction += "and the enemy lost "+enemyLoss+" soldiers.";
			}else if(enemyLoss==0&&playerLoss!=0){
				depiction += "and the enemy didn't lose any soldiers.";
			}else if(enemyLoss==0&&playerLoss==0){
				depiction += "and the enemy didn't lose any soldiers either.";
			}
			depictionField.text = depiction;
		}
		
		function rollEnemyTactic():String{
			var swordsmen:int = enemyTroops.s[Constants.swordsmanid];
			var archers:int = enemyTroops.s[Constants.archerid];
			var pikemen:int = enemyTroops.s[Constants.pikemanid];
			var horsemen:int = enemyTroops.s[Constants.horsemanid];
			var guardians:int = enemyTroops.s[Constants.guardianid];
			var top:int = Math.max(swordsmen,archers,pikemen,horsemen,guardians);
			
			var topTactic:String = "Skirmish";
			var topScore:int = 0;
			for each(var tactic:String in tactics){
				var score:int = getArmyAttack(enemyTroops,tactic)+getArmyDef(enemyTroops,tactic);
				if(score>topScore){
					topScore = score;
					topTactic = tactic;
				}
			}
			
			var topPlayerTactic:String = "Skirmish";
			topScore = 0;
			for each(tactic in tactics){
				score = getArmyAttack(playerTroops,tactic)+getArmyDef(playerTroops,tactic);
				if(score>topScore){
					topScore = score;
					topPlayerTactic = tactic;
				}
			}
			var counterTactic:String = getCounterTactic(topPlayerTactic);
			if(counterTactic == null)counterTactic = topTactic;
			
			var playerCounterTactic:String = getCounterTactic(topTactic);
			var ccTactic:String = getCounterTactic(playerCounterTactic);
			if(ccTactic==null)ccTactic = topTactic;
			
			var chosenTactic:String;
			var roll:Number = Math.random();
			if(roll<0.33)chosenTactic=ccTactic;
			else if(roll>0.67)chosenTactic=counterTactic;
			else chosenTactic = topTactic;
			if(roll>0.5)chosenTactic = ccTactic;
			else chosenTactic = topTactic;
			trace("Top: "+topTactic+" Counter: "+counterTactic+" CC: "+ccTactic);
			return chosenTactic;
		}
		
		//returns attack calculated with chosen tactic and troop bonuses
		function getArmyAttack(army:Army,tactic:String):Number{
			var swordsmen:int = army.s[Constants.swordsmanid];
			var archers:int = army.s[Constants.archerid];
			var pikemen:int = army.s[Constants.pikemanid];
			var horsemen:int = army.s[Constants.horsemanid];
			var guardians:int = army.s[Constants.guardianid];
			var sum:int = 0;
			
			if(tactic=="Skirmish"){
				archers*=1.25;
				swordsmen*=1.1;
				guardians*=1.1;
				sum = archers+swordsmen+pikemen+horsemen+guardians;
			}else if(tactic=="Charge"){
				archers*=0.8;
				guardians*=0.8;
				pikemen*=1.25;
				horsemen*=1.5;
				sum = archers+swordsmen+pikemen+horsemen+guardians;
				sum*=1.25;
			}else if(tactic=="Defend"){
				archers*=1.25;
				guardians*=1.5;
				pikemen*=1.1;
				horsemen*=0.8;
				sum = archers+swordsmen+pikemen+horsemen+guardians;
				sum*=0.5;
			}else if(tactic=="Retreat"){
				archers*=0.8;
				guardians*=1.1;
				horsemen*=0.8;
				sum = archers+swordsmen+pikemen+horsemen+guardians;
				sum*=0.5;
			}else if(tactic=="Maneuver"){
				archers*=1.25;
				horsemen*=1.5;
				sum = archers+swordsmen+pikemen+horsemen+guardians;
				sum*=0.5;
			}else if(tactic=="Flee"){	
				sum = archers+swordsmen+pikemen+horsemen+guardians;
				sum*=0.1;
			}
			return sum;
		}
		
		//returns def calculated with chosen tactic
		function getArmyDef(army:Army,tactic:String):Number{
			var swordsmen:int = army.s[Constants.swordsmanid];
			var archers:int = army.s[Constants.archerid];
			var pikemen:int = army.s[Constants.pikemanid];
			var horsemen:int = army.s[Constants.horsemanid];
			var guardians:int = army.s[Constants.guardianid];
			var sum:int = 0;
			
			if(tactic=="Skirmish"){
				//archers*=1.25;
				//swordsmen*=1.1;
				//guardians*=1.1;
				sum = archers+swordsmen+pikemen+horsemen+guardians;
			}else if(tactic=="Charge"){
				//archers*=0.8;
				//guardians*=0.8;
				//pikemen*=1.1;
				//horsemen*=1.25;
				sum = archers+swordsmen+pikemen+horsemen+guardians;
				sum*=0.75;
			}else if(tactic=="Defend"){
				//archers*=1.25;
				//guardians*=1.25;
				//pikemen*=1.1;
				//horsemen*=0.8;
				sum = archers+swordsmen+pikemen+horsemen+guardians;
				sum*=1.5;
			}else if(tactic=="Retreat"){
				//archers*=0.8;
				//guardians*=1.1;
				//horsemen*=0.8;
				sum = archers+swordsmen+pikemen+horsemen+guardians;
				sum*=0.75;
			}else if(tactic=="Maneuver"){
				//archers*=1.1;
				//horsemen*=1.25;
				sum = archers+swordsmen+pikemen+horsemen+guardians;
				sum*=0.75;
			}else if(tactic=="Flee"){	
				sum = archers+swordsmen+pikemen+horsemen+guardians;
				sum*=0.5;
			}
			return sum;
		}
		
		function addTacticAttackBonus(attack:int,tactic:String,enemyTactic:String):int{
			if(tactic=="Defend"){
				if(enemyTactic == "Retreat"){
					attack*=0.5;
				}else if(enemyTactic == "Charge"){
					attack*=1.5;
				}else if(enemyTactic == "Flee"){
					attack*=0.1;
				}else if(enemyTactic == "Maneuver"){
					attack*=0.5;
				}
			}else if(tactic=="Maneuver"){
				if(enemyTactic == "Retreat"){
					attack*=0.5;
				}else if(enemyTactic == "Charge"){
					attack*=0.75;
				}else if(enemyTactic == "Flee"){
					attack*=0.25;
				}
			}else if(tactic=="Charge"){
				if(enemyTactic == "Retreat"){
					attack*=1.5;
				}else if(enemyTactic == "Maneuver"){
					attack*=1.25;
				}else if(enemyTactic == "Flee"){
					attack*=2.0;
				}else if(enemyTactic == "Defend"){
					attack*=0.5;
				}
			}else if(tactic=="Skirmish"){
				if(enemyTactic == "Flee"){
					attack*=0.5;
				}
			}else if(tactic=="Retreat"){
				if(enemyTactic == "Charge"){
					attack*=0.75;
				}
			}else if(tactic=="Flee"){
				if(enemyTactic == "Charge"){
					attack*=0.5;
				}
			}
			return attack;
		}
		
		function addTacticDefBonus(def:int,tactic:String,enemyTactic:String):int{
			if(tactic=="Defend"){
				if(enemyTactic == "Charge"){
					def*=1.5;
				}
			}else if(tactic=="Maneuver"){
				if(enemyTactic == "Retreat"){
					def*=1.5;
				}else if(enemyTactic == "Charge"){
					def*=0.75;
				}else if(enemyTactic == "Flee"){
					def*=2.0;
				}else if(enemyTactic == "Defend"){
					def*=1.5;
				}
			}else if(tactic=="Charge"){
				if(enemyTactic == "Retreat"){
					def*=1.5;
				}else if(enemyTactic == "Charge"){
					def*=0.75;
				}else if(enemyTactic == "Flee"){
					def*=2.0;
				}else if(enemyTactic == "Defend"){
					def*=0.75;
				}
			}else if(tactic=="Retreat"){
				if(enemyTactic == "Maneuver"){
					def*=1.5;
				}else if(enemyTactic == "Charge"){
					def*=0.5;
				}else if(enemyTactic == "Defend"){
					def*=1.5;
				}
			}else if(tactic=="Flee"){
				if(enemyTactic == "Retreat"){
					def*=2.0;
				}else if(enemyTactic == "Charge"){
					def*=0.5;
				}else if(enemyTactic == "Flee"){
					def*=2.0;
				}else if(enemyTactic == "Maneuver"){
					def*=1.5;
				}else if(enemyTactic == "Defend"){
					def*=1.5;
				}
			}
			return def;
		}
		
		//returns null if no specific tactic
		function getCounterTactic(tactic:String):String{
			if(tactic=="Skirmish")return null;
			else if(tactic=="Defend")return "Maneuver";
			else if(tactic=="Charge")return "Defend";
			else if(tactic=="Maneuver")return "Charge";
			else if(tactic=="Retreat") return "Charge";
			else if(tactic=="Flee") return "Charge";
			else return null;
		}
		
		function depict(tactic:String,enemyTactic:String){
			if(tactic=="Skirmish"){
				if(enemyTactic=="Skirmish"){
					depiction+=" Both armies are fighting in a skirmish. ";
				}else if(enemyTactic=="Defend"){
					depiction+=" The enemy troops are defending themselves against our skirmish. ";
				}else if(enemyTactic=="Charge"){
					depiction+=" The enemy is charging at our skirmish. ";
				}else if(enemyTactic=="Maneuver"){
					depiction+=" The enemy is trying to outmaneuver our skirmish. ";
				}else if(enemyTactic=="Retreat"){
					depiction+=" The enemy is slowly retreating from our skirmish. ";
				}else if(enemyTactic=="Flee"){
					depiction+=" The enemy is fleeing from our skirmish. ";
				}
			}else if(tactic=="Defend"){
				if(enemyTactic=="Skirmish"){
					depiction+=" Our troops are defending themselves against enemy skirmish. ";
				}else if(enemyTactic=="Defend"){
					depiction+=" Both armies are fighting defensively. ";
				}else if(enemyTactic=="Charge"){
					depiction+=" The enemy is charging at our defensive position. ";
				}else if(enemyTactic=="Maneuver"){
					depiction+=" The enemy is outmaneuvering our defensive postition. ";
				}else if(enemyTactic=="Retreat"){
					depiction+=" The enemy is retreating away from our defending troops. ";
				}else if(enemyTactic=="Flee"){
					depiction+=" The enemy is fleeing from our defending troops. ";
				}
			}else if(tactic=="Charge"){
				if(enemyTactic=="Skirmish"){
					depiction+=" We are charging at the enemy skirmish. ";
				}else if(enemyTactic=="Defend"){
					depiction+=" The enemy troops are defending themselves against our charge. ";
				}else if(enemyTactic=="Charge"){
					depiction+=" Both armies are charging at each other. ";
				}else if(enemyTactic=="Maneuver"){
					depiction+=" Our troops managed to interrupt enemy troops trying to outmaneuver us. ";
				}else if(enemyTactic=="Retreat"){
					depiction+=" Our troops are charging at the retreating enemy. ";
				}else if(enemyTactic=="Flee"){
					depiction+=" Our troops are charging at the fleeing enemy. ";
				}
			}else if(tactic=="Maneuver"){
				if(enemyTactic=="Skirmish"){
					depiction+=" We are trying to outmaneuver the enemy skirmish. ";
				}else if(enemyTactic=="Defend"){
					depiction+=" We are outmaneuvering the defensive position of our enemy.  ";
				}else if(enemyTactic=="Charge"){
					depiction+=" The enemy is charging at our maneuvering troops. ";
				}else if(enemyTactic=="Maneuver"){
					depiction+=" Both armies are looking for an advantageous position. ";
				}else if(enemyTactic=="Retreat"){
					depiction+=" The enemy is retreating whilst our troops are doing maneuvers. ";
				}else if(enemyTactic=="Flee"){
					depiction+=" The enemy is fleeing whilst our troops are doing maneuvers. ";
				}
			}else if(tactic=="Retreat"){
				if(enemyTactic=="Skirmish"){
					depiction+=" Our troops are retreating from the enemy skirmish. ";
				}else if(enemyTactic=="Defend"){
					depiction+=" Our troops are retreating away from the defensive postion of our enemy. ";
				}else if(enemyTactic=="Charge"){
					depiction+=" The enemy is charging at our retreat. ";
				}else if(enemyTactic=="Maneuver"){
					depiction+=" Our troops are retreating whilst the enemy is looking for an advantageous position. ";
				}else if(enemyTactic=="Retreat"){
					depiction+=" Both armies are retreating. ";
				}else if(enemyTactic=="Flee"){
					depiction+=" Our army is retreating whilst the enemy is running away. ";
				}
			}else if(tactic=="Flee"){
				if(enemyTactic=="Skirmish"){
					depiction+=" We are fleeing from the enemy skirmish. ";
				}else if(enemyTactic=="Defend"){
					depiction+=" Our troops are fleeing from the defensive postion of our enemy. ";
				}else if(enemyTactic=="Charge"){
					depiction+=" The enemy is charging at our fleeing troops. ";
				}else if(enemyTactic=="Maneuver"){
					depiction+=" Our troops are fleeing whilst the enemy is busy looking for an advantageous position. ";
				}else if(enemyTactic=="Retreat"){
					depiction+=" Our troops are fleeing from the retreating forces of our enemy. ";
				}else if(enemyTactic=="Flee"){
					depiction+=" Both armies are running away from each other. ";
				}
			}
		}
	}

}