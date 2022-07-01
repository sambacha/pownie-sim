# Docker container spec defining and running a simulation to start a single
# client node and run RPC tests against it.
FROM python:3.9-slim-buster

RUN set -eux; \
	apt-get update; \
	apt-get install -y git ca-certificates jq curl --no-install-recommends; \
	rm -rf /var/lib/apt/lists/*; \

RUN pip3 install --upgrade pip

COPY requirements.txt /tmp/
RUN pip install --requirement /tmp/requirements.txt
COPY . /tmp/

# Download and install the test repository itself
RUN set -eux; \
  git clone https://github.com/manifoldx/hive-interfaces       && \
  cd interfaces                                               && \
  cp -a rpc-specs-tests/. /                                   && \
  mv /configs/bcRPC_API_Test.json /bcRPC_API_Test.json

COPY genesis.json /genesis.json
COPY keys.tar.gz /keys
# Add the simulation controller
COPY *.py /

ENV PYTHONUNBUFFERED 1
#ENV PYTHONPATH=/app
ENTRYPOINT ["python3","/main.py"]