class SpeedDoomCountdownTimer : SpeedDoomTimer {
	override void init() {
		ticksLeft = 105;
		
		//Stop the music and prepare the countdown
		S_ChangeMusic("");
		S_StartSound("misc/countDown", 0);
	}

	override void update(int secondsLeft, bool outOfTime) {
		if (ticksLeft % 35 == 0) {
			if (outOfTime) { S_StartSound("misc/countDownEnd", 0); }
			else { S_StartSound("misc/countDown", 0); }
		}
		
		//Check for the timer running out, if it did start the run
		if (outOfTime) { mainHandler.changeTimer("SpeedDoomDeathTimer"); }
	}
	
	override HUDFont getFont() { return HUDFont.Create(bigfont); }
	override void draw(HUDFont dFont, int secondsLeft, bool outOfTime) {
		int fontColour = Font.CR_GREEN;
		if (secondsLeft == 2) { fontColour = Font.CR_GOLD; }
		else if (secondsLeft == 1) { fontColour = Font.CR_RED; }
	
		Statusbar.DrawString(
			dFont, secondsLeft.."",
			(0, 50),
			Statusbar.DI_SCREEN_CENTER_TOP | Statusbar.DI_TEXT_ALIGN_CENTER, fontColour
		);
	}
	
	override bool canMove() { return false; }
}