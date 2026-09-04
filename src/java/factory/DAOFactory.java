package factory;

import dao.DashboardDAO;
import dao.PackageDAO;
import dao.ReservationDAO;
import dao.RoomDAO;
import dao.UserDAO;

/**
 * Factory design pattern: central place to create DAO objects.
 * Combined with Singleton so the rest of the app does not call {@code new XxxDAO()}
 * from every servlet.
 */
public class DAOFactory {

    private static final DAOFactory INSTANCE = new DAOFactory();

    private DAOFactory() {
    }

    public static DAOFactory getInstance() {
        return INSTANCE;
    }

    public UserDAO createUserDAO() {
        return new UserDAO();
    }

    public RoomDAO createRoomDAO() {
        return new RoomDAO();
    }

    public PackageDAO createPackageDAO() {
        return new PackageDAO();
    }

    public ReservationDAO createReservationDAO() {
        return new ReservationDAO();
    }

    public DashboardDAO createDashboardDAO() {
        return new DashboardDAO();
    }
}
