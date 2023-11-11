FROM portainer/portainer-ce:latest

EXPOSE 9000

CMD ["docker", "run", "-d", "-p", "9000:9000", "--restart", "always", "-v", "/var/run/docker.sock:/var/run/docker.sock", "portainer/portainer-ce:latest"]
