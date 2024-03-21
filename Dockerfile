FROM nvidia/cuda:12.3.1-devel-ubuntu22.04

# Install additional packages
RUN apt-get -y update && \
         apt-get -y upgrade && \
         apt-get install -y python3-pip python3-dev

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y git freeglut3-dev python3-tk freeglut3-dev

CMD tail -f  /dev/null

# Install any python packages you need
COPY requirements.txt requirements.txt

#Create user 'user' with password 'ubuntu'
RUN apt-get install -y sudo
RUN useradd -ms /bin/bash -G sudo -p $(perl -e 'print crypt($ARGV[0], "password")' 'ubuntu') user
RUN cd ~/; umask 022

RUN python3 -m pip install --upgrade pip && \
   python3 -m pip install -r requirements.txt

# RUN /bin/bash pip3 uninstall onnxruntime onnxruntime-gpu
# RUN /bin/bash pip3 install onnxruntime-gpu==1.15.1

RUN apt-get install -y libglib2.0-0 ffmpeg

USER user
WORKDIR /home/user/