<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Account Details</title>
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
        p {
            font-size: 16px;
            color: #555;
            margin: 10px 0;
        }
        form {
            margin: 20px 0;
        }
        input[type="submit"], button {
            width: 100%;
            padding: 15px;
            margin: 10px 0;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            color: white;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease; /* Smooth transition for color and scaling */
        }
        input[type="submit"] {
            background-color: #7ABA78; /* Default button color */
        }
        input[type="submit"]:hover {
            background-color: #6AAE6A; /* Color when hovered */
        }
        input[type="submit"]:active {
            background-color: #0A6847; /* Color when clicked */
            transform: scale(0.98); /* Slightly scale down the button on click */
        }
        button {
            background-color: #7ABA78; /* Default button color */
        }
        button:hover {
            background-color: #6AAE6A; /* Color when hovered */
        }
        button:active {
            background-color: #0A6847; /* Color when clicked */
            transform: scale(0.98); /* Slightly scale down the button on click */
        }
    </style>
    <script type="text/javascript">
        function confirmCloseAccount() {
            return confirm("Are you sure you want to close your account?");
        }
    </script>
</head>
<body>
    <div class="container">
        <h2>Welcome, <%= request.getAttribute("fullName") %></h2>
        <p>Account Number: <%= session.getAttribute("accountNo") %></p>
        <p>Balance: <%= request.getAttribute("balance") %></p>

        <form action="deposit.jsp" method="get">
            <input type="submit" value="Deposit">
        </form>
        <form action="withdrawal.jsp" method="get">
            <input type="submit" value="Withdrawal">
        </form>
        <form action="transaction.jsp" method="get">
            <input type="submit" value="Transaction">
        </form>
        <form action="changepassword.jsp" method="get">
            <button type="submit">Change Password</button>
        </form>
        <form action="closeaccount.jsp" method="post" onsubmit="return confirmCloseAccount();">
            <button type="submit">Close Account</button>
        </form>
        <form action="user_login.jsp" method="get">
            <button type="submit">Logout</button>
        </form>
    </div>
</body>
</html>
