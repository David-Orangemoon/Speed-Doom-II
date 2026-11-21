class SpeedDoomTimer {
	SpeedDoomMain mainHandler;
	int ticksLeft;
	
	virtual String timeToString(int secondsLeft) {
		int minutes = (secondsLeft / 60) % 60;
		int seconds = secondsLeft % 60;
		
		//Little hour long easter egg
		if (secondsLeft >= 3600) { return String.Format("%02d:%02d:%02d", (secondsLeft / 3600), minutes, seconds); }
		else { return String.Format("%02d:%02d", minutes, seconds); }
	}
	
	virtual void init() { ticksLeft = 35; }
	virtual play void update(int secondsLeft, bool outOfTime) {}
	
	virtual ui HUDFont getFont() { return HUDFont.Create(smallfont); }
	virtual ui void draw(HUDFont dFont, int secondsLeft, bool outOfTime) {}
	
	virtual bool canMove() { return true; }
}