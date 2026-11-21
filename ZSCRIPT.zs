version "4.0.0"

#include "./scripts/BASE_TIMER.zs"
#include "./scripts/COUNTDOWN_TIMER.zs"
#include "./scripts/DEATH_TIMER.zs"
#include "./scripts/POST_REVIEW.zs"
#include "./scripts/PICKUP.zs"

class SpeedDoomMain : EventHandler {
	SpeedDoomTimer currentTimer;
	string deathMessage;
	int levelTime;
	
	bool dropClocks;
	int clockTimeAdder;
	int clockMinDropped;
	int clockMaxDropped;
	float clockSpawnCurve;
	
	virtual void changeTimer(String newTimerType) {
		if (currentTimer) { currentTimer.Destroy(); }
		currentTimer = SpeedDoomTimer(New(newTimerType));
		
		currentTimer.mainHandler = self;
		currentTimer.init();
	}
	
	virtual void addTime(int time) {
		if (currentTimer) {
			currentTimer.ticksLeft += time * 35;
			levelTime += time;
		}
	}
	
	override void WorldLoaded(WorldEvent e) {
		//Determine level time and if we should spawn clocks,
		//If we don't have a proper ParTime just do 1:30 per level.
		if (level.ParTime != 0) {
			levelTime = level.ParTime;
			dropClocks = CVar.GetCVar("speedDoomII_EnemiesDropClocks").GetBool();
		}
		else {
			levelTime = 90;
			dropClocks = true;
		}
		
		//Adjust to time modifier
		levelTime = max(levelTime + CVar.GetCVar("speedDoomII_TimeMod").GetInt(), 10);
		
		//Set clock settings
		clockTimeAdder = CVar.GetCVar("speedDoomII_ClockTimeAdder").GetInt();
		clockMinDropped = CVar.GetCVar("speedDoomII_ClockMin").GetInt();
		clockMaxDropped = CVar.GetCVar("speedDoomII_ClockMax").GetInt();
		clockSpawnCurve = CVar.GetCVar("speedDoomII_ClockSpawnCurve").GetFloat();
		
		//Start if we aren't a titlemap
		deathMessage = "GAME OVER!";
		if (level.Mapname != "TITLEMAP") { changeTimer("SpeedDoomCountdownTimer"); }
	}
	
	//Now for the actual UI and logic code
	override void WorldTick() {
		//Tick down and call the timer's update function
		if (currentTimer && currentTimer.ticksLeft > 0) {
			currentTimer.ticksLeft--;
			currentTimer.update(ceil(float(currentTimer.ticksLeft) / 35), currentTimer.ticksLeft <= 0);
		}
	}
	
	override void RenderOverlay(RenderEvent e) {
		//Make sure the timer exists
		if (currentTimer) {
			//Begin hud drawing
			Statusbar.BeginHUD();
			currentTimer.draw(currentTimer.getFont(), ceil(float(currentTimer.ticksLeft) / 35), currentTimer.ticksLeft <= 0);
		}
	}
	
	//Check for when a player dies
	override void WorldThingDied(WorldEvent e) {
		//See if the thing that died is a player
		if (e.thing) {
			//If a player died do the death check.
			if (e.thing.player) {
				bool allDead = true;
			
				//Check to make sure all players are dead
				for (int i = 0; i < players.Size(); i++) {
					PlayerPawn player = players[i].mo;
					if (player && player.health > 0) { allDead = false; }
				}
			
				if (allDead) { changeTimer("SpeedDoomDeadTimer"); }
			}
			//If a monster dies and it is a monster drop time.
			else if (e.thing.bIsMonster && dropClocks) {
				Vector3 spawnPos = e.thing.pos + (0, 0, e.thing.height / 2);
				int spawnedClocks = min(max(
					sqrt(float(e.Thing.GetMaxHealth()) / clockSpawnCurve), //A nice curve for their spawn rate
					clockMinDropped), clockMaxDropped //And the min and max
				);
				
				for (int i = 0; i < spawnedClocks; i++) {
					//Spawn and cast the object to SpeedDoomTimePickup
					SpeedDoomTimePickup spawned = SpeedDoomTimePickup(Actor.Spawn(
						"SpeedDoomTimePickup", 
						spawnPos
					));
				
					//Set variables
					spawned.mainHandler = self;
					spawned.vel = (frandom(-5, 5), frandom(-5, 5), frandom(4, 8));
				}
			}
		}
	}
	
	//Stop input if the timer doesn't allow input.
	override bool InputProcess(InputEvent e) {
		if (currentTimer) { return !currentTimer.canMove(); }
		return false;
	}
}