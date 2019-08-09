FROM moby/buildkit:master
USER root
WORKDIR /root
COPY build /usr/bin/
ENTRYPOINT ["build"]
