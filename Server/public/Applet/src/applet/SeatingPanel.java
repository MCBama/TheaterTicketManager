package applet;

import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Image;
import java.util.ArrayList;
import javax.swing.JPanel;

public class SeatingPanel extends JPanel 
{
	
	private static final long serialVersionUID = 1L;
	
	
	private Image img;
	private ArrayList<Seat> seatList;
	
	public SeatingPanel(TheaterVenue theater, ArrayList<Seat> seatList) {
		this.seatList = seatList;
		this.img = theater.getImg();
		
		setPreferredSize(new Dimension(theater.getImg().getWidth(), 
				theater.getImg().getHeight()));
		setLayout(null);
		addSeats();
		
	}
	
	public void addSeats() {
		for(int i = 0; i < seatList.size(); ++i) {
			this.add(seatList.get(i));
		}
	}
	
	@Override
	public void paintComponent(Graphics g) {
		super.paintComponent(g);
			g.drawImage(img, 0,0, null);
	}
}
