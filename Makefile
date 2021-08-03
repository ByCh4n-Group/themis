define install
	mkdir -p /usr/share/themis/packages /usr/share/themis/repositories /usr/local/lib/themis /usr/share/licenses/themis /usr/share/doc/themis
	cp ./LICENSE /usr/share/licenses/themis
	cp ./README.md ./doc/* /usr/share/doc/themis
	cp ./lib/* /usr/local/lib/themis
	cp ./themis.conf ./index.sh /usr/share/themis
	install -m 755 ./completion/themis.sh /etc/bash_completion.d
	install -m 755 ./themis.sh /usr/bin/themis
	cd lib-pkgs
endef

define uninstall
	rm -rf /usr/share/themis /usr/local/lib/themis /usr/share/licenses/themis /usr/share/doc/themis /usr/bin/themis /etc/bash_completion.d/themis.sh
endef

install:
	$(install)

uninstall:
	$(uninstall)

reinstall:
	$(uninstall)	
	$(install)