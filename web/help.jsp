<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Help | Ocean View Resort</title>
  <style>
    body{font-family:Segoe UI,Arial;background:#f5f7fb;margin:0;}
    .wrap{max-width:860px;margin:30px auto;padding:0 16px 40px;}
    .card{background:#fff;border:1px solid #e9edf5;border-radius:16px;padding:24px;margin-bottom:14px;}
    ol{padding-left:20px;}
    li{margin:8px 0;}
    code{background:#f3f6ff;padding:2px 6px;border-radius:6px;}
    a{color:#1b4fff;}
  </style>
</head>
<body>
<jsp:include page="components/header.jsp"/>
<div class="wrap">
  <div class="card">
    <h2>Help for new staff</h2>
    <p>Use this page as a step-by-step guide. Guests, staff and administrators share the same system with different access levels.</p>
  </div>
  <div class="card">
    <h3>1. User authentication (login)</h3>
    <ol>
      <li>Open <a href="login.jsp">Sign in</a>.</li>
      <li>Enter your username and password.</li>
      <li>Administrators go to the dashboard. Staff go to the staff desk. Guests go to the home page.</li>
      <li>Use <b>Logout</b> when you finish so the next person cannot use your session.</li>
    </ol>
    <p>Demo accounts after importing <code>TestGB.sql</code>: <code>admin / admin123</code>, <code>staff1 / staff123</code>, <code>client1 / client123</code>.</p>
  </div>
  <div class="card">
    <h3>2. Register a new booking</h3>
    <ol>
      <li>A guest creates an account on <a href="register.jsp">Register</a> (name, address, contact, username, password).</li>
      <li>After login, choose a room from <a href="packages.jsp">Packages</a> or <a href="<%=request.getContextPath()%>/bookNow">Book Now</a>.</li>
      <li>Enter check-in and check-out dates. Check-out must be after check-in.</li>
      <li>Confirm the summary. The system stores a unique reservation number such as <code>RES-20260902-...</code>.</li>
    </ol>
  </div>
  <div class="card">
    <h3>3. Display booking details</h3>
    <ol>
      <li>Open <a href="<%=request.getContextPath()%>/searchReservation">Find booking</a>.</li>
      <li>Type the reservation number and search.</li>
      <li>The screen shows guest name, address, contact, room type, dates, total and status.</li>
      <li>Guests can only see their own bookings. Staff and admin can see any booking.</li>
    </ol>
  </div>
  <div class="card">
    <h3>4. Calculate and print the bill</h3>
    <ol>
      <li>From the search result, click <b>Calculate / print bill</b>.</li>
      <li>The bill is room nights × nightly rate plus a service fee.</li>
      <li>Click <b>Print bill</b> and choose Save as PDF or the printer.</li>
    </ol>
  </div>
  <div class="card">
    <h3>5. This help section</h3>
    <p>Keep this page bookmarked for training. Administrators also have Reports under the dashboard for occupancy and revenue.</p>
  </div>
  <div class="card">
    <h3>6. Exit the system</h3>
    <p>Click <b>Logout</b> in the header. This invalidates the session and returns to the home page.</p>
  </div>
  <div class="card">
    <h3>Web services (for IT staff)</h3>
    <p>REST endpoints (header <code>X-Api-Key: oceanview-demo-key</code> or a logged-in session):</p>
    <ul>
      <li><code>GET <%=request.getContextPath()%>/api/rooms</code></li>
      <li><code>GET <%=request.getContextPath()%>/api/rooms?status=AVAILABLE</code></li>
      <li><code>GET <%=request.getContextPath()%>/api/reservations?resNo=RES-...</code></li>
    </ul>
  </div>
</div>
</body>
</html>
