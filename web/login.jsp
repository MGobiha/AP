<%-- 
    Document   : login
    Created on : Mar 3, 2026, 9:42:46 PM
    Author     : user
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login | Ocean View Resort</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <style>
        *{
            margin:0;
            padding:0;
            box-sizing:border-box;
            font-family:Segoe UI, Arial, sans-serif;
        }

        body{
            min-height:100vh;
            display:flex;
            justify-content:center;
            align-items:center;
            background:
              linear-gradient(rgba(0,0,0,.6), rgba(0,0,0,.6)),
              url("https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=1600&q=70");
            background-size:cover;
            background-position:center;
        }

        .login-card{
            background:rgba(255,255,255,0.95);
            padding:40px;
            width:100%;
            max-width:400px;
            border-radius:20px;
            box-shadow:0 20px 50px rgba(0,0,0,0.3);
        }

        .login-card h2{
            text-align:center;
            margin-bottom:25px;
            color:#1b4fff;
        }

        .input-group{
            margin-bottom:18px;
        }

        .input-group label{
            font-size:13px;
            font-weight:600;
            color:#555;
            display:block;
            margin-bottom:6px;
        }

        .input-group input{
            width:100%;
            padding:12px;
            border-radius:12px;
            border:1px solid #ddd;
            font-size:14px;
            outline:none;
            transition:0.3s;
        }

        .input-group input:focus{
            border-color:#1b4fff;
            box-shadow:0 0 0 3px rgba(27,79,255,0.1);
        }

        .btn-login{
            width:100%;
            padding:12px;
            border:none;
            border-radius:14px;
            background:#1b4fff;
            color:white;
            font-size:15px;
            font-weight:600;
            cursor:pointer;
            transition:0.3s;
        }

        .btn-login:hover{
            filter:brightness(0.95);
        }

        .extra{
            text-align:center;
            margin-top:15px;
            font-size:13px;
        }

        .extra a{
            text-decoration:none;
            color:#1b4fff;
            font-weight:600;
        }

        .extra a:hover{
            text-decoration:underline;
        }

        @media(max-width:480px){
            .login-card{
                margin:20px;
                padding:30px;
            }
        }
    </style>
</head>

<body>

    <div class="login-card">
        <h2>Ocean View Resort</h2>

        <form action="login" method="post">
            <% String loginError = request.getParameter("error"); %>
            <% if ("1".equals(loginError)) { %>
              <p style="background:#ffecec;color:#c21818;padding:10px;border-radius:10px;margin-bottom:14px;font-size:13px;">Invalid username or password.</p>
            <% } else if ("required".equals(loginError)) { %>
              <p style="background:#ffecec;color:#c21818;padding:10px;border-radius:10px;margin-bottom:14px;font-size:13px;">Username and password are required.</p>
            <% } %>
            <% if ("1".equals(request.getParameter("registered"))) { %>
              <p style="background:#eafff1;color:#0e8a3a;padding:10px;border-radius:10px;margin-bottom:14px;font-size:13px;">Account created. Please sign in.</p>
            <% } %>

            <div class="input-group">
                <label>Username</label>
                <input type="text" name="username" required>
            </div>

            <div class="input-group">
                <label>Password</label>
                <input type="password" name="password" required>
            </div>

            <button type="submit" class="btn-login">Login</button>
        </form>

       <div class="extra">
        <p>New client? <a href="register.jsp">Create an account</a></p>
        <p>Back to <a href="index.jsp">Home</a></p>
      </div>
    </div>


<!--<h2>Login</h2>

<form action="login" method="post">
    Username: <input type="text" name="username"/><br><br>
    Password: <input type="password" name="password"/><br><br>
    <button type="submit">Login</button>
</form>-->

</body>
</html>