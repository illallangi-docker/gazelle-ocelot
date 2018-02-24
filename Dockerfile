FROM centos:7.3.1611
MAINTAINER Andrew Cole <andrew.cole@illallangi.com>

ENV GAZELLE_GIT=http://github.com/WhatCD/Gazelle.git
ENV GAZELLE_COMMIT=63b337026d49b5cf63ce4be20fdabdc880112fa3
ENV GAZELLE_SRC=/usr/local/src/gazelle-63b337026d49b5cf63ce4be20fdabdc880112fa3
ENV TEMPLATER_GIT=http://github.com/lavoiesl/bash-templater.git
ENV TEMPLATER_COMMIT=dfe9c5b2b1dfbd9bc2867157557c1244f2c2163e
ENV TEMPLATER_SRC=/usr/local/src/templater-dfe9c5b2b1dfbd9bc2867157557c1244f2c2163e
ENV WAITFOR_GIT=http://github.com/Eficode/wait-for.git
ENV WAITFOR_COMMIT=51de968acbcd4d8837de6447dd6a91cdebfc51ea
ENV WAITFOR_SRC=/usr/local/src/waitfor-51de968acbcd4d8837de6447dd6a91cdebfc51ea
ENV MYSQL_HOST=mariadb
ENV MYSQL_PORT=3306
ENV OCELOT_PORT=34000

# Install git, nc, rsync, boost-devel, libev-devel, mariadb-devel, mysql++-devel, make, gcc ang gcc-c++
RUN yum install -y epel-release && \
    yum update -y && \
    yum install -y git nc rsync boost-devel libev-devel mariadb-devel mysql++-devel make gcc gcc-c++ && \
    yum clean -y all

# Retrieve Gazelle source
RUN rm -Rf ${GAZELLE_SRC} && \
    git clone ${GAZELLE_GIT} ${GAZELLE_SRC} && \
    cd ${GAZELLE_SRC} && \
    git checkout ${GAZELLE_COMMIT} && \
    rm -rf ${GAZELLE_SRC}/.git && \
    cd

# Retrieve Templater source
RUN rm -Rf ${TEMPLATER_SRC} && \
    git clone ${TEMPLATER_GIT} ${TEMPLATER_SRC} && \
    cd ${TEMPLATER_SRC} && \
    git checkout ${TEMPLATER_COMMIT} && \
    rm -rf ${TEMPLATER_SRC}/.git && \
    cd

# Retrieve Wait For source
RUN rm -Rf ${WAITFOR_SRC} && \
    git clone ${WAITFOR_GIT} ${WAITFOR_SRC} && \
    cd ${WAITFOR_SRC} && \
    git checkout ${WAITFOR_COMMIT} && \
    rm -rf ${WAITFOR_SRC}/.git && \
    cd

# Retrieve ocelot source
RUN find ${GAZELLE_SRC}/ -name ocelot-\*.tar.gz -exec tar -C /usr/local/src -zxf '{}' \; -delete

# Install Templater
RUN cp ${TEMPLATER_SRC}/templater.sh /usr/local/bin/templater

# Install Wait For
RUN cp ${WAITFOR_SRC}/wait-for /usr/local/bin/wait-for

COPY *-entrypoint.sh /usr/local/bin/
COPY templates.d /templates.d

ENTRYPOINT ["gazelle-entrypoint.sh"]
CMD ["/usr/local/bin/ocelot"]
EXPOSE 34000