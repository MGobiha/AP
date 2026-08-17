<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="model.Room"%>

<%
  List<Room> rooms = (List<Room>) request.getAttribute("availableRooms");
%>

<jsp:include page="components/header.jsp"/>

<style>
  body{font-family:Segoe UI,Arial;background:#f5f7fb;margin:0;}
  .wrap{max-width:1100px;margin:24px auto;padding:0 18px;}
  .panel{background:#fff;border:1px solid #e9edf5;border-radius:18px;box-shadow:0 10px 20px rgba(10,20,40,.06);overflow:hidden;}
  .head{padding:16px 18px;border-bottom:1px solid #e9edf5;}
  .head h2{margin:0;}
  table{width:100%;border-collapse:collapse;}
  th,td{padding:12px 14px;border-bottom:1px solid #eef1f6;text-align:left;font-size:13px;}
  th{background:linear-gradient(180deg,#1b4fff,#1442d7);color:#fff;font-weight:900;}
  .btn{background:#1b4fff;color:#fff;border:none;border-radius:12px;padding:10px 14px;font-weight:900;cursor:pointer;}
  .date{padding:8px 10px;border:1px solid #e9edf5;border-radius:10px;}
  .date:disabled{opacity:.5;background:#f3f5f9;cursor:not-allowed;}
</style>

<div class="wrap">
  <div class="panel">
    <div class="head">
      <h2>Select Rooms + Dates</h2>
      <p style="margin-top:8px;color:#555;">Select multiple rooms and choose duration for each.</p>
    </div>

    <!-- ✅ add id="bookingForm" -->
    <form id="bookingForm" action="<%=request.getContextPath()%>/confirmBooking" method="post">
      <table>
        <thead>
          <tr>
            <th>Select</th>
            <th>Room No</th>
            <th>Type</th>
            <th>Price/Night</th>
            <th>Check-in</th>
            <th>Check-out</th>
          </tr>
        </thead>
        <tbody>
        <%
          if(rooms == null || rooms.isEmpty()){
        %>
          <tr><td colspan="6">No available rooms right now.</td></tr>
        <%
          } else {
            for(Room r: rooms){
        %>
          <tr>
            <td>
              <input type="checkbox" class="room-check" name="roomId" value="<%=r.getId()%>">
            </td>
            <td><%=r.getRoomNo()%></td>
            <td><%=r.getRoomType()%></td>
            <td><%=r.getPrice()%></td>

            <td>
              <input class="date" type="date" name="checkIn_<%=r.getId()%>" disabled>
            </td>

            <td>
              <input class="date" type="date" name="checkOut_<%=r.getId()%>" disabled>
            </td>
          </tr>
        <%
            }
          }
        %>
        </tbody>
      </table>

      <div style="padding:16px 18px;display:flex;justify-content:flex-end;">
        <button class="btn" type="submit">Confirm Booking</button>
      </div>
    </form>
  </div>
</div>

<script>
  const form = document.getElementById("bookingForm");
  const checks = document.querySelectorAll(".room-check");

  // Enable + require dates only when checkbox is checked
  checks.forEach(cb => {
    cb.addEventListener("change", () => {
      const tr = cb.closest("tr");
      const inEl = tr.querySelector('input[name^="checkIn_"]');
      const outEl = tr.querySelector('input[name^="checkOut_"]');

      if (!inEl || !outEl) return;

      if (cb.checked) {
        inEl.disabled = false;
        outEl.disabled = false;
        inEl.required = true;
        outEl.required = true;
      } else {
        inEl.required = false;
        outEl.required = false;
        inEl.value = "";
        outEl.value = "";
        inEl.disabled = true;
        outEl.disabled = true;
      }
    });
  });

  // Must select at least 1 room
  form.addEventListener("submit", (e) => {
    const anyChecked = Array.from(checks).some(x => x.checked);
    if (!anyChecked) {
      e.preventDefault();
      alert("Please select at least one room.");
    }
  });
</script>