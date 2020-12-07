Visible at <http://diff.prototools.net/>

This is a website for utilities that might be useful for readers of [Introduction to Game Design, Prototyping, and Development](http://book.prototools.net/) by Jeremy Bond. The backend (found in `backend/game_assistant`) is written with Elixir's Phoenix. The frontend (found in `frontend/game_assistant`) is written in React and TypeScript using the static site generator Gatsby.

# Requirements

1) Node.js (v8+)
2) Elixir (v1.6+)
3) Yarn - optional. You can use npm if you want, but it's for your own sanity.

(For developing, you also need to install the Gatsby cli with `npm install -g gatsby-cli`)

# Setting up the backend

1) Install Elixir dependencies with `mix deps.get`.

2) Create and migrate the database with mix ecto.setup (this runs mix ecto.create, mix ecto.migrate and mix run priv/repo/seeds.exs in order)

Finally, start Phoenix with `mix phx.server`

# Deploying the backend

The backend is currently set up with Gigalixir. To deploy, first make sure you have the gigalixir remote added:

    git remote add gigalixir <gigalixir remote>

(The remote is secret, don't share it with anyone!)

Then push the backend directory!

    git subtree push --prefix backend/game_assistant gigalixir master

# Hacking on the frontend

Start up the backend, and run `gatsby develop` in the frontend to open up a Gatsby development server. Then visit `localhost:8000` to see the site!

# Copying tutorial files

The tutorial files are stored in `/tutorials`. The idea is to have one snapshot of what the tutorials look like at the end of each chapter. To do that, work on whatever tutorial you want in `tutorials/current_work` then use `copy_current_work.py` to efficiently copy your work into the `tutorials/projects` folder. Then run `generate.py` to copy the projects file into the backend, which will make them actually show up on the site.
