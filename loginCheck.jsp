<%@page import="java.net.URLEncoder"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%
	// login.html에서 입력된 id, pw값을 변수에 저장
	// 한글을 받을 필요가 있을때 인코딩
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	
	// JDBC 연결을 통해서 로그인 기능 구현
	// JDBC 연결과정
	// 1. OracleDriver 연결
	Class.forName("oracle.jdbc.driver.OracleDriver");
	
	String url = "jdbc:oracle:thin:@localhost:1521:xe";
	String user = "hr";
	String password = "hr";
	
	// 2. DB연결 ( Connection )
	// Connection : java.sql 인터페이스로 선택
	Connection conn = DriverManager.getConnection(url, user, password);
	
	if (conn == null ) out.print("DB연결 실패...");
	else out.print("DB연결성공!");
	
	// 3. SQL 작성 & 실행
	String sql = "select * from s_member where m_id = ? and m_pw = ?";
	
	PreparedStatement psmt = conn.prepareStatement(sql);
	
	psmt.setString(1, id);
	psmt.setString(2, pw);
	
	ResultSet rs = psmt.executeQuery();
	// next() : 커서 - 호출당 한번 내려간다, 기본값 True
	if (rs.next()) {
		String nick = rs.getString("m_nick");
		// 동일 : String nick = rs.getString(3);
		// 한글 인코딩 URLEncoder.encode(nick,"UTF-8")
		response.sendRedirect("loginTrue.jsp?nick="+URLEncoder.encode(nick,"UTF-8"));
	} else {
		response.sendRedirect("loginFalse.jsp");
	}
	// 4. DB연결 종료
	rs.close();
	psmt.close();
	conn.close();
	
	/* if(id.equals("smhrd") && pw.equals("1234")) {
		response.sendRedirect("loginTrue.jsp?id="+id);
	} else {
		response.sendRedirect("loginFalse.jsp");
	} */
	%>
</body>
</html>