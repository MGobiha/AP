<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="model.Room"%>
<%@page import="model.Package"%>

<%
  List<Room> rooms = (List<Room>) request.getAttribute("rooms");
  List<Package> packages = (List<Package>) request.getAttribute("packages");

  // inline edit
  String editIdParam = request.getParameter("editId");
  int editId = -1;
  if(editIdParam != null){
      try{ editId = Integer.parseInt(editIdParam); } catch(Exception e){ editId = -1; }
  }

  // helper: package name by id
  Map<Integer, String> packageNameMap = new HashMap<>();
  if(packages != null){
      for(Package p : packages){
          packageNameMap.put(p.getId(), p.getName());
      }
  }
%>

<jsp:include page="components/admin_layout_top.jsp">
  <jsp:param name="active" value="rooms"/>
</jsp:include>

<style>
  .page-title{font-size:20px;font-weight:900;margin-bottom:14px;}
  .panel{background:#fff;border:1px solid #e9edf5;border-radius:16px;box-shadow:0 10px 20px rgba(10,20,40,.06);overflow:hidden;}
  .panel-head{padding:14px 16px;border-bottom:1px solid #e9edf5;display:flex;align-items:center;justify-content:space-between;}
  .panel-head h3{font-size:15px;font-weight:900;}

  .btn{border:none;cursor:pointer;border-radius:10px;padding:10px 14px;font-weight:900;}
  .btn-primary{background:#1b4fff;color:#fff;}
  .btn-primary:hover{filter:brightness(.95);}

  .form-grid{display:grid;grid-template-columns:.7fr 1fr .8fr .8fr 1fr auto;gap:10px;padding:14px 16px;}
  .input, select{width:100%;padding:10px 12px;border:1px solid #e9edf5;border-radius:12px;outline:none;background:#fbfcff;}
  .input:focus, select:focus{border-color:#1b4fff;}

  table{width:100%;border-collapse:collapse;}
  th,td{padding:12px 14px;text-align:left;border-bottom:1px solid #eef1f6;font-size:13px;}
  th{background:linear-gradient(180deg,#1b4fff,#1442d7);color:#fff;font-weight:900;}
  tr:hover td{background:#fbfdff;}

  .tag{display:inline-block;padding:6px 10px;border-radius:999px;font-weight:900;font-size:12px;border:1px solid transparent;}
  .tag.ok{background:#eafff1;color:#0e8a3a;border-color:#bff3d0;}
  .tag.bad{background:#ffecec;color:#c21818;border-color:#ffcaca;}

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

  .ok-btn{background:#eafff1;border-color:#bff3d0;}
  .ok-btn .icon{stroke:#0e8a3a;}
</style>

<div class="page-title">Rooms</div>

<div class="panel">
  <div class="panel-head">
    <h3>Add New Room</h3>
  </div>

  <!-- ADD ROOM -->
  <form class="form-grid" action="<%=request.getContextPath()%>/admin" method="post">
    <input type="hidden" name="action" value="room_add">

    <input class="input" name="roomNo" placeholder="Room No (101)" required>
    <input class="input" name="roomType" placeholder="Type (Deluxe)" required>
    <input class="input" name="price" type="number" step="0.01" placeholder="Price" required>

    <select name="status">
      <option value="AVAILABLE">AVAILABLE</option>
      <option value="BOOKED">BOOKED</option>
    </select>

    <select name="packageId" required>
      <%
        if(packages != null && !packages.isEmpty()){
          for(Package p : packages){
      %>
        <option value="<%=p.getId()%>"><%=p.getName()%></option>
      <%
          }
        } else {
      %>
        <option value="">No Packages</option>
      <%
        }
      %>
    </select>

    <button class="btn btn-primary" type="submit">Save</button>
  </form>

  <!-- TABLE -->
  <table>
    <thead>
      <tr>
        <th style="width:70px;">ID</th>
        <th style="width:110px;">Room No</th>
        <th>Type</th>
        <th style="width:120px;">Price</th>
        <th style="width:130px;">Status</th>
        <th style="width:170px;">Package</th>
        <th style="width:140px;">Actions</th>
      </tr>
    </thead>

    <tbody>
    <%
      if(rooms == null || rooms.isEmpty()){
    %>
      <tr><td colspan="7">No rooms found.</td></tr>
    <%
      } else {
        for(Room r : rooms){
          boolean editing = (r.getId() == editId);
          String pkgName = packageNameMap.get(r.getPackageId());
          if(pkgName == null) pkgName = "—";
    %>

      <% if(!editing){ %>
      <tr>
        <td><%=r.getId()%></td>
        <td><%=r.getRoomNo()%></td>
        <td><%=r.getRoomType()%></td>
        <td><%=r.getPrice()%></td>
        <td>
          <span class="tag <%= "AVAILABLE".equalsIgnoreCase(r.getStatus()) ? "ok" : "bad" %>">
            <%=r.getStatus()%>
          </span>
        </td>
        <td><%=pkgName%></td>

        <td>
          <div class="actions">

            <!-- EDIT -->
            <a class="icon-btn edit"
               href="<%=request.getContextPath()%>/admin?page=rooms&editId=<%=r.getId()%>"
               title="Edit">
              <svg class="icon" viewBox="0 0 24 24">
                <path d="M12 20h9"/>
                <path d="M16.5 3.5a2.1 2.1 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/>
              </svg>
            </a>

            <!-- DELETE -->
            <form action="<%=request.getContextPath()%>/admin" method="post" style="margin:0;">
              <input type="hidden" name="action" value="room_delete">
              <input type="hidden" name="id" value="<%=r.getId()%>">
              <button class="icon-btn danger" type="submit" title="Delete"
                      onclick="return confirm('Delete this room?')">
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
        <td><%=r.getId()%></td>

        <td colspan="6" style="padding:0;">
          <form action="<%=request.getContextPath()%>/admin" method="post"
                style="display:grid;grid-template-columns:110px 1fr 120px 130px 170px 140px;gap:10px;padding:12px 14px;">
            <input type="hidden" name="action" value="room_update">
            <input type="hidden" name="id" value="<%=r.getId()%>">

            <input class="cell-input" name="roomNo" value="<%=r.getRoomNo()%>" required>
            <input class="cell-input" name="roomType" value="<%=r.getRoomType()%>" required>
            <input class="cell-input" type="number" step="0.01" name="price" value="<%=r.getPrice()%>" required>

            <select class="cell-input" name="status">
              <option value="AVAILABLE" <%= "AVAILABLE".equalsIgnoreCase(r.getStatus())?"selected":"" %>>AVAILABLE</option>
              <option value="BOOKED" <%= "BOOKED".equalsIgnoreCase(r.getStatus())?"selected":"" %>>BOOKED</option>
            </select>

            <select class="cell-input" name="packageId" required>
              <%
                if(packages != null){
                  for(Package p : packages){
              %>
                <option value="<%=p.getId()%>" <%= (p.getId()==r.getPackageId())?"selected":"" %>>
                  <%=p.getName()%>
                </option>
              <%
                  }
                }
              %>
            </select>

            <div class="actions">
              <!-- SAVE -->
              <button class="icon-btn ok-btn" type="submit" title="Save">
                <svg class="icon" viewBox="0 0 24 24">
                  <path d="M20 6L9 17l-5-5"/>
                </svg>
              </button>

              <!-- CANCEL -->
              <a class="icon-btn danger" title="Cancel"
                 href="<%=request.getContextPath()%>/admin?page=rooms">
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