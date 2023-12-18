package demo.connection.mysql;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.Scanner;

public class Main {
	static final int LOGIN = 1;
	static final int REGISTER = 2;

	public static void main(String[] args) throws SQLException {
		CourseService courseService = new CourseService();
		List<Course> list = courseService.getAllCourses();

		for (Course course : list) {
			System.out.println("ID: " + course.getId() + " | Course: " + course.getName());
		}

		Scanner scanner = new Scanner(System.in);
		System.out.println("Selected Course: ");
		int selectedCourseByID = scanner.nextInt();

		Course selectedCourse = courseService.getCourseById(selectedCourseByID);
		System.out.println("ID: " + selectedCourse.getId() + " | Course: " + selectedCourse.getName());

		UserService userService = new UserService();
		System.out.println("Enter name: ");
		String name = scanner.nextLine();
		System.out.println("Enter password: ");
		String pwd = scanner.nextLine();

		UserService userService1 = new UserService();

		// LOGIN + REGISTER
		User loggedInUser = null;
		int selectedCommand;
		do {
			System.out.println("1.LOGIN");
			System.out.println("2.REGISTER");
			System.out.println("No Account? Please Register.");
			String id, password, name1;
			selectedCommand = scanner.nextInt();
			scanner.nextLine();
			switch (selectedCommand) {
			case LOGIN: {
				System.out.println("Please enter your ID: ");
				id = scanner.nextLine();
				System.out.println("Please enter your password: ");
				password = scanner.nextLine();
				loggedInUser = userService.login(id, password);
				break;
			}
			case REGISTER: {
				System.out.println("Please create your ID: ");
				id = scanner.nextLine();
				System.out.println("Please enter your name: ");
				name1 = scanner.nextLine();
				System.out.println("Please enter your password: ");
				password = scanner.nextLine();
				userService.registerNewUser(id);
				break;
			}
			default: {
				break;
			}
			}

		} while (loggedInUser == null);
	}
}
