#!/bin/bash
set -x

download_jdk() {
  local JDK_VERSION="$1"
  local EXT="$2"
  local curl_cmd="curl \
    -L \
    --silent \
    --connect-timeout 5 \
    --max-time 10 \
    --retry 5 \
    --retry-delay 0 \
    --retry-max-time 60"
  # readonly URL="https://www.oracle.com"
  # readonly JDK_DOWNLOAD_URL1="${URL}/technetwork/java/javase/downloads/index.html"
  # readonly JDK_DOWNLOAD_URL2=$(${curl_cmd} ${JDK_DOWNLOAD_URL1} | grep -E -o "\/technetwork\/java/\javase\/downloads\/jdk${JDK_VERSION}-downloads-.+?\.html" | head -1 | cut -d '"' -f 1)
  # [[ -z "${JDK_DOWNLOAD_URL2}" ]] && echo "Could not get jdk download url - ${JDK_DOWNLOAD_URL1}" && exit 1
  # readonly JDK_DOWNLOAD_URL3="${URL}${JDK_DOWNLOAD_URL2}"
  # readonly JDK_DOWNLOAD_URL4=$(${curl_cmd} "${JDK_DOWNLOAD_URL3}" | grep -E -o "https\:\/\/download\.oracle\.com\/otn\/java\/.*\/jdk-${JDK_VERSION}u[0-9]+(.*)linux-x64.${EXT}" | tail -1)
  # for DL_URL in "${JDK_DOWNLOAD_URL4[@]}"; do
  DL_URL='https://javadl.oracle.com/webapps/download/AutoDL?BundleId=239847_230deb18db3e4014bb8e3e8324f81b43'
  wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" -N "${DL_URL}"
  mv 'AutoDL?BundleId=239847_230deb18db3e4014bb8e3e8324f81b43' jre-8u221-linux-x64.rpm
  #  done
}

echo "Running"

echo "Installing Oracle JDK"

# Detect package management system.
YUM=$(which yum 2>/dev/null)
APT_GET=$(which apt-get 2>/dev/null)

if [[ ! -z ${YUM} ]]; then
  echo "RHEL/CentOS system detected"
  aws s3 cp s3://infosec-vault/jdk-8u221-linux-x64.rpm .
  # download_jdk 8 rpm
  sudo rpm -Uvh jdk-*-linux-x64.rpm
elif [[ ! -z ${APT_GET} ]]; then
  echo "Debian/Ubuntu system detected"
  # download_jdk 8 tar.gz
  aws s3 cp s3://infosec-vault/jdk-8u221-linux-x64.tar.gz .
  sudo mkdir -p /opt/jdk
  sudo tar xf jdk-*-linux-x64.tar.gz -C /opt/jdk
  JDK_VERSION="$(ls /opt/jdk/)"
  sudo update-alternatives --install /usr/bin/java java /opt/jdk/${JDK_VERSION}/bin/java 2000
  sudo update-alternatives --install /usr/bin/javac javac /opt/jdk/${JDK_VERSION}/bin/javac 2000
  sudo update-alternatives --install /usr/bin/jar jar /opt/jdk/${JDK_VERSION}/bin/jar 2000
  update-alternatives --display java
  update-alternatives --display javac
  update-alternatives --display jar
else
  echo "Oracle JDK not installed due to OS detection failure"
  exit 1;
fi

echo "Complete"
