FROM debian:jessie
RUN echo 'Installing base dependencies...'
RUN apt-get -y update && apt-get install -y python-dev libcurl4-gnutls-dev libexpat1-dev gettext libz-dev apache2 x11vnc xvfb iceweasel openssh-server
RUN echo 'Done.\n\n'
RUN echo 'Stopping apache...'
CMD apache2ctl stop
RUN echo 'Done.\n\n'
RUN echo 'Installing nginx...'
RUN apt-get install -y nginx
RUN echo 'Done.\n\n'
RUN echo 'Stopping nginx...'
CMD service nginx stop
RUN echo 'Done.\n\n'
RUN echo 'Installing pip, ipython, bpython and supervisor...'
RUN apt-get install -y git python-pip
RUN pip install -U pip
RUN pip install ipython && pip install bpython && pip install virtualenv && pip install supervisor --pre
RUN echo 'Done.\n\n'
RUN echo 'Installing postgresql...'
RUN apt-get install -y postgresql postgresql-contrib
RUN echo 'Done.\n\n'
RUN echo 'Setup some final stuffs...'
RUN mkdir ~/.vnc
RUN x11vnc -storepasswd 1234 ~/.vnc/passwd
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
RUN echo 'Done.\n\n'.
RUN echo 'Installing ssh daemon...'
RUN mkdir /var/run/sshd
RUN echo 'root:1234' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
RUN echo 'Done.\n\n'.