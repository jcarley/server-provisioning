RBENV_ROOT="$HOME/.rbenv"

echo "Installing rbenv at $RBENV_ROOT"

if [ ! -d "$RBENV_ROOT" ] ; then

  echo "changing directory to $HOME"
  cd $HOME

  # check for, and install rbenv
  #curl -L https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash

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
  #source ~/.bashrc

  # install some server essentials
  #rbenv bootstrap-ubuntu-11-10

  # install ruby
  #rbenv install 1.9.3-p125

  # set 1.9.3 as our global ruby
  #rbenv global 1.9.3-p125

  # install gems
  #rbenv bootstrap

  # install bundler
  #gem install bundler --no-ri --no-rdoc
fi
