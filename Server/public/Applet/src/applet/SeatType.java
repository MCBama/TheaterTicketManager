package applet;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.net.URL;

import javax.imageio.ImageIO;

public enum SeatType {
	EMPTY("http://i.imgur.com/mhgrWto.png", "..\\src\\applet\\res\\seatEmpty.png"),
	RESERVED("http://i.imgur.com/HDNXP4n.png", "..\\src\\applet\\res\\seatReserved.png"),
	SELECTED("http://i.imgur.com/Dreuov0.png", "..\\src\\applet\\res\\seatSelected.png"),
	SELECTED_RESERVED("http://i.imgur.com/ZFzbpL4.png", "..\\src\\applet\\res\\seatSelectedReserved.png"),
	ADULT("http://i.imgur.com/nImdWcO.png", "..\\src\\applet\\res\\seatAdult.png"),
	CHILD("http://i.imgur.com/vQYfUBE.png", "..\\src\\applet\\res\\seatChild.png"),
	MILITARY("http://i.imgur.com/W0JrQaQ.png", "..\\src\\applet\\res\\seatMilitary.png");
	
	private String webImgPath;
	private String localImgPath;
	private BufferedImage img;
	
	SeatType(String webImgPath, String localImgPath) {
		this.webImgPath = webImgPath;
		this.localImgPath = localImgPath;
		try {
			URL url = new URL(this.webImgPath);
			img = ImageIO.read(url);
		} catch (IOException e) {
			System.err.println("ERR: Could not load web image at \"" + this.webImgPath +
					"\". Falling back to local image file...");
			try {
				File file = new File(this.localImgPath);
				img = ImageIO.read(file);
			} catch (IOException e1) {
				System.err.println("ERR: Could not load local image at \"" + this.localImgPath +
						"\". Generating blank image...");
				img = new BufferedImage(1, 1, BufferedImage.TYPE_INT_RGB);
			}
		} 
		
	}
	
	public BufferedImage getImg() {
		return this.img;
	}

};
