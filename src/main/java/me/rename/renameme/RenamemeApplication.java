package me.rename.renameme;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * The application's entry point.
 */
@SpringBootApplication
public class RenamemeApplication {

    public static void main(final String[] args) {
        SpringApplication.run(RenamemeApplication.class, args);
    }

    public static String getWelcomeMessage() {
        return "Read the readme to get started";
    }
}
