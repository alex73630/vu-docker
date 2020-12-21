FROM ubuntu:20.04 as wine

RUN dpkg --add-architecture i386

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
	apt-get install -y -q wine wine32 xvfb unzip wget winbind && \
	rm -rf /var/lib/apt/lists/*

ENV WINEPREFIX /root/.wine
ENV WINEARCH win32

WORKDIR /tmp

RUN WINEDLLOVERRIDES="mscoree,mshtml=" xvfb-run wine wineboot

RUN wget -nc https://download.microsoft.com/download/5/D/8/5D8C65CB-C849-4025-8E95-C3966CAFD8AE/vcredist_x86.exe && \
	xvfb-run wine ./vcredist_x86.exe /q; exit 0

FROM wine as vu

WORKDIR /vu/client

RUN wget https://veniceunleashed.net/files/vu.zip && \
	unzip vu.zip && \
	rm vu.zip

CMD ["wine", "/vu/client/vu.com", "-gamepath", "/bf3", "-serverInstancePath", "/vu/instance", "-server", "-dedicated"]