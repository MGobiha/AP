<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Booking Failed</title>
  <style>
    body{font-family:Segoe UI,Arial;background:#f5f7fb;margin:0;}
    .box{max-width:720px;margin:60px auto;background:#fff;padding:24px;border-radius:16px;border:1px solid #e9edf5;}
    .btn{display:inline-block;margin-top:14px;background:#1b4fff;color:#fff;padding:10px 14px;border-radius:12px;text-decoration:none;font-weight:800;}
  </style>
</head>
<body>
  <div class="box">
    <h2>Booking Failed</h2>
    <p>Sorry, your booking could not be completed. The room might already be booked or dates are invalid.</p>
    <a class="btn" href="<%=request.getContextPath()%>/bookNow">Try Again</a>
  </div>
</body>
</html>