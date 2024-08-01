<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.io.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Download Transactions</title>
</head>
<body>
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

            // Set response headers for CSV download
            response.setContentType("text/csv");
            response.setHeader("Content-Disposition", "attachment; filename=\"transactions.csv\"");

            PrintWriter writer = response.getWriter(); // Use 'writer' instead of 'out'
            writer.println("Transaction ID,Type,Amount,Date");

            while (rs.next()) {
                int transactionId = rs.getInt("transaction_id");
                String transactionType = rs.getString("transaction_type");
                double amount = rs.getDouble("amount");
                Timestamp transactionDate = rs.getTimestamp("transaction_date");

                writer.printf("%d,%s,%.2f,%s%n", transactionId, transactionType, amount, sdf.format(transactionDate));
            }

        } catch (Exception e) {
            e.printStackTrace();
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
</body>
</html>

