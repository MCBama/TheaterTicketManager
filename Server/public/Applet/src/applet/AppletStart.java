package applet;

import javax.swing.JApplet;
import javax.swing.SwingUtilities;
import java.awt.Dimension;
import java.lang.reflect.InvocationTargetException;

public class AppletStart extends JApplet {

	private static final long serialVersionUID = 1L;
	private String mode = null;
	private int transID = -1;
	private int perfID = -1;
	private int stockAdult = 0;
	private int stockChild = 0;
	private int stockMilitary = 0;
	private int stockNum = 0;

	@Override
	public void init() {
		MainPanel mp = null;
		
		this.mode = this.getParameter("mode");
		this.transID = Integer.parseInt(this.getParameter("transaction_id"));
		this.perfID = Integer.parseInt(this.getParameter("performance_id"));
		if(this.mode != null) {
			if(this.mode.equals("ticket_purchase")) {
				this.stockAdult = Integer.parseInt(this.getParameter("stock_adult"));
				this.stockChild = Integer.parseInt(this.getParameter("stock_child"));
				this.stockMilitary = Integer.parseInt(this.getParameter("stock_military"));
				mp = new MainPanel(this.transID, this.perfID, this.stockAdult, this.stockChild, this.stockMilitary);
			}
			else if(this.mode.equals("season_ticket_purchase")) {
				this.stockNum = Integer.parseInt(this.getParameter("stock"));
				mp = new MainPanel(this.transID, this.perfID, this.stockNum);
			}
			else if(this.mode.equals("admin_move")) {
				mp = new MainPanel(this.transID, this.perfID);
			}
			else {
				System.err.println("Error: mode flag invalid");
			}
		}
		else {
			System.err.println("Error: mode flag not set");
		}
		
		this.setPreferredSize(new Dimension(1000, 1000));
		this.setSize(1000, 1000);
		
		final MainPanel finalmp = mp;
	
		Runnable r = new Runnable() {
			@Override
			public void run() {
				add(finalmp);
			}
		};
		try {
			SwingUtilities.invokeAndWait(r);
		} catch(InterruptedException ie) {
			ie.printStackTrace();
		} catch (InvocationTargetException ite) {
			ite.printStackTrace();
		}
	} 
}