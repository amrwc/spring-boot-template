--liquibase formatted sql

--changeset amrw:20210310-02
CREATE TABLE WELCOME_MESSAGES (
    ID      UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    CONTENT VARCHAR(64) NOT NULL CHECK (CONTENT <> '')
);
COMMENT ON TABLE WELCOME_MESSAGES IS 'Messages to welcome the users';
COMMENT ON COLUMN WELCOME_MESSAGES.ID IS 'Unique identifier of a welcome message';
COMMENT ON COLUMN WELCOME_MESSAGES.CONTENT IS 'Content of a welcome message';

-- Initial value
INSERT INTO WELCOME_MESSAGES (CONTENT) VALUES ('Welcome! Read the readme to get started.');

--rollback DROP TABLE WELCOME_MESSAGES;
