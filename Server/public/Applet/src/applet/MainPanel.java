package applet;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;
import java.util.Arrays;

import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JPanel;
import javax.swing.JScrollPane;

public class MainPanel extends JPanel {

	private static final long serialVersionUID = 1L;
	
	private JScrollPane seatingScrollPane;
	private JPanel seatingPanel;
	private ArrayList<Seat> seatList;
	private JButton confirmButton;
	boolean confirmShown = false;;
	
	final private TheaterVenue venue;
	private DBConnector DBconn = null;
	
	final private int transID;
	final private int perfID;
	
	final private boolean isSelectableEmpty;
	final private boolean isSelectableReserved;
	final private boolean isPlaceableSelected;
	final private boolean isPlaceableAdult;
	final private boolean isPlaceableChild;
	final private boolean isPlaceableMilitary;
	
	final private SeatStock stockSelected;
	final private SeatStock stockAdult;
	final private SeatStock stockChild;
	final private SeatStock stockMilitary;
	
	
	public MainPanel(int transID, int perfID, int stockAdult, int stockChild, int stockMilitary) {
		this.transID = transID;
		this.perfID = perfID;
		
		this.isSelectableEmpty = true;
		this.isSelectableReserved = false;
		this.isPlaceableSelected = false;
		this.isPlaceableAdult = true;
		this.isPlaceableChild = true;
		this.isPlaceableMilitary = true;
		
		this.stockSelected = new SeatStock(SeatType.SELECTED, 0);
		this.stockAdult = new SeatStock(SeatType.ADULT, stockAdult);
		this.stockChild = new SeatStock(SeatType.CHILD, stockChild);
		this.stockMilitary = new SeatStock(SeatType.MILITARY, stockMilitary);
		
		this.venue = TheaterVenue.CONCERTHALL;
		
		this.confirmShown = false;
		this.confirmButton = new JButton("Confrim Seats");
		
		this.init();
	}
	
	public MainPanel(int transID, int perfID, int stockNum) {
		this.transID = transID;
		this.perfID = perfID;
		
		this.isSelectableEmpty = true;
		this.isSelectableReserved = false;
		this.isPlaceableSelected = true;
		this.isPlaceableAdult = false;
		this.isPlaceableChild = false;
		this.isPlaceableMilitary = false;
		
		this.stockSelected = new SeatStock(SeatType.SELECTED, stockNum);
		this.stockAdult = new SeatStock(SeatType.ADULT, 0);
		this.stockChild = new SeatStock(SeatType.CHILD, 0);
		this.stockMilitary = new SeatStock(SeatType.MILITARY, 0);
		
		this.venue = TheaterVenue.CONCERTHALL;
		
		this.confirmShown = false;
		this.confirmButton = new JButton("Confrim Seats");
		
		this.init();
	}
	
	public MainPanel(int transID, int perfID) {
		this.transID = transID;
		this.perfID = perfID;
		
		this.isSelectableEmpty = true;
		this.isSelectableReserved = false;
		this.isPlaceableSelected = false;
		this.isPlaceableAdult = true;
		this.isPlaceableChild = true;
		this.isPlaceableMilitary = true;
		
		this.stockSelected = new SeatStock(SeatType.SELECTED, 0);
		this.stockAdult = new SeatStock(SeatType.ADULT, 10);
		this.stockChild = new SeatStock(SeatType.CHILD, 10);
		this.stockMilitary = new SeatStock(SeatType.MILITARY, 10);
		
		this.venue = TheaterVenue.CONCERTHALL;
		
		this.confirmShown = false;
		this.confirmButton = new JButton("Confrim Seats");
		
		this.init();
	}
	
	private void init() {
		if(isPlaceableSelected && stockSelected.getStock() != 0) {
			stockSelected.setActive(true);
		}
		else if(isPlaceableAdult && stockAdult.getStock() != 0) {
			stockAdult.setActive(true);
		}
		else if(isPlaceableChild && stockChild.getStock() != 0) {
			stockChild.setActive(true);
		}
		else if(isPlaceableMilitary && stockMilitary.getStock() != 0) {
			stockMilitary.setActive(true);
		}
		this.buildStocks();
		this.buildVenue();
		this.initLayout();
	}
	
