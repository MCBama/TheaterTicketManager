package applet;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class DBConnector {
	private static DBConnector instance = null;
	private Connection conn = null;
	private String url = "";
	private String user = "";
	private String password = "";
	private int perfID;
	private int count;
	
	protected DBConnector() {
		this.url = "jdbc:mysql://localhost:3306/development";
		this.user = "root";
		this.password = "";
		
		while(!this.openConnection() && count < 5) {
			try {
			    Thread.sleep(1000);
			} catch(InterruptedException ex) {
			    Thread.currentThread().interrupt();
			}
			
			count++;
		}
	}
	
	public static DBConnector getInstance() {
		if(instance == null) {
			instance = new DBConnector();
		}
		return instance;
	}
	
	protected void finalize() {
		while(!this.closeConnection()) {
			try {
			    Thread.sleep(1000);
			} catch(InterruptedException ex) {
			    Thread.currentThread().interrupt();
			}
		}
	}
	
	private boolean openConnection() {
		try {
			conn = DriverManager.getConnection(url, user, password);
		} catch (SQLException ex) {
			System.out.println("SQLException: " + ex.getMessage());
			System.out.println("SQLState: " + ex.getSQLState());
			System.out.println("VendorError: " + ex.getErrorCode());
			return false;
		}
		
		System.out.println("Connection was successful");
		return true;
	}
	
	private boolean closeConnection() {
		try {
			if (conn != null) {
				conn.close();
			}
		} catch (SQLException ex) {
			System.out.println("SQLException: " + ex.getMessage());
			System.out.println("SQLState: " + ex.getSQLState());
			System.out.println("VendorError: " + ex.getErrorCode());
			
			return false;
		}
		
		return false;
	}
	
	public ArrayList<Integer> getReservedSeats(int perfID) {
		ArrayList<Integer> list = new ArrayList<Integer>();
		Statement stmt = null;
		ResultSet rs = null;
		
		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery("SELECT seat_id FROM development.tickets");
			
			while(rs.next()) {
				list.add(rs.getInt("seat_id"));
			}
			
		} 
		catch(SQLException e) {
			System.out.println("SQLException: " + e.getMessage());
		    System.out.println("SQLState: " + e.getSQLState());
		    System.out.println("VendorError: " + e.getErrorCode());
		}
		finally {
			if (rs != null) {
		        try {
		            rs.close();
		        } catch (SQLException sqlEx) { } // ignore

		        rs = null;
		    }

		    if (stmt != null) {
		        try {
		            stmt.close();
		        } catch (SQLException sqlEx) { } // ignore

		        stmt = null;
		    }
		}
		
		return list;
	}
	
}