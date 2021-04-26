# OverTheAir

This repo is a basic implementation for uploading a firmware to a device. The device is mocked by using a node.js server (not included).
## Commands:

- `start()` - read a hex file and, parsing every line and sending request to an endpoint (by default `http://localhost:3000/`). Returns `{:ok, "Delivery succesfully completed."}` if the file was send successfully. Otherwise, it throws an error in the form `{:error, some_message}`.  
- `check_device_status()` - Make a request to the endpoint to know the actual state of the server/device.
- `reset_device_status()` - Reset the server/device in case is needed.

## Installation

- This app works with `httpoison`, so, remember to run `mix deps.get`.
- To run the app start an iex session by using `iex -S mix` command. After that you can use one of the three commands (see commands section).
- **REMEMBER** running the node.js server.

## Note

- When running the app there a bunch of log messages indicating how is the app working. Do not be overweling, this can be disable by adjusting the Logger configuration.

## Missing
- Documentation is not included (tech debt)
- More testing is needed (future tests would require mocks)
