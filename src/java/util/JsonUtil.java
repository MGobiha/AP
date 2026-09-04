package util;

public class JsonUtil {

    private JsonUtil() {
    }

    public static String quote(String value) {
        if (value == null) {
            return "null";
        }
        String escaped = value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "\\r")
                .replace("\n", "\\n");
        return "\"" + escaped + "\"";
    }

    public static String object(String... keysAndValues) {
        if (keysAndValues.length % 2 != 0) {
            throw new IllegalArgumentException("Keys and values must be pairs");
        }
        StringBuilder sb = new StringBuilder("{");
        for (int i = 0; i < keysAndValues.length; i += 2) {
            if (i > 0) {
                sb.append(",");
            }
            sb.append(quote(keysAndValues[i])).append(":").append(keysAndValues[i + 1]);
        }
        sb.append("}");
        return sb.toString();
    }

    public static String error(int status, String message) {
        return object("ok", "false", "status", String.valueOf(status), "message", quote(message));
    }
}
