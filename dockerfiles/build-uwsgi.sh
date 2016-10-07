#!/bin/bash
#
# Build UWSGI RPM package
#
version=$1
path=$2
#Set up build directories
build_dir=`mktemp -d`
cd $build_dir

#/usr/sbin/setenforce 0

#Download uwsgi and extract
wget http://projects.unbit.it/downloads/uwsgi-$version.tar.gz
tar -xvvf  uwsgi-$version.tar.gz
cd uwsgi-$version

# Add config 
cp /home/jenkins/config.ini buildconf/

#Compile uwsgi package
export USE_PYTHON27=1

CPUCOUNT=2 python uwsgiconfig.py --build config

mv /home/jenkins/etc $build_dir
mv /home/jenkins/run $build_dir
mv /home/jenkins/usr $build_dir
mv uwsgi $build_dir/usr/sbin/

cd /home/jenkins

#Assemble package with fpm
/usr/local/bin/fpm -s dir -t rpm --name uwsgi --version $version --iteration 1 --description "uwsgi package" -C $build_dir etc/ usr/ run/

package=`ls /home/jenkins | grep uwsgi | grep rpm`
scp /home/jenkins/$package jenkins@myhost:/var/tmp/$path
