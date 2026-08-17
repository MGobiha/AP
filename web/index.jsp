<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Users"%>
<%@ page import="dao.PackageDAO" %>
<%@ page import="model.Package" %>
<%@ page import="java.util.*" %>

<%
  PackageDAO pdao = new PackageDAO();
  List<Package> packageList = pdao.findAll(); // we will filter ACTIVE in JSP
%>
<%
    Users u = (Users) session.getAttribute("user");
    boolean loggedIn = (u != null);

    String username = loggedIn ? u.getUsername() : "";
    String avatarLetter = "U";
    if (loggedIn && username != null && username.length() > 0) {
        avatarLetter = username.substring(0, 1).toUpperCase();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Ocean View Resort | Book Your Stay</title>

  <style>
    *{margin:0;padding:0;box-sizing:border-box;font-family:Segoe UI, Arial, sans-serif;}
    body{background:#f5f7fb;color:#111;}

    /* Layout */
    .container{max-width:1100px;margin:0 auto;padding:0 18px;}

    /* Navbar */
    .nav{
      position:sticky; top:0; z-index:10;
      background:#fff;
      border-bottom:1px solid #eef1f6;
    }
    .nav-inner{
      height:70px;
      display:flex; align-items:center; justify-content:space-between;
    }
    .brand{font-weight:800;font-size:20px;letter-spacing:.2px;}
    .menu{display:flex;gap:18px;align-items:center;}
    .menu a{
      text-decoration:none;color:#444;font-size:14px;
      padding:8px 10px;border-radius:10px;
    }
    .menu a:hover{background:#f3f6ff;color:#1b4fff;}

    .actions{display:flex;gap:10px;align-items:center;}

    .btn{
      text-decoration:none;font-size:14px;font-weight:600;
      padding:10px 14px;border-radius:999px;display:inline-block;
      border:1px solid #dbe3ff;
    }
    .btn-outline{color:#1b4fff;background:#fff;}
    .btn-outline:hover{background:#f3f6ff;}
    .btn-primary{background:#1b4fff;color:#fff;border-color:#1b4fff;}
    .btn-primary:hover{filter:brightness(.95);}

    /* User pill */
    .user-pill{
      display:flex;gap:10px;align-items:center;
      padding:8px 12px;border-radius:999px;border:1px solid #eef1f6;background:#fff;
      text-decoration:none;color:#111;
    }
    .user-pill:hover{background:#f8faff;}
    .avatar{
      width:34px;height:34px;border-radius:50%;
      background:#1b4fff;color:#fff;display:flex;align-items:center;justify-content:center;
      font-weight:800;
    }
    .name{font-weight:700;font-size:14px;max-width:140px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;}

    /* Hero */
    .hero-wrap{padding:18px 0 6px;}
    .hero{
      position:relative;
      height:320px;
      border-radius:22px;
      overflow:hidden;
      background:
        linear-gradient(90deg, rgba(0,0,0,.55), rgba(0,0,0,.15)),
        url("https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=1600&q=70");
      background-size:cover;
      background-position:center;
    }
    .hero-content{
      position:absolute; inset:0;
      display:flex; flex-direction:column;
      align-items:center; justify-content:center;
      text-align:center; color:#fff;
      padding:18px;
    }
    .hero h1{font-size:34px;line-height:1.15;margin-bottom:10px;}
    .hero p{font-size:14px;opacity:.9;max-width:520px;}

    /* Search bar overlay */
    .search-bar{
      position:relative;
      margin:-34px auto 0;
      max-width:920px;
      background:#fff;
      border-radius:18px;
      box-shadow:0 14px 35px rgba(0,0,0,.12);
      padding:14px;
    }
    .search-grid{
      display:grid;
      grid-template-columns: 1.2fr 1fr 1fr .9fr 56px;
      gap:10px;
      align-items:stretch;
    }
    .field{
      border:1px solid #eef1f6;
      border-radius:14px;
      padding:10px 12px;
      background:#fff;
    }
    .label{font-size:11px;color:#777;font-weight:700;margin-bottom:4px;}
    .input{
      width:100%;
      border:none; outline:none;
      font-size:14px;color:#222;
      background:transparent;
    }
    .go{
      width:56px;height:56px;border:none;cursor:pointer;
      border-radius:16px;
      background:#1b4fff;color:#fff;
      display:flex;align-items:center;justify-content:center;
      box-shadow:0 10px 22px rgba(27,79,255,.25);
      font-size:20px;font-weight:900;
    }
    .go:hover{filter:brightness(.95);}

    /* Section */
    .section{padding:22px 0 40px;}
    .section h2{
      font-size:16px;color:#222;
      margin:18px 0 12px;
      font-weight:800;
    }

    /* Cards grid */
    .grid{
      display:grid;
      grid-template-columns: 1.2fr 1fr 1fr .9fr;
      gap:14px;
    }
    .card{
      position:relative;
      border-radius:18px;
      overflow:hidden;
      min-height:170px;
      background:#ddd;
      box-shadow:0 10px 22px rgba(0,0,0,.08);
      transform:translateZ(0);
    }
    .card img{width:100%;height:100%;object-fit:cover;display:block;filter:saturate(1.05);}
    .tag{
      position:absolute;left:12px;bottom:12px;
      background:rgba(255,255,255,.88);
      color:#111;font-weight:800;
      padding:6px 10px;border-radius:999px;font-size:12px;
      backdrop-filter: blur(6px);
    }

    .tall{grid-row:span 2; min-height:360px;}
    .stack{display:grid;grid-template-rows:1fr 1fr; gap:14px;}

    /* Footer */
    .footer{
      padding:18px 0 26px;color:#777;font-size:13px;
      border-top:1px solid #eef1f6;background:#fff;
    }

    /* Responsive */
    @media (max-width: 980px){
      .search-grid{grid-template-columns:1fr 1fr;}
      .go{width:100%; height:48px; border-radius:14px;}
      .grid{grid-template-columns:1fr 1fr;}
      .tall{grid-row:auto; min-height:220px;}
      .hero{height:300px;}
    }
    @media (max-width: 540px){
      .grid{grid-template-columns:1fr;}
      .hero h1{font-size:26px;}
      .menu{display:none;}
    }
   
  .pkg-wrap{
    margin:18px auto 0;
    max-width:920px;
    padding:20px;
    background:#fff;
    border-radius:22px;
    box-shadow:0 14px 35px rgba(0,0,0,.12);
  }
  .pkg-head{ text-align:center; margin-bottom:18px; }
  .pkg-head h2{ font-size:22px; font-weight:900; margin-bottom:6px; }
  .pkg-head p{ font-size:13px; color:#666; }

  .pkg-grid{
    display:grid;
    grid-template-columns: repeat(4, 1fr);
    gap:14px;
  }

  .pkg-card{
    border:1px solid #eef1f6;
    background:#fbfcff;
    border-radius:18px;
    padding:16px;
    text-align:center;
    transition:.2s;
  }
  .pkg-card:hover{
    transform: translateY(-2px);
    border-color:#dbe3ff;
    box-shadow:0 10px 22px rgba(27,79,255,.10);
  }

  .pkg-icon{
    width:48px;height:48px;
    margin:0 auto 10px;
    border-radius:999px;
    background:#eef3ff;
    display:flex;align-items:center;justify-content:center;
    font-size:20px;
  }

  .pkg-card h3{ font-size:15px; font-weight:900; margin-bottom:6px; }
  .pkg-sub{ font-size:12px; color:#1b4fff; font-weight:900; margin-bottom:8px; }
  .pkg-desc{ font-size:12px; color:#555; min-height:38px; margin-bottom:12px; }

  .pkg-btn{
    display:inline-block;
    text-decoration:none;
    font-weight:900;
    font-size:13px;
    color:#1b4fff;
    padding:10px 12px;
    border-radius:12px;
    background:#fff;
    border:1px solid #dbe3ff;
  }
  .pkg-btn:hover{ background:#f3f6ff; }

  @media (max-width: 980px){
    .pkg-grid{ grid-template-columns: repeat(2, 1fr); }
  }
  @media (max-width: 540px){
    .pkg-grid{ grid-template-columns: 1fr; }
  }
.gallery-title{
  text-align:center;
  font-size:24px;
  font-weight:800;
  margin-bottom:20px;
}

.gallery-grid{
  display:grid;
  grid-template-columns:repeat(3,1fr);
  grid-auto-rows:220px;
  gap:12px;
}

.gallery-item{
  overflow:hidden;
  border-radius:16px;
}

.gallery-item img{
  width:100%;
  height:100%;
  object-fit:cover;
  transition:0.3s;
}

.gallery-item:hover img{
  transform:scale(1.05);
}

.gallery-item.large{
  grid-row:span 2;
}

/* responsive */

@media(max-width:900px){
  .gallery-grid{
    grid-template-columns:repeat(2,1fr);
  }
}

@media(max-width:500px){
  .gallery-grid{
    grid-template-columns:1fr;
  }
}
  </style>
</head>

<body>

  <!-- NAVBAR -->
<jsp:include page="components/header.jsp"/>

  <!-- HERO -->
  <div class="hero-wrap">
    <div class="container">
      <div class="hero">
        <div class="hero-content">
          <h1>Book your stay with OceanView</h1>
          <p>Comfortable rooms, beachside views, and fast reservation management.</p>
        </div>
      </div>

      <!-- SEARCH BAR (UI only) -->
<!--      <div class="search-bar" id="packages">
        <form class="search-grid" action="<%= loggedIn ? "dashboard.jsp" : "login.jsp" %>" method="get">
          <div class="field">
            <div class="label">Location</div>
            <input class="input" type="text" placeholder="Where are you going?" />
          </div>

          <div class="field">
            <div class="label">Check-in</div>
            <input class="input" type="date" />
          </div>

          <div class="field">
            <div class="label">Check-out</div>
            <input class="input" type="date" />
          </div>

          <div class="field">
            <div class="label">Guests</div>
            <input class="input" type="number" min="1" value="2" />
          </div>

          <button class="go" type="submit" title="Search">➜</button>
        </form>
      </div>-->
    </div>
  </div>
<div class="pkg-wrap" id="packages">
  <div class="pkg-head">
    <h2>Our Packages</h2>
    <p>Choose the best plan for your stay.</p>
  </div>

  <div class="pkg-grid">
    <%
      boolean hasAny = false;
      if(packageList != null){
        for(Package p : packageList){
          if(!"ACTIVE".equalsIgnoreCase(p.getStatus())) continue; // only available packages
          hasAny = true;
    %>

    <div class="pkg-card">
      <div class="pkg-icon">🏷️</div>

      <h3><%= p.getName() %></h3>

      <div class="pkg-sub">
        LKR <%= String.format("%.2f", p.getPricePerNight()) %> / night
      </div>

      <div class="pkg-desc">
        <%= (p.getDescription()==null || p.getDescription().trim().isEmpty()) ? "No description." : p.getDescription() %>
      </div>

      <!-- Button behavior: if not logged in -> login.jsp , if logged in -> packages.jsp -->
      <a class="pkg-btn"
         href="<%= (loggedIn ? "packages.jsp?packageId="+p.getId() : "login.jsp") %>">
         Learn More →
      </a>
    </div>

    <%
        }
      }
      if(!hasAny){
    %>
      <div style="padding:16px;color:#666;">No active packages available right now.</div>
    <%
      }
    %>
  </div>
</div>
  <!-- POPULAR -->
  <div class="section" id="popular">
    <div class="container">
      <h2>Popular destinations</h2>

      <div class="grid">
        <div class="card tall">
            <img src="https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=1200&q=70" alt="Deluxe Room">
          <div class="tag">Deluxe Room</div>
        </div>

        <div class="stack">
          <div class="card">
            <img src="https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=70" alt="Superior Room">
            <div class="tag">Superior Room</div>
          </div>
          <div class="card">
            <img src="https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1200&q=70" alt="Family Room">

            <div class="tag">Family Room</div>
          </div>
        </div>

        <div class="card tall">
          <img src="https://images.unsplash.com/photo-1551776235-dde6d482980b?auto=format&fit=crop&w=1200&q=70" alt="Ocean View Room">
          <div class="tag">Ocean View Room</div>
        </div>

        <div class="stack">
          <div class="card">
            <img src="https://images.unsplash.com/photo-1578683010236-d716f9a3f461?auto=format&fit=crop&w=1200&q=70" alt="Premium Suite">
            <div class="tag">Premium Suite</div>
          </div>
          <div class="card">
            <img src="https://images.unsplash.com/photo-1595526114035-0d45ed16cfbf?auto=format&fit=crop&w=1200&q=70" alt="Executive Room">
            <div class="tag">Executive Room</div>
          </div>
        </div>
      </div>

    </div>
  </div>
<div class="section" id="gallery">
  <div class="container">

    <h2 class="gallery-title">Room Image Gallery</h2>

    <div class="gallery-grid">

      <div class="gallery-item large">
        <img src="https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=1200&q=70">
      </div>

      <div class="gallery-item">
        <img src="https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1200&q=70">
      </div>

      <div class="gallery-item">
        <img src="https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1200&q=70">
      </div>

      <div class="gallery-item">
        <img src="https://images.unsplash.com/photo-1551776235-dde6d482980b?auto=format&fit=crop&w=1200&q=70">
      </div>

      <div class="gallery-item">
        <img src="https://images.unsplash.com/photo-1595526114035-0d45ed16cfbf?auto=format&fit=crop&w=1200&q=70">
      </div>

      <div class="gallery-item">
        <img src="https://images.unsplash.com/photo-1578683010236-d716f9a3f461?auto=format&fit=crop&w=1200&q=70">
      </div>

    </div>

  </div>
</div>
  <!-- FOOTER -->
  <div class="footer">
    <div class="container">
      © 2026 Ocean View Resort | Reservation Management System
    </div>
  </div>

</body>
</html>