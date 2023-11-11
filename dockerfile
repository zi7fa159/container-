FROM portainer/portainer-ce:latest

# Set the working directory to /app
WORKDIR /app

# Copy the application code into the container
COPY . /app

# Install any needed packages
RUN npm install

# Expose the port and start the server
EXPOSE 9000
CMD ["npm", "start"]
