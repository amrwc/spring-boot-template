package me.rename.renameme.controller;

import lombok.extern.log4j.Log4j2;
import me.rename.renameme.model.WelcomeMessage;
import me.rename.renameme.repository.WelcomeMessageRepository;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

/**
 * A controller that welcomes the user.
 */
@Log4j2
@RestController
public class WelcomeController {

    private final WelcomeMessageRepository repository;

    public WelcomeController(final WelcomeMessageRepository repository) {
        this.repository = repository;
    }

    @RequestMapping(path = "/api/welcome", method = RequestMethod.GET)
    public ResponseEntity<WelcomeMessage> welcome() {
        log.info("Fetching the first welcome message");
        return new ResponseEntity<>(
                repository.findById(1L)
                        .orElseThrow(() -> new IllegalArgumentException("The first WelcomeMessage has not been found")),
                HttpStatus.OK
        );
    }
}
