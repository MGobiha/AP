package service;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

/**
 * Business-logic service for overnight stay billing.
 * Kept independent of JDBC so it can be unit-tested (TDD).
 */
public class BillingService {

    public static final double CONSULTATION_EQUIVALENT_FEE = 500.00;

    public long countNights(LocalDate checkIn, LocalDate checkOut) {
        if (checkIn == null || checkOut == null) {
            throw new IllegalArgumentException("Check-in and check-out dates are required");
        }
        long nights = ChronoUnit.DAYS.between(checkIn, checkOut);
        if (nights < 1) {
            throw new IllegalArgumentException("Check-out must be after check-in");
        }
        return nights;
    }

    public double calculateRoomTotal(double pricePerNight, LocalDate checkIn, LocalDate checkOut) {
        if (pricePerNight < 0) {
            throw new IllegalArgumentException("Price per night cannot be negative");
        }
        return countNights(checkIn, checkOut) * pricePerNight;
    }

    public double calculateRoomTotal(double pricePerNight, long nights) {
        if (nights < 1) {
            throw new IllegalArgumentException("At least one night is required");
        }
        if (pricePerNight < 0) {
            throw new IllegalArgumentException("Price per night cannot be negative");
        }
        return nights * pricePerNight;
    }

    /**
     * Hotel equivalent of "treatment cost + consultation fee":
     * room nights plus a fixed service charge.
     */
    public double calculateBillTotal(double pricePerNight, LocalDate checkIn, LocalDate checkOut) {
        return calculateRoomTotal(pricePerNight, checkIn, checkOut) + CONSULTATION_EQUIVALENT_FEE;
    }

    public double calculateBillTotal(double pricePerNight, long nights) {
        if (nights < 1) {
            throw new IllegalArgumentException("At least one night is required");
        }
        if (pricePerNight < 0) {
            throw new IllegalArgumentException("Price per night cannot be negative");
        }
        return (nights * pricePerNight) + CONSULTATION_EQUIVALENT_FEE;
    }
}
