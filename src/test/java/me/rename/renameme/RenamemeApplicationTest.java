package me.rename.renameme;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

class RenamemeApplicationTest {

    @Test
    @DisplayName("Should have returned the welcome message")
    void shouldHaveWelcomed() {
        assertThat(RenamemeApplication.getWelcomeMessage()).isEqualTo("Read the readme to get started");
    }
}
