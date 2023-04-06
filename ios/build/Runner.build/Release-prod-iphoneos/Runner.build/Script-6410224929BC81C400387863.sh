#!/bin/sh
# Get a reference to the destination location for the GoogleService-Info.plist
# This is the default location where Firebase init code expects to find GoogleServices-Info.plist file.
PLIST_DESTINATION=${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app
# We have named our Build Configurations as Debug-dev, Debug-prod etc.
# Here, dev and prod are the scheme names. This kind of naming is required by Flutter for flavors to work.
# We are using the $CONFIGURATION variable available in the XCode build environment to get the build configuration.
if [ "${CONFIGURATION}" == "Debug-prod" ] || [ "${CONFIGURATION}" == "Release-prod" ] || [ "${CONFIGURATION}" == "Profile-prod" ] || [ "${CONFIGURATION}" == "Release" ]; then
cp "${PROJECT_DIR}/config/prod/GoogleService-Info.plist" "${PLIST_DESTINATION}/GoogleService-Info.plist"
echo "Production plist copied"
elif [ "${CONFIGURATION}" == "Debug-dev" ] || [ "${CONFIGURATION}" == "Release-dev" ] || [ "${CONFIGURATION}" == "Profile-dev" ] || [ "${CONFIGURATION}" == "Debug" ]; then
cp "${PROJECT_DIR}/config/dev/GoogleService-Info.plist" "${PLIST_DESTINATION}/GoogleService-Info.plist"
echo "Development plist copied"
fi