	private void buildSeatList() {
		int count = 0; // quick count variable to track number of comparisons made in the loop
		this.seatList = SeatLocations.getSeatLocations(this.venue);
		ArrayList<Integer> reservedSeatList = new ArrayList<>(Arrays.asList(12)); //DBconn.getReservedSeats(this.perfID);
		for(int i = 0; i < this.seatList.size(); ++i) {
			for(int j = 0; j < reservedSeatList.size(); ++j) {
				System.out.println("Size: "+reservedSeatList.size());
				System.out.println(i+" "+j);
				count++;
				System.out.println(count);
				if(this.seatList.get(i).getID() == reservedSeatList.get(j)) {
					this.seatList.get(i).setType(SeatType.RESERVED);
					reservedSeatList.remove(j);
					break;
				}
			}
			this.seatList.get(i).addActionListener(new ActionListener() {

				@Override
				public void actionPerformed(ActionEvent e) {
					Seat thisSeat = (Seat) e.getSource();
					if(isSelectableEmpty && thisSeat.getType() == SeatType.EMPTY) {
						if(isPlaceableSelected && stockSelected.isActive()) {
							thisSeat.setType(SeatType.SELECTED);
							stockSelected.decStock();
						}
						else if(isPlaceableAdult && stockAdult.isActive()) {
							thisSeat.setType(SeatType.ADULT);
							stockAdult.decStock();
						}
						else if(isPlaceableChild && stockChild.isActive()) {
							thisSeat.setType(SeatType.CHILD);
							stockChild.decStock();
						}
						else if(isPlaceableMilitary && stockMilitary.isActive()) {
							thisSeat.setType(SeatType.MILITARY);
							stockMilitary.decStock();
						}
					}
					else if(isSelectableReserved && thisSeat.getType() == SeatType.RESERVED) {
						if(isPlaceableSelected && stockSelected.isActive()) {
							thisSeat.setType(SeatType.SELECTED_RESERVED);
							stockSelected.decStock();
						}
					}
					else {
						
						if(thisSeat.getType() == SeatType.SELECTED) {
							thisSeat.setType(SeatType.EMPTY);
							stockSelected.incStock();
						}
						else if(thisSeat.getType() == SeatType.SELECTED_RESERVED) {
							thisSeat.setType(SeatType.RESERVED);
							stockSelected.incStock();
						}
						else if(thisSeat.getType() == SeatType.ADULT) {
							thisSeat.setType(SeatType.EMPTY);
							stockAdult.incStock();
						}
						else if(thisSeat.getType() == SeatType.CHILD) {
							thisSeat.setType(SeatType.EMPTY);
							stockChild.incStock();
						}
						else if(thisSeat.getType() == SeatType.MILITARY) {
							thisSeat.setType(SeatType.EMPTY);
							stockMilitary.incStock();
						}
					}
					
					if(!(stockSelected.isActive() || stockAdult.isActive() 
							|| stockChild.isActive() || stockMilitary.isActive())) {
						if(isPlaceableSelected && stockSelected.getStock() != 0) {
							stockSelected.setActive(true);
						}
						else if(isPlaceableAdult && stockAdult.getStock() != 0) {
							stockAdult.setActive(true);
						}
						else if(isPlaceableChild && stockChild.getStock() != 0) {
							stockChild.setActive(true);
						}
						else if(isPlaceableMilitary && stockMilitary.getStock() != 0) {
							stockMilitary.setActive(true);
						}
						else {
							
						}
						
					}
				}
			});
		}
		
	}
	
	private void buildVenue() {
		this.buildSeatList();
		this.seatingPanel = new SeatingPanel(this.venue, this.seatList);
		this.seatingScrollPane = new JScrollPane();
		this.seatingScrollPane.setViewportView(this.seatingPanel);
		this.seatingScrollPane.setSize(500,500);
	}
	
	private void buildStocks() {
		
		
		ActionListener stockListener = new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				stockSelected.setActive(false);
				stockAdult.setActive(false);
				stockChild.setActive(false);
				stockMilitary.setActive(false);
				
				SeatStock thisStock = (SeatStock) e.getSource();
				thisStock.setActive(true);
			}
			
		};
		
		this.stockSelected.addActionListener(stockListener);
		this.stockAdult.addActionListener(stockListener);
		this.stockChild.addActionListener(stockListener);
		this.stockMilitary.addActionListener(stockListener);
	}
	
	private void initLayout() {
		this.removeAll();
		this.setLayout(new BorderLayout());
		JPanel eastPanel = new JPanel();
		stockAdult.setAlignmentX(CENTER_ALIGNMENT);
		stockChild.setAlignmentX(CENTER_ALIGNMENT);
		stockMilitary.setAlignmentX(CENTER_ALIGNMENT);
		eastPanel.setLayout(new BoxLayout(eastPanel, BoxLayout.Y_AXIS));
		JPanel centerPanel = new JPanel(new GridBagLayout());
		this.add(eastPanel, BorderLayout.EAST);
		this.add(centerPanel, BorderLayout.CENTER);
		GridBagConstraints c = new GridBagConstraints();
		
		int stockLayoutCol = 0;
		
		if(isPlaceableSelected) {
			/*clearGridBagConstraints(c);
			c.gridx = stockLayoutCol++;
			c.gridy = 0;
			c.weightx = 1;
			c.fill = GridBagConstraints.BOTH;*/
			eastPanel.add(stockSelected);
		}
		
		if(isPlaceableAdult) {
			/*clearGridBagConstraints(c);
			c.gridx = stockLayoutCol++;
			c.gridy = 0;
			c.weightx = 1;
			c.fill = GridBagConstraints.BOTH;*/
			eastPanel.add(stockAdult);
		}
		
		if(isPlaceableChild) {
			/*clearGridBagConstraints(c);
			c.gridx = stockLayoutCol++;
			c.gridy = 0;
			c.weightx = 1;
			c.fill = GridBagConstraints.BOTH;*/
			eastPanel.add(stockChild);
		}
		
		if(isPlaceableMilitary) {
			/*clearGridBagConstraints(c);
			c.gridx = stockLayoutCol++;
			c.gridy = 0;
			c.weightx = 1;
			c.fill = GridBagConstraints.BOTH;*/
			eastPanel.add(stockMilitary);
		}
		
		clearGridBagConstraints(c);
		c.gridx = 0;
		c.gridy = 1;
		c.weightx = 1;
		c.weighty = 1;
		c.gridwidth = GridBagConstraints.REMAINDER;
		c.fill = GridBagConstraints.BOTH;
		centerPanel.add(seatingScrollPane, c);
		
		//eastPanel.add(new JButton("Confirm"));
		
	}
	
	private void showConfirm() {
		
	}
	
	private void hideConfirm() {
		
	}
	
	private void clearGridBagConstraints(GridBagConstraints c) {
		c.gridx = 0;
		c.gridy = 0;
		c.gridwidth = 1;
		c.gridheight = 1;
		c.weightx = 0;
		c.weighty = 0;
		c.anchor = GridBagConstraints.CENTER;
		c.fill = GridBagConstraints.NONE;
		c.ipadx = 0;
		c.ipady = 0;
	}
}

