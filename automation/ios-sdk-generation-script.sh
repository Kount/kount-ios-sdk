# In order to use this script should be executed in the root of the kount-ios-sdk-source
# Run ./automation/ios-sdk-generation-script.sh from the root of this project

BASEDIR=$(PWD)
ULDIR=out/Build/Products/Release-universal
XCFRAMEWORKDIR=out/Build/Products/xcframeworks/KountDataCollector.xcframework

printLine() {
    echo ""
    echo "=============================================================="
    echo ""
}


if [ -d "$ULDIR" ]; then
 echo "$ULDIR found"
 cd $ULDIR
 cd ..

 find . -name KDataCollector.h -type f -delete
 find . -name KountAnalyticsViewController.h -type f -delete
 find . -name libKountDataCollector.a -type f -delete
 
 cd $BASEDIR
else
echo "$ULDIR not found."
printLine
fi

if [ -d "$XCFRAMEWORKDIR" ]; then
    echo "$XCFRAMEWORKDIR found"
    cd $XCFRAMEWORKDIR
    cd ..

  
    find . -name KDataCollector.h -type f -delete
    find . -name KountAnalyticsViewController.h -type f -delete
    find . -name libKountDataCollector.a -type f -delete
    rm Info.plist
    
    cd $BASEDIR
else
echo "$XCFRAMEWORKDIR not found"
printLine
fi

# Universal Library Creation
xcodebuild build -project Library/KountDataCollector.xcodeproj -scheme UniversalLibrary -derivedDataPath out

# XCframework Creation
xcodebuild build -scheme KountDataCollector -derivedDataPath out/builds/simulator -arch x86_64 -arch arm64 -sdk iphonesimulator SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

xcodebuild build -scheme KountDataCollector -derivedDataPath out/builds/iphone -arch arm64 -sdk iphoneos SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

xcodebuild -create-xcframework -library out/builds/iphone/Build/Products/Debug-iphoneos/libKountDataCollector.a -headers out/builds/iphone/Build/Products/Debug-iphoneos/include/KountDataCollector -library out/builds/simulator/Build/Products/Debug-iphonesimulator/libKountDataCollector.a -headers out/builds/simulator/Build/Products/Debug-iphonesimulator/include/KountDataCollector -output out/builds/xcframeworks/KountDataCollector.xcframework

# Copy PrivacyInfo.xcprivacy
cp Library/KountDataCollector/PrivacyInfo.xcprivacy out/builds/xcframeworks/KountDataCollector.xcframework/ios-arm64/

cp Library/KountDataCollector/PrivacyInfo.xcprivacy out/builds/xcframeworks/KountDataCollector.xcframework/ios-arm64_x86_64-simulator/

# Create folders for XCFrameworks
mkdir out/builds/xcframeworks/XC-SPM
mkdir out/builds/xcframeworks/Cocoapods
mkdir out/builds/UniversalLibrary

# Copy original XCframework into different integrations XCFrameworks
cp -r out/builds/xcframeworks/KountDataCollector.xcframework out/builds/xcframeworks/Cocoapods
cp -r out/builds/xcframeworks/KountDataCollector.xcframework out/builds/xcframeworks/XC-SPM
cp -r out/Build/Products/Release-universal out/builds/UniversalLibrary

# Delete XcFramework in root folder
rm -r out/builds/xcframeworks/KountDataCollector.xcframework

# Copying module.modulemap into Cocoapod XCframework root path
cp out/builds/xcframeworks/Cocoapods/KountDataCollector.xcframework/ios-arm64/Headers/module.modulemap out/builds/xcframeworks/Cocoapods/KountDataCollector.xcframework

# Delete module.modulemap for each arch
rm out/builds/xcframeworks/Cocoapods/KountDataCollector.xcframework/ios-arm64/Headers/module.modulemap
rm out/builds/xcframeworks/Cocoapods/KountDataCollector.xcframework/ios-arm64_x86_64-simulator/Headers/module.modulemap

# Updating Route of module.modulemap in root of Cocoapods XCFramework
sed -i '' -e 's/umbrella header "KountUmbrella.h"/umbrella header "ios-arm64_x86_64-simulator\/Headers\/KountUmbrella.h"/' out/builds/xcframeworks/Cocoapods/KountDataCollector.xcframework/module.modulemap

# XCframework signing
export developer_id='2D058C230CF725676548571A607CC5C133089F14'
codesign --timestamp -v --sign $developer_id out/builds/xcframeworks/XC-SPM/KountDataCollector.xcframework
codesign --timestamp -v --sign $developer_id out/builds/xcframeworks/Cocoapods/KountDataCollector.xcframework
export developer_id=""

# Build .zip files

cd ${BASEDIR}/out/builds/xcframeworks/Cocoapods/
zip -r ${BASEDIR}/out/Cocoapod-KountDataCollector.xcframework.zip -- *

cd ${BASEDIR}/out/builds/xcframeworks/XC-SPM/
zip -r ${BASEDIR}/out/XC-SPM-KountDataCollector.xcframework.zip -- *

cd ${BASEDIR}/out/builds/UniversalLibrary
zip -r ${BASEDIR}/out/Release-universal.zip -- *

# Local upload to nexus -- DO NOT RUN on the GitLab macOS runner
# export NEXUS_TOKEN=$(security find-generic-password -s 'NEXUS_TOKEN' -w | base64 --decode)
# curl -v -u $NEXUS_TOKEN --upload-file out/Release-universal.zip https://nrm.us.equifax.com/repository/cs-mobile-tribe-kdm-raw-release-raw-hosted/ios/UniversalLibrary/Release-universal.zip
# curl -v -u $NEXUS_TOKEN --upload-file out/Cocoapod-KountDataCollector.xcframework.zip https://nrm.us.equifax.com/repository/cs-mobile-tribe-kdm-raw-release-raw-hosted/ios/xcframework/Cocoapods/Cocoapod-KountDataCollector.xcframework.zip
# curl -v -u $NEXUS_TOKEN --upload-file out/XC-SPM-KountDataCollector.xcframework.zip https://nrm.us.equifax.com/repository/cs-mobile-tribe-kdm-raw-release-raw-hosted/ios/xcframework/XC-SPM/XC-SPM-KountDataCollector.xcframework.zip