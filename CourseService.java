package demo.connection.mysql;

import java.sql.Connection;
import java.sql.Date;
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
			int fee = resultSet.getInt("fee");
			String mentors = resultSet.getString("mentors");
			Date begin_time = resultSet.getDate("begin");
			Date end_time = resultSet.getDate("end");
			course = new Course();
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
			Course course = new Course();
			listCourse.add(course);
		}
		return listCourse;
	}
	
	public Mentors showMentorByCourse(int course_id) throws SQLException {
		Connection connection = DBConnection.makeConnection();
		String SQL = "SELECT * FROM mentor WHERE course_id = ?";
		
		PreparedStatement stmt = connection.prepareStatement(SQL);
		stmt.setInt(1, course_id);
		ResultSet resultSet = stmt.executeQuery();
		
		Mentors mentor = null;
		if(resultSet.next()) {
			String name = resultSet.getString("name");
			String mail = resultSet.getString("mail");
			String phone = resultSet.getString("phone");
			mentor = new Mentors();
		
		}
		return mentor;
	}

}
