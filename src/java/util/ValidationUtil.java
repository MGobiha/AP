package util;

import java.time.LocalDate;
import java.util.regex.Pattern;

public class ValidationUtil {

    private static final Pattern PHONE = Pattern.compile("^[0-9+]{9,15}$");
    private static final Pattern USERNAME = Pattern.compile("^[A-Za-z0-9._-]{4,50}$");
    private static final Pattern RESERVATION_NO = Pattern.compile("^RES-[0-9]{8}-[0-9]+$");

    private ValidationUtil() {
    }

    public static boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    public static String trim(String value) {
        return value == null ? "" : value.trim();
    }

    public static boolean isValidName(String name) {
        return !isBlank(name) && trim(name).length() >= 3;
    }

    public static boolean isValidPhone(String phone) {
        return phone != null && PHONE.matcher(phone.trim()).matches();
    }

    public static boolean isValidUsername(String username) {
        return username != null && USERNAME.matcher(username.trim()).matches();
    }

    public static boolean isValidPassword(String password) {
        return password != null && password.length() >= 6;
    }

    public static boolean isValidAddress(String address) {
        return !isBlank(address) && trim(address).length() >= 5;
    }

    public static boolean isValidDateRange(LocalDate checkIn, LocalDate checkOut) {
        return checkIn != null && checkOut != null && checkOut.isAfter(checkIn);
    }

    public static boolean isValidReservationNo(String reservationNo) {
        return reservationNo != null && RESERVATION_NO.matcher(reservationNo.trim()).matches();
    }

    public static boolean isPositiveNumber(String raw) {
        try {
            return Double.parseDouble(raw) > 0;
        } catch (Exception e) {
            return false;
        }
    }
}
