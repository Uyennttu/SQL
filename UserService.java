package demo.connection.mysql;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

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
			user = new User(resultSet.getInt("id"), resultSet.getString("name"), resultSet.getString("password"));
		}
		return user;

	}
}
