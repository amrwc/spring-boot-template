package me.rename.renameme.controller;

import lombok.extern.log4j.Log4j2;
import me.rename.renameme.model.WelcomeMessage;
import me.rename.renameme.repository.WelcomeMessageRepository;
import me.rename.renameme.request.WelcomeMessageRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

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

    /**
     * Fetches the welcome message with the given ID.
     * @param id optional ID
     * @return welcome message with the given ID
     */
    @RequestMapping(path = "/api/welcome/{id}", method = RequestMethod.GET)
    public ResponseEntity<WelcomeMessage> welcome(@PathVariable Optional<Long> id) {
        log.info("Fetching the first welcome message");
        return repository.findById(id.orElse(1L))
                .map(welcomeMessage -> new ResponseEntity<>(welcomeMessage, HttpStatus.OK))
                .orElse(new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }

    /**
     * Persists the given welcome message in the database.
     * @param request welcome message to persist
     * @return HTTP status
     */
    @RequestMapping(path = "/api/welcome", method = RequestMethod.POST)
    public ResponseEntity<HttpStatus> addWelcome(@RequestBody WelcomeMessageRequest request) {
        log.info("Persisting the given welcome message");
        return Optional.of(repository.save(new WelcomeMessage(request.getContent())))
                .map(ignored -> new ResponseEntity<HttpStatus>(HttpStatus.CREATED))
                .orElse(new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR));
    }
}
