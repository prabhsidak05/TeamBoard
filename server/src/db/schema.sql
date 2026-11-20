CREATE TABLE users (
  id            SERIAL PRIMARY KEY,
  email         TEXT UNIQUE NOT NULL,
  name          TEXT NOT NULL,
  password_hash TEXT NOT NULL,
  created_at    TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE boards (
  id         SERIAL PRIMARY KEY,
  title      TEXT NOT NULL,
  owner_id   INT REFERENCES users(id) ON DELETE CASCADE,
  invite_code TEXT UNIQUE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE board_members (
  board_id INT REFERENCES boards(id) ON DELETE CASCADE,
  user_id  INT REFERENCES users(id) ON DELETE CASCADE,
  role     TEXT NOT NULL DEFAULT 'member',  -- owner | member | viewer
  PRIMARY KEY (board_id, user_id)
);

CREATE TABLE lists (
  id       SERIAL PRIMARY KEY,
  board_id INT REFERENCES boards(id) ON DELETE CASCADE,
  title    TEXT NOT NULL,
  position DOUBLE PRECISION NOT NULL
);

CREATE TABLE cards (
  id          SERIAL PRIMARY KEY,
  list_id     INT REFERENCES lists(id) ON DELETE CASCADE,
  title       TEXT NOT NULL,
  description TEXT,
  position    DOUBLE PRECISION NOT NULL,
  created_by  INT REFERENCES users(id),
  created_at  TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_lists_board ON lists(board_id, position);
CREATE INDEX idx_cards_list  ON cards(list_id, position);