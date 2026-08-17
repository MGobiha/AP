package model;

public class Room {
    private int id;
    private String roomNo;
    private String roomType;
    private double price;
    private String status;
    
    private int packageId;
    
    public int getPackageId(){ return packageId; }
    public void setPackageId(int packageId){ this.packageId = packageId; }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getRoomNo() { return roomNo; }
    public void setRoomNo(String roomNo) { this.roomNo = roomNo; }

    public String getRoomType() { return roomType; }
    public void setRoomType(String roomType) { this.roomType = roomType; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
