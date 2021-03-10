package me.rename.renameme.controller;

import lombok.extern.log4j.Log4j2;
import me.rename.renameme.model.WelcomeMessage;
import me.rename.renameme.request.WelcomeMessageRequest;
import me.rename.renameme.service.WelcomeMessageService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.validation.Valid;
import java.util.List;

/**
 * A controller that welcomes the user.
 */
@Log4j2
@RestController
@RequestMapping("/api/welcome")
public class WelcomeController {

    private final WelcomeMessageService service;

    public WelcomeController(final WelcomeMessageService service) {
        this.service = service;
    }

    /** @return all welcome messages */
    @RequestMapping(method = RequestMethod.GET)
    public ResponseEntity<List<WelcomeMessage>> getAllWelcomeMessages() {
        log.info("Fetching all welcome messages with");
        return new ResponseEntity<>(service.findAllWelcomeMessages(), HttpStatus.OK);
    }

    /**
     * Persists the given welcome message in the database.
     * @param request welcome message to persist
     * @return HTTP status
     */
    @RequestMapping(method = RequestMethod.POST)
    public ResponseEntity<HttpStatus> addWelcome(@RequestBody @Valid WelcomeMessageRequest request) {
        log.info("Creating a welcome message: {}", request);
        service.createWelcomeMessage(request.getContent());
        return new ResponseEntity<>(HttpStatus.CREATED);
    }
}
