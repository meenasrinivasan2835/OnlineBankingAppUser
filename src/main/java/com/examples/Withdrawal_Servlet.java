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

public class Withdrawal_Servlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accountNo = (String) request.getSession().getAttribute("accountNo");
        double withdrawalAmount = Double.parseDouble(request.getParameter("withdrawalAmount"));

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        double newBalance = 0.0;
        String message = "";

        try {
            conn = dbconnection.getConnection();
            String selectSQL = "SELECT initial_balance FROM user_details WHERE account_no = ?";
            ps = conn.prepareStatement(selectSQL);
            ps.setString(1, accountNo);
            rs = ps.executeQuery();

            if (rs.next()) {
                double currentBalance = rs.getDouble("initial_balance");

                if (currentBalance >= withdrawalAmount) {
                    newBalance = currentBalance - withdrawalAmount;

                    String updateSQL = "UPDATE user_details SET initial_balance = ? WHERE account_no = ?";
                    ps = conn.prepareStatement(updateSQL);
                    ps.setDouble(1, newBalance);
                    ps.setString(2, accountNo);
                    ps.executeUpdate();

                    String insertTransactionSQL = "INSERT INTO transactions (account_no, transaction_type, amount, transaction_date) VALUES (?, ?, ?, NOW())";
                    ps = conn.prepareStatement(insertTransactionSQL);
                    ps.setString(1, accountNo);
                    ps.setString(2, "withdraw");
                    ps.setDouble(3, withdrawalAmount);
                    ps.executeUpdate();

                    message = "Withdrawal successful. Your new balance is: " + newBalance;
                } else {
                    message = "Insufficient balance. Your current balance is: " + currentBalance;
                }
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

        request.setAttribute("message", message);
        request.getRequestDispatcher("withdrawal_success.jsp").forward(request, response);
    }
}

