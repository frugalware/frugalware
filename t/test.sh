sudo rm -rf d
make DESTDIR=`pwd`/d install
sudo chown -R root:root d
cd d
tar -djf ~/darcs/current/frugalware-i686/frugalware-0.6pre2-1-i686.fpm |grep -v 'Mod time differs'
