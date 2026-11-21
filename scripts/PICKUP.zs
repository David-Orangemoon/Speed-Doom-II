class SpeedDoomTimePickup : Inventory {
	SpeedDoomMain mainHandler;
	float itemScale;
	
	Default { Inventory.PickupSound "misc/speedDoomTimeUp"; }
	
	States {
		Spawn:
			TCLK ABCDEFGHIJKL 6;
			Loop;
	}
	
	override void BeginPlay() { itemScale = 0; }
	
	override void Tick() {
		super.Tick();
		A_SetAngle(angle + 5);
		
		if (itemScale < 0.5) {
			itemScale += 0.025;
			A_SetScale(itemScale);
		}
	}
	
	override String PickupMessage () { return String.Format("Picked up %d seconds!", mainHandler.clockTimeAdder); }
	override bool TryPickup (in out Actor other) {
		if (mainHandler) {
			mainHandler.addTime(mainHandler.clockTimeAdder);
			GoAwayAndDie();
			return true;
		}
		
		return false;
	}
}