package demo.connection.mysql;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.Scanner;

public class Main {
	public static void main(String[] args) throws SQLException {
		CourseService courseService = new CourseService();
		List<Course> list = courseService.getAllCourses();

		for (Course course : list) {
			System.out.println("ID: " + course.getId() + " | Course: " + course.getName());
		}

		Scanner sc = new Scanner(System.in);
		System.out.println("Selected Course: ");
		int selectedCourseByID = sc.nextInt();

		Course selectedCourse = courseService.getCourseById(selectedCourseByID);
		System.out.println("ID: " + selectedCourse.getId() + " | Course: " + selectedCourse.getName());

		UserService userService = new UserService();
		System.out.println("Enter name: ");
		String name = sc.nextLine();
		System.out.println("Enter password: ");
		String pwd = sc.nextLine();

		User userLogin = userService.login(name, pwd);

		if (userLogin != null) {
			System.out.println("Login Successfully.");
			System.out.println("ID: " + userLogin.getId() + " | Name: " + userLogin.getName());
		} else {
			System.out.println("Invalid credentials. Login Failed.");
		}
	}

}
