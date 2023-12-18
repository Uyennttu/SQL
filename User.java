package demo.connection.mysql;

import java.util.ArrayList;

public class User {
	private int id;
	private String name;
	private String password;
	public int failedCount;
	ArrayList<Course> registeredCourses;
	
	public User() {
		// TODO Auto-generated constructor stub
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public int getFailedCount() {
		return failedCount;
	}

	public void setFailedCount(int failedCount) {
		this.failedCount = failedCount;
	}

	public ArrayList<Course> getRegisteredCourses() {
		return registeredCourses;
	}

	public void setRegisteredCourses(ArrayList<Course> registeredCourses) {
		this.registeredCourses = registeredCourses;
	}
	
	
}
