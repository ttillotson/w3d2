-- USERS


DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY
  fname TEXT
  lname TEXT
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Travis', 'Tillotson'), ('Ozzy', 'Paniagua'), ('Matthew', 'Martinez');



-- QUESTIONS


DROP TABLE IF EXISTS questions;

CREATE TABLE questions (
  id INTEGER PRIMARY KEY
  title TEXT NOT NULL
  body TEXT NOT NULL
  author_id INTEGER NOT NULL

  FOREIGN KEY (author_id) REFERENCES users(id)
);

  INSERT INTO
    questions (title, body, author_id)
  SELECT
    'Travis'' question', 'Did you hear about the fire at the circus?', users.id
  FROM
    users
  WHERE
    fname = 'Travis' AND lname = 'Tillotson';

  INSERT INTO
    questions (title, body, author_id)
  SELECT
    'Ozzy''s question', 'PINEAPPLES', users.id
  FROM
    users
  WHERE
    fname = 'Ozzy' AND lname = 'Paniagua';

  INSERT INTO
    questions (title, body, author_id)
  SELECT
    'Matthew''s question', 'Worst classroom experience?', users.id
  FROM
    users
  WHERE
    fname = 'Matthew' AND lname = 'Martinez';


-- QUESTION_FOLLOWS

DROP TABLE IF EXISTS question_follows;
-- JOINS users and questions
CREATE TABLE question_follows (
  id INTEGER NOT NULL
  user_id INTEGER NOT NULL
  question_id INTEGER NOT NULL

  FOREIGN KEY (user_id) REFERENCES users(id)
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

  INSERT INTO
    question_follows (user_id, question_id)

  -- Looking at the seeding in the solution it looks like we are going to have
  -- other people answer the questions
  VALUES
    ((SELECT id FROM users WHERE fname = 'Travis' AND lname = 'Tillotson'),
      (SELECT id FROM questions WHERE title = 'Ozzy''s question'));
    ((SELECT id FROM users WHERE fname = 'Matthew' AND lname = 'Martinez'),
      (SELECT id FROM questions WHERE title = 'Ozzy''s question'));

-- REPLIES

DROP TABLE IF EXISTS replies;

CREATE TABLE replies (
  id INTEGER PRIMARY KEY
  question_id INTEGER NOT NULL
  parent_reply_id INTEGER NOT NULL
  author_id INTEGER NOT NULL
  body TEXT NOT NULL

  FOREIGN KEY (question_id) REFERENCES questions(id)
  FOREIGN KEY (parent_reply_id) REFERENCES replies(id)
  FOREIGN KEY (author_id) REFERENCES users(id)
);

  INSERT INTO
    replies (question_id, parent_reply_id, author_id, body)
  VALUES
    ((SELECT id FROM questions WHERE title = 'Travis''s question'),
    NULL,
    (SELECT id FROM users WHERE fname = 'Travis' AND lname = 'Tillotson'),
    'it was in tents');

  INSERT INTO
    replies (question_id, parent_reply_id, author_id, body)
  VALUES
    ((SELECT id FROM questions WHERE title = 'Travis''s question'),
    (SELECT id FROM replies WHERE body = 'it was in tents'),
    (SELECT id FROM users WHERE fname = 'Ozzy'AND lname = 'Paniagua'),
    'It was intense?');

  INSERT INTO
    replies (question_id, parent_reply_id, author_id, body)
  VALUES
    ((SELECT id FROM questions WHERE title = 'Travis''s question'),
    (SELECT id FROM replies WHERE body = 'It was intense?'),
    (SELECT id FROM users WHERE fname = 'Matthew' AND lname = 'Martinez'),
    'It was in tents. Cause its a circus...\nBad joke, Travis...')



DROP TABLE IF EXISTS question_likes;

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY
  user_id INTEGER NOT NULL
  question_id INTEGER NOT NULL

  FOREIGN KEY (user_id) REFERENCES users(id)
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

  INSERT INTO
    question_likes (user_id, question_id)
  VALUES
    (1, 1);

  INSERT INTO
    question_likes (user_id, question_id)
  VALUES
    (1, 2);
