package me.rename.renameme.service;

import me.rename.renameme.model.WelcomeMessage;
import me.rename.renameme.repository.WelcomeMessageRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Captor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;

import static org.apache.commons.lang3.RandomStringUtils.randomAlphanumeric;
import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class WelcomeMessageServiceTest {

    @Mock
    private WelcomeMessageRepository repository;
    @InjectMocks
    private WelcomeMessageService service;

    @Mock
    private WelcomeMessage welcomeMessage;
    @Captor
    private ArgumentCaptor<WelcomeMessage> welcomeMessageCaptor;

    @Test
    @DisplayName("Should have found all WelcomeMessages")
    void shouldHaveFoundAllWelcomeMessages() {
        final var welcomeMessages = List.of(welcomeMessage);
        when(repository.findAll()).thenReturn(welcomeMessages);
        assertThat(service.findAllWelcomeMessages()).isEqualTo(welcomeMessages);
    }

    @Test
    @DisplayName("Should have created a new WelcomeMessage with the given content")
    void shouldHaveCreatedWelcomeMessage() {
        final var content = randomAlphanumeric(16);
        when(repository.save(any(WelcomeMessage.class))).thenReturn(welcomeMessage);
        assertThat(service.createWelcomeMessage(content)).isEqualTo(welcomeMessage);
        verify(repository).save(welcomeMessageCaptor.capture());
        assertThat(welcomeMessageCaptor.getValue().getContent()).isEqualTo(content);
    }
}
