install:
	cp -r ./usr/share/themis /usr/share
	cp ./usr/bin/themis.sh /usr/bin/themis
	cp ./etc/bash_completion.d/themis.sh /etc/bash_completion.d
	chmod 755 /usr/bin/themis /usr/share/themis/modules/*
	mkdir -p /usr/share/themis/packages
	mkdir -p /usr/share/themis/repositories

uninstall:
	rm -rf /usr/share/themis /usr/bin/themis /etc/bash_completion.d/themis.sh

reinstall:
	rm -rf /usr/share/themis /usr/bin/themis /etc/bash_completion.d/themis.sh
	cp -r ./usr/share/themis /usr/share
	cp ./usr/bin/themis.sh /usr/bin/themis
	cp ./etc/bash_completion.d/themis.sh /etc/bash_completion.d
	chmod 755 /usr/bin/themis /usr/share/themis/modules/*
	mkdir -p /usr/share/themis/packages
	mkdir -p /usr/share/themis/repositories
