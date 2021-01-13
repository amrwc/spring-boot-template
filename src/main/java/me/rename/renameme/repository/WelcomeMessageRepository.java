package me.rename.renameme.repository;

import me.rename.renameme.model.WelcomeMessage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * Repository for the welcome messages.
 */
@Repository
public interface WelcomeMessageRepository extends JpaRepository<WelcomeMessage, Long> {
}
