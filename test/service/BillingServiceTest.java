package service;

import java.time.LocalDate;

/**
 * Automated tests for billing rules. Run {@link test.AssignmentTestRunner}.
 * These tests were written before the servlet wiring (TDD for the calculation engine).
 */
public class BillingServiceTest {

    private final BillingService service = new BillingService();
    private int passed;
    private int failed;

    public int run() {
        passed = 0;
        failed = 0;
        testTwoNights();
        testRejectsSameDayCheckout();
        testRejectsNegativePrice();
        testGrandTotalIncludesServiceFee();
        testNightsTimesPrice();
        System.out.println("BillingServiceTest passed=" + passed + " failed=" + failed);
        return failed;
    }

    private void testTwoNights() {
        long nights = service.countNights(LocalDate.of(2026, 9, 1), LocalDate.of(2026, 9, 3));
        check("two nights", nights == 2);
    }

    private void testRejectsSameDayCheckout() {
        boolean thrown = false;
        try {
            service.countNights(LocalDate.of(2026, 9, 1), LocalDate.of(2026, 9, 1));
        } catch (IllegalArgumentException ex) {
            thrown = true;
        }
        check("same-day checkout rejected", thrown);
    }

    private void testRejectsNegativePrice() {
        boolean thrown = false;
        try {
            service.calculateRoomTotal(-10, LocalDate.of(2026, 9, 1), LocalDate.of(2026, 9, 2));
        } catch (IllegalArgumentException ex) {
            thrown = true;
        }
        check("negative price rejected", thrown);
    }

    private void testGrandTotalIncludesServiceFee() {
        double total = service.calculateBillTotal(10000, LocalDate.of(2026, 9, 1), LocalDate.of(2026, 9, 3));
        check("grand total 2 nights + fee", total == 20500.00);
    }

    private void testNightsTimesPrice() {
        double total = service.calculateRoomTotal(8000, 3);
        check("3 nights * 8000", total == 24000.00);
    }

    private void check(String name, boolean ok) {
        if (ok) {
            passed++;
            System.out.println("  PASS " + name);
        } else {
            failed++;
            System.out.println("  FAIL " + name);
        }
    }
}
