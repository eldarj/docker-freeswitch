FROM centos:7

# Install FS
RUN yum install -y https://files.freeswitch.org/repo/yum/centos-release/freeswitch-release-repo-0-1.noarch.rpm epel-release && \
yum install -y freeswitch-config-vanilla freeswitch-lang-en freeswitch-sounds-en freeswitch-meta-all

# Install other libs
RUN yum install -y net-tools sngrep && \
yum clean all

# Copy config files (recursively append folder without removing FS files from /etc/freeswitch)
COPY config/. /etc/freeswitch/

COPY share/. /usr/share/freeswitch/

# Remove IPV6 because we won't use it
RUN rm -r /etc/freeswitch/sip_profiles/*ipv6*

# Change owner to FS
RUN chown -R freeswitch:daemon /etc/freeswitch
RUN chown -R freeswitch:daemon /usr/share/freeswitch/

# Give RWX to all, for development purposes (see #Mounts in install.sh and README)
RUN chmod -R a+rwx /etc/freeswitch
RUN chmod -R a+rwx /usr/share/freeswitch

CMD freeswitch && tail -f /var/log/freeswitch.log
