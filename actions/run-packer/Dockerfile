# Install pyrax and ansible-base
FROM alpine:3.9 as pyrax-image

RUN apk add --update --no-cache --virtual build-dependencies \
    build-base \
    python3-dev \
    linux-headers \
    libffi-dev \
    openssl-dev \
    gcc \
  && pip3 install --no-cache-dir --user --upgrade pyrax jmespath

# Alpine 3.9 191 MB
FROM alpine:3.9

RUN apk add --no-cache ansible openssh-client
RUN ln -s /usr/bin/python3 /usr/bin/python && \
    ln -s /usr/bin/pip3 /usr/bin/pip
COPY --from=pyrax-image /root/.local /root/.local
COPY entrypoint.sh /entrypoint.sh
COPY ansible/ /ansible
RUN chmod +x /entrypoint.sh
ENV PYTHONPATH "${PYTONPATH}:/root/.local/lib/python3.6/site-packages"
CMD ["ansible-playbook" "--version"]

ENTRYPOINT ["/entrypoint.sh"]
