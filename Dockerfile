FROM registry.cn-beijing.aliyuncs.com/hub-mirrors/python:3
#FROM acr-panda-registry-vpc.cn-shanghai.cr.aliyuncs.com/baseimage/python:3
LABEL maintainer="shawn.xiao@jll.com 2023.7.25"

ARG ACCESS_KEY_ID
ARG ACCESS_KEY_SECRET


ENV ALIBABA_CLOUD_ACCESS_KEY_ID $ACCESS_KEY_ID
ENV ALIBABA_CLOUD_ACCESS_KEY_SECRET $ACCESS_KEY_SECRET

EXPOSE 8888
COPY GetServiceProvidersPage.py /usr/local/bin/

RUN sed -i 's/http:\/\/deb.debian.org/http:\/\/mirrors.aliyun.com/g' /etc/apt/sources.list
#RUN sed -i 's/http:\/\/deb.debian.org/http:\/\/mirrors.aliyun.com/g' /etc/apt/sources.list.d/debian.sources  
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0E98404D386FA1D9 6ED0E7B82643E131 F8D2585B8783D481 54404762BBB6E853 BDE6D2B9216EC7A8
# Add necessary GPG keys to the trusted keyring
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0E98404D386FA1D9 6ED0E7B82643E131 F8D2585B8783D481 54404762BBB6E853 BDE6D2B9216EC7A8
# Add necessary GPG keys to the trusted keyring
#RUN mkdir -p /etc/apt/trusted.gpg.d/ && \
#    wget -O /etc/apt/trusted.gpg.d/key1.gpg http://keyserver.ubuntu.com/pks/lookup?op=get\&search=0x0E98404D386FA1D9 && \
#    wget -O /etc/apt/trusted.gpg.d/key2.gpg http://keyserver.ubuntu.com/pks/lookup?op=get\&search=0x6ED0E7B82643E131 && \
#    wget -O /etc/apt/trusted.gpg.d/key3.gpg http://keyserver.ubuntu.com/pks/lookup?op=get\&search=0xF8D2585B8783D481 && \
#    wget -O /etc/apt/trusted.gpg.d/key4.gpg http://keyserver.ubuntu.com/pks/lookup?op=get\&search=0x54404762BBB6E853 && \
#    wget -O /etc/apt/trusted.gpg.d/key5.gpg http://keyserver.ubuntu.com/pks/lookup?op=get\&search=0xBDE6D2B9216EC7A8


RUN apt-get update 
RUN apt-get install bash jq -y
RUN pip install flask
RUN pip install jsonify
RUN pip install aliyun-python-sdk-edas==3.26.8

ENTRYPOINT ["/bin/sh","-c","exec python3 /usr/local/bin/GetServiceProvidersPage.py"]