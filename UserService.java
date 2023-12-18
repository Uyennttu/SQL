package demo.connection.mysql;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserService {
	public User login(String name, String password) throws SQLException {
		Connection connection = DBConnection.makeConnection();
		String SQL = "SELECT * FROM user WHERE name = ? AND password = ?";

		PreparedStatement stmt = connection.prepareStatement(SQL);
		stmt.setString(1, name);
		stmt.setString(2, password);
		ResultSet resultSet = stmt.executeQuery();

		User user = null;
		if (resultSet.next()) {
			user = new User();
		}
		return user;
	}

	public User loginWithAttempts(String name, String password) throws SQLException {
		User user = login(name, password);
		if (user != null) {
			user.failedCount = 0;
			System.out.println("Login successfully. Welcome " + user.getName());
			return user;
		}
		user.failedCount++;
		checkFailedCount(user, user.failedCount);
		return null;
	}

	public User checkFailedCount(User user, int failedCount) {
		if (user.failedCount > 2) {
			System.out.println("Your account is blocked.");
			return null;
		}
		System.out.println("Invalid ID or password. Please try again.");
		System.out.println("You have " + (3 - user.failedCount) + " attempt(s) left");
		return null;
	}

	public User registerNewUser(String mail) throws SQLException {
		Connection connection = DBConnection.makeConnection();

		if (isEmailExists(connection, mail)) {
			System.out.println("Email already exists.");
			return null;
		}

		String SQL = "INSERT INTO user (mail) VALUES (?)";

		PreparedStatement stmt = connection.prepareStatement(SQL);
		stmt.setString(1, mail);
		stmt.executeUpdate();
		System.out.println("Register Successfully.");
		return new User();
	}

	public boolean isEmailExists(Connection connection, String email) throws SQLException {
		String checkSQL = "SELECT COUNT(*) FROM user WHERE mail = ?";
		PreparedStatement checkStmt = connection.prepareStatement(checkSQL);
		checkStmt.setString(1, email);
		ResultSet resultSet = checkStmt.executeQuery();

		if (resultSet.next()) {
			int count = resultSet.getInt(1);
			return count > 0;
		}
		return false;
	}

}
