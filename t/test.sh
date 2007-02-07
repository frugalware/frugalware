sudo rm -rf d
make DESTDIR=`pwd`/d install
sudo chown -R root:root d
cd d
tar -djf ~/darcs/current/frugalware-`uname -m`/frugalware-0.6pre2-1-`uname -m`.fpm |grep -v 'Mod time differs'
