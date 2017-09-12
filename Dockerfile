FROM debian:jessie

LABEL \
        io.voxbox.build-date=${BUILD_DATE} \
        io.voxbox.name=docker-freeswitch \
        io.voxbox.vendor=voxbox.io \
    maintainer=matteo@voxbox.io \
        io.voxbox.vcs-url=https://github.com/matteolc/docker-freeswitch.git \
        io.voxbox.vcs-ref=${VCS_REF} \
        io.voxbox.license=MIT

ARG HOME
ARG FREESWITCH_VERSION_MAJOR
ARG FREESWITCH_VERSION_MINOR

ENV FREESWITCH_VERSION_MAJOR=${FREESWITCH_VERSION_MAJOR:-1.6} \
    FREESWITCH_VERSION_MINOR=${FREESWITCH_VERSION_MINOR:-19} \
    GIT_SSL_NO_VERIFY=1 \
    HOME=${HOME:-/opt/freeswitch}

RUN apt-get update && apt-get install -y \
  build-essential \
  dh-autoreconf \
  sudo \
  curl \
  wget \
  git \
  ntp \
  ntpdate

WORKDIR /usr/src

RUN wget -O - \
      https://files.freeswitch.org/repo/deb/debian/freeswitch_archive_g0.pub \
      | apt-key add - && \
    echo "deb http://files.freeswitch.org/repo/deb/freeswitch-${FREESWITCH_VERSION_MAJOR}/ jessie main" \
      > /etc/apt/sources.list.d/freeswitch.list && \
    apt-get update && \
    apt-get install \
      -y \
      --force-yes \
      freeswitch-video-deps-most && \
    git clone \
      https://freeswitch.org/stash/scm/fs/freeswitch.git \
      -bv${FREESWITCH_VERSION_MAJOR}.${FREESWITCH_VERSION_MINOR}

WORKDIR freeswitch

ADD build/modules.conf /usr/src/freeswitch/modules.conf

RUN ./bootstrap.sh -j && \
    ./configure --prefix=${HOME} --enable-core-pgsql-support && \
    make && \
    make install && \
    make cd-sounds-install && \
    make cd-moh-install

RUN groupadd freeswitch && \
    adduser \
      --quiet \
      --system \
      --home ${HOME} \
      --gecos "freeswitch" \
      --ingroup freeswitch freeswitch \
      --disabled-password && \
    chown -R freeswitch:freeswitch ${HOME} && \
    chmod -R ug=rwX,o= ${HOME} && \
    chmod -R u=rwx,g=rx ${HOME}/bin/*

RUN ln -s ${HOME}/bin/freeswitch /usr/bin && \
    ln -s ${HOME}/bin/fs_cli /usr/bin && \
    ln -s ${HOME}/etc/freeswitch ${HOME}/conf && \
    ln -s ${HOME}/lib/freeswitch/mod ${HOME}/mod && \
    ln -s ${HOME}/share/freeswitch/sounds ${HOME}/sounds && \
    ln -s ${HOME}/var/run ${HOME} && \
    ln -s ${HOME}/var/run/freeswitch/freeswitch.pid ${HOME}/run && \
    mkdir -p ${HOME}/cdr/cdr-csv

ENV FS_INCLUDES=${HOME}/include/freeswitch \
    FS_MODULES=${HOME}/mod
RUN cd /usr/src && \
    git clone \
      https://github.com/voxbox-io/freeswitch-g729.git && \
    cd freeswitch-g729 && \
    make && \
    make install

RUN cd /usr/src && \
    curl -R -O http://www.lua.org/ftp/lua-5.3.4.tar.gz && \
    tar zxf lua-5.3.4.tar.gz && \
    cd lua-5.3.4 && \
    make linux install && \
    make test

RUN wget https://luarocks.org/releases/luarocks-2.4.2.tar.gz && \
    tar zxpf luarocks-2.4.2.tar.gz && \
    cd luarocks-2.4.2 && \
    ./configure && \
    make bootstrap && \
    luarocks install lua-cjson

RUN cp /usr/local/lib/lua/5.3/cjson.so ${HOME}/mod

WORKDIR ${HOME}

RUN rm -Rf /usr/src/* && \
    apt-get clean && \
    rm -Rf /tmp/* /var/tmp/* && \
    rm -Rf /var/lib/apt/lists/*

# RUN mkdir -p ${HOME}/cdr/spool/scripts
# ln -s ${HOME}/share/freeswitch/scripts ${HOME}/scripts && \

RUN rm -Rf ${HOME}/etc/freeswitch
# COPY conf ${HOME}/etc/freeswitch

RUN chown freeswitch:freeswitch -R ${HOME}
RUN setcap 'cap_net_bind_service,cap_sys_nice=+ep' ${HOME}/bin/freeswitch
COPY entrypoint.sh /usr/local/bin/freeswitch-entrypoint.sh
ENTRYPOINT ["freeswitch-entrypoint.sh"]
CMD ["-rp", "-nonat", "-c", "-u", "freeswitch", "-g", "freeswitch"]