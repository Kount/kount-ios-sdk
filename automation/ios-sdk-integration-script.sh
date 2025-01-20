
# Run "./automation/ios-sdk-integration-script.sh" from the root of this project, this script also runs the generation script to always use the latest changes.

# NOTES: The integration should be done at least once manually so XCODE could link and reference the library to the project. 

# Add the routes of the target proyects in the followings variables.
TARGET_UL_PROJECT_ROUTE=$UL_PROJECT_ROUTE
TARGET_XCFRAMEWORK_PROJECT_ROUTE=$XCFRAMEWORK_PROJECT_ROUTE
TARGET_SPM_PROJECT_ROUTE=$SPM_PROJECT_ROUTE
TARGET_COCOAPODS_PROJECT_ROUTE=$COCOAPODS_PROJECT_ROUTE

# ROUTES VARIABLES. NOTE: Here should be added the folder route where is located the UL or the XCFramework . 
NEW_XCFRAMEWORK_ROUTE=out/Build/Products/xcframeworks/KountDataCollector.xcframework
NEW_UL_ROUTE=out/Build/Products/Release-universal

/bin/bash ./automation/ios-sdk-generation-script.sh

SCRIPT_ROUTE=$(PWD)



echo "script route $SCRIPT_ROUTE"

# Prints a line.
printLine() {
    echo ""
    echo "=============================================================="
    echo ""
}

# Start Copying Libraries to UL Project.

printLine
echo "Start Copying Libraries to $TARGET_UL_PROJECT_ROUTE"

if [ -d "$NEW_UL_ROUTE" ]; then
    echo "$NEW_UL_ROUTE exists."

    cd $TARGET_UL_PROJECT_ROUTE
    find . -name KDataCollector.h -type f -delete
    find . -name KountAnalyticsViewController.h -type f -delete
    find . -name libKountDataCollector.a -type f -delete


    cp $NEW_UL_ROUTE/include/KountDataCollector/* $TARGET_UL_PROJECT_ROUTE/
    cp $NEW_UL_ROUTE/libKountDataCollector.a $TARGET_UL_PROJECT_ROUTE/

    echo "copied new Universal Library into $TARGET_UL_PROJECT_ROUTE"
    
    cd $SCRIPT_ROUTE
else
echo "$NEW_UL_ROUTE do not exists."
printLine
fi

# Start Copying XCFramework to XCFramework Project.

printLine
echo "Start Copying Libraries to $TARGET_XCFRAMEWORK_PROJECT_ROUTE"

if [ -d "$NEW_XCFRAMEWORK_ROUTE" ]; then
    echo "$NEW_XCFRAMEWORK_ROUTE exists."

    cd $TARGET_XCFRAMEWORK_PROJECT_ROUTE
    find . -name KDataCollector.h -type f -delete
    find . -name KountAnalyticsViewController.h -type f -delete
    find . -name libKountDataCollector.a -type f -delete
    rm Info.plist


    cp $NEW_XCFRAMEWORK_ROUTE/Info.plist $TARGET_XCFRAMEWORK_PROJECT_ROUTE/

    cp $NEW_XCFRAMEWORK_ROUTE/ios-arm64/Headers/* $TARGET_XCFRAMEWORK_PROJECT_ROUTE/ios-arm64/Headers/
    cp $NEW_XCFRAMEWORK_ROUTE/ios-arm64/libKountDataCollector.a $TARGET_XCFRAMEWORK_PROJECT_ROUTE/ios-arm64/

    cp $NEW_XCFRAMEWORK_ROUTE/ios-x86_64-simulator/Headers/* $TARGET_XCFRAMEWORK_PROJECT_ROUTE/ios-x86_64-simulator/Headers/
    cp $NEW_XCFRAMEWORK_ROUTE/ios-x86_64-simulator/libKountDataCollector.a $TARGET_XCFRAMEWORK_PROJECT_ROUTE/ios-x86_64-simulator/


    echo "copied XCFramework into $TARGET_XCFRAMEWORK_PROJECT_ROUTE"
    
    cd $SCRIPT_ROUTE
else
echo "$NEW_XCFRAMEWORK_ROUTE do not exists."
printLine
fi

# Start Copying XCFramework to SPM Project.

printLine
echo "Start Copying Libraries to $TARGET_SPM_PROJECT_ROUTE"

if [ -d "$NEW_XCFRAMEWORK_ROUTE" ]; then
    echo "$NEW_XCFRAMEWORK_ROUTE exists."

    cd $TARGET_SPM_PROJECT_ROUTE
    find . -name KDataCollector.h -type f -delete
    find . -name KountAnalyticsViewController.h -type f -delete
    find . -name libKountDataCollector.a -type f -delete
    rm Info.plist


    cp $NEW_XCFRAMEWORK_ROUTE/Info.plist $TARGET_SPM_PROJECT_ROUTE/

    cp $NEW_XCFRAMEWORK_ROUTE/ios-arm64/Headers/* $TARGET_SPM_PROJECT_ROUTE/ios-arm64/Headers/
    cp $NEW_XCFRAMEWORK_ROUTE/ios-arm64/libKountDataCollector.a $TARGET_SPM_PROJECT_ROUTE/ios-arm64/

    cp $NEW_XCFRAMEWORK_ROUTE/ios-x86_64-simulator/Headers/* $TARGET_SPM_PROJECT_ROUTE/ios-x86_64-simulator/Headers/
    cp $NEW_XCFRAMEWORK_ROUTE/ios-x86_64-simulator/libKountDataCollector.a $TARGET_SPM_PROJECT_ROUTE/ios-x86_64-simulator/


    echo "copied XCFramework into $TARGET_SPM_PROJECT_ROUTE"
    
    cd $SCRIPT_ROUTE
else
echo "$NEW_XCFRAMEWORK_ROUTE do not exists."
printLine
fi



# Start Copying XCFramework to Cocoapods.

printLine
echo "Start Copying Libraries to $TARGET_COCOAPODS_PROJECT_ROUTE"

if [ -d "$NEW_XCFRAMEWORK_ROUTE" ]; then
    echo "$NEW_XCFRAMEWORK_ROUTE exists."

    cd $TARGET_COCOAPODS_PROJECT_ROUTE
    find . -name KDataCollector.h -type f -delete
    find . -name KountAnalyticsViewController.h -type f -delete
    find . -name libKountDataCollector.a -type f -delete
    rm Info.plist


    cp $NEW_XCFRAMEWORK_ROUTE/Info.plist $TARGET_COCOAPODS_PROJECT_ROUTE/

    cp $NEW_XCFRAMEWORK_ROUTE/ios-arm64/Headers/* $TARGET_COCOAPODS_PROJECT_ROUTE/ios-arm64/Headers/
    cp $NEW_XCFRAMEWORK_ROUTE/ios-arm64/libKountDataCollector.a $TARGET_COCOAPODS_PROJECT_ROUTE/ios-arm64/

    cp $NEW_XCFRAMEWORK_ROUTE/ios-x86_64-simulator/Headers/* $TARGET_COCOAPODS_PROJECT_ROUTE/ios-x86_64-simulator/Headers/
    cp $NEW_XCFRAMEWORK_ROUTE/ios-x86_64-simulator/libKountDataCollector.a $TARGET_COCOAPODS_PROJECT_ROUTE/ios-x86_64-simulator/


    echo "copied XCFramework into $TARGET_COCOAPODS_PROJECT_ROUTE"
    
    cd $SCRIPT_ROUTE
else
echo "$NEW_XCFRAMEWORK_ROUTE do not exists."
printLine
fi
    








