<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Deposit</title>
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
            max-width: 400px;
            width: 100%;
        }
        h2 {
            color: #333;
            margin-bottom: 20px;
        }
        form {
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        label {
            font-size: 16px;
            color: #555;
            margin-bottom: 10px;
            text-align: left;
            width: 100%;
        }
        input[type="number"] {
            padding: 15px;
            margin-bottom: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            width: calc(100% - 30px); /* Adjust width for padding */
            box-sizing: border-box;
        }
        input[type="submit"] {
            background-color: #7ABA78; /* Default button color */
            color: white;
            border: none;
            padding: 15px;
            text-align: center;
            font-size: 16px;
            cursor: pointer;
            border-radius: 5px;
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
        <h2>Deposit Amount</h2>
        <form action="Deposit_Servlet" method="post">
            <label for="depositAmount">Amount:</label>
            <input type="number" id="depositAmount" name="depositAmount" required>
            <input type="submit" value="Deposit">
        </form>
    </div>
</body>
</html>
