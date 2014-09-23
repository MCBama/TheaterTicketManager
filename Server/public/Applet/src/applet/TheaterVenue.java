package applet;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.net.URL;

import javax.imageio.ImageIO;

public enum TheaterVenue {
	CONCERTHALL("http://i.imgur.com/6uMYBN7.png", "..\\src\\applet\\res\\concerthall.png"),
	PLAYHOUSE("", "");
	
	private String webImgPath;
	private String localImgPath;
	private BufferedImage img;
	
	TheaterVenue (String webImgPath, String localImgPath) {
		this.webImgPath = webImgPath;
		this.localImgPath = localImgPath;
		try {
			throw new IOException();
			//URL url = new URL(this.webImgPath);
			//img = ImageIO.read(url);
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
