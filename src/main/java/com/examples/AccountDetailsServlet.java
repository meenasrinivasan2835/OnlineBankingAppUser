package com.examples;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class AccountDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accountNo = (String) request.getSession().getAttribute("accountNo");
        if (accountNo == null) {
            response.sendRedirect("user_login.jsp");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String fullName = "";
        double balance = 0.0;

        try {
            conn = dbconnection.getConnection();
            String sql = "SELECT full_name, initial_balance FROM user_details WHERE account_no = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, accountNo);
            rs = ps.executeQuery();

            if (rs.next()) {
                fullName = rs.getString("full_name");
                balance = rs.getDouble("initial_balance");
            }

            // Debug statements
            System.out.println("Account No: " + accountNo);
            System.out.println("Full Name: " + fullName);
            System.out.println("Balance: " + balance);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        request.setAttribute("fullName", fullName);
        request.setAttribute("balance", balance);
        request.getRequestDispatcher("main.jsp").forward(request, response);
    }
}
