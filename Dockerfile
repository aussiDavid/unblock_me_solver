FROM elixir:latest

WORKDIR /usr/src/app

RUN apt-get update && \
  apt-get install -y inotify-tools

RUN mix local.hex --force

COPY mix.exs ./
COPY mix.lock ./
RUN mix deps.get


COPY . .

RUN mix compile

cmd "while true; do sleep 1; echo '.'; done"
