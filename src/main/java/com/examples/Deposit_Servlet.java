package com.examples;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class Deposit_Servlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accountNo = (String) request.getSession().getAttribute("accountNo");
        double depositAmount = Double.parseDouble(request.getParameter("depositAmount"));

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        double newBalance = 0.0;

        try {
            conn = dbconnection.getConnection();
            String selectSQL = "SELECT initial_balance FROM user_details WHERE account_no = ?";
            ps = conn.prepareStatement(selectSQL);
            ps.setString(1, accountNo);
            rs = ps.executeQuery();

            if (rs.next()) {
                double currentBalance = rs.getDouble("initial_balance");
                newBalance = currentBalance + depositAmount;

                String updateSQL = "UPDATE user_details SET initial_balance = ? WHERE account_no = ?";
                ps = conn.prepareStatement(updateSQL);
                ps.setDouble(1, newBalance);
                ps.setString(2, accountNo);
                ps.executeUpdate();

                // Insert transaction record
                String insertTransactionSQL = "INSERT INTO transactions (account_no, transaction_type, amount, transaction_date) VALUES (?, ?, ?, NOW())";
                ps = conn.prepareStatement(insertTransactionSQL);
                ps.setString(1, accountNo);
                ps.setString(2, "deposit");
                ps.setDouble(3, depositAmount);
                ps.executeUpdate();
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            throw new ServletException("An error occurred while processing deposit", e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close(); // Close connection properly
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        request.setAttribute("newBalance", newBalance);
        request.getRequestDispatcher("deposit_success.jsp").forward(request, response);
    }
}
