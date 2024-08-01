<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Change Password</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(to right, #E0FBE2, #BFF6C3, #B0EBB4); /* Linear gradient background */
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .container {
            background: #fff;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
            max-width: 500px;
            width: 100%;
        }
        h2 {
            color: #333;
            margin-bottom: 20px;
        }
        input[type=password], input[type=submit] {
            width: calc(100% - 22px); /* Adjusting for padding and border */
            padding: 12px;
            margin: 10px 0;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
        }
        input[type=submit] {
            background-color: #7ABA78; /* Default button color */
            color: white;
            border: none;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease; /* Smooth transition for color and scaling */
        }
        input[type=submit]:hover {
            background-color: #6AAE6A; /* Color when hovered */
        }
        input[type=submit]:active {
            background-color: #0A6847; /* Color when clicked */
            transform: scale(0.98); /* Slightly scale down the button on click */
        }
        .button-container {
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Change Password</h2>
        <form method="post">
            Old Password: <input type="password" name="oldPassword" required><br>
            New Password: <input type="password" name="newPassword" required><br>
            <input type="submit" value="Change Password">
        </form>
        <%
            String oldPassword = request.getParameter("oldPassword");
            String newPassword = request.getParameter("newPassword");
            String accountNo = (String) request.getSession().getAttribute("accountNo"); // Assuming accountNo is stored in session
            if (oldPassword != null && newPassword != null && accountNo != null) {
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver"); // Replace with your JDBC driver
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/userdb", "root", "12345@goat");

                    // Verify old password
                    String verifySQL = "SELECT * FROM user_details WHERE account_no = ? AND password = ?";
                    ps = conn.prepareStatement(verifySQL);
                    ps.setString(1, accountNo);
                    ps.setString(2, oldPassword);
                    rs = ps.executeQuery();

                    if (rs.next()) {
                        // Update password in user_details table
                        String updateSQL1 = "UPDATE user_details SET password = ? WHERE account_no = ?";
                        ps = conn.prepareStatement(updateSQL1);
                        ps.setString(1, newPassword);
                        ps.setString(2, accountNo);
                        ps.executeUpdate();

                        // Update password in users table
                        String updateSQL2 = "UPDATE users SET password = ? WHERE account_no = ?";
                        ps = conn.prepareStatement(updateSQL2);
                        ps.setString(1, newPassword);
                        ps.setString(2, accountNo);
                        ps.executeUpdate();

        %>
                        <p class="status-message" style="color: #5bc0de;">Password changed successfully!</p>
        <%
                    } else {
        %>
                        <p class="status-message" style="color: #d9534f;">Old password is incorrect. Please try again.</p>
        <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
        %>
                    <p class="status-message" style="color: #d9534f;">An error occurred: <%= e.getMessage() %></p>
        <%
                } finally {
                    try {
                        if (rs != null) rs.close();
                        if (ps != null) ps.close();
                        if (conn != null) conn.close(); // Close connection properly
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }
        %>
        <div class="button-container">
            <form action="AccountDetailsServlet" method="get">
                <input type="submit" value="Go to Account Page">
            </form>
        </div>
    </div>
</body>
</html>

