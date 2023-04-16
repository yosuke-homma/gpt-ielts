# An app to practice IELTS Writing using ChatGPT

## Setup instructions

1. Run `docker-compose build`:
  ```
  $ docker-compose build
  ```

2. Start the docker container to launch the Rails server:
  ```
  $ docker-compose up -d
  ```

3. Create and migrate the database:
  ```
  $ docker-compose exec web rails db:create
  $ docker-compose exec web rails db:migrate
  ```

4. Create a `.env` file in the project root directory with your OpenAI access token:
  ```
  OPENAI_ACCESS_TOKEN = WRITE_YOUR_OPENAI_ACCESS_TOKEN_HERE
  ```
