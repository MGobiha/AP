<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="model.Users"%>

<%
  List<Users> staff = (List<Users>) request.getAttribute("staff");

  int editId = -1;
  try { editId = Integer.parseInt(request.getParameter("editId")); } catch(Exception e) {}
%>

<jsp:include page="components/admin_layout_top.jsp">
  <jsp:param name="page" value="staff"/>
</jsp:include>

<style>
  .page-title{font-size:20px;font-weight:900;margin-bottom:14px;}
  .panel{background:#fff;border:1px solid #e9edf5;border-radius:16px;box-shadow:0 10px 20px rgba(10,20,40,.06);overflow:hidden;}
  .panel-head{padding:14px 16px;border-bottom:1px solid #e9edf5;display:flex;align-items:center;justify-content:space-between;}
  .panel-head h3{font-size:15px;font-weight:900;}
  .btn{border:none;cursor:pointer;border-radius:10px;padding:10px 14px;font-weight:900;}
  .btn-primary{background:#1b4fff;color:#fff;}
  .btn-primary:hover{filter:brightness(.95);}

  .form-grid{
    display:grid;
    grid-template-columns:1.2fr .8fr 1.2fr 1fr .8fr .8fr auto;
    gap:10px;padding:14px 16px;
  }

  .input, select{
    width:100%;padding:10px 12px;border:1px solid #e9edf5;border-radius:12px;
    outline:none;background:#fbfcff;
  }
  .input:focus, select:focus{border-color:#1b4fff;}

  table{width:100%;border-collapse:collapse;}
  th,td{padding:12px 14px;text-align:left;border-bottom:1px solid #eef1f6;font-size:13px;vertical-align:middle;}
  th{background:linear-gradient(180deg,#1b4fff,#1442d7);color:#fff;font-weight:900;}
  tr:hover td{background:#fbfdff;}

  .actions{display:flex;gap:8px;align-items:center;}
  .icon-btn{
    width:36px;height:36px;border-radius:10px;border:1px solid #e9edf5;
    background:#fff;display:flex;align-items:center;justify-content:center;
    cursor:pointer;
  }
  .icon-btn:hover{background:#f3f6ff;border-color:#dbe3ff;}
  .icon{width:18px;height:18px;fill:none;stroke:#111;stroke-width:2;stroke-linecap:round;stroke-linejoin:round;}
  .danger:hover{background:#ffecec;border-color:#ffcaca;}
  .danger .icon{stroke:#c21818;}
  .edit .icon{stroke:#1b4fff;}
  .ok-btn{background:#eafff1;border-color:#bff3d0;}
  .ok-btn .icon{stroke:#0e8a3a;}

  .cell-input{
    width:100%;padding:8px 10px;border:1px solid #e9edf5;border-radius:10px;background:#fbfcff;
    outline:none;font-size:13px;
  }
  .cell-input:focus{border-color:#1b4fff;}
</style>

<div class="page-title">Staff</div>

<div class="panel">
  <div class="panel-head">
    <h3>Add New Staff</h3>
  </div>

  <!-- ADD STAFF -->
  <form class="form-grid" action="<%=request.getContextPath()%>/admin" method="post">
    <input type="hidden" name="action" value="staff_add">

    <input class="input" name="fullName" placeholder="Full name" required>
    <input class="input" name="phone" placeholder="Phone" required>
    <input class="input" name="address" placeholder="Address" required>

    <select class="input" name="role" required>
      <option value="STAFF_L1">STAFF Level 1</option>
      <option value="STAFF_L2">STAFF Level 2</option>
      <option value="STAFF_L3">STAFF Level 3</option>
    </select>

    <input class="input" name="username" placeholder="Username" required>
    <input class="input" name="password" type="password" placeholder="Temp password" required>

    <button class="btn btn-primary" type="submit">Save</button>
  </form>

  <table>
    <thead>
      <tr>
        <th style="width:70px;">ID</th>
        <th>Full Name</th>
        <th style="width:130px;">Phone</th>
        <th>Address</th>
        <th style="width:160px;">Username</th>
        <th style="width:160px;">User Type</th>
        <th style="width:140px;">Actions</th>
      </tr>
    </thead>

    <tbody>
    <%
      if(staff == null || staff.isEmpty()){
    %>
      <tr><td colspan="7">No staff found.</td></tr>
    <%
      } else {
        for(Users u : staff){
          boolean editing = (u.getId() == editId);
    %>

      <% if(!editing){ %>
      <tr>
        <td><%=u.getId()%></td>
        <td><%=u.getFullName()%></td>
        <td><%=u.getPhone()%></td>
        <td><%=u.getAddress()%></td>
        <td><%=u.getUsername()%></td>
        <td><%=u.getRole()%></td>
        <td>
          <div class="actions">
            <a class="icon-btn edit"
               href="<%=request.getContextPath()%>/admin?page=staff&editId=<%=u.getId()%>"
               title="Edit">
              <svg class="icon" viewBox="0 0 24 24">
                <path d="M12 20h9"/>
                <path d="M16.5 3.5a2.1 2.1 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/>
              </svg>
            </a>

            <form action="<%=request.getContextPath()%>/admin" method="post" style="margin:0;">
              <input type="hidden" name="action" value="staff_delete">
              <input type="hidden" name="id" value="<%=u.getId()%>">
              <button class="icon-btn danger" type="submit" title="Delete"
                      onclick="return confirm('Delete this staff member?')">
                <svg class="icon" viewBox="0 0 24 24">
                  <path d="M3 6h18"/>
                  <path d="M8 6V4h8v2"/>
                  <path d="M19 6l-1 14H6L5 6"/>
                  <path d="M10 11v6"/>
                  <path d="M14 11v6"/>
                </svg>
              </button>
            </form>
          </div>
        </td>
      </tr>

      <% } else { %>
      <!-- INLINE EDIT ROW -->
      <tr>
        <td><%=u.getId()%></td>

        <td colspan="6" style="padding:0;">
          <form action="<%=request.getContextPath()%>/admin" method="post"
                style="display:grid;grid-template-columns:1fr 130px 1fr 160px 160px 140px;gap:10px;padding:12px 14px;align-items:center;">
            <input type="hidden" name="action" value="staff_update">
            <input type="hidden" name="id" value="<%=u.getId()%>">

            <input class="cell-input" name="fullName" value="<%=u.getFullName()%>" required>
            <input class="cell-input" name="phone" value="<%=u.getPhone()%>" required>
            <input class="cell-input" name="address" value="<%=u.getAddress()%>" required>
            <input class="cell-input" name="username" value="<%=u.getUsername()%>" required>

            <!-- ✅ ROLE EDIT FIELD -->
            <select class="cell-input" name="role" required>
              <option value="STAFF_L1" <%= "STAFF_L1".equalsIgnoreCase(u.getRole())?"selected":"" %>>STAFF Level 1</option>
              <option value="STAFF_L2" <%= "STAFF_L2".equalsIgnoreCase(u.getRole())?"selected":"" %>>STAFF Level 2</option>
              <option value="STAFF_L3" <%= "STAFF_L3".equalsIgnoreCase(u.getRole())?"selected":"" %>>STAFF Level 3</option>
            </select>

            <div class="actions">
              <button class="icon-btn ok-btn" type="submit" title="Save">
                <svg class="icon" viewBox="0 0 24 24">
                  <path d="M20 6L9 17l-5-5"/>
                </svg>
              </button>

              <a class="icon-btn danger" title="Cancel"
                 href="<%=request.getContextPath()%>/admin?page=staff">
                <svg class="icon" viewBox="0 0 24 24">
                  <path d="M18 6L6 18"/>
                  <path d="M6 6l12 12"/>
                </svg>
              </a>
            </div>

          </form>
        </td>
      </tr>
      <% } %>

    <%
        }
      }
    %>
    </tbody>
  </table>
</div>

<jsp:include page="components/admin_layout_bottom.jsp"/>