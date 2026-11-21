class SpeedDoomReviewTimer : SpeedDoomTimer {
	override void init() {
		ticksLeft = 525;
		
		//Play the lose music
		S_ChangeMusic("audio/REVIEW_MUSIC.mp3");
	}
	
	override void update(int secondsLeft, bool outOfTime) {
		for (int i = 0; i < players.Size(); i++) {
			PlayerPawn player = players[i].mo;
			
			//If the player exists rotate them
			if (player) {
				player.A_SetAngle(player.angle + 1);
			}
		}
		
		//Loop back around to the first message
		if (outOfTime) { ticksLeft = 525; }
	}
	
	override void draw(HUDFont dFont, int secondsLeft, bool outOfTime) {
		//Show the TIME OUT! text
		Statusbar.DrawString(
			HUDFont.Create(bigfont), mainHandler.deathMessage,
			(0, 30),
			Statusbar.DI_SCREEN_CENTER_TOP | Statusbar.DI_TEXT_ALIGN_CENTER, Font.CR_WHITE
		);
	
		//Uhh... the UI system doesn't support multiline.
		if (secondsLeft > 10) {
			Statusbar.DrawString(
					dFont, "You have died!",
					(0, 50),
					Statusbar.DI_SCREEN_CENTER_TOP | Statusbar.DI_TEXT_ALIGN_CENTER, Font.CR_RED
			);
			
			Statusbar.DrawString(
					dFont, "But you could have done better!",
					(0, 60),
					Statusbar.DI_SCREEN_CENTER_TOP | Statusbar.DI_TEXT_ALIGN_CENTER, Font.CR_GREEN
			);
		}
		else if (secondsLeft > 5) {
			Statusbar.DrawString(
					dFont, String.Format("You had \cf%s", timeToString(mainHandler.levelTime)),
					(0, 50),
					Statusbar.DI_SCREEN_CENTER_TOP | Statusbar.DI_TEXT_ALIGN_CENTER, Font.CR_GREEN
			);
			
			Statusbar.DrawString(
					dFont, "to complete it!",
					(0, 60),
					Statusbar.DI_SCREEN_CENTER_TOP | Statusbar.DI_TEXT_ALIGN_CENTER, Font.CR_GREEN
			);
		}
		else {
			Statusbar.DrawString(
					dFont, "Respawn to retry!",
					(0, 55),
					Statusbar.DI_SCREEN_CENTER_TOP | Statusbar.DI_TEXT_ALIGN_CENTER, Font.CR_LIGHTBLUE
			);
		}
	}
}