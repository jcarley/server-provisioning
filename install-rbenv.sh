RBENV_ROOT="$HOME/.rbenv"

installrbenv() {
  if [ ! -d "$RBENV_ROOT" ] ; then

    echo "Installing rbenv at $RBENV_ROOT"

    # check for, and install rbenv
    curl -L https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash
  fi
}

addrbenvtoloadpath() {
  source ~/.bashrc

  if [ ! $(which rbenv) ]; then
    # take a backup of .bashrc
    echo "Making a backup of the .bashrc"
    cp .bashrc .bashrc.original

    # insert lines at top of .bashrc
    echo "Adding rbenv to the load path"
    echo "if [ -d \$HOME/.rbenv ]; then" >> bashrc.tmp
    echo "  export PATH=\"\$HOME/.rbenv/bin:\$PATH\"" >> bashrc.tmp
    echo "  eval \"\$(rbenv init -)\"" >> bashrc.tmp
    echo "fi" >> bashrc.tmp
    cat .bashrc >> bashrc.tmp
    mv bashrc.tmp .bashrc

    # source .bashrc
    source ~/.bashrc
  fi
}

bootstrapserver() {
  echo "Installing server build essentials."
  # install some server essentials
  rbenv bootstrap-ubuntu-11-10
}

installruby() {
  if [ ! $(which ruby) ]; then
    echo "Install ruby 1.9.3"

    # install ruby
    rbenv install 1.9.3-p125

    echo "Setting ruby 1.9.3 as the global."

    # set 1.9.3 as our global ruby
    rbenv global 1.9.3-p125

    echo "Installing necessary gems."

    # install gems
    rbenv bootstrap
  fi
}

echo "Provisioning server with rbenv"
echo "Changing directory to $HOME"

cd $HOME

installrbenv
addrbenvtoloadpath
bootstrapserver
installruby


