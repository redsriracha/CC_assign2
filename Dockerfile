FROM ubuntu

RUN apt install wget
COPY hadoop-install.sh .
RUN chmod u+x hadoop-install.sh
RUN ./hadoop-install.sh

RUN apt update
RUN apt install make
RUN apt install -y python3
RUN apt install -y python3-pip
RUN apt install -y git

COPY requirements.txt .
RUN python3 -m pip install -r requirements.txt

