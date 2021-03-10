package me.rename.renameme.controller;

import me.rename.renameme.model.WelcomeMessage;
import me.rename.renameme.request.WelcomeMessageRequest;
import me.rename.renameme.service.WelcomeMessageService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Captor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;

import java.util.List;

import static org.apache.commons.lang3.RandomStringUtils.randomAlphanumeric;
import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class WelcomeControllerTest {

    @Mock
    private WelcomeMessageService service;
    @InjectMocks
    private WelcomeController controller;

    @Mock
    private WelcomeMessage welcomeMessage;
    @Mock
    private WelcomeMessageRequest welcomeMessageRequest;
    @Captor
    private ArgumentCaptor<String> stringCaptor;

    @Test
    @DisplayName("Should have got all WelcomeMessages")
    void shouldHaveGotAllWelcomeMessages() {
        final var welcomeMessages = List.of(welcomeMessage);
        when(service.findAllWelcomeMessages()).thenReturn(welcomeMessages);
        final var result = controller.getAllWelcomeMessages();
        assertThat(result.getBody()).isEqualTo(welcomeMessages);
        assertThat(result.getStatusCode()).isEqualTo(HttpStatus.OK);
    }

    @Test
    @DisplayName("Should have persisted the new WelcomeMessage")
    void shouldHaveAddedWelcome() {
        final var content = randomAlphanumeric(16);
        when(welcomeMessageRequest.getContent()).thenReturn(content);
        when(service.createWelcomeMessage(anyString())).thenReturn(welcomeMessage);
        final var result = controller.addWelcome(welcomeMessageRequest);
        assertThat(result.getStatusCode()).isEqualTo(HttpStatus.CREATED);
        verify(service).createWelcomeMessage(stringCaptor.capture());
        assertThat(stringCaptor.getValue()).isEqualTo(content);
    }
}
