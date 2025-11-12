package com.happypaws.petcare.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;

public class PasswordUtil {
    public static String hash(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] out = md.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder(out.length * 2);
            for (byte v : out) sb.append(String.format("%02x", v));
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public static boolean verify(String rawPassword, String storedHash) {
        if (storedHash == null) return false;
        // Accept SHA-256 hex hashes
        if (storedHash.matches("^[a-fA-F0-9]{64}$")) {
            return storedHash.equalsIgnoreCase(hash(rawPassword));
        }
        // Dev/legacy fallback (plain text)
        return storedHash.equals(rawPassword);
    }
}


