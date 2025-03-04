FROM hub.opensciencegrid.org/osg-htc/osg-wn:24-release-el8

# Required
# --------
# - cmsRun fails without stdint.h (from glibc-headers)
#   Tested CMSSW_7_4_5_patch1
#
# Other
# -----
# - ETF calls /usr/bin/lsb_release (from redhat-lsb-core)
# - sssd-client for LDAP lookups through the host
# - SAM tests expect cvmfs utilities and python3
# - gcc is required by GLOW jobs (builds matplotlib)
#
# CMSSW dependencies
# ------------------
# Required software is listed under el8_amd64_platformSeeds at
# http://cmsrep.cern.ch/cgi-bin/cmspkg/driver/cms/el8_amd64_gcc12

RUN    dnf install -y \
            apptainer \
            cvmfs \
            gcc \
            glibc-headers \
            openssh-clients \
            osg-wn-client \
            python3 \
            redhat-lsb-core \
            sssd-client \
    && dnf install -y \
            bash tcsh perl bzip2-libs glibc nspr nss nss-util popt zlib \
            glibc-devel openssl openssl-devel openssl-libs krb5-libs \
            libcom_err libX11 libXext libXft libXpm libglvnd-glx \
            libglvnd-opengl mesa-libGLU readline ncurses-libs tcl tk libaio \
            libxcrypt perl-libs \
    && dnf clean all \
    && rm -rf /var/cache/yum

# Create condor user and group
RUN    groupadd -r condor \
    && useradd -r -g condor -d /var/lib/condor -s /sbin/nologin condor
