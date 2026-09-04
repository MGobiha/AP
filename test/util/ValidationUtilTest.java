package util;

public class ValidationUtilTest {

    private int passed;
    private int failed;

    public int run() {
        passed = 0;
        failed = 0;
        check("blank null", ValidationUtil.isBlank(null));
        check("blank spaces", ValidationUtil.isBlank("   "));
        check("valid name", ValidationUtil.isValidName("Amal Perera"));
        check("short name rejected", !ValidationUtil.isValidName("Al"));
        check("valid phone", ValidationUtil.isValidPhone("0771234567"));
        check("short phone rejected", !ValidationUtil.isValidPhone("123"));
        check("valid username", ValidationUtil.isValidUsername("client1"));
        check("short username rejected", !ValidationUtil.isValidUsername("ab"));
        check("password length", ValidationUtil.isValidPassword("secret1"));
        check("short password rejected", !ValidationUtil.isValidPassword("123"));
        check("reservation number format", ValidationUtil.isValidReservationNo("RES-20260902-171000"));
        check("bad reservation number", !ValidationUtil.isValidReservationNo("ABC-1"));
        check("positive number", ValidationUtil.isPositiveNumber("12000.50"));
        check("not a number", !ValidationUtil.isPositiveNumber("abc"));
        System.out.println("ValidationUtilTest passed=" + passed + " failed=" + failed);
        return failed;
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
