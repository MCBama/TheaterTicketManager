package applet;

import java.util.ArrayList;

public class SeatLocations {
	
	public static ArrayList<Seat> getSeatLocations(TheaterVenue theater) {
		ArrayList<Seat> seats = new ArrayList<>();
		
		if(theater == TheaterVenue.CONCERTHALL) {
			seats.add(new Seat(1, "Ground Floor", "A", "1", 607, 138, 18));
			seats.add(new Seat(2, "Ground Floor", "A", "2", 627, 152, 18));
			seats.add(new Seat(3, "Ground Floor", "A", "3", 647, 164, 18));
			seats.add(new Seat(4, "Ground Floor", "A", "4", 667, 174, 18));
			seats.add(new Seat(5, "Ground Floor", "A", "5", 687, 184, 18));
			seats.add(new Seat(6, "Ground Floor", "A", "6", 707, 192, 18));
			seats.add(new Seat(7, "Ground Floor", "A", "7", 727, 200, 18));
			seats.add(new Seat(8, "Ground Floor", "A", "8", 747, 208, 18));
			seats.add(new Seat(9, "Ground Floor", "A", "9", 767, 216, 18));
			seats.add(new Seat(10, "Ground Floor", "A", "10", 787, 224, 18));
			seats.add(new Seat(11, "Ground Floor", "A", "11", 807, 232, 18));//
			seats.add(new Seat(12, "Ground Floor", "A", "12", 827, 234, 18));
			seats.add(new Seat(7, "Ground Floor", "A", "13", 847, 248, 18));
			seats.add(new Seat(8, "Ground Floor", "A", "14", 867, 242, 18));
			seats.add(new Seat(9, "Ground Floor", "A", "15", 887, 246, 18));
			seats.add(new Seat(10, "Ground Floor", "A", "16", 907, 248, 18));
			seats.add(new Seat(11, "Ground Floor", "A", "17", 927, 250, 18));
			seats.add(new Seat(12, "Ground Floor", "A", "18", 947, 252, 18));
		}
		else if(theater == TheaterVenue.PLAYHOUSE) {
			
		}
		return seats;
	}

}
