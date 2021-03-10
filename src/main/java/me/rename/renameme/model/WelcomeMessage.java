package me.rename.renameme.model;

import lombok.*;
import org.hibernate.annotations.Immutable;

import javax.persistence.*;
import javax.validation.constraints.NotBlank;
import java.util.UUID;

@Data
@Entity
@Immutable
@NoArgsConstructor
@Table(name = "WELCOME_MESSAGES")
public class WelcomeMessage {

    @Id
    @GeneratedValue
    @Column(name = "ID", unique = true, nullable = false, insertable = false, updatable = false)
    private UUID id;

    @Column(name = "CONTENT", length = 64, nullable = false, updatable = false)
    @NotBlank(message = "Welcome message content cannot be blank")
    private String content;

    public WelcomeMessage(final String content) {
        this.content = content;
    }
}
