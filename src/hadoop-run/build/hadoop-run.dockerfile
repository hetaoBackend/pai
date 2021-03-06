# Copyright (c) Microsoft Corporation
# All rights reserved.
#
# MIT License
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
# to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
# BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

FROM base-image

ENV HADOOP_VERSION=hadoop-2.9.0

RUN apt-get -y install zookeeper libsnappy-dev
RUN rm -rf /var/lib/apt/lists/*

COPY dependency/hadoop-binary/hadoop-2.9.0.tar.gz /usr/local/

RUN tar -xzf /usr/local/$HADOOP_VERSION.tar.gz -C /usr/local/ && \
    cd /usr/local && \
    ln -s ./$HADOOP_VERSION hadoop

ENV HADOOP_PREFIX=/usr/local/hadoop \
    HADOOP_BIN_DIR=/usr/local/hadoop/bin \
    HADOOP_SBIN_DIR=/usr/local/hadoop/sbin \
    HADOOP_COMMON_HOME=/usr/local/hadoop \
    HADOOP_HDFS_HOME=/usr/local/hadoop \
    HADOOP_MAPRED_HOME=/usr/local/hadoop \
    HADOOP_YARN_HOME=/usr/local/hadoop \
    HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop \
    HADOOP_ROOT_LOGGER=INFO,console \
    HADOOP_SECURITY_LOGGER=INFO,console

ENV YARN_CONF_DIR=$HADOOP_PREFIX/etc/hadoop

ENV PATH=$PATH:$HADOOP_BIN_DIR:$HADOOP_SBIN_DIR:/usr/share/zookeeper/bin

RUN chown -R root:root /var
RUN mkdir -p $HADOOP_YARN_HOME/logs

RUN mkdir -p /var/lib/hdfs/name
RUN mkdir -p /var/lib/hdfs/data

COPY build/start.sh /usr/local/start.sh
RUN chmod a+x /usr/local/start.sh


# Only node manager need this.#
#COPY docker-17.06.2-ce.tgz /usr/local
RUN wget https://download.docker.com/linux/static/stable/x86_64/docker-17.06.2-ce.tgz
RUN cp docker-17.06.2-ce.tgz /usr/local
RUN tar xzvf /usr/local/docker-17.06.2-ce.tgz
# Only node manager need this.#

CMD ["/usr/local/start.sh"]
