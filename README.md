# Convert YouTube copyright claims to video descriptions

### turns this

![](docs/images/before.png)

### into this

![](docs/images/after.png)

### by doing this

1. Open Chrome DevTools’ Network inspector, and look for an API call to `list_creator_received_claims`.

2. Copy the contents and paste it into a file.

3. ruby generate.rb data.json
