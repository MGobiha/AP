<%
    // destroy session
    session.invalidate();

    // redirect to home page
    response.sendRedirect("index.jsp");
%>