FROM portainer/portainer-ce:latest

# Expose the Portainer port
EXPOSE 9000

# Set up persistent storage for the Docker socket
VOLUME /var/run/docker.sock

# Command to run Portainer
CMD ["-p", "9000:9000", "--restart", "always", "-v", "/var/run/docker.sock:/var/run/docker.sock"]
