FROM moby/buildkit:master
USER root
WORKDIR /root
RUN sed -e "s/max=10$/max=100/" -i $(which buildctl-daemonless.sh)
COPY build /usr/bin/
ENTRYPOINT ["build"]
