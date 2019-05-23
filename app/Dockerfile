FROM node:8

# Create dir && copy files
WORKDIR /usr/src/app
ADD . /usr/src/app/

# Hardening
COPY ./harden.sh .
RUN chmod +x harden.sh && \
    sh harden.sh && \
    rm harden.sh
USER appuser

# Expose port & run
EXPOSE 3000
CMD [ "npm", "start" ]
