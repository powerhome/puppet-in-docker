#!/usr/bin/env bash

if [ -n "$HIERA_BASE64" ]; then
  echo "---> Saving Hiera configuration to /etc/puppetlabs/puppet/hiera.yaml (base64 decoded)"
  echo -e "$HIERA_BASE64" | base64 -d > /etc/puppetlabs/puppet/hiera.yaml
fi

if [ -n "$HIERA_GPG_KEY_BASE64" ]; then
  echo "---> Importing GPG key to Hiera Keyring"
  mkdir ${GNUPGHOME}
  echo "$HIERA_GPG_KEY_BASE64" | base64 -d | gpg --import
fi
