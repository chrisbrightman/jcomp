package hello;

public class Help {

	private String str;

	public void blah() {
		System.err.println("blah");
	}

	public Help(String str) {
		this.str = str;
	}

	public String toString() {
		return str;
	}
}