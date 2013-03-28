There is a readme.txt file in each toolXXX dir.

these tools can support to add a new package from raw package to code project with proper configuation.

When ui designer added a package to ui/icons/ dir, we need to:
    1, find if the package contains too long icon file names and generate tooLongFiles.plist in the package with toolForRawPackage.
        copy the tooLongFiles.plist to ui/icons/thePackage and commit the file to git.
    2, copy ui/icons/thePackage to a temp dir, 
        use toolmacForRawPackage to split the icons into groups with every group containing 10 icons.
        remove those file which are not in any group.
    3, copy tempDir/thePackage to iphone/trunk/QuizGame/Resouces/quizicons/ , 
        use toolmacForPackage to generate packages-groups config template (packagesConfigTemplate.plist) which file path can be seen in log.
    4, use the packagesConfigTemplate.plist file to update iphone/trunk/QuizGame/Resouces/quizicons/packageConfig.plist,
        and necessary manual work will be done.
    5, when release the app to simulator or device, usually need to uninstall the app and execute product->clean in xcode.

git related commands:

git rm -r "Apparel and shoes" Automotive Countries Electronics "Food and drink" "Fortune 500" "Health and beauty" "Sports club"

git add "Apparel and shoes" Automotive Countries Electronics "Food and drink" "Fortune 500" "Health and beauty" "Sports club"













