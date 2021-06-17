install:
	cp -r ./usr/share/themis /usr/share
	cp ./usr/bin/themis.sh /usr/bin/themis
	mkdir -p /usr/share/themis/packages
	mkdir -p /usr/share/themis/repositories

uninstall:
	rm -rf /usr/share/themis /usr/bin/themis

reinstall:
	rm -rf /usr/share/themis /usr/bin/themis
	cp -r ./usr/share/themis /usr/share
	cp ./usr/bin/themis.sh /usr/bin/themis
	mkdir -p /usr/share/themis/packages
	mkdir -p /usr/share/themis/repositories
