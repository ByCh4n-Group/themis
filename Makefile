MU := $(shell bash installer.sh --call --user)


define install
	mkdir -p /usr/share/themis/packages /usr/share/themis/repositories /usr/local/lib/themis /usr/share/licenses/themis /usr/share/doc/themis
	cp ./LICENSE /usr/share/licenses/themis
	cp ./README.md ./doc/* /usr/share/doc/themis
	cp ./lib/* /usr/local/lib/themis
	cp ./themis.conf ./repo.sh /usr/share/themis
	install -m 755 ./completion/themis.sh /etc/bash_completion.d
	install -m 755 ./themis.sh /usr/bin/themis
	chown ${MU} /usr/share/themis /usr/local/lib/themis /usr/share/themis/* /usr/local/lib/themis/* /usr/bin/themis /etc/bash_completion.d
	sqlite3 "/usr/share/themis/packages.db" "CREATE TABLE packages(pkg TEXT,ver TEXT,dep TEXT,maintainer TEXT,desc TEXT,codec TEXT)"
    openssl genrsa -out "/usr/share/themis/priv.pem" 2048
    openssl rsa -in "/usr/share/themis/priv.pem" -outform PEM -pubout -out "/usr/share/themis/pub.pem"
	chmod 755 /usr/share/themis/*
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