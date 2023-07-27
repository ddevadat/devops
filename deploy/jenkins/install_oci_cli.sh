oci_cli_setup_zip="https://github.com/oracle/oci-cli/releases/download/v3.22.0/oci-cli-3.22.0-Ubuntu-18.04-Offline.zip"
wget $oci_cli_setup_zip -O /tmp/ocicli.zip
unzip /tmp/ocicli.zip -d /tmp
cd /tmp
# ./oci-cli-installation/install.sh --install-dir {{ ansible_env.HOME }} --exec-dir {{ ansible_env.HOME }} --script-dir {{ ansible_env.HOME }} --accept-all-defaults
