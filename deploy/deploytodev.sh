####################################################################################################
# CONFIGURATION:
#
# CLIENT_ID is updated on sandbox refreshed. It must match the connected app in the target ORG
  export CLIENT_ID="3MVG9pRzvMkjMb6lVklCoDEZMvQlWttmINWWEZvi.tOwtGKk3PPVFp8YdFfL0bauRYUuHbhHcSOxXjTXE.NFp"
#
# UserName must match the deployment user for the target ORG and must be associated with a
# profile or permission set which has access to the connected app specified above
  export CI_USERNAME="mvsalespocdev@mindzcloud.com"
#
# INSTANCE_URL should be login for prod or test for sandbox
  export INSTANCE_URL="https://login.salesforce.com"
#

  export PATH_TO_SOURCE="../$WORKSPACE_DIR"
  export WORKSPACE_DIR=`pwd`
  export JWT_KEY="$WORKSPACE_DIR/server.key"

echo "-------------------------------------------------------------------------"
echo "SFDX CLI "
echo "---"

echo "Installed SFDC CLI Version:"
sfdx --version
echo "done"

echo "-------------------------------------------------------------------------"
echo "Authorizing CI User                                                      "
echo "-------------------------------------------------------------------------"


#
# Supporting SFDC documentation
# https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_auth_jwt_flow.htm
#

sfdx force:auth:jwt:grant --clientid $CLIENT_ID \
--jwtkeyfile $JWT_KEY --username $CI_USERNAME \
--instanceurl $INSTANCE_URL

echo "done"

echo "-------------------------------------------------------------------------"
echo "Convert DX Source to Metadata API format                                 "
echo "-------------------------------------------------------------------------"

# Supporting documentation:
# https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta

export METADATA_API_DIR="mdapi_output_dir"
cd $PATH_TO_SOURCE
echo "Current dir:" `pwd`
sfdx force:source:convert -d $METADATA_API_DIR
echo "Metadata directory generated contents:"
ls -lR $METADATA_API_DIR
echo "done"


echo "-------------------------------------------------------------------------"
echo "Deploy                                                                   "
echo "-------------------------------------------------------------------------"

# Supporting documentation:
# https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta
#
export WAIT_TIME_MINS=180

SFDX_DISABLE_INSIGHTS=true \
sfdx force:mdapi:deploy --deploydir $METADATA_API_DIR \
--targetusername $CI_USERNAME \
--wait $WAIT_TIME_MINS \
--soapdeploy