package examples.util;

import java.security.SecureRandom;

public final class RandomDataUtil {

    private static final String ALPHA = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    private static final String ALPHANUMERIC = ALPHA + "0123456789";
    private static final SecureRandom RANDOM = new SecureRandom();

    private RandomDataUtil() {
    }

    public static String randomAlpha(int length) {
        return generate(length, ALPHA);
    }

    public static String randomAlphanumeric(int length) {
        return generate(length, ALPHANUMERIC);
    }

    private static String generate(int length, String alphabet) {
        if (length <= 0) {
            throw new IllegalArgumentException("length must be greater than zero");
        }
        StringBuilder value = new StringBuilder(length);
        for (int index = 0; index < length; index++) {
            int charIndex = RANDOM.nextInt(alphabet.length());
            value.append(alphabet.charAt(charIndex));
        }
        return value.toString();
    }
}
