package demo.connection.mysql;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class CourseService {
	public Course getCourseById(int id) throws SQLException {
		Connection connection = DBConnection.makeConnection();
		String SQL = "SELECT * FROM course WHERE id = ?";

		PreparedStatement stmt = connection.prepareStatement(SQL);
		stmt.setInt(1, id);
		ResultSet resultSet = stmt.executeQuery();
		
		Course course = null;
		if(resultSet.next()) {
			String name = resultSet.getString("name");
			course = new Course(id, name);
		}
		return course;

	}

	public List<Course> getAllCourses() throws SQLException {
		Connection connection = DBConnection.makeConnection();
		String SQL = "SELECT * FROM course";

		Statement stmt = connection.createStatement();
		ResultSet resultSet = stmt.executeQuery(SQL);

		List<Course> listCourse = new ArrayList<Course>();

		while (resultSet.next()) {
			int id = resultSet.getInt("id");
			String name = resultSet.getString("name");
			Course course = new Course(id, name);
			listCourse.add(course);
		}
		return listCourse;
	}

}
