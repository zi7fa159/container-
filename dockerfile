# Use the official Ubuntu base image
FROM ubuntu:latest

# Update and install OpenSSH server
RUN apt-get update && \
    apt-get install -y openssh-server && \
    rm -rf /var/lib/apt/lists/*

# Change default SSH port to 80
RUN sed -i 's/Port 22/Port 80/' /etc/ssh/sshd_config

# Allow root login (for demonstration purposes, consider adjusting based on your security requirements)
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Create a user for SSH login (replace 'username' and 'password' with your desired values)
RUN useradd -m -s /bin/bash username && \
    echo 'username:password' | chpasswd

# Expose port 80 for SSH
EXPOSE 80

# Start the SSH server
CMD ["/usr/sbin/sshd", "-D"]
