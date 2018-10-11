#!/usr/bin/env python

#Usage (linux): eval $(python assume_role.py <profile> <token mfa>)

# These two have to be installed via pip
from configparser import SafeConfigParser
import boto3 # AWS Python SDK--"pip install boto"

import platform
import os
import sys
import getpass
import time


if __name__ == "__main__":
   
	target_account = sys.argv[1]
	if target_account == "":
		target_account = "default"

	mfa_token = sys.argv[2]
	if mfa_token == "":
		print ("Missing MFA token")
		quit(1)


	# Setup Config Parser to read from the default .aws/credentials file
	# TODO: Add check for file existence
	config = SafeConfigParser()
	cred_file = os.path.expanduser("~/.aws/credentials")
	config.read(cred_file)

	# Read default api keys, we need these to perform the STS Assume Role call
	# Possibly add support back for OptParser to read a --profile option to change which profile is used as the "base" profile
	if not config.has_section('default'):
		print("Missing %s section from the credentials file" % target_account)
		quit(1)

	if not (config.has_option('default', 'aws_access_key_id') 
		and config.has_option('default', 'aws_secret_access_key')):
		print("Missing 'aws_access_key_id' or 'aws_secret_access_key' from %s section of the credentials file" % target_account)
		quit(2)

	aws_access_key = config.get('default', 'aws_access_key_id')
	aws_secret_key = config.get('default', 'aws_secret_access_key')
	# # If the config file is setup to use real api keys, just set the profile, and exit
	# # This is how the "default" provider gets used, as we have to have one set of API keys to make the rest of this work
	# if config.has_option(target_account, 'aws_access_key_id') and config.has_option(target_account, 'aws_secret_access_key'):
	#     print "unset AWS_DEFAULT_REGION;"
	#     print "unset AWS_SESSION_NAME;"
	#     print "unset AWS_ACCESS_KEY_ID;"
	#     print "unset AWS_SECRET_ACCESS_KEY;"
	#     print "unset AWS_SESSION_TOKEN;"
	#     print "unset AWS_SESSION_EXPIRATION;"
	#     print "export AWS_PROFILE=%s;" % target_account
	#     print "echo Account %s is setup for use.;" % target_account
	#     quit(0)
	

	if not (config.has_option(target_account, 'account_id') 
		and config.has_option(target_account, 'role')
		and config.has_option(target_account, 'role')):
		print("echo Account '%s' is missing the required options, 'account_id' or 'role' in the credentials file.;" % target_account)
		quit(4)

	account_id = config.get(target_account, 'account_id')
	role = config.get(target_account, 'role')
	role_arn = 'arn:aws:iam::%s:role/%s' % (account_id, role)
	mfa_serial = config.get(target_account, 'mfa_serial')
	session_name = '%s-%s' % (getpass.getuser(), target_account)
	duration=3600*8

	# read/set default region, default to us-east-1 if one isn't specified
	region = 'eu-west-1'
	if config.has_option(target_account, 'region'):
		region = config.get(target_account, 'region')

	# Step 2: Connect to AWS STS and then call AssumeRole. This returns 
	# temporary security credentials.
	client = boto3.client('sts')
	creds = client.assume_role(RoleArn=role_arn,
								RoleSessionName=session_name,
								DurationSeconds=duration,
								SerialNumber=mfa_serial,
								TokenCode=mfa_token)

	config.set(target_account, 'aws_access_key_id', creds['Credentials']['AccessKeyId'])
	config.set(target_account, 'aws_secret_access_key', creds['Credentials']['SecretAccessKey'])
	config.set(target_account, 'aws_session_token', creds['Credentials']['SessionToken'])

	with open(cred_file, "w") as cred_config_file:
		config.write(cred_config_file)

	if platform.system() == 'Linux':
		print("export AWS_ACCESS_KEY_ID=%s;" % creds['Credentials']['AccessKeyId'])
		print("export AWS_SECRET_ACCESS_KEY=%s;" % creds['Credentials']['SecretAccessKey'])
		print("export AWS_SESSION_TOKEN=%s;" % creds['Credentials']['SessionToken'])
		print("export AWS_PROFILE=%s;" % target_account)
		print("export AWS_DEFAULT_REGION=%s;" % region)
	else:
		print("set AWS_ACCESS_KEY_ID=%s;" % creds['Credentials']['AccessKeyId'])
		print("set AWS_SECRET_ACCESS_KEY=%s;" % creds['Credentials']['SecretAccessKey'])
		print("set AWS_SESSION_TOKEN=%s;" % creds['Credentials']['SessionToken'])
		print("set AWS_PROFILE=%s;" % target_account)
		print("set AWS_DEFAULT_REGION=%s;" % region)

	