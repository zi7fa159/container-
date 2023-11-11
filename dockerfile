FROM portainer/portainer-ce:latest

# Expose the Portainer port
EXPOSE 9000

# Set up persistent storage for the Docker socket
VOLUME /var/run/docker.sock

# Set the default Portainer data directory
CMD ["--data", "/data"]

# Override the entry point to include necessary flags
ENTRYPOINT ["--host=0.0.0.0", "--no-auth"]
