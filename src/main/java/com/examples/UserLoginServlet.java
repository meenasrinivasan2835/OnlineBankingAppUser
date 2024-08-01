package com.examples;

import jakarta.servlet.ServletException;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;




public class UserLoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String accountNo = request.getParameter("accountNo");
        String password = request.getParameter("password");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = dbconnection.getConnection();
            String sql = "SELECT * FROM users WHERE account_no = ? AND password = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, accountNo);
            ps.setString(2, password);

            // Debug statement
            System.out.println("Trying to log in with Account No: " + accountNo + " and Password: " + password);

            rs = ps.executeQuery();
            if (rs.next()) {
            	HttpSession session = request.getSession();
                session.setAttribute("accountNo", accountNo);

                // Redirect to main page
                response.sendRedirect("AccountDetailsServlet");
            } else {
                request.setAttribute("errorMessage", "Invalid account number or password");
                request.getRequestDispatcher("user_login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while processing your request.");
            request.getRequestDispatcher("user_login.jsp").forward(request, response);
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
