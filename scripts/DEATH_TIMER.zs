class SpeedDoomDeathTimer : SpeedDoomTimer {
	float spread;
	
	override void init() {
		//Ready the time and set the spread to 0
		spread = 0;
		ticksLeft = mainHandler.levelTime * 35;
		
		//Restart the music
		S_ChangeMusic("*");
	}

	override void update(int secondsLeft, bool outOfTime) {
		//Flashy Effects
		if (secondsLeft <= 10 && spread < 3) { spread = min(spread + 0.1, 3); }
		else if (spread > 0) { spread = max(spread - 0.1, 0); }
		
		//Once the timer runs out, kill the players
		if (outOfTime) {
			mainHandler.deathMessage = "TIME OUT!";
			
			for (int i = 0; i < players.Size(); i++) {
				PlayerPawn player = players[i].mo;
				
				//If the player exists kill and fling them
				if (player) {
					player.DamageMobj(player, player, 99999, "TimeOut");
					player.Vel.Z = 7.5;
				}
			}
			
			//Change to the dead timer which handles the death stuff
			mainHandler.changeTimer("SpeedDoomDeadTimer");
		}
	}
	
	override void draw(HUDFont dFont, int secondsLeft, bool outOfTime) {
		//Little hour long easter egg
		String text = "TIME LEFT "..timeToString(secondsLeft);
		
		//Check to see if we need to draw multiple times
		//We will not set fSeconds if we don't need to
		int drawCount = 1;
		if (spread != 0) { drawCount = 20; }
		
		//Check colours!
		int fontColour = Font.CR_GOLD;
		if (secondsLeft >= 60) { fontColour = Font.CR_GREEN; }
		else if (secondsLeft <= 10) {
			if (ticksLeft % 35 > 17) { fontColour = Font.CR_RED; }
			else { fontColour = Font.CR_BRICK; }
		}
		
		for (let i = drawCount - 1; i >= 0; i--) {
			Vector2 drawPosition = (0, 50);
			if (spread != 0) {
				float trigTimer = (i * 3.5 + level.Time) * 2;
				drawPosition.x += sin(trigTimer) * spread;
				drawPosition.y += sin(trigTimer * 2) * spread;
			}
			
			Statusbar.DrawString(
				dFont, text,
				drawPosition,
				Statusbar.DI_SCREEN_CENTER_TOP | Statusbar.DI_TEXT_ALIGN_CENTER, fontColour,
				1 - (double(i) / 20)
			);
		}
	}
}

class SpeedDoomDeadTimer : SpeedDoomDeathTimer {
	Vector2 textFall;

	override void init() {
		spread = 3;
		ticksLeft = 280;
		
		//For the text fall animation
		textFall = (0, -10);
		
		//Stop the music and play the lose noise
		S_ChangeMusic("");
		S_StartSound("misc/speedDoomLose", 0);
	}
	
	override void update(int secondsLeft, bool outOfTime) {
		textFall.y += 0.5;
		textFall.x += textFall.y;
		if (textFall.x >= 30) { 
			textFall.x = 30;
			textFall.y /= -2.5;
		}
	
		if (!outOfTime) { super.update(0, false); }
		else { mainHandler.changeTimer("SpeedDoomReviewTimer"); }
	}
	
	override void draw(HUDFont dFont, int secondsLeft, bool outOfTime) {
		Statusbar.DrawString(
			HUDFont.Create(bigfont), mainHandler.deathMessage,
			(0, textFall.x),
			Statusbar.DI_SCREEN_CENTER_TOP | Statusbar.DI_TEXT_ALIGN_CENTER, Font.CR_WHITE
		);
		
		super.draw(dFont, 0, false);
	}
	
	override bool canMove() { return false; }
}