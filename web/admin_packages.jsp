<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="model.Package"%>

<%
    List<Package> packages = (List<Package>) request.getAttribute("packages");

    // inline edit row id
    String editIdParam = request.getParameter("editId");
    int editId = -1;
    if (editIdParam != null) {
        try { editId = Integer.parseInt(editIdParam); } catch (Exception e) { editId = -1; }
    }
%>

<jsp:include page="components/admin_layout_top.jsp">
  <jsp:param name="active" value="packages"/>
</jsp:include>

<style>
  .page-title{font-size:20px;font-weight:900;margin-bottom:14px;}
  .panel{background:#fff;border:1px solid #e9edf5;border-radius:16px;box-shadow:0 10px 20px rgba(10,20,40,.06);overflow:hidden;}
  .panel-head{padding:14px 16px;border-bottom:1px solid #e9edf5;display:flex;align-items:center;justify-content:space-between;}
  .panel-head h3{font-size:15px;font-weight:900;}

  .btn{border:none;cursor:pointer;border-radius:10px;padding:10px 14px;font-weight:900;}
  .btn-primary{background:#1b4fff;color:#fff;}
  .btn-primary:hover{filter:brightness(.95);}

  .form-grid{display:grid;grid-template-columns:1.2fr .7fr .7fr 1.4fr auto;gap:10px;padding:14px 16px;}
  .input, select{width:100%;padding:10px 12px;border:1px solid #e9edf5;border-radius:12px;outline:none;background:#fbfcff;}
  .input:focus, select:focus{border-color:#1b4fff;}

  table{width:100%;border-collapse:collapse;}
  th,td{padding:12px 14px;text-align:left;border-bottom:1px solid #eef1f6;font-size:13px;}
  th{background:linear-gradient(180deg,#1b4fff,#1442d7);color:#fff;font-weight:900;}
  tr:hover td{background:#fbfdff;}

  .tag{display:inline-block;padding:6px 10px;border-radius:999px;font-weight:900;font-size:12px;border:1px solid transparent;}
  .tag.active{background:#eafff1;color:#0e8a3a;border-color:#bff3d0;}
  .tag.inactive{background:#f1f5f9;color:#334155;border-color:#e2e8f0;}

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

  /* inline edit inputs */
  .cell-input{
    width:100%;
    padding:8px 10px;
    border:1px solid #e9edf5;
    border-radius:10px;
    background:#fbfcff;
    outline:none;
    font-size:13px;
  }
  .cell-input:focus{ border-color:#1b4fff; }

  /* save tick */
  .ok-btn{background:#eafff1;border-color:#bff3d0;}
  .ok-btn .icon{stroke:#0e8a3a;}
  .ok-btn:hover{background:#dfffea;border-color:#a6eabc;}
</style>

<div class="page-title">Packages</div>

<div class="panel">

  <div class="panel-head">
    <h3>Add New Package</h3>
  </div>

  <form class="form-grid" action="<%=request.getContextPath()%>/admin" method="post">
    <input type="hidden" name="action" value="package_add">

    <input class="input" name="name" placeholder="Package name" required>
    <input class="input" name="price" type="number" step="0.01" placeholder="Price/Night" required>

    <select name="status">
      <option value="ACTIVE">ACTIVE</option>
      <option value="INACTIVE">INACTIVE</option>
    </select>

    <input class="input" name="description" placeholder="Description (optional)">

    <button class="btn btn-primary" type="submit">Save</button>
  </form>

  <table>
    <thead>
      <tr>
        <th style="width:70px;">ID</th>
        <th>Name</th>
        <th style="width:130px;">Price/Night</th>
        <th style="width:120px;">Status</th>
        <th>Description</th>
        <th style="width:140px;">Actions</th>
      </tr>
    </thead>

    <tbody>
    <%
      if (packages == null || packages.isEmpty()) {
    %>
      <tr><td colspan="6">No packages found.</td></tr>
    <%
      } else {
        for (Package p : packages) {

          boolean editing = (p.getId() == editId);
    %>

      <tr>
        <td><%= p.getId() %></td>

        <% if (!editing) { %>

          <td><%= p.getName() %></td>
          <td><%= p.getPricePerNight() %></td>
          <td>
            <span class="tag <%= "ACTIVE".equalsIgnoreCase(p.getStatus()) ? "active" : "inactive" %>">
              <%= p.getStatus() %>
            </span>
          </td>
          <td><%= p.getDescription() %></td>

          <td>
            <div class="actions">
              <!-- EDIT -->
              <a class="icon-btn edit"
                 href="<%=request.getContextPath()%>/admin?page=packages&editId=<%=p.getId()%>"
                 title="Edit">
                <svg class="icon" viewBox="0 0 24 24">
                  <path d="M12 20h9"/>
                  <path d="M16.5 3.5a2.1 2.1 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/>
                </svg>
              </a>

              <!-- DELETE -->
              <form action="<%=request.getContextPath()%>/admin" method="post" style="margin:0;">
                <input type="hidden" name="action" value="package_delete">
                <input type="hidden" name="id" value="<%=p.getId()%>">
                <button class="icon-btn danger" type="submit" title="Delete"
                        onclick="return confirm('Delete this package?')">
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

        <% } else { %>

          <!-- INLINE EDIT FORM -->
          <form action="<%=request.getContextPath()%>/admin" method="post">
            <input type="hidden" name="action" value="package_update">
            <input type="hidden" name="id" value="<%=p.getId()%>">

            <td>
              <input class="cell-input" name="name" value="<%=p.getName()%>" required>
            </td>

            <td>
              <input class="cell-input" type="number" step="0.01" name="price"
                     value="<%=p.getPricePerNight()%>" required>
            </td>

            <td>
              <select class="cell-input" name="status">
                <option value="ACTIVE" <%= "ACTIVE".equalsIgnoreCase(p.getStatus()) ? "selected" : "" %>>ACTIVE</option>
                <option value="INACTIVE" <%= "INACTIVE".equalsIgnoreCase(p.getStatus()) ? "selected" : "" %>>INACTIVE</option>
              </select>
            </td>

            <td>
              <input class="cell-input" name="description"
                     value="<%= p.getDescription() == null ? "" : p.getDescription() %>">
            </td>

            <td>
              <div class="actions">
                <!-- SAVE ✅ -->
                <button class="icon-btn ok-btn" type="submit" title="Save">
                  <svg class="icon" viewBox="0 0 24 24">
                    <path d="M20 6L9 17l-5-5"/>
                  </svg>
                </button>

                <!-- CANCEL ❌ -->
                <a class="icon-btn danger" title="Cancel"
                   href="<%=request.getContextPath()%>/admin?page=packages">
                  <svg class="icon" viewBox="0 0 24 24">
                    <path d="M18 6L6 18"/>
                    <path d="M6 6l12 12"/>
                  </svg>
                </a>
              </div>
            </td>
          </form>

        <% } %>
      </tr>

    <%
        }
      }
    %>
    </tbody>

  </table>
</div>

<jsp:include page="components/admin_layout_bottom.jsp"/>