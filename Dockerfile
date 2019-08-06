FROM moby/buildkit:v0.6.0
USER root
WORKDIR /root
COPY build /usr/bin/
ENTRYPOINT ["build"]
