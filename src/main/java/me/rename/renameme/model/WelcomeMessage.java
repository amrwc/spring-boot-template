package me.rename.renameme.model;

import lombok.*;
import org.hibernate.annotations.Immutable;

import javax.persistence.*;

@Entity
@Getter
@Setter
@Immutable
@EqualsAndHashCode
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "WELCOME_MESSAGES")
@SequenceGenerator(name = "seq", sequenceName = "WELCOME_MESSAGES_SEQ", allocationSize = 1)
public class WelcomeMessage {

    @Id
    @Column(name = "ID")
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq")
    private Long id;

    @Column(name = "CONTENT", length = 64)
    private String content;

    public WelcomeMessage(final String content) {
        this.content = content;
    }
}
