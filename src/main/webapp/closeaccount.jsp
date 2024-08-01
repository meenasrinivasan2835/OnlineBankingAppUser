<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Close Account</title>
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
        .message {
            padding: 15px;
            margin: 20px 0;
            border-radius: 5px;
            font-size: 16px;
        }
        .success {
            background-color: #7ABA78;
            color: white;
        }
        .error {
            background-color: #d9534f;
            color: white;
        }
        form {
            margin: 20px 0;
        }
        input[type="submit"] {
            width: 100%;
            padding: 15px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            color: white;
            background-color: #7ABA78; /* Default button color */
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease; /* Smooth transition for color and scaling */
        }
        input[type="submit"]:hover {
            background-color: #6AAE6A; /* Color when hovered */
        }
        input[type="submit"]:active {
            background-color: #0A6847; /* Color when clicked */
            transform: scale(0.98); /* Slightly scale down the button on click */
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Close Account</h2>
        <%
            String accountNo = (String) request.getSession().getAttribute("accountNo");
            if (accountNo != null) {
                Connection conn = null;
                PreparedStatement ps = null;
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver"); // Replace with your JDBC driver
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/userdb", "root", "12345@goat");

                    // Delete account from user_details table
                    String deleteSQL1 = "DELETE FROM user_details WHERE account_no = ?";
                    ps = conn.prepareStatement(deleteSQL1);
                    ps.setString(1, accountNo);
                    int rowsDeleted1 = ps.executeUpdate();

                    // Delete account from users table
                    String deleteSQL2 = "DELETE FROM users WHERE account_no = ?";
                    ps = conn.prepareStatement(deleteSQL2);
                    ps.setString(1, accountNo);
                    int rowsDeleted2 = ps.executeUpdate();

                    if (rowsDeleted1 > 0 && rowsDeleted2 > 0) {
        %>
                        <div class="message success">Account closed successfully!</div>
        <%
                        // Invalidate the session after closing the account
                        request.getSession().invalidate();
                    } else {
        %>
                        <div class="message error">Failed to close the account. Please try again.</div>
        <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
        %>
                    <div class="message error">An error occurred: <%= e.getMessage() %></div>
        <%
                } finally {
                    try {
                        if (ps != null) ps.close();
                        if (conn != null) conn.close(); // Close connection properly
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            } else {
        %>
                <div class="message error">No account number found in session.</div>
        <%
            }
        %>
        <form action="AccountDetailsServlet" method="get">
            <input type="submit" value="Go to Account Page">
        </form>
    </div>
</body>
</html>

