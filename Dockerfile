FROM debian:jessie
MAINTAINER John Chambers-Malewig <johncm@rcn.com> 

ENV WINE_MONO_VERSION 0.0.8 

#RUN dpkg --add-architecture i386 && \
#    apt-get update && \
#    apt-get install --no-install-recommends -y \
#      wine \
#      wine32 \
#      cabextract \
#      zenity \
#      libgl1-mesa-dri \
#      libgl1-mesa-glx \
#      libasound2 \
#      alsa-utils \
#      ca-certificates \
#      curl && \
#    apt-get clean && \
#    curl  https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks > /usr/local/bin/winetricks && \
#    chmod +x /usr/local/bin/winetricks

RUN echo "deb http://http.debian.net/debian jessie main non-free contrib" >> /etc/apt/sources.list \ 
	&& dpkg --add-architecture i386 \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
		# Install some tools required for creating the image \
		curl \
		unzip \
		ca-certificates \
		# Install wine and related packages
		wine \
		wine32 \
		# msttcorefonts \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# RUN cp /usr/share/fonts/truetype/msttcorefonts/* /root/.wine/drive_c/windows/Fonts/

# Download the latest version of winetricks
RUN curl -SL 'https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks' -o /usr/local/bin/winetricks \
	&& chmod +x /usr/local/bin/winetricks

# Get latest version of mono for wine
RUN mkdir -p /usr/share/wine/mono \
	&& curl -SL 'http://sourceforge.net/projects/wine/files/Wine%20Mono/$WINE_MONO_VERSION/wine-mono-$WINE_MONO_VERSION.msi/download' -o /usr/share/wine/mono/wine-mono-$WINE_MONO_VERSION.msi \
	&& chmod +x /usr/share/wine/mono/wine-mono-$WINE_MONO_VERSION.msi

RUN mkdir /dude
WORKDIR /dude
RUN wget -q http://download.mikrotik.com/dude-install-3.6.exe
#            http://download.mikrotik.com/dude/4.0beta3/dude-install-4.0beta3.exe

VOLUME /dude
VOLUME /root/.wine

# ENTRYPOINT [ "wine" ]
