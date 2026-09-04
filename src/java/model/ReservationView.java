package model;

import java.sql.Date;

public class ReservationView {
    private int id;
    private String reservationNo;
    private int userId;
    private String clientName;
    private String clientPhone;
    private String clientAddress;
    private String clientUsername;
    private String roomNo;
    private String roomType;
    private Date checkIn;
    private Date checkOut;
    private double pricePerNight;
    private double totalAmount;
    private String status;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getReservationNo() { return reservationNo; }
    public void setReservationNo(String reservationNo) { this.reservationNo = reservationNo; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getClientName() { return clientName; }
    public void setClientName(String clientName) { this.clientName = clientName; }

    public String getClientPhone() { return clientPhone; }
    public void setClientPhone(String clientPhone) { this.clientPhone = clientPhone; }

    public String getClientAddress() { return clientAddress; }
    public void setClientAddress(String clientAddress) { this.clientAddress = clientAddress; }

    public String getClientUsername() { return clientUsername; }
    public void setClientUsername(String clientUsername) { this.clientUsername = clientUsername; }

    public String getRoomNo() { return roomNo; }
    public void setRoomNo(String roomNo) { this.roomNo = roomNo; }

    public String getRoomType() { return roomType; }
    public void setRoomType(String roomType) { this.roomType = roomType; }

    public Date getCheckIn() { return checkIn; }
    public void setCheckIn(Date checkIn) { this.checkIn = checkIn; }

    public Date getCheckOut() { return checkOut; }
    public void setCheckOut(Date checkOut) { this.checkOut = checkOut; }

    public double getPricePerNight() { return pricePerNight; }
    public void setPricePerNight(double pricePerNight) { this.pricePerNight = pricePerNight; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
