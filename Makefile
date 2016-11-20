# Makefile for virtualenv pinning
# Thanks to http://docs.python-guide.org/en/latest/dev/virtualenvs/

# For use with a "bootstrap" VirtualEnv that has virtualenv installed within it
# E.g. /tmp/foo/bin/virtualenv
# See http://unixnut-tech.blogspot.com.au/2016/10/how-to-bootstrap-python-virtualenvs.html
BOOTSTRAP_VIRTUALENV=virtualenv

# E.g. -p /usr/bin/python3
VIRTUALENV_OPTS=

.PHONY: install init setup pip info list update upgrade

setup: | .virtualenv
.virtualenv:
	grep -q '^\.virtualenv' .gitignore 2> /dev/null || echo .virtualenv >> .gitignore
	$(BOOTSTRAP_VIRTUALENV) --no-site-packages $(VIRTUALENV_OPTS) $@

# Note that this isn't quite the same as "composer init" in that this doesn't
# need to ask questions
init: | .virtualenv
	.virtualenv/bin/pip freeze > requirements.txt

# Note that this doesn't install anything outside the project directory;
# instead, it's like "composer install" in that it installs the defined
# dependencies.
install: requirements.txt | .virtualenv
	.virtualenv/bin/pip install -r requirements.txt

# like "composer update"
update: upgrade init

# upgrade all the packages, but don't write requirements.txt
# Thanks to http://stackoverflow.com/questions/2720014/upgrading-all-packages-with-pip
upgrade: | .virtualenv
	.virtualenv/bin/pip freeze | awk -F = '! /^(\-e|#)/ { print $$1 }' | xargs .virtualenv/bin/pip install --upgrade

info list: | .virtualenv
	## .virtualenv/bin/pip list
	.virtualenv/bin/pip freeze | sed 's/==\(.*\)/ (\1)/'

PKG=asnatoehusaotehusnt
pip: | .virtualenv
	.virtualenv/bin/pip install $(PIP_OPTS) $(PKG)
