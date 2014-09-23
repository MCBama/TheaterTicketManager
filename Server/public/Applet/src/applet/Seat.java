package applet;
import java.awt.Graphics;
import java.awt.Image;

import javax.swing.JButton;


public class Seat extends JButton 
{
	
	private int size;
	private int x;
	private int y;
	private int id;
	private String section;
	private String row;
	private String seatNumber;
	private SeatType type;
	
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	Seat(int id, String section, String row, String seat, int y, int x, int size)
	{
		this.id = id;
		this.x = x;
		this.y = y;
		this.section = section;
		this.row = row;
		this.seatNumber = seat;
		this.type = SeatType.EMPTY;
		
		setToolTipText(this.section + ", Row " + this.row + ", Seat " + this.seatNumber);
		setSize(size);
		setBorder(null);
		setContentAreaFilled(false); 
		
		//AffineTransform tx = new AffineTransform();
		//tx.rotate(Math.toRadians(180), backgroundImg.getWidth(null)/2, backgroundImg.getHeight(null)/2);
		//AffineTransformOp op = new AffineTransformOp(tx, AffineTransformOp.TYPE_BILINEAR);
		//backgroundImg = op.filter(backgroundImg, null);
	    
		
		//this.addActionListener(new seatListener());
	}
	
	public int getID() {
		return this.id;
	}
	
	public void setSize(int size) {
		this.setBounds(y-(size/2),x-(size/2),size,size);
		this.size = size;
	}
	
	public void setType(SeatType type) {
		this.type = type;
	}
	
	public SeatType getType() {
		return this.type;
	}
	
	@Override
	public void paintComponent(Graphics g)
	{
		super.paintComponent(g);
		g.drawImage(SeatType.EMPTY.getImg().getScaledInstance(size, size, Image.SCALE_SMOOTH), 0, 0, null);
		
		if(this.type != SeatType.EMPTY) {
			g.drawImage(this.type.getImg().getScaledInstance(size, size, Image.SCALE_SMOOTH), 0, 0, null);
		}
	}
}
