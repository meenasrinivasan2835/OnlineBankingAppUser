<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <title>Last Ten Transactions</title>
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
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 80%;
            max-width: 900px;
            text-align: center;
        }
        h2 {
            color: #333;
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: left;
        }
        th {
            background-color: #4CAF50;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        tr:hover {
            background-color: #f1f1f1;
        }
        .button-container {
            margin-top: 20px;
        }
        .button-container form {
            margin: 10px 0;
        }
        input[type="submit"] {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            background-color: #7ABA78;
            color: white;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }
        input[type="submit"]:hover {
            background-color: #6AAE6A;
        }
        input[type="submit"]:active {
            background-color: #0A6847;
            transform: scale(0.98);
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Last Ten Transactions</h2>
        <table>
            <tr>
                <th>Transaction ID</th>
                <th>Type</th>
                <th>Amount</th>
                <th>Date</th>
            </tr>
            <%
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                String accountNo = (String) session.getAttribute("accountNo");
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/userdb", "root", "12345@goat");

                    String sql = "SELECT * FROM transactions WHERE account_no = ? ORDER BY transaction_date DESC LIMIT 10";
                    ps = conn.prepareStatement(sql);
                    ps.setString(1, accountNo);
                    rs = ps.executeQuery();

                    while (rs.next()) {
                        int transactionId = rs.getInt("transaction_id");
                        String transactionType = rs.getString("transaction_type");
                        double amount = rs.getDouble("amount");
                        Timestamp transactionDate = rs.getTimestamp("transaction_date");
            %>
                        <tr>
                            <td><%= transactionId %></td>
                            <td><%= transactionType %></td>
                            <td><%= amount %></td>
                            <td><%= sdf.format(transactionDate) %></td>
                        </tr>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
            %>
                    <tr>
                        <td colspan="4">An error occurred while retrieving transactions.</td>
                    </tr>
            <%
                } finally {
                    try {
                        if (rs != null) rs.close();
                        if (ps != null) ps.close();
                        if (conn != null) conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            %>
        </table>
        <div class="button-container">
            <form action="AccountDetailsServlet" method="get">
                <input type="submit" value="Go to Account Page">
            </form>
            <form action="DownloadTransactions.jsp" method="get">
                <input type="submit" value="Download Transactions">
            </form>
        </div>
    </div>
</body>
</html>

