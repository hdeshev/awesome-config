# eval ~/.profile if it exists
# the Fedora awesome package doesn't seem to do it by default
# use it as the place to set global env vars and start gpg-agent
[ -r $HOME/.profile ] && . $HOME/.profile
