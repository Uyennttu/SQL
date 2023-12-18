package demo.connection.mysql;

import java.util.ArrayList;
import java.util.Date;

public class Course {
	private int id;
	private String name;
	private ArrayList<Mentors> teachingMentors;
	private Date begin;
	private Date end;
	private int fee;
	
	public Course() {
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

	public ArrayList<Mentors> getTeachingMentors() {
		return teachingMentors;
	}

	public void setTeachingMentors(ArrayList<Mentors> teachingMentors) {
		this.teachingMentors = teachingMentors;
	}

	public Date getBegin() {
		return begin;
	}

	public void setBegin(Date begin) {
		this.begin = begin;
	}

	public Date getEnd() {
		return end;
	}

	public void setEnd(Date end) {
		this.end = end;
	}

	public int getFee() {
		return fee;
	}

	public void setFee(int fee) {
		this.fee = fee;
	}
	
	

}