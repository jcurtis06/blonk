# Blonk

Essentially hide and seek... online... in the dark... oh and with guns. And upgrades. Don't forget about the upgrades, Jeffery.

## Local Development Setup

1. Clone the repo
2. Build the server Godot project
3. Install Flask if not already installed, `pip install flask`
4. Run `python server/master_server.py`, use `--build="path/to/executable`
5. Open `client/project.godot`, click "Host". A new server instance should start and the lobby code will be copied to your clipboard once the server is active.
6. Enjoy!!!

## How it Works

Blonk takes a unique approach to multiplayer. Most games use a third-party multiplayer API to handle custom game rooms. Blonk, however, is different. There are three separate applications, the client, the server, and the master server. Each has an important role.

### Client

- This is where the bulk of the action happens.
- End-users will have a copy of the client build.

### Server

- The middleman, handles broadcasting data from one client to others.
- Instances are created by the master server.

### Master Server

- A RESTful API, made in Python.
- Provides endpoints for creating & joining games.

## Useful Resources

- [Godot's High Level Multiplayer Docs](https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html)
- [Scene Replication in Godot](https://godotengine.org/article/multiplayer-in-godot-4-0-scene-replication/)
- [Godot 4.1 Documentation](https://docs.godotengine.org/en/stable/)
