DROP TABLE IF EXISTS question_likes;

DROP TABLE IF EXISTS question_follows;

DROP TABLE IF EXISTS replies;

DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;


PRAGMA foreign_keys = ON;

-- USERS
CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname VARCHAR(255) NOT NULL,
    lname VARCHAR(255) NOT NULL
);

INSERT INTO
    users (fname, lname)
VALUES
    ('Hisham', 'Elmorsi'), ('Adam', 'Mohamed'), ('Jo', 'Alex');

-- QUESTIONS
CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    body TEXT NOT NULL,
    author_id INTEGER NOT NULL,

    FOREIGN KEY(author_id) REFERENCES users(id)
);



INSERT INTO
    questions (title, body, author_id)
SELECT
    "Hisham's question", "This is a question from Hisham", users.id
FROM
    users
WHERE
    users.fname = "Hisham" AND users.lname = "Elmorsi";

INSERT INTO
    questions (title, body, author_id)
SELECT
    "Adam's question", 'This is a question from Adam', users.id
FROM
    users
WHERE
    users.fname = 'Adam' AND users.lname = 'Mohamed';

INSERT INTO
    questions (title, body, author_id)
SELECT
    "Jo's question", 'This is a question from Jo', users.id
FROM
    users
WHERE
    users.fname = 'Jo' AND users.lname = 'Alex';

-- QUESTION FOLLOWS

CREATE TABLE question_follows (
    id INTEGER PRIMARY KEY,
    user_id INT NOT NULL,
    question_id INT NOT NULL,
    FOREIGN KEY(user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
    question_follows (user_id, question_id)
VALUES
    ((SELECT id FROM users WHERE fname = "Hisham" AND lname = 'Elmorsi'),
    (SELECT id FROM questions WHERE title = "Jo's question")),

    ((SELECT id FROM users WHERE fname = "Hisham" AND lname = 'Elmorsi'),
    (SELECT id FROM questions WHERE title = "Adam's question")),

    ((SELECT id FROM users WHERE fname = "Jo" AND lname = 'Alex'),
    (SELECT id FROM questions WHERE title = "Adam's question")
);


-- REPLIES


CREATE TABLE replies(
    id INTEGER PRIMARY KEY,
    author_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,
    parent_reply_id INTEGER,
    body TEXT NOT NULL,


    FOREIGN KEY (author_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (parent_reply_id) REFERENCES replies(id)
);

INSERT INTO
    replies (author_id, question_id, body, parent_reply_id)
VALUES
    ((SELECT id FROM users WHERE fname = "Hisham" AND lname = "Elmorsi"),
    (SELECT id FROM questions WHERE title = "Adam's question"),
    "Is that real!", NULL
);

INSERT INTO
    replies (author_id, question_id, body, parent_reply_id)
VALUES
    ((SELECT id FROM users WHERE fname = "Jo" AND lname = "Alex"),
    (SELECT id FROM questions WHERE title = "Adam's question"),
    "Certainly, Hisham",
    (SELECT id FROM replies WHERE body = "Is that real!")
);


-- QUESTION LIKES


CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN key (question_id) REFERENCES questions(id)
);


INSERT INTO
    question_likes (user_id, question_id)
VALUES
    ((SELECT id FROM users WHERE fname = "Hisham" AND lname = "Elmorsi"),
    (SELECT id FROM questions WHERE title = "Adam's question")
);

INSERT INTO
    question_likes (user_id, question_id)
VALUES
    ((SELECT id FROM users WHERE fname = "Hisham" AND lname = "Elmorsi"),
    (SELECT id FROM questions WHERE title = "Jo's question")
);

INSERT INTO
    question_likes (user_id, question_id)
VALUES
    ((SELECT id FROM users WHERE fname = "Jo" AND lname = "Alex"),
    (SELECT id FROM questions WHERE title = "Adam's question")
);
