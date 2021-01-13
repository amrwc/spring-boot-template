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
public class WelcomeMessage {

    @Id
    @GeneratedValue
    @Column(name = "ID")
    private Long id;

    @Column(name = "CONTENT", length = 64)
    private String content;
}
