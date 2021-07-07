install:
	cp -r ./usr/share/themis /usr/share
	cp ./usr/bin/themis.sh /usr/bin/themis
	cp ./etc/bash_completion.d/themis.sh /etc/bash_completion.d
	chmod 755 /usr/bin/themis /usr/share/themis/modules/*
	mkdir -p /usr/share/themis/packages /usr/share/themis/repositories /usr/share/doc/packages/themis /usr/share/licences/themis
	cp ./usr/share/doc/packages/themis/README.md /usr/share/doc/packages/themis
	cp ./usr/share/licences/themis/LICENSE /usr/share/licences/themis 

uninstall:
	rm -rf /usr/share/themis /usr/bin/themis /etc/bash_completion.d/themis.sh /usr/share/doc/packages/themis /usr/share/licences/themis

reinstall:
	rm -rf /usr/share/themis /usr/bin/themis /etc/bash_completion.d/themis.sh /usr/share/doc/packages/themis /usr/share/licences/themis
	cp -r ./usr/share/themis /usr/share
	cp ./usr/bin/themis.sh /usr/bin/themis
	cp ./etc/bash_completion.d/themis.sh /etc/bash_completion.d
	chmod 755 /usr/bin/themis /usr/share/themis/modules/*
	mkdir -p /usr/share/themis/packages /usr/share/themis/repositories /usr/share/doc/packages/themis /usr/share/licences/themis
	cp ./usr/share/doc/packages/themis/README.md /usr/share/doc/packages/themis
	cp ./usr/share/licences/themis/LICENSE /usr/share/licences/themis 
