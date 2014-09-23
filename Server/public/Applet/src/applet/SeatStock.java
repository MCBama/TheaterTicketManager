package applet;

import java.awt.Color;

import javax.swing.ImageIcon;
import javax.swing.JButton;

public class SeatStock extends JButton {
	
	private static final long serialVersionUID = 1L;
	private SeatType type;
	private int stock;
	private boolean isActive;
	
	public SeatStock(SeatType type, int stock) {
		this.type = type;
		
		setIcon(new ImageIcon(type.getImg()));
		setActive(false);
		setStock(stock);
	}
	
	public SeatType getType() {
		return this.type;
	}
	
	public void setActive(boolean value) {
		this.isActive = value;
		setBorderPainted(false);
		setOpaque(true);
		setContentAreaFilled(true);
		if(value) {
			setBackground(new Color(180, 180, 180));
		}
		else {
			setBackground(new Color(230, 230, 230));
		}
	}
	
	public boolean isActive() {
		return this.isActive;
	}
	
	private void setStock(int stock) {
		
		this.stock = stock;
		setText(this.type + " (" + this.stock + ")");
		
		if(stock <= 0) {
			setEnabled(false);
			setActive(false);
		}
		else {
			setEnabled(true);
		}
		
	}
	
	public int getStock() {
		return this.stock;
	}
	
	public void incStock() {
		setStock(++this.stock);
	}
	
	public void decStock() {
		setStock(--this.stock);
	}
	
}
