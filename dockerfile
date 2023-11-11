FROM portainer/community:latest

COPY portainer.yml /app/portainer.yml

EXPOSE 9443
CMD ["/app/portainer"]
