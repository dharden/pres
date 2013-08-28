
PROGRAM_NAME="pres"

github_location="https://github.com/deshawnbw/$PROGRAM_NAME/tarball/master"

install_dir="$HOME/.$PROGRAM_NAME" # Where the program will be installed too

tmp_dir="$HOME/tmp" # Where tar file / tmp files will be generated to

# If there is already an installation in the install_dir
if [ -d "$install_dir" ]; then
  # remove it
  rm -rf "$install_dir"
fi

# Create the tmp dir
mkdir -p $tmp_dir

# The installation directory should not exist yet, it will be created on mv
# mkdir -p "$install_dir"

# Get the latest tarball
curl -k -L $github_location -o "$tmp_dir/$PROGRAM_NAME.tar.gz"

if [ -f "$tmp_dir/$PROGRAM_NAME.tar.gz" ]; then
  echo "*** Tar file downloaded"
fi

# Retreive its directory name within the tar file for use later
tar_dir_name=`tar -tf "$tmp_dir/$PROGRAM_NAME.tar.gz" | head -n1`

echo "*** Found root tar dir $tar_dir_name"

# Extract the tar file to the tmp directory
(cd $tmp_dir
  tar xzf "$tmp_dir/$PROGRAM_NAME.tar.gz"
)

if [ -d "$tmp_dir/$tar_dir_name" ]; then
  echo "*** Tar file ($tmp_dir/$PROGRAM_NAME.tar.gz) extracted to $tmp_dir/$tar_dir_name"
fi

# Move the contents of the tar file to the installation directory
mv "$tmp_dir/$tar_dir_name" "$install_dir"

if [ -d "$install_dir" ]; then
  echo "*** Moved $tmp_dir/$tar_dir_name to $install_dir "
fi

# Remove the temp file
rm "$tmp_dir/$PROGRAM_NAME.tar.gz"

yesno() {
  read -p "$1 " response
  if [[ "$response" == "y" || "$response" == "Y" || "$response" == "yes" ]]; then
    echo "yes"
  else
    echo "no"
  fi
}

echo -e "WARNING: This will put a PATH export line in your ~/.bashrc or /.zshrc

I don't feel like writing another installation script...

hope that cool with you bro"



# Determine what shell is being used
is_zsh=`echo $SHELL | grep -c zsh`
is_bash=`echo $SHELL | grep -c bash`

program_path="~/.pres/bin/"

path_export="export PATH=\$PATH:$program_path"

# If its zsh, output alias to .zshrc
if [ $is_zsh -eq "1" ]; then
  echo "$path_export" >> "$HOME/.zshrc"
  echo "*** program PATH has been exported to your ~/.zshrc"
fi

# If its bash, output alias to .bashrc
if [ $is_bash -eq "1" ]; then
  echo "$path_export" >> "$HOME/.bashrc"
  echo "*** program PATH has been exported to your ~/.bashrc"
fi

echo "You should be all set."

