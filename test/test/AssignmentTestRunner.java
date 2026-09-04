package test;

import service.BillingServiceTest;
import util.JsonUtil;
import util.ValidationUtilTest;

/**
 * Test automation entry point. Run as a Java application in NetBeans
 * (Right click file → Run File) after compiling the project.
 */
public class AssignmentTestRunner {

    public static void main(String[] args) {
        int failed = 0;
        System.out.println("=== Ocean View Resort automated tests ===");
        failed += new BillingServiceTest().run();
        failed += new ValidationUtilTest().run();
        failed += jsonTests();
        if (failed == 0) {
            System.out.println("ALL TESTS PASSED");
        } else {
            System.out.println("TESTS FAILED: " + failed);
            System.exit(1);
        }
    }

    private static int jsonTests() {
        int failed = 0;
        String json = JsonUtil.object("ok", "true", "message", JsonUtil.quote("hello \"world\""));
        if (!json.contains("\"ok\":true") || !json.contains("hello \\\"world\\\"")) {
            System.out.println("  FAIL json object encoding");
            failed++;
        } else {
            System.out.println("  PASS json object encoding");
        }
        String err = JsonUtil.error(404, "Missing");
        if (!err.contains("404") || !err.contains("Missing")) {
            System.out.println("  FAIL json error payload");
            failed++;
        } else {
            System.out.println("  PASS json error payload");
        }
        System.out.println("JsonUtilTest failed=" + failed);
        return failed;
    }
}
