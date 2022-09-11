#!/bin/bash

# Usage statement
script_name=$0

usage() {
  echo '-----------------'
  echo "|  $script_name  |"
  echo '-----------------'
  echo 'Usage:'
  echo "  $script_name [--admin_url_with_port <value>] [--application_name <value>] [--user <value>] [--password <value>] [--ip_whitelist <value>]"
  echo ''
  echo 'Examples:'
  echo "  $script_name --admin_url_with_port http://localhost:8087 --application_name myapp --user wowza --password wowzapassword --ip_whitelist 192.168.1.1,192.168.1.2"
  echo "  $script_name --verbose --admin_url_with_port http://localhost:8087 --application_name myapp --user wowza --password wowzapassword --ip_whitelist 192.168.1.1,192.168.1.2"
  echo ''
  echo 'Options:'
  echo "  --verbose     Verbose output."
  echo ''
  exit 1
}

# Show usage statement if no arguments have been passed in
if [[ $1 == '' ]]; then usage; exit; fi

# Parse args

admin_url_with_port=''
application_name=''
user=''
password=''
ip_whitelist=''
verbose=0

positional_args=()
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    # -e|--example-arg)
    #   EXTENSION="$2"
    #   shift # past argument
    #   shift # past value
    #   ;;
    # --standalone-flag)
    #   standalone_flag=1
    #   shift # past argument
    #   ;;
    --admin_url_with_port)
      admin_url_with_port="$2"
      shift # past argument
      shift # past value
      ;;
    --application_name)
      application_name="$2"
      shift # past argument
      shift # past value
      ;;
    --user)
      user="$2"
      shift # past argument
      shift # past value
      ;;
    --password)
      password="$2"
      shift # past argument
      shift # past value
      ;;
    --ip_whitelist)
      ip_whitelist="$2"
      shift # past argument
      shift # past value
      ;;
    --verbose)
      verbose=1
      shift # past argument
      ;;
    *)    # unknown option
      positional_args+=("$1") # save it in an array for later
      shift # past argument
      ;;
  esac
done
set -- "${positional_args[@]}" # restore positional arguments

#############################
# Main script functionality #
#############################

# Update IP whitelist
curl --digest -u "$user:$password" -X PUT -H 'Accept:application/json; charset=utf-8' -H 'Content-Type:application/json; charset=utf-8' $admin_url_with_port/v2/servers/_defaultServer_/vhosts/_defaultVHost_/applications/$application_name/adv -d"
{
   \"advancedSettings\": [{
       \"enabled\": true,
       \"canRemove\": true,
       \"name\": \"securityPlayIPAllowList\",
       \"value\": \"$ip_whitelist\",
       \"defaultValue\": null,
       \"type\": \"String\",
       \"sectionName\": \"Application\",
       \"section\": \"/Root/Application\",
       \"documented\": false
   }]
}"

echo -e "\nDone!"

# TODO: Restart application
# Command below is not compatible with our current Wowza installation

#echo "Restarting application: $application_name ..."
#curl --digest -u "$user:$password" -X PUT -H 'Accept:application/json; charset=utf-8' $admin_url_with_port/v2/servers/defaultServer/vhosts/defaultVHost/applications/$application_name/actions/restart
#echo -e "\nDone!"
