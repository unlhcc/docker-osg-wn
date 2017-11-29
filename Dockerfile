FROM centos:centos5

# Required
# --------
# - cmsRun fails without stdint.h (from glibc-headers)
#   Copied from EL6 build and untested on EL5
#
# Other
# -----
# - sssd-client for LDAP lookups through the host
#
# CMSSW dependencies
# ------------------
# Required software is listed under slc5_amd64_platformSeeds at
# http://cmsrep.cern.ch/cgi-bin/cmspkg/driver/cms/slc5_amd64_gcc462

# Use yum repo workaround from https://github.com/astj/docker-centos5-vault
COPY ./etc/ /etc/

RUN yum -y install --disablerepo=osg epel-release \
                                     yum-plugin-priorities && \
    yum -y install --disablerepo=osg python-hashlib && \
    yum -y install glibc-headers \
                   openssh-clients \
                   osg-wn-client \
                   sssd-client && \
    yum -y install glibc coreutils bash tcsh zsh perl tcl tk readline openssl \
                   ncurses e2fsprogs krb5-libs freetype fontconfig \
                   compat-libstdc++-33 libidn libX11 libXmu libSM libICE \
                   libXcursor libXext libXrandr libXft mesa-libGLU mesa-libGL \
                   e2fsprogs-libs libXi libXinerama libXft && \
    yum clean all

# Create condor user and group
RUN groupadd -r condor && \
    useradd -r -g condor -d /var/lib/condor -s /sbin/nologin condor

# yum update
RUN yum update -y && \
    yum clean all
