package me.rename.renameme.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import me.rename.renameme.TestType;
import me.rename.renameme.request.WelcomeMessageRequest;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;

import static org.apache.commons.lang3.RandomStringUtils.randomAlphanumeric;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@Tag(TestType.IntegrationTest)
public class WelcomeControllerIntegrationTest {

    @Autowired
    private ObjectMapper objectMapper;
    @Autowired
    private MockMvc mockMvc;

    @Test
    @DisplayName("Should have got all WelcomeMessages")
    void shouldHaveGotAllWelcomeMessages() throws Exception {
        mockMvc.perform(get("/api/welcome"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0]['id']").isNotEmpty());
    }

    @Test
    @DisplayName("Should have persisted the new WelcomeMessage")
    void shouldHaveAddedWelcome() throws Exception {
        final var welcomeMessageRequest = new WelcomeMessageRequest();
        welcomeMessageRequest.setContent(randomAlphanumeric(16));
        mockMvc.perform(post("/api/welcome")
                .contentType("application/json")
                .content(objectMapper.writeValueAsString(welcomeMessageRequest))
        ).andExpect(status().isCreated());
    }
}
