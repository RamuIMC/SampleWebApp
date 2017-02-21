FROM java:8-jre
#https://github.com/docker-library/tomcat

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME

# see https://www.apache.org/dist/tomcat/tomcat-8/KEYS
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys \
    mQGiBDtAWuURBADZ0KUEyUkSUiTA09e7tvEbX25STsjxrR+DNTainCls+XlkVOij \
gBv216lqge9tIsS0L6hCP4OQbFf/64qVtJssX4QXdyiZGb5wpmcj0Mz602Ew8r+N \
I0S5NvmogoYWW7BlP4r61jNxO5zrr03KaijM5r4ipJdLUxyOmM6P2jRPUwCg/5gm \
bpqiYl7pXX5FgDeB36tmD+UD/06iLqOnoiKO0vMbOk7URclhCObMNrHqxTxozMTS \
B9soYURbIeArei+plYo2n+1qB12ayybjhVu3uksXRdT9bEkyxMfslvLbIpDAG8Cz \
gNftTbKx/MVS7cQU0II8BKo2Akr+1FZah+sD4ovK8SfkMXUQUbTeefTntsAQKyyU \
9M9tA/9on9tBiHFl0qVJht6N4GiJ2G689v7rS2giLgKjetjiCduxBXEgvUSuyQID \
nF9ATrpXjITwsRlGKFmpZiFm5oCeCXihIVH0u6q066xNW2AXkLVoJ1l1Rs2Z0lsb \
0cq3xEAcwAmYLKQvCtgDV8CYgWKVmPi+49rSuQn7Lo9l02OUbLQgQW5keSBBcm1z \
dHJvbmcgPGFuZHlAdGFnaXNoLmNvbT6JAFgEEBECABgFAjtAWuUICwMJCAcCAQoC \
GQEFGwMAAAAACgkQajrT9PIsT+1plgCfXAovWnVL3MjrTfcGlFSKw7GHCSYAoJkz \
x+r2ANe8/0e+u5ZcYtSaSry+uQINBDtAWuUQCAD2Qle3CH8IF3KiutapQvMF6PlT \
ETlPtvFuuUs4INoBp1ajFOmPQFXz0AfGy0OplK33TGSGSfgMg71l6RfUodNQ+PVZ \
X9x2Uk89PY3bzpnhV5JZzf24rnRPxfx2vIPFRzBhznzJZv8V+bv9kV7HAarTW56N \
oKVyOtQa8L9GAFgr5fSI/VhOSdvNILSd5JEHNmszbDgNRR0PfIizHHxbLY7288kj \
wEPwpVsYjY67VYy4XTjTNP18F1dDox0YbN4zISy1Kv884bEpQBgRjXyEpwpy1obE \
AxnIByl6ypUM2Zafq9AKUJsCRtMIPWakXUGfnHy9iUsiGSa6q6Jew1XpMgs7AAIC \
B/0eHkYQ0Rv6s21TgpOzRBon+rQAv9ka0PlC7bj2eYWsCOBib8K7qO8hND0sW59p \
0uFQ01X7kC7L/4Ls1HTk0chEZMV0UrGAOKXHY1QFlxrNtFi5U3pTPITXDDfy+g/G \
6FTX3PLnGGvwXbtaiAq5UjQ6iXm03lh0BW6Q+kPtm8swPPfqfjYv0rrT+I8Ic3p2 \
HplWKR2bpi3wqCSKB/AaTQJwTbh2x2+2cPVONPodgjZSJ9eQkErejkNSvqbumlTx \
dB81eoGa0Lo2xE7N+DNlCnILGE0X4hPMdj+N5fmyEbyx0WOB8crvCuODGGEQnXs/ \
zbVO7FP+rj7YWjRh5pVD3bGiiQBMBBgRAgAMBQI7QFrlBRsMAAAAAAoJEGo60/Ty \
LE/tj/QAoOFNFa7rbAy+eT6mRNb7XztfcAbWAKD6Gd6S/7lEJU0k2TS5tozt4jMl \
vw== \
=/91Q

ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.0.41
ENV TOMCAT_TGZ_URL https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

RUN set -x \
    && curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
    && curl -fSL "$TOMCAT_TGZ_URL.asc" -o tomcat.tar.gz.asc \
    && gpg --verify tomcat.tar.gz.asc \
    && tar -xvf tomcat.tar.gz --strip-components=1 \
    && rm bin/*.bat \
    && rm tomcat.tar.gz*

ADD ./target/*.war $CATALINA_HOME/webapps/

EXPOSE 8080
EXPOSE 8081
EXPOSE 81
CMD ["catalina.sh", "run"]
